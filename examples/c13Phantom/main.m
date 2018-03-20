clear all;
close all;
addpath('../../bin');
addpath('../../bin/tensorlab');

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

spec = fftnc(sortedData);
spec = circshift(spec,round(npe/2), 2);

% optional noising step
spec = spec + ...
  .001 *  max(max(max(abs(spec)))) * ...
  (randn(size(spec)) + 1i * randn(size(spec)));
  

[U,S,sv] = mlsvd(spec);

figure();
for ii = 1:3
  y = sv{ii};
  subplot(1,3,ii);
  semilogy(y);
end


sizeLR = [10, 10, 5];
Utrunc{1} = U{1}(:, 1:sizeLR(1));
Utrunc{2} = U{2}(:, 1:sizeLR(2));
Utrunc{3} = U{3}(:, 1:sizeLR(3));
Strunc = S(1:sizeLR(1), 1:sizeLR(2), 1:sizeLR(3));
imglr = lmlragen(Utrunc, Strunc);





p1i = 58:68;
p2i = 80:89;
p3i = 98:107;
p4i = 120:143;


im = sum(abs(spec),3);
imlr = sum(abs(imglr),3);
figure()
subplot(1,2,1)
imagesc(im)
subplot(1,2,2)
imagesc(imlr)


p1 = sum(abs(spec(:,:,p1i)),3);
p2 = sum(abs(spec(:,:,p2i)),3);
p3 = sum(abs(spec(:,:,p3i)),3);
p4 = sum(abs(spec(:,:,p4i)),3);
figure()
subplot(2,2,1)
imagesc(p1)
subplot(2,2,2)
imagesc(p2)
subplot(2,2,3)
imagesc(p3)
subplot(2,2,4)
imagesc(p4)


p1lr = sum(abs(imglr(:,:,p1i)),3);
p2lr = sum(abs(imglr(:,:,p2i)),3);
p3lr = sum(abs(imglr(:,:,p3i)),3);
p4lr = sum(abs(imglr(:,:,p4i)),3);
figure()
subplot(2,2,1)
imagesc(p1lr)
subplot(2,2,2)
imagesc(p2lr)
subplot(2,2,3)
imagesc(p3lr)
subplot(2,2,4)
imagesc(p4lr)

