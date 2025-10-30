%% Lab 4: Noise and Filtering
% Requirements:
% - Model Gaussian and salt-and-pepper noise
% - Measure MSE and SNR (also PSNR for convenience)
% - Compare mean, median, Gaussian filters for noise reduction
% - Save screenshots for GitHub

close all; clear; clc;

%% ---------- Helpers ----------
snr_db = @(orig,noisy) 10*log10( mean(orig(:).^2) / mean((noisy(:)-orig(:)).^2) );
psnr_db = @(orig,noisy) psnr(noisy,orig);            % uses Image Processing Toolbox
mse_fun = @(A,B) immse(A,B);

savepng = @(h,name) (print(h, sprintf('%s.png',name), '-dpng','-r160'));

%% ---------- Load grayscale test image ----------
I0 = im2double(rgb2gray(imread('peppers.png')));     % any image is fine, keep 0..1
% If you want to fix randomness for reproducibility:
rng(0);

%% ---------- 1) Add noise: Gaussian & Salt-Pepper ----------
sigma2 = 0.01;          % variance for Gaussian
sp_density = 0.05;      % density for salt & pepper

I_g  = imnoise(I0,'gaussian',0,sigma2);
I_sp = imnoise(I0,'salt & pepper',sp_density);

fh1 = figure('Name','Original & Noisy','Color','w');
montage({I0, I_g, I_sp}, 'Size',[1 3], 'BorderSize',[10 10], 'BackgroundColor','w');
title('Original | Gaussian noise | Salt & pepper noise');
savepng(fh1,'fig_noisy_montage');

%% ---------- 2) Baseline metrics ----------
MSE_g  = mse_fun(I_g, I0);
MSE_sp = mse_fun(I_sp, I0);
SNR_g  = snr_db(I0, I_g);
SNR_sp = snr_db(I0, I_sp);
PSNR_g  = psnr_db(I0, I_g);
PSNR_sp = psnr_db(I0, I_sp);

fprintf('Baseline (noisy vs original)\n');
fprintf('  Gaussian:  MSE = %.4f | SNR = %.2f dB | PSNR = %.2f dB\n', MSE_g,  SNR_g,  PSNR_g);
fprintf('  S&P:       MSE = %.4f | SNR = %.2f dB | PSNR = %.2f dB\n\n', MSE_sp, SNR_sp, PSNR_sp);

%% ---------- 3) Filters: mean(average), Gaussian, median ----------
% Kernels (3x3). You can also try 5x5 below.
h_avg3   = fspecial('average',3);
h_gauss3 = fspecial('gaussian',[3 3],0.7);

% Apply to Gaussian-noisy
Ig_avg3   = imfilter(I_g, h_avg3,  'replicate');
Ig_g3     = imfilter(I_g, h_gauss3,'replicate');
Ig_med3   = medfilt2(I_g,[3 3]);

% Apply to S&P-noisy
Isp_avg3  = imfilter(I_sp,h_avg3,  'replicate');
Isp_g3    = imfilter(I_sp,h_gauss3,'replicate');
Isp_med3  = medfilt2(I_sp,[3 3]);

% Show comparison panels (and save)
fh2 = figure('Name','Filtering: S&P','Color','w');
montage({I_sp, Isp_avg3, Isp_g3, Isp_med3},'Size',[1 4], 'BorderSize',[10 10], 'BackgroundColor','w');
title('Salt & pepper: Noisy | Mean 3x3 | Gaussian 3x3 | Median 3x3');
savepng(fh2,'fig_sp_filters');

fh3 = figure('Name','Filtering: Gaussian','Color','w');
montage({I_g, Ig_avg3, Ig_g3, Ig_med3},'Size',[1 4], 'BorderSize',[10 10], 'BackgroundColor','w');
title('Gaussian: Noisy | Mean 3x3 | Gaussian 3x3 | Median 3x3');
savepng(fh3,'fig_gauss_filters');

%% ---------- 4) Metrics after filtering (3x3) ----------
labels = { ...
  'S&P mean3', 'S&P gauss3', 'S&P median3', ...
  'Gauss mean3', 'Gauss gauss3', 'Gauss median3'};

imgs   = {Isp_avg3, Isp_g3, Isp_med3, Ig_avg3, Ig_g3, Ig_med3};

MSE = zeros(numel(imgs),1);
SNR = zeros(numel(imgs),1);
PSN = zeros(numel(imgs),1);

for k=1:numel(imgs)
    MSE(k) = mse_fun(imgs{k}, I0);
    SNR(k) = snr_db(I0, imgs{k});
    PSN(k) = psnr_db(I0, imgs{k});
end

fprintf('After filtering (3x3):\n');
for k=1:numel(labels)
    fprintf('  %-13s  MSE = %.4f | SNR = %.2f dB | PSNR = %.2f dB\n', ...
        labels{k}, MSE(k), SNR(k), PSN(k));
end
fprintf('\n');

%% ---------- 5) (Optional) Try 5x5 kernels to see blur vs. denoise tradeoff ----------
h_avg5   = fspecial('average',5);
h_gauss5 = fspecial('gaussian',[5 5],1.0);

Ig_avg5  = imfilter(I_g,  h_avg5,  'replicate');
Ig_g5    = imfilter(I_g,  h_gauss5,'replicate');
Ig_med5  = medfilt2(I_g,  [5 5]);

Isp_avg5 = imfilter(I_sp, h_avg5,  'replicate');
Isp_g5   = imfilter(I_sp, h_gauss5,'replicate');
Isp_med5 = medfilt2(I_sp, [5 5]);

fh4 = figure('Name','5x5 Comparison','Color','w');
montage({Isp_avg5,Isp_g5,Isp_med5, Ig_avg5,Ig_g5,Ig_med5},'Size',[2 3], 'BorderSize',[10 10], 'BackgroundColor','w');
title('Top: S&P (mean5 | gauss5 | median5)  |  Bottom: Gaussian (mean5 | gauss5 | median5)');
savepng(fh4,'fig_5x5_comparison');

fprintf('5x5 quick check (PSNR only):\n');
fprintf('  S&P: mean5 %.2f | gauss5 %.2f | median5 %.2f dB\n', psnr_db(I0,Isp_avg5), psnr_db(I0,Isp_g5), psnr_db(I0,Isp_med5));
fprintf('  Gauss: mean5 %.2f | gauss5 %.2f | median5 %.2f dB\n', psnr_db(I0,Ig_avg5), psnr_db(I0,Ig_g5), psnr_db(I0,Ig_med5));
