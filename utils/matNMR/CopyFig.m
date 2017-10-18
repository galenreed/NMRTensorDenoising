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
%CopyFig is a function that copies the current figure into a new window without taking the
%uicontrols.
%6-3-'98

function CopyFig(FigHandle, Azimuth, Elevation)

  QmatNMR.New = copyobj(FigHandle, 0);

  delete(findobj(get(QmatNMR.New, 'children'), 'type', 'uicontrol'));
  delete(findobj(get(QmatNMR.New, 'children'), 'type', 'uimenu'));
  set(QmatNMR.New, 'resize', 'on', 'units', 'normalized', 'position', [0.005 0.437 0.45 0.45], 'tag', 'CopyFigure', 'closerequestfcn', 'closereq', 'menubar', 'figure');
  set(QmatNMR.New, 'name', 'CopyFig window')
  Rotate3DmatNMR off
  ZoomMatNMR CopyFig off
  QmatNMR.C1 = uimenu('label', '   Close Window   ');
  	uimenu(QmatNMR.C1, 'label', 'Close Window', 'callback', 'close', 'accelerator', 'w');
	
  QmatNMR.C2 = uimenu('label', '   Zoom   ');
  	uimenu(QmatNMR.C2, 'label', 'Zoom', 'callback', 'view(2); Rotate3DmatNMR off; ZoomMatNMR 2D3DViewer');
	
  QmatNMR.C3 = uimenu('label', '   Rotate3D   ');
  	uimenu(QmatNMR.C3, 'label', 'Rotate3D', 'callback', 'Rotate3DmatNMR on');
	
  QmatNMR.C4 = uimenu('label', '   Get Position   ');
  	uimenu(QmatNMR.C4, 'label', 'Get Position', 'callback', 'view(2); ZoomMatNMR 2D3DViewer off; crsshair2d('''', '''')');
  
  QTEMP1 = ['global QmatNMR; figure(QmatNMR.New); matprint;'];
  QmatNMR.C5 = uimenu('label', '   Printing Menu   ');
  	uimenu(QmatNMR.C5, 'label', 'Printing Menu', 'callback', QTEMP1, 'accelerator', 'p');

					%prevent the colorbar from deleting the original one from the original figure
  set(findobj(allchild(QmatNMR.New), 'deletefcn', 'colorbar(''delete'')'), 'deletefcn', '', 'userdata', []);
  set(findobj(allchild(gca), 'tag', 'ColorbarDeleteProxy'), 'userdata', [], 'deletefcn', '');
  
					%prevent legend from being moveable --> this will give error messages
					%because the axis of the plot does not refer to the axis that the legend
					%thinks is belonging to.
					%and who wants the legend to be moveable in a copyfigure anyway?
  QTEMP1 = findobj(findobj(allchild(QmatNMR.New), 'tag', 'legend'), 'type', 'axes');
  set(QTEMP1, 'buttondownfcn', '');
  view([Azimuth Elevation]);

  set(QmatNMR.New, 'buttondownfcn', '');
