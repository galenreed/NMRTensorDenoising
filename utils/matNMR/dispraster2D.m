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
%dispraster2D.m creates a crude 2D surface plot of the current 2D spectrum in the matNMR main window.
%03-01-'00
%03-10-'00


try
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
  %Change the rendering mode such that it can handle 3D plots properly (slow mode)
  %
    set(QmatNMR.Fig2D3D, 'renderer', 'zbuffer');
  
  
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
  %In this routine the low-level plotting routine "surface" is used. This doesn't clear the
  %current axis, even though the 'nextplot' property has been set to 'replacechildren'!
  %
    if (~ ishold)
      cla
    end
  
  
  
  %
  %Determine the type of raster plot from the 2D/3D panel window
  %After that check the axis variables and perform the raster plot
  %
    QmatNMR.rasterdisplay = QmatNMR.rasterdisplaystring(get(QmatNMR.Rasterbut1, 'value'), :);
    CheckAxisCont
    [QTEMP5, QTEMP6] = size(QmatNMR.Spec2D3D);
    QmatNMR.Rastervec1 = QmatNMR.Axis2D3DTD2(1:QmatNMR.RasterSamplingFactor:QTEMP6);
    QmatNMR.Rastervec2 = QmatNMR.Axis2D3DTD1(1:QmatNMR.RasterSamplingFactor:QTEMP5);
    QmatNMR.Rastervec1Plot = QmatNMR.Axis2D3DTD2Plot(1:QmatNMR.RasterSamplingFactor:QTEMP6);
    QmatNMR.Rastervec2Plot = QmatNMR.Axis2D3DTD1Plot(1:QmatNMR.RasterSamplingFactor:QTEMP5);
  
    %
    %now we make sure that the size of the matrix is a multiple of the RasterSamplingFactor
    %
    QTEMP9 = zeros(ceil(QTEMP5/QmatNMR.RasterSamplingFactor)*QmatNMR.RasterSamplingFactor, ceil(QTEMP6/QmatNMR.RasterSamplingFactor)*QmatNMR.RasterSamplingFactor);
    QTEMP9(1:QTEMP5, 1:QTEMP6) = QmatNMR.Spec2D3DPlot;
    QTEMP7 = mod(QTEMP5, QmatNMR.RasterSamplingFactor);
    QTEMP8 = mod(QTEMP6, QmatNMR.RasterSamplingFactor);
    if (QTEMP7)
      for QTEMP10=1:(QmatNMR.RasterSamplingFactor-QTEMP7)
        QTEMP9(QTEMP5 + QTEMP10, 1:QTEMP6) = QTEMP9(QTEMP5, 1:QTEMP6);
      end
    end
    if (QTEMP8)
      for QTEMP10=1:(QmatNMR.RasterSamplingFactor-QTEMP8)
        QTEMP9(:, QTEMP6 + QTEMP10) = QTEMP9(:, QTEMP6);
      end
    end
  
    QmatNMR.RasterMatrix = QTEMP9(1:QmatNMR.RasterSamplingFactor:end, 1:QmatNMR.RasterSamplingFactor:end);
    for QTEMP7 = 2:QmatNMR.RasterSamplingFactor
      QmatNMR.RasterMatrix = QmatNMR.RasterMatrix + QTEMP9(QTEMP7:QmatNMR.RasterSamplingFactor:end, QTEMP7:QmatNMR.RasterSamplingFactor:end);
    end
    QmatNMR.Raster2DPlotCommand = ['surface(QmatNMR.Rastervec1Plot, QmatNMR.Rastervec2Plot,' QmatNMR.rasterdisplay '(QmatNMR.RasterMatrix))'];
    eval(QmatNMR.Raster2DPlotCommand);
  
  
  %
  %Update the axis scaling and other things to accomodate the new plot
  %
    if (~ishold) 	%HOLD = OFF
    %
    %Set some axis properties
    %
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
                           'box', 'on');
  
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
      grid off;
      shading flat
  
  
    %
    %Define the axis labels and title
    %
      title('2D raster plot', 'Color', QmatNMR.ColorScheme.AxisFore);
      xlabel(strrep(QmatNMR.textt2, '\n', char(10)));
      ylabel(strrep(QmatNMR.textt1, '\n', char(10)));
  
  
    %
    %Update the axis scaling to the new plot (unless the hold flag is active)
    %
      if (~ ishold)
        QmatNMR.aswaarden = [QmatNMR.Rastervec1Plot(1) QmatNMR.Rastervec1Plot(length(QmatNMR.Rastervec1Plot)) QmatNMR.Rastervec2Plot(1) QmatNMR.Rastervec2Plot(length(QmatNMR.Rastervec2Plot))];
        setappdata(QmatNMR.AxisHandle2D3D, 'ZoomLimitsMatNMR', QmatNMR.aswaarden);
        axis(QmatNMR.aswaarden);
      end
  
  
    %
    %save the offset and slope of each axis ruler in the userdata of the axis
    %then always the intensity can be calculated properly (for 'get position' and
    %'peak picking')
    %
      %define the axis increments and offsets for TD2 and TD1 respectively
      QTEMP2 = [(QmatNMR.Rastervec1(2)-QmatNMR.Rastervec1(1)) (2*QmatNMR.Rastervec1(1)-QmatNMR.Rastervec1(2))];
      QTEMP3 = [(QmatNMR.Rastervec2(2)-QmatNMR.Rastervec2(1)) (2*QmatNMR.Rastervec2(1)-QmatNMR.Rastervec2(2))];
  
      %now-check whether the axes are linear, if not set the axis increment to 0 and put the entire vector into the userdata
      if LinearAxis(QmatNMR.Rastervec1)
        QmatNMR.Q2D3DUserData.PlotParams(QmatNMR.AxisNR2D3D).AxisTD2 = [];		%linear axis -> clear variable
      else
  
        QTEMP2(1) = 0;						%non-linear axis -> add axis vector
        QmatNMR.Q2D3DUserData.PlotParams(QmatNMR.AxisNR2D3D).AxisTD2 = QmatNMR.Rastervec1;
      end
  
      if LinearAxis(QmatNMR.Rastervec2)
        QmatNMR.Q2D3DUserData.PlotParams(QmatNMR.AxisNR2D3D).AxisTD1 = [];		%linear axis -> clear variable
      else
  
        QTEMP3(1) = 0;						%non-linear axis -> add axis vector
        QmatNMR.Q2D3DUserData.PlotParams(QmatNMR.AxisNR2D3D).AxisTD1 = QmatNMR.Rastervec2;
      end
      QmatNMR.Q2D3DUserData.PlotParams(QmatNMR.AxisNR2D3D).AxisProps = [QTEMP2 QTEMP3];
      QmatNMR.Q2D3DUserData.PlotParams(QmatNMR.AxisNR2D3D).AnalyserAxisTD2 = QmatNMR.Rastervec1;
      QmatNMR.Q2D3DUserData.PlotParams(QmatNMR.AxisNR2D3D).AnalyserAxisTD1 = QmatNMR.Rastervec2;
  
  
    %
    %save the other plot parameters in the userdata
    %
      QmatNMR.Q2D3DUserData.PlotParams(QmatNMR.AxisNR2D3D).Name = QmatNMR.SpecName2D3D;
      QmatNMR.Q2D3DUserData.PlotParams(QmatNMR.AxisNR2D3D).MaxInt  = eval(['max(max(' QmatNMR.rasterdisplay '(QmatNMR.Spec2D3DPlot)));']);
      QmatNMR.Q2D3DUserData.PlotParams(QmatNMR.AxisNR2D3D).MinInt  = eval(['min(min(' QmatNMR.rasterdisplay '(QmatNMR.Spec2D3DPlot)));']);
      QmatNMR.Q2D3DUserData.PlotParams(QmatNMR.AxisNR2D3D).SizeTD2 = length(QmatNMR.Axis2D3DTD2);
      QmatNMR.Q2D3DUserData.PlotParams(QmatNMR.AxisNR2D3D).SizeTD1 = length(QmatNMR.Axis2D3DTD1);
      QmatNMR.Q2D3DUserData.PlotParams(QmatNMR.AxisNR2D3D).History = QmatNMR.History2D3D;
  
  
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
    disp('Raster Plot finished ...');
    Arrowhead
  
    clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
