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
%LinearAxis.m checks whether a certain vector has a constant directional coefficient
%output: 1=linear axis, 0=non-linear axis.
%23-03-'99

function ret = LinearAxis(Axis, Precision)

  if (nargin == 1)		%as diff is an approximation it is possible that even though an
    Precision = 1e-9;		%axis is linear elements are 1e-11. Therefore this precaution...
  end
  
  if (any(imag(Axis)))		%Axis is a complex vector for some fucked up reason
    ret = ~(any(abs(diff(real(Axis), 2)) > Precision));

  else  
    ret = ~(any(abs(diff(Axis, 2)) > Precision));
  end  
