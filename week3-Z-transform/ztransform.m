%% week3_Z_transform.m
% Z-transform practice: Tasks A1–A5
% Run sections individually (Ctrl+Enter) in MATLAB.

clear; close all; clc;

%% ------------------------------------------------------------------------
% A1 – Warm-up: Finite Sequences → Polynomials
% -------------------------------------------------------------------------

syms n z

%% A1 (a) – Explicit polynomials in z^{-1}

% (i) x[n] = {1, 2, 5} at n = {0,1,2}
x1 = [1 2 5];
n1 = 0:2;
X1_poly = 1 + 2*z^(-1) + 5*z^(-2);      % by hand
disp('A1 (i)  X1(z) = 1 + 2 z^{-1} + 5 z^{-2}');
pretty(X1_poly)

% Verify with symbolic sum
X1_sym = 0;
for k = 1:length(x1)
    X1_sym = X1_sym + x1(k)*z^(-n1(k));
end
X1_sym = simplify(X1_sym);
disp('A1 (i)  X1(z) from symbolic sum:')
pretty(X1_sym)

% (ii) x[n] = {0, 3, 0, 4} at n = {0,1,2,3}
x2 = [0 3 0 4];
n2 = 0:3;
X2_poly = 0 + 3*z^(-1) + 0*z^(-2) + 4*z^(-3);
disp('A1 (ii) X2(z) = 3 z^{-1} + 4 z^{-3}');
pretty(X2_poly)

% Verify with symbolic sum
X2_sym = 0;
for k = 1:length(x2)
    X2_sym = X2_sym + x2(k)*z^(-n2(k));
end
X2_sym = simplify(X2_sym);
disp('A1 (ii) X2(z) from symbolic sum:')
pretty(X2_sym)

% A1 (b) explanation is to be written in the report (not code).


%% ------------------------------------------------------------------------
% A2 – Infinite Sequences & ROC
% -------------------------------------------------------------------------

syms n z a

% (a) x[n] = a^n u[n], with a = 0.6
a1 = 0.6;
x_a = a1^n * heaviside(n);     % heaviside(n) plays role of u[n]
X_a = simplify( ztrans(x_a, n, z) );
disp('A2 (a)  X(z) for a = 0.6:')
pretty(X_a)
disp('ROC: |z| > 0.6')

% (b) x[n] = (-0.8)^n u[n]
a2 = -0.8;
x_b = a2^n * heaviside(n);
X_b = simplify( ztrans(x_b, n, z) );
disp('A2 (b)  X(z) for a = -0.8:')
pretty(X_b)
disp('ROC: |z| > 0.8')

% (c) x[n] = -(0.9)^n u[-n-1]   (left-sided sequence)
a3 = 0.9;
x_c = -(a3^n) * heaviside(-n-1);    % left-sided u[-n-1]
X_c = simplify( ztrans(x_c, n, z) );
disp('A2 (c)  X(z) for left-sided sequence:')
pretty(X_c)
disp('ROC: |z| < 0.9')

% Explanation about ROC vs |z| and poles goes in the report.


%% ------------------------------------------------------------------------
% A3 – Properties: Linearity & Shifting
% -------------------------------------------------------------------------

syms n z

% Given sequences:
x1_inf = (0.5)^n    * heaviside(n);   % x1[n] = (0.5)^n u[n]
x2_inf = (-0.5)^n   * heaviside(n);   % x2[n] = (-0.5)^n u[n]

% (a) Z{2 x1[n] - 3 x2[n]}
X_lin = simplify( ztrans( 2*x1_inf - 3*x2_inf, n, z ) );
disp('A3 (a)  Z{2 x1[n] - 3 x2[n]} = ')
pretty(X_lin)

% (b) Time shift: Z{x1[n-3]}
x1_shifted = subs(x1_inf, n, n-3);    % x1[n-3]
X_shift = simplify( ztrans(x1_shifted, n, z) );
disp('A3 (b)  Z{x1[n-3]} = ')
pretty(X_shift)


%% ------------------------------------------------------------------------
% A4 – Inverse Z-Transform
% -------------------------------------------------------------------------

syms n z

% (a) X(z) = 1 / (1 - 0.7 z^{-1})
Xa = 1 / (1 - 0.7*z^(-1));
xa = simplify( iztrans(Xa, z, n) );
disp('A4 (a)  x[n] from X(z) = 1 / (1 - 0.7 z^{-1}):')
pretty(xa)

% (b) X(z) = (1 - 0.5 z^{-1}) / (1 - 0.8 z^{-1})
Xb = (1 - 0.5*z^(-1)) / (1 - 0.8*z^(-1));
xb = simplify( iztrans(Xb, z, n) );
disp('A4 (b)  x[n] from X(z) = (1 - 0.5 z^{-1}) / (1 - 0.8 z^{-1}):')
pretty(xb)

% Short pole/ROC explanation goes into the report.


%% ------------------------------------------------------------------------
% A5 – H(z), Poles/Zeros & Frequency Response
% -------------------------------------------------------------------------

% H(z) = (1 − 2.4 z^{−1} + 2.88 z^{−2}) / (1 − 0.8 z^{−1} + 0.64 z^{−2})

b = [1 -2.4 2.88];   % numerator coefficients
a = [1 -0.8 0.64];   % denominator coefficients

% (a) Pole-zero plot and numeric values
figure;
zplane(b, a);
grid on;
title('A5: Pole-Zero Plot of H(z)');

% numeric zeros and poles
z_zeros = roots(b);
z_poles = roots(a);
disp('A5 (a)  Zeros:')
disp(z_zeros)
disp('A5 (a)  Poles:')
disp(z_poles)

% (b) Magnitude and phase responses
[H, w] = freqz(b, a, 512);   % 512-point frequency response

figure;
subplot(2,1,1);
plot(w/pi, abs(H));
grid on;
xlabel('\omega / \pi');
ylabel('|H(e^{j\omega})|');
title('A5: Magnitude Response');

subplot(2,1,2);
plot(w/pi, angle(H));
grid on;
xlabel('\omega / \pi');
ylabel('Phase (rad)');
title('A5: Phase Response');

% Optional test signal to see filtering in time domain
n_s = 0:511;
x_test = sin(0.2*pi*n_s) + 0.5*sin(0.8*pi*n_s);
y_test = filter(b, a, x_test);

figure;
subplot(2,1,1);
plot(n_s, x_test);
grid on; xlabel('n'); ylabel('x[n]');
title('A5: Test Input Signal');

subplot(2,1,2);
plot(n_s, y_test);
grid on; xlabel('n'); ylabel('y[n]');
title('A5: Filtered Output Signal');

% Interpretation of filter type (low-pass, etc.) goes in the report.





