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
%regelaxis3d.m takes care of the input for a user-defined axis for the third dimension of a 3D spectrum
%16-09-'06

try
  if QmatNMR.buttonList == 1
    QmatNMR.UserDefAxis = QmatNMR.uiInput1;
    if isempty(QmatNMR.UserDefAxis)
      disp('Changing of axis aborted !!');
      return
    end
    QTEMP = eval(QmatNMR.uiInput1);  
    
    if (length(QTEMP) == QmatNMR.Size3D)
      if ~(isempty(QmatNMR.Q3DOutput))
        %store axis variable in the output variable
        if (isstruct(eval(QmatNMR.Q3DOutput)))	%do we store the 3D as a matNMR structure?
          eval([QmatNMR.Q3DOutput '.AxisTD3 = QTEMP(:)'';']);
          disp('User-defined axis for 3D stored in output variable');
  
        else
          beep
          disp('matNMR NOTICE: output variable not a matNMR structure. Cannot store the axis vector in output variable!');  
        end
      end
  
      if ~(isempty(QmatNMR.Q3DInput2))
        %store axis variable in the input variable
        if (isstruct(eval(QmatNMR.Q3DInput2)))	%do we store the 3D as a matNMR structure?
          eval([QmatNMR.Q3DInput2 '.AxisTD3 = QTEMP(:)'';']);
          disp('User-defined axis for 3D stored in input variable');
  
        else
          disp('matNMR NOTICE: input variable not a matNMR structure. Cannot store the axis vector in input variable!');  
        end
      end
  
      
      %
      %store in history macro
      %
      QTEMP1 = deblank(fliplr(deblank(fliplr(QmatNMR.uiInput1))));			%remove trailing and heading spaces
      QTEMP11 = double(['QmatNMR.uiInput1 = ''' QTEMP1 '''']);
      QTEMP12 = ceil(length(QTEMP11)/(QmatNMR.MacroLength-1));
      QTEMP13 = zeros(1, QTEMP12*(QmatNMR.MacroLength-1));
      QTEMP13(1:length(QTEMP11)) = QTEMP11;
      for QTEMP40=1:QTEMP12
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 711, QTEMP13((QTEMP40-1)*(QmatNMR.MacroLength-1)+ (1:(QmatNMR.MacroLength-1))));
  
        if (QmatNMR.RecordingPlottingMacro)
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 711, QTEMP13((QTEMP40-1)*(QmatNMR.MacroLength-1)+ (1:(QmatNMR.MacroLength-1))));
        end
      end
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 712);	%code for finishing strings
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 301);	%code for axis in 3rd dimension
      if (QmatNMR.RecordingPlottingMacro)
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 712);       		%code for finishing strings
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 301);       		%code for axis in 3rd dimension
      end
  
    else
      beep
      disp('matNMR NOTICE: axis vector is of incorrect length!');  
    end
    
    clear QTEMP*  
  else
    disp('Changing of the axis aborted !!');
  end

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
