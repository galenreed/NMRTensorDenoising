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
%AddToMacro.m
%
%adds an entry to a matNMR macro.
%
%22-03-'99

function ret = AddToMacro(Macro, var1, var2, var3, var4, var5, var6, var7, var8, var9, var10, var11, var12, var13, var14, var15, var16, var17, var18, var19, var20)

  global QmatNMR
  if ~isfield(QmatNMR, 'MacroLength')
    QmatNMR.MacroLength = 15;
  end

  QTEMP = nargin;
  
  if (QTEMP == 0)               %create new macro if no arguments are given
    ret = zeros(1, QmatNMR.MacroLength);
    
  else
                                %If so then the total length of all parameters may not
                                %be more than 10 else it will be cut off

    for QTEMP40=QTEMP:20		%make unused parameters zero!
      eval(['var' num2str(QTEMP40) ' = 0;']);
    end

				%add the new line to the macro
    QTEMP2 = [var1];
    for QTEMP40 = 2:QmatNMR.MacroLength
      eval(['QTEMP2 = [QTEMP2 var' num2str(QTEMP40) '];'])
    end
    ret = [Macro; QTEMP2(1:QmatNMR.MacroLength)];
  end  
