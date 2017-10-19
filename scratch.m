clear all;
close all;
addpath('utils');
addpath('utils/matNMR');
addpath('utils/tensorlab');

phaseSensitive = false;
% set to false for applying same phase correction to all timepoints from a single coil
phaseCorrectTimePoints = true;

infile = 'spectra1.mat';
load(infile);
dataSize = size(data);
specPoints = dataSize(1);
timePoints = dataSize(2);
channels = dataSize(3);

disp("computing FFTs");
specs = zeros(size(data));
for ii = 1:channels
  for jj = 1:timePoints
    fid = squeeze(data(:,jj,ii));
    spec = fftshift(fft(fftshift(fid)));
    specs(:,jj,ii) = spec; 
  end
end

phaseCorrectedSpectra =  zeros(size(specs));
if(~phaseSensitive)
  phaseCorrectedSpectra = abs(specs);% makes life a lot easier
else 
  disp("performing coil-wise phase correction");

  % here we take the highest signal spec from a single channel, estimate its phase
  % then apply that phase to all time points from that channel
  for ii = 1:channels        
    TFSpecSingleCoil = specs(:, :, ii);
    if(~phaseCorrectTimePoints)
      peakTimePoint = find(max(max(abs(TFSpecSingleCoil))));% 
      highestSNRSpec = TFSpecSingleCoil(:, peakTimePoint);
      phi0 = phaseCorrectSpectra(highestSNRSpec);
      TFSpecSingleCoil = TFSpecSingleCoil * exp(-1i * pi * phi0 / 180);
      phaseCorrectedSpectra(:, :, ii) = TFSpecSingleCoil;
    else
      % just run through all time points 
      for jj = 1:timePoints
        singleSpectra = TFSpecSingleCoil(:, jj);
        phi0 = phaseCorrectSpectra(singleSpectra);
        phaseCorrectedSpectra(:, jj, ii) =  singleSpectra * exp(-1i * pi * phi0 / 180);
      end     
    end
  end
end






[U,S,sv] = mlsvd(phaseCorrectedSpectra);

figure();
for ii = 1:3
  y = sv{ii};
  subplot(1,3,ii);
  semilogy(y);
end



sizeLR = [5, 3, 3];
Utrunc{1} = U{1}(:, 1:sizeLR(1));
Utrunc{2} = U{2}(:, 1:sizeLR(2));
Utrunc{3} = U{3}(:, 1:sizeLR(3));
Strunc = S(1:sizeLR(1), 1:sizeLR(2), 1:sizeLR(3));
specsLR = lmlragen(Utrunc, Strunc);

denoised = sum(specsLR,3);
denoised = sum(denoised,2);
regular = sum(phaseCorrectedSpectra,3);
regular = sum(regular,2);

figure();
subplot(1,2,1)
plot(real(regular))
subplot(1,2,2)
plot(real(denoised))



