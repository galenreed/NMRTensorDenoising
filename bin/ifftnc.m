function res = ifftnc(x)
%
%
% res = ifftnc(x)
% 
% orthonormal centered N-Dimention ifft
%
% (c) Michael Lustig 2005

res = sqrt(length(x(:)))*ifftshift(ifftn(fftshift(x)));
