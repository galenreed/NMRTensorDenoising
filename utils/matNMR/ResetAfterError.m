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
%ResetAfterError attempts to reset all necessary variables and the axes to prevent
%a forced shutdown of matNMR after an error has occured.
%29-10-'03


try
  %
  %remember the original title of the plot
  %
  QmatNMR.TEMPtitle = get(get(gca, 'title'), 'string');
  
  
  %
  %Recreate the axis in the main figure window
  %
  CreateMainAxes
  
  
  %
  %Set the title to the plot
  %
  title(QmatNMR.TEMPtitle, 'Color', QmatNMR.ColorScheme.AxisFore);
  
  
  %
  %reset figure
  %
  asaanpas
  
  
  %
  %variables to be cleared
  %
  QmatNMR.SwitchTo1D = 0;
  QmatNMR.SingleSlice = 0; 
  QmatNMR.BusyWithMacro = 0;	%reset macro flag just to be sure
  QmatNMR.BREAK = 0;
  
  
  %
  %order the fields names in QmatNMR for easy user access
  %
  QmatNMR = orderfields(QmatNMR);
  
  
  %
  %clear functions and update path just to be sure
  %
  clear functions;
  rehash toolboxreset
  rehash toolboxcache
  rehash path
  
  disp('Reset after error performed ...'); 
  Arrowhead
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
