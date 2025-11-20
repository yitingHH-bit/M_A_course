<img width="662" height="751" alt="image" src="https://github.com/user-attachments/assets/db67d4e9-e74b-4b72-9c7f-8fe2fa971027" />

## Learning to See in the Dark – Mini Demo

This project uses the pretrained **Learning to See in the Dark** network from MathWorks to enhance a low-light image without any training.

### Files

* `seeInTheDarkDemo.m` – main MATLAB script
* `Example_03.png` – my own dark input image
* `enhanced_result.png` – network output (enhanced image)

### What I changed

Compared to the original demo script:

1. **Custom input image**
   I replaced the default test image (`peppers.png`) with my own low-light image:

   ```matlab
   I = imread("Example_03.png");
   ```

2. **Adjusted low-light simulation**
   Because my image is already dark, I changed how the synthetic low-light image is created:

   * Set

     ```matlab
     darkFactor = 1.0;
     ```

     so the script keeps the original brightness instead of making it much darker.
   * Reduced the Gaussian noise variance in

     ```matlab
     I_dark_noisy = imnoise(I_dark, "gaussian", 0, 0.001);
     ```

     to add only a small amount of noise.

These changes let me test the pretrained network on a realistic dark photo I took, and then compare **original vs. noisy low-light vs. enhanced** results.
<img width="1148" height="588" alt="image" src="https://github.com/user-attachments/assets/2f908b0b-ac50-4776-bca6-6e678132db08" />
