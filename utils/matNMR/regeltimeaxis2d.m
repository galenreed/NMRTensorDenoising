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
%regeltimeaxis2d.m takes care of the input for time axes in a 2D spectrum
%20-02-'04

try
  if QmatNMR.buttonList == 1
    QmatNMR.TimeAxisStartTD2 = eval(QmatNMR.uiInput1);
    QmatNMR.TimeAxisDwellTD2 = eval(QmatNMR.uiInput2);  
    QmatNMR.UserDefAxisT2Cont = QmatNMR.uiInput3;
  
    QmatNMR.TimeAxisStartTD1 = eval(QmatNMR.uiInput4);
    QmatNMR.TimeAxisDwellTD1 = eval(QmatNMR.uiInput5);  
    QmatNMR.UserDefAxisT1Cont = QmatNMR.uiInput6;
  
    QmatNMR.statuspar2d = 4;	%flag for time axes
    scale2d  
  
  else
    disp('Adding time axes aborted !!');
  end

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
