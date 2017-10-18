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
%makenew2D3D creates a new 2D/3D viewer window
%
%06-09-2004

try
  %
  %Deselect all axes in the current window
  %
  set(findobj(QmatNMR.Fig2D3D, 'selected', 'on'), 'selected', 'off');
  
  %
  %remember the current figure-window handle and the colorbar status
  %
  QmatNMR.Fig2D3Dold = QmatNMR.Fig2D3D;
  QmatNMR.TempValue = get(QmatNMR.c19, 'value');
  QmatNMR.TempValue2 = QmatNMR.CurrentColorMap;
  
  %
  %Make a new figure window
  %
  matNMR2DButtons
  
  %
  %Use the same number of subplots as were in the previous current window
  %
  if (length(QmatNMR.ContSubplots) > 1)
    Subplots(QmatNMR.Fig2D3D, QmatNMR.ContSubplots(1), QmatNMR.ContSubplots(2:end))
  else
    Subplots(QmatNMR.Fig2D3D, QmatNMR.ContSubplots)
  end
  
  %
  %Set the colour map in the new window the same as in the previous window
  %
  set(QmatNMR.Fig2D3D, 'colormap', get(QmatNMR.Fig2D3Dold, 'colormap'));
  QmatNMR.CurrentColorMap = QmatNMR.TempValue2;
  QTEMP2 = get(gcf, 'userdata');
  QTEMP2.ColorMap = QmatNMR.CurrentColorMap;
  set(gcf, 'userdata', QTEMP2);
  
  %
  %Set the colour bar status in the new window the same as in the previous window,
  %but ONLY when only 1 subplot is present
  %
  if (QmatNMR.ContSubplots == 1)
    QmatNMR.buttonList = 1;
    QmatNMR.uiInput1 = QmatNMR.TempValue;
    QmatNMR.uiInput2 = 0; 
    QmatNMR.uiInput3 = 1; 
    contcbar
  end
  
  %
  %update some variables
  %
  UpdateFigure
  
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
