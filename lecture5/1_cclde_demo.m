%% 5- and 9-point moving-average filters: freqz + tf2zpk + pole-zero plots
% Coefficients exactly as given (unnormalized: DC gain = length)
b1 = [1 1 1 1 1];           a1 = 1;      % 5-point MA (gain at DC = 5)
b2 = [1 1 1 1 1 1 1 1 1];   a2 = 1;      % 9-point MA (gain at DC = 9)

% (Optional) normalized versions (uncomment to use DC gain = 1)
%b1 = b1/numel(b1);  b2 = b2/numel(b2);

% Frequency responses
nfft = 2048;
[H1, w] = freqz(b1, a1, nfft, 'whole');   % w in rad/sample [0, 2*pi)
H2      = freqz(b2, a2, nfft, 'whole');

% Magnitude (linear) and in dB
mag1 = abs(H1);  mag2 = abs(H2);
mag1dB = 20*log10(mag1 + eps);  mag2dB = 20*log10(mag2 + eps);

% --- Plots ---
figure('Name','Magnitude responses');
subplot(2,1,1); plot(w/pi, mag1, 'LineWidth',1.2); grid on;
title('|H_1(e^{j\omega})| for 5-point MA'); xlabel('\omega/\pi'); ylabel('Magnitude');

subplot(2,1,2); plot(w/pi, mag2, 'LineWidth',1.2); grid on;
title('|H_2(e^{j\omega})| for 9-point MA'); xlabel('\omega/\pi'); ylabel('Magnitude');

figure('Name','Magnitude (dB)');
subplot(2,1,1); plot(w/pi, mag1dB, 'LineWidth',1.2); grid on;
title('5-point MA (dB)'); xlabel('\omega/\pi'); ylabel('Magnitude (dB)');
subplot(2,1,2); plot(w/pi, mag2dB, 'LineWidth',1.2); grid on;
title('9-point MA (dB)');  xlabel('\omega/\pi'); ylabel('Magnitude (dB)');

% Zeros, poles, gain via tf2zpk
[z1, p1, k1] = tf2zpk(b1, a1);
[z2, p2, k2] = tf2zpk(b2, a2);

% Pole-zero plots
figure('Name','Pole-zero plots');
subplot(1,2,1); zplane(b1, a1); title('Pole-zero: 5-point MA');
subplot(1,2,2); zplane(b2, a2); title('Pole-zero: 9-point MA');

% Print some key values
disp('--- 5-point MA ---');
disp('Zeros:'); disp(z1.'); disp('Poles:'); disp(p1.'); disp(['Gain k = ', num2str(k1)]);
disp('--- 9-point MA ---');
disp('Zeros:'); disp(z2.'); disp('Poles:'); disp(p2.'); disp(['Gain k = ', num2str(k2)]);
