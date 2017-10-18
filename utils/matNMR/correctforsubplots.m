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
%correctforsubplots allows some default actions to be taken when working with large
%numbers of subplots in a 2D/3D viewer window. Things like axis labels and titles and
%tick labels can typically be left away. Also font settings could be changed, etc.
%
%28-07-'04

try
  if (QmatNMR.ContNrSubplots > 25)
    %no tick labels when larger than 5x5
    set(QmatNMR.AxisHandle2D3D, 'xticklabel', '', 'yticklabel', '', 'zticklabel', '')
  
    %no axis labels when larger than 5x5
    QTEMP9 = get(QmatNMR.AxisHandle2D3D, 'xlabel');
    if iscell(QTEMP9)
      QTEMP9 = cell2mat(QTEMP9);
    end
    set(QTEMP9, 'string', '');
  
    QTEMP9 = get(QmatNMR.AxisHandle2D3D, 'ylabel');
    if iscell(QTEMP9)
      QTEMP9 = cell2mat(QTEMP9);
    end
    set(QTEMP9, 'string', '');
  
    QTEMP9 = get(QmatNMR.AxisHandle2D3D, 'zlabel');
    if iscell(QTEMP9)
      QTEMP9 = cell2mat(QTEMP9);
    end
    set(QTEMP9, 'string', '');
  end
  
  if (QmatNMR.ContNrSubplots >= 36)
    %no titles when larger than 6x6
    QTEMP9 = get(QmatNMR.AxisHandle2D3D, 'title');
    if iscell(QTEMP9)
      QTEMP9 = cell2mat(QTEMP9);
    end
    set(QTEMP9, 'string', '');
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
