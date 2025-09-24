clc;

clear all;

close all;

% Discretize the value of t from -1 to 1 with the increment of 0.001

% write the function x = sin(2π50t) in MATLAB

%Use the subplot function

plot(t(1001:1200),x(1:200));

grid;

title('Sin(2\pi50t)')

xlabel('Time, s')

%Use the subplot function

% write the matlab code for absolute value of fast Fourier transform of x, and assign it as X

% Now find the fftshift of X to get X2

X2=fftshift(X);

f=-499.9:1000/2001:500;

plot(f,X2);

grid;

title(' Frequency domain representation of … Sin(2\pi50t)');

xlabel('Frequency, Hz.')
