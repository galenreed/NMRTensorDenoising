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
%DetermineNewAxisLimits.m determines the axis limits for a new plot.
%16-10-'01


try
  if (QmatNMR.DisplayMode ~= 3)        %if not 'both'
    QmatNMR.Ylimiet = get(gca, 'YLim');
    QmatNMR.minY = QmatNMR.Ylimiet(1,1);
    QmatNMR.maxY = QmatNMR.Ylimiet(1,2);
  
    QmatNMR.ymin = QmatNMR.minY;
    QmatNMR.totaalY = QmatNMR.maxY - QmatNMR.minY;
    if (abs(QmatNMR.totaalY) < eps^2)
      QmatNMR.ymin = QmatNMR.ymin - 1;
      QmatNMR.totaalY = 2;	      %to prevent Matlab from showing nothing
    end
  
    [QTEMP1, QmatNMR.Size1D] = size(QmatNMR.Spec1DPlot);
    QmatNMR.totaalX = QmatNMR.Axis1DPlot(QmatNMR.Size1D) - QmatNMR.Axis1DPlot(1);
  
    QmatNMR.xmin = QmatNMR.Axis1DPlot(1);
    if (abs(QmatNMR.totaalX) < eps^2)
      QmatNMR.xmin = QmatNMR.xmin - 1;
      QmatNMR.totaalX = 2;	      %just in case in a 2D mode a 1D vector was loaded
    end
    
  else		      %display mode is 'both'
    QmatNMR.Ylimiet = get(gca, 'YLim');
    QmatNMR.minY = QmatNMR.Ylimiet(1,1);
    QmatNMR.maxY = QmatNMR.Ylimiet(1,2);
  
    QmatNMR.ymin = QmatNMR.minY;
    QmatNMR.totaalY = QmatNMR.maxY - QmatNMR.minY;
    if (abs(QmatNMR.totaalY) < eps^2)
      QmatNMR.ymin = QmatNMR.ymin - 1;
      QmatNMR.totaalY = 2;	      %to prevent Matlab from showing nothing
    end
  
    [QTEMP1, QmatNMR.Size1D] = size(QmatNMR.Spec1DPlot);
    QmatNMR.totaalX = 2*QmatNMR.Axis1DPlot(QmatNMR.Size1D) - 3*QmatNMR.Axis1DPlot(1) + QmatNMR.Axis1DPlot(2);
  
    QmatNMR.xmin = QmatNMR.Axis1DPlot(1);
    if (abs(QmatNMR.totaalX) < eps^2)
      QmatNMR.xmin = QmatNMR.xmin - 1;
      QmatNMR.totaalX = 2;	      %just in case in a 2D mode a 1D vector was loaded
    end
  end
  
  clear QTEMP1

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
