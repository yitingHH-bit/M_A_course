%% Image Denoising: Gaussian Noise + Traditional vs AI
% Reproducible setup
rng(0);

% --- 1) Load image & add Gaussian noise ---
I = im2double(imread('cameraman.tif'));   % grayscale [0,1]
sigmaNoise = 0.04;                        % intensity-domain std
In = imnoise(I, 'gaussian', 0, sigmaNoise^2);

% --- 2) Traditional filters: Mean, Median, Gaussian blur, Wiener ---
% Kernel/window sizes chosen to balance smoothing & detail
meanH = fspecial('average', [5 5]);                 % Mean (box) filter
I_mean = imfilter(In, meanH, 'replicate');

I_median = medfilt2(In, [5 5]);                     % Median filter

sigmaSpatial = 1.0;                                 % spatial std (pixels)
I_gauss = imgaussfilt(In, sigmaSpatial, 'FilterSize', 5);  % Gaussian blur

I_wiener = wiener2(In, [5 5], sigmaNoise^2);        % Wiener (optional traditional)

% --- 3) AI filter: DnCNN (grayscale) ---
hasAI = true;
try
    net = denoisingNetwork('DnCNN');                % requires toolbox weights
    I_ai = denoiseImage(In, net);
catch
    warning('DnCNN not available; skipping AI filter.');
    hasAI = false;
    I_ai = [];
end

% --- 4) Quantitative evaluation: MSE, PSNR, SSIM ---
methods = {'Noisy','Mean','Median','Gaussian','Wiener'};
images  = {In,    I_mean, I_median, I_gauss,  I_wiener};

if hasAI
    methods{end+1} = 'AI (DnCNN)';
    images{end+1}  = I_ai;
end

% Compute metrics
mseVals  = zeros(numel(images),1);
psnrVals = zeros(numel(images),1);
ssimVals = zeros(numel(images),1);

for k = 1:numel(images)
    mseVals(k)  = immse(images{k}, I);
    psnrVals(k) = psnr(images{k}, I);
    ssimVals(k) = ssim(images{k}, I);
end

% --- 5) Display: side-by-side visual comparison ---
figure('Name','Gaussian Noise Denoising Comparison','Color','w');
tiledlayout(2,4,'TileSpacing','compact','Padding','compact');

% Row 1
nexttile; imshow(I);    title('Original');
nexttile; imshow(In);   title(sprintf('Noisy (\\sigma=%.02f)', sigmaNoise));
nexttile; imshow(I_mean);   title('Mean (5×5)');
nexttile; imshow(I_median); title('Median (5×5)');

% Row 2
nexttile; imshow(I_gauss);  title(sprintf('Gaussian blur (\\sigma_s=%.1f, 5×5)', sigmaSpatial));
nexttile; imshow(I_wiener); title('Wiener (5×5)');
if hasAI
    nexttile; imshow(I_ai); title('AI (DnCNN)');
else
    nexttile; axis off; text(0.5,0.5,'AI (DnCNN) not available','HorizontalAlignment','center');
end
% Residual (optional visualization)
R = abs(In - I_wiener);  % show Wiener residual as example
nexttile; imshow(R,[]);  title('Residual |Noisy - Wiener|');

% Save figure for GitHub
try
    exportgraphics(gcf,'denoising_comparison.png','Resolution',200);
catch
    saveas(gcf,'denoising_comparison.png');
end

% --- 6) Print a neat metrics table & save CSV ---
fprintf('\n--- Image Quality Metrics (Reference = Original) ---\n');
fprintf('Noise sigma = %.4f (intensity)\n', sigmaNoise);
fprintf('%-16s | %10s | %10s | %10s\n','Method','MSE','PSNR (dB)','SSIM');
fprintf('%s\n', rep('-',16+3+10+3+10+3+10));

T = table(methods(:), mseVals, psnrVals, ssimVals, ...
    'VariableNames', {'Method','MSE','PSNR_dB','SSIM'});
disp(T);

% Save CSV for your repo
writetable(T,'metrics.csv');

% --- Local notes (for your write-up) ---
% Typical expectations for additive white Gaussian noise:
% - Mean filter: strong smoothing, but blurs edges and fine texture.
% - Median filter: robust to impulsive noise (salt & pepper), less ideal for Gaussian.
% - Gaussian blur: matches Gaussian noise statistics; good trade-off but still softens edges.
% - Wiener: adapts by local variance -> preserves edges better than fixed blur.
% - DnCNN: learns complex priors; often best PSNR/SSIM + preserves details if available.

