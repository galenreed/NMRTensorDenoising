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
function prt = Diffpk_qvtdf(x,f,lam,dp,func)

% function prt = Diffpk_qvtdf(x,f,lam,dp,func)
% calculate partial derivatives of the diffusion 
% exponential function.
% for use with Diffleasqr.m
% 5-3-94 SMB (Bren@SLAC.stanford.edu)

%
% adapted for matNMR by Jacco van Beek
% 1-1-'97
%

global QmatNMR

leng = length(lam);		%How many parameters to fit ?
npts = length(x);		%How many points in the data array ?
npeaks = floor((leng-2)/2);	%How many exponentials to fit ?

prt=zeros(npts,leng);		%Resulting output (first derivative to each parameter

for i=1:npeaks,
  base=(i-1)*2;

  prt(:,base+1) = lam(leng) * exp(-(2*pi*QmatNMR.DiffGamma)^2*1e12 * QmatNMR.Diffdelta^2 * (QmatNMR.DiffDELTA - QmatNMR.Diffdelta/QmatNMR.Diffalpha - QmatNMR.Difftau/QmatNMR.Diffbeta) * x.^2 * lam(base+2));
  prt(:,base+2) = lam(base+1) .* prt(:, base+1) .* (-(2*pi*QmatNMR.DiffGamma)^2*1e12 * QmatNMR.Diffdelta^2 * (QmatNMR.DiffDELTA - QmatNMR.Diffdelta/QmatNMR.Diffalpha - QmatNMR.Difftau/QmatNMR.Diffbeta) * x.^2);
end

prt(:,leng-1) = lam(leng)*ones(npts,1);	%Partial derivative of the constant is 1*amplitude

prt(:, leng) = zeros(npts, 1);		%partial derivative of the amplitude is the whole exponential + background
for i=1:npeaks
  base=(i-1)*2;

  prt(:, leng) = prt(:, leng) + (lam(base+1) .* exp(-(2*pi*QmatNMR.DiffGamma)^2*1e12 * QmatNMR.Diffdelta^2 * (QmatNMR.DiffDELTA - QmatNMR.Diffdelta/QmatNMR.Diffalpha - QmatNMR.Difftau/QmatNMR.Diffbeta) * x.^2 * lam(base+2)));
end
prt(:, leng) = prt(:, leng) + lam(leng-1);  
