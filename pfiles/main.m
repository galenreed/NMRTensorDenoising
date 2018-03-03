clear all;
close all;
addpath('../bin');
addpath('bin/tensorlab');

infile = 'fov10_46by46';
npe = 46;
specpts = 256;

[data header] = rawloadX(infile);
dataSize = size(data);

sortedData = zeros([npe npe specpts]);


for ii = 1:npe
  for jj = 1:npe
    ind = jj + (ii-1)*npe;
    sortedData(ii,jj,:) = squeeze(data(:,ind));
    
  end
end
 
spec = abs(fftnc(sortedData));
im = sum(spec,3);
imagesc(im) 
 



%
%
%sizeLR = [5, 4, 6];
%Utrunc{1} = U{1}(:, 1:sizeLR(1));
%Utrunc{2} = U{2}(:, 1:sizeLR(2));
%Utrunc{3} = U{3}(:, 1:sizeLR(3));
%Strunc = S(1:sizeLR(1), 1:sizeLR(2), 1:sizeLR(3));
%specsLR = lmlragen(Utrunc, Strunc);
%
%% sum over coils and time points
%denoisedSummedCoils = sum(specsLR,3);
%denoisedSummedTime = sum(denoisedSummedCoils,2);
%
%originalSummedCoils = sum(abs(spectra),3);
%originalSummedTime = sum(originalSummedCoils,2);
%
%figure();
%subplot(1,2,1)
%plot(real(originalSummedTime))
%subplot(1,2,2)
%plot(real(denoisedSummedTime))
%
%figure()
%subplot(1,2,1)
%surf(real(originalSummedCoils))
%subplot(1,2,2)
%surf(real(denoisedSummedCoils))
%
%

  


