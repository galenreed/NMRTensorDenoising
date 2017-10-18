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
%asaanpas.m is the script that displays all spectra and auto-adjusts
%the scaling
%9-8-'96

try
  watch;
  
  %get the axis handle
  QmatNMR.TEMPAxis = gca;
  
  
  %remember the original title of the plot
  QmatNMR.PlotTitle = get(get(QmatNMR.TEMPAxis, 'title'), 'string');
  
  
  %
  %asaanpas only makes default plots, i.e.nothing special
  %
  QmatNMR.PlotType = 1;
  
  
  %update the spectrum (in case the user has changed the QmatNMR.Spec1D variable manually)
  Qspcrel;
  
  
  %set the line tag
  if (QmatNMR.Dim == 0)	%1D FID/spectrum
    QmatNMR.LineTag = QmatNMR.LineTag1D;
  
  else
    QmatNMR.LineTag = QmatNMR.LineTag2D;
  end
  
  
  %if in default-axis mode then we redefine the axis variable just to be sure
  if (QmatNMR.RulerXAxis == 0)	%use default axis for plotting of spectra
    GetDefaultAxis
  
  else
    set(QmatNMR.h670, 'checked', 'off'); 	%switch off the check flag in the menubar
    set(QmatNMR.defaultaxisbutton, 'value', 8);
  end
  
  
  %if the axis vector is on incorrect length repair the damage by switching to default-axis mode!
  if ~ (length(QmatNMR.Axis1D) == length(QmatNMR.Spec1DPlot))
    GetDefaultAxis
  end
  
  
  detaxisprops		%determine axes offsets and increments
  CheckAxis;					%checks whether the axis is ascending or descending and adjusts the
  						%plot direction if necessary
  
  %
  %just in case the current mode is "both" and the default axis has been changed.
  %
  regeldisplaymode
  
  
  axis on
  cla;
  delete(findobj(gcf, 'tag', 'legend'));		%remove any legends present
  eval(['QTEMP = ' QmatNMR.PlotCommand]);
  set(QTEMP, 'LineWidth', QmatNMR.LineWidth, 'MarkerSize', QmatNMR.MarkerSize, 'buttondownfcn', ...
             'MoveLine', 'hittest', 'on', 'Tag', QmatNMR.LineTag);
  
  set(QmatNMR.TEMPAxis, 'FontSize', QmatNMR.TextSize, ...
         'FontName', QmatNMR.TextFont, ...
         'FontAngle', QmatNMR.TextAngle, ...
         'FontWeight', QmatNMR.TextWeight, ...
         'LineWidth', QmatNMR.LineWidth, ...
         'Color', QmatNMR.ColorScheme.AxisBack, ...
         'xcolor', QmatNMR.ColorScheme.AxisFore, ...
         'ycolor', QmatNMR.ColorScheme.AxisFore, ...
         'zcolor', QmatNMR.ColorScheme.AxisFore, ...
         'box', 'on', ...
         'userdata', 1, ...
         'tag', 'MainAxis', ...
         'view', [0 90], ...
         'visible', 'on', ...
         'xscale', 'linear', ...
         'yscale', 'linear', ...
         'zscale', 'linear', ...
         'xticklabelmode', 'auto', ...
         'yticklabelmode', 'auto', ...
         'zticklabelmode', 'auto', ...
         'selected', 'off', ...
         'ydir', 'normal', ...
         'zdir', 'normal', ...
         'XDir', QmatNMR.AxisPlotDirection);		%CheckAxis.m determines whether the direction should be normal or reverse
  
  
  %
  %Now we set the axis limits. In case the display mode has been set to 'both' then we need to do
  %	take both the real and imaginary into account. This requires special care.
  %
    axis auto
    DetermineNewAxisLimits
  
  
  %
  %Set the title to the plot
  %
  title(strrep(QmatNMR.PlotTitle, '\n', char(10)), 'Color', QmatNMR.ColorScheme.AxisFore);
  
  
  %
  %set the axis limits properly and also set the ApplicationData such that the zoom function uses the new values
  %
  axis([QmatNMR.xmin (QmatNMR.xmin+QmatNMR.totaalX) QmatNMR.ymin (QmatNMR.ymin+QmatNMR.totaalY)]);
  setappdata(QmatNMR.TEMPAxis, 'ZoomLimitsMatNMR', [QmatNMR.xmin (QmatNMR.xmin+QmatNMR.totaalX) QmatNMR.ymin (QmatNMR.ymin+QmatNMR.totaalY)]);
  
  
  if QmatNMR.gridvar 
    set(QmatNMR.TEMPAxis, 'ytickmode', 'auto');
    grid on;
    QmatNMR.gridvar = 1;
    if ~ QmatNMR.yschaal
      set(QmatNMR.TEMPAxis, 'ytick', []);
    end
  else
    grid off;
    if QmatNMR.yschaal 
      set(QmatNMR.TEMPAxis, 'ytickmode', 'auto');
    else
      set(QmatNMR.TEMPAxis, 'ytick', []);
    end
  end
  
  if QmatNMR.xschaal
    set(QmatNMR.TEMPAxis, 'xtickmode', 'auto');
  
    if (QmatNMR.DisplayMode == 3) 	%display mode is 'both' -> needs special care for the tick marks on the x-axis
      QTEMP8 = get(QmatNMR.TEMPAxis, 'xtick');
      QTEMP8 = QTEMP8(find(QTEMP8 <= max(QmatNMR.Axis1D)));
      
      if (QmatNMR.FIDstatus == 1) 	%spectrum
        if (strcmp(QmatNMR.AxisPlotDirection, 'reverse'))	%ascending axis
          QTEMP9 = sort(unique([QTEMP8 (QTEMP8+QmatNMR.Axis1D(QmatNMR.Size1D)-QmatNMR.Rnull)]));
          set(QmatNMR.TEMPAxis, 'xtick', sort(QTEMP9), 'xticklabel', [QTEMP8 QTEMP8]);
  
        else						%descending axis
          QTEMP9 = sort(unique([QTEMP8 (QTEMP8-QmatNMR.Axis1D(QmatNMR.Size1D)+QmatNMR.Rnull)]));
          set(QmatNMR.TEMPAxis, 'xtick', QTEMP9, 'xticklabel', [QTEMP8 QTEMP8]);
        end
  
      else			%FID
        if (QmatNMR.Rincr > 0)					%ascending axis
          QTEMP9 = sort(unique([QTEMP8 (QTEMP8+QmatNMR.Axis1D(QmatNMR.Size1D)-QmatNMR.Rnull)]));
          set(QmatNMR.TEMPAxis, 'xtick', QTEMP9, 'xticklabel', [QTEMP8 QTEMP8]);
  
        else						%descending axis
          QTEMP9 = sort(unique([QTEMP8 (QTEMP8-QmatNMR.Axis1D(QmatNMR.Size1D)+QmatNMR.Rnull)]));
          set(QmatNMR.TEMPAxis, 'xtick', QTEMP9, 'xticklabel', [QTEMP8 QTEMP8]);
        end
      end    
    end
  else
    set(QmatNMR.TEMPAxis, 'xtick', []);
  end
  
  h = xlabel(strrep(QmatNMR.texie, '\n', char(10)));
  set(h, 'color', QmatNMR.ColorScheme.AxisFore);
  ylabel(''); 		%by default there is no y-label
  QmatNMR.nrspc = 1;
  
  %
  %update the buttons for the sweep width and the spectrometer frequency
  %
  if (QmatNMR.Dim == 1)
    QmatNMR.SW1D = QmatNMR.SWTD2;
    QmatNMR.SF1D = QmatNMR.SFTD2;
  
  elseif (QmatNMR.Dim == 2)
    QmatNMR.SW1D = QmatNMR.SWTD1;
    QmatNMR.SF1D = QmatNMR.SFTD1;
  end
  
  updatebuttons
  
  DIMstatus		%shows which dimension we're working in
  
  if (~QmatNMR.lbstatus == 0)
  %
  %plot apodisation function in blue
  %
    plotapodizer
  end
  
  Arrowhead;
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
