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
%dispstack3d.m plots a 3D stack plot
%04-01-'00
%03-10-'00


try
  %
  %Change the mouse pointer into a clock
  %
    watch;
  
  
  %
  %be sure to work in the current 2D/3D Viewer window
  %
    %axes(QmatNMR.AxisHandle2D3D);
    set(QmatNMR.Fig2D3D, 'currentaxes', QmatNMR.AxisHandle2D3D);
    QmatNMR.Q2D3DUserData = get(QmatNMR.Fig2D3D, 'userdata');		%retrieve the figure and plot handles/parameters
  
  
  %
  %prevent that new plot is drawn in the axis of the supertitle
  %if the current axis is the supertitle axis then put the plot in the first subplot
  %
    if (QmatNMR.AxisHandle2D3D == findobj(allchild(QmatNMR.Fig2D3D), 'tag', 'SuperTitleAxis'))
      %axes(findobj(allchild(QmatNMR.Fig2D3D), 'type', 'axes', 'userdata', 1));
      set(QmatNMR.Fig2D3D, 'currentaxes', findobj(allchild(QmatNMR.Fig2D3D), 'type', 'axes', 'userdata', 1));
      QmatNMR.AxisNR2D3D = 1;
      QmatNMR.AxisHandle2D3D = QmatNMR.Q2D3DUserData.AxesHandles(1);
      %axes(QmatNMR.AxisHandle2D3D);
      set(QmatNMR.Fig2D3D, 'currentaxes', QmatNMR.AxisHandle2D3D);
    end
  
  
  %
  %clear any previous peak list
  %
    QmatNMR.PeakList = [];
    
    
  %
  %disable the zoom function if the user has requested a view different from [0 90]
  %as in 3D mode the zoom function will give an error message.
  %  
    if (QmatNMR.Q2D3DUserData.Zoom) & ~isequal([QmatNMR.az QmatNMR.el], [0 90]) 	%disable the zoom function
      view([0 90])
      ZoomMatNMR 2D3DViewer off;		
      set(QmatNMR.c10, 'value', 0);
      QmatNMR.Q2D3DUserData.Zoom = 0;
    end
  
  
  %
  %Remember axis limits and color axis settings if the hold state is on for the current axis
  %
    if (ishold)
      QmatNMR.Q2D3DAxisData.AxisLims = axis;	%read current axis limits
      QmatNMR.Q2D3DAxisData.CLim = caxis; 	%read current color axis limits
      QmatNMR.Q2D3DAxisData.XDir = get(QmatNMR.AxisHandle2D3D, 'xdir');
      QmatNMR.Q2D3DAxisData.YDir = get(QmatNMR.AxisHandle2D3D, 'ydir');
    end
  
  
  %
  %If a colorbar is present this will be deleted first and added again afterwards.
  %This prevents crashing of matNMR when a user does a CTRL-C (break) while plotting
  %a spectrum. 
  %
    if QmatNMR.contcolorbar(QmatNMR.AxisNR2D3D)	%A colorbar is present in the current plot --> make sure it is updated properly
      QmatNMR.ColorBarPresent = 1;			%temporary variable to denote that a color bar must be added again later
      try
        delete(QmatNMR.contcolorbar(QmatNMR.AxisNR2D3D));
      catch
        %
        %issue a warning statement and wait for the response
        %
        beep
        QuiInput(['matNMR WARNING:' char(10)  char(10) 'The current 2D/3D viewer window appears' char(10) 'to be corrupted! Please close this window or' char(10) 'select a new subplot configuration.'], 'Continue', '');
        waitforbuttonpress
        QmatNMR.ColorBarPresent = 0;
      end
      QmatNMR.ContColorbarIndicator(QmatNMR.AxisNR2D3D) = 0;
      QmatNMR.Q2D3DUserData.ColorBarIndicator = QmatNMR.ContColorbarIndicator;
      QmatNMR.contcolorbar(QmatNMR.AxisNR2D3D) = 0;
      QmatNMR.Q2D3DUserData.ColorBarHandles = QmatNMR.contcolorbar;
      set(QmatNMR.Fig2D3D, 'userdata', QmatNMR.Q2D3DUserData);	%save all figure parameters back into the userdata
    else
      QmatNMR.ColorBarPresent = 0;  
    end
  
  
  %
  %Determine the type of stack plot from the 2D/3D panel window
  %After that check the axis variables and perform the plot
  %
    QmatNMR.stackdisplay = QmatNMR.stackdisplaystring(get(QmatNMR.R17, 'value'), :);
    CheckAxisCont
    
    %
    %determine whether the hold property is on. If not the afterwards this must be 
    %set to replacechildren again
    %
    if ishold
      QTEMP10 = 0;		%hold on
    else
      QTEMP10 = 1;		%hold off
    end    
  
    %
    %now plot the spectra ...
    %
    if (QmatNMR.Stack3DDimension == 1)	%TD2 along the x-axis
      QTEMP = ones(1, length(QmatNMR.Axis2D3DTD2Plot));
    
      for QTEMP2 = 1:length(QmatNMR.Axis2D3DTD1Plot)
        QmatNMR.Stack3DPlotCommand = ['plot3(QmatNMR.Axis2D3DTD2Plot, QTEMP*QmatNMR.Axis2D3DTD1Plot(QTEMP2), ' QmatNMR.stackdisplay '(QmatNMR.Spec2D3DPlot(QTEMP2, :)), QmatNMR.LineColor);'];
        eval(QmatNMR.Stack3DPlotCommand);
        
        if (QTEMP2==1)
          hold on
        end  
      end
  
      %
      %set the hold off if necessary
      %  
      if (QTEMP10)
        set(gca, 'nextplot', 'replacechildren');
        QTEMP10=0;
      end  
  
      if (~ishold)  
        QmatNMR.aswaarden = [QmatNMR.Axis2D3DTD2Plot(1) QmatNMR.Axis2D3DTD2Plot(length(QmatNMR.Axis2D3DTD2)) QmatNMR.Axis2D3DTD1Plot(1) QmatNMR.Axis2D3DTD1Plot(length(QmatNMR.Axis2D3DTD1))];
        setappdata(QmatNMR.AxisHandle2D3D, 'ZoomLimitsMatNMR', QmatNMR.aswaarden);
        axis(QmatNMR.aswaarden);
      end  
    
    else				%TD1 along the x-axis
    
      QTEMP = ones(1, length(QmatNMR.Axis2D3DTD1Plot));
      for QTEMP2 = 1:length(QmatNMR.Axis2D3DTD2Plot)
        QmatNMR.Stack3DPlotCommand = ['plot3(QmatNMR.Axis2D3DTD1Plot, QTEMP*QmatNMR.Axis2D3DTD2Plot(QTEMP2), ' QmatNMR.stackdisplay '(QmatNMR.Spec2D3DPlot(:, QTEMP2)), ''y'');'];
        eval(QmatNMR.Stack3DPlotCommand);
        
        if (QTEMP2==1)
          hold on
        end  
      end
  
      %
      %set the hold off if necessary
      %  
      if (QTEMP10)
        set(gca, 'nextplot', 'replacechildren');
        QTEMP10=0;
      end  
  
      if (~ishold)  
        QmatNMR.aswaarden = [QmatNMR.Axis2D3DTD1Plot(1) QmatNMR.Axis2D3DTD1Plot(length(QmatNMR.Axis2D3DTD1)) QmatNMR.Axis2D3DTD2Plot(1) QmatNMR.Axis2D3DTD2Plot(length(QmatNMR.Axis2D3DTD2))];
        setappdata(QmatNMR.AxisHandle2D3D, 'ZoomLimitsMatNMR', QmatNMR.aswaarden);
        axis(QmatNMR.aswaarden);
      end  
    end
    
  
  
  %
  %save the offset and slope of each axis ruler in the userdata of the axis
  %then always the intensity can be calculated properly (for 'get position' and
  %'peak picking')
  %In case a non-linear axis has been supplied the whole axis vector will be saved
  %in the userdata of the figure window
  %
    %define the axis increments and offsets for TD2 and TD1 respectively
    QTEMP2 = [(QmatNMR.Axis2D3DTD2(2)-QmatNMR.Axis2D3DTD2(1)) (2*QmatNMR.Axis2D3DTD2(1)-QmatNMR.Axis2D3DTD2(2))];
    QTEMP3 = [(QmatNMR.Axis2D3DTD1(2)-QmatNMR.Axis2D3DTD1(1)) (2*QmatNMR.Axis2D3DTD1(1)-QmatNMR.Axis2D3DTD1(2))];
    
    %now-check whether the axes are linear, if not set the axis increment to 0 and put the entire vector into the userdata
    if LinearAxis(QmatNMR.Axis2D3DTD2)
      QmatNMR.Q2D3DUserData.PlotParams(QmatNMR.AxisNR2D3D).AxisTD2 = [];		%linear axis -> clear variable
    else
  
      QTEMP2(1) = 0;						%non-linear axis -> add axis vector
      QmatNMR.Q2D3DUserData.PlotParams(QmatNMR.AxisNR2D3D).AxisTD2 = QmatNMR.Axis2D3DTD2;
    end  
  
    if LinearAxis(QmatNMR.Axis2D3DTD1)
      QmatNMR.Q2D3DUserData.PlotParams(QmatNMR.AxisNR2D3D).AxisTD1 = [];		%linear axis -> clear variable
    else
  
      QTEMP3(1) = 0;						%non-linear axis -> add axis vector
      QmatNMR.Q2D3DUserData.PlotParams(QmatNMR.AxisNR2D3D).AxisTD1 = QmatNMR.Axis2D3DTD1;
    end  
    QmatNMR.Q2D3DUserData.PlotParams(QmatNMR.AxisNR2D3D).AxisProps = [QTEMP2 QTEMP3];
    QmatNMR.Q2D3DUserData.PlotParams(QmatNMR.AxisNR2D3D).AnalyserAxisTD2 = QmatNMR.Axis2D3DTD2;
    QmatNMR.Q2D3DUserData.PlotParams(QmatNMR.AxisNR2D3D).AnalyserAxisTD1 = QmatNMR.Axis2D3DTD1;
    
  
  %
  %switch the rendering mode to 'painters' (is faster) if no surface and light objects exist in the window
  %
    if ((isempty(findobj(allchild(QmatNMR.Fig2D3D), 'type', 'surface'))) & (isempty(findobj(allchild(QmatNMR.Fig2D3D), 'type', 'light'))))
      %this is temporarily blocked under Windows because Matlab 7.0 screws up the colour map in painters mode
      if (QmatNMR.Platform ~= QmatNMR.PlatformPC)
        set(QmatNMR.Fig2D3D, 'renderer', 'painters');
      end
    end
  
  
  %
  %Update the axis scaling and other things to accomodate the new plot
  %
    if (~ishold) 	%HOLD = OFF
    %
    %Set some axis properties
    %
      %
      %draw a box around the axis if the view is 2D
      %
      if ((QmatNMR.stackaz == 0) & (QmatNMR.stackel == 90))
        QTEMP2 = 'on';
      else
        QTEMP2 = 'off';
      end
      axis on
      set(QmatNMR.AxisHandle2D3D, 'FontSize', QmatNMR.TextSize, ...
                           'FontName', QmatNMR.TextFont, ...
                           'FontAngle', QmatNMR.TextAngle, ...
                           'FontWeight', QmatNMR.TextWeight, ...
                           'LineWidth', QmatNMR.LineWidth, ...
                           'xcolor', QmatNMR.ColorScheme.AxisFore, ...
                           'ycolor', QmatNMR.ColorScheme.AxisFore, ...
                           'zcolor', QmatNMR.ColorScheme.AxisFore, ...
                           'xscale', 'linear', ...
                           'yscale', 'linear', ...
                           'zscale', 'linear', ...
                           'xgrid','off', ...
                           'ygrid','off', ...
                           'zgrid','off', ...
                           'view', [QmatNMR.stackaz QmatNMR.stackel], ...
                           'climmode', 'auto', ...
                           'zlimmode', 'auto', ...
                           'xtickmode', 'auto', ...
                           'ytickmode', 'auto', ...
                           'ztickmode', 'auto', ...
                           'xticklabelmode', 'auto', ...
                           'yticklabelmode', 'auto', ...
                           'zticklabelmode', 'auto', ...
                           'xdir', 'normal', ...
                           'ydir', 'normal', ...
                           'zdir', 'normal', ...
                           'box', QTEMP2);
  
  
      %set xdir and ydir axis property
        				%set xdir and ydir axis property according to whether they have ascending or descending axes
      if (QmatNMR.Axis2D3DTD2(1) < QmatNMR.Axis2D3DTD2(2))
        set(QmatNMR.AxisHandle2D3D, 'xdir', 'reverse');
      else  
        set(QmatNMR.AxisHandle2D3D, 'xdir', 'normal');
      end  
      if (QmatNMR.Axis2D3DTD1(1) < QmatNMR.Axis2D3DTD1(2))
        set(QmatNMR.AxisHandle2D3D, 'ydir', 'reverse');
      else  
        set(QmatNMR.AxisHandle2D3D, 'ydir', 'normal');
      end  
  
      stack3dreverse
      regelyaxis
      regelzaxis
    
      
      %Read in the current value for zlim to give user control of z-axis too
      QmatNMR.RZlim = get(QmatNMR.AxisHandle2D3D, 'zlim');
      QmatNMR.RZlim1 = QmatNMR.RZlim(1);
      QmatNMR.RZlim2 = QmatNMR.RZlim(2);
      set(QmatNMR.R29, 'string', QmatNMR.RZlim1);
      set(QmatNMR.R30, 'string', QmatNMR.RZlim2);
      grid off;
    
    
    %
    %Define the axis labels and title
    %
      QmatNMR.titelstring1 = ['3D Stack Plot from :    ' strrep(QmatNMR.SpecName2D3D, '_', '\_')];
      title(QmatNMR.titelstring1, 'Color', QmatNMR.ColorScheme.AxisFore);
  
  
    %
    %Store the plot type in the userdata
    %
    %1 = relative contours
    %2 = absolute contours
    %3 = mesh/surface plot
    %4 = stack 3D plot
    %5 = raster plot
    %6 = polar plot
    %7 = bar plot
    %8 = line plot
    %
    QmatNMR.Q2D3DUserData.PlotType(QmatNMR.AxisNR2D3D) = QmatNMR.Q2D3DPlotType;
  
  
    %
    %save the other plot parameters in the userdata
    %
      QmatNMR.Q2D3DUserData.PlotParams(QmatNMR.AxisNR2D3D).Name = QmatNMR.SpecName2D3D;
      QmatNMR.Q2D3DUserData.PlotParams(QmatNMR.AxisNR2D3D).MaxInt  = eval(['max(max(' QmatNMR.stackdisplay '(QmatNMR.Spec2D3DPlot)));']);
      QmatNMR.Q2D3DUserData.PlotParams(QmatNMR.AxisNR2D3D).MinInt  = eval(['min(min(' QmatNMR.stackdisplay '(QmatNMR.Spec2D3DPlot)));']);
      QmatNMR.Q2D3DUserData.PlotParams(QmatNMR.AxisNR2D3D).SizeTD2 = length(QmatNMR.Axis2D3DTD2);
      QmatNMR.Q2D3DUserData.PlotParams(QmatNMR.AxisNR2D3D).SizeTD1 = length(QmatNMR.Axis2D3DTD1);
      QmatNMR.Q2D3DUserData.PlotParams(QmatNMR.AxisNR2D3D).History = QmatNMR.History2D3D;
  
    else 	%HOLD = ON
      %
      %when the hold is on we don't do much because we assume that the first plot is most important
      %
      
      %
      %reset the axis limits
      %
      axis(QmatNMR.Q2D3DAxisData.AxisLims);
      
      %
      %reset the color axis scaling
      %
      caxis(QmatNMR.Q2D3DAxisData.CLim);
      
      %
      %reset the plot directions
      %
      set(gca, 'xdir', QmatNMR.Q2D3DAxisData.XDir, 'ydir', QmatNMR.Q2D3DAxisData.YDir);
    end
    
  
  %
  %In case we have many subplots we automatically restrict some things like axis labels etc
  %
    correctforsubplots
    
    
  %
  %Update the colorbar
  %
    if QmatNMR.ColorBarPresent	%A colorbar was present in the current plot --> make sure it is updated properly
      QmatNMR.contcolorbar(QmatNMR.AxisNR2D3D) = colorbarmatNMR('vert');
      QmatNMR.Q2D3DUserData.ColorBarHandles = QmatNMR.contcolorbar;
      QmatNMR.ContColorbarIndicator(QmatNMR.AxisNR2D3D) = 1;
      QmatNMR.Q2D3DUserData.ColorBarIndicator = QmatNMR.ContColorbarIndicator;
      QmatNMR.ColorBarPresent = 0;
    end
  
  
  %
  %Save all figure parameters back into the userdata
  %
    set(QmatNMR.Fig2D3D, 'userdata', QmatNMR.Q2D3DUserData);	%save all figure parameters back into the userdata
    
  
  %
  %adjust the posneg colormaps if that is the current colormap. This must be after the parameters have been
  %written to the figure userdata because the QColorMaps and AdjustPosNeg routines needs those!
  %
    if strcmp(QmatNMR.CurrentColorMap(1:14), 'QmatNMR.PosNeg')
      set(QmatNMR.c8, 'value', 3);
      contcmap
    end
  
  
  %
  %Execute a plotting macro if that was asked for
  %
    if ~isempty(QmatNMR.Q2D3DMacro)
      QmatNMR.LastMacroVariable = QmatNMR.Q2D3DMacro;
      QmatNMR.ExecutingMacro = eval(QmatNMR.Q2D3DMacro);
      tic
      RunMacro
      QmatNMR.Timing = toc;
      disp(['Finished executing macro "' QmatNMR.Q2D3DMacro '". Execution time (including rendering) was ' num2str(QmatNMR.Timing, 6) ' seconds']);
    end
  
  
  %
  %Wite message and change mouse pointer back to arrow head
  %
    disp('finished making 3D stack plot ...');
    Arrowhead;
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
