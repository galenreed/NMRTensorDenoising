clear all;
close all;

addpath('~/Documents/octave/NMRTensorDenoising/bin');
addpath('~/Documents/octave/WhittakerSmootherBaseline');
addpath('~/Documents/octave/NMRTensorDenoising/data');

%infile = 'run1_10by10'; 
infile = 'P18432.7'; 
%infile = 'P95744.7';


% data are stored in pfile with all phase encodes
% along a single dimension, parse them here
[data header] = rawloadX(infile);
dataSize = size(data);
specPoints = dataSize(1);
timePoints = dataSize(2);
channels = dataSize(5);

%%take mag of each spectra
magTimeSeries = zeros([specPoints timePoints channels]);
magSOS = zeros([specPoints timePoints]);
for ii = 1:timePoints
  sosVector = zeros([specPoints 1]);
  for jj =1:channels
    fid = squeeze(data(:,ii,1,1,jj));
    FID = abs(fftshift(fft(fftshift(fid))));
    %FID = spectraBaselineCorrection(FID);
    magTimeSeries(:,ii,jj) = FID;
    sosVector = sosVector + FID .* FID;
  end  
  magSOS(:,ii) = sqrt(sosVector);
end


% svd denoise
n = 5;
[U, S, V] = svd(magSOS,'econ');
magSOSD = magSOS * V(:,1:n) * V(:,1:n)';


summedSpec = sum(magSOS,2);
summedSpecD = sum(magSOSD,2);

figure();
subplot(1,2,1);
plot(summedSpec);

title('original');
subplot(1,2,2);
plot(summedSpecD)
    
title('svd denoise');

figure()
semilogy(diag(S))
    
%figure();
%subplot(1,2,1);
%surf(magSOS);    
%zlim([1 5e8]);   
%title('original');
%   
%subplot(1,2,2);
%surf(magSOSD);    
%zlim([1 5e8]);       
%title('svd denoise');


%phaseCorrection = 120*pi/180;
%data = data * exp(-1i * phaseCorrection);
%plot(real(fft(data(:,1,1,1,5))))








