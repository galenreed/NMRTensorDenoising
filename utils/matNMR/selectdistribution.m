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
%selectdistribution allows changing the matNMR distribution, after which matNMR will restart itself
%Note that the path variable will be temporarily changed
%09-06-2004

try
  XXXXDDDDWWWW1 = which('nmr.m');
  XXXXDDDDWWWW1 = XXXXDDDDWWWW1(1:end-6);
  QmatNMR.Xpath2 = uigetdirBackup(XXXXDDDDWWWW1, 'Choose new directory');
  
  if (QmatNMR.Xpath2 == 0)
    disp('selectdistribution cancelled ...');
    return
  end
  
  %
  %if the new directory contains the file nmr.m then we'll restart matNMR from that directory
  %
  if exist([QmatNMR.Xpath2 filesep 'nmr.m'])
    %
    %change PATH variable -> replaces the current directory from which matNMR is run!
    %
    XXXXDDDDWWWW1 = which('nmr.m');
    XXXXDDDDWWWW1 = XXXXDDDDWWWW1(1:end-6);
    XXXXDDDDWWWW2 = path;
    XXXXDDDDWWWW2 = strrep(XXXXDDDDWWWW2, XXXXDDDDWWWW1, QmatNMR.Xpath2);
  
  
    %
    %stop current matNMR distribution
    %
    QmatNMR.buttonList = 1;
    stopnmr
  
  
    %
    %change PATH
    %
    path(XXXXDDDDWWWW2)
  
  
    %
    %restart matNMR
    %
    nmr
    clear XXXXDDDDWWWW*
  
  else
    disp('matNMR NOTICE: new directory doesn''t seem to contain a matNMR distribution.');
    disp('matNMR NOTICE: please try again!');
    clear XXXXDDDDWWWW*
    selectdistribution
  end

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
