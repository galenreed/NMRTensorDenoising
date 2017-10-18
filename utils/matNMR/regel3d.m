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
%regel3d.m takes care of the choices possible for loading a 3D FID or spectrum in the UIcontrol
%in the 3D panel for the main window
%07-07-'04

try
  QTEMP1 = gco;	%as there are two buttons which could lead into this routine (main window and 3D window!) we determine which one we're looking at right now
  QTEMP1 = get(QTEMP1, 'value');
  %reset both buttons
  set(QmatNMR.h53, 'Value', 1);
  if (QmatNMR.fig3D)
    set(QmatNMR.but3D1, 'Value', 1);
  end
  
  if ~(QTEMP1 == 1)
    if ~isempty(QmatNMR.LastVariableNames3D(QTEMP1-1).Spectrum)
      QmatNMR.Spec3DName = QmatNMR.LastVariableNames3D(QTEMP1-1).Spectrum;
      QmatNMR.UserDefAxisT2Main = QmatNMR.LastVariableNames3D(QTEMP1-1).AxisTD2;
      QmatNMR.UserDefAxisT1Main = QmatNMR.LastVariableNames3D(QTEMP1-1).AxisTD1;
    end
  end
  
  QmatNMR.ask = 3;			%flag
  askname;			%load a new 3D spectrum
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
