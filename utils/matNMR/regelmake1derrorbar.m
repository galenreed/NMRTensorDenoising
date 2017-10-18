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
%regelmake1derrorbar.m creates a 1D error bar plot from the current FID/Spectrum in the main
%window
%
%09-10-2003

try
  if QmatNMR.buttonList == 1		%OK-button
    %get the axis handle
    QmatNMR.TEMPAxis = gca;
  
  
    QmatNMR.Q1DErrorBars = QmatNMR.uiInput1;
  
    [QmatNMR.Q1DErrorBars, QmatNMR.CheckInput] = checkinput(QmatNMR.Q1DErrorBars); %adjust the format of the input expression for later use
    QmatNMR.Q1DErrorBars2 = QmatNMR.Q1DErrorBars;
    checkinputerrorbar
    QTEMP1 = eval(QmatNMR.Q1DErrorBars2);
    
  
    %remember the original title of the plot
    QTEMP8 = get(get(QmatNMR.TEMPAxis, 'title'), 'string');
  
  
    %
    %Now check whether the length of the vector is correct. A single number is interpreted
    %as the same error for all points.
    %
    if (length(QTEMP1) == 1)	%a single number has been entered
      QTEMP1 = QTEMP1*ones(1, QmatNMR.Size1D);
  
    else				%check to see if the length is correct
      [QTEMP2, QTEMP3] = size(QTEMP1);
      if ((QTEMP2 ~= 1) & (QTEMP3 ~= 1))	%is this really a 1D vector?
        disp('matNMR WARNING: error bar vector is not a 1D variable! Aborting ...');
        return
      end
  
      if (length(QTEMP1) ~= QmatNMR.Size1D) 	%check to see if the length is correct
        disp('matNMR WARNING: error bar vector is of incorrect length. Aborting ...');
        return
      end
    end
  
  
    %
    %make the errorbar plot taking the current display mode into account
    %
    if (QmatNMR.DisplayMode == 1)			%Real spectrum
      errorbarMatNMR(QmatNMR.Axis1D, real(QmatNMR.Spec1D), QTEMP1, deblank([QmatNMR.LineColor QmatNMR.LineType QmatNMR.MarkerType]))
  
    elseif (QmatNMR.DisplayMode == 2)			%Imaginary spectrum
      errorbarMatNMR(QmatNMR.Axis1D, imag(QmatNMR.Spec1D), QTEMP1, deblank([QmatNMR.LineColor QmatNMR.LineType QmatNMR.MarkerType]))
  
    elseif (QmatNMR.DisplayMode == 4)			%Absolute spectrum
      errorbarMatNMR(QmatNMR.Axis1D, abs(QmatNMR.Spec1D), QTEMP1, deblank([QmatNMR.LineColor QmatNMR.LineType QmatNMR.MarkerType]))
  
    elseif (QmatNMR.DisplayMode == 5)			%Power spectrum
      errorbarMatNMR(QmatNMR.Axis1D, abs(QmatNMR.Spec1D).^2, QTEMP1, deblank([QmatNMR.LineColor QmatNMR.LineType QmatNMR.MarkerType]))
    end
    
  
    %
    %Set axis properties similar to asaanpas
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
         'XDir', QmatNMR.AxisPlotDirection);    %CheckAxis.m determines whether the direction should be normal or reverse
    
    
    %
    %Now we set the axis limits. In case the display mode has been set to 'both' then we need to do
    %	take both the real and imaginary into account. This requires special care.
    %
      axis auto
      DetermineNewAxisLimits
    
  
    %
    %Now change the x limits slightly to accomodate for the length of the bars, which are
    %0.02 * QmatNMR.totaalX by default (see errorbar.m)
    %
    QmatNMR.xmin = QmatNMR.xmin - 0.01*QmatNMR.totaalX;
    QmatNMR.totaalX = QmatNMR.totaalX + 0.02*QmatNMR.totaalX;
  
  
    %
    %set the axis limits properly and also change the userdata property of the zlabel
    %as this is used by the MATLAB zoom function.
    %
    axis([QmatNMR.xmin (QmatNMR.xmin+QmatNMR.totaalX) QmatNMR.ymin (QmatNMR.ymin+QmatNMR.totaalY)]);
    setappdata(QmatNMR.TEMPAxis, 'ZoomLimitsMatNMR', [QmatNMR.xmin (QmatNMR.xmin+QmatNMR.totaalX) QmatNMR.ymin (QmatNMR.ymin+QmatNMR.totaalY)]);
  
  
    %
    %Set the title to the plot
    %
    title(QTEMP8, 'Color', QmatNMR.ColorScheme.AxisFore);
  
  
    %
    %Create a grid if asked for by the setting in the options
    %
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
  
  
    %
    %add this to the processing history
    %
    QmatNMR.History = str2mat(QmatNMR.History, 'Errorbar plot created from the current view');
    
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
    %
    %then store the input string and the action into the history macro
    %
    QTEMP1 = deblank(fliplr(deblank(fliplr(QmatNMR.uiInput1))));			%remove trailing and heading spaces
    QTEMP11 = double(['QmatNMR.uiInput1 = ''' QTEMP1 '''']);
    QTEMP12 = ceil(length(QTEMP11)/(QmatNMR.MacroLength-1));
    QTEMP13 = zeros(1, QTEMP12*(QmatNMR.MacroLength-1));
    QTEMP13(1:length(QTEMP11)) = QTEMP11;
    for QTEMP40=1:QTEMP12
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 711, QTEMP13((QTEMP40-1)*(QmatNMR.MacroLength-1)+ (1:(QmatNMR.MacroLength-1))));
    end
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 712);
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 703, QmatNMR.Dim);	%code for errorbar plot
    
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
      for QTEMP40=1:QTEMP12
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 711, QTEMP13((QTEMP40-1)*(QmatNMR.MacroLength-1)+ (1:(QmatNMR.MacroLength-1))));
      end
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 712);
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 703, QmatNMR.Dim);	%code for errorbar plot
    end
  
  
    %
    %Finish off
    %
    QmatNMR.PlotType = 5; 	%denotes 1D error bar plot
    QmatNMR.nrspc = 1;
    disp('Finished making 1D error bar plot ...');
  
  else
    disp('Making 1D error bar plot cancelled ...');
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
