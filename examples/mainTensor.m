clear all;
close all;
pkg load image;

addpath('../bin');
addpath('../bin/tensorlab');


slices = 109;
inPlaneRes = 256;


imgvol = zeros([inPlaneRes, inPlaneRes, slices]);
flimgv = zeros([inPlaneRes, inPlaneRes, 1, slices]);


% read data
for ii = 1:slices
  fid = fopen(['headMRI/MRbrain.', num2str(ii)]);
  rawData = fread(fid, 'uint16',0,'b');
  img = reshape(rawData, inPlaneRes, inPlaneRes);
  imgvol(:,:,ii) = double(img);
  flimgv(:,:,1,ii) = double(img);
end

peakpixel =  max(max(max(imgvol)));
noiseamp = 0.05 * peakpixel;
noise = noiseamp * randn(size(imgvol));
imgvolnoisy = imgvol + abs(noise);



[U,S,sv] = mlsvd(imgvolnoisy);

figure();
for ii = 1:3
  y = sv{ii};
  subplot(1,3,ii);
  semilogy(y);
end



sizeLR = [170, 170, 90];
Utrunc{1} = U{1}(:, 1:sizeLR(1));
Utrunc{2} = U{2}(:, 1:sizeLR(2));
Utrunc{3} = U{3}(:, 1:sizeLR(3));
Strunc = S(1:sizeLR(1), 1:sizeLR(2), 1:sizeLR(3));
imglr = lmlragen(Utrunc, Strunc);



figure()
sl = 60;
graylims = [1000, peakpixel/1.5];
subplot(1,3,1)
testim = imgvol(:,:,sl)';
testim = imresize(testim, [1000 1000]);
imagesc(testim,graylims);
set(gca,'xtick',[]);
set(gca,'ytick',[]);
colormap('gray')

subplot(1,3,2)
testim = imgvolnoisy(:,:,sl)';
testim = imresize(testim, [1000 1000]);
imagesc(testim,graylims);
set(gca,'xtick',[]);
set(gca,'ytick',[]);
colormap('gray')

subplot(1,3,3)
testim = imglr(:,:,sl)';
testim = imresize(testim, [1000 1000]);
imagesc(testim,graylims);
set(gca,'xtick',[]);
set(gca,'ytick',[]);
colormap('gray')

