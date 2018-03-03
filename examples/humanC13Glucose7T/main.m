clear all;
close all;
addpath('../../bin');
addpath('../../bin/phaseCorrect');
%addpath('../../bin/tensorlab');
%addpath('../../bin/baselineCorrect');
addpath('phillipsFileIO');


% options for phase correction search (if used)
bruteForce = 0;
simplexZeroOrder = 1;
simplexZeroAndFirstOrder = 2;
params.nonNegativePenalty = true;
params.searchMethod = simplexZeroOrder;


f1 = '7T1501_WIP_afterT1_dyn1_9_1_raw_act';
f2 = '7T1501_WIP_afterT2_dyn5_10_1_raw_act';
f3 = '7T1501_WIP_afterT3_dyn5_11_1_raw_act';
         
data1 = mrs_readSDAT(f1);
hdr1 = mrs_readSPAR(f1);
data2 = mrs_readSDAT(f2);
hdr2 = mrs_readSPAR(f2);
data3 = mrs_readSDAT(f3);
hdr3 = mrs_readSPAR(f3);


data = [data1 data2 data3];
DATA = zeros(size(data));
nt = size(data,2);

for ii = 1:nt
  spec = data(:,ii);
  SPEC = fftc(spec);
  DATA(:,ii) = SPEC;
end

n = 1;
[U, S, V] = svd(DATA,'econ');
denoised = DATA * V(:,1:n)*V(:,1:n)';

p1 = abs(DATA * V(:,1)*V(:,1)');
p2 = abs(DATA * V(:,2)*V(:,2)');
p3 = abs(DATA * V(:,3)*V(:,3)');
p4 = abs(DATA * V(:,4)*V(:,4)');

d1 = abs(DATA);
d2 = abs(denoised);

tp = 1;
figure();
subplot(1,2,1)
%plot(d1(:,tp))
plot(sum(d1,2))
title('original, averaged');
subplot(1,2,2)
plot(d2(:,tp))
title('rank 1 approximation');


figure();
subplot(1,2,1)
%plot(d1(:,tp))
plot(d1(:,tp))
title('original');
subplot(1,2,2)
plot(d2(:,tp))
title('rank 1 approximation');


figure()
subplot(1,2,1)
waterfall(d1)
title('original');
subplot(1,2,2)
waterfall(d2)
title('rank 1 approximation');

figure();
semilogy(diag(S))
title('singular vals');




 
