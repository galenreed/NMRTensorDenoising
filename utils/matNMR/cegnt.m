function [y,ypure,w,varw]=cegnt(lp,para,sn,randseed)
% function [y,ypure,w,varw]=cegnt(lp,para,sn,randseed)
% ********** function CEGNT.M begin **********
% what: Complex Exponential Generation (CEG) for Numerical Test (NT)
% who:  Yung-Ya Lin
% when: 03/11/94
% ==== arguments ====
% lp: complex time series index vector
% para: spectral parameters, M*4
%       para=[damping factor,frequency,amplitude,phase]
% sn: s/n ratio
% varw: noise variance                      
% randseed: seed for randon number generator
% y: the simulated complex FID with noise 1*N complex
% ypure: the simulated complex FID without noise 1*N complex
% w: normal dist. white noise 1*N complex

% ********** loop sncnt **********
lp=lp(:);
[M,temp]=size(para);
delta=sqrt((sum(para(:,3).^2))/(2*10^(sn/10))); % delta: noise standard deviation
ypure=zeros(size(lp));
ypure=ypure(:);
for ii=1:M
   ss=-para(ii,1)+sqrt(-1)*2*pi*para(ii,2);
   ypure=ypure+(para(ii,3)*exp(ss*lp+sqrt(-1)*para(ii,4))); % FID w/o noise     
end %ii
randn('seed',randseed);
w=delta*randn(size(ypure))*sqrt(-1); % noise
w=w+delta*randn(size(ypure));
y=ypure+w; % y: FID with noise    
varw=std(w).^2;
return
% ********** function CEGNT.M end **********

