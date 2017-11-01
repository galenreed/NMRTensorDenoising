function [DATA] = applyFFTs(data, params)
  ## this currently just FFTs the frequency dimension
  ## in general we need to FFT each dimension aside from time and coils
  
  disp("computing FFTs");
  DATA = zeros([params.specPoints params.timePoints params.channels]);
  for ii = 1:params.channels
    for jj = 1:params.timePoints
      fid = squeeze(data(:,jj,ii));
      spec = fftshift(fft(fftshift(fid)));
      DATA(:,jj,ii) = spec;  
    end
  end
end