clear all;
close all;
addpath('utils');
addpath('utils/matNMR');
addpath('utils/tensorlab');

infile = 'spectra1.mat';
load(infile);
dataSize = size(data);
specPoints = dataSize(1);
timePoints = dataSize(2);
channels = dataSize(3);

% run through all the matrix and do FFTs
specs = zeros(size(data));
for ii = 1:channels
  for jj = 1:timePoints
    fid = squeeze(data(:,jj,ii));
    spec = fftshift(fft(fftshift(fid)));
    specs(:,jj,ii) = (spec);    
  end
end


testspec = specs(:,1,1);
phi0 = phaseCorrectSpectra(testspec);
phased = testspec * exp(-1i * phi0 * pi / 180);
plot(real(phased))




#{
[U,S,sv] = mlsvd(specs);

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
regular = sum(specs,3);
regular = sum(regular,2);

figure();
subplot(1,2,1)
plot(real(regular))
subplot(1,2,2)
plot(real(denoised))
#}


