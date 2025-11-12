function tire_stud_detector
% tire_stud_detector.m
% Detects metal studs on tire images using preprocessing + connected components.
% Usage:
%   Place this file alongside: studded_tire.jpg, summer_tire.jpg
%   Run: tire_stud_detector

clear; clc; close all;

imageFiles = {'studded_tire.jpeg', 'summer_tire.jpg'};

% -------- Tunable parameters (adjust if needed) --------
scaleFactor   = 0.5;      % image resize factor for speed
gaussSigma    = 0.8;      % Gaussian blur for de-noising bright spots
minA          = 4;        % min stud area (px)
maxA          = 120;      % max stud area (px)
minCirc       = 0.60;     % min circularity (4*pi*A/P^2)
maxEcc        = 0.85;     % max eccentricity (roundness)
studCountCut  = 12;       % fallback threshold if density is ambiguous
densityCut    = 1.2e-4;   % studs per pixel^2 in tire area (tweak per dataset)

for i = 1:numel(imageFiles)
    % ---------- 1) Read & resize ----------
    I = imread(imageFiles{i});
    if scaleFactor ~= 1
        I = imresize(I, scaleFactor);
    end

    % ---------- 2) Convert to grayscale ----------
    if ndims(I) == 3
        Igray = rgb2gray(I);
    else
        Igray = I;
    end
    Igray = im2uint8(Igray);

    % Optional contrast stretching helps a lot with uneven lighting
    Ieq = imadjust(Igray);

    % ---------- 3) Create tire mask (tire darker than background) ----------
    % Use Otsu on the *inverted* image to bias toward selecting the dark tire.
    invImg = imcomplement(Ieq);
    tDark  = graythresh(invImg);                     % [0,1] threshold
    tireMask = imbinarize(invImg, tDark);            % tire ~1, background ~0
    
    % Clean up: fill holes, open/close, remove small specks
    tireMask = imfill(tireMask, 'holes');
    tireMask = imopen(tireMask, strel('disk', 5));
    tireMask = imclose(tireMask, strel('disk', 7));
    tireMask = bwareaopen(tireMask, 500);            % remove tiny regions

    % ---------- 4) Candidate studs (bright points inside tire) ----------
    % Light smoothing to suppress grain noise before thresholding
    Iblur = imgaussfilt(Ieq, gaussSigma);

    % Use adaptive threshold focused on bright dots; combine with tire mask
    % Mix global & local strategies for robustness.
    Tglob = graythresh(Iblur);                       % Otsu
    candG = Iblur > uint8(Tglob * 255);

    Tlocal = adaptthresh(Iblur, 0.55, 'NeighborhoodSize', 41, 'Statistic','gaussian');
    candL  = imbinarize(Iblur, Tlocal);

    cand = (candG | candL) & tireMask;

    % Cleanup candidates: remove tiny specks, close small gaps
    cand = bwareaopen(cand, 3);
    cand = imopen(cand, strel('disk', 1));
    cand = imclose(cand, strel('disk', 2));
    cand = imfill(cand, 'holes');

    % ---------- 5) Connected components ----------
    CC = bwconncomp(cand);
    stats = regionprops(CC, 'Area', 'Perimeter', 'Eccentricity', 'Centroid', 'BoundingBox');

    % ---------- 6) Filter candidates ----------
    studMask = false(size(cand));
    studCount = 0;

    for k = 1:numel(stats)
        A = stats(k).Area;
        P = stats(k).Perimeter;
        E = stats(k).Eccentricity;

        if P <= 0
            continue; % avoid div-by-zero
        end

        circ = (4*pi*A)/(P^2); % circularity in [0,1]; 1 is a perfect circle

        if A >= minA && A <= maxA && circ >= minCirc && E <= maxEcc
            % accept as stud
            pix = false(size(cand));
            pix(CC.PixelIdxList{k}) = true;
            studMask = studMask | pix;
            studCount = studCount + 1;
        end
    end

    % ---------- 7) Decision rule ----------
    tireArea = nnz(tireMask);
    density  = studCount / max(tireArea,1); % avoid div-by-zero
    isStudded = (studCount >= studCountCut) | (density >= densityCut);

    % ---------- 8) Visualization ----------
    figure('Color','w');
    subplot(1,3,1);
    imshow(I); title(sprintf('Input: %s', imageFiles{i}), 'Interpreter','none');

    subplot(1,3,2);
    imshow(cand); title('Candidate studs (binary)');

    subplot(1,3,3);
    imshow(I); hold on;
    visboundaries(studMask, 'Color',[0.85 0 0], 'LineWidth', 0.7);
    if isStudded
        ttl = sprintf('STUDDED TIRE  | studs: %d  | density: %.2e', studCount, density);
    else
        ttl = sprintf('NON-STUDDED TIRE  | studs: %d  | density: %.2e', studCount, density);
    end
    title(ttl);

    % Console summary
    fprintf('\nImage: %s\n', imageFiles{i});
    fprintf('  Tire area (px): %d\n', tireArea);
    fprintf('  Studs detected: %d\n', studCount);
    fprintf('  Density: %.3e\n', density);
    fprintf('  Classification: %s\n', tern(isStudded,'STUDDED','NON-STUDDED'));
end
end

% tiny helper
function s = tern(cond, a, b)
if cond, s = a; else, s = b; end
end
