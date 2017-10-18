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
%regelexecutemacro3d.m executes a macro for an entire 3D (series of 2D's)
%07-07-'04

try
  if (QmatNMR.buttonList == 1)
    QTEMP2 = gcf;
  
    %
    %reset the flag for processing a macro on a 3D
    %
    QmatNMR.BusyWithMacro3D = 0;
  
    if isempty(QmatNMR.uiInput1)
      disp('Execute macro for 3D was cancelled ...');
      return
    end  
  
    QmatNMR.LastMacroVariable = QmatNMR.uiInput1;
    QmatNMR.ExecutingMacro3D = eval(QmatNMR.LastMacroVariable);
  
  
    try
      if isstruct(QmatNMR.ExecutingMacro3D)
        if isfield(QmatNMR.ExecutingMacro3D, 'HistoryMacro')
          QmatNMR.ExecutingMacro3D = CorrectMacro(QmatNMR.ExecutingMacro3D.HistoryMacro, QmatNMR.MacroLength);
  
        else
          beep
          disp('matNMR WARNING: variable is a structure without field called "HistoryMacro". Aborting ...');
          return
        end  
  
      else
        QmatNMR.ExecutingMacro3D = CorrectMacro(QmatNMR.ExecutingMacro3D, QmatNMR.MacroLength);
      end
  
    catch
      beep
      disp('matNMR WARNING: there seems to be a problem with the macro. Please check your input. Aborting ...');
      return
    end
  
    QmatNMR.ExecutingMacro = QmatNMR.ExecutingMacro3D;
    QTEMP1 = size(QmatNMR.ExecutingMacro);
  
    if (QTEMP1(1) == 1)
      disp('matNMR WARNING: Macro is empty!');
  
    else	%run the macro for all 2D's in the 3D
      %
      %set the flag for processing a macro on a 3D
      %
      QmatNMR.BusyWithMacro3D = 1;
  
      %
      %just to be sure we empty the output variable
      %
      if ~isempty(QmatNMR.Q3DOutput)
        if (isstruct(eval(QmatNMR.Q3DOutput)))	%is the output variable a matNMR structure?
          eval([QmatNMR.Q3DOutput '.Spectrum = [];']);
        
        else
          eval([QmatNMR.Q3DOutput ' = [];']);
        end
      end
      
      %
      %loop over all 2D's
      %
      %
      QmatNMR.Timing = 0;
      tic
      
        %reset the UI control for the index counter
      QmatNMR.Q3DIndex = 1;
      set(QmatNMR.but3D7, 'string', QmatNMR.Q3DIndex);
  
        %make sure the main window is the current one
      Arrowhead
      figure(QmatNMR.Fig)
  
        %load the current 2D into matNMR
      QmatNMR.Spec1DName = [QmatNMR.Q3DInput2 '(' num2str(QmatNMR.Q3DIndex) ', :, :)'];
      [QmatNMR.Spec1DName, QmatNMR.CheckInput] = checkinput(QmatNMR.Spec1DName);%adjust the format of the input expression for later use
      makenew2D
  
        %run the macro on the first 2D
      QmatNMR.ExecutingMacro = QmatNMR.ExecutingMacro3D;
      RunMacro
      if (QmatNMR.RulerXAxis == 0)
        GetDefaultAxis
      end
      
      QTEMP1 = toc;
      disp(['Finished executing macro "' QmatNMR.LastMacroVariable '" on 2D. Execution time (including rendering) was ' num2str(QTEMP1-QmatNMR.Timing, 6) ' seconds']);
      QmatNMR.Timing = QTEMP1;
  
        %store the current 2D into the 3D and go to the next
      for Q3DIndexCount = 2:QmatNMR.Size3D
        QmatNMR.Q3DNewIndex = QmatNMR.Q3DIndex + 1;
        QmatNMR.Q3DLastType = 0; 	%read from input variable
        view2d
        QmatNMR.ExecutingMacro = QmatNMR.ExecutingMacro3D;
  
        RunMacro
        if (QmatNMR.RulerXAxis == 0)
          GetDefaultAxis
        end
        QTEMP1 = toc;
        disp(['Finished executing macro "' QmatNMR.LastMacroVariable '" on 2D. Execution time was (including rendering) ' num2str(QTEMP1-QmatNMR.Timing, 6) ' seconds']);
        QmatNMR.Timing = QTEMP1;
      end
  
        %store the last spectrum in the 3D
      QmatNMR.Q3DNewIndex = QmatNMR.Q3DIndex + 1;
      QmatNMR.Q3DLastType = 1; 	%read from output variable
      view2d
      QmatNMR.BusyWithMacro3D = 0;
  
      %
      %update the screen
      %
      asaanpas
  
      QmatNMR.Timing = toc;
      disp(['Finished executing macro "' QmatNMR.LastMacroVariable '" on entire 3D. Total execution time (including rendering) was ' num2str(QmatNMR.Timing, 6) ' seconds']);
    end
  
  else
    disp('Execute macro for 3D was cancelled ...');
  end
  
  clear QTEMP* Q3DIndexCount

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
