clc; clear; close all;

%% 1) "Analog" signal (high-resolution time grid)
f = 100;                      % Hz
t = 0:1e-4:0.01;              % very fine step (≈ continuous)
x_analog = sin(2*pi*f*t);

figure;
plot(t, x_analog, 'LineWidth', 1.5);
grid on;
title('Analog Signal (Sine Wave)');
xlabel('Time (s)'); ylabel('Amplitude');

%% 2) Sampling
Fs = 1000;                    % sampling frequency (Hz)
Ts = 1/Fs;                    % sampling period
n = 0:Ts:0.01;                % sample instants
x_sampled = sin(2*pi*f*n);

figure;
stem(n, x_sampled, 'filled'); grid on;
title(sprintf('Sampled Signal (Fs = %d Hz)', Fs));
xlabel('Time (s)'); ylabel('Amplitude');

% (Optional) overlay analog vs sampled for visual comparison
figure;
plot(t, x_analog, 'LineWidth', 1.2); hold on;
stem(n, x_sampled, 'filled'); grid on;
legend('Analog (dense)','Sampled','Location','best');
title('Analog vs. Sampled'); xlabel('Time (s)'); ylabel('Amplitude');

%% 3) Quantization
bits   = 4;                   % number of bits
levels = 2^bits;              % quantization levels
x_min  = min(x_sampled);
x_max  = max(x_sampled);

% Use levels-1 to avoid an unreachable top code due to rounding
q_step = (x_max - x_min)/(levels - 1);

% Map to code indices, round, then clip to [0, levels-1]
x_index = round((x_sampled - x_min)/q_step);
x_index = max(0, min(levels-1, x_index));

% Reconstruct quantized amplitudes
x_quantized = x_index * q_step + x_min;

figure;
stairs(n, x_quantized, 'LineWidth', 1.2); hold on;
stem(n, x_sampled, 'filled'); grid on;
legend('Quantized','Original samples','Location','best');
title(sprintf('Quantized Signal (%d-bit, %d levels)', bits, levels));
xlabel('Time (s)'); ylabel('Amplitude');

%% 4) Encoding (binary words for each quantized sample)
binary_codes = dec2bin(x_index, bits);   % char array: numSamples x bits

disp('--- First 10 encoded samples (binary) ---');
disp(binary_codes(1:min(10, size(binary_codes,1)), :));  % <-- fixed indexing

%% 5) Digital bitstream (concatenate words)
bitstream = reshape(binary_codes.', 1, []);   % row char vector of '0'/'1'

disp('--- First 40 bits of the stream ---');
disp(bitstream(1:min(40, numel(bitstream))));

%% Summary
fprintf('\nSimulation complete!\n');
fprintf('Analog -> Sampling -> Quantization -> Encoding -> Bitstream\n');
fprintf('Bits per sample: %d\n', bits);
fprintf('Total samples:   %d\n', numel(x_sampled));
fprintf('Total bits:      %d\n', numel(bitstream));

