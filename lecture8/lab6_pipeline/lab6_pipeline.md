# Lab 6 — Mini Project: Unified Image Pipeline

**Goal.** Combine denoising → contrast enhancement → edge detection → frequency filtering on my own image, and explain choices.

## Problem statement
I chose an image of ______. The main challenge is ______ (e.g., low contrast, fine texture that triggers false edges, periodic interference).

## Pipeline & DSP links
1) **Denoise** (median/bilateral): suppress high-frequency noise while preserving edges (non-linear vs edge-preserving linear).
2) **Enhance** (stretch/CLAHE): increase dynamic range / local contrast to make edges more detectable.
3) **Edges** (Sobel/Canny/LoG): gradient vs zero-crossing; Canny adds NMS + hysteresis for thin, continuous contours.
4) **Frequency** (LP / notch): smooth textures (low-pass) or remove periodic artifacts visible as spikes in the spectrum.
5) **(Optional) Sharpen** after smoothing to recover perceived detail.

## Screenshots
See `fig0...fig5` PNGs in this repo.

## Observations
- Bilateral preserved boundaries better than median on this image; median is preferable for impulsive noise.
- CLAHE improved mid-tone contrast and gave cleaner Canny edges.
- Canny produced the thinnest, most stable edges vs. Sobel/LoG.
- Low-pass reduced distracting texture before edge detection; notch removed a visible periodic stripe (if present).

## Quick metrics (printed by script)
- Denoised MSE/SNR, Enhanced MSE/SNR, Canny edge density (%).  
*(Note: enhancement intentionally changes intensity distribution; metrics are indicative, not absolute quality.)*

## Limitations & improvements
- Kernel sizes and thresholds are image-dependent; auto-tuning (Otsu on gradient magnitude, auto Canny) could generalize.
- Ideal LP causes ringing; try Butterworth/Gaussian in frequency for smoother roll-off.

#
<img width="650" height="528" alt="image" src="https://github.com/user-attachments/assets/0ead77ae-f410-483d-9730-39fca3e0a4aa" />

#
<img width="649" height="230" alt="image" src="https://github.com/user-attachments/assets/1d825b4f-d392-489b-b931-3aeaa28e69ca" />

#
<img width="670" height="229" alt="image" src="https://github.com/user-attachments/assets/df0193c0-dc30-4c18-a6c9-faaa3b83e56e" />

#
<img width="641" height="238" alt="image" src="https://github.com/user-attachments/assets/9900c851-be77-4d29-985a-6d3cb1526c10" />

#
<img width="650" height="207" alt="image" src="https://github.com/user-attachments/assets/79ad1416-5f9e-4799-898b-bc95b7c3e9a4" />
#
<img width="672" height="162" alt="image" src="https://github.com/user-attachments/assets/7e98614a-8859-4cba-9668-708d715c0d96" />
