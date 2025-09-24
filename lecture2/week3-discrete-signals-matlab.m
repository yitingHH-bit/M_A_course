% discrete_signals.m
% Week 3 - Discrete-Time Signals (stem plots)
% Author: <your name>
% Description: Generate and plot common discrete-time signals over n = -10:10.

clc; clear; close all;

% ----------------------------
% 0) Common setup
% ----------------------------
n = -10:10;                 % discrete-time index vector
N = numel(n);

% Helper inline functions for readability
u  = @(n) double(n >= 0);                   % unit step u[n]
sgn = @(n) double(n > 0) - double(n < 0);   % signum: -1 (n<0), 0 (n=0), 1 (n>0)

% ----------------------------
% 1) Unit Impulse δ[n]
% ----------------------------
delta = double(n == 0);     % 1 at n=0, else 0

% ----------------------------
% 2) Unit Step u[n]
% ----------------------------
step = u(n);                % 1 for n>=0, else 0

% ----------------------------
% 3) Unit Ramp r[n] = n·u[n]
% ----------------------------
ramp = n .* u(n);           % linear growth for n>=0, zero for n<0

% ----------------------------
% 4) Exponential Signal x[n] = a^n u[n], choose a in (0,1) for decay
% ----------------------------
a = 0.8;                    % decay factor (try 1.2 to see growth for n>=0)
exp_sig = (a.^n) .* u(n);   % causal right-sided exponential

% ----------------------------
% 5) Signum Function sgn[n]
% ----------------------------
signum = sgn(n);            % -1 for n<0, 0 at n=0, +1 for n>0

% ----------------------------
% 6) Sinc Function sinc_d[n] = sin(pi n)/(pi n), with sinc_d[0] = 1
% ----------------------------
sinc_d = zeros(size(n));
idx0   = (n == 0);
sinc_d(idx0)    = 1;                          % define value at n=0
sinc_d(~idx0)   = sin(pi*n(~idx0)) ./ (pi*n(~idx0));

% ----------------------------
% Plot all (discrete → use stem)
% ----------------------------
figure('Name','Discrete-Time Signals','Color','w');
tiledlayout(3,2, 'TileSpacing','compact','Padding','compact');

% δ[n]
nexttile;
stem(n, delta, 'filled');
grid on; xlabel('n'); ylabel('\delta[n]');
title('Unit Impulse \delta[n]');
xlim([min(n) max(n)]);

% u[n]
nexttile;
stem(n, step, 'filled');
grid on; xlabel('n'); ylabel('u[n]');
title('Unit Step u[n]');
xlim([min(n) max(n)]); ylim([-0.2 1.2]);

% r[n] = n u[n]
nexttile;
stem(n, ramp, 'filled');
grid on; xlabel('n'); ylabel('r[n]');
title('Unit Ramp r[n] = n u[n]');
xlim([min(n) max(n)]);

% a^n u[n]
nexttile;
stem(n, exp_sig, 'filled');
grid on; xlabel('n'); ylabel(sprintf('%0.1f^n u[n]', a));
title(sprintf('Exponential a^n u[n] (a = %.2f)', a));
xlim([min(n) max(n)]);

% sgn[n]
nexttile;
stem(n, signum, 'filled');
grid on; xlabel('n'); ylabel('sgn[n]');
title('Signum Function sgn[n]');
xlim([min(n) max(n)]); ylim([-1.2 1.2]);

% sinc
nexttile;
stem(n, sinc_d, 'filled');
grid on; xlabel('n'); ylabel('sinc_d[n]');
title('Discrete sinc: sin(\pin)/(\pin)');
xlim([min(n) max(n)]);

% ----------------------------
% (Optional) Export figure as PNG for GitHub README
% ----------------------------
% saveas(gcf, 'discrete_signals.png');

