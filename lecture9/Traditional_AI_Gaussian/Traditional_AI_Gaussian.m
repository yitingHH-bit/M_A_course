%% Gaussian Noise Denoising with Traditional Filters
% Requirements: Image Processing Toolbox (for psnr, ssim, imgaussfilt)
% Output: saves a figure PNG and metrics CSV for GitHub

clear; clc; close all;

%% 1) Load image & add Gaussian noise
% Use cameraman.tif (ships with MATLAB). Convert to double grayscale [0,1].
try
    originalImage = im2double(imread('cameraman.tif'));
catch
    % Fallback if file not found
    I = imread('peppers.png');
    if size(I,3) == 3, I = rgb2gray(I); end
    originalImage = im2double(I);
end

noiseSigma = 0.04;                 % standard deviation (σ)
noisyImage  = imnoise(originalImage, 'gaussian', 0, noiseSigma^2);

%% 2) Apply traditional filters (Mean, Median, Gaussian blur)
% Kernel/window choices are typical; you can tweak and re-run.
meanKernelSize   = [5 5];
gaussKernelSigma = 1.0;            % std for Gaussian blur
gaussKernelSize  = 5;              % filter size (odd)

% Mean (average) filter
meanKernel   = fspecial('average', meanKernelSize);
meanFiltered = imfilter(noisyImage, meanKernel, 'replicate');

% Median filter
medianFiltered = medfilt2(noisyImage, [5 5], 'symmetric');

% Gaussian blur
gaussianFiltered = imgaussfilt(noisyImage, gaussKernelSigma, 'FilterSize', gaussKernelSize);

%% (Optional) Include Wiener for your own curiosity/comparison
% Not required by your brief, but helpful as a reference baseline
wienerFiltered = wiener2(noisyImage, [5 5], noiseSigma^2);

%% 3) Metrics: MSE, PSNR, SSIM
% Helper for MSE
mse = @(A,B) mean((A(:) - B(:)).^2);

methods = {'Noisy', 'Mean (Average)', 'Median', 'Gaussian Blur', 'Wiener (opt)'};
images  = {noisyImage, meanFiltered,   medianFiltered, gaussianFiltered, wienerFiltered};

MSE   = zeros(numel(images),1);
PSNRdB= zeros(numel(images),1);
SSIMv = zeros(numel(images),1);

for i = 1:numel(images)
    MSE(i)    = mse(images{i}, originalImage);
    PSNRdB(i) = psnr(images{i}, originalImage);
    SSIMv(i)  = ssim(images{i}, originalImage);
end

%% 4) Show visuals (good for screenshots)
figure('Name','Gaussian Noise Denoising (Traditional Filters)','Color','w','Position',[100 100 1400 400]);
tiledlayout(1,6,'Padding','compact','TileSpacing','compact');
nexttile; imshow(originalImage);  title('Original');
nexttile; imshow(noisyImage);     title(sprintf('Noisy (\\sigma=%.3f)', noiseSigma));
nexttile; imshow(meanFiltered);   title('Mean (5x5)');
nexttile; imshow(medianFiltered); title('Median (5x5)');
nexttile; imshow(gaussianFiltered); title(sprintf('Gaussian Blur (\\sigma=%.1f)', gaussKernelSigma));
nexttile; imshow(wienerFiltered); title('Wiener (5x5, opt)');

% Save figure for GitHub
outFigPath = 'denoising_traditional_comparison.png';
exportgraphics(gcf, outFigPath, 'Resolution', 200);

%% 5) Print & save metrics (CSV for GitHub)
fprintf('\n--- Image Quality Metrics (higher PSNR/SSIM, lower MSE is better) ---\n');
fprintf('%-18s | %10s | %10s | %10s\n','Method','MSE','PSNR(dB)','SSIM');
fprintf('--------------------|------------|------------|------------\n');
for i = 1:numel(images)
    fprintf('%-18s | %10.6f | %10.4f | %10.4f\n', methods{i}, MSE(i), PSNRdB(i), SSIMv(i));
end

T = table(methods(:), MSE, PSNRdB, SSIMv, ...
    'VariableNames', {'Method','MSE','PSNR_dB','SSIM'});
writetable(T, 'denoising_metrics.csv');

%% 6) Notes for your report (short bullets to include with screenshots)
% - Gaussian noise added with σ=noiseSigma.
% - Mean filter: reduces noise but tends to blur edges and fine textures.
% - Median filter: robust to impulse noise; for Gaussian noise it can help,
%   but may still soften details.
% - Gaussian blur: matched to Gaussian noise; preserves structure better than mean,
%   but still smooths edges depending on σ.
% - (Optional) Wiener: adapts by local variance; often performs best among
%   "traditional" options for AWGN.
