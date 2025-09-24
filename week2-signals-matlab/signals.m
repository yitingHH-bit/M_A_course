% ct_signals.m
% Continuous-time signals: impulse, step, ramp, exponential, signum, sinc
% Note: delta(t) (Dirac impulse) can't be plotted directly; we visualize it.

clc; clear; close all;

% Continuous time axis
t = -10:0.01:10;                   % "continuous-like" time grid

% Helper functions (vectorized)
u  = double(t >= 0);               % unit step u(t)
sg = sign(t); sg(t==0) = 0;        % signum with sgn(0)=0

% Signals
delta_height = 1;                  % drawn height for impulse visualization
step_sig  = u;                     % unit step
ramp_sig  = t .* u;                % unit ramp r(t) = t*u(t)
alpha     = 0.2;                   % decay rate (>0)
expo_sig  = exp(-alpha*t) .* u;    % right-sided decaying exponential
signum    = sg;                    % signum
sinc_sig  = sinc(t);               % MATLAB's sinc(x) = sin(pi*x)/(pi*x)

% -------- Figure 1: first five signals --------
figure('Color','w'); tiledlayout(3,2, "TileSpacing","compact","Padding","compact");

% 1) Unit impulse (visualized as a vertical line at t=0)
nexttile;
plot(t, zeros(size(t)), 'k'); hold on; grid on;
line([0 0], [0 delta_height], 'Color','b', 'LineWidth', 2);   % visual marker
title('Continuous time unit impulse signal');
xlabel('continuous time t ---->'); ylabel('amplitude --->');
ylim([0 1.1*delta_height]);

% 2) Unit step
nexttile;
plot(t, step_sig, 'b', 'LineWidth', 1.5); grid on;
title('Unit step signal');
xlabel('continuous time t ---->'); ylabel('amplitude --->');
ylim([-0.1 1.1]);

% 3) Unit ramp
nexttile;
plot(t, ramp_sig, 'b', 'LineWidth', 1.5); grid on;
title('Unit ramp signal');
xlabel('continuous time t ---->'); ylabel('amplitude --->');

% 4) Exponential (right-sided, decaying)
nexttile;
plot(t, expo_sig, 'b', 'LineWidth', 1.5); grid on;
title('continuous time exponential signal');
xlabel('continuous time t ---->'); ylabel('amplitude --->');

% 5) Signum
nexttile([1 2]);                    % wide tile
plot(t, signum, 'b', 'LineWidth', 1.5); grid on;
title('continuous time signum function');
xlabel('continuous time t ---->'); ylabel('amplitude --->');
ylim([-1.1 1.1]);

% -------- Figure 2: Sinc --------
figure('Color','w');
plot(t, sinc_sig, 'b', 'LineWidth', 1.5); grid on;
title('continuous time sinc function');
xlabel('continuous time t ---->'); ylabel('amplitude --->');

% (Optional) export figures
% saveas(figure(1), 'ct_signals_1.png');
% saveas(figure(2), 'ct_sinc.png');
