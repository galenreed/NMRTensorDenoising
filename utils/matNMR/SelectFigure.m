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
%SelectFigure.m defines a buttondown-function for the current figure that makes it selected.
%06-01-'00

try
  					%In the following line the current figure is taken from the
  					%fact whether the current window in which the mouse pointer is
  					%located is a 2D/3D Viewer window. If not, then this criterium
  					%is not used and a previous definition of QmatNMR.Fig2D3D must be
  					%presented.
  QTEMP = get(0, 'pointerwindow');
  if (QTEMP ~= QmatNMR.Fig2D3D)
    QmatNMR.cntrsOld = QmatNMR.Fig2D3D;
    if (strcmp(get(QTEMP, 'tag'), '2D/3D Viewer'))
      QmatNMR.Fig2D3D = QTEMP;
    
    elseif (strcmp(get(QmatNMR.Fig2D3D, 'tag'), ''))
      findcurrentfigure
    end
    set(findobj(QmatNMR.cntrsOld, 'selected', 'on'), 'selected', 'off');
    
    UpdateFigure
  
  else
    %unless the right mouse button was the last button pressed, then we show that the current axis is selected
    QTEMP1 = get(gcf, 'SelectionType');
    if ~strcmp(QTEMP1,'alt')
      set(QmatNMR.AxisHandle2D3D, 'selected', 'on');
    end
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
