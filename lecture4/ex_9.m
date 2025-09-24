
clc; clear; close all;

% ---- signal (与Ex.8相同) ----
Fs = 100;
t  = 0:1/Fs:10-1/Fs;                  % 10 s, N = 1000
x  = sin(2*pi*15*t) + sin(2*pi*40*t);

% ---- FFT 指定长度 n ----
n = 512;
y = fft(x, n);
m = abs(y);
y(m < 1e-6) = 0;                      % 小幅值清零，便于相位
p = unwrap(angle(y));                 % 相位(rad)
f = (0:n-1) * Fs / n;                 % 频率轴

% ---- 画图 ----
figure; clf;

% 1) Magnitude
subplot(2,1,1);
plot(f, m);
grid on;
title('Magnitude');
xlabel('Frequency, Hz');
xlim([0 100]);
ax = gca; ax.XTick = [15 40 60 85];

% 2) Phase
subplot(2,1,2);
plot(f, p*180/pi);
grid on;
title('Phase');
xlabel('Frequency, Hz');
xlim([0 100]);
ax = gca; ax.XTick = [15 40 60 85];

drawnow;   % 强制刷新（可选）
