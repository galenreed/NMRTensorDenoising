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
%regeldisplaymode.m sets the display mode variable and the plot commands based on the setting
%	of the uicontrol QmatNMR.h76 in the main window.
%11-10-2001

try
  QmatNMR.DisplayModeOLD = QmatNMR.DisplayMode;				%remember previous display mode
  QmatNMR.DisplayMode = get(QmatNMR.h76, 'value');		%determine new display mode
  
  if (QmatNMR.DisplayMode == 1)				%Real spectrum
    QmatNMR.PlotCommand = 'plot(QmatNMR.Axis1DPlot, real(QmatNMR.Spec1DPlot), [QmatNMR.LineColor QmatNMR.LineType QmatNMR.MarkerType]);';
    QmatNMR.DualPlotCommand = 'plot(QmatNMR.dualaxisPlot, real(QmatNMR.dual), [QmatNMR.color(rem(QmatNMR.nrspc, length(QmatNMR.color)) + 1) QmatNMR.MarkerType QmatNMR.LineType]);';
  
  elseif (QmatNMR.DisplayMode == 2)			%Imaginary spectrum
    QmatNMR.PlotCommand = 'plot(QmatNMR.Axis1DPlot, imag(QmatNMR.Spec1DPlot), [QmatNMR.LineColor QmatNMR.LineType QmatNMR.MarkerType]);';
    QmatNMR.DualPlotCommand = 'plot(QmatNMR.dualaxisPlot, imag(QmatNMR.dual), [QmatNMR.color(rem(QmatNMR.nrspc, length(QmatNMR.color)) + 1) QmatNMR.MarkerType QmatNMR.LineType]);';
  
  elseif (QmatNMR.DisplayMode == 3)			%Both = Real+Imaginary spectrum
    if (QmatNMR.FIDstatus == 1)	%spectrum
      if (QmatNMR.Rincr>0)	%ascending axes
        QmatNMR.PlotCommand = 'plot(QmatNMR.Axis1DPlot, imag(QmatNMR.Spec1DPlot), [QmatNMR.LineColor QmatNMR.LineType QmatNMR.MarkerType], (QmatNMR.Axis1DPlot+QmatNMR.Rincr+QmatNMR.Axis1DPlot(QmatNMR.Size1D)-QmatNMR.Axis1DPlot(1)), real(QmatNMR.Spec1DPlot), [QmatNMR.LineColor QmatNMR.LineType QmatNMR.MarkerType]);';
        QmatNMR.DualPlotCommand = 'plot(QmatNMR.dualaxisPlot, imag(QmatNMR.dual), [QmatNMR.color(rem(QmatNMR.nrspc, length(QmatNMR.color)) + 1) QmatNMR.MarkerType QmatNMR.LineType], (QmatNMR.dualaxisPlot+QmatNMR.dualaxisincr+QmatNMR.dualaxisPlot(QmatNMR.dimDualSpec)-QmatNMR.dualaxisPlot(1)), real(QmatNMR.dual), [QmatNMR.color(rem(QmatNMR.nrspc, length(QmatNMR.color)) + 1) QmatNMR.MarkerType QmatNMR.LineType]);';
  
      else		%descending axes
        QmatNMR.PlotCommand = 'plot(QmatNMR.Axis1DPlot, real(QmatNMR.Spec1DPlot), [QmatNMR.LineColor QmatNMR.LineType QmatNMR.MarkerType], (QmatNMR.Axis1DPlot-QmatNMR.Rincr+QmatNMR.Axis1DPlot(QmatNMR.Size1D)-QmatNMR.Axis1DPlot(1)), imag(QmatNMR.Spec1DPlot), [QmatNMR.LineColor QmatNMR.LineType QmatNMR.MarkerType]);';
        QmatNMR.DualPlotCommand = 'plot(QmatNMR.dualaxisPlot, real(QmatNMR.dual), [QmatNMR.color(rem(QmatNMR.nrspc, length(QmatNMR.color)) + 1) QmatNMR.MarkerType QmatNMR.LineType], (QmatNMR.dualaxisPlot-QmatNMR.dualaxisincr+QmatNMR.dualaxisPlot(QmatNMR.dimDualSpec)-QmatNMR.dualaxisPlot(1)), imag(QmatNMR.dual), [QmatNMR.color(rem(QmatNMR.nrspc, length(QmatNMR.color)) + 1) QmatNMR.MarkerType QmatNMR.LineType]);';
      end
    else			%FID
      if (QmatNMR.Rincr>0)	%ascending axes (positive time increment)
        QmatNMR.PlotCommand = 'plot(QmatNMR.Axis1DPlot, real(QmatNMR.Spec1DPlot), [QmatNMR.LineColor QmatNMR.LineType QmatNMR.MarkerType], (QmatNMR.Axis1DPlot+QmatNMR.Rincr+QmatNMR.Axis1DPlot(QmatNMR.Size1D)-QmatNMR.Axis1DPlot(1)), imag(QmatNMR.Spec1DPlot), [QmatNMR.LineColor QmatNMR.LineType QmatNMR.MarkerType]);';
        QmatNMR.DualPlotCommand = 'plot(QmatNMR.dualaxisPlot, real(QmatNMR.dual), [QmatNMR.color(rem(QmatNMR.nrspc, length(QmatNMR.color)) + 1) QmatNMR.MarkerType QmatNMR.LineType], (QmatNMR.dualaxisPlot+QmatNMR.dualaxisincr+QmatNMR.dualaxisPlot(QmatNMR.dimDualSpec)-QmatNMR.dualaxisPlot(1)), imag(QmatNMR.dual), [QmatNMR.color(rem(QmatNMR.nrspc, length(QmatNMR.color)) + 1) QmatNMR.MarkerType QmatNMR.LineType]);';
  
      else		%descending axes (negative time increment)
        QmatNMR.PlotCommand = 'plot(QmatNMR.Axis1DPlot, real(QmatNMR.Spec1DPlot), [QmatNMR.LineColor QmatNMR.LineType QmatNMR.MarkerType], (QmatNMR.Axis1DPlot-QmatNMR.Rincr+QmatNMR.Axis1DPlot(QmatNMR.Size1D)-QmatNMR.Axis1DPlot(1)), imag(QmatNMR.Spec1DPlot), [QmatNMR.LineColor QmatNMR.LineType QmatNMR.MarkerType]);';
        QmatNMR.DualPlotCommand = 'plot(QmatNMR.dualaxisPlot, real(QmatNMR.dual), [QmatNMR.color(rem(QmatNMR.nrspc, length(QmatNMR.color)) + 1) QmatNMR.MarkerType QmatNMR.LineType], (QmatNMR.dualaxisPlot-QmatNMR.dualaxisincr+QmatNMR.dualaxisPlot(QmatNMR.dimDualSpec)-QmatNMR.dualaxisPlot(1)), imag(QmatNMR.dual), [QmatNMR.color(rem(QmatNMR.nrspc, length(QmatNMR.color)) + 1) QmatNMR.MarkerType QmatNMR.LineType]);';
      end
    end  
  
  elseif (QmatNMR.DisplayMode == 4)			%Absolute spectrum
    QmatNMR.PlotCommand = 'plot(QmatNMR.Axis1DPlot, abs(QmatNMR.Spec1DPlot), [QmatNMR.LineColor QmatNMR.LineType QmatNMR.MarkerType]);';
    QmatNMR.DualPlotCommand = 'plot(QmatNMR.dualaxisPlot, abs(QmatNMR.dual), [QmatNMR.color(rem(QmatNMR.nrspc, length(QmatNMR.color)) + 1) QmatNMR.MarkerType QmatNMR.LineType]);';
  
  elseif (QmatNMR.DisplayMode == 5)			%Power spectrum
    QmatNMR.PlotCommand = 'plot(QmatNMR.Axis1DPlot, (abs(QmatNMR.Spec1DPlot).^2), [QmatNMR.LineColor QmatNMR.LineType QmatNMR.MarkerType]);';
    QmatNMR.DualPlotCommand = 'plot(QmatNMR.dualaxisPlot, (abs(QmatNMR.dual).^2), [QmatNMR.color(rem(QmatNMR.nrspc, length(QmatNMR.color)) + 1) QmatNMR.MarkerType QmatNMR.LineType]);';
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
