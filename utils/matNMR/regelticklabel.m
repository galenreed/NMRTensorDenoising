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
%regelticklabel.m sets the xtick, ytick and ztick label properties for the current axis
%26-03-'99

try
  if QmatNMR.buttonList == 1			%MANUAL-button
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
      QTEMP11 = double(['QmatNMR.uiInput1 = ''' QmatNMR.uiInput1 '''']);
      QTEMP12 = ceil(length(QTEMP11)/(QmatNMR.MacroLength-1));
      QTEMP13 = zeros(1, QTEMP12*(QmatNMR.MacroLength-1));
      QTEMP13(1:length(QTEMP11)) = QTEMP11;
      for QTEMP40=1:QTEMP12
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 711, QTEMP13((QTEMP40-1)*(QmatNMR.MacroLength-1)+ (1:(QmatNMR.MacroLength-1))));
      end
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 712);
  
      QTEMP11 = double(['QmatNMR.uiInput2 = ''' QmatNMR.uiInput2 '''']);
      QTEMP12 = ceil(length(QTEMP11)/(QmatNMR.MacroLength-1));
      QTEMP13 = zeros(1, QTEMP12*(QmatNMR.MacroLength-1));
      QTEMP13(1:length(QTEMP11)) = QTEMP11;
      for QTEMP40=1:QTEMP12
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 711, QTEMP13((QTEMP40-1)*(QmatNMR.MacroLength-1)+ (1:(QmatNMR.MacroLength-1))));
      end
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 712);
  
      QTEMP11 = double(['QmatNMR.uiInput3 = ''' QmatNMR.uiInput3 '''']);
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
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 741, QTEMP12.SubPlots, QmatNMR.uiInput1a, QmatNMR.uiInput2a, QmatNMR.uiInput3a, QmatNMR.uiInput4);
    end
  
  
    %
    %Perform the action
    %
    QTEMP1 = deblank(fliplr(deblank(fliplr(QmatNMR.uiInput1))));			%remove trailing and heading spaces
    for QTel=(length(QTEMP1)):-1:2					%remove double spaces
      if ((QTEMP1(QTel) == ' ') & (QTEMP1(QTel-1) == ' '))
        QTEMP1 = [QTEMP1(1:QTel-1) QTEMP1((QTel+1):length(QTEMP1))];
      end
    end
    %
    %Now we check whether the input is a variable of type char array, in which case
    %we assume that the variable contains all the tick labels
    %
    if (exist(QTEMP1, 'var'))
      eval(['QTEMP1 = ' QTEMP1]);
  
    else
        									%convert string into a matrix by changing all
      									%(single) spaces.
      eval(['QTEMP1 = str2mat(''' strrep(QTEMP1, ' ', ''',''') ''');']);
    end
  
  
    QTEMP2 = deblank(fliplr(deblank(fliplr(QmatNMR.uiInput2))));			%remove trailing and heading spaces
    for QTel=(length(QTEMP2)):-1:2					%remove double spaces
      if ((QTEMP2(QTel) == ' ') & (QTEMP2(QTel-1) == ' '))
        QTEMP2 = [QTEMP2(1:QTel-1) QTEMP2((QTel+1):length(QTEMP2))];
      end
    end
    %
    %Now we check whether the input is a variable of type char array, in which case
    %we assume that the variable contains all the tick labels
    %
    if (exist(QTEMP2, 'var'))
      eval(['QTEMP2 = ' QTEMP2 ';']);
  
    else
        									%convert string into a matrix by changing all
      									%(single) spaces.
      eval(['QTEMP2 = str2mat(''' strrep(QTEMP2, ' ', ''',''') ''');']);
    end
  
  
    QTEMP3 = deblank(fliplr(deblank(fliplr(QmatNMR.uiInput3))));			%remove trailing and heading spaces
    for QTel=(length(QTEMP3)):-1:2					%remove double spaces
      if ((QTEMP3(QTel) == ' ') & (QTEMP3(QTel-1) == ' '))
        QTEMP3 = [QTEMP3(1:QTel-1) QTEMP3((QTel+1):length(QTEMP3))];
      end
    end
    %
    %Now we check whether the input is a variable of type char array, in which case
    %we assume that the variable contains all the tick labels
    %
    if (exist(QTEMP3, 'var'))
      eval(['QTEMP3 = ' QTEMP3]);
  
    else
        									%convert string into a matrix by changing all
      									%(single) spaces.
      eval(['QTEMP3 = str2mat(''' strrep(QTEMP3, ' ', ''',''') ''');']);
    end
  
  
    %
    %Change the tick labels
    %
    if (QmatNMR.uiInput4 == 1)			%Only change selected axes
      QmatNMR.AllAxes = findobj(findobj(QTEMP21, 'type', 'axes'), 'selected', 'on');
      if isempty(QmatNMR.AllAxes)
        QmatNMR.AllAxes = QTEMP20;
      end
    
      for QTEMP4 = 1:length(QmatNMR.AllAxes)
        QmatNMR.AxesNR = get(QmatNMR.AllAxes(QTEMP4), 'userdata');
      
        if ~isempty(QmatNMR.AxesNR)
          if QmatNMR.uiInput1a
            set(QmatNMR.AllAxes(QTEMP4), 'xticklabel', QTEMP1);
  	end
          if QmatNMR.uiInput2a
            set(QmatNMR.AllAxes(QTEMP4), 'yticklabel', QTEMP2);
  	end
          if QmatNMR.uiInput3a
            set(QmatNMR.AllAxes(QTEMP4), 'zticklabel', QTEMP3);
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
  
      disp('Tick labels changed for the selected axes ...');
  
  
    elseif (QmatNMR.uiInput4 == 2) 		%apply to all subplots
      QmatNMR.AllAxes = findobj(QTEMP21, 'type', 'axes', 'tag', 'RegularAxis');
    
      for QTEMP4 = 1:length(QmatNMR.AllAxes)
        QmatNMR.AxesNR = get(QmatNMR.AllAxes(QTEMP4), 'userdata');
      
        if ~isempty(QmatNMR.AxesNR)
          if QmatNMR.uiInput1a
            set(QmatNMR.AllAxes(QTEMP4), 'xticklabel', QTEMP1);
  	end
          if QmatNMR.uiInput2a
            set(QmatNMR.AllAxes(QTEMP4), 'yticklabel', QTEMP2);
  	end
          if QmatNMR.uiInput3a
            set(QmatNMR.AllAxes(QTEMP4), 'zticklabel', QTEMP3);
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
  
      disp('Tick labels changed for all axes ...');
      
  
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
        askticklabel
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
              set(QmatNMR.AllAxes(QTEMP4), 'xticklabel', QTEMP1);
            end
            if QmatNMR.uiInput2a
              set(QmatNMR.AllAxes(QTEMP4), 'yticklabel', QTEMP2);
            end
            if QmatNMR.uiInput3a
              set(QmatNMR.AllAxes(QTEMP4), 'zticklabel', QTEMP3);
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
  
      disp('Tick labels changed for all axes in the current row ...');
      
  
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
        askticklabel
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
              set(QmatNMR.AllAxes(QTEMP4), 'xticklabel', QTEMP1);
            end
            if QmatNMR.uiInput2a
              set(QmatNMR.AllAxes(QTEMP4), 'yticklabel', QTEMP2);
            end
            if QmatNMR.uiInput3a
              set(QmatNMR.AllAxes(QTEMP4), 'zticklabel', QTEMP3);
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
  
      disp('Tick labels changed for all axes in the current column ...');
    end  
  
  
  elseif (QmatNMR.buttonList == 2)		%AUTO-button
    QTEMP20 = gca;
    QTEMP21 = gcf; 	%the current figure window
  
    if (QmatNMR.uiInput4 == 1)			%only change the selected axes
      QmatNMR.AllAxes = findobj(findobj(QTEMP21, 'type', 'axes'), 'selected', 'on');
      if isempty(QmatNMR.AllAxes)
        QmatNMR.AllAxes = QTEMP20;
      end
    
      for QTEMP4 = 1:length(QmatNMR.AllAxes)
        QmatNMR.AxesNR = get(QmatNMR.AllAxes(QTEMP4), 'userdata');
      
        if ~isempty(QmatNMR.AxesNR)
          if QmatNMR.uiInput1a
            set(QmatNMR.AllAxes(QTEMP4), 'xticklabelmode', 'auto');
  	end
          if QmatNMR.uiInput2a
            set(QmatNMR.AllAxes(QTEMP4), 'yticklabelmode', 'auto');
  	end
          if QmatNMR.uiInput3a
            set(QmatNMR.AllAxes(QTEMP4), 'zticklabelmode', 'auto');
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
  
      disp('Tick label mode set to automatic for selected axes ...');
  
  
    elseif (QmatNMR.uiInput4 == 2) 		%apply to all subplots
      QmatNMR.AllAxes = findobj(QTEMP21, 'type', 'axes', 'tag', 'RegularAxis');
    
      for QTEMP4 = 1:length(QmatNMR.AllAxes)
        QmatNMR.AxesNR = get(QmatNMR.AllAxes(QTEMP4), 'userdata');
      
        if ~isempty(QmatNMR.AxesNR)
          if QmatNMR.uiInput1a
            set(QmatNMR.AllAxes(QTEMP4), 'xticklabelmode', 'auto');
  	end
          if QmatNMR.uiInput2a
            set(QmatNMR.AllAxes(QTEMP4), 'yticklabelmode', 'auto');
  	end
          if QmatNMR.uiInput3a
            set(QmatNMR.AllAxes(QTEMP4), 'zticklabelmode', 'auto');
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
  
      disp('Tick label mode set to automatic for all axes ...');
      
  
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
        askticklabel
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
              set(QmatNMR.AllAxes(QTEMP4), 'xticklabelmode', 'auto');
            end
            if QmatNMR.uiInput2a
              set(QmatNMR.AllAxes(QTEMP4), 'yticklabelmode', 'auto');
            end
            if QmatNMR.uiInput3a
              set(QmatNMR.AllAxes(QTEMP4), 'zticklabelmode', 'auto');
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
  
      disp('Tick label mode set to automatic for all axes in the current row ...');
      
  
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
        askticklabel
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
              set(QmatNMR.AllAxes(QTEMP4), 'xticklabelmode', 'auto');
            end
            if QmatNMR.uiInput2a
              set(QmatNMR.AllAxes(QTEMP4), 'yticklabelmode', 'auto');
            end
            if QmatNMR.uiInput3a
              set(QmatNMR.AllAxes(QTEMP4), 'zticklabelmode', 'auto');
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
  
      disp('Tick label mode set to automatic for all axes in the current column ...');
    end  
  
  else
    disp('Setting of xtick, ytick and ztick labels was cancelled ...');
  end  
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
