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
processedSpectra = phaseAndBaselineCorrect(spectra, params);


  


