Measure image quality using common metrics: Mean-Square Error (MSE), Peak Signal-to-Noise Ratio (PSNR), and Structural Similarity Index (SSIM).
Compare the effectiveness of traditional filters (Mean, Median, and Gaussian blur) for different noise reduction tasks.
HOW TO SUBMIT: Include screenshots and short explanations for each section in the GitHub. Submit only the GitHub URL.

## Noise model: Added zero-mean Gaussian noise with σ = 0.04.

## Metrics: Lower MSE is better; higher PSNR/SSIM is better.

## Observations:

## Mean gives uniform smoothing but blurs edges.

## Median is excellent for salt-and-pepper; for Gaussian it helps but can soften details.

## Gaussian blur matches the noise distribution; usually better edge retention than mean for similar smoothness.

## (Optional) Wiener adapts to local variance and often achieves the best PSNR/SSIM among traditional filters on AWGN.  
<img width="1186" height="730" alt="image" src="https://github.com/user-attachments/assets/46ac2942-d0b6-48dd-9e3e-caaf372991f7" />

<img width="588" height="463" alt="image" src="https://github.com/user-attachments/assets/4d95c6b2-fde7-4da7-8dd3-8a04fb737a8c" />
