clear all;
close all;
addpath('bin');
addpath('bin/matNMR');
addpath('bin/tensorlab');


infile = 'data/spectra1.mat';
load(infile);
dataSize = size(data);

params.phaseSensitive = false;
params.phaseCorrectTimePoints = false; 
params.baselineCorrect = true;
params.specPoints = dataSize(1);
params.timePoints = dataSize(2);
params.channels = dataSize(3);

spectra = applyFFTs(data, params);
phaseCorrectedSpectra = phaseAndBaselineCorrect(spectra, params);


[U,S,sv] = mlsvd(phaseCorrectedSpectra);

figure();
for ii = 1:3
  y = sv{ii};
  subplot(1,3,ii);
  semilogy(y);
end



sizeLR = [3, 4, 4];
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




  


