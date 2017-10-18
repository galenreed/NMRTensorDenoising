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
%regellims.m sets the xlim, ylim and zlim properties for the current axis
%15-12-'98

try
  if QmatNMR.buttonList == 1			%OK-button
    QTEMP20 = gca;	%the current axis
    QTEMP21 = gcf; 	%the current figure window
  
    QTEMP1 = eval(['[' QmatNMR.uiInput1 ']']);	%xlim
    QTEMP2 = eval(['[' QmatNMR.uiInput2 ']']);	%ylim
    QTEMP3 = eval(['[' QmatNMR.uiInput3 ']']);	%zlim
  
  
    %
    %Add an entry to the plotting macro if we're recording one
    %
    if (QmatNMR.RecordingPlottingMacro)
      %
      %first store the list of selected regular axes unless none were selected
      %
      QTEMP11 = 0;
      QmatNMR.AllAxes = findobj(findobj(QTEMP21, 'type', 'axes', 'tag', 'RegularAxis'), 'selected', 'on');
      if ~isempty(QmatNMR.AllAxes)     %only store if at least 1 axis is selected
        QTEMP11 = length(QmatNMR.AllAxes);
        QTEMP12 = ceil(QTEMP11/(QmatNMR.MacroLength-1));
        QTEMP13 = zeros(1, QTEMP12*(QmatNMR.MacroLength-1));
        QTEMP14 = get(QmatNMR.AllAxes, 'userdata');
        if iscell(QTEMP14)
          QTEMP14 = cell2mat(QTEMP14);
        end
        QTEMP13(1:QTEMP11) = QTEMP14;
        for QTEMP40=1:QTEMP12
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 710, QTEMP13((QTEMP40-1)*(QmatNMR.MacroLength-1)+ (1:(QmatNMR.MacroLength-1))));
        end
      end
  
  
      %
      %then store the input strings
      %
      QTEMP11 = double(['QmatNMR.uiInput1 = ''[' QmatNMR.uiInput1 ']''']);
      QTEMP12 = ceil(length(QTEMP11)/(QmatNMR.MacroLength-1));
      QTEMP13 = zeros(1, QTEMP12*(QmatNMR.MacroLength-1));
      QTEMP13(1:length(QTEMP11)) = QTEMP11;
      for QTEMP40=1:QTEMP12
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 711, QTEMP13((QTEMP40-1)*(QmatNMR.MacroLength-1)+ (1:(QmatNMR.MacroLength-1))));
      end
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 712);
  
      QTEMP11 = double(['QmatNMR.uiInput2 = ''[' QmatNMR.uiInput2 ']''']);
      QTEMP12 = ceil(length(QTEMP11)/(QmatNMR.MacroLength-1));
      QTEMP13 = zeros(1, QTEMP12*(QmatNMR.MacroLength-1));
      QTEMP13(1:length(QTEMP11)) = QTEMP11;
      for QTEMP40=1:QTEMP12
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 711, QTEMP13((QTEMP40-1)*(QmatNMR.MacroLength-1)+ (1:(QmatNMR.MacroLength-1))));
      end
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 712);
  
      QTEMP11 = double(['QmatNMR.uiInput3 = ''[' QmatNMR.uiInput3 ']''']);
      QTEMP12 = ceil(length(QTEMP11)/(QmatNMR.MacroLength-1));
      QTEMP13 = zeros(1, QTEMP12*(QmatNMR.MacroLength-1));
      QTEMP13(1:length(QTEMP11)) = QTEMP11;
      for QTEMP40=1:QTEMP12
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 711, QTEMP13((QTEMP40-1)*(QmatNMR.MacroLength-1)+ (1:(QmatNMR.MacroLength-1))));
      end
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 712);
  
  
      %
      %Finally we store the processing action
      %
      QTEMP12 = get(get(QTEMP20, 'parent'), 'userdata');	%to allow extraction of the subplot code
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 737, QTEMP12.SubPlots, QmatNMR.uiInput1a, QmatNMR.uiInput2a, QmatNMR.uiInput3a, QmatNMR.uiInput4);
    end
  
  
    %
    %Perform the action
    %
    if (QmatNMR.uiInput4 == 1)				%only change selected axes
      QmatNMR.AllAxes = findobj(findobj(QTEMP21, 'type', 'axes'), 'selected', 'on');
      if isempty(QmatNMR.AllAxes)
        QmatNMR.AllAxes = QTEMP20;
      end
    
      for QTEMP4 = 1:length(QmatNMR.AllAxes)
        QmatNMR.AxesNR = get(QmatNMR.AllAxes(QTEMP4), 'userdata');
      
        if ~isempty(QmatNMR.AxesNR)
          if QmatNMR.uiInput1a
            set(QmatNMR.AllAxes(QTEMP4), 'xlim', sort(QTEMP1));
          end
          if QmatNMR.uiInput2a
            set(QmatNMR.AllAxes(QTEMP4), 'ylim', sort(QTEMP2));
          end
          if QmatNMR.uiInput3a
            set(QmatNMR.AllAxes(QTEMP4), 'zlim', sort(QTEMP3));
          end
        end	  
      end
      
      %
      %make sure only the current axis is selected, if there are more than one axes in the list
      %
      QmatNMR.AllAxes = findobj(findobj(QTEMP21, 'type', 'axes'), 'selected', 'on');
      if (length(QmatNMR.AllAxes) > 0)
        set(QmatNMR.AllAxes, 'selected', 'off');
        set(QmatNMR.AxisHandle2D3D, 'selected', 'on');
        %axes(QmatNMR.AxisHandle2D3D);
        set(QTEMP21, 'currentaxes', QmatNMR.AxisHandle2D3D);
      end
  
      if (~QmatNMR.BusyWithMacro)
        drawnow
      end
  
      disp('Axis limits manually changed for selected axes ...');
  
  
    elseif (QmatNMR.uiInput4 == 2) 		%apply to all subplots
      QmatNMR.AllAxes = findobj(QTEMP21, 'type', 'axes', 'tag', 'RegularAxis');
    
      for QTEMP4 = 1:length(QmatNMR.AllAxes)
        QmatNMR.AxesNR = get(QmatNMR.AllAxes(QTEMP4), 'userdata');
      
        if ~isempty(QmatNMR.AxesNR)
          if QmatNMR.uiInput1a
            set(QmatNMR.AllAxes(QTEMP4), 'xlim', sort(QTEMP1));
          end
          if QmatNMR.uiInput2a
            set(QmatNMR.AllAxes(QTEMP4), 'ylim', sort(QTEMP2));
          end
          if QmatNMR.uiInput3a
            set(QmatNMR.AllAxes(QTEMP4), 'zlim', sort(QTEMP3));
          end
        end	  
      end
      
      %
      %make sure only the current axis is selected, if there are more than one axes in the list
      %
      QmatNMR.AllAxes = findobj(findobj(QTEMP21, 'type', 'axes'), 'selected', 'on');
      if (length(QmatNMR.AllAxes) > 0)
        set(QmatNMR.AllAxes, 'selected', 'off');
        set(QmatNMR.AxisHandle2D3D, 'selected', 'on');
        %axes(QmatNMR.AxisHandle2D3D);
        set(QTEMP21, 'currentaxes', QmatNMR.AxisHandle2D3D);
      end
  
      if (~QmatNMR.BusyWithMacro)
        drawnow
      end
  
      disp('Axis limits manually changed for all axes ...');
      
  
    elseif (QmatNMR.uiInput4 == 3) 		%apply to the current row of subplots
      QmatNMR.AllAxes = findobj(findobj(QTEMP21, 'type', 'axes', 'tag', 'RegularAxis'), 'selected', 'on');
      if isempty(QmatNMR.AllAxes)
        QmatNMR.AllAxes = QTEMP20;
      end
      %
      %demand that at most 1 subplot is selected
      %
      if (length(QmatNMR.AllAxes) > 1)
        disp('matNMR WARNING: only 1 subplot may be selected to work on the current row');
        asklims
        return
      end
      %
      %Select all subplots and determine the position of the current row
      %
      QTEMP17 = get(QmatNMR.AllAxes, 'position');
      QmatNMR.AllAxes = findobj(QTEMP21, 'type', 'axes', 'tag', 'RegularAxis');
    
      for QTEMP4 = 1:length(QmatNMR.AllAxes)
        QmatNMR.AxesNR = get(QmatNMR.AllAxes(QTEMP4), 'userdata');
      
        if ~isempty(QmatNMR.AxesNR)
          QTEMP18 = get(QmatNMR.AllAxes(QTEMP4), 'position');
          if (QTEMP18(2) == QTEMP17(2)) 	%check whether this axis has the correct position
            if QmatNMR.uiInput1a
              set(QmatNMR.AllAxes(QTEMP4), 'xlim', sort(QTEMP1));
            end
            if QmatNMR.uiInput2a
              set(QmatNMR.AllAxes(QTEMP4), 'ylim', sort(QTEMP2));
            end
            if QmatNMR.uiInput3a
              set(QmatNMR.AllAxes(QTEMP4), 'zlim', sort(QTEMP3));
            end
  	end
        end	  
      end
      
      %
      %make sure only the current axis is selected, if there are more than one axes in the list
      %
      QmatNMR.AllAxes = findobj(findobj(QTEMP21, 'type', 'axes'), 'selected', 'on');
      if (length(QmatNMR.AllAxes) > 0)
        set(QmatNMR.AllAxes, 'selected', 'off');
        set(QmatNMR.AxisHandle2D3D, 'selected', 'on');
        %axes(QmatNMR.AxisHandle2D3D);
        set(QTEMP21, 'currentaxes', QmatNMR.AxisHandle2D3D);
      end
  
      if (~QmatNMR.BusyWithMacro)
        drawnow
      end
  
      disp('Axis limits changed for all axes in the current row ...');
      
  
    elseif (QmatNMR.uiInput4 == 4) 		%apply to the current column of subplots
      QmatNMR.AllAxes = findobj(findobj(QTEMP21, 'type', 'axes', 'tag', 'RegularAxis'), 'selected', 'on');
      if isempty(QmatNMR.AllAxes)
        QmatNMR.AllAxes = QTEMP20;
      end
      %
      %demand that at most 1 subplot is selected
      %
      if (length(QmatNMR.AllAxes) > 1)
        disp('matNMR WARNING: only 1 subplot may be selected to work on the current column');
        asklims
        return
      end
      %
      %Select all subplots and determine the position of the current row
      %
      QTEMP17 = get(QmatNMR.AllAxes, 'position');
      QmatNMR.AllAxes = findobj(QTEMP21, 'type', 'axes', 'tag', 'RegularAxis');
    
      for QTEMP4 = 1:length(QmatNMR.AllAxes)
        QmatNMR.AxesNR = get(QmatNMR.AllAxes(QTEMP4), 'userdata');
      
        if ~isempty(QmatNMR.AxesNR)
          QTEMP18 = get(QmatNMR.AllAxes(QTEMP4), 'position');
          if (QTEMP18(1) == QTEMP17(1)) 	%check whether this axis has the correct position
            if QmatNMR.uiInput1a
              set(QmatNMR.AllAxes(QTEMP4), 'xlim', sort(QTEMP1));
            end
            if QmatNMR.uiInput2a
              set(QmatNMR.AllAxes(QTEMP4), 'ylim', sort(QTEMP2));
            end
            if QmatNMR.uiInput3a
              set(QmatNMR.AllAxes(QTEMP4), 'zlim', sort(QTEMP3));
            end
  	end
        end	  
      end
      
      %
      %make sure only the current axis is selected, if there are more than one axes in the list
      %
      QmatNMR.AllAxes = findobj(findobj(QTEMP21, 'type', 'axes'), 'selected', 'on');
      if (length(QmatNMR.AllAxes) > 0)
        set(QmatNMR.AllAxes, 'selected', 'off');
        set(QmatNMR.AxisHandle2D3D, 'selected', 'on');
        %axes(QmatNMR.AxisHandle2D3D);
        set(QTEMP21, 'currentaxes', QmatNMR.AxisHandle2D3D);
      end
  
      if (~QmatNMR.BusyWithMacro)
        drawnow
      end
  
      disp('Axis limits changed for all axes in the current column ...');
    end
  
    QmatNMR.aswaarden = [QTEMP1 QTEMP2];		%this is the internal variable in matNMR that is used by
    					%the zoom routine and the define plot funtion!
  
  else
    disp('Changing of axis limits was cancelled ...');
  end  
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
