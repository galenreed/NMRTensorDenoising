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
%stack1dcertical.m makes a vertical stack plot of the current 2D spectrum by plotting
%an array of 1D spectra in the same plot, whilst giving each of them a different
%vertical offset. If the spectrum is zoomed only the zoomed area is taken !
%
%12-05-'04

try
  if (QmatNMR.buttonList == 1)
    %get the axis handle
    QmatNMR.TEMPAxis = gca;
  
    watch;
    
    if (QmatNMR.Dim == 0)
      disp('matNMR NOTICE: Cannot make a vertical stack plot from a 1D view. Please select a row/column from a 2D.');
      Arrowhead
    
    elseif (QmatNMR.DisplayMode == 3)
      disp('matNMR NOTICE: Cannot make a vertical stack plot in current display mode "both".');
      Arrowhead
    
    elseif (QmatNMR.yrelative)
      disp('matNMR NOTICE: Cannot make a vertical stack plot using a relative y-scale.');
      Arrowhead
  
    else
      QmatNMR.VerticalStackRange = QmatNMR.uiInput1;
      QmatNMR.VerticalStackDisplacement = QmatNMR.uiInput2;
  
      %
      %reset the plot to the default plot first to ensure proper calculation of the vertical
      %scaling factor in the stack plot
      %
      QmatNMR.TEMPxmin = QmatNMR.xmin;	%remember the current x scale in order to recover it after the reset figure
      QmatNMR.TEMPtotaalX = QmatNMR.totaalX;
      asaanpas
      QmatNMR.xmin = QmatNMR.TEMPxmin;
      QmatNMR.totaalX = QmatNMR.TEMPtotaalX;
      QmatNMR.VerticalStackymin    = QmatNMR.ymin;
      QmatNMR.VerticalStacktotaalY = QmatNMR.totaalY;
      axis([QmatNMR.xmin (QmatNMR.xmin+QmatNMR.totaalX) QmatNMR.ymin (QmatNMR.ymin+QmatNMR.totaalY)]);
      cla					%clear the plot
      hold on				%set the hold state to on
  
      
      %
      %process user input
      %
      QTEMP4 = eval(QmatNMR.uiInput1);		%range of vertical stack plot
      QTEMP5 = eval(QmatNMR.uiInput2);		%displacement factor, relative to current y-range (QmatNMR.ymin+QmatNMR.totaalY)
  
  
      %
      %create all lines in the axes
      %
      if (QmatNMR.Rincr < 0)		%for negative axis increments we need to flip the spectrum.
        QTEMP9 = 'fliplr'; 	%normally this is doen by CheckAxis but now we do it manually.
      else
        QTEMP9 = '';
      end
  
      if (QmatNMR.Dim == 1) 		%current dimension = TD2
        for QTEMP6 = 1:length(QTEMP4)
          
          QTEMP7 = strrep(QmatNMR.PlotCommand, 'QmatNMR.Spec1DPlot', [QTEMP9 '(QmatNMR.Spec2D(QTEMP4(QTEMP6), :) - (1+sqrt(-1))*QTEMP5*(QTEMP6-1)*QmatNMR.totaalY)']);
  	eval(['QTEMP8 = ' QTEMP7])
  
          set(QTEMP8, 'LineWidth', QmatNMR.LineWidth, 'MarkerSize', QmatNMR.MarkerSize, 'buttondownfcn', ...
             'MoveLine', 'hittest', 'on', 'Tag', QmatNMR.LineTag);
        end
  
      else 				%current dimension = TD1
        for QTEMP6 = 1:length(QTEMP4)
          if QmatNMR.HyperComplex				%If processing is hypercomplex, use QmatNMR.Spec2Dhc
            QTEMP7 = strrep(QmatNMR.PlotCommand, 'QmatNMR.Spec1DPlot', [QTEMP9 '((real(QmatNMR.Spec2D(:, QTEMP4(QTEMP6))) + sqrt(-1)*real(QmatNMR.Spec2Dhc(:, QTEMP4(QTEMP6)))).'' - (1+sqrt(-1))*QTEMP5*(QTEMP6-1)*QmatNMR.totaalY)']);
          else
            QTEMP7 = strrep(QmatNMR.PlotCommand, 'QmatNMR.Spec1DPlot', [QTEMP9 '(QmatNMR.Spec2D(:, QTEMP4(QTEMP6)).'' - (1+sqrt(-1))*QTEMP5*(QTEMP6-1)*QmatNMR.totaalY)']);
          end
          eval(['QTEMP8 = ' QTEMP7])
  
          set(QTEMP8, 'LineWidth', QmatNMR.LineWidth, 'MarkerSize', QmatNMR.MarkerSize, 'buttondownfcn', ...
             'MoveLine', 'hittest', 'on', 'Tag', QmatNMR.LineTag);
        end
  
      end
  
  
      %
      %set various axis properties
      %
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
         'tag', 'MainAxis', ...
         'userdata', 1, ...
         'view', [0 90], ...
         'visible', 'on', ...
         'xscale', 'linear', ...
         'yscale', 'linear', ...
         'zscale', 'linear', ...
         'xticklabelmode', 'auto', ...
         'yticklabelmode', 'auto', ...
         'zticklabelmode', 'auto', ...
         'XDir', QmatNMR.AxisPlotDirection);		%CheckAxis.m determines whether the direction should be normal or reverse
  
  
      %
      %set the ticks and tick labels on the y axis according to the values of the corresponding 
      %axis vector in that dimension
      %
      if (QmatNMR.Dim == 1) 	%TD2
        QTEMP9 = QmatNMR.AxisTD1(QTEMP4);
      else
  
        QTEMP9 = QmatNMR.AxisTD2(QTEMP4);
      end
      QTEMP10 = 0:(-QmatNMR.totaalY * QTEMP5):(-QmatNMR.totaalY * (length(QTEMP4)-1) * QTEMP5);
      if (QTEMP5 > 0)
        QTEMP10 = fliplr(QTEMP10);
        QTEMP9 = fliplr(QTEMP9);
      end
      set(QmatNMR.TEMPAxis, 'ytick', QTEMP10, 'yticklabels', QTEMP9);
  
  
      %
      %set the axis limits properly and also set the ApplicationData such that the zoom function uses the new values
      %
      if (QTEMP5 > 0)
        QmatNMR.ymin = QmatNMR.ymin - QmatNMR.totaalY * (length(QTEMP4)-1) * QTEMP5;
      end
  
      if (QTEMP5 ~= 0)
        QmatNMR.totaalY = QmatNMR.totaalY * length(QTEMP4) * abs(QTEMP5);
      end
  
      if (QmatNMR.totaalY < 0)
        QmatNMR.ymin = QmatNMR.ymin + QmatNMR.totaalY;
        QmatNMR.totaalY = -QmatNMR.totaalY + QmatNMR.ymin;
      end
  
      axis([QmatNMR.xmin (QmatNMR.xmin+QmatNMR.totaalX) QmatNMR.ymin (QmatNMR.ymin+QmatNMR.totaalY)]);
      setappdata(QmatNMR.TEMPAxis, 'ZoomLimitsMatNMR', [QmatNMR.xmin (QmatNMR.xmin+QmatNMR.totaalX) QmatNMR.ymin (QmatNMR.ymin+QmatNMR.totaalY)]);
  
  
      %
      %set the hold state back to replace the axis children
      %
      set(QmatNMR.TEMPAxis, 'nextplot', 'replacechildren');
  
  
      %
      %vertical stack means QmatNMR.PlotType = 3
      %
      QmatNMR.PlotType = 3;
  
  
      title(['Vertical stack plot from current 2D spectrum ' strrep(QmatNMR.Spec2DName, '_', '\_')], 'Color', QmatNMR.ColorScheme.AxisFore);
      disp('Vertical Stack plot finished');
  
  
      %
      %add this action to the processing history
      %
      QmatNMR.History = str2mat(QmatNMR.History, 'Vertical stack plot created from the current view');
  
      if LinearAxis(QTEMP4)	%only store in history macro if the range is linear
        if (QmatNMR.Dim == 0)
          QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
      
        elseif (QmatNMR.Dim == 1)
          QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
          QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
      
        else
          QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
          QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
        end
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 401);
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 701, QmatNMR.Dim, QTEMP4(1), QTEMP4(2)-QTEMP4(1), QTEMP4(end), QTEMP5, QmatNMR.xmin, QmatNMR.totaalX, QmatNMR.VerticalStackymin, QmatNMR.VerticalStacktotaalY);	%code for stack1d, dimension, range, offset, QmatNMR.xmin, QmatNMR.xmin+QmatNMR.totaalX, QmatNMR.ymin, QmatNMR.ymin+QmatNMR.totaalY
    
        if (QmatNMR.RecordingPlottingMacro | QmatNMR.RecordingMacro)
          if (QmatNMR.Dim == 0)
            QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
      
          elseif (QmatNMR.Dim == 1)
            QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
            QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
      
          else
            QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
            QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
          end
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 401);
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 701, QmatNMR.Dim, QTEMP4(1), QTEMP4(2)-QTEMP4(1), QTEMP4(end), QTEMP5, QmatNMR.xmin, QmatNMR.totaalX, QmatNMR.VerticalStackymin, QmatNMR.VerticalStacktotaalY);  	%code for stack1d, dimension, range, offset, QmatNMR.xmin, QmatNMR.xmin+QmatNMR.totaalX, QmatNMR.ymin, QmatNMR.ymin+QmatNMR.totaalY
        end
      end  
  
  
      if (~QmatNMR.BusyWithMacro)		%unless we are processing a macro, we reset the mouse pointer and the 1D undo matrix
        %clear the previous 1D undo matrix
        QmatNMR.UnDoMatrix1D = GenerateMatNMRStructure;
        
        Arrowhead;
      end
    end
  
  
  
  else
    disp('Vertical stack plot cancelled');
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
