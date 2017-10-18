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
%CorrectWindow.m corrects all buttons of the main window when the screen size is too small
%25-08-'99


try
  %
  %SET all uicontrols to the right size
  %
  get(QTEMP1, 'position')
  get(QTEMP1, 'units')
  
  QmatNMR.SETbuttons = get(QTEMP1, 'children');
  QmatNMR.SETnumberbuttons = length(QmatNMR.SETbuttons);
  
  QmatNMR.ChangeTo = QmatNMR.ComputerScreenSize*0.8;
  QmatNMR.ChangeTo(1:2) = [QmatNMR.ComputerScreenSize(3)*0.05 QmatNMR.ComputerScreenSize(4)*0.08];
  QmatNMR.ChangedValue = [QmatNMR.ChangeTo(3)/QmatNMR.ChangeFrom(3) QmatNMR.ChangeTo(4)/QmatNMR.ChangeFrom(4) QmatNMR.ChangeTo(3)/QmatNMR.ChangeFrom(3) QmatNMR.ChangeTo(4)/QmatNMR.ChangeFrom(4)];
  
  for QSETteller = 1:QmatNMR.SETnumberbuttons
    if ((length(get(QmatNMR.SETbuttons(QSETteller), 'type')) == 9) & ( ~strcmp(get(QmatNMR.SETbuttons(QSETteller), 'units'), 'normalized') ))		%This means it's a uicontrol !!! but not with normalized units
      QTEMP = get(QmatNMR.SETbuttons(QSETteller), 'position');
      set(QmatNMR.SETbuttons(QSETteller), 'position', QTEMP .* QmatNMR.ChangedValue);
    end
  end
  
  set(QTEMP1, 'position', QmatNMR.ChangeTo);	%change the figure size to the window size
  drawnow;
  get(QTEMP1, 'position')
  get(QTEMP1, 'units')
  
  QmatNMR.unittype = 1;		%force window to become normalized
  
  clear QSET* QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
