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
%togglegrid selectively toggles the x-, y- and z-grids
%
%28-05-'98

function ret = togglegrid(var);

if strcmp(var, 'x')
  temp = get(gca, 'xgrid');
  if temp(2) == 'f'
    set(gca, 'xgrid', 'on');
  else
    set(gca, 'xgrid', 'off');
  end

elseif strcmp(var, 'y')
  temp = get(gca, 'ygrid');
  if temp(2) == 'f'
    set(gca, 'ygrid', 'on');
  else
    set(gca, 'ygrid', 'off');
  end

elseif strcmp(var, 'z')
  temp = get(gca, 'zgrid');
  if temp(2) == 'f'
    set(gca, 'zgrid', 'on');
  else
    set(gca, 'zgrid', 'off');
  end
end
