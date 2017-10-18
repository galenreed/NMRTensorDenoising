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
%GetPeaks.m handles the peak picking in matNMR. It is a rather simplistic routine though.
%Peaks can be picked and lines can be drawn between the peaks in wanted. Also text symbols
%are plotted with each peak. These (and the lines too) can be removed separately.
%17-08-'98
%04-10-'00


function [x, y, value, button] = GetPeaks(Spectrum, var1, var2)

global QmatNMR

if (var2 > 0)
  set(QmatNMR.Fig2D3D,'windowbuttondownfcn',['SelectFigure; GetPeaks(' Spectrum ',''' var1 ''', 0);'], ...
          'windowbuttonupfcn','', ...
          'windowbuttonmotionfcn','',...
          'interruptible','on')
  set(QmatNMR.AxisHandle2D3D,'interruptible','on', 'buttondownfcn', '')

else
  button = get(QmatNMR.Fig2D3D, 'SelectionType');
  if strcmp(button,'normal')
    button = 1;
  elseif strcmp(button,'extend')
    button = 2;
  elseif strcmp(button,'alt')
    button = 3;
  end

  QTEMP1 = str2num(var1);
  QmatNMR.PeakPickType = QTEMP1(1);
  QmatNMR.PeakPickSearchDir = QTEMP1(2);

  if (button == 1)		%Left button was pressed --> select peak
    eindpunt = 0;
    while (eindpunt == 0)
      beginpunt = get(QmatNMR.AxisHandle2D3D,'currentpoint');

      rbbox([get(QmatNMR.Fig2D3D,'currentpoint') 0 0],get(QmatNMR.Fig2D3D,'currentpoint'));
      eindpunt = get(QmatNMR.AxisHandle2D3D,'currentpoint');
    end

				%
				%sort output such that matrix is:  [top-left-X    top-left-Y]
				%                                  [bot-right-X  bot-right-Y]
				%
    QmatNMR.Pos = [sort([beginpunt(1,1); eindpunt(1,1)]) sort([beginpunt(1,2); eindpunt(1,2)])];


				%Extract plot parameters from the figure window's userdata
    QTEMP1 = get(QmatNMR.Fig2D3D, 'userdata');				
    QmatNMR.AxisData = QTEMP1.PlotParams(QmatNMR.AxisNR2D3D).AxisProps;
    if ~(QmatNMR.AxisData(1))		%non-linear axis in TD2 -> extract axis vector directly from userdata
      QmatNMR.Axis2D3DTD2 = QTEMP1.PlotParams(QmatNMR.AxisNR2D3D).AxisTD2;
    end  

    if ~(QmatNMR.AxisData(3))		%non-linear axis in TD1 -> extract axis vector directly from userdata
      QmatNMR.Axis2D3DTD1 = QTEMP1.PlotParams(QmatNMR.AxisNR2D3D).AxisTD1;
    end  

    if ~ isempty(QmatNMR.AxisData)			%when the user has plotted some spectrum himself
	    					%into the contour window then probably the axes information
						%will not have been written into the userdata property.
						%Then this could give errors ...

      %
      %now determine the coordinate in points. The method depends on whether the axis
      %was linear or non-linear.
      %
      if (QmatNMR.AxisData(1))		%linear axis in TD2 -> use axis increment and offset values
        X = round((QmatNMR.Pos(1:2, 1)-QmatNMR.AxisData(2)) ./ QmatNMR.AxisData(1));
      else
      				%non-linear axis -> use the minimum distance to the next point in the axis vector
        [X, QTEMP2] = min(abs(QmatNMR.Axis2D3DTD2 - QmatNMR.Pos(1, 1)));
        [X, QTEMP3] = min(abs(QmatNMR.Axis2D3DTD2 - QmatNMR.Pos(2, 1)));
        X = [QTEMP2 QTEMP3];
      end
      
      if (QmatNMR.AxisData(3))		%linear axis in TD1 -> use axis increment and offset values
        Y = round((QmatNMR.Pos(1:2, 2)-QmatNMR.AxisData(4)) ./ QmatNMR.AxisData(3));
      else
      				%non-linear axis -> use the minimum distance to the next point in the axis vector
        [Y, QTEMP2] = min(abs(QmatNMR.Axis2D3DTD1 - QmatNMR.Pos(1, 2)));
        [Y, QTEMP3] = min(abs(QmatNMR.Axis2D3DTD1 - QmatNMR.Pos(2, 2)));
        Y = [QTEMP2 QTEMP3];
      end

    else
      %no axis information found. Cannot continue!
      error('matNMR ERROR: cannot find axis information in figure window''s userdata. Aborting ...');
    end
				%Check whether the coordinates are within the matrix bounds
    [QmatNMR.tmp1, QmatNMR.tmp2] = size(Spectrum);
    X = sort(X);
    Y = sort(Y);
    if (X(1) < 1); X(1)=1; end
    if (X(2) > max(QmatNMR.tmp2)); X(2)=max(QmatNMR.tmp2); end
    if (Y(1) < 1); Y(1)=1; end
    if (Y(2) > max(QmatNMR.tmp1)); Y(2)=max(QmatNMR.tmp1); end

    				%
				%get the maximum in the specified area according to the search type
				%
    if (QmatNMR.PeakPickSearchDir == 1)	%Maximum Intensity
      [value, y] = max(real(Spectrum(Y(1):Y(2), X(1):X(2))));
      [value, x] = max(value);

    elseif (QmatNMR.PeakPickSearchDir == 2)	%Minimum Intensity
      [value, y] = min(real(Spectrum(Y(1):Y(2), X(1):X(2))));
      [value, x] = min(value);

    elseif (QmatNMR.PeakPickSearchDir == 3)	%Only Positive
      QTEMP1 = real(Spectrum(Y(1):Y(2), X(1):X(2)));
      QTEMP2 = 0*QTEMP1;
      QTEMP3 = find(QTEMP1 > 0);
      QTEMP2(QTEMP3) = ones(1, length(QTEMP3));
      [value, y] = max(QTEMP1 .* QTEMP2);
      [value, x] = max(value);

    elseif (QmatNMR.PeakPickSearchDir == 4)	%Only negative
      QTEMP1 = real(Spectrum(Y(1):Y(2), X(1):X(2)));
      QTEMP2 = 0*QTEMP1;
      QTEMP3 = find(QTEMP1 < 0);
      QTEMP2(QTEMP3) = ones(1, length(QTEMP3));
      [value, y] = min(QTEMP1 .* QTEMP2);
      [value, x] = min(value);

    elseif (QmatNMR.PeakPickSearchDir == 5)	%Highest Absolute value
      [value, y] = max(abs(real(Spectrum(Y(1):Y(2), X(1):X(2)))));
      [value, x] = max(value);
    end
    

    %
    %Now convert the coordinates in points back to the axes units. These values
    %for x and y are used to plot the text labels to each peak.
    %
    if (QmatNMR.AxisData(3))	      %linear axis in TD1 -> use axis increment and offset values
      y_display = (y(x)+Y(1)-1)*QmatNMR.AxisData(3) + QmatNMR.AxisData(4);
    else
			      %non-linear axis -> use the minimum distance to the next point in the axis vector
      y_display = QmatNMR.Axis2D3DTD1(y(x)+Y(1)-1);
    end
    
    if (QmatNMR.AxisData(1))	      %linear axis in TD2 -> use axis increment and offset values
      x_display = (x+X(1)-1)*QmatNMR.AxisData(1) + QmatNMR.AxisData(2);
    else
			      %non-linear axis -> use the minimum distance to the next point in the axis vector
      x_display = QmatNMR.Axis2D3DTD2(x+X(1)-1);
    end


    %
    %Now convert the coordinates in points back to the units of the analysis axes. 
    %These values are always stored in the userdata as 
    %QTEMP1.PlotParams(QmatNMR.AxisNR2D3D).AnalyserAxisTD2
    %and 
    %QTEMP1.PlotParams(QmatNMR.AxisNR2D3D).AnalyserAxisTD1.
    %
    QmatNMR.contvec1_analysis = QTEMP1.PlotParams(QmatNMR.AxisNR2D3D).AnalyserAxisTD2;
    QmatNMR.contvec2_analysis = QTEMP1.PlotParams(QmatNMR.AxisNR2D3D).AnalyserAxisTD1;
    y_analysis = QmatNMR.contvec2_analysis(y(x)+Y(1)-1);
    x_analysis = QmatNMR.contvec1_analysis(x+X(1)-1);
    

%
%NOTE:
%So now we have two sets of coordinates. One ("x_analysis" and "y_analysis") give the real value
%of the position in the desired units. The other set ("x_display" and "y_display") give the
%corresponding values of the coordinates in the real units of the current plot.
%This rather tricky business was started to be able to handle spectra that are cut into
%slices and then pasted together again, while not losing any of the original axes information.
%These plots are then plotted in points with the tickmarks and ticklabels set to look as if
%the plot is in the original units. To be able to do peak picking etc. one needs to be able
%to read the coordinates back somehow. This is done by saving the axes in the userdata of
%the figure window.
%


    %
    %For only-negative and only positive searches we need to check whether the value was
    %indeed positive or negative.
    %    
    if ((QmatNMR.PeakPickSearchDir == 4) & (value > 0)) | ((QmatNMR.PeakPickSearchDir == 3) & (value < 0))
      value = NaN;
    end
      
    
    %
    %allow the peak that was found if it conforms to the search specifications else discard it
    %
    if ~(isnan(value))		

  				%put text label in contour plot
      QmatNMR.TextHandle = text(x_display, y_display, strcat('(', num2str(x_analysis), ', ', num2str(y_analysis), ')'));
      set(QmatNMR.TextHandle, 'hittest', 'on', 'Color', QmatNMR.ColorScheme.AxesFore, ...
          'buttondownfcn', 'askedittext');
    
      QmatNMR.PeakList = [QmatNMR.PeakList; [x_analysis y_analysis value QmatNMR.TextHandle 0]];
  
      if (QmatNMR.PeakPickType == 2)		%draw line between the last 2 peaks ...
        QTEMP1 = size(QmatNMR.PeakList, 1);
        if QTEMP1>1		%Don't plot when this is the first entry in the peak list

				%now we distinguish between the case where the two sets of
				%coordinates are the same (for most plots this is true)
				%and where they are not (the difficult tricky case)
	  if ((x_display == x_analysis) & (y_display == y_analysis))
	    %
	    %the easy case ... they are equal
	    %
            LineHandle = line(QmatNMR.PeakList( (QTEMP1-1):(QTEMP1), 1 ), QmatNMR.PeakList( (QTEMP1-1):(QTEMP1), 2 ));
            set(LineHandle, 'color', 'w', 'hittest', 'on', ...
	      'buttondownfcn', 'QuiInput(''Delete Line ?'', '' YES | NO'', ''regeleditline'', [], ''Line Handle (do not edit!)'', num2str(gco,20));');
            QmatNMR.PeakList(QTEMP1, 5) = LineHandle;
	    
	  else
	    %
	    %the difficult case ... they are not equal. What do we do now?
	    %-We just have to convert the last entry of the peak list into the units of the
	    % display axis (we can use the x_display and y_display of the current entry so
	    % that saves us some time)
	    %
	    %note that when the user has done a bad cut of the spectrum that some peaks
	    %will not be plottable because they are not included in the range!
	    %
	    if (QmatNMR.AxisData(1))		%linear axis in TD2 -> use axis increment and offset values
              QmatNMR.Axis2D3DTD2 = (1:QmatNMR.tmp2)*QmatNMR.AxisData(1) + QmatNMR.AxisData(2);
	    end  
	    if (QmatNMR.AxisData(3))		%linear axis in TD1 -> use axis increment and offset values
              QmatNMR.Axis2D3DTD1 = (1:QmatNMR.tmp1)*QmatNMR.AxisData(3) + QmatNMR.AxisData(4);
	    end  
	    QmatNMR.PreviousX_analysis = QmatNMR.PeakList( (QTEMP1-1), 1 );
	    QmatNMR.PreviousY_analysis = QmatNMR.PeakList( (QTEMP1-1), 2 );
	    
            QTEMP11 = (QmatNMR.contvec1_analysis - QmatNMR.PreviousX_analysis);
            QTEMP12 = QTEMP11(1:QmatNMR.tmp2-1).*QTEMP11(2:QmatNMR.tmp2);
            QmatNMR.PreviousX_display = find( (sign(QTEMP12)==-1) | (sign(QTEMP12)==0) );
            if ~ isempty(QmatNMR.PreviousX_display)
	      QmatNMR.PreviousX_display = QmatNMR.PreviousX_display(length(QmatNMR.PreviousX_display));
              QmatNMR.PreviousX_display = QmatNMR.Axis2D3DTD2(QmatNMR.PreviousX_display) + (QmatNMR.Axis2D3DTD2(QmatNMR.PreviousX_display+1) - QmatNMR.Axis2D3DTD2(QmatNMR.PreviousX_display)) * (QmatNMR.PreviousX_analysis - QmatNMR.contvec1_analysis(QmatNMR.PreviousX_display)) / (QmatNMR.contvec1_analysis(QmatNMR.PreviousX_display+1) - QmatNMR.contvec1_analysis(QmatNMR.PreviousX_display));
    	
            else
              QmatNMR.PreviousX_display = NaN;
            end  
	    
            QTEMP11 = (QmatNMR.contvec2_analysis - QmatNMR.PreviousY_analysis);
            QTEMP12 = QTEMP11(1:QmatNMR.tmp1-1).*QTEMP11(2:QmatNMR.tmp1);
            QmatNMR.PreviousY_display = find( (sign(QTEMP12)==-1) | (sign(QTEMP12)==0) );
            if ~ isempty(QmatNMR.PreviousY_display)
	      QmatNMR.PreviousY_display = QmatNMR.PreviousY_display(length(QmatNMR.PreviousY_display));
              QmatNMR.PreviousY_display = QmatNMR.Axis2D3DTD1(QmatNMR.PreviousY_display) + (QmatNMR.Axis2D3DTD1(QmatNMR.PreviousY_display+1) - QmatNMR.Axis2D3DTD1(QmatNMR.PreviousY_display)) * (QmatNMR.PreviousY_analysis - QmatNMR.contvec2_analysis(QmatNMR.PreviousY_display)) / (QmatNMR.contvec2_analysis(QmatNMR.PreviousY_display+1) - QmatNMR.contvec2_analysis(QmatNMR.PreviousY_display));
    	
            else
              QmatNMR.PreviousY_display = NaN;
            end

            %
	    %Now finally we can draw the line
	    %
            LineHandle = line([QmatNMR.PreviousX_display x_display], [QmatNMR.PreviousY_display y_display]);
            set(LineHandle, 'color', 'w', 'hittest', 'on', ...
	      'buttondownfcn', 'QuiInput(''Delete Line ?'', '' YES | NO'', ''regeleditline'', [], ''Line Handle (do not edit!)'', num2str(gco,20));');
            QmatNMR.PeakList(QTEMP1, 5) = LineHandle;
  
	  end  
        end	
      end
      
    else
      disp('matNMR WARNING: No peak was found in the given area that conforms to the search specifications!!');
      QTEMP1 = str2mat('Maximum Intensity in area','Minimum Intensity in area','Maximum, Only Positive','Minimum, Only Negative','Highest Absolute Value in area');
      disp(['(Current Search Specs are: ' deblank(QTEMP1(QmatNMR.PeakPickSearchDir, :)) ')']);
    end  
    



  elseif (button == 2)		%Middle button was pressed --> delete last entry from Peak List
    QTEMP1 = size(QmatNMR.PeakList);
    if (QTEMP1(1) > 1)
      delete(QmatNMR.PeakList(QTEMP1(1), 4));
      
      LineHandle = QmatNMR.PeakList(QTEMP1(1), 5);
      if LineHandle
        delete(LineHandle);
      end	
      
      QmatNMR.PeakList = QmatNMR.PeakList(1:(QTEMP1(1)-1), :);

      disp('Deleting last entry from Peak List !');
      
    elseif (QTEMP1(1) == 1)	%this is the last element ... so now the list is empty again
      delete(QmatNMR.PeakList(QTEMP1(1), 4));		%delete label
      QmatNMR.PeakList = [];				%clear list
      
    else
      disp('Cannot delete last element: No more elements in list !');
    end




  elseif (button == 3)		%Right button was pressed --> stop routine  
    disp('GetPeaks stopped...');
    set(QmatNMR.Fig2D3D,'windowbuttondownfcn','SelectFigure', ...
          'windowbuttonupfcn','', ...
          'windowbuttonmotionfcn','',...
          'interruptible','on')
    set(QmatNMR.AxisHandle2D3D,'interruptible','on', 'buttondownfcn', 'SelectAxis')
    
    Arrowhead
  end
end
