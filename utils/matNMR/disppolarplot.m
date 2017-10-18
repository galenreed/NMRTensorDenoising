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
%disppolarplot.m creates a polar plot of a matrix using a stereographic projection.
%based on an original routine by Marcel Utz.
%
%30-07-'01

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
  %Determine the type of polar plot from the parameters and draw it
  %
    [QTEMP7, QTEMP8] = size(QmatNMR.Spec2D3D);
    QmatNMR.Axis2D3DTD2 = tan(0.5*(0:pi/2/(QTEMP8-1):pi/2)).'*cos((pi/2)/(QTEMP7-1)*(0:(QTEMP7-1)));
    QmatNMR.Axis2D3DTD1 = tan(0.5*(0:pi/2/(QTEMP8-1):pi/2)).'*sin((pi/2)/(QTEMP7-1)*(0:(QTEMP7-1)));
    QmatNMR.Spec2D3DPlot = real(QmatNMR.Spec2D3D);
    QmatNMR.Axis2D3DTD2Plot = QmatNMR.Axis2D3DTD2;
    QmatNMR.Axis2D3DTD1Plot = QmatNMR.Axis2D3DTD1;
    switch QmatNMR.PolarPlotPlotType
      case 1		%pcolor
        QTEMP5 = pcolor(QmatNMR.Axis2D3DTD2Plot, QmatNMR.Axis2D3DTD1Plot, QmatNMR.Spec2D3DPlot.'); 
        shading interp; 
  
      case 2		%filled contours (relative levels)
        set(QmatNMR.c17, 'value', 1);	%set to real contours
        calccontlevels
        [QTEMP4, QTEMP5, QTEMP6] = contourf(QmatNMR.Axis2D3DTD2Plot, QmatNMR.Axis2D3DTD1Plot, QmatNMR.Spec2D3DPlot.', QmatNMR.ContourLevels); 
        shading flat
  
      case 3		%filled contours (absolute contours)
        QmatNMR.ContourLevels = eval(QmatNMR.PolarPlotContourLevels);
        [QTEMP4, QTEMP5, QTEMP6] = contourf(QmatNMR.Axis2D3DTD2Plot, QmatNMR.Axis2D3DTD1Plot, QmatNMR.Spec2D3DPlot.', QmatNMR.ContourLevels); 
        shading flat
  
      case 4		%normal contours (relative levels)
        set(QmatNMR.c17, 'value', 1);	%set to real contours
        calccontlevels
        [QTEMP4, QTEMP5, QTEMP6] = contour(QmatNMR.Axis2D3DTD2Plot, QmatNMR.Axis2D3DTD1Plot, QmatNMR.Spec2D3DPlot.', QmatNMR.ContourLevels); 
        shading flat
  
      case 5		%normal contours (absolute contours)
        QmatNMR.ContourLevels = eval(QmatNMR.PolarPlotContourLevels);
        [QTEMP4, QTEMP5, QTEMP6] = contour(QmatNMR.Axis2D3DTD2Plot, QmatNMR.Axis2D3DTD1Plot, QmatNMR.Spec2D3DPlot.', QmatNMR.ContourLevels); 
        shading flat
    end  
  %
  %As we set the axis to off, we still want to be able to select the axis. Therefore we
  %give the surface or patch objects the SelectAxis buttondownfcn.
  %
    set(QTEMP5, 'ButtonDownFcn', 'SelectAxis', 'hittest', 'on', 'selectionhighlight', 'off');
  
  %
  %if asked for put on a nice axis
  %
    if (QmatNMR.PolarPlotAxis > 1)
      %
      %outer circle, horizontal axis and vertical axis lines
      %
      QTEMP5=line(cos((0:50)/100*pi),sin((0:50)/100*pi));
      set(QTEMP5,'Color', 'w');
      QTEMP5=line([0 1],[0 0]);
      set(QTEMP5,'Color', 'w');
      QTEMP5=line([0 0],[0 1]);
      set(QTEMP5,'Color', 'w');
      
      %
      %
      %
      QmatNMR.ri=tan(20/360*pi);
      for QTEMP40=10:10:80
        QmatNMR.ra=tan(QTEMP40/360*pi);
        %
        %circular lines
        %
        QTEMP5 = line(QmatNMR.ra*cos((0:50)/100*pi),QmatNMR.ra*sin((0:50)/100*pi));
        set(QTEMP5,'Color', 'w');
        
        %
        %radial lines
        %
        QTEMP5 = line(cos(QTEMP40/180*pi)*[QmatNMR.ri 1],sin(QTEMP40/180*pi)*[QmatNMR.ri 1]);
        set(QTEMP5,'Color', 'w');   
      end
  
      %
      %put text labels into the plot if asked for
      %
      if (QmatNMR.PolarPlotAxis == 3)
        for QTEMP40=10:10:80
          QmatNMR.ra=tan(QTEMP40/360*pi);
          QTEMP5 = text(QmatNMR.ra-0.02,-0.03,num2str(QTEMP40));	%tick labels on x-axis
          set(QTEMP5, 'tag', 'PolarPlotAxisText', 'Color', QmatNMR.ColorScheme.AxesFore);
    
          QTEMP5 = text(-0.06,QmatNMR.ra,num2str(QTEMP40));		%tick labels on y-axis
          set(QTEMP5, 'tag', 'PolarPlotAxisText', 'Color', QmatNMR.ColorScheme.AxesFore);
    
          QTEMP5 = text(1.03*cos(QTEMP40/180*pi)-0.02,1.03*sin(QTEMP40/180*pi),num2str(QTEMP40));	%tick labels alpha angle
          set(QTEMP5, 'tag', 'PolarPlotAxisText', 'Color', QmatNMR.ColorScheme.AxesFore);
        end
        QTEMP5 = text(0.98,-0.03,'90');		%tick labels on x-axis
        set(QTEMP5, 'tag', 'PolarPlotAxisText', 'Color', QmatNMR.ColorScheme.AxesFore);
    
        QTEMP5 = text(-0.06, 1,'90');		%tick labels on y-axis
        set(QTEMP5, 'tag', 'PolarPlotAxisText', 'Color', QmatNMR.ColorScheme.AxesFore);
    
        QTEMP5 = text(0.4,-0.1,'\beta [degrees]');
        set(QTEMP5, 'tag', 'PolarPlotAxisLabelText', 'Color', QmatNMR.ColorScheme.AxesFore);
    
        QTEMP5 = text(0.8,0.75,'\alpha [degrees]');
        set(QTEMP5, 'tag', 'PolarPlotAxisLabelText', 'Color', QmatNMR.ColorScheme.AxesFore);
    
        QTEMP5 = text(-0.1,0.4,'\beta [degrees]');
        set(QTEMP5, 'rotation', 90, 'tag', 'PolarPlotAxisLabelText');
      end
    end  
    
  
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
      axis on
      set(QmatNMR.AxisHandle2D3D, 'FontSize', QmatNMR.TextSize, ...
                           'FontName', QmatNMR.TextFont, ...
                           'FontAngle', QmatNMR.TextAngle, ...
                           'FontWeight', QmatNMR.TextWeight, ...
                           'LineWidth', QmatNMR.LineWidth, ...
                           'xgrid','off', ...
                           'ygrid','off', ...
                           'zgrid','off', ...
                           'xcolor', QmatNMR.ColorScheme.AxisFore, ...
                           'ycolor', QmatNMR.ColorScheme.AxisFore, ...
                           'zcolor', QmatNMR.ColorScheme.AxisFore, ...
                           'xscale', 'linear', ...
                           'yscale', 'linear', ...
                           'zscale', 'linear', ...
                           'zlimmode', 'auto', ...
                           'climmode', 'auto', ...
                           'xtickmode', 'auto', ...
                           'ytickmode', 'auto', ...
                           'ztickmode', 'auto', ...
                           'xticklabelmode', 'auto', ...
                           'yticklabelmode', 'auto', ...
                           'zticklabelmode', 'auto', ...
                           'xdir', 'normal', ...
                           'ydir', 'normal', ...
                           'zdir', 'normal', ...
                           'box', 'off');
      axis square equal
      axis off
      grid off;
    
    
    %
    %Define the axis labels and title
    %
      QmatNMR.titelstring1 = [strrep(QmatNMR.SpecName2D3D, '_', '\_') '   --->   '];
      QmatNMR.titelstring2 = 'polar plot';
      title([QmatNMR.titelstring1, QmatNMR.titelstring2], 'Color', QmatNMR.ColorScheme.AxisFore);
    
    
    %
    %Update the axis scaling to the new plot (unless the hold flag is active)
    %
      if (~ishold)
        QmatNMR.aswaarden = [0 1 0 1];
        setappdata(QmatNMR.AxisHandle2D3D, 'ZoomLimitsMatNMR', QmatNMR.aswaarden);
        axis(QmatNMR.aswaarden);
      end
      
    
    %
    %manually set the color scaling axis to the minimum and maximum of the contour levels
    %NB: this is only done if no linespec arguments have been given for the color.
    %The colorstyle.m function is used to check for this.
    %
      switch QmatNMR.PolarPlotPlotType
        case 1		%pcolor
          QTEMP2 = min(min(QmatNMR.Spec2D3D));
          QTEMP3 = max(max(QmatNMR.Spec2D3D));
          if (QTEMP2 ~= QTEMP3)
            caxis(sort([QTEMP2 QTEMP3]));
          end
     
    
        case 2		%filled contours (relative levels)
          QTEMP2 = min(QmatNMR.ContourLevels);
          QTEMP3 = max(QmatNMR.ContourLevels);
          if (QTEMP2 ~= QTEMP3)
            caxis([QTEMP2 QTEMP3]);
          end
    
          %
          %in case negative contours are plotted, change the colormap to the last-used PosNeg map
          %
          if ((QmatNMR.negcont==3) | (QmatNMR.negcont == 4))	%Set colormap for contour plot. Default in matNMR is hsv (from MATLAB v 5.0
         						%the contour plot is stored as a patch and all color information is written in the
      						%postscript and so to print on black and white a monochrome plot is required. --> White)
            colormap(eval(QmatNMR.PosNegMapLast));		%This is a special colormap for plots with negative peaks !!
          end
    
    
        case 3		%filled contours (absolute contours)
          QTEMP2 = min(QmatNMR.ContourLevels);
          QTEMP3 = max(QmatNMR.ContourLevels);
          if (QTEMP2 ~= QTEMP3)
            caxis([QTEMP2 QTEMP3]);
          end	
    
    
        case 4		%normal contours (relative levels)
          QTEMP2 = min(QmatNMR.ContourLevels);
          QTEMP3 = max(QmatNMR.ContourLevels);
          if (QTEMP2 ~= QTEMP3)
            caxis([QTEMP2 QTEMP3]);
          end	
    
    
          %
          %in case negative contours are plotted, change the colormap to the last-used PosNeg map
          %
          if ((QmatNMR.negcont==3) | (QmatNMR.negcont == 4))	%Set colormap for contour plot. Default in matNMR is hsv (from MATLAB v 5.0
         						%the contour plot is stored as a patch and all color information is written in the
      						%postscript and so to print on black and white a monochrome plot is required. --> White)
            colormap(eval(QmatNMR.PosNegMapLast));		%This is a special colormap for plots with negative peaks !!
          end
    
    
        case 5		%normal contours (absolute contours)
          QTEMP2 = min(QmatNMR.ContourLevels);
          QTEMP3 = max(QmatNMR.ContourLevels);
          if (QTEMP2 ~= QTEMP3)
            caxis([QTEMP2 QTEMP3]);
          end	
      end  
    
    
    %
    %save the offset and slope of each axis ruler in the userdata of the axis
    %then always the intensity can be calculated properly (for 'get position' and
    %'peak picking')
    %In case a non-linear axis has been supplied the whole axis vector will be saved
    %in the userdata of the figure window
    %
      QmatNMR.Q2D3DUserData.PlotParams(QmatNMR.AxisNR2D3D).AxisTD2 = [];		%linear axis -> clear variable
      QmatNMR.Q2D3DUserData.PlotParams(QmatNMR.AxisNR2D3D).AxisTD1 = [];		%linear axis -> clear variable
      QmatNMR.Q2D3DUserData.PlotParams(QmatNMR.AxisNR2D3D).AxisProps = [1 0 1 0];
      QmatNMR.Q2D3DUserData.PlotParams(QmatNMR.AxisNR2D3D).AnalyserAxisTD2 = QmatNMR.Axis2D3DTD2;
      QmatNMR.Q2D3DUserData.PlotParams(QmatNMR.AxisNR2D3D).AnalyserAxisTD1 = QmatNMR.Axis2D3DTD1;
    
    
    %
    %save the other plot parameters in the userdata
    %
      QmatNMR.Q2D3DUserData.PlotParams(QmatNMR.AxisNR2D3D).Name = QmatNMR.SpecName2D3D;
      QmatNMR.Q2D3DUserData.PlotParams(QmatNMR.AxisNR2D3D).MaxInt  = max(max(real(QmatNMR.Spec2D3DPlot)));
      QmatNMR.Q2D3DUserData.PlotParams(QmatNMR.AxisNR2D3D).MinInt  = min(min(real(QmatNMR.Spec2D3DPlot)));
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
    disp('Finished Polar Plot');
    Arrowhead;
  
    clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
