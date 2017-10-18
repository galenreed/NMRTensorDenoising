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
%regeloutput3d deals with changing the name of the output variable in 3D mode in the main
%window
%07-07-'04

try
  QmatNMR.Q3DOutput = fliplr(deblank(fliplr(deblank(get(QmatNMR.but3D5, 'string'))))); 	%the new name
  
  %
  %create an empty 3D as we don't know yet what size the final spectrum will be
  %
  if isempty(QmatNMR.Q3DOutput)
    disp('matNMR NOTICE: without output variable the current 2D will not be stored!')
  
  else
    if (CheckVariableName(QmatNMR.Q3DOutput))	%check if the variable name makes sense
      %check whether the variable already exists
      if (exist(QmatNMR.Q3DOutput) == 1)
        if (strcmp(QmatNMR.Q3DInput2, QmatNMR.Q3DOutput))
          beep
          disp('matNMR WARNING: Variable name for output of 3D matrix is the same as the input variable!');
          disp('matNMR WARNING: Please change the name if this is not wanted in order to avoid errors and loss of data.');
        else
          beep
          disp('matNMR WARNING: Variable name for output of 3D matrix already exists in the workspace.');
          disp('matNMR WARNING: Please change the name if this is not wanted in order to avoid errors and loss of data.');
        end
  
      else
        if (isstruct(eval(QmatNMR.Q3DInput2)))
          eval([QmatNMR.Q3DOutput ' = ' QmatNMR.Q3DInput2 ';']);
          eval([QmatNMR.Q3DOutput '.Spectrum = [];']);
        
        else
          eval([QmatNMR.Q3DOutput ' = GenerateMatNMRStructure;']);
          eval([QmatNMR.Q3DOutput '.Spectrum = [];']);
        end
        disp(['matNMR NOTICE: New variable name "' QmatNMR.Q3DOutput '" allocated for output of 3D matrix']);
      end
  
    else
      disp('matNMR WARNING: illegal variable name given for storage in workspace. Please correct');
      QmatNMR.Q3DOutput = '';
      set(QmatNMR.but3D5, 'string', QmatNMR.Q3DOutput);
    end
  
  
    %
    %Add the variable to the list of 10 last-used 3D variables
    %
    QmatNMR.newinlist.Spectrum = QmatNMR.Q3DOutput;	%define the name of the variable and axis vector
    QmatNMR.newinlist.AxisTD2 = '';		%for putinlist3d.m
    QmatNMR.newinlist.AxisTD1 = '';
    putinlist3d;				%put name in list of last 10 variables if it is new
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
