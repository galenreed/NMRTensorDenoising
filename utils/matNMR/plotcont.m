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
%plotcont.m is the actual plotting routine for contours ...
%20-08-'98
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
  %Remember axis limits and color axis settings if the hold state is on for the current axis
  %
    if (ishold)
      QmatNMR.Q2D3DAxisData.AxisLims = axis;	%read current axis limits
      QmatNMR.Q2D3DAxisData.CLim = caxis; 	%read current color axis limits
      QmatNMR.Q2D3DAxisData.XDir = get(QmatNMR.AxisHandle2D3D, 'xdir');
      QmatNMR.Q2D3DAxisData.YDir = get(QmatNMR.AxisHandle2D3D, 'ydir');
      
      %determine the maximum amplitude of all children of the current axis. This value is added
      %to the zdata of the patches of the contour plot that we are about to add to the axis.
      %This will ensure the contours are always visible (as Matlab wants them on top to be visible.
      QTEMP2 = 0;
      QTEMP21 = get(QmatNMR.AxisHandle2D3D, 'children');
      for QTEMP9 = 1:length(QTEMP21)
        if (QTEMP2 < max(max(get(QTEMP21(QTEMP9), 'zdata'))))
          QTEMP2 = max(max(get(QTEMP21(QTEMP9), 'zdata')));
        end
      end
      QmatNMR.Q2D3DAxisData.MaxSignal = QTEMP2;
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
  %Determine the type of contour plot from the 2D/3D panel window
  %After that check the axis variables and perform the contour plot
  %
    QmatNMR.ContourType = deblank(QmatNMR.contourtypestring(get(QmatNMR.c18, 'value'), :));	%read plot type from figure window buttons
  
  %
  %The contourf routine in Matlab 7 is buggy and hence we use the possibility to reverting back to the version of
  %Matlab 6, i.e. the 'v6' option.
  %
    if (strcmp(QmatNMR.ContourType, 'contourf') & (QmatNMR.MatlabVersion >= 7.0))
      QTEMP21 = '(''v6'', ';
  
    else
      QTEMP21 = '(';
    end
  
    QmatNMR.contdisplay = QmatNMR.contdisplaystring(get(QmatNMR.c17, 'value'), :);
    CheckAxisCont;
    if length(QmatNMR.ContourLineSpec)
      QmatNMR.PlotString = ['[QTEMP3 QTEMP4] = ' QmatNMR.ContourType QTEMP21 'QmatNMR.Axis2D3DTD2Plot, QmatNMR.Axis2D3DTD1Plot, ' QmatNMR.contdisplay '(QmatNMR.Spec2D3DPlot), QmatNMR.ContourLevels, QmatNMR.ContourLineSpec);'];
    else  
      QmatNMR.PlotString = ['[QTEMP3 QTEMP4] = ' QmatNMR.ContourType QTEMP21 'QmatNMR.Axis2D3DTD2Plot, QmatNMR.Axis2D3DTD1Plot, ' QmatNMR.contdisplay '(QmatNMR.Spec2D3DPlot), QmatNMR.ContourLevels);'];
    end  
    eval(QmatNMR.PlotString);
  
  
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
    if (~ishold)		%HOLD = OFF
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
    
    
    %
    %Define the axis labels and title
    %
      xlabel(strrep(QmatNMR.textt2, '\n', char(10)));
      ylabel(strrep(QmatNMR.textt1, '\n', char(10)));
      QmatNMR.titelstring1 = [strrep(QmatNMR.SpecName2D3D, '_', '\_') '   --->   '];
      title([strrep(QmatNMR.titelstring1, '\n', char(10)), QmatNMR.titelstring2], 'Color', QmatNMR.ColorScheme.AxisFore);
  
  
    %
    %set the shading to flat for a filled contour plot
    %
      if strcmp(QmatNMR.ContourType, 'contourf')
        shading flat;
      end  
  
    %
    %Axis limits
    %
      QmatNMR.aswaarden = [QmatNMR.Axis2D3DTD2Plot(1) QmatNMR.Axis2D3DTD2Plot(end) QmatNMR.Axis2D3DTD1Plot(1) QmatNMR.Axis2D3DTD1Plot(end)];
      setappdata(QmatNMR.AxisHandle2D3D, 'ZoomLimitsMatNMR', QmatNMR.aswaarden);
      axis(QmatNMR.aswaarden);
  
    %
    %manually set the color scaling axis to the minimum and maximum of the contour levels
    %NB: this is only done if no linespec arguments have been given for the color.
    %The colorstyle.m function is used to check for this.
    %
    %For positive and negative contours to their respective maxima the color axis is set
    %to the maximum and minimum of the spectrum, and not of the contour levels!
    %
      QTEMP2 = min(QmatNMR.ContourLevels);
      QTEMP3 = max(QmatNMR.ContourLevels);
      if (QmatNMR.negcont==3) 	%for positive and negative contours to their respective maxima
        QTEMP2 = QmatNMR.specmin;
        QTEMP3 = QmatNMR.specmax;
      end
    
      if ~isempty(QmatNMR.ContourLineSpec)			%A linespec argument has been given
        [QmatNMR.Cline,QmatNMR.Ccol,QmatNMR.Cmark,QmatNMR.Cmsg] = colstyle(QmatNMR.ContourLineSpec);
        if isempty(QmatNMR.Ccol)				%but there was no color information and so a colormap is needed
          if (QTEMP2 ~= QTEMP3)
            caxis([QTEMP2 QTEMP3]);
          end
    
          if ((QmatNMR.negcont==3) | (QmatNMR.negcont == 4))	%Set colormap for contour plot. Default in matNMR is hsv (from MATLAB v 5.0
         						%the contour plot is stored as a patch and all color information is written in the
      						%postscript and so to print on black and white a monochrome plot is required. --> White)
            colormap(eval(QmatNMR.PosNegMapLast));		%This is a special colormap for plots with negative peaks !!
          end
        end  
    
      else						%no linespec argument was given -> use colormap
        if (QTEMP2 ~= QTEMP3)
          caxis([QTEMP2 QTEMP3]);
        end
    
        if ((QmatNMR.negcont==3) | (QmatNMR.negcont == 4))	%Set colormap for contour plot. Default in matNMR is hsv (from MATLAB v 5.0
         						%the contour plot is stored as a patch and all color information is written in the
      						%postscript and so to print on black and white a monochrome plot is required. --> White)
          colormap(eval(QmatNMR.PosNegMapLast));		%This is a special colormap for plots with negative peaks !!
        end
      end  
  
  
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
    %save the other plot parameters in the userdata
    %
      QmatNMR.Q2D3DUserData.PlotParams(QmatNMR.AxisNR2D3D).Name = QmatNMR.SpecName2D3D;
      QmatNMR.Q2D3DUserData.PlotParams(QmatNMR.AxisNR2D3D).MaxInt  = eval(['max(max(' QmatNMR.contdisplay '(QmatNMR.Spec2D3DPlot)));']);
      QmatNMR.Q2D3DUserData.PlotParams(QmatNMR.AxisNR2D3D).MinInt  = eval(['min(min(' QmatNMR.contdisplay '(QmatNMR.Spec2D3DPlot)));']);
      QmatNMR.Q2D3DUserData.PlotParams(QmatNMR.AxisNR2D3D).SizeTD2 = length(QmatNMR.Axis2D3DTD2);
      QmatNMR.Q2D3DUserData.PlotParams(QmatNMR.AxisNR2D3D).SizeTD1 = length(QmatNMR.Axis2D3DTD1);
      QmatNMR.Q2D3DUserData.PlotParams(QmatNMR.AxisNR2D3D).History = QmatNMR.History2D3D;
  
    else 	%HOLD = ON
      %
      %when the hold is on we don't do much because we assume that the first plot is most important.
      %The contour plot will be put above the first spectrum unless a contour3 plot is asked for
      %
  
      if ~strcmp(QmatNMR.ContourType, 'contour3')
        %
        %set the zdata of the new contour plot equal to the previously-determined maximum amplitude of all axis children
        %
        %NOTE: QTEMP4 is the list of handles corresponding to the patches of the contour (matlab 6.5) or to the hggroup
        %(matlab 7 and higher). For Matlab 7 and higher we need to get the childen of this hggroup handle
        %
        if (QmatNMR.MatlabVersion >= 7.0)
          QTEMP4 = get(QTEMP4, 'children');
        end
    
        for QTEMP2 = 1:length(QTEMP4)
          QTEMP3 = get(QTEMP4(QTEMP2), 'xdata')*0;
          set(QTEMP4(QTEMP2), 'zdata', QTEMP3+QmatNMR.Q2D3DAxisData.MaxSignal);
        end
      end
      
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
    if (QmatNMR.ColorBarPresent)	%A colorbar was present in the current plot --> make sure it is updated properly
      QmatNMR.contcolorbar(QmatNMR.AxisNR2D3D) = colorbarmatNMR('vert');
      QmatNMR.Q2D3DUserData.ColorBarHandles = QmatNMR.contcolorbar;
      QmatNMR.ContColorbarIndicator(QmatNMR.AxisNR2D3D) = 1;
      QmatNMR.Q2D3DUserData.ColorBarIndicator = QmatNMR.ContColorbarIndicator;
      QmatNMR.ColorBarPresent = 0;
    end
  
  
  %
  %Save all figure parameters back into the userdata
  %
    set(QmatNMR.Fig2D3D, 'userdata', QmatNMR.Q2D3DUserData);    %save all figure parameters back into the userdata
    
  
  %
  %adjust the posneg colormaps if that is the current colormap. This must be after the parameters have been
  %written to the figure userdata because the QColorMaps and AdjustPosNeg routines needs those!
  %
    if strcmp(QmatNMR.CurrentColorMap(1:14), 'QmatNMR.PosNeg')
      set(QmatNMR.c8, 'value', 3);
      contcmap
    end
  
  
  %  
  %restore the peak list if it was saved in the data structure
  %this has to go last because unfortunately the QmatNMR.Q2D3DUserData variable is used in this routine
  %to contain the figure window's userdata but in the restorepeaklist routine it is used
  %to give information about the position of the variable name in the string QmatNMR.SpecName2D3DProc
  %(detected by checkinput.m)
  %
    if (QmatNMR.RestorePeaklist == 0)
      [QmatNMR.SpecName2D3DProc, QmatNMR.CheckInput] = checkinput(QmatNMR.SpecName2D3DProc);
      restorepeaklist;				
    end
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
