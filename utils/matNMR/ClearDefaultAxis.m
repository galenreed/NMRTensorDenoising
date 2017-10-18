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
%ClearDefaultAxis
%
%clears any old reference values used by the default axis
%
%26-07-'04

try
  if (QmatNMR.Dim == 0) 	%1D mode
    QmatNMR.RulerXAxis  = 0;	%flip to default axis setting
    QmatNMRsettings.DefaultAxisReferencekHz= 0; 		%1D mode
    QmatNMRsettings.DefaultAxisReferencePPM= 0;		%1D mode
    QmatNMRsettings.DefaultAxisCarrierIndex = floor(QmatNMR.Size1D/2)+1;
  
  else 			%2D mode
    QmatNMR.RulerXAxis  = 0;	%flip to default axis setting
    QmatNMR.RulerXAxis1 = 0;	%flip to default axis setting
    QmatNMR.RulerXAxis2 = 0;	%flip to default axis setting
  
    QmatNMRsettings.DefaultAxisCarrierIndex1 = floor(QmatNMR.SizeTD2/2)+1;
    QmatNMRsettings.DefaultAxisReferencekHz= 0; 		%1D mode
    QmatNMRsettings.DefaultAxisReferencekHz1= 0; 	%TD2
    QmatNMRsettings.DefaultAxisReferencekHz2= 0; 	%TD1
  
    QmatNMRsettings.DefaultAxisCarrierIndex2 = floor(QmatNMR.SizeTD1/2)+1;
    QmatNMRsettings.DefaultAxisReferencePPM= 0;		%1D mode
    QmatNMRsettings.DefaultAxisReferencePPM1= 0; 	%TD2
    QmatNMRsettings.DefaultAxisReferencePPM2= 0;		%TD1
  end

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
