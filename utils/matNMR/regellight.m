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
%regellight.m handles the creation/deletion of light objects in the 2D/3D
%Viewer
%
%12-11-'07

try
  if (QmatNMR.buttonList == 1)	%OK button
    %
    %regellight is special in the sence that this routine can (currently) only be called from a 2D/3D viewer window
    %
    QTEMP20 = QmatNMR.AxisHandle2D3D;
    QTEMP21 = QmatNMR.Fig2D3D;
  
  
    %
    %First we check the input parameters: if the user doesn't want a
    %predefined position of the light then an azimuth and elevation must be
    %defined.
    %
    if (QmatNMR.uiInput2 == 1)
      try
        QTEMP = eval(QmatNMR.uiInput3);
        QmatNMR.ContLightAz = QTEMP(1);
        QmatNMR.ContLightEl = QTEMP(2);
  
      catch
        beep
        disp('matNMR WARNING: input for azimuth/elevation did not yield a vector of length 2. Please correct. Aborting ...');
        return
      end
    end
  
  
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
  
      QTEMP11 = double(['QmatNMR.uiInput3 = ''' QTEMP3 '''']);
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
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 746, QTEMP12.SubPlots, QmatNMR.uiInput1, QmatNMR.uiInput2, QmatNMR.uiInput4, QmatNMR.uiInput5, QmatNMR.uiInput6, QmatNMR.uiInput7, get(QTEMP20, 'userdata'));
    end
  
  
    %
    %Perform the action
    %
    if (QmatNMR.uiInput7 == 1)		%only change selected axes
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
            if (QmatNMR.uiInput1 == 1) 	%a light is wanted
              %first delete the old light object, if one exists
              delete(findobj(allchild(QmatNMR.AllAxes(QTEMP2)), 'type', 'light'));
  
              %axes(QmatNMR.AllAxes(QTEMP2));
              set(QTEMP21, 'currentaxes', QmatNMR.AllAxes(QTEMP2));
  
              %then add a new light based on the given settings
              if (QmatNMR.uiInput4 == 1)
                QTEMP = 'local';
              else
                QTEMP = 'infinite';
              end
  
              if (QmatNMR.uiInput2 == 4)        %user-defined lamp position relative to current view
                camlight(QmatNMR.ContLightAz, QmatNMR.ContLightEl, QTEMP);
              elseif (QmatNMR.uiInput2 == 1)
                camlight('headlight', QTEMP);
              elseif (QmatNMR.uiInput2 == 2)
                camlight('right', QTEMP);
              elseif (QmatNMR.uiInput2 == 3)
                camlight('left', QTEMP);
              end
  
              if (QmatNMR.uiInput5 == 1)        %material properties
                material default
              elseif (QmatNMR.uiInput5 == 2)
                material dull
              elseif (QmatNMR.uiInput5 == 3)
                material shiny
              elseif (QmatNMR.uiInput5 == 4)
                material metal
              end
  
              if (QmatNMR.uiInput6 == 4)        %lighting algorithms
                lighting none
              elseif (QmatNMR.uiInput6 == 1)
                lighting flat
              elseif (QmatNMR.uiInput6 == 2)
                lighting gouraud
              elseif (QmatNMR.uiInput6 == 3)
                lighting phong
              end
  
            else				%Remove the light object
              %axes(QmatNMR.AllAxes(QTEMP2));
              set(QTEMP21, 'currentaxes', QmatNMR.AllAxes(QTEMP2));
  
              %first delete the old light object, if one exists
              delete(findobj(allchild(QmatNMR.AllAxes(QTEMP2)), 'type', 'light'));
            end
          end
  
        else 	%NOT a regular axis
          disp('matNMR NOTICE: currently, colorbars can only be generated or deleted for regular axes. Sorry ...');
        end
      end
  
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
  
  
    elseif (QmatNMR.uiInput7 == 2)		%apply to all axes
      QmatNMR.AllAxes = findobj(QTEMP21, 'type', 'axes', 'tag', 'RegularAxis');		%find all axis handles
  
      for QTEMP2 = 1:length(QmatNMR.AllAxes)
        QmatNMR.AxesNR = get(QmatNMR.AllAxes(QTEMP2), 'userdata');
  
        if ~isempty(QmatNMR.AxesNR)
          if (QmatNMR.uiInput1 == 1)    %a light is wanted
            %first delete the old light object, if one exists
            delete(findobj(allchild(QmatNMR.AllAxes(QTEMP2)), 'type', 'light'));
  
            %axes(QmatNMR.AllAxes(QTEMP2));
            set(QTEMP21, 'currentaxes', QmatNMR.AllAxes(QTEMP2));
  
            %then add a new light based on the given settings
            if (QmatNMR.uiInput4 == 1)
              QTEMP = 'local';
            else
              QTEMP = 'infinite';
            end
  
            if (QmatNMR.uiInput2 == 4)        %user-defined lamp position relative to current view
              camlight(QmatNMR.ContLightAz, QmatNMR.ContLightEl, QTEMP);
            elseif (QmatNMR.uiInput2 == 1)
              camlight('headlight', QTEMP);
            elseif (QmatNMR.uiInput2 == 2)
              camlight('right', QTEMP);
            elseif (QmatNMR.uiInput2 == 3)
              camlight('left', QTEMP);
            end
  
            if (QmatNMR.uiInput5 == 1)        %material properties
              material default
            elseif (QmatNMR.uiInput5 == 2)
              material dull
            elseif (QmatNMR.uiInput5 == 3)
              material shiny
            elseif (QmatNMR.uiInput5 == 4)
              material metal
            end
  
            if (QmatNMR.uiInput6 == 4)        %lighting algorithms
              lighting none
            elseif (QmatNMR.uiInput6 == 1)
              lighting flat
            elseif (QmatNMR.uiInput6 == 2)
              lighting gouraud
            elseif (QmatNMR.uiInput6 == 3)
              lighting phong
            end
  
          else                          %Remove the light object
            %axes(QmatNMR.AllAxes(QTEMP2));
            set(QTEMP21, 'currentaxes', QmatNMR.AllAxes(QTEMP2));
  
            %first delete the old light object, if one exists
            delete(findobj(allchild(QmatNMR.AllAxes(QTEMP2)), 'type', 'light'));
          end
        end
      end
  
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
  
      disp('Colorbar settings were changed for all axes ...');
  
  
    elseif (QmatNMR.uiInput7 == 3)		%apply to the current row of subplots
      QmatNMR.AllAxes = findobj(findobj(QTEMP21, 'type', 'axes', 'tag', 'RegularAxis'), 'selected', 'on');
      if isempty(QmatNMR.AllAxes)
        QmatNMR.AllAxes = QTEMP20;
      end
      %
      %demand that at most 1 subplot is selected
      %
      if (length(QmatNMR.AllAxes) > 1)
        disp('matNMR WARNING: only 1 subplot may be selected to work on the current row');
        asklight
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
            if (QmatNMR.uiInput1 == 1)    %a light is wanted
              %first delete the old light object, if one exists
              delete(findobj(allchild(QmatNMR.AllAxes(QTEMP2)), 'type', 'light'));
  
              %axes(QmatNMR.AllAxes(QTEMP2));
              set(QTEMP21, 'currentaxes', QmatNMR.AllAxes(QTEMP2));
  
              %then add a new light based on the given settings
              if (QmatNMR.uiInput4 == 1)
                QTEMP = 'local';
              else
                QTEMP = 'infinite';
              end
  
              if (QmatNMR.uiInput2 == 4)        %user-defined lamp position relative to current view
                camlight(QmatNMR.ContLightAz, QmatNMR.ContLightEl, QTEMP);
              elseif (QmatNMR.uiInput2 == 1)
                camlight('headlight', QTEMP);
              elseif (QmatNMR.uiInput2 == 2)
                camlight('right', QTEMP);
              elseif (QmatNMR.uiInput2 == 3)
                camlight('left', QTEMP);
              end
  
              if (QmatNMR.uiInput5 == 1)        %material properties
                material default
              elseif (QmatNMR.uiInput5 == 2)
                material dull
              elseif (QmatNMR.uiInput5 == 3)
                material shiny
              elseif (QmatNMR.uiInput5 == 4)
                material metal
              end
  
              if (QmatNMR.uiInput6 == 4)        %lighting algorithms
                lighting none
              elseif (QmatNMR.uiInput6 == 1)
                lighting flat
              elseif (QmatNMR.uiInput6 == 2)
                lighting gouraud
              elseif (QmatNMR.uiInput6 == 3)
                lighting phong
              end
  
            else                          %Remove the light object
              %axes(QmatNMR.AllAxes(QTEMP2));
              set(QTEMP21, 'currentaxes', QmatNMR.AllAxes(QTEMP2));
  
              %first delete the old light object, if one exists
              delete(findobj(allchild(QmatNMR.AllAxes(QTEMP2)), 'type', 'light'));
            end
          end
        end
      end
  
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
  
      disp('Colorbar settings were changed for all axes in the current row ...');
  
  
    elseif (QmatNMR.uiInput7 == 4)		%apply to the current column of subplots
      QmatNMR.AllAxes = findobj(findobj(QTEMP21, 'type', 'axes', 'tag', 'RegularAxis'), 'selected', 'on');
      if isempty(QmatNMR.AllAxes)
        QmatNMR.AllAxes = QTEMP20;
      end
      %
      %demand that at most 1 subplot is selected
      %
      if (length(QmatNMR.AllAxes) > 1)
        disp('matNMR WARNING: only 1 subplot may be selected to work on the current column');
        asklight
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
            if (QmatNMR.uiInput1 == 1)    %a light is wanted
              %first delete the old light object, if one exists
              delete(findobj(allchild(QmatNMR.AllAxes(QTEMP2)), 'type', 'light'));
  
              %axes(QmatNMR.AllAxes(QTEMP2));
              set(QTEMP21, 'currentaxes', QmatNMR.AllAxes(QTEMP2));
  
              %then add a new light based on the given settings
              if (QmatNMR.uiInput4 == 1)
                QTEMP = 'local';
              else
                QTEMP = 'infinite';
              end
  
              if (QmatNMR.uiInput2 == 4)        %user-defined lamp position relative to current view
                camlight(QmatNMR.ContLightAz, QmatNMR.ContLightEl, QTEMP);
              elseif (QmatNMR.uiInput2 == 1)
                camlight('headlight', QTEMP);
              elseif (QmatNMR.uiInput2 == 2)
                camlight('right', QTEMP);
              elseif (QmatNMR.uiInput2 == 3)
                camlight('left', QTEMP);
              end
  
              if (QmatNMR.uiInput5 == 1)        %material properties
                material default
              elseif (QmatNMR.uiInput5 == 2)
                material dull
              elseif (QmatNMR.uiInput5 == 3)
                material shiny
              elseif (QmatNMR.uiInput5 == 4)
                material metal
              end
  
              if (QmatNMR.uiInput6 == 4)        %lighting algorithms
                lighting none
              elseif (QmatNMR.uiInput6 == 1)
                lighting flat
              elseif (QmatNMR.uiInput6 == 2)
                lighting gouraud
              elseif (QmatNMR.uiInput6 == 3)
                lighting phong
              end
  
            else                          %Remove the light object
              %axes(QmatNMR.AllAxes(QTEMP2));
              set(QTEMP21, 'currentaxes', QmatNMR.AllAxes(QTEMP2));
  
              %first delete the old light object, if one exists
              delete(findobj(allchild(QmatNMR.AllAxes(QTEMP2)), 'type', 'light'));
            end
          end
        end
      end
  
      %axes(QmatNMR.AxisHandle2D3D);		%go back to the axis from which the command was started
      set(QmatNMR.Fig2D3D, 'currentaxes', QmatNMR.AxisHandle2D3D);
  
      %
      %make sure only the current axis is selected, if there are more than one axes in the list
      %
      QmatNMR.AllAxes = findobj(findobj(QTEMP21, 'type', 'axes'), 'selected', 'on');
      if (length(QmatNMR.AllAxes) > 0)
        set(QmatNMR.AllAxes, 'selected', 'off');
        set(QmatNMR.AxisHandle2D3D, 'selected', 'on');
        axes(QmatNMR.AxisHandle2D3D);
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
