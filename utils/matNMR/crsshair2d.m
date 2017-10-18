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
function crsshair2d(action, action2, action3);
%         crsshair2d
%
%  A gui interface for reading (x,y) values from a plot.
%	
%  A set of mouse driven crosshairs is placed on the current axes,
%  and displays the current (x,y) position, interpolated between points. 
%  For multiple traces, only plots with the same length(xdata) 
%  will be tracked. Select done after using to remove the gui stuff, 
%  and to restore the mouse buttons to previous values.
%
%   Richard G. Cobb    3/96
%   cobbr@plk.af.mil 
%

%
% original version for 1D spectra was adapted for 2D contour plots for matNMR 
% by Jacco van Beek
% 1-1-'98
%

global QmatNMR

if (nargin == 2)
  action3 = '';
end
  
%
% action tells the crsshair2d routine what to do
% action2 is a string that refers to a global variable in the workspace. crsshair2d.m will
% 	access this variable and get the intensity which will be shown too. If the variable
%	does not exist or is not a proper matrix then NaN will be displayed
% action3 defines the name of a callback routine that must be started whenever a button is
% 	pressed. This normally stops the routine but was adapted such that a callback routine
%	can be started from it. 
%
if (~ ((strcmp(action, 'up')) | (strcmp(action, 'move'))) )
        xhrx_axis=QmatNMR.AxisHandle2D3D;
	set(QmatNMR.Fig2D3D,'WindowButtonDownFcn',['crsshair2d(''move'', ''' action2 ''', ''' action3 ''');'], ...
	        'WindowButtonMotionFcn',['crsshair2d(''move'', ''' action2 ''', ''' action3 ''');']);

%
%
%   Frame and Buttons
%
%
	frame=uicontrol('Style', 'frame', 'units', 'normalized', ...
	                'backgroundcolor', QmatNMR.ColorScheme.Frame2, ...
			'Position', [0 0 0.28 0.095]);
	xaxis_text=uicontrol('Style','text','Units','Normalized',...
			'Position',[0 0.06 0.07 0.03],...
			'String','TD2 :',...
			'BackGroundColor', QmatNMR.ColorScheme.Button13Back, ...
			'Foregroundcolor', QmatNMR.ColorScheme.Button13Fore, ...
			'fontsize', QmatNMR.UIFontSize+1);
	x_num=uicontrol('Style','text','Units','Normalized',...
			'Position',[0.07 0.06 0.1 0.03],...
			'String',' ',...
			'BackGroundColor', QmatNMR.ColorScheme.Button12Back, ...
			'Foregroundcolor', QmatNMR.ColorScheme.Button12Fore, ...
			'fontsize', QmatNMR.UIFontSize+1);
	x_num2=uicontrol('Style','text','Units','Normalized',...
			'Position',[0.17 0.06 0.1 0.03],...
			'String',' ',...
			'BackGroundColor', QmatNMR.ColorScheme.Button12Back, ...
			'Foregroundcolor', QmatNMR.ColorScheme.Button12Fore, ...
			'fontsize', QmatNMR.UIFontSize+1);
	y_text=uicontrol('Style','text','Units','Normalized',...
			'Position',[0 0.03 0.07 0.03],...
			'String','TD1 :',...
			'BackGroundColor', QmatNMR.ColorScheme.Button13Back, ...
			'Foregroundcolor', QmatNMR.ColorScheme.Button13Fore, ...
			'fontsize', QmatNMR.UIFontSize+1);
	y_num=uicontrol('Style','text','Units','Normalized',...
			'Position',[0.07 0.03 0.1 0.03],...
			'String',' ',...
			'BackGroundColor', QmatNMR.ColorScheme.Button12Back, ...
			'Foregroundcolor', QmatNMR.ColorScheme.Button12Fore, ...
			'fontsize', QmatNMR.UIFontSize+1);
	y_num2=uicontrol('Style','text','Units','Normalized',...
			'Position',[0.17 0.03 0.1 0.03],...
			'String',' ',...
			'BackGroundColor', QmatNMR.ColorScheme.Button12Back, ...
			'Foregroundcolor', QmatNMR.ColorScheme.Button12Fore, ...
			'fontsize', QmatNMR.UIFontSize+1);
	int_text=uicontrol('Style','text','Units','Normalized',...
			'Position',[0 0 0.07 0.03],...
			'String','INT :',...
			'BackGroundColor', QmatNMR.ColorScheme.Button13Back, ...
			'Foregroundcolor', QmatNMR.ColorScheme.Button13Fore, ...
			'fontsize', QmatNMR.UIFontSize+1);
	int_num=uicontrol('Style','text','Units','Normalized',...
			'Position',[0.07 0 0.2 0.03],...
			'String',' ',...
			'BackGroundColor', QmatNMR.ColorScheme.Button12Back, ...
			'Foregroundcolor', QmatNMR.ColorScheme.Button12Fore, ...
			'fontsize', QmatNMR.UIFontSize+1);
	QTEMPO = get(QmatNMR.Fig2D3D, 'userdata');
	QTEMPO.Crosshair2D = [xhrx_axis xaxis_text x_num x_num2 y_text y_num y_num2 int_text int_num frame];
	set(QmatNMR.Fig2D3D, 'userdata', QTEMPO, 'Pointer', 'crosshair');
        
        %
        %store the current spectrum for easy retrieval of the intensities
        %
        if (QmatNMR.Crosshair2DSlices==1)
          QTEMP = get(QmatNMR.Fig2D3D, 'userdata');
          if isequal(QTEMP.PlotParams(QmatNMR.AxisNR2D3D).Name, QmatNMR.SpecName2D3D)
            QmatNMR.Crosshair2DSpec = real(QmatNMR.Spec2D3D);
          else
            QmatNMR.Crosshair2DSpec = eval(QTEMP.PlotParams(QmatNMR.AxisNR2D3D).Name);
            if isstruct(QmatNMR.Crosshair2DSpec)
              QmatNMR.Crosshair2DSpec = QmatNMR.Crosshair2DSpec.Spectrum;
            end
            QmatNMR.Crosshair2DSpec = real(QmatNMR.Crosshair2DSpec);
          end
          QmatNMR.Crosshair2DSpec = QmatNMR.Crosshair2DSpec / max(max(QmatNMR.Crosshair2DSpec));
          
          %
          %plot slices and store the handles so we later only replace the xdata or ydata
          %
          QTEMP3 = get(gca, 'nextplot');
          hold on
          QmatNMR.Q1 = QTEMP.PlotParams(QmatNMR.AxisNR2D3D).AnalyserAxisTD2;
          QmatNMR.Q2 = QTEMP.PlotParams(QmatNMR.AxisNR2D3D).AnalyserAxisTD1;
          
          QmatNMR.Crosshair2DScalingTD1 = -(QmatNMR.Q1(end)-QmatNMR.Q1(1))/4;
          QmatNMR.Crosshair2DScalingTD2 = -(QmatNMR.Q2(end)-QmatNMR.Q2(1))/4;
          if (abs(QmatNMR.Crosshair2DScalingTD2) > abs(QmatNMR.Crosshair2DScalingTD1))
            QmatNMR.Crosshair2DScalingTD2 = abs(QmatNMR.Crosshair2DScalingTD1)*sign(QmatNMR.Crosshair2DScalingTD2);
          else
            QmatNMR.Crosshair2DScalingTD1 = abs(QmatNMR.Crosshair2DScalingTD2)*sign(QmatNMR.Crosshair2DScalingTD1);
          end

          
          QTEMP2 = plot(QmatNMR.Q1(round(length(QmatNMR.Q1)*0.9)) + QmatNMR.Crosshair2DSpec(:, 1)*0, QmatNMR.Q2, QmatNMR.LineColor);
          set(QTEMP2, 'tag', 'crsshairplots1');
          QTEMP2 = plot(QmatNMR.Q1, QmatNMR.Q2(round(length(QmatNMR.Q2)*0.9)) + QmatNMR.Crosshair2DSpec(1, :)*0, QmatNMR.LineColor);
          set(QTEMP2, 'tag', 'crsshairplots2');
          set(gca, 'nextplot', QTEMP3)

        else
          if isfield(QmatNMR, 'Crosshair2DSpec')
            rmfield(QmatNMR, 'Crosshair2DSpec');
          end
        end


elseif strcmp(action,'move');
	QmatNMR.handles = get(QmatNMR.Fig2D3D, 'userdata');
	QmatNMR.handles = QmatNMR.handles.Crosshair2D;
	xhrx_axis=QmatNMR.handles(1);
	xaxis_text=QmatNMR.handles(2);
	x_num=QmatNMR.handles(3);
	x_num2=QmatNMR.handles(4);
	y_text=QmatNMR.handles(5);
	y_num=QmatNMR.handles(6); 
	y_num2=QmatNMR.handles(7); 
	int_text=QmatNMR.handles(8);
	int_num=QmatNMR.handles(9);

	pt=get(xhrx_axis,'Currentpoint');
	xdata_pt=pt(1,1);
	ydata_pt=pt(1,2);
	
					%This is to check whether the name of the variable given in action2
					%really exists as a global and whether it is a matrix.
					%Numbers that fall outside the size of the matrix will give NaN for
					%intensity.
					%
					%BUG / NOTE: when the axes of the plot are not in points then the
					%	intensity cannot be read properly without giving many parameters
					%	to this function. I didn't want to do this to keep this function
					%	simple.

  	if strcmp(deblank(action2), '')
	  intensity = NaN;
	else
  	  %eval(['global ' action2]);
  	  
  	  if ( (isa(eval(action2), 'double')) & (~ (size(eval(action2)) == [0 0]) ) )
  	    [QmatNMR.tmp1 QmatNMR.tmp2] = size(eval(action2));	%this is the size of the last plotted spectrum in the 2D/3D Viewer
	    QTEMP = get(QmatNMR.Fig2D3D, 'userdata');
	    
	    						%now we need to check whether the last plotted spectrum at least has the
							%same size as the parameters of the current axis show.
	    QmatNMR.CheckTD2 = QTEMP.PlotParams(QmatNMR.AxisNR2D3D).SizeTD2;
	    QmatNMR.CheckTD1 = QTEMP.PlotParams(QmatNMR.AxisNR2D3D).SizeTD1;
	    if ~ ((QmatNMR.CheckTD2 == QmatNMR.tmp2) & (QmatNMR.CheckTD1 == QmatNMR.tmp1))
	      QmatNMR.BadFlag = 1;
	      %disp('matNMR WARNING: the current axis does not seem to be the same size as the last plotted spectrum!!');
	      %disp('matNMR WARNING: the intensity is not determined therefore.');
	      
	      QmatNMR.tmp1 = QmatNMR.CheckTD1;			%to be sure that 
	      QmatNMR.tmp2 = QmatNMR.CheckTD2;

	    else
	      QmatNMR.BadFlag = 0;
	    end  
	    
	    						%read offset and slope of the axes vectors in the plot
	    QmatNMR.AxisData = QTEMP.PlotParams(QmatNMR.AxisNR2D3D).AxisProps;

	    						%and from them determine the real position in points
	    
	    if ~ isempty(QmatNMR.AxisData)			%when the user has plotted some spectrum himself
	    						%into the contour window then probably the axes information
							%will not have been written into the userdata property.
							%Then this could give errors ...
              %
	      %first determine the coordinate in points. The method depends on whether the axis
	      %was linear or non-linear.
	      %
              if (QmatNMR.AxisData(1))		%linear axis in TD2 -> use axis increment and offset values
  	        QmatNMR.xCoord = round((xdata_pt-QmatNMR.AxisData(2)) / QmatNMR.AxisData(1));
              else
	      				%non-linear axis -> use the minimum distance to the next point in the axis vector
	        [QTEMP2 QmatNMR.xCoord] = min(abs(QTEMP.PlotParams(QmatNMR.AxisNR2D3D).AxisTD2 - xdata_pt));
	      end
	      
              if (QmatNMR.AxisData(3))		%linear axis in TD1 -> use axis increment and offset values
  	        QmatNMR.yCoord = round((ydata_pt-QmatNMR.AxisData(4)) / QmatNMR.AxisData(3));
              else
	      				%non-linear axis -> use the minimum distance to the next point in the axis vector
	        [QTEMP2 QmatNMR.yCoord] = min(abs(QTEMP.PlotParams(QmatNMR.AxisNR2D3D).AxisTD1 - ydata_pt));
	      end

              %
	      %Now check whether these coordinates are within the limits of the axes length 1:dim and if
	      %so extract the value from the current spectrum, unless the QmatNMR.BadFlag is active in which case
	      %a NaN will be generated
	      %
    	      if ((QmatNMR.BadFlag) | (QmatNMR.xCoord < 1) | (QmatNMR.xCoord > QmatNMR.tmp2) | (QmatNMR.yCoord < 1) | (QmatNMR.yCoord > QmatNMR.tmp1))
  	        intensityR = NaN;
  	        intensityI = NaN;
  	      else  
      	        intensityR = real(eval([action2 '(' num2str(round(QmatNMR.yCoord)) ', ' num2str(round(QmatNMR.xCoord)) ')']));
      	        intensityI = imag(eval([action2 '(' num2str(round(QmatNMR.yCoord)) ', ' num2str(round(QmatNMR.xCoord)) ')']));
      	      end
	    else
	      QmatNMR.xCoord = NaN;
	      QmatNMR.yCoord = NaN;
	      intensityR = NaN;
	      intensityI = NaN;
	    end  
      	  else
      	    intensityR = NaN;
      	    intensityI = NaN;
      	    action2 = '';
	  end  
  	end


					%set the windowbuttonup function --> push button = stop routine!	
	set(QmatNMR.Fig2D3D,'WindowButtonUpFcn',['crsshair2d(''up'', ''' action2 ''', ''' action3 '''); ' action3 ';']);

	QmatNMR.Q1 = QTEMP.PlotParams(QmatNMR.AxisNR2D3D).AnalyserAxisTD2;
	QmatNMR.Q2 = QTEMP.PlotParams(QmatNMR.AxisNR2D3D).AnalyserAxisTD1;

	if ((QmatNMR.xCoord < 1) | (QmatNMR.xCoord > length(QmatNMR.Q1)) | isempty(QmatNMR.Q1))	%if the crosshair is outside the axis a NaN will be shown
  	  set(x_num  ,'String',sprintf('%5.2f', NaN));	%td2
  	  set(x_num2 ,'String','');			%td2
	  
	else
  	  set(x_num  ,'String',sprintf('%5.2f', QmatNMR.Q1(QmatNMR.xCoord)));	%td2
  	  set(x_num2 ,'String',sprintf('(%5d)', QmatNMR.xCoord));	%td2

          if (QmatNMR.Crosshair2DSlices==1)
            set(findobj(allchild(gcf), 'tag', 'crsshairplots1'), 'xdata', QmatNMR.Q1(round(length(QmatNMR.Q1)*0.9)) + QmatNMR.Crosshair2DSpec(:, QmatNMR.xCoord)*QmatNMR.Crosshair2DScalingTD1);
          end
	end  

	if ((QmatNMR.yCoord < 1) | (QmatNMR.yCoord > length(QmatNMR.Q2)) | isempty(QmatNMR.Q2))
	  set(y_num  ,'String',sprintf('%5.2f', NaN));	%td1
  	  set(y_num2 ,'String','');			%td1
	  
	else
	  set(y_num  ,'String',sprintf('%5.2f', QmatNMR.Q2(QmatNMR.yCoord)));	%td1
	  set(y_num2 ,'String',sprintf('(%5d)', QmatNMR.yCoord));	%td1

          if (QmatNMR.Crosshair2DSlices==1)
            set(findobj(allchild(gcf), 'tag', 'crsshairplots2'), 'ydata', QmatNMR.Q2(round(length(QmatNMR.Q2)*0.9)) + QmatNMR.Crosshair2DSpec(QmatNMR.yCoord, :)*QmatNMR.Crosshair2DScalingTD2);
          end
	end  



%	set(x_num  ,'String',sprintf('%5.2f', xdata_pt));	%td2
%	set(y_num  ,'String',sprintf('%5.2f', ydata_pt));	%td1
	set(int_num,'String',sprintf('%5.4g %+5.4gi', intensityR, intensityI ));

elseif strcmp(action,'up');
	QmatNMR.handles = get(QmatNMR.Fig2D3D, 'userdata');
	QmatNMR.handles = QmatNMR.handles.Crosshair2D;
	xhrx_axis=QmatNMR.handles(1);
	xaxis_text=QmatNMR.handles(2);
	x_num=QmatNMR.handles(3);
	x_num2=QmatNMR.handles(4);
	y_text=QmatNMR.handles(5);
	y_num=QmatNMR.handles(6); 
	y_num2=QmatNMR.handles(7); 
	int_text=QmatNMR.handles(8);
	int_num=QmatNMR.handles(9);
	frame=QmatNMR.handles(10);

	set(QmatNMR.Fig2D3D,'WindowButtonDownFcn',' ', 'WindowButtonMotionFcn',' ', 'WindowButtonUpFcn',' ', 'pointer', 'arrow');
        delete([xaxis_text x_num x_num2 y_text y_num y_num2 int_text int_num frame]);

        delete(findobj(allchild(gcf), 'tag', 'crsshairplots1'));
        delete(findobj(allchild(gcf), 'tag', 'crsshairplots2'));
end

