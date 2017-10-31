function correctedspectrum = spectraBaselineCorrection(spectrum)
  
  mask = peakDetect(spectrum);
  baseline = estimateBaseline(spectrum, mask);
  
end