clc; clear all; close all;

% Time vector: t = 0:1/100:10-1/100  (Fs = 100 Hz, 10 s, N = 1000)
t  = 0:1/100:10-1/100;
Fs = 100;
N  = numel(t);

% Signal: x = sin(2*pi*15*t) + sin(2*pi*40*t)
x = sin(2*pi*15*t) + sin(2*pi*40*t);

% ----- Plots -----
figure;

% Original signal
subplot(3,1,1);
plot(t, x);
grid on;
title('Given Original Signal');
xlabel('Time, s');

% DFT (single-argument FFT)
y = fft(x);
m = abs(y);                       % Magnitude
y(m < 1e-6) = 0;                  % Zero-out tiny bins to stabilize phase
p = unwrap(angle(y));             % Phase (radians)

% Frequency points: f = (0:length(y)-1)*100/length(y)
f = (0:N-1) * Fs / N;

% Magnitude plot
subplot(3,1,2);
stem(f, m, 'Marker','none');
grid on;
title('Magnitude');
xlabel('Frequency, Hz.');
xlim([0 100]);
ax = gca; ax.XTick = [15 40 60 85];

% Phase plot (degrees)
subplot(3,1,3);
stem(f, p*180/pi, 'Marker','none');
grid on;
title('Phase');
xlabel('Frequency, Hz.');
xlim([0 100]);
ax = gca; ax.XTick = [15 40 60 85];

