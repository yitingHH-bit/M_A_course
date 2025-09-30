%% 1) CCLDE Demo: simulate a linear difference equation
% Goal: Show how coefficients a and b define an LTI system via a difference equation.
% y[n] + a1*y[n-1] + a2*y[n-2] = b0*x[n] + b1*x[n-1] + b2*x[n-2]

clear; clc; close all;

% Example coefficients (stable)
a = [1, -0.5, 0.25];   % a0=1 is implied; remaining are a1, a2
b = [0.2, 0.1, 0.05];  % b0, b1, b2

N = 300;
n = 0:N-1;

% Input: a sum of sinusoids + noise
x = sin(2*pi*0.03*n) + 0.5*sin(2*pi*0.12*n + pi/3) + 0.2*randn(size(n));

% Simulate difference equation using filter()
y = filter(b, a, x);

figure; 
subplot(2,1,1); plot(n, x, 'LineWidth', 1); grid on;
title('Input x[n]'); xlabel('n'); ylabel('Amplitude');

subplot(2,1,2); plot(n, y, 'LineWidth', 1); grid on;
title('Output y[n] via CCLDE (filter)'); xlabel('n'); ylabel('Amplitude');

% Frequency response
figure;
[H,w] = freqz(b, a, 1024, 'whole');
plot(w/pi, 20*log10(abs(fftshift(H))+eps), 'LineWidth', 1); grid on;
title('System Magnitude Response');
xlabel('Normalized Frequency (\times \pi rad/sample)'); ylabel('Magnitude (dB)');
