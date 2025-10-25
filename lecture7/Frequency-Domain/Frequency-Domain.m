%% Lab 3: Frequency-Domain Filtering with fft2
% Course: Mathematical Algorithms (DSP) — Image Processing Labs
% -------------------------------------------------------------------------
% - Ideal LP causes ringing (Gibbs) due to hard cutoff.
% - Convolution theorem: spatial convolution <-> frequency multiplication.
% - Compare spatial vs frequency-domain Gaussian LP (should match closely).
%
% HOW TO SUBMIT:
% Include screenshots and short explanations for each section in GitHub.
% Submit only the GitHub URL.
% -------------------------------------------------------------------------
close all; clear; clc;

%% 0) Load and prepare image
if exist('peppers.png','file')
    I0 = imread('peppers.png');
else
    I0 = repmat(imread('cameraman.tif'),1,1,3);
end
I = im2double(rgb2gray(I0));
[M, N] = size(I);

%% 1) Magnitude spectrum (log-scale)
F = fft2(I);
Fshift = fftshift(F);
S = log(1 + abs(Fshift));

figure('Name','1) Magnitude Spectrum','NumberTitle','off');
subplot(1,2,1); imshow(I,[]); title('Image');
subplot(1,2,2); imshow(S,[]); title('Log-magnitude spectrum (centered)');
% Observation: Bright center = low frequencies; corners = high frequencies.

%% 2) Ideal & Gaussian Low-pass Filters in frequency domain
[u, v] = meshgrid( -floor(N/2):ceil(N/2)-1, -floor(M/2):ceil(M/2)-1 );
D = sqrt(u.^2 + v.^2);

D0 = 40;                     % cutoff radius for ideal LP
H_ideal_LP = double(D <= D0);

sigma = 20;                  % std dev for Gaussian LP
H_gauss_LP = exp(-(D.^2) / (2*sigma^2));

figure('Name','2) Filter Spectra','NumberTitle','off');
subplot(1,2,1); imshow(fftshift(H_ideal_LP),[]); title('Ideal LP mask');
subplot(1,2,2); imshow(fftshift(H_gauss_LP),[]); title('Gaussian LP mask');

%% 3) Apply LP filters in frequency domain
G_ideal = ifft2( ifftshift( H_ideal_LP .* Fshift ) );
G_gauss = ifft2( ifftshift( H_gauss_LP .* Fshift ) );

figure('Name','3) LP Filtering Results','NumberTitle','off');
montage({I, real(G_ideal), real(G_gauss)}, 'Size', [1 3]);
title('Original | Ideal LP | Gaussian LP (ringing vs smooth)');
% Observation: Ideal LP causes ringing; Gaussian LP yields smoother blur.

%% 4) High-pass via complement
H_gauss_HP = 1 - H_gauss_LP;
G_hp = real( ifft2( ifftshift( H_gauss_HP .* Fshift ) ) );
G_hp = mat2gray(G_hp);

figure('Name','4) High-pass Result','NumberTitle','off');
montage({I, G_hp}, 'Size', [1 2]);
title('Original | Gaussian High-pass result');
% Observation: High-pass emphasizes edges and fine details.

%% 5) Compare spatial vs frequency-domain Gaussian LP
g1d = fspecial('gaussian',[1 7], 1.2);
I_spatial_gauss = imfilter(I, g1d'*g1d, 'replicate');

figure('Name','5) Spatial vs Frequency Gaussian','NumberTitle','off');
montage({I_spatial_gauss, real(G_gauss)}, 'Size', [1 2]);
title('Spatial Gaussian LP | Frequency-domain Gaussian LP');
% Observation: Both results are nearly identical.

%% 6) Reflections (for report)
% 1) Why does ideal LP cause ringing (Gibbs phenomenon)?
%    → Abrupt cutoff in frequency = oscillations in spatial domain.
%
% 2) What does fftshift do visually?
%    → Moves DC component (low frequencies) to image center for visualization.
%
% 3) When is frequency-domain filtering computationally preferable?
%    → For large kernels (convolution theorem: FFT-based multiplication is faster).
