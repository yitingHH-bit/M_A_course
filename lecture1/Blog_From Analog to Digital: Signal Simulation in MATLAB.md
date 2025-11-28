
````markdown
# From Analog to Digital: Signal Simulation in MATLAB

This repo shows the full path:

**Analog → Sampling → Quantization → Binary Encoding → Bitstream**

We simulate everything in MATLAB using a simple sine wave.

---

## 1. Analog Signal Generation

We create a “continuous-time” signal using a very small time step.

**Signal:**

- x(t) = sin(2*pi*f*t)
- f = 100 Hz

```matlab
%% 1. Generate Analog Signal (conceptual)

t = 0:0.0001:0.01;        % very fine step (continuous-like time)
f = 100;                  % frequency = 100 Hz

x_analog = sin(2*pi*f*t); % x(t) = sin(2πft)

figure;
plot(t, x_analog, 'LineWidth', 1.5);
title('Analog Signal (Sine Wave)');
xlabel('Time (s)'); ylabel('Amplitude');
grid on;
````

This mimics an analog sensor output (e.g. microphone, vibration sensor).

---

## 2. Sampling

We sample the analog signal at sampling frequency `Fs`.

**Key formulas (text form):**

* Sampling frequency: `Fs` (Hz)
* Sampling period: `Ts = 1/Fs`
* Sample times: `t_n = n * Ts`
* Samples: `x[n] = x(t_n)`

```matlab
%% 2. Sampling

Fs = 1000;               % Sampling frequency = 1 kHz
Ts = 1/Fs;               % Sampling period
n  = 0:Ts:0.01;          % Discrete sample points

x_sampled = sin(2*pi*f*n);  % x[n] = x(nTs)

figure;
stem(n, x_sampled, 'filled');
title('Sampled Signal');
xlabel('Time (s)'); ylabel('Amplitude');
grid on;
```

**Nyquist theorem:**
To avoid aliasing, choose `Fs >= 2 * f_max`.
Here, `f_max = 100 Hz`, so Nyquist rate is `200 Hz`. We use `Fs = 1000 Hz`.

---

## 3. Quantization

Sampling makes **time** discrete.
Quantization makes **amplitude** discrete (finite levels).

**Parameters:**

* Bits per sample: `B = bits`
* Number of levels: `L = 2^B`
* Input range: `[x_min, x_max]`
* Step size (resolution): `Delta = (x_max - x_min) / L`

**Operations:**

* Index: `k[n] = round( (x[n] - x_min) / Delta )`
* Quantized value: `x_q[n] = x_min + k[n] * Delta`

```matlab
%% 3. Quantization

bits   = 4;                     % Number of bits
levels = 2^bits;                % Quantization levels L = 2^B

x_min  = min(x_sampled);
x_max  = max(x_sampled);

q_step = (x_max - x_min) / levels;   % Step size Δ

% Map samples to integer indices 0..L-1
x_index = round((x_sampled - x_min) / q_step);

% Clip indices to [0, levels-1]
x_index(x_index < 0)        = 0;
x_index(x_index > levels-1) = levels-1;

% Map indices back to quantized amplitudes
x_quantized = x_index * q_step + x_min;

figure;
stem(n, x_quantized, 'filled');
title(['Quantized Signal (' num2str(bits) '-bit)']);
xlabel('Time (s)'); ylabel('Amplitude');
grid on;
```

More bits → more levels → smaller step size → less quantization error.

---

## 4. Binary Encoding

Each quantization index `k[n]` is a number between `0` and `L-1`.
We encode it as a `bits`-bit binary word.

Examples for 4 bits:

* 0 → 0000
* 5 → 0101
* 15 → 1111

```matlab
%% 4. Encoding (Binary Representation)

binary_codes = dec2bin(x_index, bits);  % each row = B-bit codeword

disp('--- First 10 encoded samples (index and bits) ---');
disp(table((0:9)', x_index(1:10)', binary_codes(1:10,:), ...
    'VariableNames', {'n','Index','Bits'}));
```

---

## 5. Digital Bitstream

Finally, we concatenate all codewords into one long bitstream
(similar to what would be sent over a bus or wireless link).

```matlab
%% 5. Digital Bitstream

bitstream = reshape(binary_codes.', 1, []);  % concatenate all bits

disp('--- First 40 bits of the stream ---');
disp(bitstream(1:40));

%% Summary

fprintf('\nSimulation complete!\n');
fprintf('Analog -> Sampling -> Quantization -> Binary Encoding -> Digital Stream\n');
fprintf('Bits per sample: %d\n', bits);
fprintf('Total samples: %d\n', length(x_sampled));
fprintf('Total bits: %d\n', length(bitstream));
```

---

## IoT Context

This flow matches what happens inside an IoT sensor node:

1. Sensor outputs analog voltage `x(t)`.
2. ADC samples and quantizes it.
3. MCU encodes samples as bits.
4. Wireless module sends the bitstream to the cloud.

---

## Things to Try

* Change `Fs` below and above the Nyquist rate and observe aliasing.
* Change `bits` (e.g. 2, 3, 8) and see how quantization affects signal quality.
* Plot `x_sampled` and `x_quantized` together to visualize quantization error.


