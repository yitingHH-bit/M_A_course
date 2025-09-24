clc;
clear; close all;

% Discretize the value of t from -1 to 1 with the increment of 0.001
t  = -1:0.001:1;               % 2001 samples
Fs = 1/0.001;                  % Sampling frequency (Hz)
N  = numel(t);

% write the function x = sin(2π50t) in MATLAB
x = sin(2*pi*50*t);

% Use the subplot function
figure;
subplot(2,1,1);
plot(t(1001:1200), x(1001:1200));  % show ~0 to 0.199 s segment
grid on;
title('Sin(2\pi50t)');
xlabel('Time, s');

% write the matlab code for absolute value of fast Fourier transform of x, and assign it as X
X = abs(fft(x));                % (optionally: X = abs(fft(x))/N; for amplitude scaling)

% Now find the fftshift of X to get X2
X2 = fftshift(X);

% Frequency axis (matches length N exactly)
f = (-(N-1)/2 : (N-1)/2) * (Fs/N);

% Use the subplot function
subplot(2,1,2);
plot(f, X2);
grid on;
title('Frequency domain representation of Sin(2\pi50t)');
xlabel('Frequency, Hz.');
