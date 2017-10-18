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
% uigetdirBackup
%
% This routine checks whether the uigetdir function is known or not by Matlab.
% As uigetdir was introduced in Matlab 6.5 this doesn't work for older versions
% In that case the uigetfile routine is used and the user must specify any file
% in the requested directory (The uigetfile routine doesn't allow directories
% to be selected).
%
% Jacco van Beek
% 19-03-2004
%

function DirectoryName = uigetdirBackup(StartPath, Title)


  %
  %check the parameters
  %
  if (nargin == 1)
    Title = '';
  elseif (nargin == 0)
    StartPath = '';
    Title = '';
  end


  %
  %does the uigetdir routine exist?
  %
  CheckString = which('uigetdir');
  if ~isempty(CheckString)	%uigetdir is known so we use it
    DirectoryName = uigetdir(StartPath, Title);

  else
    %
    %uigetdir doesn't exist so we revert to uigetfile and instruct the user to select
    %any file from the directory
    %
    disp(' ');
    disp('matNMR NOTICE: the "uigetdir" routine is not available to your version of Matlab.');
    disp('matNMR NOTICE: using the "uigetfile" routine instead: please select any file from');
    disp('matNMR NOTICE: the directory which you want to select!');
    disp(' ');
    
    [FileName, DirectoryName] = uigetfile([StartPath filesep '*.*'], Title);
  end
