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
%regelplotseries.m takes care of plotting a series of 2D spectra, with the particular plot
%type specified by QmatNMR.Q2D3DPlotType
%27-07-'04

try
  if QmatNMR.buttonList == 1
    QSeriesName = QmatNMR.uiInput1;
    QmatNMR.SpecName2D3D = QSeriesName;
  
    QSeriesAxisTD2 = QmatNMR.TempAxis1Cont;
    QSeriesAxisTD1 = QmatNMR.TempAxis2Cont;
    QSeriesSpec = QmatNMR.Spec2D3D;
    QSeriesSize = size(QSeriesSpec);			%first check whether there are enough subplots available to plot
    							%all spectra
  
    QSeriesSubPlotNR = get(QmatNMR.AxisHandle2D3D, 'userdata');	%number of the current subplot
    if isempty(QSeriesSubPlotNR)
      disp('matNMR ERROR: current axis does not have the axis number in the tag. Cannot execute');
      disp('matNMR ERROR: the requested function without this. Please go to the plot manipulations');
      disp('matNMR ERROR: menu and choose the requested number of subplots.');
    end  
  
    if (QSeriesSize(1) > QmatNMR.ContNrSubplots)
      disp('matNMR WARNING: not enough subplots defined to plot all spectra in!!');
      disp('matNMR WARNING: Plotting was cancelled!');
  
    elseif (QSeriesSize(1) + QSeriesSubPlotNR - 1 > QmatNMR.ContNrSubplots)
      disp('matNMR WARNING: When starting on the current subplot there would not be enough subplots to plot all spectra in!!');
      disp('matNMR WARNING: Please select an earlier subplot to start with. Plotting was cancelled!');
    
    else
      QmatNMR.Q2D3DPlottingSeries = 1;
      
      %
      %if no (correct) axis vector was defined by checkinputcont, we do it now
      %
      if (length(QmatNMR.TempAxis3Cont) ~= QSeriesSize(1))
        QmatNMR.TempAxis3Cont = 1:QSeriesSize(1);
      end
      
      %
      %plot all spectra
      %
      for QSeriesCounter = 1:QSeriesSize(1)
        %
        %show a progress counter if there are many plots to be made
        %
        if (QSeriesSize(1) > 24)
          disp(['Plotting spectrum ' num2str(QSeriesCounter) ' of ' num2str(QSeriesSize(1))]);
        end
      
        %axes(findobj(QmatNMR.Fig2D3D, 'type', 'axes', 'userdata', QSeriesSubPlotNR + QSeriesCounter - 1));	%go to the subplot
        set(QmatNMR.Fig2D3D, 'currentaxes', findobj(QmatNMR.Fig2D3D, 'type', 'axes', 'userdata', QSeriesSubPlotNR + QSeriesCounter - 1));	%go to the subplot
        set(QmatNMR.Fig2D3D, 'selectiontype', 'normal');	%pretend the last mouse button pressed was the left one (bug fix 24-09-'04 related to context menus)
        SelectAxis;

        QmatNMR.uiInput1 = ['squeeze(QSeriesSpec(' num2str(QSeriesCounter) ', :, :))']; 	%define the 2D spectrum
  
        switch (QmatNMR.Q2D3DPlotType)
        %1 = relative contours
        %2 = absolute contours
        %3 = mesh/surface plot
        %4 = stack 3D plot
        %5 = raster plot
        %6 = polar plot
        %7 = bar 2D plot
        %8 = line plot
        %9 = bar 3D plot
          case 1
  	  QmatNMR.uiInput2 = num2str(QmatNMR.under);
  	  QmatNMR.uiInput3 = num2str(QmatNMR.over);
  	  QmatNMR.uiInput4 = num2str(QmatNMR.multcont);
  	  if (length(QmatNMR.numbcont) == 2)
              QmatNMR.uiInput5 = [num2str(QmatNMR.numbcont(1)) ' ' num2str(QmatNMR.numbcont(2))];
  	  else
  	    QmatNMR.uiInput5 = num2str(QmatNMR.numbcont);
  	  end
  	  QmatNMR.uiInput6 = QmatNMR.negcont;
  	  
            if isempty(QSeriesAxisTD2)
              QmatNMR.uiInput7 = '';
            else
              QmatNMR.uiInput7 = 'QSeriesAxisTD2';
            end
            if isempty(QSeriesAxisTD1)
              QmatNMR.uiInput8 = '';
            else
              QmatNMR.uiInput8 = 'QSeriesAxisTD1';
            end
  	  QmatNMR.uiInput9 = QmatNMR.ContourLineSpec;
  	  QmatNMR.uiInput10 = QmatNMR.Q2D3DMacro;
  
            regelcont
  
          case 2
  	  QmatNMR.uiInput2 = QmatNMR.Contourlast;
            if isempty(QSeriesAxisTD2)
              QmatNMR.uiInput3 = '';
            else
              QmatNMR.uiInput3 = 'QSeriesAxisTD2';
            end
            if isempty(QSeriesAxisTD1)
              QmatNMR.uiInput4 = '';
            else
              QmatNMR.uiInput4 = 'QSeriesAxisTD1';
            end
  	  QmatNMR.uiInput5 = QmatNMR.ContourLineSpec;
  	  QmatNMR.uiInput6 = QmatNMR.Q2D3DMacro;
  
            regelabscont
  
          case 3
  	  QmatNMR.uiInput2 = num2str(QmatNMR.az);
  	  QmatNMR.uiInput3 = num2str(QmatNMR.el);
            if isempty(QSeriesAxisTD2)
              QmatNMR.uiInput4 = '';
            else
              QmatNMR.uiInput4 = 'QSeriesAxisTD2';
            end
            if isempty(QSeriesAxisTD1)
              QmatNMR.uiInput5 = '';
            else
              QmatNMR.uiInput5 = 'QSeriesAxisTD1';
            end
            if (get(QmatNMR.MM29, 'value') == 6)	%in case of a surface lightning ask for orientation
              QmatNMR.uiInput6 = num2str(QmatNMR.ContLightAz);
              QmatNMR.uiInput7 = num2str(QmatNMR.ContLightEl);
              QmatNMR.uiInput8 = QmatNMR.Q2D3DMacro;
  
            else
              QmatNMR.uiInput6 = QmatNMR.Q2D3DMacro;
            end
  
            regelmesh
  
          case 4
  	  QmatNMR.uiInput2 = num2str(QmatNMR.Stack3DDimension);
  	  QmatNMR.uiInput3 = num2str(QmatNMR.stackaz);
  	  QmatNMR.uiInput4 = num2str(QmatNMR.stackel);
            if isempty(QSeriesAxisTD2)
              QmatNMR.uiInput5 = '';
            else
              QmatNMR.uiInput5 = 'QSeriesAxisTD2';
            end
            if isempty(QSeriesAxisTD1)
              QmatNMR.uiInput6 = '';
            else
              QmatNMR.uiInput6 = 'QSeriesAxisTD1';
            end
  	  QmatNMR.uiInput7 = QmatNMR.Q2D3DMacro;
  
            regelstack3D
  
          case 5
  	  QmatNMR.uiInput2 = num2str(QmatNMR.RasterSamplingFactor);
            if isempty(QSeriesAxisTD2)
              QmatNMR.uiInput3 = '';
            else
              QmatNMR.uiInput3 = 'QSeriesAxisTD2';
            end
            if isempty(QSeriesAxisTD1)
              QmatNMR.uiInput4 = '';
            else
              QmatNMR.uiInput4 = 'QSeriesAxisTD1';
            end
  	  QmatNMR.uiInput5 = QmatNMR.Q2D3DMacro;
  
            regelraster2D
  
          case 6
  	  QmatNMR.uiInput2 = QmatNMR.PolarPlotAxis;
  	  QmatNMR.uiInput3 = QmatNMR.PolarPlotPlotType;
  	  QmatNMR.uiInput4 = QmatNMR.PolarPlotContourLevels;
  	  QmatNMR.uiInput5 = num2str(QmatNMR.under);
  	  QmatNMR.uiInput6 = num2str(QmatNMR.over);
  	  QmatNMR.uiInput7 = num2str(QmatNMR.multcont);
  	  if (length(QmatNMR.numbcont) == 2)
              QmatNMR.uiInput8 = [num2str(QmatNMR.numbcont(1)) ' ' num2str(QmatNMR.numbcont(2))];
  	  else
  	    QmatNMR.uiInput8 = num2str(QmatNMR.numbcont);
  	  end
  	  QmatNMR.uiInput9 = QmatNMR.negcont;
  	  QmatNMR.uiInput10 = QmatNMR.Q2D3DMacro;
  
            regelpolarplot
  
          case 7
            if isempty(QSeriesAxisTD2)
              QmatNMR.uiInput2 = '';
            else
              QmatNMR.uiInput2 = 'QSeriesAxisTD2';
            end
  	  QmatNMR.uiInput3 = num2str(QmatNMR.Q1DBarWidth);
  	  QmatNMR.uiInput4 = QmatNMR.Q1DBarColour;
  	  QmatNMR.uiInput5 = QmatNMR.Q2D3DMacro;
  
            regelbar
  
          case 8
            if isempty(QSeriesAxisTD2)
              QmatNMR.uiInput2 = '';
            else
              QmatNMR.uiInput2 = 'QSeriesAxisTD2';
            end
  	  QmatNMR.uiInput3 = QmatNMR.ContourLineSpec;
  	  QmatNMR.uiInput4 = QmatNMR.Q2D3DMacro;
  
            regelline
  
          case 9
  	  QmatNMR.uiInput2 = num2str(QmatNMR.az);
  	  QmatNMR.uiInput3 = num2str(QmatNMR.el);
            QmatNMR.uiInput4 = QmatNMR.Bar3DType;
            if isempty(QSeriesAxisTD2)
              QmatNMR.uiInput5 = '';
            else
              QmatNMR.uiInput5 = 'QSeriesAxisTD2';
            end
            if isempty(QSeriesAxisTD1)
              QmatNMR.uiInput6 = '';
            else
              QmatNMR.uiInput6 = 'QSeriesAxisTD1';
            end
  	  QmatNMR.uiInput7 = QmatNMR.Q2D3DMacro;
  
            regelpcolor3d
        end
  
  
        %
        %Use the axis variable for the 3rd dimension
        %
        title(strrep(num2str(QmatNMR.TempAxis3Cont(QSeriesCounter)), '_', '\_'), 'Color', QmatNMR.ColorScheme.AxisFore)
        
        %
        %In case we have many subplots we automatically restrict some things like axis labels etc
        %
        correctforsubplots
      end
      
      %
      %reset the variable name and the axis names to their originals
      %
      QmatNMR.SpecName2D3D = QSeriesName;
      QmatNMR.UserDefAxisT2Cont = QmatNMR.UserDefAxisT2ContSeries;
      QmatNMR.UserDefAxisT1Cont = QmatNMR.UserDefAxisT1ContSeries;
      
      %
      %create a super title with the current variable name
      %
      QmatNMR.uiInput1 = strrep(QmatNMR.SpecName2D3D, '_', '\_');
      QmatNMR.uiInput2 = '16';
      QmatNMR.uiInput3 = '0';
      QmatNMR.buttonList = 1;
      regelsupertitle
  
  
      %
      %Execute a plotting macro if that was asked for
      %
      if ~isempty(QmatNMR.Q2D3DMacro)
        QmatNMR.LastMacroVariable = QmatNMR.Q2D3DMacro;
        QmatNMR.ExecutingMacro = eval(QmatNMR.Q2D3DMacro);
        tic
        RunMacro
        QmatNMR.Timing = toc;
        disp(['Finished executing macro "' QmatNMR.Q2D3DMacro '". Execution time (including rendering) was ' num2str(QmatNMR.Timing, 6) ' seconds']);
      end
      
      clear QTEMP*
      QmatNMR.Q2D3DPlottingSeries = 0;
    end
  
  
    %
    %
    %
    switch (QmatNMR.Q2D3DPlotType)
    %1 = relative contours
    %2 = absolute contours
    %3 = mesh/surface plot
    %4 = stack 3D plot
    %5 = raster plot
    %6 = polar plot
    %7 = bar 2D plot
    %8 = line plot
    %9 = bar 3D plot
      case 1
        disp('Finished plotting series of relative contour spectra ...');
      case 2
        disp('Finished plotting series of absolute contour spectra ...');
      case 3
        disp('Finished plotting series of mesh/surface spectra ...');
      case 4
        disp('Finished plotting series of stack 3D spectra ...');
      case 5
        disp('Finished plotting series of raster 2D spectra ...');
      case 6
        disp('Finished plotting series of polar plots ...');
      case 7
        disp('Finished plotting series of bar spectra ...');
      case 8
        disp('Finished plotting series of line spectra ...');
      case 9
        disp('Finished plotting series of 3D bar spectra ...');
    end
  
  else
    disp('Plotting of series of spectra was cancelled ...');
  end  
  
  clear QTEMP* QSeries*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
