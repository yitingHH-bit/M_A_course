clc; clear all; close all;

% Define the value of t  (-1 to 1 with 0.001 step)
t  = -1:0.001:1;          % 2001 samples
Fs = 1/0.001;             % 1000 Hz
N  = numel(t);

% Write the given expression x in terms of t
x = sin(2*pi*50*t) + sin(2*pi*75*t);

% ---- Time domain plot ----
subplot(2,1,1);
plot(t(1001:1200), x(1001:1200));   % align indices
grid on;
title('Sin(2\pi50t)+Sin(2\pi75t)');
xlabel('Time, s');

% ---- Frequency domain ----
X  = abs(fft(x));          % FFT magnitude
X2 = fftshift(X);          % Shift zero freq to center

% Frequency axis: -499.9 : (1000/2001) : 500, trimmed to N points
f = -499.9 : (Fs/N) : 500;
f = f(1:N);

subplot(2,1,2);
plot(f, X2);               % use stem(f,X2) if you want spikes like the slide
grid on;
title('Frequency domain representation of Sin(2\pi50t)+ Sin(2\pi75t)');
xlabel('Frequency, Hz.');
xlim([-200 200]);          % optional: zoom to show ±50 and ±75 clearly

