%% Lab 1: Image as a 2D Signal (Sampling, Quantization, Histograms, Enhancement)
%
% -------------------------------------------------------------------------
% Notes:
% - If 'peppers.png' is not available, use 'cameraman.tif' or another image.
% - Quantization ↔ bit-depth, Dynamic range ↔ contrast, Sampling ↔ resize.
% - Gamma correction is nonlinear; contrast stretching is linear.
% -------------------------------------------------------------------------
% HOW TO SUBMIT: include screenshots and short explanations in your GitHub repo.
% Submit only the GitHub URL.
close all; clear; clc;

%% 0) Load and inspect an image
if exist('peppers.png','file')
    I_rgb = imread('peppers.png');
else
    I_rgb = repmat(imread('cameraman.tif'), 1, 1, 3); % fallback to grayscale image replicated
end

figure; imshow(I_rgb); title('Original RGB');

% Convert to grayscale
if size(I_rgb,3)==3
    I = rgb2gray(I_rgb);
else
    I = I_rgb;
end

figure; imshow(I); title('Grayscale');

% Basic info
fprintf('Class: %s | Range: [%g, %g] | Size: %d x %d\n', ...
    class(I), double(min(I(:))), double(max(I(:))), size(I,1), size(I,2));

%% 1) Quantization and dynamic range
I8 = I; % 8-bit (0–255)
I6 = uint8(floor(double(I)/4)*4);   % ~6 bits (step 4)
I4 = uint8(floor(double(I)/16)*16); % ~4 bits (step 16)

figure; montage({I8,I6,I4},'Size',[1 3]);
title('Quantization: 8-bit vs ~6-bit vs ~4-bit');

fprintf('Quantization done. Range: [%g, %g]\n', double(min(I(:))), double(max(I(:))));

%% (Added by jiancai) Convert to black and white
IBW = imbinarize(I);  % Convert grayscale to binary (black & white)
figure; imshow(IBW); title('Black & White');

%% 2) Histogram and contrast stretching
figure;
subplot(1,2,1); imhist(I); title('Histogram (original)');

I_norm = mat2gray(I); % Normalize to [0,1]
I_stretch = imadjust(I,[0.2 0.8],[0 1]); % Contrast stretch mid-range

subplot(1,2,2); imhist(I_stretch); title('Histogram (stretched)');

figure; montage({I, im2uint8(I_norm), im2uint8(I_stretch)},'Size',[1 3]);
title('Original | Normalized | Contrast-stretched');

%% 3) Gamma correction (nonlinear scaling)
I_gamma_low = imadjust(I,[],[],0.6);  % gamma < 1 → brightens
I_gamma_high = imadjust(I,[],[],1.6); % gamma > 1 → darkens

figure; montage({I, I_gamma_low, I_gamma_high},'Size',[1 3]);
title('Gamma: original | gamma=0.6 | gamma=1.6');

%% 4) Sampling and aliasing (downsample then upsample)
scale = 0.1; % 10% of size
I_small = imresize(I, scale, 'nearest'); % aggressive downsample
I_back = imresize(I_small, size(I), 'nearest'); % upscale back

figure; montage({I, I_small, I_back}, 'Size', [1 3]);
title('Original | Downsampled | Upscaled (aliasing artifacts)');

%% 5) OPTIONAL: Moiré demo
% Try with striped or patterned images to observe moiré patterns.

%% 6) Reflection questions (for your report)
% 1) How does bit-depth reduction cause visible banding/posterization?
% 2) How does contrast stretching change histogram & detail visibility?
% 3) Why does aggressive downsampling cause aliasing? (Nyquist criterion)
