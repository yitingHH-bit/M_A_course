%% Hybrid Traditional + AI Pipeline
% Learning outcomes covered:
% - Hybrid pipeline: traditional segmentation + AI classifier
% - Traditional preprocessing (color segmentation, morphology)
% - Pre-trained CNN classification (SqueezeNet)
% - Quantitative & qualitative comparison w/ and w/o preprocessing
%
% Outputs saved for GitHub:
%   - hybrid_pipeline_overview.png
%   - hybrid_gradcam.png (optional, if gradCAM available)
%   - hybrid_predictions.csv
%   - isolated_object.png
%
% Requirements:
%   - Image Processing Toolbox
%   - Deep Learning Toolbox
%   - Pretrained models support (for squeezenet), e.g. Deep Learning Toolbox Model for SqueezeNet Network

close all; clear; clc;

%% -------------------------------
%  Section 1: Load image & network
%  -------------------------------
fprintf('Loading image and pre-trained network...\n');

% Use the classic peppers image (ships with MATLAB)
I = imread('peppers.png');                      % RGB
origRGB = I;

% Load SqueezeNet (small, fast)
net = squeezenet;

% Network input size
inSize = net.Layers(1).InputSize(1:2);          % [H W]
fprintf('Network input size: %dx%d\n', inSize(1), inSize(2));

%% -------------------------------------------------------
%  Section 2: Traditional preprocessing (color segmentation)
%  -------------------------------------------------------
fprintf('Applying traditional color segmentation (k-means in L*a*b*)...\n');

% Convert to L*a*b* and cluster in ab-channels (color)
lab = rgb2lab(origRGB);
ab  = im2single(lab(:,:,2:3));
nColors = 3;                                    % 2–4 often works; 3 is robust for this image
pixelLabels = imsegkmeans(ab, nColors, 'NumAttempts', 3);

% Decide which cluster is "object":
% Heuristic: choose the cluster with the highest mean L* (brighter than background)
L = lab(:,:,1);
meansL = zeros(nColors,1);
for k = 1:nColors
    meansL(k) = mean(L(pixelLabels==k));
end
[~, objCluster] = max(meansL);
mask = (pixelLabels == objCluster);

% Morphological cleanup (remove speckles, fill holes, smooth edges)
mask = imfill(mask, 'holes');
mask = bwareaopen(mask, 500);                    % drop tiny blobs
se = strel('disk', 5);
mask = imopen(mask, se);
mask = imclose(mask, se);

% Isolate object
isolatedRGB = origRGB;
isolatedRGB(repmat(~mask,1,1,3)) = 0;

% Save isolated object image for GitHub
imwrite(isolatedRGB, 'isolated_object.png');

%% -------------------------------------------------------
%  Section 3: AI Method (classify with & without preprocessing)
%  -------------------------------------------------------
fprintf('Running AI classification...\n');

% Prepare two inputs:
% (A) Raw original
imgRaw = imresize(origRGB, inSize);

% (B) Preprocessed (segmented/isolated)
imgIso = imresize(isolatedRGB, inSize);

% Classify both
[YPredRaw, probsRaw] = classify(net, imgRaw);
[YPredIso, probsIso] = classify(net, imgIso);

% Extract top-5 for readability
[topProbsRaw, idxRaw] = maxk(probsRaw, 5);
[topClassesRaw]       = net.Layers(end).Classes(idxRaw);

[topProbsIso, idxIso] = maxk(probsIso, 5);
[topClassesIso]       = net.Layers(end).Classes(idxIso);

%% --------------------------------------
%  Section 4: Results & visualization
%  --------------------------------------
% Overview figure: Original, Mask, Isolated, Both CNN inputs side-by-side
f1 = figure('Name','Hybrid Pipeline Overview','Color','w','Position',[100 100 1300 650]);
t = tiledlayout(2,3,'TileSpacing','compact','Padding','compact');

nexttile; imshow(origRGB);      title('Original Image');
nexttile; imshow(mask);         title('Traditional Mask (k-means + morphology)');
nexttile; imshow(isolatedRGB);  title('Isolated Object (Traditional Output)');

nexttile; imshow(imgRaw);       title({'CNN Input: Raw', ...
    sprintf('Top-1: %s (%.1f%%)', string(YPredRaw), 100*max(probsRaw))});

