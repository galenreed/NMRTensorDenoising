function mask = peakDetect(spectrum)
  %
  % the following performs the Dietrich Method for peak detection
  %
  
  
  % this method as-is underestimates the threshold
  % this multiples the threshold at the end
  thesholdScaleFactor = 5;
  
  dSpectrum = diff(spectrum); % derivative
  dSpectrum = dSpectrum .* conj(dSpectrum); % power spectrum  
  thresh = mean(dSpectrum) + 3 * std(dSpectrum);
  numElementsBelowThresh = length(find(dSpectrum < thresh));
  previousNumElementsBelow = numElementsBelowThresh;
  numIterations = previousNumElementsBelow;
  threshTest = -1;
  while(threshTest == -1)
    indsBelowThresh = find(dSpectrum < thresh);
    thresh = mean(dSpectrum(indsBelowThresh)) + 3 * std(dSpectrum(indsBelowThresh));
    numElementsBelowThresh = length(find(dSpectrum < thresh));

    if(numElementsBelowThresh ~= previousNumElementsBelow)
      previousNumElementsBelow = numElementsBelowThresh;
    else
      threshTest = +1;
    end
    disp([num2str(numElementsBelowThresh) 'below thresh']);
  end
  
  mask = zeros(size(dSpectrum));
  mask(find(dSpectrum > 10*thresh)) = max(abs(spectrum));
  
  
  
  figure()
  hold on;
  plot(spectrum);
  plot(mask,'.-')
  
  figure()
  semilogy(dSpectrum);
end  