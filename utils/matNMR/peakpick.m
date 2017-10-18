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
%peakpick.m lets the user define boxes from which the maximum of that area is taken as a peak.
%a very basic peak picking routine ...
%23-07-'98

try
  QmatNMR.MouseButton = 0;
  
  if (any(get(gca,'view')==[0 90]))
    ZoomMatNMR 2D3DViewer off;		%disable the zoom function
    set(QmatNMR.c10, 'value', 0);
    QTEMP2 = get(QmatNMR.Fig2D3D, 'userdata');
    QTEMP2.Zoom = 0;
    set(QmatNMR.Fig2D3D, 'userdata', QTEMP2);
  end;  
  
  view(2);			%make sure it is in 2D view --> turn rotate3d off !
  Rotate3DmatNMR off;
  set(QmatNMR.c16, 'value', 0);
  
  set(gcf, 'Pointer', 'crosshair');
  
  			%initialize peak-picking routine, QTEMP1 is set in matNMR2DButtons
  if (QTEMP1 == 1)	%pick peacks but don't draw lines ...
    disp('Peak Picking started, no lines between peaks will be drawn. Use left button to define peaks');
    disp('the middle button to delete the last peak in the last and the right button to stop the routine');
    GetPeaks('QmatNMR.Spec2D3D', ['[1 ' num2str(QmatNMR.PeakPickSearchDir) ']'], 1);
    
  else			%pick peaks and draw lines between the peaks
    disp('Peak Picking started, between all peaks lines will be drawn! Use left button to define peaks');
    disp('the middle button to delete the last peak in the last and the right button to stop the routine');
    GetPeaks('QmatNMR.Spec2D3D', ['[2 ' num2str(QmatNMR.PeakPickSearchDir) ']'], 1);
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
