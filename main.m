clear all;
close all;
addpath('bin');
addpath('bin/matNMR');
addpath('bin/tensorlab');
addpath('bin/baselineCorrect');

infile = 'data/spectra1.mat';
load(infile);
dataSize = size(data);

params.phaseSensitive = false;
params.phaseCorrectTimePoints = false; 
params.baselineCorrect = false;
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



sizeLR = [5, 4, 6];
Utrunc{1} = U{1}(:, 1:sizeLR(1));
Utrunc{2} = U{2}(:, 1:sizeLR(2));
Utrunc{3} = U{3}(:, 1:sizeLR(3));
Strunc = S(1:sizeLR(1), 1:sizeLR(2), 1:sizeLR(3));
specsLR = lmlragen(Utrunc, Strunc);

% sum over coils and time points
denoisedSummedCoils = sum(specsLR,3);
denoisedSummedTime = sum(denoisedSummedCoils,2);

originalSummedCoils = sum(abs(spectra),3);
originalSummedTime = sum(originalSummedCoils,2);

figure();
subplot(1,2,1)
plot(real(originalSummedTime))
subplot(1,2,2)
plot(real(denoisedSummedTime))

figure()
subplot(1,2,1)
surf(originalSummedCoils)
subplot(1,2,2)
surf(denoisedSummedCoils)



  


