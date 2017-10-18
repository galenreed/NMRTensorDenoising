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
%
%
%
% matNMR v. 3.9.0 - A processing toolbox for NMR/EPR under MATLAB
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
%regelmatlaadSeries.m reads a series of MATLAB files from disk.
%07-11-'01

try
  if (QmatNMR.buttonList == 1)				%OK-button 
    watch;
    disp('Please wait while matNMR is reading the MATLAB files ...');
  
  %
  %retrieve common part of the filename and the range
  %
    QmatNMR.Fname = QmatNMR.uiInput1;
    QTEMP = findstr(QmatNMR.Fname, filesep);		%extract the filename and path depending on the platform
    QmatNMR.Xpath = deblank(QmatNMR.uiInput1(1:QTEMP(length(QTEMP))));
    QmatNMR.Xfilename = deblank(QmatNMR.uiInput1((QTEMP(length(QTEMP))+1):length(QmatNMR.uiInput1)));
    
  
    QmatNMR.FIDRangeIn = QmatNMR.uiInput2;
  
  
    %
    %Now we perform a loop over the range of the file names and execute the lot
    %
    eval(['QTEMP1 = [' QmatNMR.FIDRangeIn '];']);
    eval(['QTEMP2 = [' QmatNMR.FIDRangeOut '];']);
    for QTEMP3 = 1:length(QTEMP1)
      %the file names
      QTEMP4 = strrep(QmatNMR.Fname, '$#$', num2str(QTEMP1(QTEMP3), 10));
  
      load(QTEMP4);
  
      disp([QTEMP4 ' loaded ...']);
    end
    Arrowhead;
  else
    disp('Reading of series of MATLAB files cancelled ...');
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
