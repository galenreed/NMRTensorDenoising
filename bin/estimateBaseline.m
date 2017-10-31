function baseline = estimateBaseline(spectrum, mask)
 ##
 ## estimateBaseline uses the whittaker smoothing technique for baseline estimation
 ## inputs: spectrum, the soectrum data (frequency domain)
 ## inputs: mask, the a vector ## inputs: mask, the a vector with ones where peaks are detected, zeroes elsewhere
 ## return: baseline, 
  
% smoothing parameter
lambda = 1e1;
doPlot = true;  
  
% must be made a column vector explicitly in octave, probably doesnt matter in matlab
if(size(spectrum,1) == 1)
  spectrum = spectrum';
end
if(size(mask,1) == 1)
  mask = mask';
end

% invert logical value of mask
maskInv = ones(size(mask)) - mask;

% create the D vector, the finite difference operator
N = length(spectrum);
diagVector = ones([1 N]);
D = diff(diag(diagVector));% operate diff on identity matrix to get D matrix rep
W = diag(maskInv);
matrixMultiplier = inv(W + lambda * D' * D) * W;


baseline = matrixMultiplier * spectrum;

if(doPlot)
  figure();
  hold on;
  plot(spectrum);
  scaledMask = mask * max(abs(spectrum));
  plot(scaledMask,'g-')
  plot(baseline,'r-')
end

end

