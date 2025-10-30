%% Lab 5: Edge Detection and Segmentation
% Learning outcomes:
% - Relate edges to high-frequency components
% - Apply gradient-based and zero-crossing operators
% - Perform automatic thresholding (Otsu) and simple segmentation
close all; clear; clc;

% Load image
I = im2double(rgb2gray(imread('peppers.png')));

%% 1) Basic derivative filters (Sobel, Prewitt)
edges_sobel   = edge(I,'Sobel');
edges_prewitt = edge(I,'Prewitt');

fh1 = figure('Color','w'); 
montage({edges_sobel, edges_prewitt}, 'Size',[1 2]);
title('Sobel | Prewitt edges');
print(fh1,'fig_edges_gradients','-dpng','-r160');

%% 2) Canny detector (multi-stage)
edges_canny = edge(I,'Canny',[0.05 0.2]);  % [low high] thresholds
fh2 = figure('Color','w'); imshow(edges_canny); 
title('Canny edges');
print(fh2,'fig_edges_canny','-dpng','-r160');

%% 3) Laplacian of Gaussian (LoG)
edges_log = edge(I,'log');   % 'log' is the MATLAB token for LoG
fh3 = figure('Color','w'); imshow(edges_log); 
title('Laplacian of Gaussian edges');
print(fh3,'fig_edges_log','-dpng','-r160');

%% 4) Otsu threshold → binary mask
level = graythresh(I);                    % Otsu’s method
BW = imbinarize(I, level);
fh4 = figure('Color','w'); 
montage({I, BW}, 'Size',[1 2]);
title('Original | Otsu threshold binary mask');
print(fh4,'fig_otsu','-dpng','-r160');

%% 5) Label and visualize regions
[L, num] = bwlabel(BW);
RGB = label2rgb(L);
fh5 = figure('Color','w'); imshow(RGB); 
title(['Labeled regions: ', num2str(num)]);
print(fh5,'fig_labels','-dpng','-r160');

%% 6) Notes for README
% - Thin/clean edges: Canny (nonmax suppression + hysteresis) is usually best.
% - Canny vs. simple gradients: better noise rejection and edge localization.
% - Otsu: picks threshold that maximizes between-class variance (histogram-based).
