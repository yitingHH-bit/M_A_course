
% EXERCISE 12 — Direct FIR Low-Pass (no window), M = 20 & 64
% Implements:
% h_LP(n) = sin(wc*(n - M/2)) / (pi*(n - M/2)), with h_LP(M/2) = wc/pi
% and plots impulse + magnitude, plus a comparison figure.

clear; close all; clc;

wc   = 1;                 % cutoff in RADIANS
Nfft = 1024;              % FFT grid
w    = linspace(-pi, pi, Nfft);
wn   = w/pi;              % normalized x-axis [-1,1]

Ms = [20, 64];            % filter orders to test
Hs_keep = cell(numel(Ms),1);

for i = 1:numel(Ms)
    M = Ms(i);
    n = 0:M;                              % sample index (length M+1)
    c = M/2;                              % center (since M even, c is integer)
    % --- impulse response (element-wise ops!) ---
    h_LP = sin(wc*(n - c)) ./ (pi*(n - c));
    h_LP(n == c) = wc/pi;                 % special case n = M/2

    % --- frequency response on Nfft grid ---
    H_LP = fft(h_LP, Nfft);
    Hplt = fftshift(H_LP);                % center DC at 0 for plotting
    Hs_keep{i} = abs(Hplt);

    % ===== plots for this M =====
    figure('Color','w');
    stem(n, h_LP, 'filled'); grid on;
    title(sprintf('Impulse Response h_{LP}(n), M = %d', M));
    xlabel('n'); ylabel('h_{LP}(n)');

    figure('Color','w');
    plot(wn, abs(Hplt), 'LineWidth', 1.2); grid on;
    title(sprintf('Magnitude Response |H_{LP}(e^{j\\omega})|, M = %d', M));
    xlabel('\omega/\pi'); ylabel('|H_{LP}|');
    xlim([-1 1]);
    % (Optional) show normalized cutoff location:
    xline(+wc/pi,'--'); xline(-wc/pi,'--');
end

% ===== comparison: both magnitudes on one figure =====
figure('Color','w'); hold on; grid on;
plot(wn, Hs_keep{1}, 'LineWidth', 1.2);
plot(wn, Hs_keep{2}, 'LineWidth', 1.2);
xlim([-1 1]);
xlabel('\omega/\pi'); ylabel('|H_{LP}|');
title('Magnitude Response Comparison (M = 20 vs 64) — Ideal (no window)');
legend('M = 20','M = 64','Location','best');
