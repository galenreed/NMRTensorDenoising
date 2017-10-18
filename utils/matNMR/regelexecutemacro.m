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
%regelexecutemacro.m executes a macro
%24-03-'99

try
  if (QmatNMR.buttonList == 1)
    QTEMP2 = gcf;
  
    if isempty(QmatNMR.uiInput1)
      disp('Execute macro was cancelled ...');
      return
    end  
  
    QmatNMR.LastMacroVariable = QmatNMR.uiInput1;
    QmatNMR.ExecutingMacro = eval(QmatNMR.LastMacroVariable);
    try
      if isstruct(QmatNMR.ExecutingMacro)
        if isfield(QmatNMR.ExecutingMacro, 'HistoryMacro')
          QmatNMR.ExecutingMacro = CorrectMacro(QmatNMR.ExecutingMacro.HistoryMacro, QmatNMR.MacroLength);
        else
          beep
          disp('matNMR WARNING: variable is a structure without field called "HistoryMacro". Aborting ...');
          return
        end  
      else
        QmatNMR.ExecutingMacro = CorrectMacro(QmatNMR.ExecutingMacro, QmatNMR.MacroLength);
      end
    catch
      beep
      disp('matNMR WARNING: there seems to be a problem with the macro. Please check your input. Aborting ...');
      return
    end
    QTEMP1 = size(QmatNMR.ExecutingMacro);
  
    if (QTEMP1(1) == 1)
      disp('matNMR WARNING: Macro is empty!');
    else
      %
      %we must check whether there are processing actions in the macro if the current
      %window is NOT the main window
      %
      if (QTEMP2 ~= findobj(0, 'tag', 'matNMRmainwindow'))
        if ~isempty(find(QmatNMR.ExecutingMacro(2:end, 1) < 700))
          disp('matNMR NOTICE: macro contains processing actions and may only be started from the main window!');
  	return
        end
      end
      
      %
      %All clear to run the macro ...
      %
      if (QmatNMR.StepWise)		%stepwise reprocessing of the macro has been requested.
      				%this means the user can at this point choose whether it wants
    				%to perform this step or not
        QTEMP9 = 0;	%flag for initialization
        RunMacroStepwise
      else
        tic
        RunMacro
        QmatNMR.Timing = toc;
        disp(['Finished executing macro "' QmatNMR.LastMacroVariable '". Execution time (including rendering) was ' num2str(QmatNMR.Timing, 6) ' seconds']);
      end
    end
  
  else
    disp('Execute macro was cancelled ...');
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
