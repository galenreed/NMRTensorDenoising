%
%
%
% matNMR v. 3.9.94 - A processing toolbox for NMR/EPR under MATLAB
%
% Copyright (c) 1997-2009  Jacco van Beek
% jabe@users.sourceforge.net
%
%
% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
%
% --> gpl.txt
%
% Should yo be too lazy to do this, please remember:
%    - The code may be altered under the condition that all changes are clearly marked 
%      with your name and the date and that none of the names currently present in the 
%      code are removed.
%
% Furthermore:
%    -Please update the BugFixes.txt (i.e. the changelog file)!
%    -Please inform me of useful changes and annoying bugs!
%
% Jacco
%
%
% ====================================================================================
%
%
function prt=pk_qvtdf(x,f,lam,dp,func)

% function prt=pk_qvtdf(x,f,lam,dp,func)
% calculate partial derivatives of pseudo-voigt
% for use with leasqr.m
% 5-3-94 SMB (Bren@SLAC.stanford.edu)

%
% adapted for matNMR by Jacco van Beek
% 1-1-'97
%

leng=length(lam);
npts=length(x);
npeaks= floor(leng/4);
gu=zeros(npts,4);
fl=zeros(npts,4);
pl=zeros(npts,4);
g=zeros(npts,4);
f=zeros(npts,4);
pld=zeros(npts,1);
pgu=zeros(npts,1);
prt=zeros(npts,4);
for i=1:npeaks,
  base=(i-1)*4;
  gu(:,i)= (x-lam(base+1)) ./(0.600561*lam(base+3));
  fl(:,i)= (x-lam(base+1)) ./(0.5*lam(base+3));
  pl(:,i)= 1+fl(:,i).^2;
  g(:,i) = exp(-gu(:,i).^2);
  f(:,i)= lam(base+2) .*((lam(base+4)./pl(:,i))+((1-lam(base+4)).*g(:,i)));
  pld = (pl(:,i) - 2.*fl(:,i)*lam(base+4))./pl(:,i).^2;
  pgu = 2.*gu(:,i).*(1.-lam(base+4)).*g(:,i);
  prt(:,base+1) = lam(base+2).*(pgu./(0.600561*lam(base+3)) - 2.*pld./lam(base+3));
  prt(:,base+2) = f(:,i)./lam(base+2);
  prt(:,base+3) = lam(base+2).*(gu(:,i).*pgu - fl(:,i).*pld)./lam(base+3);
  prt(:,base+4) = lam(base+2).*(1./pl(:,i) - g(:,i));
end

prt(:,leng-1) = ones(npts,1);		%partial derivative of the background 1
prt(:,leng) = x;			%partial derivative of the slope is x

%
%NOTE: functional = voigt1 + voigt2 + ... + background + slope
%
