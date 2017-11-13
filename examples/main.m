clear all;
close all;
pkg load image;

addpath('../bin');


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



[ dimg,U,S,V,newimg] = casoratiSVD3D( imgvolnoisy, 20);



figure()
semilogy(diag(S))

slice = 50;
figure()
subplot(1,3,1)
imagesc(imgvol(:,:,slice)',[0 peakpixel/1.7]);
colormap('gray');
set(gca,'xtick',[]);
set(gca,'ytick',[]);

subplot(1,3,2)
imagesc(imgvolnoisy(:,:,slice)',[0 peakpixel/1.7]);
colormap('gray');
set(gca,'xtick',[]);
set(gca,'ytick',[]);
subplot(1,3,3)
imagesc(dimg(:,:,slice)',[0 peakpixel/1.7]);
colormap('gray');
set(gca,'xtick',[]);
set(gca,'ytick',[]);


%testSlice = 60;
%testIm =imgVol(:,:,testSlice)';
%[u,s,v] = svd(testIm);
%figure()
%imagesc(testIm)
%colormap('gray')

%figure()
%semilogy(diag(s))
