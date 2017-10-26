%function f = entropy_fun(x, s, ref_ph1)
%
% ACME automatic phase correction routine
%
%written by Chen Li
%input:   x - PHC0 and PHC1
%         s - NMR Spectral data
%         ref_ph1 - index for zero first-order phase correction
%output   f - entropy value (Using the first derivative)
%
%
%
% Adapted for matNMR by Jacco van Beek
% october 2006
%
%   NOTE: this routine is decent for spectra without baseline distortions. Such distortions however will screw up
%   the non-negativity penalty. Furthermore, the penalty for negative signals is typically huge because most spectra will not
%   be normalized, whereas the derivative spectrum (used for the entropy) is. This means that non-negativity overwhelmes
%   the entropy if there is any, and this also means that the algorithm will tend to overestimate the first-order
%   phase correction in order to cause a baseline distortion that yields an all-positive signal. Pretty poor I think ...
%
%

function f = ACMEentropy_fun(x, s, ref_ph1)

%initial parameters
stepsize=1;
func_type=1;

%dephase
[N,L]=size(s);
phc0=x(1);
phc1=x(2);

a_num = -((1:L)-ref_ph1)/(L);
s0 = s .* exp(sqrt(-1)*pi/180*(phc0 + phc1*a_num));

s = real(s0);

% Calculation of first derivatives
%if (func_type == 1)
  ds1 = abs((s(3:L)-s(1:L-2))/(stepsize*2));
%else
%  ds1 = ((s(3:L)-s(1:L-2))/(stepsize*2)).^2;
%end
p1 = ds1./sum(ds1);

%Calculation of Entropy
p1(find(p1 == 0)) = 1; 		%in case of ln(0)
h1  = -p1.*log(p1);
H1  = sum(h1);

%Calculation of negativity penalty
Pfun	= 0.0;
as      = s - abs(s);
sumas   = sum(as);
%figure(2); cla; hold off; plot(s, 'r'); hold on; plot(as, 'b'); drawnow

if (sumas < 0)
   Pfun = Pfun + sum(as.^2)/4/L/L;
end
P       = 1000*Pfun;

% The value of objective function

f = H1+P;
