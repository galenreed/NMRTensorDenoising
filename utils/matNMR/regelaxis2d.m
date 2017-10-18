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
%regelaxis2d.m takes care of the input for a user defined axis in a 2D or 3D spectrum
%11-06-'97

try
  if QmatNMR.buttonList == 1
    QTEMP2 = eval(QmatNMR.uiInput1);
    QTEMP1 = eval(QmatNMR.uiInput2);
  
    QmatNMR.x = length(QTEMP2);
    QmatNMR.y = length(QTEMP1);
    
    QmatNMR.UserDefAxisT1Cont = QmatNMR.uiInput2;
    QmatNMR.UserDefAxisT2Cont = QmatNMR.uiInput1;
  
    if (isempty(QmatNMR.UserDefAxisT1Cont) | isempty(QmatNMR.UserDefAxisT2Cont))
      disp('Changing of axis aborted due to an empty input field !!');
      return
    end
  
    if ~((length(QTEMP1) == length(QmatNMR.Axis2D3DTD1)) & (length(QTEMP2) == length(QmatNMR.Axis2D3DTD2)))
      beep
      disp('matNMR ERROR: sizes of user defined vectors do not correspond to matrix size');
    else
      QmatNMR.statuspar2d = 6;	%revert to axis in points
      scale2d  
    end  
  
    clear QTEMP*
  
  else
    disp('Changing of the axis aborted !!');
  end

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
