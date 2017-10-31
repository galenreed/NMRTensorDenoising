function correctedspectrum = spectraBaselineCorrection(spectrum)
  
  mask = peakDetect(spectrum);
  baseline = estimateBaseline(spectrum, mask);
  correctedspectrum = spectrum - baseline;
  
end