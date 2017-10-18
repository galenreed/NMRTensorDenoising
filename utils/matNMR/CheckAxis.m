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
%CheckAxis.m checks whether the axis for the current 1D plot is ascending or descending.
%
%if the axis is descending the the vector will be flipped from left to right together with
%the axis. That way the axis will become ascending again (the only way MATLAB can plot 
%unfortunately!). Also the 'xdir' property of the axis will be set to 'normal'.
%
%for an ascending axis the 'xdir' property of the axis will be set to 'reverse'
%
%12-11-'98

try
  if (QmatNMR.FIDstatus == 1)			%means it's a spectrum
    if (QmatNMR.Rincr > 0)			%ascending axis
      QmatNMR.Axis1DPlot = QmatNMR.Axis1D;
      QmatNMR.AxisPlotDirection = 'reverse';
    
    else						%descending axis
      QmatNMR.Spec1DPlot = fliplr(QmatNMR.Spec1DPlot);
      QmatNMR.Axis1DPlot = fliplr(QmatNMR.Axis1D);
      QmatNMR.AxisPlotDirection = 'normal ';
    end  
  
  else						%it's an FID
    if (QmatNMR.Rincr > 0)			%ascending axis
      QmatNMR.Axis1DPlot = QmatNMR.Axis1D;
      QmatNMR.AxisPlotDirection = 'normal ';
    
    else						%descending axis
      QmatNMR.Spec1DPlot = fliplr(QmatNMR.Spec1DPlot);
      QmatNMR.Axis1DPlot = fliplr(QmatNMR.Axis1D);
      QmatNMR.AxisPlotDirection = 'normal';
    end  
  end  
    

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
