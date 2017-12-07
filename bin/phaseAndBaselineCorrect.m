function [processedSpectra] = phaseAndBaselineCorrect(spectra, params)
 ## wrapper function for applying basic NMR processing steps
 ## phase and baseline correction currently applied

  % initialize
  phaseCorrectedSpectra = zeros([params.specPoints, ...
                                 params.timePoints, ... 
                                 params.channels]); 
  baselineCorrectedSpectra = phaseCorrectedSpectra;
  
  for ii = 1:params.channels        
    disp(['processing channel ', num2str(ii)]);
    TFSpectraSingleCoil = spectra(:, :, ii);
    if(params.phaseSensitive)
      if(params.phaseCorrectTimePoints)
        % phase correct each time point individually
        for jj = 1:params.timePoints
          singleSpectra = TFSpectraSingleCoil(:, jj);
          [correctedSpectra, phi0] = phaseCorrect(singleSpectra, params);
          phaseCorrectedSpectra(:, jj, ii) = correctedSpectra;
        end 
      else
        % apply one phase to all time point from one channel
        % this phase is measured from the highest signal time point
        peakTimePoint = find(max(max(abs(TFSpectraSingleCoil))));% 
        highestSNRSpec = TFSpectraSingleCoil(:, peakTimePoint);
        [correctedSpectra, phi0] = phaseCorrect(highestSNRSpec, params);
        TFSpectraSingleCoil = ...
          TFSpectraSingleCoil * exp(-1i * pi * phi0 / 180);
        phaseCorrectedSpectra(:, :, ii) = TFSpectraSingleCoil;
      end
    else % not phase sensitive
      disp('abs');

      for jj = 1:params.timePoints
        singleSpectra = TFSpectraSingleCoil(:, jj);
        phaseCorrectedSpectra(:, jj, ii) = abs(singleSpectra);
      end
    end
    
    % apply baseline correction if applicable
    if(params.baselineCorrect)
    disp(['correcting baseline']);
      for jj = 1:params.timePoints
        singleSpectra = phaseCorrectedSpectra(:, jj, ii);
        phaseCorrectedSpectra(:, jj, ii) = ...
          spectraBaselineCorrection(singleSpectra);
      end 
    end
  end
  processedSpectra = phaseCorrectedSpectra;
end