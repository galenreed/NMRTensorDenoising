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
%simpelplot.m plots the 1D spectrum but does not alter the scaling
%9-8-'96

try
  removecurrentline		%removes the apodization line(s) if necessary
  
  if (isempty(QmatNMR.TempHandle) | (QmatNMR.PlotType ~= 1))
    %just in case that no line was found (e.g. after a horizontal stack plot)
    %
    %OR
    %
    %the plot type was not 1 (the default type)
    %
    %then we perform a reset figure
    %
    asaanpas
  
  else
    %
    %simpelplot only makes default plots, i.e.nothing special
    %
    QmatNMR.PlotType = 1;
    
    if (~QmatNMR.lbstatus == 0)
      CheckAxis;			%checks whether the axis is ascending or descending and adjusts the
    				%plot direction if necessary
    end 
    
    switch QmatNMR.DisplayMode
      %
      %Then we update the plot
      %
      case 1				%real value display
        set(QmatNMR.TempHandle(length(QmatNMR.TempHandle)), 'xdata', QmatNMR.Axis1DPlot, 'ydata', real(QmatNMR.Spec1DPlot));
    
      case 2				%imaginary value display
        set(QmatNMR.TempHandle(length(QmatNMR.TempHandle)), 'xdata', QmatNMR.Axis1DPlot,  'ydata', imag(QmatNMR.Spec1DPlot));
    
      case 3  				%both real and imaginary value display
        asaanpas
    
      case 4  				%absolute value display
        set(QmatNMR.TempHandle(length(QmatNMR.TempHandle)), 'xdata', QmatNMR.Axis1DPlot,  'ydata', abs(QmatNMR.Spec1DPlot));
    
      case 5  				%power value display
        set(QmatNMR.TempHandle(length(QmatNMR.TempHandle)), 'xdata', QmatNMR.Axis1DPlot,  'ydata', abs(QmatNMR.Spec1DPlot).^2);
    end
  end
  
  xlabel(strrep(QmatNMR.texie, '\n', char(10)));
  ylabel(''); 		%by default there is no y-label
  DIMstatus 		%shows which dimension we're working in by changing the corresponding UI control
  
  if (~QmatNMR.lbstatus == 0)
  %
  %plot apodization function in blue
  %
    plotapodizer
  end  

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
