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
%RunMacroStepwise.m controls the stepwise execution of processing macro's.
%
%The function works as a shell around RunMacro.m. For each step in the macro the user
%has to choose whether to perform it or to ignore it and proceed to the next step.
%A temporary macro of 1 action is then defined and passed on to the RunMacro.m
%
%08-09-'00

try
  %
  %QTEMP9 is the status variable for the specific action that needs to be done
  %
  if (QTEMP9 == 0)				%start up the routine
    %
    %Store the current window from which the routine was started
    %
    QmatNMR.StepwiseWindow = gcf;
    
    %
    %store the macro in another variable
    %
    QmatNMR.StepWiseExecutingMacro = QmatNMR.ExecutingMacro;	%first save the total macro in this variable
    
    %
    %First we have to analyse the given macro and determine how many steps it has etc.
    %
    QmatNMR.StepWiseText = '';				%this variable contains all information of all actions in the macro
    QmatNMR.StepWiseNumbering = 1;			%this variable keeps track of how many lines in the original macro are taken
    						%by the current step.
    QmatNMR.StepWiseTempNumber = 0;
    QmatNMR.StepWiseProcessNumber = 2;			%which is the current step? (the first is always empty!)
    QmatNMR.TEMPUserCommandString = '';
  
    
    %
    %start analyzing ...
    %
    AnalyseMacro
    QmatNMR.StepWiseNRSteps = size(QmatNMR.StepWiseText, 1);	%how many steps are there in the macro?
    
    
    %
    %Now open or create the window for the stepwise processing and we're finished
    %
    if (QmatNMR.FigureStepwise)
      figure(QmatNMR.FigureStepwise);
    
    else  
      QmatNMR.FigureStepwise = figure('Pointer', 'Arrow', 'Units', 'Pixels', 'Position', [115  48 920 200], 'Numbertitle', 'off', 'Resize', 'on', ...
                    'backingstore', 'on', 'Visible', 'on', 'closerequestfcn', 'delete(QmatNMR.FigureStepwise); QmatNMR.FigureStepwise=0;', ...
                    'menubar', 'none', ...
    	          'renderer', 'painters', 'Name', 'Stepwise processing of macro''s', 'tag', 'StepwiseProcessor', 'color', QmatNMR.ColorScheme.Figure1Back);
  
    %
    %To work around a Matlab bug (see BugFixes.txt, 11-05-'04) we redefine the position and units.
    %
    set(QmatNMR.FigureStepwise, 'units', 'pixels', 'position', [115  48 920 200]);
    		
      uicontrol('Style', 'Pushbutton', 'Position', [  9  10 150  30], 'String', 'Close', 'callback', 'delete(QmatNMR.FigureStepwise); QmatNMR.FigureStepwise=0;', 'BackgroundColor', QmatNMR.ColorScheme.Button3Back, 'ForegroundColor', QmatNMR.ColorScheme.Button3Fore);
      uicontrol('Style', 'Pushbutton', 'Position', [197  10 150  30], 'String', 'Perform Step', 'callback', 'QTEMP9 = 1; RunMacroStepwise', 'BackgroundColor', QmatNMR.ColorScheme.Button4Back, 'ForegroundColor', QmatNMR.ColorScheme.Button4Fore); 
      uicontrol('Style', 'Pushbutton', 'Position', [385  10 150  30], 'String', 'Skip Step', 'callback', 'QTEMP9 = 2; RunMacroStepwise', 'BackgroundColor', QmatNMR.ColorScheme.Button5Back, 'ForegroundColor', QmatNMR.ColorScheme.Button5Fore); 
      uicontrol('Style', 'Pushbutton', 'Position', [573  10 150  30], 'String', 'Perform All Steps', 'callback', 'QTEMP9 = 3; RunMacroStepwise', 'BackgroundColor', QmatNMR.ColorScheme.Button1Back, 'ForegroundColor', QmatNMR.ColorScheme.Button1Fore); 
      uicontrol('Style', 'Pushbutton', 'Position', [761  10 150  30], 'String', 'New Macro', 'callback', 'figure(QmatNMR.StepwiseWindow); askexecutemacro', 'BackgroundColor', QmatNMR.ColorScheme.Button1Back, 'ForegroundColor', QmatNMR.ColorScheme.Button1Fore); 
      
      QmatNMR.SW1 = uicontrol('Style', 'Pushbutton', 'Position', [ 10 170 900  30], 'horizontalalignment', 'left', 'BackgroundColor', QmatNMR.ColorScheme.Button14Back, 'ForegroundColor', QmatNMR.ColorScheme.Button14Fore);
      QmatNMR.SW2 = uicontrol('Style', 'Pushbutton', 'Position', [ 10 140 900  30], 'horizontalalignment', 'left', 'BackgroundColor', QmatNMR.ColorScheme.Button12Back, 'ForegroundColor', QmatNMR.ColorScheme.Button12Fore);
      QmatNMR.SW3 = uicontrol('Style', 'Pushbutton', 'Position', [ 10 110 900  30], 'horizontalalignment', 'left', 'BackgroundColor', QmatNMR.ColorScheme.Button12Back, 'ForegroundColor', QmatNMR.ColorScheme.Button12Fore);
      QmatNMR.SW4 = uicontrol('Style', 'Pushbutton', 'Position', [ 10  80 900  30], 'horizontalalignment', 'left', 'BackgroundColor', QmatNMR.ColorScheme.Button12Back, 'ForegroundColor', QmatNMR.ColorScheme.Button12Fore);
      QmatNMR.SW5 = uicontrol('Style', 'Pushbutton', 'Position', [ 10  50 900  30], 'horizontalalignment', 'left', 'BackgroundColor', QmatNMR.ColorScheme.Button12Back, 'ForegroundColor', QmatNMR.ColorScheme.Button12Fore);
      
      set(allchild(QmatNMR.FigureStepwise), 'units', 'normalized');
      set(QmatNMR.FigureStepwise, 'units', 'normalized', 'position', [0.1962 0.0711 0.7986 0.2222]);
    end
    %
    %Now this part of the routine is finished. The user must now push the buttons to invoke reprocessing
    %
  
  elseif (QTEMP9 == 1) 				%perform step
    %
    %A single step must be performed now. First we define it and then we pass it on to the
    %RunMacro.m
    %
    %in case of a 2D processing step we must first set the dimension-specific parameters.
    %We first detect how many of such lines are present and add that to the macro
    %
    QmatNMR.NRdimspecific = 0;
    QTEMP11 = 0; 		%temporary counter
    QTEMP12 = 0; 		%temporary counter
    while (QTEMP11 ~= QmatNMR.StepWiseNumbering(QmatNMR.StepWiseProcessNumber))	%do this loop until QmatNMR.StepWiseNumbering(QmatNMR.StepWiseProcessNumber)
    								%of non-dimension-specific processing steps have been found
      QTEMP12 = QTEMP12 + 1;
      
      if ((QmatNMR.StepWiseExecutingMacro(1+QTEMP12, 1) == 400) | (QmatNMR.StepWiseExecutingMacro(1+QTEMP12, 1) == 401))
        QmatNMR.NRdimspecific = QmatNMR.NRdimspecific + 1;
      else
        QTEMP11 = QTEMP11 + 1;
      end
    end
  
    figure(QmatNMR.StepwiseWindow);
    QmatNMR.ExecutingMacro = AddToMacro;
    QmatNMR.ExecutingMacro(2:(1+QmatNMR.StepWiseNumbering(QmatNMR.StepWiseProcessNumber)+QmatNMR.NRdimspecific), :) = QmatNMR.StepWiseExecutingMacro(2:(1+QmatNMR.StepWiseNumbering(QmatNMR.StepWiseProcessNumber)+QmatNMR.NRdimspecific), :);
    QmatNMR.StepWiseExecutingMacro = [QmatNMR.StepWiseExecutingMacro(1, :); QmatNMR.StepWiseExecutingMacro(2+QmatNMR.StepWiseNumbering(QmatNMR.StepWiseProcessNumber)+QmatNMR.NRdimspecific:size(QmatNMR.StepWiseExecutingMacro,1), :)];
  
    RunMacro
    
    QmatNMR.StepWiseProcessNumber = QmatNMR.StepWiseProcessNumber + 1;
  
  elseif (QTEMP9 == 2)				%skip current step
    %
    %Normally in case of a 2D processing step we must first set the dimension-specific parameters.
    %So we first detect how many of such lines are present and add that to the macro
    %
    QmatNMR.NRdimspecific = 0;
    QTEMP11 = 0; 		%temporary counter
    QTEMP12 = 0; 		%temporary counter
    while (QTEMP11 ~= QmatNMR.StepWiseNumbering(QmatNMR.StepWiseProcessNumber))	%do this loop until QmatNMR.StepWiseNumbering(QmatNMR.StepWiseProcessNumber)
    								%of non-dimension-specific processing steps have been found
      QTEMP12 = QTEMP12 + 1;
      
      if ((QmatNMR.StepWiseExecutingMacro(1+QTEMP12, 1) == 400) | (QmatNMR.StepWiseExecutingMacro(1+QTEMP12, 1) == 401))
        QmatNMR.NRdimspecific = QmatNMR.NRdimspecific + 1;
      else
        QTEMP11 = QTEMP11 + 1;
      end
    end
  
    QmatNMR.StepWiseExecutingMacro = [QmatNMR.StepWiseExecutingMacro(1, :); QmatNMR.StepWiseExecutingMacro((2+QmatNMR.StepWiseNumbering(QmatNMR.StepWiseProcessNumber)+QmatNMR.NRdimspecific):size(QmatNMR.StepWiseExecutingMacro,1), :)];
    QmatNMR.StepWiseProcessNumber = QmatNMR.StepWiseProcessNumber + 1;
  
  elseif (QTEMP9 == 3)				%perform all remaining steps
    %
    %A single step must be performed now. First we define it and then we pass it on to the
    %RunMacro.m
    %
    figure(QmatNMR.StepwiseWindow);
    QmatNMR.ExecutingMacro = QmatNMR.StepWiseExecutingMacro;
    RunMacro
    
    QmatNMR.StepWiseProcessNumber = QmatNMR.StepWiseNRSteps + 1;
  
  end
  
  %
  %Now fill the edit buttons with the appropriate steps ...
  %
  regelstepwisebuttons
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
