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
%regelplotcutspectrum.m takes care of plotting a cut spectrum into a number of subplots
%type specified by QmatNMR.Q2D3DPlotType
%07-03-'08

try
  if QmatNMR.buttonList == 1

    %
    %Check out the axes and change the spectrum accordingly
    %
    CheckAxisCont


    %
    %First determine the number of parts into which the spectrum was cut
    %
    QmatNMR.CutLinesTD2 = find(isnan(QmatNMR.Spec2D3D(1, :)));
    QmatNMR.CutLinesTD1 = find(isnan(QmatNMR.Spec2D3D(:, 1))).';


    %
    %Create subplots based on the number of parts determined above
    %
    QmatNMR.CutNrPlotsX = length(QmatNMR.CutLinesTD2)+1; 		%number of spectra in X direction
    QmatNMR.CutNrPlotsY = length(QmatNMR.CutLinesTD1)+1; 		%number of spectra in Y direction
    QmatNMR.CutAxisSpaceX = 0.9 / QmatNMR.CutNrPlotsX; 		%space alocated for each axis (including space between axes) in X direction
    QmatNMR.CutAxisSpaceY = 0.9 / QmatNMR.CutNrPlotsY; 		%space alocated for each axis (including space between axes) in Y direction
    QmatNMR.CutAxisWidthX = 0.97 * QmatNMR.CutAxisSpaceX;         %space alocated for each axis (excluding space between axes) in X direction
    QmatNMR.CutAxisWidthY = 0.97 * QmatNMR.CutAxisSpaceY;         %space alocated for each axis (excluding space between axes) in Y direction
    QmatNMR.CutOffsetX = 0.07; 					%offset in X direction
    QmatNMR.CutOffsetY = 0.95 - QmatNMR.CutAxisSpaceY; 		%offset in Y direction


    QmatNMR.CutSubplotValues = [QmatNMR.CutNrPlotsX QmatNMR.CutOffsetX QmatNMR.CutAxisWidthX QmatNMR.CutAxisSpaceX QmatNMR.CutNrPlotsY QmatNMR.CutOffsetY QmatNMR.CutAxisWidthY QmatNMR.CutAxisSpaceY];
    QmatNMR.ContSubplots = [99 QmatNMR.CutSubplotValues]; 	%user-defined grid of subplots
    %
    %select window from which the new subplot configuration was chosen
    %
    findcurrentfigure


    %
    %remember the current colour map
    %
    QTEMP43 = get(QmatNMR.Fig2D3D, 'colormap');
    QTEMP44 = QmatNMR.CurrentColorMap;


    %
    %Create the new subplot configuration
    %
    Subplots(QmatNMR.Fig2D3D, QmatNMR.ContSubplots(1), QmatNMR.CutSubplotValues)


    %
    %Set the colour map in the new window the same as in the previous window
    %
    set(QmatNMR.Fig2D3D, 'colormap', QTEMP43);
    QmatNMR.CurrentColorMap = QTEMP44;
    QTEMP2 = get(gcf, 'userdata');
    QTEMP2.ColorMap = QTEMP44;


    %
    %Set the colour map in the new window the same as in the previous window
    %
    set(gcf, 'userdata', QTEMP2);


    %
    %Define the indices into the matrix for each subplot
    %
    QTEMP3 = size(QmatNMR.Spec2D3D);
    QTEMP4 = [0 QmatNMR.CutLinesTD2 QTEMP3(2)+1];
    QTEMP5 = [0 QmatNMR.CutLinesTD1 QTEMP3(1)+1];
    QTEMP8 = 0;


    QmatNMR.CutIndicesTD2 = zeros(QmatNMR.CutNrPlotsX*QmatNMR.CutNrPlotsY, 2);
    QmatNMR.CutIndicesTD1 = zeros(QmatNMR.CutNrPlotsX*QmatNMR.CutNrPlotsY, 2);

    %
    %The direction of putting the subspectra into the subplots
    %
    QTEMP9 = QmatNMR.CutNrPlotsX:-1:1;
    QTEMP10 = 1:QmatNMR.CutNrPlotsY;

    for QTEMP6 = QTEMP10
      for QTEMP7 = QTEMP9
        QTEMP8 = QTEMP8 + 1;

        QmatNMR.CutIndicesTD2(QTEMP8, :) = [(QTEMP4(QTEMP7)+1) (QTEMP4(QTEMP7+1)-1)];
        QmatNMR.CutIndicesTD1(QTEMP8, :) = [(QTEMP5(QTEMP6)+1) (QTEMP5(QTEMP6+1)-1)];
      end
    end


    %
    %plot-type specific actions
    %
    QmatNMR.TEMPACTION = 0;
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
        %
        %in case of a relative contour plot we change the plot type to absolute contours because otherwise
        %we cannot garantuee that all subsplots have the same contour levels.
        %
        calccontlevels

        %
        %remember the last setting for the type of contours so we can reset this afterwards
        %
        QmatNMR.TEMPACTION = QmatNMR.negcont;

        QmatNMR.Q2D3DPlotType = 2;
        QmatNMR.Contourlast = [];
        for QTEMP6 = 1:length(QmatNMR.ContourLevels)
          QmatNMR.Contourlast = [QmatNMR.Contourlast '  ' num2str(QmatNMR.ContourLevels(QTEMP6), 10)];
        end
    end


    %
    %plot all spectra
    %
    QSeriesName = QmatNMR.uiInput1;
    QSeriesSpec = QmatNMR.Spec2D3D;
    QmatNMR.SpecName2D3D = QSeriesName;
    for QSeriesCounter = 1:QmatNMR.CutNrPlotsX*QmatNMR.CutNrPlotsY
      %axes(findobj(QmatNMR.Fig2D3D, 'type', 'axes', 'userdata', QSeriesSubPlotNR + QSeriesCounter - 1));       %go to the subplot
      set(QmatNMR.Fig2D3D, 'currentaxes', findobj(QmatNMR.Fig2D3D, 'type', 'axes', 'userdata', QSeriesCounter)); %go to the subplot
      set(QmatNMR.Fig2D3D, 'selectiontype', 'normal');  %pretend the last mouse button pressed was the left one (bug fix 24-09-'04 related to context menus)
      SelectAxis;

      QmatNMR.uiInput1 = ['QSeriesSpec(' num2str(QmatNMR.CutIndicesTD1(QSeriesCounter, 1)) ':' num2str(QmatNMR.CutIndicesTD1(QSeriesCounter, 2)) ',' num2str(QmatNMR.CutIndicesTD2(QSeriesCounter, 1)) ':' num2str(QmatNMR.CutIndicesTD2(QSeriesCounter, 2)) ')'];   %define the 2D spectrum

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

          QmatNMR.uiInput7 = [QSeriesName '.AxisTD2(' num2str(QmatNMR.CutIndicesTD2(QSeriesCounter, 1)) ':' num2str(QmatNMR.CutIndicesTD2(QSeriesCounter, 2)) ')'];
          QmatNMR.uiInput8 = [QSeriesName '.AxisTD1(' num2str(QmatNMR.CutIndicesTD1(QSeriesCounter, 1)) ':' num2str(QmatNMR.CutIndicesTD1(QSeriesCounter, 2)) ')'];

          QmatNMR.uiInput9 = QmatNMR.ContourLineSpec;
          QmatNMR.uiInput10 = QmatNMR.Q2D3DMacro;

          regelcont






        case 2
          QmatNMR.uiInput2 = QmatNMR.Contourlast;
          QmatNMR.uiInput3 = [QSeriesName '.AxisTD2(' num2str(QmatNMR.CutIndicesTD2(QSeriesCounter, 1)) ':' num2str(QmatNMR.CutIndicesTD2(QSeriesCounter, 2)) ')'];
          QmatNMR.uiInput4 = [QSeriesName '.AxisTD1(' num2str(QmatNMR.CutIndicesTD1(QSeriesCounter, 1)) ':' num2str(QmatNMR.CutIndicesTD1(QSeriesCounter, 2)) ')'];
          QmatNMR.uiInput5 = QmatNMR.ContourLineSpec;
          QmatNMR.uiInput6 = QmatNMR.Q2D3DMacro;

          regelabscont


        case 3
          QmatNMR.uiInput2 = num2str(QmatNMR.az);
          QmatNMR.uiInput3 = num2str(QmatNMR.el);
          QmatNMR.uiInput4 = [QSeriesName '.AxisTD2(' num2str(QmatNMR.CutIndicesTD2(QSeriesCounter, 1)) ':' num2str(QmatNMR.CutIndicesTD2(QSeriesCounter, 2)) ')'];
          QmatNMR.uiInput5 = [QSeriesName '.AxisTD1(' num2str(QmatNMR.CutIndicesTD1(QSeriesCounter, 1)) ':' num2str(QmatNMR.CutIndicesTD1(QSeriesCounter, 2)) ')'];
          if (get(QmatNMR.MM29, 'value') == 6)  %in case of a surface lightning ask for orientation
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
          QmatNMR.uiInput5 = [QSeriesName '.AxisTD2(' num2str(QmatNMR.CutIndicesTD2(QSeriesCounter, 1)) ':' num2str(QmatNMR.CutIndicesTD2(QSeriesCounter, 2)) ')'];
          QmatNMR.uiInput6 = [QSeriesName '.AxisTD1(' num2str(QmatNMR.CutIndicesTD1(QSeriesCounter, 1)) ':' num2str(QmatNMR.CutIndicesTD1(QSeriesCounter, 2)) ')'];
          QmatNMR.uiInput7 = QmatNMR.Q2D3DMacro;

          regelstack3D

        case 5
          QmatNMR.uiInput2 = num2str(QmatNMR.RasterSamplingFactor);
          QmatNMR.uiInput3 = [QSeriesName '.AxisTD2(' num2str(QmatNMR.CutIndicesTD2(QSeriesCounter, 1)) ':' num2str(QmatNMR.CutIndicesTD2(QSeriesCounter, 2)) ')'];
          QmatNMR.uiInput4 = [QSeriesName '.AxisTD1(' num2str(QmatNMR.CutIndicesTD1(QSeriesCounter, 1)) ':' num2str(QmatNMR.CutIndicesTD1(QSeriesCounter, 2)) ')'];
          QmatNMR.uiInput5 = QmatNMR.Q2D3DMacro;

          regelraster2D

        case 6
          %
          %nothing defined as it wouldn't make much sense for this plot type. MatNMR will plot the cut spectrum as if
          %it were a normal dataset.
          %

        case 7
          %
          %nothing defined as it wouldn't make much sense for this plot type. MatNMR will plot the cut spectrum as if
          %it were a normal dataset.
          %

        case 8
          %
          %nothing defined as it wouldn't make much sense for this plot type. MatNMR will plot the cut spectrum as if
          %it were a normal dataset.
          %

        case 9
          QmatNMR.uiInput2 = num2str(QmatNMR.az);
          QmatNMR.uiInput3 = num2str(QmatNMR.el);
          QmatNMR.uiInput4 = QmatNMR.Bar3DType;
          QmatNMR.uiInput5 = [QSeriesName '.AxisTD2(' num2str(QmatNMR.CutIndicesTD2(QSeriesCounter, 1)) ':' num2str(QmatNMR.CutIndicesTD2(QSeriesCounter, 2)) ')'];
          QmatNMR.uiInput6 = [QSeriesName '.AxisTD1(' num2str(QmatNMR.CutIndicesTD1(QSeriesCounter, 1)) ':' num2str(QmatNMR.CutIndicesTD1(QSeriesCounter, 2)) ')'];
          QmatNMR.uiInput7 = QmatNMR.Q2D3DMacro;

          regelpcolor3d
      end

      %
      %In case we have many subplots we automatically restrict some things like axis labels etc
      %
      correctforsubplots
    end




    %
    %reset the variable name and the axis names to their originals
    %
    QmatNMR.SpecName2D3D = QSeriesName;
    QmatNMR.UserDefAxisT2Cont = '';
    QmatNMR.UserDefAxisT1Cont = '';

    %
    %create a super title with the current variable name
    %
    QmatNMR.uiInput1 = strrep(QmatNMR.SpecName2D3D, '_', '\_');
    QmatNMR.uiInput2 = '16';
    QmatNMR.uiInput3 = '0';
    QmatNMR.buttonList = 1;
    regelsupertitle

    %
    %remove tick labels (not tick marks), axis labels and titles on all but the outer axes
    %
    for QTEMP2 = 1:(QmatNMR.CutNrPlotsY-1)
      for QTEMP1 = 1
        %select the axis
        QTEMP3 = findobj(allchild(gcf), 'userdata', (QTEMP2-1)*QmatNMR.CutNrPlotsX + QTEMP1);
        set(QmatNMR.Fig2D3D, 'currentaxes', QTEMP3);
        if ~isempty(QmatNMR.Spec2D3DCutData.CutSpectrumTicksTD2)
          set(QTEMP3, 'xtick', QmatNMR.Spec2D3DCutData.CutSpectrumTicksTD2)
        end
        if ~isempty(QmatNMR.Spec2D3DCutData.CutSpectrumTicksTD1)
          set(QTEMP3, 'ytick', QmatNMR.Spec2D3DCutData.CutSpectrumTicksTD1)
        end

        %delete the title, axis labels and tick labels
        title('');
        xlabel('');
        zlabel('');
        set(QTEMP3, 'yticklabelmode', 'auto', 'xticklabel', '');
      end

      for QTEMP1 = 2:QmatNMR.CutNrPlotsX
        %select the axis
        QTEMP3 = findobj(allchild(gcf), 'userdata', (QTEMP2-1)*QmatNMR.CutNrPlotsX + QTEMP1);
        set(QmatNMR.Fig2D3D, 'currentaxes', QTEMP3);
        if ~isempty(QmatNMR.Spec2D3DCutData.CutSpectrumTicksTD2)
          set(QTEMP3, 'xtick', QmatNMR.Spec2D3DCutData.CutSpectrumTicksTD2)
        end
        if ~isempty(QmatNMR.Spec2D3DCutData.CutSpectrumTicksTD1)
          set(QTEMP3, 'ytick', QmatNMR.Spec2D3DCutData.CutSpectrumTicksTD1)
        end

        %delete the title, axis labels and tick labels
        title('');
        xlabel('');
        ylabel('');
        zlabel('');
        set(QTEMP3, 'xticklabel', '', 'yticklabel', '');
      end
    end

    for QTEMP2 = QmatNMR.CutNrPlotsY
      for QTEMP1 = 1
        %select the axis
        QTEMP3 = findobj(allchild(gcf), 'userdata', (QTEMP2-1)*QmatNMR.CutNrPlotsX + QTEMP1);
        set(QmatNMR.Fig2D3D, 'currentaxes', QTEMP3);
        if ~isempty(QmatNMR.Spec2D3DCutData.CutSpectrumTicksTD2)
          set(QTEMP3, 'xtick', QmatNMR.Spec2D3DCutData.CutSpectrumTicksTD2)
        end
        if ~isempty(QmatNMR.Spec2D3DCutData.CutSpectrumTicksTD1)
          set(QTEMP3, 'ytick', QmatNMR.Spec2D3DCutData.CutSpectrumTicksTD1)
        end

        %delete the title, axis labels and tick labels
        title('');
        zlabel('');
      end

      for QTEMP1 = 2:QmatNMR.CutNrPlotsX
        %select the axis
        QTEMP3 = findobj(allchild(gcf), 'userdata', (QTEMP2-1)*QmatNMR.CutNrPlotsX + QTEMP1);
        set(QmatNMR.Fig2D3D, 'currentaxes', QTEMP3);
        if ~isempty(QmatNMR.Spec2D3DCutData.CutSpectrumTicksTD2)
          set(QTEMP3, 'xtick', QmatNMR.Spec2D3DCutData.CutSpectrumTicksTD2)
        end
        if ~isempty(QmatNMR.Spec2D3DCutData.CutSpectrumTicksTD1)
          set(QTEMP3, 'ytick', QmatNMR.Spec2D3DCutData.CutSpectrumTicksTD1)
        end

        %delete the title, axis labels and tick labels
        title('');
        ylabel('');
        zlabel('');
        set(QTEMP3, 'yticklabel', '');
      end
    end




    %
    %set the same color axis for all subplots
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
        %
        %set color axis
        %
        QTEMP2 = min(QmatNMR.ContourLevels);
        QTEMP3 = max(QmatNMR.ContourLevels);
        if (QmatNMR.negcont==3)     %for positive and negative contours to their respective maxima
          QTEMP2 = QmatNMR.specmin;
          QTEMP3 = QmatNMR.specmax;
        end

        QmatNMR.buttonList = 1; 			%manual setting of color axis
        QmatNMR.uiInput1 = num2str(QTEMP2); 	%lower limit
        QmatNMR.uiInput1a = 1;
        QmatNMR.uiInput2 = num2str(QTEMP3); 	%upper limit
        QmatNMR.uiInput2a = 2;
        QmatNMR.uiInput3 = 2; 			%apply to all axes
        regelcaxis

      case 2
        %
        %set color axis
        %
        QTEMP2 = min(QmatNMR.ContourLevels);
        QTEMP3 = max(QmatNMR.ContourLevels);
        if (QmatNMR.negcont==3)     %for positive and negative contours to their respective maxima
          QTEMP2 = QmatNMR.specmin;
          QTEMP3 = QmatNMR.specmax;
        end

        QmatNMR.buttonList = 1; 			%manual setting of color axis
        QmatNMR.uiInput1 = num2str(QTEMP2); 	%lower limit
        QmatNMR.uiInput1a = 1;
        QmatNMR.uiInput2 = num2str(QTEMP3); 	%upper limit
        QmatNMR.uiInput2a = 2;
        QmatNMR.uiInput3 = 2; 			%apply to all axes
        regelcaxis

      case 3
        %
        %set color axis
        %
        eval(['QTEMP2 = min(min(' QmatNMR.meshdisplay '(QSeriesSpec)));']);
        eval(['QTEMP3 = max(max(' QmatNMR.meshdisplay '(QSeriesSpec)));']);

        QmatNMR.buttonList = 1; 			%manual setting of color axis
        QmatNMR.uiInput1 = num2str(QTEMP2); 	%lower limit
        QmatNMR.uiInput1a = 1;
        QmatNMR.uiInput2 = num2str(QTEMP3); 	%upper limit
        QmatNMR.uiInput2a = 2;
        QmatNMR.uiInput3 = 2; 			%apply to all axes
        regelcaxis

        %
        %set z-limits
        %
        eval(['QTEMP2 = min(min(' QmatNMR.meshdisplay '(QSeriesSpec)));']);
        eval(['QTEMP3 = max(max(' QmatNMR.meshdisplay '(QSeriesSpec)));']);

        QmatNMR.buttonList = 1; 			%manual setting of color axis
        QmatNMR.uiInput1 = '0 0';
        QmatNMR.uiInput1a = 0; 			%no change in x limits
        QmatNMR.uiInput2 = '0 0';
        QmatNMR.uiInput2a = 0; 			%no change in y limits
        QmatNMR.uiInput3 = [num2str(QTEMP2, 10) ' ' num2str(QTEMP3)];
        QmatNMR.uiInput3a = 1;	 		%change z limits
        QmatNMR.uiInput4 = 2; 			%apply to all axes
        regellims

      case 4
        %
        %set color axis
        %
        eval(['QTEMP2 = min(min(' QmatNMR.stackdisplay '(QSeriesSpec)));']);
        eval(['QTEMP3 = max(max(' QmatNMR.stackdisplay '(QSeriesSpec)));']);

        QmatNMR.buttonList = 1; 			%manual setting of color axis
        QmatNMR.uiInput1 = '0 0';
        QmatNMR.uiInput1a = 0; 			%no change in x limits
        QmatNMR.uiInput2 = '0 0';
        QmatNMR.uiInput2a = 0; 			%no change in y limits
        QmatNMR.uiInput3 = [num2str(QTEMP2, 10) ' ' num2str(QTEMP3)];
        QmatNMR.uiInput3a = 1;	 		%change z limits
        QmatNMR.uiInput4 = 2; 			%apply to all axes
        regellims

      case 5
        %
        %set color axis
        %
        eval(['QTEMP2 = min(min(' QmatNMR.rasterdisplay '(QSeriesSpec)));']);
        eval(['QTEMP3 = max(max(' QmatNMR.rasterdisplay '(QSeriesSpec)));']);

        QmatNMR.buttonList = 1; 			%manual setting of color axis
        QmatNMR.uiInput1 = num2str(QTEMP2); 	%lower limit
        QmatNMR.uiInput1a = 1;
        QmatNMR.uiInput2 = num2str(QTEMP3); 	%upper limit
        QmatNMR.uiInput2a = 1;
        QmatNMR.uiInput3 = 2; 			%apply to all axes
        regelcaxis

        %
        %set z-limits
        %
        eval(['QTEMP2 = min(min(' QmatNMR.meshdisplay '(QSeriesSpec)));']);
        eval(['QTEMP3 = max(max(' QmatNMR.meshdisplay '(QSeriesSpec)));']);

        QmatNMR.buttonList = 1; 			%manual setting of color axis
        QmatNMR.uiInput1 = '0 0';
        QmatNMR.uiInput1a = 0; 			%no change in x limits
        QmatNMR.uiInput2 = '0 0';
        QmatNMR.uiInput2a = 0; 			%no change in y limits
        QmatNMR.uiInput3 = [num2str(QTEMP2, 10) ' ' num2str(QTEMP3)];
        QmatNMR.uiInput3a = 1;	 		%change z limits
        QmatNMR.uiInput4 = 2; 			%apply to all axes
        regellims

      case 9
        %
        %set color axis
        %
        eval(['QTEMP2 = min(min(' QmatNMR.meshdisplay '(QSeriesSpec)));']);
        eval(['QTEMP3 = max(max(' QmatNMR.meshdisplay '(QSeriesSpec)));']);

        QmatNMR.buttonList = 1; 			%manual setting of color axis
        QmatNMR.uiInput1 = num2str(QTEMP2); 	%lower limit
        QmatNMR.uiInput1a = 1;
        QmatNMR.uiInput2 = num2str(QTEMP3); 	%upper limit
        QmatNMR.uiInput2a = 2;
        QmatNMR.uiInput3 = 2; 			%apply to all axes
        regelcaxis

        %
        %set z-limits
        %
        eval(['QTEMP2 = min(min(' QmatNMR.meshdisplay '(QSeriesSpec)));']);
        eval(['QTEMP3 = max(max(' QmatNMR.meshdisplay '(QSeriesSpec)));']);

        QmatNMR.buttonList = 1; 			%manual setting of color axis
        QmatNMR.uiInput1 = '0 0';
        QmatNMR.uiInput1a = 0; 			%no change in x limits
        QmatNMR.uiInput2 = '0 0';
        QmatNMR.uiInput2a = 0; 			%no change in y limits
        QmatNMR.uiInput3 = [num2str(QTEMP2, 10) ' ' num2str(QTEMP3)];
        QmatNMR.uiInput3a = 1;	 		%change z limits
        QmatNMR.uiInput4 = 2; 			%apply to all axes
        regellims

        %
        %set the axis direction to reverse. By default the pcolor3d routine leaves it as normal
        %
        QmatNMR.buttonList = 1; 			%manual setting of color axis
        QmatNMR.uiInput1 = 2;
        QmatNMR.uiInput1a = 1; 			%change x direction to reverse
        QmatNMR.uiInput2 = 2;
        QmatNMR.uiInput2a = 1; 			%change y direction to reverse
        QmatNMR.uiInput3 = 1; 			%
        QmatNMR.uiInput3a = 1;	 		%change z direction to normal
        QmatNMR.uiInput4 = 2; 			%apply to all axes
        regeldirs
    end


  %
  %In case relative contours were asked for we want to reset the type of contours now
  %
    if (QmatNMR.TEMPACTION)
      QmatNMR.negcont = QmatNMR.TEMPACTION;
      QmatNMR = rmfield(QmatNMR, 'TEMPACTION');
    end


  %
  %Finish off
  %
    clear QTEMP*
    QmatNMR.Q2D3DPlottingSeries = 0;

    disp('Finished cut spectrum ...');
  else
    disp('Plotting of cut spectrum was cancelled ...');
  end

  clear QTEMP* QSeries*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
