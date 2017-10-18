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
% regelinputbuttonsfidlaadSeries4
%
% tries to set a common part for the variable name in the workspace based on the filename
%
% 26-10-'05

try
  %
  %read the current filename
  %
    QTEMP1 = get(findobj(QmatNMR.uiInputFig, 'tag', '1'), 'string');
  
  %
  %try and determine a reasonable guess for the common part in the workspace
  %
    QTEMP2 = findstr(QTEMP1, '$');
    
    %
    %if no $#$ code is found, or more than 1, then no guess can be made
    %
    if (~isempty(QTEMP2) & (length(QTEMP2) == 2))
      %
      %find file separators around the $range$ code
      %
      QTEMP3 = findstr(QTEMP1, filesep);
      
      %
      %Now make a reasonable guess of the common part
      %
      if isempty(QTEMP3) 			%no file separators found in filename
        QTEMP4 = ['x_' QTEMP1(QTEMP2(1):QTEMP2(2))];
        
      elseif (QTEMP2 < QTEMP3(1)) 	%file separator found after '$range$' code
        QTEMP4 = QTEMP1(1:QTEMP3(1)-1);
      
      elseif (QTEMP2 > QTEMP3(end)) 	%last file separator found before '$range$ code
        QTEMP4 = QTEMP1(QTEMP3(end)+1:end);
        
        if (strcmp(QTEMP4, QTEMP1(QTEMP2(1):QTEMP2(2))) & length(QTEMP3 > 1))
          QTEMP4 = [correctfilename(QTEMP1(QTEMP3(end-1)+1:QTEMP3(end)-1)) '_' QTEMP4];
        end
      
      else 				%'$range$ code sandwiched between two file separators
        QTEMP3 = sort([QTEMP3 QTEMP2]);
        QTEMP4 = QTEMP1( QTEMP3(find(QTEMP3 == QTEMP2(1)) - 1)+1:QTEMP3(find(QTEMP3 == QTEMP2(2)) + 1)-1);
        
        if (strcmp(QTEMP4, QTEMP1(QTEMP2(1):QTEMP2(2))) & (find(QTEMP3 == QTEMP2(1)) > 1))
          QTEMP4 = [correctfilename([QTEMP1( QTEMP3(find(QTEMP3 == QTEMP2(1)) - 2)+1:QTEMP3(find(QTEMP3 == QTEMP2(1)) - 1)-1)]) '_' QTEMP4];
        end
      end
  
      
      %
      %in case the substitution has not worked we prepend an 'x_'
      %
      if strcmp(QTEMP4, QTEMP1(QTEMP2(1):QTEMP2(2)))
        QTEMP4 = ['x_' QTEMP4];
      end
      
      %
      %check whether the first character of the suggested variable name is allowed, if not prepend an 'x'
      %
      QTEMP5 = double(QTEMP4(1));
      if ~(((QTEMP5 >= 65) & (QTEMP5 <= 90)) | ((QTEMP5 >= 97) & (QTEMP5 <= 122)))
        QTEMP4 = ['x' QTEMP4];
      end  
  

      %
      %Now set the reasonable guess
      %
      set(findobj(QmatNMR.uiInputFig, 'tag', '4'), 'string', QTEMP4);
    end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
