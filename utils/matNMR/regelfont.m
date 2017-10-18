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
%regelfont.m handles changing the font properties for the current axis
%31-03-'99

try
  if QmatNMR.buttonList == 1
    QTEMP20 = gca;	%the current axis
    QTEMP21 = gcf; 	%the current figure window
  
    QmatNMR.CurrentAxis = QTEMP20;
    QmatNMR.CurrentFigure = QTEMP21;
  
  
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
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 730, QTEMP12.SubPlots, QmatNMR.uiInput1, QmatNMR.uiInput1a, QmatNMR.uiInput2, QmatNMR.uiInput2a, QmatNMR.uiInput3, QmatNMR.uiInput3a, QmatNMR.uiInput4, QmatNMR.uiInput4a, QmatNMR.uiInput5, QmatNMR.uiInput6, QmatNMR.uiInput7, QmatNMR.uiInput8);
    end
  
  
    %
    %Perform the action
    %
    QTEMP1 = deblank(QmatNMR.FontList(QmatNMR.uiInput1, :));
  
    QTEMP = ['6 ';'7 ';'8 ';'9 ';'10';'11';'12';'14';'16';'18';'20';'22';'24';'30';'36';'48';'72'];
    QTEMP2 = eval(QTEMP(QmatNMR.uiInput2, :));
  
    QTEMP = ['light ';'normal';'demi  ';'bold  '];
    QTEMP3 = deblank(QTEMP(QmatNMR.uiInput3, :));
  
    QTEMP = ['normal ';'italic ';'oblique'];
    QTEMP4 = deblank(QTEMP(QmatNMR.uiInput4, :));
  
    if (QmatNMR.uiInput8 == 1)			%Only change the current axis
      QmatNMR.AllAxes = findobj(findobj(QTEMP21, 'type', 'axes'), 'selected', 'on');
      if isempty(QmatNMR.AllAxes)
        QmatNMR.AllAxes = QTEMP20;
      end
  
      for QTEMP5 = 1:length(QmatNMR.AllAxes)
        QmatNMR.AxesNR = get(QmatNMR.AllAxes(QTEMP5), 'userdata');
  
        if ~isempty(QmatNMR.AxesNR)
  	if (QmatNMR.uiInput5 == 1)		%change axis
            if QmatNMR.uiInput1a
              set(QmatNMR.AllAxes(QTEMP5), 'fontname', QTEMP1);
            end
            if QmatNMR.uiInput2a
              set(QmatNMR.AllAxes(QTEMP5), 'fontsize', QTEMP2);
            end
            if QmatNMR.uiInput3a
              set(QmatNMR.AllAxes(QTEMP5), 'fontweight', QTEMP3);
            end
            if QmatNMR.uiInput4a
              set(QmatNMR.AllAxes(QTEMP5), 'fontangle', QTEMP4);
            end
  
            %
            %Regular axes are checked for colorbars so these can also be changed.
            %
            if strcmp(get(QmatNMR.AllAxes(QTEMP5), 'tag'), 'RegularAxis')
              if QmatNMR.contcolorbar(QmatNMR.AxesNR)	%A colorbar is present in the current plot --> make sure it is updated properly
                if QmatNMR.uiInput1a
                  set(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'fontname', QTEMP1);
                end
                if QmatNMR.uiInput2a
                  set(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'fontsize', QTEMP2);
                end
                if QmatNMR.uiInput3a
                  set(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'fontweight', QTEMP3);
                end
                if QmatNMR.uiInput4a
                  set(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'fontangle', QTEMP4);
                end
              end
            end
  	end
  
  	if (QmatNMR.uiInput7 == 1)		%change title
            if QmatNMR.uiInput1a
              set(get(QmatNMR.AllAxes(QTEMP5), 'title'), 'fontname', QTEMP1);
            end
            if QmatNMR.uiInput2a
              set(get(QmatNMR.AllAxes(QTEMP5), 'title'), 'fontsize', QTEMP2);
            end
            if QmatNMR.uiInput3a
              set(get(QmatNMR.AllAxes(QTEMP5), 'title'), 'fontweight', QTEMP3);
            end
            if QmatNMR.uiInput4a
              set(get(QmatNMR.AllAxes(QTEMP5), 'title'), 'fontangle', QTEMP4);
            end
  
  
            %
            %In case of a polar plot then we need to access the axis texts differently
            %
            if QmatNMR.uiInput1a
              set(findobj(allchild(QmatNMR.AllAxes(QTEMP5)), 'tag', 'PolarPlotAxisText'), 'fontname', QTEMP1);
            end
            if QmatNMR.uiInput2a
              set(findobj(allchild(QmatNMR.AllAxes(QTEMP5)), 'tag', 'PolarPlotAxisText'), 'fontsize', QTEMP2);
            end
            if QmatNMR.uiInput3a
              set(findobj(allchild(QmatNMR.AllAxes(QTEMP5)), 'tag', 'PolarPlotAxisText'), 'fontweight', QTEMP3);
            end
            if QmatNMR.uiInput4a
              set(findobj(allchild(QmatNMR.AllAxes(QTEMP5)), 'tag', 'PolarPlotAxisText'), 'fontangle', QTEMP4);
            end
  
            %
            %Regular axes are checked for colorbars so these can also be changed.
            %
            if strcmp(get(QmatNMR.AllAxes(QTEMP5), 'tag'), 'RegularAxis')
              if QmatNMR.contcolorbar(QmatNMR.AxesNR)	%A colorbar is present in the current plot --> make sure it is updated properly
                if QmatNMR.uiInput1a
                  set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'title'), 'fontname', QTEMP1);
                end
                if QmatNMR.uiInput2a
                  set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'title'), 'fontsize', QTEMP2);
                end
                if QmatNMR.uiInput3a
                  set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'title'), 'fontweight', QTEMP3);
                end
                if QmatNMR.uiInput4a
                  set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'title'), 'fontangle', QTEMP4);
                end
              end
            end
  	end
  
  	if (QmatNMR.uiInput6 == 1) 		%change axis labels
            if QmatNMR.uiInput1a
              set(get(QmatNMR.AllAxes(QTEMP5), 'xlabel'), 'fontname', QTEMP1);
              set(get(QmatNMR.AllAxes(QTEMP5), 'ylabel'), 'fontname', QTEMP1);
              set(get(QmatNMR.AllAxes(QTEMP5), 'zlabel'), 'fontname', QTEMP1);
            end
            if QmatNMR.uiInput2a
              set(get(QmatNMR.AllAxes(QTEMP5), 'xlabel'), 'fontsize', QTEMP2);
              set(get(QmatNMR.AllAxes(QTEMP5), 'ylabel'), 'fontsize', QTEMP2);
              set(get(QmatNMR.AllAxes(QTEMP5), 'zlabel'), 'fontsize', QTEMP2);
            end
            if QmatNMR.uiInput3a
              set(get(QmatNMR.AllAxes(QTEMP5), 'xlabel'), 'fontweight', QTEMP3);
              set(get(QmatNMR.AllAxes(QTEMP5), 'ylabel'), 'fontweight', QTEMP3);
              set(get(QmatNMR.AllAxes(QTEMP5), 'zlabel'), 'fontweight', QTEMP3);
            end
            if QmatNMR.uiInput4a
              set(get(QmatNMR.AllAxes(QTEMP5), 'xlabel'), 'fontangle', QTEMP4);
              set(get(QmatNMR.AllAxes(QTEMP5), 'ylabel'), 'fontangle', QTEMP4);
              set(get(QmatNMR.AllAxes(QTEMP5), 'zlabel'), 'fontangle', QTEMP4);
            end
  
            %
            %In case of a polar plot then we need to access the axis labels differently
            %
            if QmatNMR.uiInput1a
              set(findobj(allchild(QmatNMR.AllAxes(QTEMP5)), 'tag', 'PolarPlotAxisLabelText'), 'fontname', QTEMP1);
            end
            if QmatNMR.uiInput2a
              set(findobj(allchild(QmatNMR.AllAxes(QTEMP5)), 'tag', 'PolarPlotAxisLabelText'), 'fontsize', QTEMP2);
            end
            if QmatNMR.uiInput3a
              set(findobj(allchild(QmatNMR.AllAxes(QTEMP5)), 'tag', 'PolarPlotAxisLabelText'), 'fontweight', QTEMP3);
            end
            if QmatNMR.uiInput4a
              set(findobj(allchild(QmatNMR.AllAxes(QTEMP5)), 'tag', 'PolarPlotAxisLabelText'), 'fontangle', QTEMP4);
            end
  
            %
            %Regular axes are checked for colorbars so these can also be changed.
            %
            if strcmp(get(QmatNMR.AllAxes(QTEMP5), 'tag'), 'RegularAxis')
              if QmatNMR.contcolorbar(QmatNMR.AxesNR)	%A colorbar is present in the current plot --> make sure it is updated properly
                if QmatNMR.uiInput1a
                  set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'xlabel'), 'fontname', QTEMP1);
                  set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'ylabel'), 'fontname', QTEMP1);
                  set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'zlabel'), 'fontname', QTEMP1);
                end
                if QmatNMR.uiInput2a
                  set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'xlabel'), 'fontsize', QTEMP2);
                  set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'ylabel'), 'fontsize', QTEMP2);
                  set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'zlabel'), 'fontsize', QTEMP2);
                end
                if QmatNMR.uiInput3a
                  set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'xlabel'), 'fontweight', QTEMP3);
                  set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'ylabel'), 'fontweight', QTEMP3);
                  set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'zlabel'), 'fontweight', QTEMP3);
                end
                if QmatNMR.uiInput4a
                  set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'xlabel'), 'fontangle', QTEMP4);
                  set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'ylabel'), 'fontangle', QTEMP4);
                  set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'zlabel'), 'fontangle', QTEMP4);
                end
              end
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
  
      disp('Font properties changed for selected axes ...');
  
  
    elseif (QmatNMR.uiInput8 == 2)			%Apply to all axes
      QmatNMR.AllAxes = findobj(QmatNMR.CurrentFigure, 'type', 'axes', 'tag', 'RegularAxis');
  
      for QTEMP5 = 1:length(QmatNMR.AllAxes)
        QmatNMR.AxesNR = get(QmatNMR.AllAxes(QTEMP5), 'userdata');
  
        if ~isempty(QmatNMR.AxesNR)
  	if (QmatNMR.uiInput5 == 1)		%change axis
            if QmatNMR.uiInput1a
              set(QmatNMR.AllAxes(QTEMP5), 'fontname', QTEMP1);
            end
            if QmatNMR.uiInput2a
              set(QmatNMR.AllAxes(QTEMP5), 'fontsize', QTEMP2);
            end
            if QmatNMR.uiInput3a
              set(QmatNMR.AllAxes(QTEMP5), 'fontweight', QTEMP3);
            end
            if QmatNMR.uiInput4a
              set(QmatNMR.AllAxes(QTEMP5), 'fontangle', QTEMP4);
            end
  
            if QmatNMR.contcolorbar(QmatNMR.AxesNR)	%A colorbar is present in the current plot --> make sure it is updated properly
              if QmatNMR.uiInput1a
                set(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'fontname', QTEMP1);
              end
              if QmatNMR.uiInput2a
                set(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'fontsize', QTEMP2);
              end
              if QmatNMR.uiInput3a
                set(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'fontweight', QTEMP3);
              end
              if QmatNMR.uiInput4a
                set(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'fontangle', QTEMP4);
              end
            end
  	end
  
  	if (QmatNMR.uiInput7 == 1)		%change title
            if QmatNMR.uiInput1a
              set(get(QmatNMR.AllAxes(QTEMP5), 'title'), 'fontname', QTEMP1);
            end
            if QmatNMR.uiInput2a
              set(get(QmatNMR.AllAxes(QTEMP5), 'title'), 'fontsize', QTEMP2);
            end
            if QmatNMR.uiInput3a
              set(get(QmatNMR.AllAxes(QTEMP5), 'title'), 'fontweight', QTEMP3);
            end
            if QmatNMR.uiInput4a
              set(get(QmatNMR.AllAxes(QTEMP5), 'title'), 'fontangle', QTEMP4);
            end
  
  
            %
            %In case of a polar plot then we need to access the axis texts differently
            %
            if QmatNMR.uiInput1a
              set(findobj(allchild(QmatNMR.AllAxes(QTEMP5)), 'tag', 'PolarPlotAxisText'), 'fontname', QTEMP1);
            end
            if QmatNMR.uiInput2a
              set(findobj(allchild(QmatNMR.AllAxes(QTEMP5)), 'tag', 'PolarPlotAxisText'), 'fontsize', QTEMP2);
            end
            if QmatNMR.uiInput3a
              set(findobj(allchild(QmatNMR.AllAxes(QTEMP5)), 'tag', 'PolarPlotAxisText'), 'fontweight', QTEMP3);
            end
            if QmatNMR.uiInput4a
              set(findobj(allchild(QmatNMR.AllAxes(QTEMP5)), 'tag', 'PolarPlotAxisText'), 'fontangle', QTEMP4);
            end
  
  
            %
            %Regular axes are checked for colorbars so these can also be changed.
            %
            if QmatNMR.contcolorbar(QmatNMR.AxesNR)     %A colorbar is present in the current plot --> make sure it is updated properly
              if QmatNMR.uiInput1a
                set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'title'), 'fontname', QTEMP1);
              end
              if QmatNMR.uiInput2a
                set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'title'), 'fontsize', QTEMP2);
              end
              if QmatNMR.uiInput3a
                set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'title'), 'fontweight', QTEMP3);
              end
              if QmatNMR.uiInput4a
                set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'title'), 'fontangle', QTEMP4);
              end
            end
  	end
  
  	if (QmatNMR.uiInput6 == 1) 		%change axis labels
            if QmatNMR.uiInput1a
              set(get(QmatNMR.AllAxes(QTEMP5), 'xlabel'), 'fontname', QTEMP1);
              set(get(QmatNMR.AllAxes(QTEMP5), 'ylabel'), 'fontname', QTEMP1);
              set(get(QmatNMR.AllAxes(QTEMP5), 'zlabel'), 'fontname', QTEMP1);
            end
            if QmatNMR.uiInput2a
              set(get(QmatNMR.AllAxes(QTEMP5), 'xlabel'), 'fontsize', QTEMP2);
              set(get(QmatNMR.AllAxes(QTEMP5), 'ylabel'), 'fontsize', QTEMP2);
              set(get(QmatNMR.AllAxes(QTEMP5), 'zlabel'), 'fontsize', QTEMP2);
            end
            if QmatNMR.uiInput3a
              set(get(QmatNMR.AllAxes(QTEMP5), 'xlabel'), 'fontweight', QTEMP3);
              set(get(QmatNMR.AllAxes(QTEMP5), 'ylabel'), 'fontweight', QTEMP3);
              set(get(QmatNMR.AllAxes(QTEMP5), 'zlabel'), 'fontweight', QTEMP3);
            end
            if QmatNMR.uiInput4a
              set(get(QmatNMR.AllAxes(QTEMP5), 'xlabel'), 'fontangle', QTEMP4);
              set(get(QmatNMR.AllAxes(QTEMP5), 'ylabel'), 'fontangle', QTEMP4);
              set(get(QmatNMR.AllAxes(QTEMP5), 'zlabel'), 'fontangle', QTEMP4);
            end
  
            %
            %In case of a polar plot then we need to access the axis labels differently
            %
            if QmatNMR.uiInput1a
              set(findobj(allchild(QmatNMR.AllAxes(QTEMP5)), 'tag', 'PolarPlotAxisLabelText'), 'fontname', QTEMP1);
            end
            if QmatNMR.uiInput2a
              set(findobj(allchild(QmatNMR.AllAxes(QTEMP5)), 'tag', 'PolarPlotAxisLabelText'), 'fontsize', QTEMP2);
            end
            if QmatNMR.uiInput3a
              set(findobj(allchild(QmatNMR.AllAxes(QTEMP5)), 'tag', 'PolarPlotAxisLabelText'), 'fontweight', QTEMP3);
            end
            if QmatNMR.uiInput4a
              set(findobj(allchild(QmatNMR.AllAxes(QTEMP5)), 'tag', 'PolarPlotAxisLabelText'), 'fontangle', QTEMP4);
            end
  
  
            %
            %Regular axes are checked for colorbars so these can also be changed.
            %
            if strcmp(get(QmatNMR.AllAxes(QTEMP5), 'tag'), 'RegularAxis')
              if QmatNMR.contcolorbar(QmatNMR.AxesNR)	%A colorbar is present in the current plot --> make sure it is updated properly
                if QmatNMR.uiInput1a
                  set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'xlabel'), 'fontname', QTEMP1);
                  set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'ylabel'), 'fontname', QTEMP1);
                  set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'zlabel'), 'fontname', QTEMP1);
                end
                if QmatNMR.uiInput2a
                  set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'xlabel'), 'fontsize', QTEMP2);
                  set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'ylabel'), 'fontsize', QTEMP2);
                  set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'zlabel'), 'fontsize', QTEMP2);
                end
                if QmatNMR.uiInput3a
                  set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'xlabel'), 'fontweight', QTEMP3);
                  set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'ylabel'), 'fontweight', QTEMP3);
                  set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'zlabel'), 'fontweight', QTEMP3);
                end
                if QmatNMR.uiInput4a
                  set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'xlabel'), 'fontangle', QTEMP4);
                  set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'ylabel'), 'fontangle', QTEMP4);
                  set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'zlabel'), 'fontangle', QTEMP4);
                end
              end
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
  
      disp('Font properties changed for all axes ...');
  
  
    elseif (QmatNMR.uiInput8 == 3)			%Apply to the current row of subplots
      QmatNMR.AllAxes = findobj(findobj(QTEMP21, 'type', 'axes', 'tag', 'RegularAxis'), 'selected', 'on');
      if isempty(QmatNMR.AllAxes)
        QmatNMR.AllAxes = QTEMP20;
      end
      %
      %demand that at most 1 subplot is selected
      %
      if (length(QmatNMR.AllAxes) > 1)
        disp('matNMR WARNING: only 1 subplot may be selected to work on the current row');
        askfont
        return
      end
      %
      %Select all subplots and determine the position of the current row
      %
      QTEMP17 = get(QmatNMR.AllAxes, 'position');
      QmatNMR.AllAxes = findobj(QTEMP21, 'type', 'axes', 'tag', 'RegularAxis');
  
      for QTEMP5 = 1:length(QmatNMR.AllAxes)
        QmatNMR.AxesNR = get(QmatNMR.AllAxes(QTEMP5), 'userdata');
  
        if ~isempty(QmatNMR.AxesNR)
          QTEMP18 = get(QmatNMR.AllAxes(QTEMP5), 'position');
          if (QTEMP18(2) == QTEMP17(2)) 	%check whether this axis has the correct position
            if (QmatNMR.uiInput5 == 1)		%change axis
              if QmatNMR.uiInput1a
                set(QmatNMR.AllAxes(QTEMP5), 'fontname', QTEMP1);
              end
              if QmatNMR.uiInput2a
                set(QmatNMR.AllAxes(QTEMP5), 'fontsize', QTEMP2);
              end
              if QmatNMR.uiInput3a
                set(QmatNMR.AllAxes(QTEMP5), 'fontweight', QTEMP3);
              end
              if QmatNMR.uiInput4a
                set(QmatNMR.AllAxes(QTEMP5), 'fontangle', QTEMP4);
              end
  
              if QmatNMR.contcolorbar(QmatNMR.AxesNR)	%A colorbar is present in the current plot --> make sure it is updated properly
                if QmatNMR.uiInput1a
                  set(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'fontname', QTEMP1);
                end
                if QmatNMR.uiInput2a
                  set(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'fontsize', QTEMP2);
                end
                if QmatNMR.uiInput3a
                  set(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'fontweight', QTEMP3);
                end
                if QmatNMR.uiInput4a
                  set(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'fontangle', QTEMP4);
                end
              end
    	  end
  
    	  if (QmatNMR.uiInput7 == 1)		%change title
              if QmatNMR.uiInput1a
                set(get(QmatNMR.AllAxes(QTEMP5), 'title'), 'fontname', QTEMP1);
              end
              if QmatNMR.uiInput2a
                set(get(QmatNMR.AllAxes(QTEMP5), 'title'), 'fontsize', QTEMP2);
              end
              if QmatNMR.uiInput3a
                set(get(QmatNMR.AllAxes(QTEMP5), 'title'), 'fontweight', QTEMP3);
              end
              if QmatNMR.uiInput4a
                set(get(QmatNMR.AllAxes(QTEMP5), 'title'), 'fontangle', QTEMP4);
              end
  
              %
              %In case of a polar plot then we need to access the axis texts differently
              %
              if QmatNMR.uiInput1a
                set(findobj(allchild(QmatNMR.AllAxes(QTEMP5)), 'tag', 'PolarPlotAxisText'), 'fontname', QTEMP1);
              end
              if QmatNMR.uiInput2a
                set(findobj(allchild(QmatNMR.AllAxes(QTEMP5)), 'tag', 'PolarPlotAxisText'), 'fontsize', QTEMP2);
              end
              if QmatNMR.uiInput3a
                set(findobj(allchild(QmatNMR.AllAxes(QTEMP5)), 'tag', 'PolarPlotAxisText'), 'fontweight', QTEMP3);
              end
              if QmatNMR.uiInput4a
                set(findobj(allchild(QmatNMR.AllAxes(QTEMP5)), 'tag', 'PolarPlotAxisText'), 'fontangle', QTEMP4);
              end
  
              %
              %Regular axes are checked for colorbars so these can also be changed.
              %
              if QmatNMR.contcolorbar(QmatNMR.AxesNR)	%A colorbar is present in the current plot --> make sure it is updated properly
                if QmatNMR.uiInput1a
                  set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'title'), 'fontname', QTEMP1);
                end
                if QmatNMR.uiInput2a
                  set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'title'), 'fontsize', QTEMP2);
                end
                if QmatNMR.uiInput3a
                  set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'title'), 'fontweight', QTEMP3);
                end
                if QmatNMR.uiInput4a
                  set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'title'), 'fontangle', QTEMP4);
                end
              end
    	  end
  
  
    	  if (QmatNMR.uiInput6 == 1) 		%change axis labels
              if QmatNMR.uiInput1a
                set(get(QmatNMR.AllAxes(QTEMP5), 'xlabel'), 'fontname', QTEMP1);
                set(get(QmatNMR.AllAxes(QTEMP5), 'ylabel'), 'fontname', QTEMP1);
                set(get(QmatNMR.AllAxes(QTEMP5), 'zlabel'), 'fontname', QTEMP1);
              end
              if QmatNMR.uiInput2a
                set(get(QmatNMR.AllAxes(QTEMP5), 'xlabel'), 'fontsize', QTEMP2);
                set(get(QmatNMR.AllAxes(QTEMP5), 'ylabel'), 'fontsize', QTEMP2);
                set(get(QmatNMR.AllAxes(QTEMP5), 'zlabel'), 'fontsize', QTEMP2);
              end
              if QmatNMR.uiInput3a
                set(get(QmatNMR.AllAxes(QTEMP5), 'xlabel'), 'fontweight', QTEMP3);
                set(get(QmatNMR.AllAxes(QTEMP5), 'ylabel'), 'fontweight', QTEMP3);
                set(get(QmatNMR.AllAxes(QTEMP5), 'zlabel'), 'fontweight', QTEMP3);
              end
              if QmatNMR.uiInput4a
                set(get(QmatNMR.AllAxes(QTEMP5), 'xlabel'), 'fontangle', QTEMP4);
                set(get(QmatNMR.AllAxes(QTEMP5), 'ylabel'), 'fontangle', QTEMP4);
                set(get(QmatNMR.AllAxes(QTEMP5), 'zlabel'), 'fontangle', QTEMP4);
              end
  
              %
              %In case of a polar plot then we need to access the axis labels differently
              %
              if QmatNMR.uiInput1a
                set(findobj(allchild(QmatNMR.AllAxes(QTEMP5)), 'tag', 'PolarPlotAxisLabelText'), 'fontname', QTEMP1);
              end
              if QmatNMR.uiInput2a
                set(findobj(allchild(QmatNMR.AllAxes(QTEMP5)), 'tag', 'PolarPlotAxisLabelText'), 'fontsize', QTEMP2);
              end
              if QmatNMR.uiInput3a
                set(findobj(allchild(QmatNMR.AllAxes(QTEMP5)), 'tag', 'PolarPlotAxisLabelText'), 'fontweight', QTEMP3);
              end
              if QmatNMR.uiInput4a
                set(findobj(allchild(QmatNMR.AllAxes(QTEMP5)), 'tag', 'PolarPlotAxisLabelText'), 'fontangle', QTEMP4);
              end
  
  
              %
              %Regular axes are checked for colorbars so these can also be changed.
              %
              if strcmp(get(QmatNMR.AllAxes(QTEMP5), 'tag'), 'RegularAxis')
                if QmatNMR.contcolorbar(QmatNMR.AxesNR)	%A colorbar is present in the current plot --> make sure it is updated properly
                  if QmatNMR.uiInput1a
                    set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'xlabel'), 'fontname', QTEMP1);
                    set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'ylabel'), 'fontname', QTEMP1);
                    set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'zlabel'), 'fontname', QTEMP1);
                  end
                  if QmatNMR.uiInput2a
                    set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'xlabel'), 'fontsize', QTEMP2);
                    set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'ylabel'), 'fontsize', QTEMP2);
                    set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'zlabel'), 'fontsize', QTEMP2);
                  end
                  if QmatNMR.uiInput3a
                    set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'xlabel'), 'fontweight', QTEMP3);
                    set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'ylabel'), 'fontweight', QTEMP3);
                    set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'zlabel'), 'fontweight', QTEMP3);
                  end
                  if QmatNMR.uiInput4a
                    set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'xlabel'), 'fontangle', QTEMP4);
                    set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'ylabel'), 'fontangle', QTEMP4);
                    set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'zlabel'), 'fontangle', QTEMP4);
                  end
                end
              end
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
  
      disp('Font properties changed for all axes in the current row ...');
  
  
    elseif (QmatNMR.uiInput8 == 4)			%Apply to the current column of subplots
      QmatNMR.AllAxes = findobj(findobj(QTEMP21, 'type', 'axes', 'tag', 'RegularAxis'), 'selected', 'on');
      if isempty(QmatNMR.AllAxes)
        QmatNMR.AllAxes = QTEMP20;
      end
      %
      %demand that at most 1 subplot is selected
      %
      if (length(QmatNMR.AllAxes) > 1)
        disp('matNMR WARNING: only 1 subplot may be selected to work on the current column');
        askfont
        return
      end
      %
      %Select all subplots and determine the position of the current row
      %
      QTEMP17 = get(QmatNMR.AllAxes, 'position');
      QmatNMR.AllAxes = findobj(QTEMP21, 'type', 'axes', 'tag', 'RegularAxis');
  
      for QTEMP5 = 1:length(QmatNMR.AllAxes)
        QmatNMR.AxesNR = get(QmatNMR.AllAxes(QTEMP5), 'userdata');
  
        if ~isempty(QmatNMR.AxesNR)
          QTEMP18 = get(QmatNMR.AllAxes(QTEMP5), 'position');
          if (QTEMP18(1) == QTEMP17(1)) 	%check whether this axis has the correct position
            if (QmatNMR.uiInput5 == 1)		%change axis
              if QmatNMR.uiInput1a
                set(QmatNMR.AllAxes(QTEMP5), 'fontname', QTEMP1);
              end
              if QmatNMR.uiInput2a
                set(QmatNMR.AllAxes(QTEMP5), 'fontsize', QTEMP2);
              end
              if QmatNMR.uiInput3a
                set(QmatNMR.AllAxes(QTEMP5), 'fontweight', QTEMP3);
              end
              if QmatNMR.uiInput4a
                set(QmatNMR.AllAxes(QTEMP5), 'fontangle', QTEMP4);
              end
  
              if QmatNMR.contcolorbar(QmatNMR.AxesNR)	%A colorbar is present in the current plot --> make sure it is updated properly
                if QmatNMR.uiInput1a
                  set(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'fontname', QTEMP1);
                end
                if QmatNMR.uiInput2a
                  set(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'fontsize', QTEMP2);
                end
                if QmatNMR.uiInput3a
                  set(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'fontweight', QTEMP3);
                end
                if QmatNMR.uiInput4a
                  set(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'fontangle', QTEMP4);
                end
              end
    	end
  
      	  if (QmatNMR.uiInput7 == 1)		%change title
              if QmatNMR.uiInput1a
                set(get(QmatNMR.AllAxes(QTEMP5), 'title'), 'fontname', QTEMP1);
              end
              if QmatNMR.uiInput2a
                set(get(QmatNMR.AllAxes(QTEMP5), 'title'), 'fontsize', QTEMP2);
              end
              if QmatNMR.uiInput3a
                set(get(QmatNMR.AllAxes(QTEMP5), 'title'), 'fontweight', QTEMP3);
              end
              if QmatNMR.uiInput4a
                set(get(QmatNMR.AllAxes(QTEMP5), 'title'), 'fontangle', QTEMP4);
              end
  
              %
              %In case of a polar plot then we need to access the axis texts differently
              %
              if QmatNMR.uiInput1a
                set(findobj(allchild(QmatNMR.AllAxes(QTEMP5)), 'tag', 'PolarPlotAxisText'), 'fontname', QTEMP1);
              end
              if QmatNMR.uiInput2a
                set(findobj(allchild(QmatNMR.AllAxes(QTEMP5)), 'tag', 'PolarPlotAxisText'), 'fontsize', QTEMP2);
              end
              if QmatNMR.uiInput3a
                set(findobj(allchild(QmatNMR.AllAxes(QTEMP5)), 'tag', 'PolarPlotAxisText'), 'fontweight', QTEMP3);
              end
              if QmatNMR.uiInput4a
                set(findobj(allchild(QmatNMR.AllAxes(QTEMP5)), 'tag', 'PolarPlotAxisText'), 'fontangle', QTEMP4);
              end
  
              %
              %Regular axes are checked for colorbars so these can also be changed.
              %
              if QmatNMR.contcolorbar(QmatNMR.AxesNR)	%A colorbar is present in the current plot --> make sure it is updated properly
                if QmatNMR.uiInput1a
                  set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'title'), 'fontname', QTEMP1);
                end
                if QmatNMR.uiInput2a
                  set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'title'), 'fontsize', QTEMP2);
                end
                if QmatNMR.uiInput3a
                  set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'title'), 'fontweight', QTEMP3);
                end
                if QmatNMR.uiInput4a
                  set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'title'), 'fontangle', QTEMP4);
                end
              end
      	  end
  
    	  if (QmatNMR.uiInput6 == 1) 		%change axis labels
              if QmatNMR.uiInput1a
                set(get(QmatNMR.AllAxes(QTEMP5), 'xlabel'), 'fontname', QTEMP1);
                set(get(QmatNMR.AllAxes(QTEMP5), 'ylabel'), 'fontname', QTEMP1);
                set(get(QmatNMR.AllAxes(QTEMP5), 'zlabel'), 'fontname', QTEMP1);
              end
              if QmatNMR.uiInput2a
                set(get(QmatNMR.AllAxes(QTEMP5), 'xlabel'), 'fontsize', QTEMP2);
                set(get(QmatNMR.AllAxes(QTEMP5), 'ylabel'), 'fontsize', QTEMP2);
                set(get(QmatNMR.AllAxes(QTEMP5), 'zlabel'), 'fontsize', QTEMP2);
              end
              if QmatNMR.uiInput3a
                set(get(QmatNMR.AllAxes(QTEMP5), 'xlabel'), 'fontweight', QTEMP3);
                set(get(QmatNMR.AllAxes(QTEMP5), 'ylabel'), 'fontweight', QTEMP3);
                set(get(QmatNMR.AllAxes(QTEMP5), 'zlabel'), 'fontweight', QTEMP3);
              end
              if QmatNMR.uiInput4a
                set(get(QmatNMR.AllAxes(QTEMP5), 'xlabel'), 'fontangle', QTEMP4);
                set(get(QmatNMR.AllAxes(QTEMP5), 'ylabel'), 'fontangle', QTEMP4);
                set(get(QmatNMR.AllAxes(QTEMP5), 'zlabel'), 'fontangle', QTEMP4);
              end
  
              %
              %In case of a polar plot then we need to access the axis labels differently
              %
              if QmatNMR.uiInput1a
                set(findobj(allchild(QmatNMR.AllAxes(QTEMP5)), 'tag', 'PolarPlotAxisLabelText'), 'fontname', QTEMP1);
              end
              if QmatNMR.uiInput2a
                set(findobj(allchild(QmatNMR.AllAxes(QTEMP5)), 'tag', 'PolarPlotAxisLabelText'), 'fontsize', QTEMP2);
              end
              if QmatNMR.uiInput3a
                set(findobj(allchild(QmatNMR.AllAxes(QTEMP5)), 'tag', 'PolarPlotAxisLabelText'), 'fontweight', QTEMP3);
              end
              if QmatNMR.uiInput4a
                set(findobj(allchild(QmatNMR.AllAxes(QTEMP5)), 'tag', 'PolarPlotAxisLabelText'), 'fontangle', QTEMP4);
              end
  
              %
              %Regular axes are checked for colorbars so these can also be changed.
              %
              if strcmp(get(QmatNMR.AllAxes(QTEMP5), 'tag'), 'RegularAxis')
                if QmatNMR.contcolorbar(QmatNMR.AxesNR)	%A colorbar is present in the current plot --> make sure it is updated properly
                  if QmatNMR.uiInput1a
                    set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'xlabel'), 'fontname', QTEMP1);
                    set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'ylabel'), 'fontname', QTEMP1);
                    set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'zlabel'), 'fontname', QTEMP1);
                  end
                  if QmatNMR.uiInput2a
                    set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'xlabel'), 'fontsize', QTEMP2);
                    set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'ylabel'), 'fontsize', QTEMP2);
                    set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'zlabel'), 'fontsize', QTEMP2);
                  end
                  if QmatNMR.uiInput3a
                    set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'xlabel'), 'fontweight', QTEMP3);
                    set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'ylabel'), 'fontweight', QTEMP3);
                    set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'zlabel'), 'fontweight', QTEMP3);
                  end
                  if QmatNMR.uiInput4a
                    set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'xlabel'), 'fontangle', QTEMP4);
                    set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'ylabel'), 'fontangle', QTEMP4);
                    set(get(QmatNMR.contcolorbar(QmatNMR.AxesNR), 'zlabel'), 'fontangle', QTEMP4);
                  end
                end
              end
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
  
      disp('Font properties changed for all axes in the current column ...');
    end
  
  else
    disp('Setting of the font properties was cancelled ...');
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
