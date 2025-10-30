%% Lab 6: Mini Project – Unified Image Pipeline
% Goal: combine filtering, frequency, edges, and enhancement
% HOW TO SUBMIT: push this script + the saved PNGs + README.md to GitHub

close all; clear; clc;
rng(0);                          % reproducibility for any random ops
out = @(h,n) print(h, n, '-dpng','-r160');   % quick saver

%% 1) Load image (grayscale); fallback if your file is missing
fname = 'your_image.jpg';        % <- replace with your file
try
    I0rgb = imread(fname);
catch
    warning('File not found: %s. Using peppers.png as fallback.', fname);
    I0rgb = imread('peppers.png');
end
if size(I0rgb,3)==3, I0 = rgb2gray(I0rgb); else, I0 = I0rgb; end
I0 = im2double(I0);

fh0 = figure('Color','w'); imshow(I0,[]); title('Original'); out(fh0,'fig0_original');

%% 2) Pre-process (noise removal)
% Pick one: median for impulsive noise, bilateral for edge-preserving smoothing
I_med = medfilt2(I0, [3 3]);                    % non-linear, great for salt&pepper
I_bil = imbilatfilt(I0, 0.08, 7);               % (range sigma, spatial sigma)

fh1 = figure('Color','w'); montage({I0,I_med,I_bil},'Size',[1 3]);
title('Original | Median 3x3 | Bilateral'); out(fh1,'fig1_denoise_compare');

% Choose one denoised base for downstream steps:
I_den = I_bil;   % <- switch to I_med if your image has speckle/impulsive noise

%% 3) Contrast enhancement
% Adaptive histogram equalization (CLAHE) vs simple stretch (imadjust)
I_clahe = adapthisteq(I_den, 'ClipLimit', 0.01, 'NBins', 256);
I_stretch = imadjust(I_den, stretchlim(I_den, [0.01 0.99]), [0 1]);

fh2 = figure('Color','w'); montage({I_den,I_stretch,I_clahe},'Size',[1 3]);
title('Denoised | Contrast stretch | CLAHE'); out(fh2,'fig2_enhance_compare');

% Choose enhanced image for features:
I_enh = I_clahe;

%% 4) Edge extraction (gradient & zero-crossing families)
E_sobel   = edge(I_enh, 'Sobel');                       % gradient mag + NMS
E_canny   = edge(I_enh, 'Canny', [0.05 0.15]);          % low/high can be tuned
E_log     = edge(I_enh, 'log', 0.003);                  % Laplacian of Gaussian

fh3 = figure('Color','w'); montage({E_sobel,E_canny,E_log},'Size',[1 3]);
title('Sobel | Canny | LoG'); out(fh3,'fig3_edges_compare');

%% 5) Frequency-domain filter (example: low-pass & notch demo)
% (a) Ideal low-pass for smoothing textures
F   = fftshift(fft2(I_enh));
[M,N] = size(F);
[U,V] = meshgrid(-N/2:N/2-1, -M/2:M/2-1);
D = sqrt(U.^2 + V.^2);

D0 = 60;                               % cutoff radius (tune to your image)
H_lp = double(D <= D0);
I_lp = real(ifft2(ifftshift(F .* H_lp)));
I_lp = mat2gray(I_lp);

% (b) Optional: notch out a periodic artifact at (u0,v0)
% Set u0,v0 after inspecting the spectrum image
u0 = 80; v0 = 0; w = 6;                 % example notch location/width
H_notch = 1 - exp(-((U-u0).^2 + (V-v0).^2)/(2*w^2)) .* exp(-((U+u0).^2 + (V+v0).^2)/(2*w^2));
I_notch = real(ifft2(ifftshift(F .* H_notch)));
I_notch = mat2gray(I_notch);

fh4 = figure('Color','w');
subplot(1,3,1); imshow(log(1+abs(F)),[]); title('Log-magnitude spectrum');
subplot(1,3,2); imshow(I_lp,[]);        title(sprintf('Ideal LP (D0=%d)',D0));
subplot(1,3,3); imshow(I_notch,[]);     title('Notch filtered'); out(fh4,'fig4_frequency');

%% 6) (Optional) Unsharp masking: sharpen while controlling noise
I_blur = imgaussfilt(I_enh, 1.0);
I_sharp = imsharpen(I_enh, 'Radius',1.0, 'Amount',1.2);
I_unsharp = imadjust(I_enh + 0.7*(I_enh - I_blur), [], [0 1]);  % classic unsharp

fh5 = figure('Color','w'); montage({I_enh,I_sharp,I_unsharp},'Size',[1 3]);
title('Enhanced | imsharpen | Unsharp mask'); out(fh5,'fig5_sharpen');

%% 7) Quick quantitative peek (edge density & contrast change)
edge_density = 100 * nnz(E_canny) / numel(E_canny);     % %
contrast_gain = std2(I_enh)/std2(I_den);                % ratio

fprintf('Edge density (Canny): %.2f %%\n', edge_density);
fprintf('Contrast gain (std ratio, enh/denoised): %.3f\n', contrast_gain);

%% 8) Final collage (story at a glance)
fh6 = figure('Color','w');
montage({I0, I_den, I_enh, E_canny, I_lp, I_sharp}, 'Size',[2 3], 'BorderSize',[10 10], 'BackgroundColor','w');
title({'Pipeline: Original | Denoised | Enhanced | Canny | Low-pass | Sharpened'});
out(fh6,'fig6_pipeline_collage');

%% 9) Notes for your README
% - Edges ~ high-frequency changes; denoising reduces false edges.
% - Gradient (Sobel/Canny) vs zero-crossing (LoG) provide complimentary maps.
% - CLAHE expands local contrast; frequency LP suppresses fine texture.
% - Notch filter removes periodic interference if present in spectrum.
% - Sharpening restores perceived detail but can re-amplify noise—balance it.
