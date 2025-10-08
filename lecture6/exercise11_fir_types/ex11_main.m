% EXERCISE 11 – FIR Types I–IV: Magnitude / Phase / Zeros
% Create: exercise11_fir_types/ex11_main.m
% Run in MATLAB (R2020b+ recommended)

clear; close all; clc;

% ---- Given impulse responses ----
h1 = [1 2 3 4 4 3 2 1];      % Type I   (M even, symmetric)   – linear phase
h2 = [1 2 3 4 3 2 1];        % Type II  (M odd,  symmetric)   – linear phase
h3 = [-1 -2 -3 -4 3 3 2 1];  % Type III (M even, antisym.)    – linear phase for odd-symmetric (mag odd)
h4 = [-1 -2 -3 0 3 2 1];     % Type IV  (M odd,  antisym.)    – linear phase; zero @ z=-1

filters = {h1,h2,h3,h4};
labels  = { ...
    'Type I  (even M, symmetric)', ...
    'Type II (odd  M, symmetric)', ...
    'Type III(even M, antisymm.)', ...
    'Type IV (odd  M, antisymm.)'};

Nfft = 512;

% ---- Figure layout: 4 rows (I–IV) × 3 cols (|H| / phase / zeros) ----
figure('Color','w','Position',[100 100 1200 900]);
tiledlayout(4,3,'TileSpacing','compact','Padding','compact');

magAxes  = gobjects(4,1);
phsAxes  = gobjects(4,1);

for k = 1:4
    h = filters{k};
    [H, w] = freqz(h, 1, Nfft);   % H(e^{jw}), w in rad/sample

    % --- Magnitude ---
    nexttile;
    plot(w/pi, abs(H), 'LineWidth',1.2); grid on;
    xlabel('Normalized Frequency (\times\pi rad/sample)');
    ylabel('|H(e^{j\omega})|');
    title(sprintf('%s — Magnitude', labels{k}));
    magAxes(k) = gca;

    % --- Phase (unwrapped) ---
    nexttile;
    ph = unwrap(angle(H));
    plot(w/pi, ph, 'LineWidth',1.2); grid on;
    xlabel('Normalized Frequency (\times\pi rad/sample)');
    ylabel('Unwrapped Phase (rad)');
    title(sprintf('%s — Phase', labels{k}));
    phsAxes(k) = gca;

    % --- Zeros (pole-zero) ---
    nexttile;
    zplane(h, 1); grid on;
    title(sprintf('%s — Zeros', labels{k}));
end

% Make the views consistent
linkaxes(magAxes, 'x'); linkaxes(phsAxes, 'x');
set(magAxes, 'XLim', [0 1]); set(phsAxes, 'XLim', [0 1]);

% Optional: show approximate linear-phase group delay lines
% (commented; uncomment if you want helper markers)
% for k = 1:4
%     h = filters{k};
%     M = length(h)-1;                 % filter order
%     tau = M/2;                        % linear-phase group delay (samples)
%     axes(phsAxes(k)); hold on;
%     y = -tau * (2*pi*(0:Nfft-1)/Nfft); % straight-line reference
%     plot((0:Nfft-1)/Nfft, unwrap(wrapToPi(y)), '--');
% end

% Save a high-res figure beside the script
outPng = fullfile(pwd, 'exercise11_results.png');
exportgraphics(gcf, outPng, 'Resolution', 220);
fprintf('Saved figure to: %s\n', outPng);

% ---- Console summary (quick checks) ----
fprintf('\n=== Summary checks ===\n');
for k = 1:4
    h = filters{k}; M = length(h)-1;
    issym  = isequal(h, fliplr(h));
    isasym = isequal(h, -fliplr(h));
    fprintf('%s: M=%d | symmetric=%d | antisymmetric=%d\n', ...
        labels{k}, M, issym, isasym);
end
fprintf('Done.\n');

