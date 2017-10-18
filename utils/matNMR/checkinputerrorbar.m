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
%checkinputerrorbar.m is used to check user input for the variable name given in the input
%window for making an error bar plot (main window). Any expression which should result in a 
%valid matrix can be checked with this script such that matNMR handles them properly ...
%--> the expression is checked for its variables: if they are structures the var.Spectrum will be
%evaluated
%
%07-07-'04

try
  for QTEMP40 = length(QmatNMR.CheckInput):-1:2
    QTEMP2 = deblank(fliplr(deblank(fliplr(QmatNMR.Q1DErrorBars2((QmatNMR.CheckInput(QTEMP40-1)+1):(QmatNMR.CheckInput(QTEMP40)-1))))));
  
    %
    %check the expression for existing variables
    %
    %This piece checks whether the string QTEMP2 is a variable in the workspace. If this is not so then it performs a second
    %check to see whether the string is in fact an element of a structure (or series of structures). The result is stored in the
    %flag variable QTEMP41
    %
    QTEMP41 = 0;
    if (exist(QTEMP2, 'var'))
      QTEMP41 = 1;
  
    else
      QTEMP42 = findstr(QTEMP2, '.');	%if this is an element of a structure then a '.' must be present at least once
      if isempty(QTEMP42) 						%the string QTEMP2 does not point to a field into a structure
        QTEMP41 = 0;
  
      else
        QTEMP42 = sort([0 QTEMP42 length(QTEMP2)+1]); 			%the positions of '.' in the string QTEMP2
  
        QTEMP44 = QTEMP2( (QTEMP42(1)+1):(QTEMP42(2)-1) );		%this should be the name of the structure in the workspace
        try
          QTEMP46 = eval(QTEMP44);
        catch
          beep
          disp('matNMR WARNING: specified input did not produce correct output. Please recheck ...');
          QmatNMR.BREAK = 1;
          return
        end
  
        if (isa(QTEMP46, 'struct'))
          for QTEMP43 = 2:(length(QTEMP42)-1)
            QTEMP45 = QTEMP2( (QTEMP42(QTEMP43)+1):(QTEMP42(QTEMP43+1)-1) );
            if ~isfield(QTEMP46, QTEMP45) 				%there is no field in the structure by this name (error follows later)
              QTEMP41 = 0;
              break
            else 								%so far so good, this field exists in the structure
  
              QTEMP41 = 1;
            end
  
            QTEMP44 = [QTEMP44 '.' QTEMP45]; 				%this should be the name of the structure embedded in a structure
            try
              QTEMP46 = eval(QTEMP44);
            catch
              beep
              disp('matNMR WARNING: specified input did not produce correct output. Please recheck ...');
              QmatNMR.BREAK = 1;
              return
            end
          end
        else 								%there is no structure in the workspace by this name (error follows later)
  
          QTEMP41 = 0;
        end
      end
    end
  
  
    %
    %if the string is a variable then we check it out
    %
    if (QTEMP41)
      if ~ strcmp(QTEMP2, ':')
  
    				%check whether the variable is a structure
        if (isa(eval(QTEMP2), 'struct'))
          QmatNMR.Q1DErrorBars2 = [QmatNMR.Q1DErrorBars2(1:(QmatNMR.CheckInput(QTEMP40)-1)) '.Spectrum' QmatNMR.Q1DErrorBars2((QmatNMR.CheckInput(QTEMP40)):length(QmatNMR.Q1DErrorBars2))];
        end
      end
    end
  end    
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
