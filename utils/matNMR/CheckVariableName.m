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
% CheckVariableName(InputString)
%
% checks whether the InputString is a proper name for a workspace variable
% Output: 0 = bad name
%         1 = good name
%
% Jacco van Beek
% 20-03-'03
%

function ret = CheckVariableName(InputString)

%
%First we check for various characters which would exclude the string from being
%a proper variable name
%
QTEMP1 = [];

ForbiddenCharacters = ' :-+=/*;:@~#)(&^%$£"!¬`\|¹²³¼½¾<>.,{}''@¶øþðßæ«»¢µ·üèöéäà';
for tel=1:length(ForbiddenCharacters)
  QTEMP1 = [QTEMP1 findstr(InputString, ForbiddenCharacters(tel))];
end

%
%Check whether the variable is really a string and not just a number. If the string
%evaluates to a matrix then this will be detected here as well.
%
QTEMP2 = str2num(InputString);
QTEMP1 = [QTEMP1 QTEMP2(:)'];

%
%if QTEMP1 is empty then it seems to be a proper string for a variable name. We'll just
%quickly check whether it already exists and then quit the search
%
if isempty(QTEMP1)
  ret = 1;		%good name

else
  ret = 0;		%bad name
end
