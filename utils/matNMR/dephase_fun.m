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
function sp_dp = dephase_fun(sp_ft,phc0,phc1,ref_ph1)
%function sp_dp = dephase_fun(sp_ft,phc0,phc1)
%written by Chen Li 
%input:   sp_ft - complex data after fourier transform
%         phc0  - the zero order phase correction
%         phc1  - the first order phase correction
%         ref_ph1 - reference point for zero first-order phase correction
%output:  sp_dp - spectral data after phase correction
%
%
%Adapted for use in matNMR by Jacco van Beek
%october 9 2006
%

[m,n]=size(sp_ft);
a_num = -((1:n)-ref_ph1)/(n);
sp_dp = sp_ft .* exp(sqrt(-1)*pi/180*(phc0 + phc1*a_num));
