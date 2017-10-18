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
function f=Diffpk_voigt(x, lam, Gamma, DELTA, delta, tau, alpha, beta);

% f= pk_voigt(x,lam)
% actual function to calculate single Diffusion exponential
% 5-2-94 SMB (Bren@SLAC.stanford.edu)

%
% adapted for matNMR by Jacco van Beek
% 1-1-'97
%

% the T1 function ...
%
% f = C * exp(-gamma^2*1e12 * delta^2 * (DELTA-delta/alpha -tau/beta) * gradient^2 * D)
%

f = lam(1) .* exp(-(Gamma*2*pi)^2*1e12 * delta^2 * (DELTA - delta/alpha - tau/beta) * x.^2 * lam(2));
