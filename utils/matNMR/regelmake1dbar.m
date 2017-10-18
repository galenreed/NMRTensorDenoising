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
%regelmake1dbar.m creates a 1D bar plot from the current FID/Spectrum in the main
%window
%
%09-10-2003


try
  if QmatNMR.buttonList == 1		%OK-button
    %get the axis handle
    QmatNMR.TEMPAxis = gca;
  
  
    QmatNMR.Q1DBarWidth  = eval(QmatNMR.uiInput1);
    QmatNMR.Q1DBarColour = QmatNMR.uiInput2;
    QmatNMR.Q1DBarEdges = QmatNMR.uiInput3;
  
    %remember the original title of the plot
    QTEMP8 = get(get(QmatNMR.TEMPAxis, 'title'), 'string');
  
    QTEMP9 = str2mat(' ', 'r', 'g', 'b', 'y', 'm', 'c', 'k', 'w');
  
    if (QmatNMR.DisplayMode == 1)			%Real spectrum
      QTEMP67 = bar(QmatNMR.Axis1D, real(QmatNMR.Spec1D), QmatNMR.Q1DBarWidth, deblank(QTEMP9(QmatNMR.Q1DBarColour, :)));
  
    elseif (QmatNMR.DisplayMode == 2)			%Imaginary spectrum
      QTEMP67 = bar(QmatNMR.Axis1D, imag(QmatNMR.Spec1D), QmatNMR.Q1DBarWidth, deblank(QTEMP9(QmatNMR.Q1DBarColour, :)));
  
    elseif (QmatNMR.DisplayMode == 4)			%Absolute spectrum
      QTEMP67 = bar(QmatNMR.Axis1D, abs(QmatNMR.Spec1D), QmatNMR.Q1DBarWidth, deblank(QTEMP9(QmatNMR.Q1DBarColour, :)));
  
    elseif (QmatNMR.DisplayMode == 5)			%Power spectrum
      QTEMP67 = bar(QmatNMR.Axis1D, abs(QmatNMR.Spec1D).^2, QmatNMR.Q1DBarWidth, deblank(QTEMP9(QmatNMR.Q1DBarColour, :)));
    end
    
    %
    %set the edge color the same as the face color, if asked for
    %
    if (QmatNMR.Q1DBarEdges)
      set(QTEMP67, 'edgecolor', get(QTEMP67, 'facecolor'));
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
    %Now change the x limits slightly
    %
    QmatNMR.xmin = QmatNMR.xmin - abs(QmatNMR.Rincr);
    QmatNMR.totaalX = QmatNMR.totaalX + 2*abs(QmatNMR.Rincr);
  
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
    %add this to the processing history
    %
    QmatNMR.History = str2mat(QmatNMR.History, '1D bar plot created from the current view');
    
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
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 702, QmatNMR.Q1DBarWidth, QmatNMR.Q1DBarColour);	%code for 1D bar plot
    
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
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 702, QmatNMR.Q1DBarWidth, QmatNMR.Q1DBarColour);	%code for 1D bar plot
    end
  
  
    %
    %Finish off
    %
    QmatNMR.PlotType = 4; 	%denotes 1D bar plot
    QmatNMR.nrspc = 1;
    disp('Finished making 1D bar plot ...');
  
  else
    disp('Making 1D bar plot cancelled ...');
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
