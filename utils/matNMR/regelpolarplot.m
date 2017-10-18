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
%regelpolarplot.m processes the input for the creation of a polar plot.
%
%30-07-'01

try
  if (QmatNMR.buttonList == 1)
    [QmatNMR.SpecName2D3D, QmatNMR.CheckInput] = checkinput(QmatNMR.uiInput1);	%Upload the spectrum that needs to be plotted
    QmatNMR.PolarPlotAxis = QmatNMR.uiInput2;
    QmatNMR.PolarPlotPlotType = QmatNMR.uiInput3;
  
    if ((QmatNMR.PolarPlotPlotType == 2) | (QmatNMR.PolarPlotPlotType == 4))	%relative contours
      QmatNMR.under = eval(QmatNMR.uiInput5);
      QmatNMR.over = eval(QmatNMR.uiInput6);
      QmatNMR.multcont = eval(QmatNMR.uiInput7);
  								%First check whether the multiplier is not smaller
  								%than 1 because then the contour levels will be bad.
      if (QmatNMR.multcont < 0)
        disp('matNMR ERROR: multiplier must be larger than 0. Mulitplier is reset to 1 (linear scale) !');
        QmatNMR.multcont = 1;
      end
      
      QmatNMR.numbcont = eval(['[' QmatNMR.uiInput8 ']']);
      QmatNMR.negcont = QmatNMR.uiInput9;
  
    elseif ((QmatNMR.PolarPlotPlotType == 3) | (QmatNMR.PolarPlotPlotType == 5))%absolute contours
      QmatNMR.PolarPlotContourLevels = QmatNMR.uiInput4;
    end
    QmatNMR.Q2D3DMacro = QmatNMR.uiInput10;
  
  
  %
  %read in variable(s) depending on the datatype. The expression given by the user is checked for variables and
  %functions (that are assumed to give proper results). The 1D data matrix is constructed from this information depending on whether
  %the variable is a structure or not (matNMR datatype). The history is only taken from a structure
  %if the variable QmatNMR.numbvars is 1 !!
  %
    QmatNMR.SpecName2D3DProc = QmatNMR.SpecName2D3D;
    checkinputcont
    if (QmatNMR.BREAK) 		%there was a problem with the input so we won't continue!
      QmatNMR.BREAK = 0;
      return
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
  QmatNMR.Q2D3DPlotType = 6;
  
  
  %
  %a 3D matrix has been supplied to the routine and this means a series of 2D spectra will be plotted
  %if possible
  %
    if (ndims(squeeze(QmatNMR.Spec2D3D)) == 3)
      disp('A 3D matrix has been supplied and will be plotted in the available subplots....');
      regelplotseries
      
    elseif (ndims(squeeze(QmatNMR.Spec2D3D)) > 3)
      error('matNMR ERROR: Matrix has a dimension size bigger than 3!');
  
    else
      %now plot the spectrum
      disppolarplot;
    end  
  else
    disp('No valid input given !! No spectrum will be displayed ...');
  end

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
