%% Hybrid Traditional + AI Pipeline (Segmentation -> CNN Classification)
% Reproducible, self-contained demo with peppers.png
close all; clear; clc; rng(0);

% ---------------------------------------------------
% Section 1: Load Image and AI Network (AI component)
% ---------------------------------------------------
I = imread('peppers.png');  % sample RGB
fprintf('Loading pre-trained AI network (SqueezeNet)...\n');
try
    net = squeezenet;       % Deep Learning Toolbox Model for SqueezeNet support package
catch
    error(['SqueezeNet not found. In MATLAB: Home > Add-Ons > Get Add-Ons > ', ...
           'search "Deep Learning Toolbox Model for SqueezeNet Network".']);
end
inputSize = net.Layers(1).InputSize(1:2);

figure('Name','Hybrid Pipeline','Color','w','Position',[100 100 1200 700]);
tiledlayout(2,3,'TileSpacing','compact','Padding','compact');
nexttile; imshow(I); title('Original Image');

% ---------------------------------------------------
% Section 2: Traditional Method (Pre-process & Segment)
% Role: isolate the main object to simplify the AI’s job
% ---------------------------------------------------
fprintf('Applying traditional color segmentation (K-means in L*a*b*)...\n');
lab = rgb2lab(I);
ab = im2single(lab(:,:,2:3));                 % a*, b* only
nColors = 3;                                  % a bit safer than 2 for busy images
pixelLabels = imsegkmeans(ab, nColors, 'NumAttempts', 3);

% Heuristic: choose the cluster with the highest mean chroma (||[a b]||),
% which often corresponds to the colorful foreground object.
chroma = vecnorm(reshape(ab,[],2),2,2);
C = zeros(nColors,1);
for k = 1:nColors
    C(k) = mean(chroma(pixelLabels(:)==k));
end
[~,foregroundCluster] = max(C);
mask = pixelLabels == foregroundCluster;

% Morphological cleanup: fill holes, remove specks, keep largest component
mask = imfill(mask, 'holes');
mask = bwareaopen(mask, 500);                 % drop tiny blobs
mask = imclose(mask, strel('disk', 5));

% Keep largest connected component for a clean object mask
cc = bwconncomp(mask);
if cc.NumObjects > 1
    stats = regionprops(cc,'Area');
    [~,idx] = max([stats.Area]);
    keep = false(size(mask));
    keep(cc.PixelIdxList{idx}) = true;
    mask = keep;
end

% Optional: crop to object bounding box for tighter framing
stats = regionprops(mask, 'BoundingBox');
if ~isempty(stats)
    bb = round(stats(1).BoundingBox);
else
    bb = [1 1 size(I,2) size(I,1)];
end

% Build isolated object view (background → black)
Iso = I;
Iso(repmat(~mask,1,1,3)) = 0;

% Cropped region (better focus for CNN)
x = max(1,bb(1)); y = max(1,bb(2));
w = min(bb(3), size(I,2)-x+1); h = min(bb(4), size(I,1)-y+1);
Ic = imcrop(Iso, [x y w-1 h-1]);   % -1 so width/height count pixels

nexttile; imshow(mask); title('Traditional Mask (K-means + cleanup)');
nexttile; imshow(Iso); title('Isolated Object (background suppressed)');

% ---------------------------------------------------
% Section 3: AI Method (Image Classification)
% Compare: (A) Raw original vs (B) Hybrid (segmented/cropped)
% ---------------------------------------------------
Ir = imresize(I,  inputSize);
Ih = imresize(Ic, inputSize);

fprintf('Running AI classification...\n');
[lab_raw,  probs_raw]  = classify(net, Ir);
[lab_hyb,  probs_hyb]  = classify(net, Ih);

% Gather top-5 for both runs
[probs_raw_sorted, idx_raw] = maxk(probs_raw,5);
[probs_hyb_sorted, idx_hyb] = maxk(probs_hyb,5);
classes = net.Layers(end).Classes;

top5_raw = string(classes(idx_raw));
top5_hyb = string(classes(idx_hyb));

% ---------------------------------------------------
% Section 4: Results & Analysis
% ---------------------------------------------------
nexttile; imshow(Ir); title(sprintf('AI alone\nPred: %s (%.1f%%)', string(lab_raw), 100*max(probs_raw)));
nexttile; imshow(Ih); title(sprintf('Hybrid (seg->AI)\nPred: %s (%.1f%%)', string(lab_hyb), 100*max(probs_hyb)));

% Top-5 bar plots (raw vs hybrid)
nexttile; barh(flip(probs_raw_sorted)); xlim([0 1]);
yticks(1:5); yticklabels(flip(top5_raw));
xlabel('Probability'); title('AI alone: Top-5');

% Start a new figure row for hybrid top-5 (so labels aren’t cramped)
figure('Name','Top-5 Probabilities','Color','w','Position',[200 200 600 400]);
barh(flip(probs_hyb_sorted)); xlim([0 1]);
yticks(1:5); yticklabels(flip(top5_hyb));
xlabel('Probability'); title('Hybrid (seg->AI): Top-5');

% Print summary to console
fprintf('\n--- Hybrid Pipeline Results ---\n');
fprintf('AI alone       : %-20s | Conf: %.2f%%\n', string(lab_raw), 100*max(probs_raw));
fprintf('Hybrid (seg->AI): %-20s | Conf: %.2f%%\n', string(lab_hyb), 100*max(probs_hyb));
fprintf('Confidence delta (Hybrid - Raw): %+0.2f%%\n', 100*(max(probs_hyb)-max(probs_raw)));

% Save outputs for your GitHub
try
    exportgraphics(gcf,'top5_hybrid.png','Resolution',200);
catch, saveas(gcf,'top5_hybrid.png'); end

set(0,'CurrentFigure',findobj('Type','figure','Name','Hybrid Pipeline'));
try
    exportgraphics(gcf,'hybrid_pipeline.png','Resolution',200);
catch, saveas(gcf,'hybrid_pipeline.png'); end

% Save a CSV comparing labels and confidences
Method   = ["AI_alone"; "Hybrid_seg_AI"];
Label    = [string(lab_raw); string(lab_hyb)];
Confidence = [max(probs_raw); max(probs_hyb)];
T = table(Method, Label, Confidence);
writetable(T,'classification_comparison.csv');

% --- Notes for the write-up (copy/paste bullets) ---
% - Traditional pre-processing (color segmentation + cleanup + crop) removed clutter.
% - The CNN saw a tighter, background-free object region, usually increasing confidence.
% - Report whether the predicted label changed and by how much the confidence improved.

