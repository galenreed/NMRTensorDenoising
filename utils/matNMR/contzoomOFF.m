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
%contzoomOFF switches off the zoom and rotate3D functions in the 2D/3D viewer window
%and sets the view to [0 90], so that other function aren't bothered by those previous
%settings
%
%04-05-2004

try
  %
  %switch figure if necessary only because this will cause an additional rendering step
  %
  if (gcf ~= QmatNMR.Fig2D3D)
    figure(QmatNMR.Fig2D3D);
  end
  
  view(2);			%make sure it is in 2D view --> turn rotate3d off !
  
  Rotate3DmatNMR off;
  set(QmatNMR.c16, 'value', 0);
  
  if (get(QmatNMR.c10, 'value') == 1)		%if zoom is on --> turn off !
    set(QmatNMR.c10, 'value', 0);
    ZoomMatNMR 2D3DViewer off
  end;  
  
  QTEMP1 = get(QmatNMR.Fig2D3D, 'userdata');
  QTEMP1.Zoom = 0;
  QTEMP1.Rotate3D = 0;
  set(QmatNMR.Fig2D3D, 'userdata', QTEMP1);
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
