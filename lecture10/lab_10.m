%% Simple demo of "Learning to See in the Dark" pretrained network
% Goal:
% Use the pretrained low-light enhancement network WITHOUT
% downloading the huge SID dataset or doing any training.

clear; clc; close all;

%% 1) Download pretrained network (only once)
dataDir = fullfile(tempdir, "Sony2025"); % or use pwd for current folder
if ~exist(dataDir, "dir")
    mkdir(dataDir);
end

modelFile = fullfile(dataDir, "trainedLowLightCameraPipelineNet.mat");
if ~isfile(modelFile)
    fprintf("Downloading pretrained low-light model...\n");
    modelURL = "https://ssd.mathworks.com/supportfiles/" + ...
        "vision/data/trainedLowLightCameraPipelineDlnetwork.zip";
    zipFile = fullfile(dataDir, "trainedLowLightCameraPipelineDlnetwork.zip");

    % Download zip file
    websave(zipFile, modelURL);

    % Unzip to dataDir
    unzip(zipFile, dataDir);
    fprintf("Download complete. Model saved in:\n%s\n", dataDir);
end

%% 2) Load pretrained network
load(modelFile, "netTrained");

%% 3) Read your own dark RGB image
% Make sure Example_03.png is in the current MATLAB folder.
I = imread("Example_03.png");
I = im2single(imresize(I, [512 512]));   % Resize and convert to single

%% 4) Use the image as the low-light input and add a small amount of noise
% (CHANGE compared to original script)
darkFactor = 1.0;                         % was 0.03 – image is already dark
I_dark = I * darkFactor;                 % keeps original brightness
I_dark_noisy = imnoise(I_dark, "gaussian", 0, 0.001); % slightly less noise

%% 5) Build a simple 4-channel "fake RAW" input
I_gray = rgb2gray(I_dark_noisy);         % H x W
rawFake = repmat(I_gray, 1, 1, 4);       % H x W x 4

%% 6) Wrap into dlarray with format "SSCB"
input = dlarray(rawFake, "SSCB");

% Optional: run on GPU if available
if canUseGPU
    input = gpuArray(input);
end

%% 7) Run the pretrained network
out = predict(netTrained, input);        % Output: H x W x 3 x 1 (RGB)

%% 8) Convert back to normal MATLAB image
out = gather(extractdata(out));          % Remove dlarray and GPU
out = squeeze(out);                      % Remove batch dimension
out = im2uint8(out);                     % Convert to uint8 [0,255]

%% 9) Show original, low-light, and enhanced images side by side
figure;
subplot(1,3,1);
imshow(I);
title("Original dark RGB");

subplot(1,3,2);
imshow(I_dark_noisy);
title("Input to network (dark + slight noise)");

subplot(1,3,3);
imshow(out);
title("Network output (enhanced)");

% Optional: save images for your report / README
imwrite(I, "input_image.png");
imwrite(I_dark_noisy, "input_dark_noisy.png");
imwrite(out, "enhanced_result.png");
