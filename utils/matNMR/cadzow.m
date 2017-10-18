function [nfid, SV] = cadzow(fid,signals,F)
%
%CADZOW - Cadzow-based signal enhancement
%
% Call: Nfid = cadzow(fid,signals,F)
%              signals = maximum number of signals
%              F = window size of the Hankel matrix (1/4-1/3)
%
% If signals is positive it represents the maximum number of signals 
% for which the fid is reconstructed.  For negative values the abs(signals)
% largest signals are removed as suggested by Zhu.
%
% The Cadzow algorithm works on one vector at a time.  Data is returned
% as a column vector.  If mat_in is a single fid the singular values vector 
% is also returned.
% If the first input argument is a matrix the enhancement is applied to all 
% columns of the matrix. 
% 
% Without any input argments a demo fid with three signals is used.  
% When no output is specified the original and the filtered fid are shown
% together with the singular value vector (magenta=all singular values,
% green=selected singular values).
%
% Refs: J.Cadzow, Signal Enhancement. A Composite Propoerty Mapping Algorithm.
%       IEEE Trans. on Acoustics, Speech and Signal Processing, 
%       ASSP-36 (1988)  
%
%       Yung-Ya, Lin and Lian-Pin Hwang: NMR Signal Enhancement Based on Matrix
%       Property Mappings. J. Magn :reson., Ser. A 103 (1993), 109-114
%
%       A. Diop, A. Briguet, D. Graveron-Demilly. Automatic in vivo NMR Data 
%       Processing Based on an Enhancement Procedure and Linear Prediction 
%       Method. Magn. Reson. in Medicine, 27 (1992), 318-328
%
%       Zhu, Guang, Choy, Wing. Y, Song, Guoqiang and Sanctuary, B.C.
%       Suppression of Diagonal Peaks with Singular Value Decomposition.
%       J. MAgn. Reson. 132, 176-178 (1988).

% ULG - 30.4.99
% Copyright (c) U.Günther and C.Ludwig 1999
% NMRLAB 1.0

if nargin==0
  disp('Cadzow filter demo mode.')
  disp('Usage: Nfid = cadzow(fid,signals,M)')
  [fid, spc] = makespc([-155,57,231],500,128,0.14,0.3);
  clear spc
  F = 1/3;
  signals = 3;
elseif nargin~=0 & nargin~=3
  error('Usage: [Nfid, SV] = cadzow(fid,signals,F)')
end

[d1size d2size] = size(fid);
if ~((d1size==1) | (d2size==1))
  error('Input must be a vector')
end

if ~exist('F') 
  F=1/3;
end  
if ~exist('signals')
  signals=3;
end  

fid = fid(:).';

% The 1D fid has already been constructed further up.
N=length(fid);
M=ceil(F*N); 
L = N+1-M;
for k=0:(L-1)				% create Hankel matrix
  X(k+1,:) = fid((1+k):(M+k));
end
% size(X)
[U,S,V] = svd(X);

if signals>0
  s = S(1:signals,1:signals);
  v = V(:,1:signals);
  u = U(:,1:signals);
  x = u*s*v';
elseif signals <=0
  sigs = abs(signals);
  s=S;
  v=V;
  u=U;
  s(1:sigs,1:sigs)=0;  
  % s = S(sigs:L,sigs:L);
  % v = V(:,sigs:L);
  % u = U(:,sigs:L);
  x = u*s*v';
end

% Reconstruct the FID
for k=0:(L-1)
  fid_new((1+k):(M+k)) = x(k+1,:);
end
  
% size(fid_new)

if nargout==0
  clf
% $$$   plot(real(fftshift(fft(X(1,:)))),'r')
% $$$   hold on
% $$$   plot(real(fftshift(fft(x(1,:)))),'b')
% $$$   hold off
% $$$   pause  
  subplot(2,1,1)
  plot(real(fftshift(fft(fid))),'r')     
  hold on
  plot(real(fftshift(fft(fid_new))),'b')
  hold off
  subplot(2,1,2)
  plot(diag(S),'m*-')
  hold on
  plot(diag(s),'g*-')
else
  nfid = fid_new;
  SV   = diag(S);  
end


return
