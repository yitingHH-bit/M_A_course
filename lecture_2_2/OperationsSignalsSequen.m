
%% Program: Operations on Continuous and Discrete Time Signals
clc; clear; close all;

choice = input('Enter your choice:\n1. Operations on continuous time signals\n2. Operations on discrete time signals\nchoice = ');

switch choice
    % ==============================================================
    % === CASE 1 : Continuous-time signals =========================
    % ==============================================================
    case 1
        t = 0:0.01:1;          % time vector
        f1 = 1; f2 = 2;        % frequencies

        s1 = sin(2*pi*f1*t);
        s2 = sin(2*pi*f2*t);

        figure;

        subplot(5,2,1);
        plot(t,s1); grid on;
        title('original signal with frequency 1');
        xlabel('time t'); ylabel('amplitude');

        subplot(5,2,2);
        plot(t,s2); grid on;
        title('original signal with frequency 2');
        xlabel('time t'); ylabel('amplitude');

        subplot(5,2,3);
        plot(t,s1+s2); grid on;
        title('sum of 2 signals');
        xlabel('time t'); ylabel('amplitude');

        subplot(5,2,4);
        plot(t,s1.*s2); grid on;
        title('multiplication of s1 and s2');
        xlabel('time t'); ylabel('amplitude');

        % Time delayed and advanced
        subplot(5,2,5);
        plot(t,s1); hold on;
        plot(t, sin(2*pi*f1*(t-0.25)) ); grid on;
        title('time delayed signal');
        xlabel('time t'); ylabel('amplitude');

        subplot(5,2,6);
        plot(t,s1); hold on;
        plot(t, sin(2*pi*f1*(t+0.25)) ); grid on;
        title('time advanced signal');
        xlabel('time t'); ylabel('amplitude');

        % Compressed and expanded
        subplot(5,2,7);
        plot(t,sin(2*pi*f1*(2*t))); grid on;
        title('compressed signal');
        xlabel('time t'); ylabel('amplitude');

        subplot(5,2,8);
        t2 = 0:0.01:2;
        plot(t2,sin(2*pi*f1*(0.5*t2))); grid on;
        title('expanded signal');
        xlabel('time t'); ylabel('amplitude');

        % Reflected and amplitude scaled
        subplot(5,2,9);
        plot(-t, s1); grid on;
        title('reflected signal');
        xlabel('time t'); ylabel('amplitude');

        subplot(5,2,10);
        plot(t, 3*s1); grid on;
        title('amplitude scaled signal');
        xlabel('time t'); ylabel('amplitude');

    % ==============================================================
    % === CASE 2 : Discrete-time signals ===========================
    % ==============================================================
    case 2
        n = -10:10;          % discrete index
        N1 = 10; N2 = 8;     % periods

        x1 = sin(2*pi*n/N1);
        x2 = sin(2*pi*n/N2);

        figure;

        subplot(3,2,1);
        stem(n,x1,'filled'); grid on;
        title('discrete sine wave x1(n) with time period = 10');
        xlabel('n'); ylabel('amplitude');

        subplot(3,2,2);
        stem(n,x2,'filled'); grid on;
        title('discrete sine wave x2(n) with time period = 8');
        xlabel('n'); ylabel('amplitude');

        subplot(3,2,3);
        stem(n,x1+x2,'filled'); grid on;
        title('sum of two discrete time signals');
        xlabel('n'); ylabel('amplitude');

        subplot(3,2,4);
        stem(n,x1.*x2,'filled'); grid on;
        title('multiplication of two discrete time signals');
        xlabel('n'); ylabel('amplitude');

        subplot(3,2,5);
        stem(n-2, x1, 'filled'); grid on;
        title('time shifted signal of x1(n)');
        xlabel('n'); ylabel('amplitude');

        subplot(3,2,6);
        stem(-n, x1, 'filled'); grid on;
        title('time folded signal of x1(n)');
        xlabel('n'); ylabel('amplitude');

        figure;
        stem(n, 2*x2, 'filled'); grid on;
        title('amplitude scaled discrete time signal of x2(n)');
        xlabel('n'); ylabel('amplitude');

    otherwise
        disp('Invalid choice. Enter 1 or 2.');
end
