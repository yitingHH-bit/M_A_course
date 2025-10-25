load("/MATLAB Drive/matlab.mat")
%% Lab 1: Image as a 2D Signal (Sampling, Quantization, Histograms, Enhancement)
%
% -------------------------------------------------------------------------
% Author: [Your Name]
% Course: [Your Course Code or Lab Section]
% Date: [Today's Date]
%
% File Name: lab1_image_processing.m
%
% -------------------------------------------------------------------------
% Quick Notes:
% - If 'peppers.png' is not available, uses 'cameraman.tif' as fallback.
% - Concepts demonstrated:
%       * Quantization  -> bit-depth and visible banding
%       * Dynamic range -> contrast and histogram spread
%       * Gamma         -> nonlinear brightness scaling
%       * Sampling      -> down/upsampling and aliasing
% - Gamma is nonlinear; contrast stretching is linear remapping.
%
% -------------------------------------------------------------------------
% SUBMISSION INSTRUCTIONS:
% Include screenshots and short written explanations for each section
% (figures + brief comments) in your GitHub repo. Submit only the GitHub URL.
% -------------------------------------------------------------------------
close all; clear; clc;

%% 0) Load and inspect an image
if exist('peppers.png','file')
    I_rgb = imread('peppers.png');
else
    I_rgb = repmat(imread('cameraman.tif'),1,1,3); % fallback (grayscale → RGB)
end

figure('Name','Section 0: Original Image','NumberTitle','off');
imshow(I_rgb); title('Original RGB');

% Convert to grayscale (luminance)
if size(I_rgb,3)==3
    I = rgb2gray(I_rgb);
else
    I = I_rgb;
end

figure('Name','Section 0: Grayscale Conversion','NumberTitle','off');
imshow(I); title('Grayscale');

% Display basic info
fprintf('Class: %s | Range: [%g, %g] | Size: %d x %d\n', ...
    class(I), double(min(I(:))), double(max(I(:))), size(I,1), size(I,2));

%% 1) Quantization and dynamic range
% Simulate lower bit-depths by coarser quantization steps
I8 = I;                                % 8-bit (original)
I6 = uint8(floor(double(I)/4)*4);      % ~6 bits (step = 4)
I4 = uint8(floor(double(I)/16)*16);    % ~4 bits (step = 16)

figure('Name','Section 1: Quantization','NumberTitle','off');
montage({I8,I6,I4},'Size',[1 3]);
title('Quantization: 8-bit vs ~6-bit vs ~4-bit');
% Observation: Lower bit-depth → visible banding (posterization).

%% 2) Histogram and contrast stretching
figure('Name','Section 2: Histogram and Contrast Stretching','NumberTitle','off');
subplot(1,2,1); imhist(I); title('Histogram (original)');

I_norm = mat2gray(I); % normalize to [0,1]
I_stretch = imadjust(I,[0.2 0.8],[0 1]); % stretch mid-range

subplot(1,2,2); imhist(I_stretch); title('Histogram (stretched)');

figure('Name','Section 2: Original vs Normalized vs Stretched','NumberTitle','off');
montage({I, im2uint8(I_norm), im2uint8(I_stretch)},'Size',[1 3]);
title('Original | Normalized | Contrast-stretched');
% Observation: Contrast stretching redistributes intensities, enhancing detail visibility.

%% 3) Gamma correction (nonlinear amplitude scaling)
I_gamma_low  = imadjust(I,[],[],0.6); % gamma < 1 brightens
I_gamma_high = imadjust(I,[],[],1.6); % gamma > 1 darkens

figure('Name','Section 3: Gamma Correction','NumberTitle','off');
montage({I, I_gamma_low, I_gamma_high},'Size',[1 3]);
title('Gamma: original | gamma=0.6 | gamma=1.6');
% Observation: Gamma < 1 brightens shadows; Gamma > 1 darkens highlights.

%% 4) Sampling and aliasing (downsample then upsample)
scale = 0.1; % retain 10% of size
I_small = imresize(I, scale, 'nearest'); % aggressive downsampling
I_back  = imresize(I_small, size(I), 'nearest'); % upsample back

figure('Name','Section 4: Sampling and Aliasing','NumberTitle','off');
montage({I, I_small, I_back}, 'Size', [1 3]);
title('Original | Downsampled | Upscaled (aliasing artifacts)');
% Observation: Loss of detail and blocky edges appear due to undersampling (Nyquist violation).

%% 5) OPTIONAL: Moiré demo
% If available, repeat Section 4 on a striped/high-frequency texture image.
% You will observe moiré patterns (interference between frequencies).

%% 6) Short reflections (to include in report)
% 1) Bit-depth vs banding: lower quantization increases visible contour steps.
% 2) Contrast stretching spreads histogram, improving dynamic visibility.
% 3) Gamma modifies perceived brightness nonlinearly.
% 4) Aliasing appears when sampling frequency < 2× highest image frequency (Nyquist).
