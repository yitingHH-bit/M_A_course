% ct_signals.m (only the exponential lines changed)

clc; clear; close all;

t = -10:0.01:10;

u  = double(t >= 0);
sg = sign(t); sg(t==0) = 0;

delta_height = 1;
step_sig  = u;
ramp_sig  = t .* u;

alpha     = 0.2;                   % try 0.18 to match ~6 at t=-10
expo_sig  = exp(-alpha*t);         % non-causal decaying exponential  <-- CHANGED
signum    = sg;
sinc_sig  = sinc(t);

figure('Color','w'); tiledlayout(3,2,"TileSpacing","compact","Padding","compact");

nexttile;
plot(t, zeros(size(t)), 'k'); hold on; grid on;
line([0 0], [0 delta_height], 'Color','b', 'LineWidth', 2);
title('Continuous time unit impulse signal');
xlabel('continuous time t ---->'); ylabel('amplitude --->');
ylim([0 1.1*delta_height]);

nexttile;
plot(t, step_sig, 'b', 'LineWidth', 1.5); grid on;
title('Unit step signal');
xlabel('continuous time t ---->'); ylabel('amplitude --->');
ylim([-0.1 1.1]);

nexttile;
plot(t, ramp_sig, 'b', 'LineWidth', 1.5); grid on;
title('Unit ramp signal');
xlabel('continuous time t ---->'); ylabel('amplitude --->');

nexttile;
plot(t, expo_sig, 'b', 'LineWidth', 1.5); grid on;
title('continuous time exponential signal');
xlabel('continuous time t ---->'); ylabel('amplitude --->');

nexttile([1 2]);
plot(t, signum, 'b', 'LineWidth', 1.5); grid on;
title('continuous time signum function');
xlabel('continuous time t ---->'); ylabel('amplitude --->');
ylim([-1.1 1.1]);

figure('Color','w');
plot(t, sinc_sig, 'b', 'LineWidth', 1.5); grid on;
title('continuous time sinc function');
xlabel('continuous time t ---->'); ylabel('amplitude --->');
