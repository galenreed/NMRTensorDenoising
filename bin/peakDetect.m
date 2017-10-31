function mask = peakDetect(spectrum)
  ##
  ## peakDetect performs the Dietrich Method for peak detection
  ## inputs: spectrum, the soectrum data (frequency domain)
  ## return: mask, the a vector with ones where peaks are detected, zeroes elsewhere
  
  % this method as-is underestimates the threshold
  % this multiples the threshold at the end
  thesholdScaleFactor = 5;
  
  doPlot = false;
  
  % derivative the starting point of this method is the power spectrum of the derivative
  dSpectrum = diff(spectrum); 
  dSpectrum = dSpectrum .* conj(dSpectrum); 
  
  
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
    %disp([num2str(numElementsBelowThresh) 'below thresh']);
  end
  
  mask = zeros(size(dSpectrum));
  mask(find(dSpectrum > thesholdScaleFactor*thresh)) = 1;  
  mask = [mask; 0]; % make the same size as spec since diff reduces it
  
  if(doPlot)
    figure()
    hold on;
    plot(spectrum);
    plot(mask,'.-')
  
    figure()
    semilogy(dSpectrum);
  end
end  