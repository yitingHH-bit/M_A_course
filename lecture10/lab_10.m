% tire_stud_detector.m
% Simple studded-tire detector using preprocessing + connected components

clear; clc; close all;

% Use the correct filenames for your images:
% If your file is studded_tire.jpg, change .jpeg to .jpg below.
imageFiles = {'studded_tire.jpeg', 'summer_tire.jpg'};

for i = 1:numel(imageFiles)

    % ---------- 1) Read & resize ----------
    I = imread(imageFiles{i});
    I = imresize(I, 0.5);   % optional scaling

    % ---------- 2) Convert to grayscale ----------
    if size(I, 3) == 3
        Igray = rgb2gray(I);
    else
        Igray = I;
    end
    Igray = im2double(Igray);  % work in [0,1]

    % ---------- 3) Create tire mask ----------
    % Tire is dark against a bright background.
    % Use Otsu threshold to separate dark tire from background.
    level = graythresh(Igray);
    tireMask = Igray < level;          % dark regions

    % Clean tire mask: fill holes, remove small blobs, smooth edges
    tireMask = imfill(tireMask, 'holes');
    tireMask = bwareaopen(tireMask, 500);      % remove tiny regions
    seTire = strel('disk', 5);
    tireMask = imopen(tireMask, seTire);
    tireMask = imclose(tireMask, seTire);

    tireArea = nnz(tireMask);   % number of pixels in tire

    % ---------- 4) Candidate studs ----------
    % Studs are bright points inside the dark tire.
    % We can use local statistics on the tire region to pick a threshold.
    Iblur = imgaussfilt(Igray, 1);   % small blur to reduce noise

    tirePixels = Iblur(tireMask);
    mu = mean(tirePixels);
    sigma = std(tirePixels);

    % Bright threshold slightly above average tire brightness
    BRIGHT_THRESHOLD = mu + 0.8 * sigma;

    cand = (Iblur > BRIGHT_THRESHOLD) & tireMask;

    % Clean candidate mask: remove tiny noise and smooth
    cand = bwareaopen(cand, 3);      % remove very small dots
    seStud = strel('disk', 1);
    cand = imclose(cand, seStud);    % fill small gaps

    % ---------- 5) Connected components ----------
    CC = bwconncomp(cand);
    stats = regionprops(CC, 'Area', 'Perimeter', 'Eccentricity');

    % ---------- 6) Filter candidates ----------
    studMask  = false(size(cand));
    studCount = 0;

    % Reasonable limits (tune if needed for your images)
    minA   = 4;      % min area of a stud
    maxA   = 120;    % max area of a stud
    minCirc = 0.6;   % minimum circularity
    maxEcc  = 0.85;  % maximum eccentricity (round-ish)

    for k = 1:numel(stats)
        A   = stats(k).Area;
        P   = stats(k).Perimeter;
        ecc = stats(k).Eccentricity;

        if P == 0
            continue;
        end

        % Circularity: 4*pi*Area / Perimeter^2  (1 = perfect circle)
        circ = 4 * pi * A / (P^2);

        if A >= minA && A <= maxA && ...
           circ >= minCirc && ...
           ecc <= maxEcc

            % Mark these pixels as a valid stud
            studMask(CC.PixelIdxList{k}) = true;
            studCount = studCount + 1;
        end
    end

    % ---------- 7) Decision rule ----------
    % Simple rule: many studs => studded tire.
    % You can adjust this threshold based on your images.
    studDensity = studCount / max(tireArea, 1);
    isStudded = (studCount > 20) || (studDensity > 0.0005);

    % ---------- 8) Visualization ----------
    figure;
    subplot(1,3,1);
    imshow(I);
    title(sprintf('Input: %s', imageFiles{i}), 'Interpreter','none');

    subplot(1,3,2);
    imshow(cand);
    title('Candidate studs (binary)');

    subplot(1,3,3);
    imshow(I); hold on;
    visboundaries(studMask, 'LineWidth', 0.7, 'Color', 'r');

    if isStudded
        title(sprintf('STUDDED TIRE (studs: %d)', studCount));
    else
        title(sprintf('NON-STUDDED TIRE (studs: %d)', studCount));
    end

end
