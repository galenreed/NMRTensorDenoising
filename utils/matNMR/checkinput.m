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
%checkinput.m is used to check user input. Any expression which should result in a valid matrix
%can be checked with this script such that matNMR handles them properly ...
%--> all unnecessary spaces are removed
%--> a check is performed for unacceptable variable names, like e.g. "i"
%
%17-05-'98

function [QTEMP2, QTEMP3] = checkinput(QTEMP1)

QTEMP1 = deblank(fliplr(deblank(fliplr(QTEMP1))));
if (~ exist(QTEMP1, 'var'))
  QTEMP2 = QTEMP1;
				%remove all double spaces
  for QTel=(length(QTEMP2)):-1:2
    if ((QTEMP2(QTel) == ' ') & (QTEMP2(QTel-1) == ' '))
      QTEMP2 = [QTEMP2(1:QTel-1) QTEMP2((QTel+1):length(QTEMP2))];
    end  
  end
end  

%
%now look for all possible characters that could be in an expression that still is valid input
%
QTEMP3 = sort([0 findstr(QTEMP2, ' ') findstr(QTEMP2, ',') findstr(QTEMP2, ':') findstr(QTEMP2, '-') findstr(QTEMP2, '+') ...
               findstr(QTEMP2, '*') findstr(QTEMP2, '/') findstr(QTEMP2, '\') findstr(QTEMP2, '^') ...
	       findstr(QTEMP2, ')') findstr(QTEMP2, '(') findstr(QTEMP2, '.*') (findstr(QTEMP2, '.*') + 1) ...
	       findstr(QTEMP2, ';') findstr(QTEMP2, '[') findstr(QTEMP2, ']') findstr(QTEMP2, '{') findstr(QTEMP2, '}') ...
	       findstr(QTEMP2, '.*') (findstr(QTEMP2, '.*') + 1) (length(QTEMP2)+1) ...
	       findstr(QTEMP2, './') (findstr(QTEMP2, './') + 1) findstr(QTEMP2, '.\') (findstr(QTEMP2, '.\') + 1) ...
	       findstr(QTEMP2, '.^') (findstr(QTEMP2, '.^') + 1)]);

%
%Now we check for variable names that are not acceptable, like e.g. "i" and "j", which are used by Matlab as the
%imaginary units and which are bound to create heaps of problems in matNMR
%
if strcmp(QTEMP2, 'i') | strcmp(QTEMP2, 'j') | strcmp(QTEMP2, 'max')
  error('matNMR WARNING: variable name is a Matlab function and therefore unacceptable to matNMR as it is bound to create problems. Please change the variable name in the workspace!');
end
