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
%saveoptions.m saves the all matNMR options
%
%7-6-'97, 25-03-'03

try
  %
  %since saveoptions is sometimes called from within a function the variables are redeclared to be
  %global first, since the function will have its own workspace
  %
  global QmatNMRsettings
  
  
  %
  %when working with Matlab 7 or newer store as V6 format!
  %
  QTEMP = version;
  QTEMP = str2num(QTEMP(1:3));
  if (QTEMP >= 7)
    eval(['save -v6 -append ''' QmatNMR.matnmrpath ''' QmatNMRsettings']);
  
  else
    eval(['save -append ''' QmatNMR.matnmrpath ''' QmatNMRsettings']);
  end
  
  disp('All matNMR options have been saved to disk');
  

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
