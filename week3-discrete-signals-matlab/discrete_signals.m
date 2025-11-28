%% week3-discrete-signals-matlab
% Basic discrete-time signals demo
% Run with:  >> discrete_signals

clc; clear; close all;

% Common index axis for all signals
n = -20:20;                      % sample indices

%% 1) Unit Impulse: models a "sample at one time index"
delta = double(n == 0);          % δ[n] = 1 at n=0, 0 elsewhere

%% 2) Unit Step: turns on a system/input at n = 0
u = double(n >= 0);              % u[n] = 1 for n>=0, 0 otherwise

%% 3) Unit Ramp: tests system response to linearly increasing inputs
r = n .* u;                      % r[n] = n for n>=0, 0 for n<0

%% 4) Right-sided Exponential: fundamental LTI mode
a = 0.8;                         % decay factor (0<|a|<1 for decaying)
x_exp = (a.^n) .* u;             % x[n] = a^n u[n], right-sided sequence

%% 5) Signum: simple nonlinearity; useful for symmetry checks
sgn = zeros(size(n));            % initialize with zeros
sgn(n > 0) = 1;                  % +1 for n>0
sgn(n < 0) = -1;                 % -1 for n<0
% sgn(0) stays 0

%% 6) Discrete-time sinc (scaled)
% x[n] = sin(pi*n/L) / (pi*n/L)
% Scaling by L spreads the main lobe, so not every integer n is a zero.
L = 4;                            % time-scaling factor
x_sinc = ones(size(n));           % value at n=0 is 1 (limit)
idx = (n ~= 0);                   % avoid division by zero
x_sinc(idx) = sin(pi*n(idx)/L) ./ (pi*n(idx)/L);

%% ---- Plot all signals ----------------------------------------------
figure('Name','Basic Discrete-Time Signals','NumberTitle','off');

subplot(3,2,1);
stem(n, delta, 'filled');
title('Unit Impulse \delta[n]');
xlabel('n'); ylabel('\delta[n]');
grid on; axis tight;

subplot(3,2,2);
stem(n, u, 'filled');
title('Unit Step u[n]');
xlabel('n'); ylabel('u[n]');
grid on; axis tight;

subplot(3,2,3);
stem(n, r, 'filled');
title('Unit Ramp r[n]');
xlabel('n'); ylabel('r[n]');
grid on; axis tight;

subplot(3,2,4);
stem(n, x_exp, 'filled');
title(sprintf('Right-Sided Exponential a^n u[n], a = %.1f', a));
xlabel('n'); ylabel('x[n]');
grid on; axis tight;

subplot(3,2,5);
stem(n, sgn, 'filled');
title('Signum Signal sgn[n]');
xlabel('n'); ylabel('sgn[n]');
grid on; axis([-20 20 -1.2 1.2]);

subplot(3,2,6);
stem(n, x_sinc, 'filled');
title(sprintf('Scaled Discrete-Time sinc, L = %d', L));
xlabel('n'); ylabel('sinc_L[n]');
grid on; axis tight;
