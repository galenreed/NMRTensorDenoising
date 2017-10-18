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
%regelCPMs finishes the making of a CPM (conditional probability matrix) from a selected spectral region
%
%12-05-'06

try
  if (QmatNMR.buttonList == 1)			%= OK-button
  %
  %process the input parameters
  %
    QTEMP2 = findstr(QmatNMR.uiInput1, ',');
  
  					%
  					%re-Check the range that was given as input
  					%
    QTEMP3 = sort([QTEMP2 findstr(QmatNMR.uiInput1, ':')]);
    QTEMP4 = [str2num(QmatNMR.uiInput1(1:(QTEMP3(1)-1))) str2num(QmatNMR.uiInput1((QTEMP3(1)+1):(QTEMP3(2)-1))) str2num(QmatNMR.uiInput1((QTEMP3(2)+1):(QTEMP3(3)-1))) str2num(QmatNMR.uiInput1((QTEMP3(3)+1):(length(QmatNMR.uiInput1))))];
    QTEMP4 = [sort(QTEMP4(1:2)); sort(QTEMP4(3:4))];
  
  				%Now determine the position in points
    QTEMP = get(QmatNMR.Fig2D3D, 'userdata');		%extract the userdata from the figure window
  					       	%read offset and slope of the axes vectors in the plot
    QmatNMR.AxisData = QTEMP.PlotParams(QmatNMR.AxisNR2D3D).AxisProps;
  
    if ~ isempty(QmatNMR.AxisData)		      %when the user has plotted some spectrum himself
  					      %into the contour window then probably the axes information
          				      %will not have been written into the userdata property.
          				      %Then this could give errors ...
      %
      %first determine the coordinate in points. The method depends on whether the axis
      %was linear or non-linear.
      %
      if (QmatNMR.AxisData(1))	      %linear axis in TD2 -> use axis increment and offset values
        QmatNMR.X = sort(round((QTEMP4(2, 1:2)-QmatNMR.AxisData(2)) ./ QmatNMR.AxisData(1)));
      else
  			      %non-linear axis -> use the minimum distance to the next point in the axis vector
        QTEMP7 = QTEMP.PlotParams(QmatNMR.AxisNR2D3D).AxisTD2;
        [QmatNMR.X QTEMP8] = min(abs(QTEMP7 - QTEMP4(2, 1)));
        [QmatNMR.X QTEMP9] = min(abs(QTEMP7 - QTEMP4(2, 2)));
        QmatNMR.X = [QTEMP8 QTEMP9];
      end
      
      if (QmatNMR.AxisData(3))	      %linear axis in TD1 -> use axis increment and offset values
        QmatNMR.Y = sort(round((QTEMP4(1, 1:2)-QmatNMR.AxisData(4)) ./ QmatNMR.AxisData(3)));
      else
  			      %non-linear axis -> use the minimum distance to the next point in the axis vector
        QTEMP7 = QTEMP.PlotParams(QmatNMR.AxisNR2D3D).AxisTD1;
        [QmatNMR.Y QTEMP8] = min(abs(QTEMP7 - QTEMP4(1, 1)));
        [QmatNMR.Y QTEMP9] = min(abs(QTEMP7 - QTEMP4(1, 2)));
        QmatNMR.Y = [QTEMP8 QTEMP9];
      end
  
  				%Check whether the coordinates are within the matrix bounds
      QmatNMR.tmp2 = QTEMP.PlotParams(QmatNMR.AxisNR2D3D).SizeTD2;
      QmatNMR.tmp1 = QTEMP.PlotParams(QmatNMR.AxisNR2D3D).SizeTD1;
      if (QmatNMR.X(1) < 1); QmatNMR.X(1)=1; end
      if (QmatNMR.X(2) > max(QmatNMR.tmp2)); QmatNMR.X(2)=max(QmatNMR.tmp2); end
      if (QmatNMR.Y(1) < 1); QmatNMR.Y(1)=1; end
      if (QmatNMR.Y(2) > max(QmatNMR.tmp1)); QmatNMR.Y(2)=max(QmatNMR.tmp1); end
  
  				%Put the final coordinates back in the input string.
  				%
  				%QmatNMR.uiInput1 gives the coordinates in points of the matrix
  				%QTEMP5 gives the coordinates in the value of their original axis --> the user gives
  				%	these numbers as I think the user isn't interested in QmatNMR.uiInput1 if he/she wants to
  				%	select a certain area of the spectrum in PPM.
  				%	QTEMP5 is therefore shown in the History and QmatNMR.uiInput1 is used by matNMR
  				%
      QmatNMR.uiInput1 = [num2str(QmatNMR.Y(1)) ':' num2str(QmatNMR.Y(2)) ', ' num2str(QmatNMR.X(1)) ':' num2str(QmatNMR.X(2))];
  
  %
  %calculate the CPMs and plot them in a new window
  %
      %the selected region of the spectrum
      QmatNMR.CPMTEMP1 = real(QmatNMR.Spec2D3D(QmatNMR.Y(1):QmatNMR.Y(2), QmatNMR.X(1):QmatNMR.X(2)));
      [QmatNMR.tmp1, QmatNMR.tmp2] = size(QmatNMR.CPMTEMP1);
      
      %apply the detection threshold
      QmatNMR.CPMTEMP1(find(QmatNMR.CPMTEMP1 < QmatNMR.CPMthreshold/100*real(max(max(QmatNMR.Spec2D3D))))) = 0;
      
      %add a tiny constant to the matrix to improve the numerical stability of the CPM calculation
      QmatNMR.CPMTEMP1 = QmatNMR.CPMTEMP1 + 0.001*max(max(QmatNMR.CPMTEMP1));
      
      %
      %given this tiny constant there is a minimum threshold for the contour levels for the CPM plots.
      %which is given by the 1/the size of the dimension by which is normalized. Even if the user wants
      %a level lower than this threshold, it will not be done
      %
      QmatNMR.CPMmin1 = (1 / QmatNMR.tmp1) / max(max(QmatNMR.CPM1))*100 + 0.1;
      if (QmatNMR.CPMmin1 < QmatNMR.CPMmin)
        QmatNMR.CPMmin1 = QmatNMR.CPMmin;
      end
      QmatNMR.CPMmin2 = (1 / QmatNMR.tmp2) / max(max(QmatNMR.CPM2))*100 + 0.1;
      if (QmatNMR.CPMmin2 < QmatNMR.CPMmin)
        QmatNMR.CPMmin2 = QmatNMR.CPMmin;
      end
  
    
      %the projections onto the axes
      QmatNMR.sumTD2 = sum(QmatNMR.CPMTEMP1, 1);
      QmatNMR.sumTD1 = sum(QmatNMR.CPMTEMP1, 2);
      %As we'll divide by the projections we're sensitive to small intensities.
      %Therefore we'll set all intensities below a certain threshold to 1
      QmatNMR.sumTD2CPM = QmatNMR.sumTD2;
      QmatNMR.sumTD1CPM = QmatNMR.sumTD1;
      QmatNMR.sumTD2CPM(find(QmatNMR.sumTD2 < max(QmatNMR.sumTD2)/200)) = 1;
      QmatNMR.sumTD1CPM(find(QmatNMR.sumTD1 < max(QmatNMR.sumTD1)/200)) = 1;
  
      %the CPMs
      QmatNMR.CPM1 = zeros(QmatNMR.tmp1, QmatNMR.tmp2);
      QmatNMR.CPM2 = zeros(QmatNMR.tmp1, QmatNMR.tmp2);
      QmatNMR.CPM3 = zeros(QmatNMR.tmp1, QmatNMR.tmp2);
      for QTEMP2 = 1:QmatNMR.tmp2
        QmatNMR.CPM1(:, QTEMP2) = QmatNMR.CPMTEMP1(:, QTEMP2) / QmatNMR.sumTD2CPM(QTEMP2);
      end
      for QTEMP2 = 1:QmatNMR.tmp1
        QmatNMR.CPM2(QTEMP2, :) = QmatNMR.CPMTEMP1(QTEMP2, :) / QmatNMR.sumTD1CPM(QTEMP2);
      end
  
   
      QmatNMR.sumCPM1= sum(QmatNMR.CPM1, 2);
      for QTEMP2 = 1:QmatNMR.tmp1
        QmatNMR.CPM3(QTEMP2, :) = QmatNMR.CPM1(QTEMP2, :) / QmatNMR.sumCPM1(QTEMP2);
      end
      QmatNMR.CPM3 = QmatNMR.CPM3 / max(max(QmatNMR.CPM3));
    
      %the corresponding axis vectors
      QmatNMR.CPMvec1 = QmatNMR.Axis2D3DTD2(QmatNMR.X(1):QmatNMR.X(2));    %along TD2
      QmatNMR.CPMvec2 = QmatNMR.Axis2D3DTD1(QmatNMR.Y(1):QmatNMR.Y(2));    %along TD1
    
      %deal with ascending or descending axes
      CheckAxisCPMs
    
    
      %
      %Finally plot the CPMs and axis projections in a new 2D/3D viewer window
      %
      %remember current figure window and axis and also its axis directions
      QmatNMR.CPMTEMP2 = QmatNMR.Fig2D3D;
      QmatNMR.CPMTEMP3 = QmatNMR.AxisHandle2D3D;
      
      %make new window with 3x2 subplots
      QmatNMR.ContSubplots = 8;
      makenew2D3D
      QTEMPPOS = get(QmatNMR.Fig2D3D, 'position');
      set(QmatNMR.Fig2D3D, 'position', [0 QTEMPPOS(2:4)]);
      QmatNMR.CPMTEMP4 = get(QmatNMR.Fig2D3D, 'userdata');
      QmatNMR.CPMTEMP4.Zoom = 0;          %switch off the zoom functionality
      ZoomMatNMR 2D3DViewer off
      QmatNMR.CPMTEMP4.Rotate3D = 0;      %switch off the rotate 3D functionality
      Rotate3DmatNMR off
    
      %define the axis increments and offsets for TD2 and TD1 respectively
      QTEMP2 = [(QmatNMR.CPMvec1(2)-QmatNMR.CPMvec1(1)) (2*QmatNMR.CPMvec1(1)-QmatNMR.CPMvec1(2))];
      QTEMP3 = [(QmatNMR.CPMvec2(2)-QmatNMR.CPMvec2(1)) (2*QmatNMR.CPMvec2(1)-QmatNMR.CPMvec2(2))];
      %now-check whether the axes are linear, if not set the axis increment to 0 and put the entire vector into the userdata
      if LinearAxis(QmatNMR.CPMvec1)
        QmatNMR.CPMTEMP4.PlotParams(1).AxisTD2 = [];              %linear axis -> clear variable
        QmatNMR.CPMTEMP4.PlotParams(3).AxisTD2 = [];              %linear axis -> clear variable
        QmatNMR.CPMTEMP4.PlotParams(5).AxisTD2 = [];              %linear axis -> clear variable
        QmatNMR.CPMTEMP4.PlotParams(6).AxisTD2 = [];              %linear axis -> clear variable
      else
    
        QmatNMR.CPMTEMP4.PlotParams(1).AxisTD2 = QmatNMR.CPMvec1;
        QmatNMR.CPMTEMP4.PlotParams(3).AxisTD2 = QmatNMR.CPMvec1;
        QmatNMR.CPMTEMP4.PlotParams(5).AxisTD2 = QmatNMR.CPMvec1;
        QmatNMR.CPMTEMP4.PlotParams(6).AxisTD2 = QmatNMR.CPMvec1;
      end  
      if LinearAxis(QmatNMR.CPMvec2)
        QmatNMR.CPMTEMP4.PlotParams(1).AxisTD1 = [];              %linear axis -> clear variable
        QmatNMR.CPMTEMP4.PlotParams(4).AxisTD2 = [];              %linear axis -> clear variable
        QmatNMR.CPMTEMP4.PlotParams(5).AxisTD1 = [];              %linear axis -> clear variable
        QmatNMR.CPMTEMP4.PlotParams(6).AxisTD1 = [];              %linear axis -> clear variable
      else
    
        QmatNMR.CPMTEMP4.PlotParams(1).AxisTD1 = QmatNMR.CPMvec2;
        QmatNMR.CPMTEMP4.PlotParams(4).AxisTD2 = QmatNMR.CPMvec2;
        QmatNMR.CPMTEMP4.PlotParams(5).AxisTD1 = QmatNMR.CPMvec2;
        QmatNMR.CPMTEMP4.PlotParams(6).AxisTD1 = QmatNMR.CPMvec2;
      end  
      QmatNMR.CPMTEMP4.PlotParams(1).AxisProps = [QTEMP2 QTEMP3];
      QmatNMR.CPMTEMP4.PlotParams(3).AxisProps = [QTEMP2 0 1];
      QmatNMR.CPMTEMP4.PlotParams(4).AxisProps = [QTEMP3 0 1];
      QmatNMR.CPMTEMP4.PlotParams(5).AxisProps = [QTEMP2 QTEMP3];
      QmatNMR.CPMTEMP4.PlotParams(6).AxisProps = [QTEMP2 QTEMP3];
    
      %define the axis vectors for all plots in the userdata
      QmatNMR.CPMTEMP4.PlotParams(1).AnalyserAxisTD2 = QmatNMR.CPMvec1;
      QmatNMR.CPMTEMP4.PlotParams(1).AnalyserAxisTD1 = QmatNMR.CPMvec2;
      QmatNMR.CPMTEMP4.PlotParams(3).AnalyserAxisTD2 = QmatNMR.CPMvec1;
      QmatNMR.CPMTEMP4.PlotParams(4).AnalyserAxisTD2 = QmatNMR.CPMvec2;
      QmatNMR.CPMTEMP4.PlotParams(5).AnalyserAxisTD2 = QmatNMR.CPMvec1;
      QmatNMR.CPMTEMP4.PlotParams(5).AnalyserAxisTD1 = QmatNMR.CPMvec2;
      QmatNMR.CPMTEMP4.PlotParams(6).AnalyserAxisTD2 = QmatNMR.CPMvec1;
      QmatNMR.CPMTEMP4.PlotParams(6).AnalyserAxisTD1 = QmatNMR.CPMvec2;
      set(QmatNMR.Fig2D3D, 'userdata', QmatNMR.CPMTEMP4);
    
    
    
      %in the top left axis we plot the region of interest as a contour plot
      if (QmatNMR.CPMfilledcontours == 0)	%plot normal contours
        contour(QmatNMR.CPMvec1Plot, QmatNMR.CPMvec2Plot, QmatNMR.CPMTEMP1Plot, 20);
      else
        if (QmatNMR.MatlabVersion >= 7.0)
          contourf('v6', QmatNMR.CPMvec1Plot, QmatNMR.CPMvec2Plot, QmatNMR.CPMTEMP1Plot, 20);
        else
          contourf(QmatNMR.CPMvec1Plot, QmatNMR.CPMvec2Plot, QmatNMR.CPMTEMP1Plot, 20);
        end
      end
      axis([sort(QmatNMR.CPMvec1([1 end])) sort(QmatNMR.CPMvec2([1 end]))])
      if (QmatNMR.CPMvec1(1) < QmatNMR.CPMvec1(2))
        set(QmatNMR.CPMTEMP4.AxesHandles(1), 'xdir', 'reverse');
      else  
        set(QmatNMR.CPMTEMP4.AxesHandles(1), 'xdir', 'normal');
      end  
      if (QmatNMR.CPMvec2(1) < QmatNMR.CPMvec2(2))
        set(QmatNMR.CPMTEMP4.AxesHandles(1), 'ydir', 'reverse');
      else  
        set(QmatNMR.CPMTEMP4.AxesHandles(1), 'ydir', 'normal');
      end  
      title('selected crosspeak', 'Color', QmatNMR.ColorScheme.AxisFore)
    
    
      
      if (QmatNMR.CPMfullprobability)
        %in the top right axis we plot the full probability function
        %axes(QmatNMR.CPMTEMP4.AxesHandles(2));
        set(QmatNMR.Fig2D3D, 'currentaxes', QmatNMR.CPMTEMP4.AxesHandles(2));
    
        surf(QmatNMR.CPMvec1Plot, QmatNMR.CPMvec2Plot, QmatNMR.CPM3Plot);
        caxis([0 1]);
        axis([sort(QmatNMR.CPMvec1([1 end])) sort(QmatNMR.CPMvec2([1 end]))])
        if (QmatNMR.CPMvec1(1) < QmatNMR.CPMvec1(2))
          set(QmatNMR.CPMTEMP4.AxesHandles(2), 'xdir', 'reverse');
        else  
          set(QmatNMR.CPMTEMP4.AxesHandles(2), 'xdir', 'normal');
        end  
        if (QmatNMR.CPMvec2(1) < QmatNMR.CPMvec2(2))
          set(QmatNMR.CPMTEMP4.AxesHandles(2), 'ydir', 'reverse');
        else  
          set(QmatNMR.CPMTEMP4.AxesHandles(2), 'ydir', 'normal');
        end  
        title('Full probability', 'Color', QmatNMR.ColorScheme.AxisFore)
        shading interp
    
      else
        %the top right axis we delete from the window
        %axes(QmatNMR.CPMTEMP4.AxesHandles(2));
        set(QmatNMR.Fig2D3D, 'currentaxes', QmatNMR.CPMTEMP4.AxesHandles(2));
        axis off
      end
    
    
    
      %in the middle left axis we plot the projection onto TD2
      %axes(QmatNMR.CPMTEMP4.AxesHandles(3));
      set(QmatNMR.Fig2D3D, 'currentaxes', QmatNMR.CPMTEMP4.AxesHandles(3));
      plot(QmatNMR.CPMvec1Plot, QmatNMR.sumTD2Plot, 'r');
      set(QmatNMR.CPMTEMP4.AxesHandles(3), 'xlim', sort(QmatNMR.CPMvec1([1 end])), 'ylim', [(min(QmatNMR.sumTD2Plot) - max(QmatNMR.sumTD2Plot)*0.1) (max(QmatNMR.sumTD2Plot)*1.1)], 'ytick', []);
      if (QmatNMR.CPMvec1(1) < QmatNMR.CPMvec1(2))
        set(QmatNMR.CPMTEMP4.AxesHandles(3), 'xdir', 'reverse');
      else  
        set(QmatNMR.CPMTEMP4.AxesHandles(3), 'xdir', 'normal');
      end
      box on
      title('Projection onto TD2', 'Color', QmatNMR.ColorScheme.AxisFore)
    
    
    
      %in the middle right axis we plot the projection onto TD1
      %axes(QmatNMR.CPMTEMP4.AxesHandles(4));
      set(QmatNMR.Fig2D3D, 'currentaxes', QmatNMR.CPMTEMP4.AxesHandles(4));
      plot(QmatNMR.CPMvec2Plot, QmatNMR.sumTD1Plot, 'r');
      set(QmatNMR.CPMTEMP4.AxesHandles(4), 'xlim', sort(QmatNMR.CPMvec2([1 end])), 'ylim', [(min(QmatNMR.sumTD1Plot) - max(QmatNMR.sumTD1Plot)*0.1) (max(QmatNMR.sumTD1Plot)*1.1)], 'ytick', []);
      if (QmatNMR.CPMvec2(1) < QmatNMR.CPMvec2(2))
        set(QmatNMR.CPMTEMP4.AxesHandles(4), 'xdir', 'reverse');
      else  
        set(QmatNMR.CPMTEMP4.AxesHandles(4), 'xdir', 'normal');
      end
      box on
      title('Projection onto TD1', 'Color', QmatNMR.ColorScheme.AxisFore)
    
    
    
      %in the bottom left axis we plot CPM1
      %axes(QmatNMR.CPMTEMP4.AxesHandles(5));
      set(QmatNMR.Fig2D3D, 'currentaxes', QmatNMR.CPMTEMP4.AxesHandles(5));
      QTEMP = QmatNMR.CPM1(isfinite(QmatNMR.CPM1));      %only take finite numbers into account
      QmatNMR.CPMContourLevels(1:QmatNMR.CPMnumbcont) = max(QTEMP) / 100 * ( ( (QmatNMR.CPMmultiplier.^linspace(0, 1, QmatNMR.CPMnumbcont) - 1) / (QmatNMR.CPMmultiplier-1) ) * (QmatNMR.CPMmax - QmatNMR.CPMmin1) + QmatNMR.CPMmin1 );
      if (QmatNMR.CPMfilledcontours == 0)      %plot normal contours
        contour(QmatNMR.CPMvec1Plot, QmatNMR.CPMvec2Plot, QmatNMR.CPM1Plot, QmatNMR.CPMContourLevels);
      else
        if (QmatNMR.MatlabVersion >= 7.0)
          contourf('v6', QmatNMR.CPMvec1Plot, QmatNMR.CPMvec2Plot, QmatNMR.CPM1Plot, QmatNMR.CPMContourLevels);
        else
          contourf(QmatNMR.CPMvec1Plot, QmatNMR.CPMvec2Plot, QmatNMR.CPM1Plot, QmatNMR.CPMContourLevels);
        end
        shading flat
      end
      axis([sort(QmatNMR.CPMvec1([1 end])) sort(QmatNMR.CPMvec2([1 end]))])
      if (QmatNMR.CPMvec1(1) < QmatNMR.CPMvec1(2))
        set(QmatNMR.CPMTEMP4.AxesHandles(5), 'xdir', 'reverse');
      else  
        set(QmatNMR.CPMTEMP4.AxesHandles(5), 'xdir', 'normal');
      end  
      if (QmatNMR.CPMvec2(1) < QmatNMR.CPMvec2(2))
        set(QmatNMR.CPMTEMP4.AxesHandles(5), 'ydir', 'reverse');
      else  
        set(QmatNMR.CPMTEMP4.AxesHandles(5), 'ydir', 'normal');
      end  
      title('CPM 1', 'Color', QmatNMR.ColorScheme.AxisFore)
  
    
    
    
      %in the bottom right axis we plot CPM2
      %axes(QmatNMR.CPMTEMP4.AxesHandles(6));
      set(QmatNMR.Fig2D3D, 'currentaxes', QmatNMR.CPMTEMP4.AxesHandles(6));
      QTEMP = QmatNMR.CPM2(isfinite(QmatNMR.CPM2));      %only take finite numbers into account
      QmatNMR.CPMContourLevels(1:QmatNMR.CPMnumbcont) = max(QTEMP) / 100 * ( ( (QmatNMR.CPMmultiplier.^linspace(0, 1, QmatNMR.CPMnumbcont) - 1) / (QmatNMR.CPMmultiplier-1) ) * (QmatNMR.CPMmax - QmatNMR.CPMmin2) + QmatNMR.CPMmin2 );
      if (QmatNMR.CPMfilledcontours == 0)      %plot normal contours
        contour(QmatNMR.CPMvec2Plot, QmatNMR.CPMvec1Plot, QmatNMR.CPM2Plot.', QmatNMR.CPMContourLevels);
      else
        if (QmatNMR.MatlabVersion >= 7.0)
          contourf('v6', QmatNMR.CPMvec2Plot, QmatNMR.CPMvec1Plot, QmatNMR.CPM2Plot.', QmatNMR.CPMContourLevels);
        else
          contourf(QmatNMR.CPMvec2Plot, QmatNMR.CPMvec1Plot, QmatNMR.CPM2Plot.', QmatNMR.CPMContourLevels);
        end
        shading flat
      end
      axis([sort(QmatNMR.CPMvec2([1 end])) sort(QmatNMR.CPMvec1([1 end]))])
      if (QmatNMR.CPMvec1(1) < QmatNMR.CPMvec1(2))
        set(QmatNMR.CPMTEMP4.AxesHandles(6), 'xdir', 'reverse');
      else  
        set(QmatNMR.CPMTEMP4.AxesHandles(6), 'xdir', 'normal');
      end  
      if (QmatNMR.CPMvec2(1) < QmatNMR.CPMvec2(2))
        set(QmatNMR.CPMTEMP4.AxesHandles(6), 'ydir', 'reverse');
      else  
        set(QmatNMR.CPMTEMP4.AxesHandles(6), 'ydir', 'normal');
      end  
      title('CPM 2', 'Color', QmatNMR.ColorScheme.AxisFore)
    
    
      %
      %change the fontsize of the axes to become roughly 4 points smaller than the standard fontsize
      %
      QmatNMR.uiInput1 = 1;      %font name = not used
      QmatNMR.uiInput1a= 0;
    
                                          %determine default font size
      QmatNMR.Ttmp=['6 ';'7 ';'8 ';'9 ';'10';'11';'12';'14';'16';'18';'20';'22';'24';'30';'36';'48';'72'];
      for QTEMP1=1:14
        if strcmp(deblank(QmatNMR.Ttmp(QTEMP1, :)), num2str(QmatNMR.TextSize));
          break
        end
      end;    
      QmatNMR.uiInput2 = QTEMP1-2;     %font size
      QmatNMR.uiInput2a= 1;
    
      QmatNMR.uiInput3 = 1;      %font weight = not used
      QmatNMR.uiInput3a= 0;
    
      QmatNMR.uiInput4 = 1;      %font angle = not used
      QmatNMR.uiInput4a= 0;
    
      QmatNMR.uiInput5 = 1;      %change axis
      QmatNMR.uiInput6 = 0;      %don't change the axis labels
      QmatNMR.uiInput7 = 0;      %don't change title
      QmatNMR.uiInput8 = 2;      %change all axes
      QmatNMR.buttonList = 1;
      regelfont
    
    
      %
      %Create a super title with a dummy text
      %
      QmatNMR.uiInput1 = 'CPMs created for spectrum XXX';
      QmatNMR.uiInput2 = num2str(QmatNMR.TextSize + 8);
      QmatNMR.uiInput3 = '0';
      QmatNMR.buttonList = 1;
      regelsupertitle
      
      
      %
      %Use the "PaperMap" colourmap
      %
      colormap(QmatNMR.PaperMap);
    
    
      %define the window with the full spectrum as the current window
      set(QmatNMR.CPMTEMP4.AxesHandles(1), 'selected', 'off')
      QmatNMR.Fig2D3D = QmatNMR.CPMTEMP2;
      figure(QmatNMR.Fig2D3D);
      %axes(QmatNMR.CPMTEMP3);
      set(QmatNMR.Fig2D3D, 'currentaxes', QmatNMR.CPMTEMP3);
      UpdateFigure
    end
  
  else
    disp('CreateCPMs stopped...');
    set(QmatNMR.Fig2D3D,'windowbuttondownfcn','SelectFigure', ...
          'windowbuttonupfcn','', ...
          'windowbuttonmotionfcn','',...
          'interruptible','on')
    set(QmatNMR.AxisHandle2D3D,'interruptible','on', 'buttondownfcn', 'SelectAxis')
    disp('  ');
    
    Arrowhead
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
