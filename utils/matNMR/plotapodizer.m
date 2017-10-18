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
%plotapodizer.m plots the chosen apodization function in the same window as the 1D FID
%
%13-11-'98

try
  hold on
  
  %
  %Add a line to show the shape of the apodization function
  %
  if (QmatNMR.Rincr > 0)						%ascending axis
    if ((QmatNMR.lbstatus == 100) | (QmatNMR.lbstatus == 1001)) 		%Shifting Gaussian function
      if (QmatNMR.DisplayMode ~= 3)	%display mode is not 'both'
        plot(QmatNMR.Axis1DPlot, QmatNMR.emacht(QmatNMR.rijnr, :)*(QmatNMR.ymin+QmatNMR.totaalY)/(max(QmatNMR.emacht(QmatNMR.rijnr, :))), QmatNMR.color(rem(2, length(QmatNMR.color)) + 1));
  
      else
        QTEMP = QmatNMR.emacht(QmatNMR.rijnr, :)*(QmatNMR.ymin+QmatNMR.totaalY)/(max(QmatNMR.emacht(QmatNMR.rijnr, :)));
        plot([QmatNMR.Axis1DPlot (QmatNMR.Axis1DPlot+QmatNMR.Axis1DPlot(QmatNMR.Size1D))], [QTEMP QTEMP], QmatNMR.color(rem(2, length(QmatNMR.color)) + 1));
      end
  
    else
      if (QmatNMR.DisplayMode ~= 3)	%display mode is not 'both'
        plot(QmatNMR.Axis1DPlot, QmatNMR.emacht*(QmatNMR.ymin+QmatNMR.totaalY), QmatNMR.color(rem(2, length(QmatNMR.color)) + 1));
  
      else
        QTEMP = QmatNMR.emacht*(QmatNMR.ymin+QmatNMR.totaalY);
        plot([QmatNMR.Axis1DPlot (QmatNMR.Axis1DPlot+QmatNMR.Axis1DPlot(QmatNMR.Size1D))], [QTEMP QTEMP], QmatNMR.color(rem(2, length(QmatNMR.color)) + 1));
      end
    end
  
  else							%descending axis
    if ((QmatNMR.lbstatus == 100) | (QmatNMR.lbstatus == 1001)) 		%Shifting Gaussian function
      if (QmatNMR.DisplayMode ~= 3)	%display mode is not 'both'
        plot(QmatNMR.Axis1DPlot, fliplr(QmatNMR.emacht(QmatNMR.rijnr, :)*(QmatNMR.ymin+QmatNMR.totaalY)/(max(QmatNMR.emacht(QmatNMR.rijnr, :)))), QmatNMR.color(rem(2, length(QmatNMR.color)) + 1));
  
      else
        QTEMP = fliplr(QmatNMR.emacht(QmatNMR.rijnr, :)*(QmatNMR.ymin+QmatNMR.totaalY)/(max(QmatNMR.emacht(QmatNMR.rijnr, :))));
        plot([QmatNMR.Axis1DPlot (QmatNMR.Axis1DPlot+QmatNMR.Axis1DPlot(QmatNMR.Size1D))], [QTEMP QTEMP], QmatNMR.color(rem(2, length(QmatNMR.color)) + 1));
      end
  
    else
      if (QmatNMR.DisplayMode ~= 3)	%display mode is not 'both'
        plot(QmatNMR.Axis1DPlot, fliplr(QmatNMR.emacht*(QmatNMR.ymin+QmatNMR.totaalY)), QmatNMR.color(rem(2, length(QmatNMR.color)) + 1));
  
      else
        QTEMP = fliplr(QmatNMR.emacht*(QmatNMR.ymin+QmatNMR.totaalY));
        plot([QmatNMR.Axis1DPlot (QmatNMR.Axis1DPlot+QmatNMR.Axis1DPlot(QmatNMR.Size1D))], [QTEMP QTEMP], QmatNMR.color(rem(2, length(QmatNMR.color)) + 1));
      end
    end
  end
  
  
  %
  %deal with the tick labels that are special for display mode 'both'
  %
  if (QmatNMR.DisplayMode == 3)         %display mode is 'both' -> needs special care for the tick marks on the x-axis
    QTEMP8 = get(QmatNMR.TEMPAxis, 'xtick');
    QTEMP8 = QTEMP8(find(QTEMP8 <= max(QmatNMR.Axis1D)));
  
    if (QmatNMR.FIDstatus == 1)         %spectrum
      if (strcmp(QmatNMR.AxisPlotDirection, 'reverse')) %ascending axis
        QTEMP9 = sort(unique([QTEMP8 (QTEMP8+QmatNMR.Axis1D(QmatNMR.Size1D)-QmatNMR.Rnull)]));
        set(QmatNMR.TEMPAxis, 'xtick', sort(QTEMP9), 'xticklabel', [QTEMP8 QTEMP8]);
  
      else                                              %descending axis
        QTEMP9 = sort(unique([QTEMP8 (QTEMP8-QmatNMR.Axis1D(QmatNMR.Size1D)+QmatNMR.Rnull)]));
        set(QmatNMR.TEMPAxis, 'xtick', QTEMP9, 'xticklabel', [QTEMP8 QTEMP8]);
      end
  
    else                        %FID
      if (QmatNMR.Rincr > 0)                                    %ascending axis
        QTEMP9 = sort(unique([QTEMP8 (QTEMP8+QmatNMR.Axis1D(QmatNMR.Size1D)-QmatNMR.Rnull)]));
        set(QmatNMR.TEMPAxis, 'xtick', QTEMP9, 'xticklabel', [QTEMP8 QTEMP8]);
  
      else                                              %descending axis
        QTEMP9 = sort(unique([QTEMP8 (QTEMP8-QmatNMR.Axis1D(QmatNMR.Size1D)+QmatNMR.Rnull)]));
        set(QmatNMR.TEMPAxis, 'xtick', QTEMP9, 'xticklabel', [QTEMP8 QTEMP8]);
      end
    end
  end
  
  
  %
  %finished
  %
  hold off
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
