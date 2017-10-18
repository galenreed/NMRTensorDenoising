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
%findcurrentfigure.m tries to find the current 2D/3D Viewer window. If the current figure
%does not conform to a 2D/3D Viewer window, then it will check to see if the current
%callback figure points to a 2D/3D viewer window. If not then it will designate a 2D/3D 
%Viewer window to be the current figure.
%05-01-'00
%last changed 12-07-'04

try
  QTEMP1 = get(0, 'children');
  
  %
  %first we check whether the current callback figure points to a 2D/3D viewer window
  %
  QTEMP2 = gcbf;
  if (strcmp(get(QTEMP2, 'tag'), '2D/3D Viewer')) 	%is this a 2D/3D viewer window?
    if (QmatNMR.Fig2D3D == QTEMP2) 	%only activate the figure window if it isn't already the
    				%current 2D/3D viewer window
      return
  
    else
      set(findobj(QmatNMR.Fig2D3D, 'selected', 'on'), 'selected', 'off');	%deselect current axis and figure window
      QmatNMR.Fig2D3D = QTEMP2;
      UpdateFigure;
    end
  
  elseif (~any(QTEMP1 == QmatNMR.Fig2D3D))
  %
  %now we designate a 2D/3D viewer window as the current one
  %
    QmatNMR.Ph = findobj(allchild(0),'tag','2D/3D Viewer');	%designate one of the open 2D/3D Viewer windows
    QmatNMR.Fig2D3D = QmatNMR.Ph(1);
  end
  
  %
  %switch figure if necessary only because this will cause an additional rendering step
  %
  if (gcf ~= QmatNMR.Fig2D3D)
    figure(QmatNMR.Fig2D3D);
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
