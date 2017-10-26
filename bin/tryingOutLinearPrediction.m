clear all;
close all;
addpath('~/Documents/octave/matNMR');
%infile = 'run1_10by10'; 
infile = 'P18432.7'; 
infile = 'P95744.7';


% data are stored in pfile with all phase encodes
% along a single dimension, parse them here
[data header] = rawloadX(infile);
dataSize = size(data);
specPoints = dataSize(1);
timePoints = dataSize(2);
channels = dataSize(5);


%[para]=lpsvd(y,M)

phase = 10 * pi / 180;
testFid = squeeze(data(:,1,1,1,1));

plot(real(fft(testFid)))
%para = lpsvd(testFid,128);
