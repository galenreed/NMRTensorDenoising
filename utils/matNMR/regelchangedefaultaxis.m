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
%regelchangedefaultaxis changes the default settings for the x-axis to a 
%new value
%14-10-2003

try
  %
  %set the new values but do not save them in the matnmroptions. This must
  %be done from the general options menu
  %
  if (QmatNMR.DefaultAxisSwitch == 0)	%user wants to change the default axis for the time domain
    if (QmatNMR.Dim == 2) 		%TD1
      QmatNMRsettings.DefaultRulerXAxis2TIME = QmatNMR.DefaultAxisType;
  
    else				%TD2 and 1D
      QmatNMRsettings.DefaultRulerXAxis1TIME = QmatNMR.DefaultAxisType;
    end
  
  else 					%user wants to change the default axis for the frequency domain
    if (QmatNMR.Dim == 2) 		%TD1
      QmatNMRsettings.DefaultRulerXAxis2FREQ = QmatNMR.DefaultAxisType;
  
    else				%TD2 and 1D
      QmatNMRsettings.DefaultRulerXAxis1FREQ = QmatNMR.DefaultAxisType;
    end
  end
  
  %
  %if the current axis is a default axis then reset the plot
  %
  if (QmatNMR.RulerXAxis == 0)
    asaanpas
  
  else
    updatebuttons
  end

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
