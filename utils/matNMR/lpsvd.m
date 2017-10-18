function [para]=lpsvd(y,M)
% LPSVD linear prediction with singular value decomposition
% function [para]=lpsvd(y,M) 
% author: Yung-Ya Lin, 12/11/97 
% reference: R. Kumaresan, D. W. Tufts IEEE Trans. Acoust. Speech Signal Processing 
% vol. ASSP-30, 837-840, 1982. 
% arguments: 
% y: complex vector, NMR FID time series 
% M: real scalar, number of signals or effective matrix rank 
% para: real M*4 matrix, estimated damping factor, frequency, amplitude, phase 

ScalingFactor = max(real(y)); 			%to prevent errors due to huge spectral intensities

y=y(:) / ScalingFactor;

N=length(y);						% # of complex data points in FID 
L=floor(N*3/4);						% linear prediction order L = 3/4*N 
A=hankel(conj(y(2:N-L+1)),conj(y(N-L+1:N)));		% backward prediction data matrix 
h=conj(y(1:N-L));					% backward prediction data vector 

try
  [U,S,V]=svd(A,0);					% singular value decomposition 

  clear A; 
  S=diag(S); 
  bias=mean(S(M+1:min([N-L,L])));				% bias compensation 
  b=-V(:,1:M)*(diag(1./(S(1:M)-bias))*(U(:,1:M)'*h));	% prediction polynomial coefficients 
  s=conj(log(roots([b(length(b):-1:1);1])));		% polynomial rooting 
  s=s(find(real(s)<0));					% extract true signal poles 
  Z=zeros(N,length(s));   
  for k=1:length(s) 
    Z(:,k)=exp(s(k)).^[0:N-1].'; 
  end; 
  a=Z\y;							% linear least squares analysis 
  para=[-real(s) imag(s)/2/pi abs(a) imag(log(a./abs(a)))]; 
  
  
  %
  %protect routine against NaN phases and/or amplitudes
  %
  QTEMP5 = [];
  QTEMP3 = isnan(para);
  for QTEMP4 = 1:size(para, 1)
    if isempty(find(QTEMP3(QTEMP4, :)))
      QTEMP5 = [QTEMP5; QTEMP4];
    end
  end
  if (length(QTEMP3) < size(para, 1))
    disp('LPSVD NOTICE: protecting LP fit against NaN')
    para = para(QTEMP5, :);
  end


  %
  %protect routine against very small amplitudes. Everything smaller than 10^-4 of the sum amplitude is deleted
  %
  QTEMP3 = find( (para(:, 3) > sum(abs(para(:, 3)))/1e4) & (para(:, 3) > 1e-6) );
  if (length(QTEMP3) < size(para, 1))
    disp('LPSVD NOTICE: protecting LP fit against small amplitudes')
    para = para(QTEMP3, :);
  end


  %
  %refuse to accept negative dampening factors (explode in time!)
  %
  %the bit with abs(sign(para(:,2))) is needed to miss out on zero-frequency components that happen to have
  %a (meaningless) negative dampening factor
  %
  QTEMP3 = find( para(:, 1).*abs(sign(para(:, 2))) >= 0 );
  if (length(QTEMP3) < size(para, 1))
    disp('LPSVD NOTICE: protecting LP fit against negative dampening factors')
    para = para(QTEMP3, :);
  end


  %
  %rescale the amplitude back
  %
  para(:, 3) = para(:, 3)*ScalingFactor;

catch
  disp(' matNMR WARNING: SVD needed for linear prediction failed to converge!');
  para = [];
end

