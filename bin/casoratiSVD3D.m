function [ dimg ,U,S,V,newimg] = casoratiSVD3D( img,n)

res = size(img);
newres = [res(1)*res(2) res(3)];
newimg = zeros(newres);
dimg = zeros(res);

for ii = 1:newres(1)
    
    [nx,ny] = ind2sub([res(1) res(2)],ii);
    newimg(ii,:) = squeeze(img(nx,ny,:));
    
end

[U, S, V] = svd(newimg,'econ');

newimgV = newimg * V(:,1:n)*V(:,1:n)';

for ii = 1:newres(1)
    
    [nx,ny] = ind2sub([res(1) res(2)],ii);
    
    dimg(nx,ny,:)= newimgV(ii,:);
end

end