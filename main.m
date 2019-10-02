clear all;
close all;
addpath('bin');
addpath('tensorlab');

infile = 'data/fov10_46by46';
numPhaseEncodes = 46;
spectraPoints = 256;
addedNoiseAmplitude = 0;


% the data here are 2D CSI of a multi-chambe 13C phantom
% this section reads the data and parses it into (x,y,f)
[data header] = rawloadX(infile);
dataSize = size(data);
sortedData = zeros([numPhaseEncodes numPhaseEncodes spectraPoints]);
for ii = 1:numPhaseEncodes
  for jj = 1:numPhaseEncodes
    ind = jj + (ii-1)*numPhaseEncodes;
    sortedData(ii,jj,:) = squeeze(data(:,ind));
    
  end
end
spec = fftnc(sortedData);
spec = circshift(spec, [0 round(numPhaseEncodes/2)]);


% these are the indices of the individual spectral components
% plot the sum over all voxels to show the spectra of the phantom
p1i = 58:68;
p2i = 80:89;
p3i = 98:107;
p4i = 120:143;
figure();
plot(squeeze(sum(sum(abs(spec), 1), 2)))
title('spectra of all voxels')



% optional step of adding extra noise
% (set addedNoiseAmplitude > 0)
spec = spec + ...
  addedNoiseAmplitude *  max(max(max(abs(spec)))) * ...
  (randn(size(spec)) + 1i * randn(size(spec)));
  
% call the tensorlab higherorder svd
[U,S,sv] = mlsvd(spec);


% this plots the ordered singular values for each dimension (3 in this case)
figure();
for ii = 1:3
  y = sv{ii};
  subplot(1,3,ii);
  semilogy(y);
  title(['\sigma for dim ' int2str(ii)])
end

% truncate the singular vals, and recunstruct the low rank image 
% the following vector determines the number of retained singular vals, 
% and thus the extent of compression 
sizeLR = [10, 10, 5];
Utrunc{1} = U{1}(:, 1:sizeLR(1));
Utrunc{2} = U{2}(:, 1:sizeLR(2));
Utrunc{3} = U{3}(:, 1:sizeLR(3));
Strunc = S(1:sizeLR(1), 1:sizeLR(2), 1:sizeLR(3));
imglr = lmlragen(Utrunc, Strunc);




% plot images, summed over all spectra
im = sum(abs(spec),3);
imlr = sum(abs(imglr),3);
figure()
subplot(1,2,1)
imagesc(im)
title('original')
subplot(1,2,2)
imagesc(imlr)
title('low rank')


p1 = sum(abs(spec(:,:,p1i)),3);
p2 = sum(abs(spec(:,:,p2i)),3);
p3 = sum(abs(spec(:,:,p3i)),3);
p4 = sum(abs(spec(:,:,p4i)),3);
figure()
subplot(2,2,1)
imagesc(p1)
title('freq1, orig')
subplot(2,2,2)
imagesc(p2)
title('freq2, orig')
subplot(2,2,3)
imagesc(p3)
title('freq3, orig')
subplot(2,2,4)
imagesc(p4)
title('freq4, orig')


p1lr = sum(abs(imglr(:,:,p1i)),3);
p2lr = sum(abs(imglr(:,:,p2i)),3);
p3lr = sum(abs(imglr(:,:,p3i)),3);
p4lr = sum(abs(imglr(:,:,p4i)),3);
figure()
subplot(2,2,1)
imagesc(p1lr)
title('freq1, lowrank')
subplot(2,2,2)
imagesc(p2lr)
title('freq2, lowrank')
subplot(2,2,3)
imagesc(p3lr)
title('freq3, lowrank')
subplot(2,2,4)
imagesc(p4lr)
title('freq4, lowrank')