nexttile; imshow(imgIso);       title({'CNN Input: Isolated', ...
    sprintf('Top-1: %s (%.1f%%)', string(YPredIso), 100*max(probsIso))});

% Simple comparison textbox
nexttile;
axis off;
text(0,1, sprintf('Hybrid vs AI-only (Top-1 confidence):\nRaw: %.2f%% -> %s\nIso: %.2f%% -> %s', ...
    100*max(probsRaw), string(YPredRaw), 100*max(probsIso), string(YPredIso)), ...
    'FontSize',12, 'VerticalAlignment','top');

exportgraphics(f1,'hybrid_pipeline_overview.png','Resolution',200);

% Optional: Grad-CAM heatmaps (if available)
gradOK = exist('gradCAM','file')==2 || exist('gradCAM','builtin')==5;
if gradOK
    try
        fprintf('Generating Grad-CAM heatmaps...\n');
        % For SqueezeNet, last learnable layer name can be used automatically by gradCAM
        camRaw = gradCAM(net, imgRaw, YPredRaw);
        camIso = gradCAM(net, imgIso, YPredIso);

        f2 = figure('Name','Grad-CAM Comparison','Color','w','Position',[150 150 1100 500]);
        t2 = tiledlayout(1,4,'TileSpacing','compact','Padding','compact');

        nexttile; imshow(imgRaw); title({'Raw Input','(AI-only)'});
        nexttile; imshow(camRaw,[]); title({'Grad-CAM','Raw'});
        nexttile; imshow(imgIso); title({'Isolated Input','(Hybrid)'});
        nexttile; imshow(camIso,[]); title({'Grad-CAM','Isolated'});

        exportgraphics(f2,'hybrid_gradcam.png','Resolution',200);
    catch
        warning('Grad-CAM failed; continuing without heatmaps.');
    end
else
    fprintf('gradCAM not available; skipping heatmaps.\n');
end

%% --------------------------------------
%  Section 5: Save a CSV with predictions
%  --------------------------------------
labelsRaw = string(topClassesRaw);
labelsIso = string(topClassesIso);

% Pad to same length (5)
maxkVal = 5;
labelsRawStr = strings(1,maxkVal); labelsRawStr(1:numel(labelsRaw)) = labelsRaw(:);
labelsIsoStr = strings(1,maxkVal); labelsIsoStr(1:numel(labelsIso)) = labelsIso(:);

topProbsRaw = double(topProbsRaw(:));
topProbsIso = double(topProbsIso(:));
if numel(topProbsRaw) < maxkVal, topProbsRaw(end+1:maxkVal) = NaN; end
if numel(topProbsIso) < maxkVal, topProbsIso(end+1:maxkVal) = NaN; end

T = table( ...
    string(YPredRaw), 100*max(probsRaw), labelsRawStr(:), 100*topProbsRaw(:), ...
    string(YPredIso), 100*max(probsIso), labelsIsoStr(:), 100*topProbsIso(:), ...
    'VariableNames', { ...
        'Top1_Raw_Label','Top1_Raw_Confidence_pct','TopK_Raw_Labels','TopK_Raw_Confidences_pct', ...
        'Top1_Iso_Label','Top1_Iso_Confidence_pct','TopK_Iso_Labels','TopK_Iso_Confidences_pct' ...
    } ...
);

writetable(T, 'hybrid_predictions.csv');

%% --------------------------------------
%  Section 6: Console summary (copy to README)
%  --------------------------------------
fprintf('\n--- Hybrid Pipeline Results ---\n');
fprintf('AI-only (Raw)     -> Top-1: %-20s | Confidence: %6.2f%%\n', string(YPredRaw), 100*max(probsRaw));
fprintf('Hybrid (Isolated) -> Top-1: %-20s | Confidence: %6.2f%%\n', string(YPredIso),  100*max(probsIso));
fprintf('Saved: hybrid_pipeline_overview.png, isolated_object.png, hybrid_predictions.csv\n');
if gradOK
    fprintf('Saved: hybrid_gradcam.png (if gradCAM succeeded)\n');
end

% Notes:
% - With a clean mask, the classifier often gains confidence or even changes
%   to a more reasonable class, as background distractors are removed.
% - You can tweak nColors or morphology sizes if the mask looks under/over-segmented.
