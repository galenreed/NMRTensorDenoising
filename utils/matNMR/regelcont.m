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
%regelcont.m takes care of the input for the plotting of contours
%28-12-'96

try
  if QmatNMR.buttonList == 1
    [QmatNMR.SpecName2D3D, QmatNMR.CheckInput] = checkinput(QmatNMR.uiInput1);	%Upload the spectrum that needs to be plotted
    QmatNMR.contdisplay = get(QmatNMR.c17, 'value');	%popup button in figure window for real/imag/absolute display
    QmatNMR.under = eval(QmatNMR.uiInput2);
    QmatNMR.over = eval(QmatNMR.uiInput3);
  
    QmatNMR.multcont = eval(QmatNMR.uiInput4);
  								%First check whether the multiplier is not smaller
  								%than 0 because then the contour levels will be bad.
    if (QmatNMR.multcont < 1)
      disp('matNMR ERROR: multiplier must be larger than or equal to 1. Mulitplier is reset to 1 (linear scale) !');
      QmatNMR.multcont = 1;
    end
  
    QmatNMR.numbcont = eval(['[' QmatNMR.uiInput5 ']']);
    QmatNMR.negcont = QmatNMR.uiInput6;
    QmatNMR.UserDefAxisT2Cont = QmatNMR.uiInput7;
    QmatNMR.UserDefAxisT1Cont = QmatNMR.uiInput8;
    QmatNMR.ContourLineSpec = QmatNMR.uiInput9;
    QmatNMR.Q2D3DMacro = QmatNMR.uiInput10;
  
  %
  %clear the previous peak list !
  %
  QmatNMR.PeakList	= [];
  
  
  %
  %just in case the variable happens to be a 3D matrix we pre-set these variables
  %
    if (QmatNMR.Q2D3DPlottingSeries == 0)		%don't set these variables when plotting a series of 2D spectra
      QmatNMR.UserDefAxisT2ContSeries = QmatNMR.UserDefAxisT2Cont;
      QmatNMR.UserDefAxisT1ContSeries = QmatNMR.UserDefAxisT1Cont;
    end
  
  
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
  QmatNMR.Q2D3DPlotType = 1;
  
    
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
      if (QmatNMR.FlagCutSpectrum == 1)
        %
        %a cut spectrum
        %
        regelplotcutspectrum;
      else
        %
        %Normal spectrum
        %
        [QTEMP3, QTEMP4] = size(QmatNMR.Spec2D3D);
        
        if isempty(QmatNMR.UserDefAxisT2Cont)			%Is the line empty ? --> axes in points in TD 2
          QmatNMR.Axis2D3DTD2 = 1:QTEMP4;
          QmatNMR.textt2 = 'T2 (Points)';
        else
          QmatNMR.Axis2D3DTD2 = eval(QmatNMR.UserDefAxisT2Cont);		      %override the axis saved with the peak list!
    
          if (length(QmatNMR.Axis2D3DTD2)~=QTEMP4)		      %now check whether the length is correct!
     	QmatNMR.Axis2D3DTD2 = 1:QTEMP4;
     	QmatNMR.textt2 = 'T2 (Points)';
            disp('matNMR WARNING: axis supplied for TD2 was not of the right length!');
     	disp('matNMR WARNING: axis in TD2 is taken in points');
     	QmatNMR.UserDefAxisT2Cont = zeros(0, 0);
          else
     	QmatNMR.textt2 = 'T2 (User def.)';
          end
        end
    
        if isempty(QmatNMR.UserDefAxisT1Cont)			%Is the line empty ? --> axes in points in TD 1
          QmatNMR.Axis2D3DTD1 = 1:QTEMP3;
          QmatNMR.textt1 = 'T1 (Points)';
        else
    							%axes given by user defined variables in TD 1
          QmatNMR.Axis2D3DTD1 = eval(QmatNMR.UserDefAxisT1Cont); 		%override the axis saved with the peak list!
    
          if (length(QmatNMR.Axis2D3DTD1)~=QTEMP3) 			%now check whether the length is correct!
        	QmatNMR.Axis2D3DTD1 = 1:QTEMP3;
        	QmatNMR.textt1 = 'T1 (Points)';
            disp('matNMR WARNING: axis supplied for TD1 was not of the right length!');
        	disp('matNMR WARNING: axis in TD1 is taken in points');
        	QmatNMR.UserDefAxisT1Cont = zeros(0, 0);
          else
        	QmatNMR.textt1 = 'T1 (User def.)';
          end
        end
    
    
        %now if the axis vectors are called "QmatNMR.TempAxis1Cont" and "QmatNMR.TempAxis2Cont" then they will be
        %cleared because this means that either the variable structure contained a proper axis vector OR
        %the defineplotlimits.m was used. In either case this variable name must not be seen again!
        if strcmp(QmatNMR.UserDefAxisT2Cont, 'QmatNMR.TempAxis1Cont')
          QmatNMR.UserDefAxisT2Cont = '';
        end
        if strcmp(QmatNMR.UserDefAxisT1Cont, 'QmatNMR.TempAxis2Cont')
          QmatNMR.UserDefAxisT1Cont = '';
        end
    
        %now plot the spectrum
        dispcont;
      end
    end  
  else
    disp('No valid input given !! No spectrum will be displayed ...');
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
