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
%regelcaxis.m handles changing of the color mapping
%29-09-1998

try
  if QmatNMR.buttonList == 1		%manual setting of the color mapping
    QTEMP20 = gca;	%the current axis
    QTEMP21 = gcf; 	%the current figure window
  
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
  
  
      %
      %Finally we store the processing action
      %
      QTEMP12 = get(get(QTEMP20, 'parent'), 'userdata');	%to allow extraction of the subplot code
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 750, QTEMP12.SubPlots, QmatNMR.uiInput1a, QmatNMR.uiInput2a, QmatNMR.uiInput3);
    end
  
  
    %
    %check the new caxis values from user input
    %
    QTEMP1 = sort([eval(QmatNMR.uiInput1) eval(QmatNMR.uiInput2)]);
    if QmatNMR.uiInput1a & QmatNMR.uiInput2a & (QTEMP1(2) == QTEMP1(1))
      disp('matNMR WARNING: illegal input. Minimum and maximum MUST be different');
      askcaxis
      return
    end
  
  
    %
    %Perform the action
    %
    if (QmatNMR.uiInput3 == 1)		%only change selected axes
      QmatNMR.AllAxes = findobj(findobj(QTEMP21, 'type', 'axes'), 'selected', 'on');
      if isempty(QmatNMR.AllAxes)
        QmatNMR.AllAxes = QTEMP20;
      end
  
      for QTEMP2 = 1:length(QmatNMR.AllAxes)
        QmatNMR.AxesNR = get(QmatNMR.AllAxes(QTEMP2), 'userdata');
  
        if ~isempty(QmatNMR.AxesNR)
          if ~QmatNMR.uiInput1a		%should we change this entry? If not then read current value
  	  QTEMP19 = get(QmatNMR.AllAxes(QTEMP2), 'clim');
  	  QTEMP1(1) = QTEMP19(1);
  	end
          if ~QmatNMR.uiInput2a		%should we change this entry? If not then read current value
  	  QTEMP19 = get(QmatNMR.AllAxes(QTEMP2), 'clim');
  	  QTEMP1(2) = QTEMP19(2);
  	end
          set(QmatNMR.AllAxes(QTEMP2), 'clim', QTEMP1);
  
          %
          %Regular axes are checked for colorbars so these can also be changed.
          %
          if strcmp(get(QmatNMR.AllAxes(QTEMP2), 'tag'), 'RegularAxis')
            if QmatNMR.ContColorbarIndicator(QmatNMR.AxesNR)%if a colorbar is present update it
              %axes(QmatNMR.AllAxes(QTEMP2))
              set(QTEMP21, 'currentaxes', QmatNMR.AllAxes(QTEMP2));
              
              try
                delete(QmatNMR.contcolorbar(QmatNMR.AxesNR));
              catch
                beep
                QuiInput(['matNMR WARNING:' char(10)  char(10) 'The current 2D/3D viewer window appears' char(10) 'to be corrupted! Please close this window or' char(10) 'select a new subplot configuration.'], 'Continue', '');
                waitforbuttonpress
              end
              RestoreSubplots(QmatNMR.Fig2D3D, QmatNMR.ContSubplots);
              QmatNMR.contcolorbar(QmatNMR.AxesNR) = colorbarmatNMR('vert');
            end
          end
        end
        %axes(QmatNMR.AxisHandle2D3D);
        set(QTEMP21, 'currentaxes', QmatNMR.AxisHandle2D3D);		%go back to the axis from which the command was started
      end
  
      %
      %after having changed the handle(s) of the color bar(s), store the data in the user data
      %
      QTEMP4 = get(QmatNMR.Fig2D3D, 'userdata');
      QTEMP4.ColorBarIndicator = QmatNMR.ContColorbarIndicator;
      QTEMP4.ColorBarHandles = QmatNMR.contcolorbar;
      set(QmatNMR.Fig2D3D, 'userdata', QTEMP4);
  
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
  
      %
      %adjust the posneg colormaps if that is the current colormap. This must be after the parameters have been
      %written to the figure userdata because the QColorMaps and AdjustPosNeg routines needs those!
      %
      if strcmp(QmatNMR.CurrentColorMap(1:14), 'QmatNMR.PosNeg')
        set(QmatNMR.c8, 'value', 3);
        contcmap
      end
  
      if (~QmatNMR.BusyWithMacro)
        drawnow
      end
  
      disp('Color mapping was changed manually for selected axes ...');
  
  
    elseif (QmatNMR.uiInput3 == 2)	%Apply to all axes
      QmatNMR.AllAxes = findobj(QTEMP21, 'type', 'axes', 'tag', 'RegularAxis');
  
      for QTEMP2 = 1:length(QmatNMR.AllAxes)
        QmatNMR.AxesNR = get(QmatNMR.AllAxes(QTEMP2), 'userdata');
  
        if ~isempty(QmatNMR.AxesNR)
          if ~QmatNMR.uiInput1a		%should we change this entry? If not then read current value
  	  QTEMP19 = get(QmatNMR.AllAxes(QTEMP2), 'clim');
  	  QTEMP1(1) = QTEMP19(1);
  	end
          if ~QmatNMR.uiInput2a		%should we change this entry? If not then read current value
  	  QTEMP19 = get(QmatNMR.AllAxes(QTEMP2), 'clim');
  	  QTEMP1(2) = QTEMP19(2);
  	end
          set(QmatNMR.AllAxes(QTEMP2), 'clim', QTEMP1);
  
  	if QmatNMR.ContColorbarIndicator(QmatNMR.AxesNR)%if a colorbar is present update it
  	  %axes(QmatNMR.AllAxes(QTEMP2))
            set(QTEMP21, 'currentaxes', QmatNMR.AllAxes(QTEMP2));
            
            delete(QmatNMR.contcolorbar(QmatNMR.AxesNR));
            RestoreSubplots(QmatNMR.Fig2D3D, QmatNMR.ContSubplots);
  	  QmatNMR.contcolorbar(QmatNMR.AxesNR) = colorbarmatNMR('vert');
  	end
        end
        %axes(QmatNMR.AxisHandle2D3D);
        set(QTEMP21, 'currentaxes', QmatNMR.AxisHandle2D3D);		%go back to the axis from which the command was started
      end
  
      %
      %after having changed the handle(s) of the color bar(s), store the data in the user data
      %
      QTEMP4 = get(QmatNMR.Fig2D3D, 'userdata');
      QTEMP4.ColorBarIndicator = QmatNMR.ContColorbarIndicator;
      QTEMP4.ColorBarHandles = QmatNMR.contcolorbar;
      set(QmatNMR.Fig2D3D, 'userdata', QTEMP4);
  
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
  
      %
      %adjust the posneg colormaps if that is the current colormap. This must be after the parameters have been
      %written to the figure userdata because the QColorMaps and AdjustPosNeg routines needs those!
      %
      if strcmp(QmatNMR.CurrentColorMap(1:14), 'QmatNMR.PosNeg')
        set(QmatNMR.c8, 'value', 3);
        contcmap
      end
  
      if (~QmatNMR.BusyWithMacro)
        drawnow
      end
  
      disp('Color mapping was changed to the same setting for all axes ...');
  
  
    elseif (QmatNMR.uiInput3 == 3)	%change all axes in the current row of subplots to the same color axis
      QmatNMR.AllAxes = findobj(findobj(QTEMP21, 'type', 'axes', 'tag', 'RegularAxis'), 'selected', 'on');
      if isempty(QmatNMR.AllAxes)
        QmatNMR.AllAxes = QTEMP20;
      end
      %
      %demand that at most 1 subplot is selected
      %
      if (length(QmatNMR.AllAxes) > 1)
        disp('matNMR WARNING: only 1 subplot may be selected to work on the current row');
        askcaxis
        return
      end
      %
      %Select all subplots and determine the position of the current row
      %
      QTEMP17 = get(QmatNMR.AllAxes, 'position');
      QmatNMR.AllAxes = findobj(QTEMP21, 'type', 'axes', 'tag', 'RegularAxis');
  
      for QTEMP2 = 1:length(QmatNMR.AllAxes)
        QmatNMR.AxesNR = get(QmatNMR.AllAxes(QTEMP2), 'userdata');
  
        if ~isempty(QmatNMR.AxesNR)
          QTEMP18 = get(QmatNMR.AllAxes(QTEMP2), 'position');
          if (QTEMP18(2) == QTEMP17(2)) 	%check whether this axis has the correct position
            if ~QmatNMR.uiInput1a		%should we change this entry? If not then read current value
              QTEMP19 = get(QmatNMR.AllAxes(QTEMP2), 'clim');
              QTEMP1(1) = QTEMP19(1);
            end
            if ~QmatNMR.uiInput2a		%should we change this entry? If not then read current value
              QTEMP19 = get(QmatNMR.AllAxes(QTEMP2), 'clim');
              QTEMP1(2) = QTEMP19(2);
            end
            set(QmatNMR.AllAxes(QTEMP2), 'clim', QTEMP1);
  
            if QmatNMR.ContColorbarIndicator(QmatNMR.AxesNR)%if a colorbar is present update it
              %axes(QmatNMR.AllAxes(QTEMP2))
              set(QTEMP21, 'currentaxes', QmatNMR.AllAxes(QTEMP2));
              
              delete(QmatNMR.contcolorbar(QmatNMR.AxesNR));
              RestoreSubplots(QmatNMR.Fig2D3D, QmatNMR.ContSubplots);
              QmatNMR.contcolorbar(QmatNMR.AxesNR) = colorbarmatNMR('vert');
            end
  	end
        end
        %axes(QmatNMR.AxisHandle2D3D);
        set(QTEMP21, 'currentaxes', QmatNMR.AxisHandle2D3D);		%go back to the axis from which the command was started
      end
  
      %
      %after having changed the handle(s) of the color bar(s), store the data in the user data
      %
      QTEMP4 = get(QmatNMR.Fig2D3D, 'userdata');
      QTEMP4.ColorBarIndicator = QmatNMR.ContColorbarIndicator;
      QTEMP4.ColorBarHandles = QmatNMR.contcolorbar;
      set(QmatNMR.Fig2D3D, 'userdata', QTEMP4);
  
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
  
      %
      %adjust the posneg colormaps if that is the current colormap. This must be after the parameters have been
      %written to the figure userdata because the QColorMaps and AdjustPosNeg routines needs those!
      %
      if strcmp(QmatNMR.CurrentColorMap(1:14), 'QmatNMR.PosNeg')
        set(QmatNMR.c8, 'value', 3);
        contcmap
      end
  
      if (~QmatNMR.BusyWithMacro)
        drawnow
      end
  
      disp('Color mapping was changed to the same setting for all axes in the current row ...');
  
  
    elseif (QmatNMR.uiInput3 == 4)	%change all axes in the current column of subplots to the same color axis
      QmatNMR.AllAxes = findobj(findobj(QTEMP21, 'type', 'axes', 'tag', 'RegularAxis'), 'selected', 'on');
      if isempty(QmatNMR.AllAxes)
        QmatNMR.AllAxes = QTEMP20;
      end
      %
      %demand that at most 1 subplot is selected
      %
      if (length(QmatNMR.AllAxes) > 1)
        disp('matNMR WARNING: only 1 subplot may be selected to work on the current column');
        askcaxis
        return
      end
      %
      %Select all subplots and determine the position of the current row
      %
      QTEMP17 = get(QmatNMR.AllAxes, 'position');
      QmatNMR.AllAxes = findobj(QTEMP21, 'type', 'axes', 'tag', 'RegularAxis');
  
      for QTEMP2 = 1:length(QmatNMR.AllAxes)
        QmatNMR.AxesNR = get(QmatNMR.AllAxes(QTEMP2), 'userdata');
  
        if ~isempty(QmatNMR.AxesNR)
          QTEMP18 = get(QmatNMR.AllAxes(QTEMP2), 'position');
          if (QTEMP18(1) == QTEMP17(1)) 	%check whether this axis has the correct position
            if ~QmatNMR.uiInput1a		%should we change this entry? If not then read current value
              QTEMP19 = get(QmatNMR.AllAxes(QTEMP2), 'clim');
              QTEMP1(1) = QTEMP19(1);
            end
            if ~QmatNMR.uiInput2a		%should we change this entry? If not then read current value
              QTEMP19 = get(QmatNMR.AllAxes(QTEMP2), 'clim');
              QTEMP1(2) = QTEMP19(2);
            end
            set(QmatNMR.AllAxes(QTEMP2), 'clim', QTEMP1);
  
            if QmatNMR.ContColorbarIndicator(QmatNMR.AxesNR)%if a colorbar is present update it
              %axes(QmatNMR.AllAxes(QTEMP2))
              set(QTEMP21, 'currentaxes', QmatNMR.AllAxes(QTEMP2));
              
              delete(QmatNMR.contcolorbar(QmatNMR.AxesNR));
              RestoreSubplots(QmatNMR.Fig2D3D, QmatNMR.ContSubplots);
              QmatNMR.contcolorbar(QmatNMR.AxesNR) = colorbarmatNMR('vert');
            end
  	end
        end
        %axes(QmatNMR.AxisHandle2D3D);
        set(QTEMP21, 'currentaxes', QmatNMR.AxisHandle2D3D);		%go back to the axis from which the command was started
      end
  
      %
      %after having changed the handle(s) of the color bar(s), store the data in the user data
      %
      QTEMP4 = get(QmatNMR.Fig2D3D, 'userdata');
      QTEMP4.ColorBarIndicator = QmatNMR.ContColorbarIndicator;
      QTEMP4.ColorBarHandles = QmatNMR.contcolorbar;
      set(QmatNMR.Fig2D3D, 'userdata', QTEMP4);
  
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
  
      %
      %adjust the posneg colormaps if that is the current colormap. This must be after the parameters have been
      %written to the figure userdata because the QColorMaps and AdjustPosNeg routines needs those!
      %
      if strcmp(QmatNMR.CurrentColorMap(1:14), 'QmatNMR.PosNeg')
        set(QmatNMR.c8, 'value', 3);
        contcmap
      end
  
      if (~QmatNMR.BusyWithMacro)
        drawnow
      end
  
      disp('Color mapping was changed to the same setting for all axes in the current column ...');
    end
  
  
  elseif QmatNMR.buttonList == 2		%automatic setting of the color mapping
    QTEMP20 = gca;
    QTEMP21 = gcf; 	%the current figure window
  
  
    %
    %Add an entry to the plotting macro if we're recording one
    %
    if (QmatNMR.RecordingPlottingMacro)
      %
      %first store the list of selected regular axes unless none were selected
      %
      QTEMP11 = 0;
      QmatNMR.AllAxes = findobj(findobj(QTEMP21, 'type', 'axes'), 'selected', 'on');
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
  
  
      %
      %Finally we store the processing action
      %
      QTEMP12 = get(get(QTEMP20, 'parent'), 'userdata');	%to allow extraction of the subplot code
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 750, QTEMP12.SubPlots, QmatNMR.uiInput1a, QmatNMR.uiInput2a, QmatNMR.uiInput3);
    end
  
  
    %
    %Perform the action
    %
    if (QmatNMR.uiInput3 == 1)		%only change selected axes
      QmatNMR.AllAxes = findobj(findobj(QTEMP21, 'type', 'axes', 'tag', 'RegularAxis'), 'selected', 'on');
      if isempty(QmatNMR.AllAxes)
        QmatNMR.AllAxes = QTEMP20;
      end
  
      for QTEMP2 = 1:length(QmatNMR.AllAxes)
        QmatNMR.AxesNR = get(QmatNMR.AllAxes(QTEMP2), 'userdata');
  
        if ~isempty(QmatNMR.AxesNR)
          set(QmatNMR.AllAxes(QTEMP2), 'climmode', 'auto');
  
          %
          %Regular axes are checked for colorbars so these can also be changed.
          %
          if strcmp(get(QmatNMR.AllAxes(QTEMP2), 'tag'), 'RegularAxis')
            if QmatNMR.ContColorbarIndicator(QmatNMR.AxesNR)%if a colorbar is present update it
              %axes(QmatNMR.AllAxes(QTEMP2))
              set(QTEMP21, 'currentaxes', QmatNMR.AllAxes(QTEMP2));
              
              try
                delete(QmatNMR.contcolorbar(QmatNMR.AxesNR));
              catch
                        beep
                QuiInput(['matNMR WARNING:' char(10)  char(10) 'The current 2D/3D viewer window appears' char(10) 'to be corrupted! Please close this window or' char(10) 'select a new subplot configuration.'], 'Continue', '');
                waitforbuttonpress
              end
              RestoreSubplots(QmatNMR.Fig2D3D, QmatNMR.ContSubplots);
  	    QmatNMR.contcolorbar(QmatNMR.AxesNR) = colorbarmatNMR('vert');
            end
  	end
        end
        %axes(QmatNMR.AxisHandle2D3D);
        set(QTEMP21, 'currentaxes', QmatNMR.AxisHandle2D3D);		%go back to the axis from which the command was started
      end
  
      %
      %after having changed the handle(s) of the color bar(s), store the data in the user data
      %
      QTEMP4 = get(QmatNMR.Fig2D3D, 'userdata');
      QTEMP4.ColorBarIndicator = QmatNMR.ContColorbarIndicator;
      QTEMP4.ColorBarHandles = QmatNMR.contcolorbar;
      set(QmatNMR.Fig2D3D, 'userdata', QTEMP4);
  
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
  
      %
      %adjust the posneg colormaps if that is the current colormap. This must be after the parameters have been
      %written to the figure userdata because the QColorMaps and AdjustPosNeg routines needs those!
      %
      if strcmp(QmatNMR.CurrentColorMap(1:14), 'QmatNMR.PosNeg')
        set(QmatNMR.c8, 'value', 3);
        contcmap
      end
  
      if (~QmatNMR.BusyWithMacro)
        drawnow
      end
  
      disp('Color mapping was set to automatic for selected axes ...');
  
    elseif (QmatNMR.uiInput3 == 2)	%change all axes in the current plot
      QmatNMR.AllAxes = findobj(QTEMP21, 'type', 'axes', 'tag', 'RegularAxis');
  
      for QTEMP2 = 1:length(QmatNMR.AllAxes)
        QmatNMR.AxesNR = get(QmatNMR.AllAxes(QTEMP2), 'userdata');
  
        if ~isempty(QmatNMR.AxesNR)
          set(QmatNMR.AllAxes(QTEMP2), 'climmode', 'auto');
  
  	if QmatNMR.ContColorbarIndicator(QmatNMR.AxesNR)%if a colorbar is present update it
  	  %axes(QmatNMR.AllAxes(QTEMP2))
            set(QTEMP21, 'currentaxes', QmatNMR.AllAxes(QTEMP2));
  
            try
              delete(QmatNMR.contcolorbar(QmatNMR.AxesNR));
            catch
                      beep
                QuiInput(['matNMR WARNING:' char(10)  char(10) 'The current 2D/3D viewer window appears' char(10) 'to be corrupted! Please close this window or' char(10) 'select a new subplot configuration.'], 'Continue', '');
              waitforbuttonpress
            end
            RestoreSubplots(QmatNMR.Fig2D3D, QmatNMR.ContSubplots);
  	  QmatNMR.contcolorbar(QmatNMR.AxesNR) = colorbarmatNMR('vert');
  	end
        end
        %axes(QmatNMR.AxisHandle2D3D);
        set(QTEMP21, 'currentaxes', QmatNMR.AxisHandle2D3D);		%go back to the axis from which the command was started
      end
  
      %
      %after having changed the handle(s) of the color bar(s), store the data in the user data
      %
      QTEMP4 = get(QmatNMR.Fig2D3D, 'userdata');
      QTEMP4.ColorBarIndicator = QmatNMR.ContColorbarIndicator;
      QTEMP4.ColorBarHandles = QmatNMR.contcolorbar;
      set(QmatNMR.Fig2D3D, 'userdata', QTEMP4);
  
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
  
      %
      %adjust the posneg colormaps if that is the current colormap. This must be after the parameters have been
      %written to the figure userdata because the QColorMaps and AdjustPosNeg routines needs those!
      %
      if strcmp(QmatNMR.CurrentColorMap(1:14), 'QmatNMR.PosNeg')
        set(QmatNMR.c8, 'value', 3);
        contcmap
      end
  
      if (~QmatNMR.BusyWithMacro)
        drawnow
      end
  
      disp('Color mapping was to automatic for all axes ...');
  
    elseif (QmatNMR.uiInput3 == 3)	%change all axes in the current row of subplots
      QmatNMR.AllAxes = findobj(findobj(QTEMP21, 'type', 'axes', 'tag', 'RegularAxis'), 'selected', 'on');
      if isempty(QmatNMR.AllAxes)
        QmatNMR.AllAxes = QTEMP20;
      end
      %
      %demand that at most 1 subplot is selected
      %
      if (length(QmatNMR.AllAxes) > 1)
        disp('matNMR WARNING: only 1 subplot may be selected to work on the current row');
        askcaxis
        return
      end
      %
      %Select all subplots and determine the position of the current row
      %
      QTEMP17 = get(QmatNMR.AllAxes, 'position');
      QmatNMR.AllAxes = findobj(QTEMP21, 'type', 'axes', 'tag', 'RegularAxis');
  
      for QTEMP2 = 1:length(QmatNMR.AllAxes)
        QmatNMR.AxesNR = get(QmatNMR.AllAxes(QTEMP2), 'userdata');
  
        if ~isempty(QmatNMR.AxesNR)
          QTEMP18 = get(QmatNMR.AllAxes(QTEMP2), 'position');
          if (QTEMP18(2) == QTEMP17(2)) 	%check whether this axis has the correct position
            set(QmatNMR.AllAxes(QTEMP2), 'climmode', 'auto');
  
            if QmatNMR.ContColorbarIndicator(QmatNMR.AxesNR)%if a colorbar is present update it
              %axes(QmatNMR.AllAxes(QTEMP2))
              set(QTEMP21, 'currentaxes', QmatNMR.AllAxes(QTEMP2));
              
              try
                delete(QmatNMR.contcolorbar(QmatNMR.AxesNR));
              catch
                        beep
                QuiInput(['matNMR WARNING:' char(10)  char(10) 'The current 2D/3D viewer window appears' char(10) 'to be corrupted! Please close this window or' char(10) 'select a new subplot configuration.'], 'Continue', '');
                waitforbuttonpress
              end
              RestoreSubplots(QmatNMR.Fig2D3D, QmatNMR.ContSubplots);
              QmatNMR.contcolorbar(QmatNMR.AxesNR) = colorbarmatNMR('vert');
            end
  	end
        end
        %axes(QmatNMR.AxisHandle2D3D);
        set(QTEMP21, 'currentaxes', QmatNMR.AxisHandle2D3D);		%go back to the axis from which the command was started
      end
  
      %
      %after having changed the handle(s) of the color bar(s), store the data in the user data
      %
      QTEMP4 = get(QmatNMR.Fig2D3D, 'userdata');
      QTEMP4.ColorBarIndicator = QmatNMR.ContColorbarIndicator;
      QTEMP4.ColorBarHandles = QmatNMR.contcolorbar;
      set(QmatNMR.Fig2D3D, 'userdata', QTEMP4);
  
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
  
      %
      %adjust the posneg colormaps if that is the current colormap. This must be after the parameters have been
      %written to the figure userdata because the QColorMaps and AdjustPosNeg routines needs those!
      %
      if strcmp(QmatNMR.CurrentColorMap(1:14), 'QmatNMR.PosNeg')
        set(QmatNMR.c8, 'value', 3);
        contcmap
      end
  
      if (~QmatNMR.BusyWithMacro)
        drawnow
      end
  
      disp('Color mapping was to automatic for all axes in the current row of subplots ...');
  
    elseif (QmatNMR.uiInput3 == 4)	%change all axes in the current column of subplots
      QmatNMR.AllAxes = findobj(findobj(QTEMP21, 'type', 'axes', 'tag', 'RegularAxis'), 'selected', 'on');
      if isempty(QmatNMR.AllAxes)
        QmatNMR.AllAxes = QTEMP20;
      end
      %
      %demand that at most 1 subplot is selected
      %
      if (length(QmatNMR.AllAxes) > 1)
        disp('matNMR WARNING: only 1 subplot may be selected to work on the current column');
        askcaxis
        return
      end
      %
      %Select all subplots and determine the position of the current row
      %
      QTEMP17 = get(QmatNMR.AllAxes, 'position');
      QmatNMR.AllAxes = findobj(QTEMP21, 'type', 'axes', 'tag', 'RegularAxis');
  
      for QTEMP2 = 1:length(QmatNMR.AllAxes)
        QmatNMR.AxesNR = get(QmatNMR.AllAxes(QTEMP2), 'userdata');
  
        if ~isempty(QmatNMR.AxesNR)
          QTEMP18 = get(QmatNMR.AllAxes(QTEMP2), 'position');
          if (QTEMP18(1) == QTEMP17(1)) 	%check whether this axis has the correct position
            set(QmatNMR.AllAxes(QTEMP2), 'climmode', 'auto');
  
            if QmatNMR.ContColorbarIndicator(QmatNMR.AxesNR)%if a colorbar is present update it
              %axes(QmatNMR.AllAxes(QTEMP2))
              set(QTEMP21, 'currentaxes', QmatNMR.AllAxes(QTEMP2));
              
              try
                delete(QmatNMR.contcolorbar(QmatNMR.AxesNR));
              catch
                beep
                QuiInput(['matNMR WARNING:' char(10)  char(10) 'The current 2D/3D viewer window appears' char(10) 'to be corrupted! Please close this window or' char(10) 'select a new subplot configuration.'], 'Continue', '');
                waitforbuttonpress
              end
              RestoreSubplots(QmatNMR.Fig2D3D, QmatNMR.ContSubplots);
              QmatNMR.contcolorbar(QmatNMR.AxesNR) = colorbarmatNMR('vert');
            end
  	end
        end
        %axes(QmatNMR.AxisHandle2D3D);
        set(QTEMP21, 'currentaxes', QmatNMR.AxisHandle2D3D);		%go back to the axis from which the command was started
      end
  
      %
      %after having changed the handle(s) of the color bar(s), store the data in the user data
      %
      QTEMP4 = get(QmatNMR.Fig2D3D, 'userdata');
      QTEMP4.ColorBarIndicator = QmatNMR.ContColorbarIndicator;
      QTEMP4.ColorBarHandles = QmatNMR.contcolorbar;
      set(QmatNMR.Fig2D3D, 'userdata', QTEMP4);
  
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
  
      %
      %adjust the posneg colormaps if that is the current colormap. This must be after the parameters have been
      %written to the figure userdata because the QColorMaps and AdjustPosNeg routines needs those!
      %
      if strcmp(QmatNMR.CurrentColorMap(1:14), 'QmatNMR.PosNeg')
        set(QmatNMR.c8, 'value', 3);
        contcmap
      end
  
      if (~QmatNMR.BusyWithMacro)
        drawnow
      end
  
      disp('Color mapping was to automatic for all axes in the current column of subplots ...');
    end
  
  else
    disp('Color mapping not changed ...');
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
