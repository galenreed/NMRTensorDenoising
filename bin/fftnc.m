function res = fftnc(x)

% res = fftnc(x)
% 
% orthonormal forward N-Dimension FFT
%
% (c) Michael Lustig 2007

res = 1/sqrt(length(x(:)))*fftshift(fftn(ifftshift(x)));