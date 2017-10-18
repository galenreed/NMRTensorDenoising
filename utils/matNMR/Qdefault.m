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
%Qdefault.m restores all options to the ones as are saved in the matNMR configuration file.
%
%25-09-'98

try
  figure(QmatNMR.Fig);
  watch
  disp('Busy restoring all default settings ....');
  
  			%close all options menus first
  if ~isempty(QmatNMR.ofig)		%general options menu
    try
      delete(QmatNMR.ofig);
    end
    QmatNMR.ofig = [];
  end
  if ~isempty(QmatNMR.leginp)		%line options menu
    try
      delete(QmatNMR.leginp);
    end
    QmatNMR.leginp = [];
  end
  if ~isempty(QmatNMR.leginp2)		%text options menu
    try
      delete(QmatNMR.leginp2);
    end
    QmatNMR.leginp2 = [];
  end
  if ~isempty(QmatNMR.leginp3)		%screen settings menu
    try
      delete(QmatNMR.leginp3);
    end
    QmatNMR.leginp3 = [];
  end
  if ~isempty(QmatNMR.leginp4)		%font options menu
    try
      delete(QmatNMR.leginp4);
    end
    QmatNMR.leginp4 = [];
  end
  if ~isempty(QmatNMR.leginp5)		%colour scheme menu
    try
      delete(QmatNMR.leginp5);
    end
    QmatNMR.leginp5 = [];
  end
  			
  			%restore default parameters
  setdefaults
  
  disp('Finished. Note that window sizes are not corrected automatically.');
  Arrowhead;

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
