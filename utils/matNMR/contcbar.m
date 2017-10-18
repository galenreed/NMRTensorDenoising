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
%contcbar.m is the interface between matNMR and the MATLAB colorbar function
%as in the original function no tag is given to the colorbar axis this script is
%necessary to be able to delete it easily again.
%26-8-'97
%03-11-'00
%27-07-'01

try
  %
  %switch figure if necessary only because this will cause an additional rendering step
  %
  if (gcf ~= QmatNMR.Fig2D3D)
    figure(QmatNMR.Fig2D3D);
  end
  
  if (QmatNMR.buttonList == 1)	%OK button
    %
    %contcbar is special in the sence that this routine can (currently) only be called from a 2D/3D viewer window
    %
    QTEMP20 = QmatNMR.AxisHandle2D3D;
    QTEMP21 = QmatNMR.Fig2D3D;
  
  
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
      %Finally we store the processing action
      %
      QTEMP12 = get(get(QTEMP20, 'parent'), 'userdata');	%to allow extraction of the subplot code
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 751, QTEMP12.SubPlots, QmatNMR.uiInput1, QmatNMR.uiInput2, QmatNMR.uiInput3, get(QTEMP20, 'userdata'));
    end
  
  
    %
    %Perform the action
    %
    if (QmatNMR.uiInput3 == 1)		%only change selected axes
      QmatNMR.AllAxes = findobj(findobj(QTEMP21, 'type', 'axes'), 'selected', 'on');
      if isempty(QmatNMR.AllAxes)
        QmatNMR.AllAxes = QTEMP20; 	%use the current axis if nothing else was found
      end
  
      for QTEMP2 = 1:length(QmatNMR.AllAxes)
        %
        %here we need to distinguish whether the axis is a regular axis or not. If so then we store additional information.
        %
        if strcmp(get(QmatNMR.AllAxes(QTEMP2), 'tag'), 'RegularAxis')
          QmatNMR.AxesNR = get(QmatNMR.AllAxes(QTEMP2), 'userdata');
  
          if ~isempty(QmatNMR.AxesNR)
            if (QmatNMR.uiInput1 == 1) 	%a colorbar is wanted
    	    if (QmatNMR.ContColorbarIndicator(QmatNMR.AxesNR) == 0)	%and not present yet, so place it!
                %axes(QmatNMR.AllAxes(QTEMP2));
                set(QmatNMR.Fig2D3D, 'currentaxes', QmatNMR.AllAxes(QTEMP2));
  
                QmatNMR.contcolorbar(QmatNMR.AxesNR) = colorbarmatNMR('vert');
                QmatNMR.ContColorbarIndicator(QmatNMR.AxesNR) = 1;
    	    end
  
              if (QmatNMR.uiInput2)		%use filled contours for the colorbar. This makes the
          					%colorbar printable in mif format.
                ChangeColorbarToContourf(QmatNMR.AllAxes(QTEMP2), QmatNMR.contcolorbar(QmatNMR.AxesNR))
              end
  
            elseif ((QmatNMR.ContColorbarIndicator(QmatNMR.AxesNR) == 1) & (QmatNMR.uiInput1 == 0))	%Remove the color bar
              %axes(QmatNMR.AllAxes(QTEMP2));
              set(QmatNMR.Fig2D3D, 'currentaxes', QmatNMR.AllAxes(QTEMP2));
  
              try
                delete(QmatNMR.contcolorbar(QmatNMR.AxesNR));
              catch
                        beep
                QuiInput(['matNMR WARNING:' char(10)  char(10) 'The current 2D/3D viewer window appears' char(10) 'to be corrupted! Please close this window or' char(10) 'select a new subplot configuration.'], 'Continue', '');
                waitforbuttonpress
              end
              QmatNMR.ContColorbarIndicator(QmatNMR.AxesNR) = 0;
              RestoreSubplots(QmatNMR.Fig2D3D, QmatNMR.ContSubplots);
              QmatNMR.contcolorbar(QmatNMR.AxesNR) = 0;
            end
          end
  
        else 	%NOT a regular axis
          disp('matNMR NOTICE: currently, colorbars can only be generated or deleted for regular axes. Sorry ...');
        end
      end
  
      set(QmatNMR.c19, 'value', QmatNMR.uiInput1);
      QTEMP1 = get(QmatNMR.Fig2D3D, 'userdata');
      QTEMP1.ColorBarIndicator = QmatNMR.ContColorbarIndicator;
      QTEMP1.ColorBarHandles = QmatNMR.contcolorbar;
      set(QmatNMR.Fig2D3D, 'userdata', QTEMP1);
      %axes(QmatNMR.AxisHandle2D3D);		%go back to the axis from which the command was started
      set(QmatNMR.Fig2D3D, 'currentaxes', QmatNMR.AxisHandle2D3D);
  
      %
      %make sure only the current axis is selected, if there are more than one axes in the list
      %
      QmatNMR.AllAxes = findobj(findobj(QTEMP21, 'type', 'axes'), 'selected', 'on');
      if (length(QmatNMR.AllAxes) > 0)
        set(QmatNMR.AllAxes, 'selected', 'off');
        set(QmatNMR.AxisHandle2D3D, 'selected', 'on');
        %axes(QmatNMR.AxisHandle2D3D);
        set(QmatNMR.Fig2D3D, 'currentaxes', QmatNMR.AxisHandle2D3D);
      end
  
      if (~QmatNMR.BusyWithMacro)
        drawnow
      end
  
      disp('Colorbar settings were changed for selected axes ...');
  
  
    elseif (QmatNMR.uiInput3 == 2)		%apply to all axes
      QmatNMR.AllAxes = findobj(QTEMP21, 'type', 'axes', 'tag', 'RegularAxis');		%find all axis handles
  
      for QTEMP2 = 1:length(QmatNMR.AllAxes)
        QmatNMR.AxesNR = get(QmatNMR.AllAxes(QTEMP2), 'userdata');
  
        if ~isempty(QmatNMR.AxesNR)
          if (QmatNMR.uiInput1 == 1) 	%a colorbar is wanted
  	  if (QmatNMR.ContColorbarIndicator(QmatNMR.AxesNR) == 0)	%and not present yet, so place it!
              %axes(QmatNMR.AllAxes(QTEMP2));
              set(QTEMP21, 'currentaxes', QmatNMR.AllAxes(QTEMP2));
  
              QmatNMR.contcolorbar(QmatNMR.AxesNR) = colorbarmatNMR('vert');
              QmatNMR.ContColorbarIndicator(QmatNMR.AxesNR) = 1;
  	  end
  
            if (QmatNMR.uiInput2)		%use filled contours for the colorbar. This makes the
        					%colorbar printable in mif format.
  	    ChangeColorbarToContourf(QmatNMR.AllAxes(QTEMP2), QmatNMR.contcolorbar(QmatNMR.AxesNR))
            end
  
          elseif ((QmatNMR.ContColorbarIndicator(QmatNMR.AxesNR) == 1) & (QmatNMR.uiInput1 == 0))	%Remove the color bar
            %axes(QmatNMR.AllAxes(QTEMP2));
            set(QTEMP21, 'currentaxes', QmatNMR.AllAxes(QTEMP2));
  
            try
              delete(QmatNMR.contcolorbar(QmatNMR.AxesNR));
            catch
                      beep
                QuiInput(['matNMR WARNING:' char(10)  char(10) 'The current 2D/3D viewer window appears' char(10) 'to be corrupted! Please close this window or' char(10) 'select a new subplot configuration.'], 'Continue', '');
              waitforbuttonpress
            end
            QmatNMR.ContColorbarIndicator(QmatNMR.AxesNR) = 0;
            RestoreSubplots(QmatNMR.Fig2D3D, QmatNMR.ContSubplots);
            QmatNMR.contcolorbar(QmatNMR.AxesNR) = 0;
          end
        end
      end
  
      set(QmatNMR.c19, 'value', QmatNMR.uiInput1);
      QTEMP1 = get(QmatNMR.Fig2D3D, 'userdata');
      QTEMP1.ColorBarIndicator = QmatNMR.ContColorbarIndicator;
      QTEMP1.ColorBarHandles = QmatNMR.contcolorbar;
      set(QmatNMR.Fig2D3D, 'userdata', QTEMP1);
      %axes(QmatNMR.AxisHandle2D3D);
      set(QTEMP21, 'currentaxes', QmatNMR.AxisHandle2D3D);		%go back to the axis from which the command was started
  
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
  
      disp('Colorbar settings were changed for all axes ...');
  
  
    elseif (QmatNMR.uiInput3 == 3)		%apply to the current row of subplots
      QmatNMR.AllAxes = findobj(findobj(QTEMP21, 'type', 'axes', 'tag', 'RegularAxis'), 'selected', 'on');
      if isempty(QmatNMR.AllAxes)
        QmatNMR.AllAxes = QTEMP20;
      end
      %
      %demand that at most 1 subplot is selected
      %
      if (length(QmatNMR.AllAxes) > 1)
        disp('matNMR WARNING: only 1 subplot may be selected to work on the current row');
        askcontcbar
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
            if (QmatNMR.uiInput1 == 1) 	%a colorbar is wanted
              if (QmatNMR.ContColorbarIndicator(QmatNMR.AxesNR) == 0)	%and not present yet, so place it!
                %axes(QmatNMR.AllAxes(QTEMP2));
                set(QTEMP21, 'currentaxes', QmatNMR.AllAxes(QTEMP2));
  
                QmatNMR.contcolorbar(QmatNMR.AxesNR) = colorbarmatNMR('vert');
                QmatNMR.ContColorbarIndicator(QmatNMR.AxesNR) = 1;
              end
  
              if (QmatNMR.uiInput2)		%use filled contours for the colorbar. This makes the
          					%colorbar printable in mif format.
                ChangeColorbarToContourf(QmatNMR.AllAxes(QTEMP2), QmatNMR.contcolorbar(QmatNMR.AxesNR))
              end
  
            elseif ((QmatNMR.ContColorbarIndicator(QmatNMR.AxesNR) == 1) & (QmatNMR.uiInput1 == 0))	%Remove the color bar
              %axes(QmatNMR.AllAxes(QTEMP2));
              set(QTEMP21, 'currentaxes', QmatNMR.AllAxes(QTEMP2));
  
              try
                delete(QmatNMR.contcolorbar(QmatNMR.AxesNR));
              catch
                        beep
                QuiInput(['matNMR WARNING:' char(10)  char(10) 'The current 2D/3D viewer window appears' char(10) 'to be corrupted! Please close this window or' char(10) 'select a new subplot configuration.'], 'Continue', '');
                waitforbuttonpress
              end
              QmatNMR.ContColorbarIndicator(QmatNMR.AxesNR) = 0;
              RestoreSubplots(QmatNMR.Fig2D3D, QmatNMR.ContSubplots);
              QmatNMR.contcolorbar(QmatNMR.AxesNR) = 0;
            end
          end
        end
      end
  
      set(QmatNMR.c19, 'value', QmatNMR.uiInput1);
      QTEMP1 = get(QmatNMR.Fig2D3D, 'userdata');
      QTEMP1.ColorBarIndicator = QmatNMR.ContColorbarIndicator;
      QTEMP1.ColorBarHandles = QmatNMR.contcolorbar;
      set(QmatNMR.Fig2D3D, 'userdata', QTEMP1);
      %axes(QmatNMR.AxisHandle2D3D);
      set(QTEMP21, 'currentaxes', QmatNMR.AxisHandle2D3D);		%go back to the axis from which the command was started
  
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
  
      disp('Colorbar settings were changed for all axes in the current row ...');
  
  
    elseif (QmatNMR.uiInput3 == 4)		%apply to the current column of subplots
      QmatNMR.AllAxes = findobj(findobj(QTEMP21, 'type', 'axes', 'tag', 'RegularAxis'), 'selected', 'on');
      if isempty(QmatNMR.AllAxes)
        QmatNMR.AllAxes = QTEMP20;
      end
      %
      %demand that at most 1 subplot is selected
      %
      if (length(QmatNMR.AllAxes) > 1)
        disp('matNMR WARNING: only 1 subplot may be selected to work on the current column');
        askcontcbar
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
            if (QmatNMR.uiInput1 == 1) 	%a colorbar is wanted
              if (QmatNMR.ContColorbarIndicator(QmatNMR.AxesNR) == 0)	%and not present yet, so place it!
                %axes(QmatNMR.AllAxes(QTEMP2));
                set(QTEMP21, 'currentaxes', QmatNMR.AllAxes(QTEMP2));
  
                QmatNMR.contcolorbar(QmatNMR.AxesNR) = colorbarmatNMR('vert');
                QmatNMR.ContColorbarIndicator(QmatNMR.AxesNR) = 1;
              end
  
              if (QmatNMR.uiInput2)		%use filled contours for the colorbar. This makes the
          					%colorbar printable in mif format.
                ChangeColorbarToContourf(QmatNMR.AllAxes(QTEMP2), QmatNMR.contcolorbar(QmatNMR.AxesNR))
              end
  
            elseif ((QmatNMR.ContColorbarIndicator(QmatNMR.AxesNR) == 1) & (QmatNMR.uiInput1 == 0))	%Remove the color bar
              %axes(QmatNMR.AllAxes(QTEMP2));
              set(QTEMP21, 'currentaxes', QmatNMR.AllAxes(QTEMP2));
  
              try
                delete(QmatNMR.contcolorbar(QmatNMR.AxesNR));
              catch
                beep
                QuiInput(['matNMR WARNING:' char(10)  char(10) 'The current 2D/3D viewer window appears' char(10) 'to be corrupted! Please close this window or' char(10) 'select a new subplot configuration.'], 'Continue', '');
                waitforbuttonpress
              end
              QmatNMR.ContColorbarIndicator(QmatNMR.AxesNR) = 0;
              RestoreSubplots(QmatNMR.Fig2D3D, QmatNMR.ContSubplots);
              QmatNMR.contcolorbar(QmatNMR.AxesNR) = 0;
            end
          end
        end
      end
  
      set(QmatNMR.c19, 'value', QmatNMR.uiInput1);
      QTEMP1 = get(QmatNMR.Fig2D3D, 'userdata');
      QTEMP1.ColorBarIndicator = QmatNMR.ContColorbarIndicator;
      QTEMP1.ColorBarHandles = QmatNMR.contcolorbar;
      set(QmatNMR.Fig2D3D, 'userdata', QTEMP1);
      %axes(QmatNMR.AxisHandle2D3D);
      set(QTEMP21, 'currentaxes', QmatNMR.AxisHandle2D3D);		%go back to the axis from which the command was started
  
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
  
      disp('Colorbar settings were changed for all axes in the current column ...');
    end
  
  else
    disp('Colorbar settings unchanged');
  end
  
  %
  %in case there are projection axes present
  %
  updateprojectionaxes
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
