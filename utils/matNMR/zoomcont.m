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
%zoomcont.m allows the user to zoom in a certain part of the contour plot.
%21-2-1997

try
  %uses an older zoom function from matlab 5.3. Only in ZoomMatNMR the values for the axes are adjusted when
  %the user defines an area to be zoomed into.
  %
  %switch figure if necessary only because this will cause an additional rendering step
  %
  if (gcf ~= QmatNMR.Fig2D3D)
    figure(QmatNMR.Fig2D3D);
  end
  
  QTEMP1 = get(QmatNMR.Fig2D3D, 'userdata');
  QmatNMR.AllAxes = findobj(QmatNMR.Fig2D3D, 'type', 'axes');
  for QTEMP2 = 1:length(QmatNMR.AllAxes)
    QmatNMR.AxesNR = get(QmatNMR.AllAxes(QTEMP2), 'userdata');
      
    if ~isempty(QmatNMR.AxesNR)
      set(QmatNMR.AllAxes(QTEMP2), 'view', [0 90]);	%make sure it is in 2D view --> turn rotate3d off !
    end	  
  end
  Rotate3DmatNMR off;
  set(QmatNMR.c16, 'value', 0);
  QTEMP1.Rotate3D = 0;
  
  ZoomMatNMR 2D3DViewer;

  if (QTEMP1.Zoom)			%zoom is on, now turn off
    set(QmatNMR.c10, 'value', 0);
    QTEMP1.Zoom = 0;
    set(QmatNMR.Fig2D3D, 'keypressfcn', 'SelectFigure', 'buttondownfcn', 'SelectFigure');
  
  else					%zoom is now off, turn on
    set(QmatNMR.c10, 'value', 1);
    QTEMP1.Zoom = 1;
  end
  
  set(QmatNMR.Fig2D3D, 'userdata', QTEMP1);
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
