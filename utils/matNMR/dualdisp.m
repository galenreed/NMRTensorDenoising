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
%dualdisp.m shows a second spectrum on top of the original one in magenta.
%9-8-'96

try
  if QmatNMR.buttonList == 1						%= OK-button
    watch;
  
    %get the axis handle
    QmatNMR.TEMPAxis = gca;
  
  
    if isempty(QmatNMR.uiInput1)				%prevent an empty string and ugly messages
      disp('matNMR WARNING: no spectrum/FID given. Please try again.');
      asknamedual
      return
    end
  
    [QmatNMR.SpecNameProc QmatNMR.CheckInput] = checkinput(QmatNMR.uiInput1);	%adjust the format of the input expression for later use
    QmatNMR.newinlist.Spectrum = QmatNMR.uiInput1;		%define the name of the variable and axis vector
    if (QmatNMR.PlotType == 2) 		%for horizontal stackplot there is no axis variable defined!
      QmatNMR.newinlist.Axis = '';
    else
      QmatNMR.newinlist.Axis = QmatNMR.uiInput2;			%for putinlist1d.m
    end
    putinlist1d;					%put name in list of last 10 variables if it is new
    
  %read in variable(s) depending on the datatype. The expression given by the user is checked for variables and
  %functions (that are assumed to give proper results). The 1D data matrix is constructed from this information depending on whether
  %the variable is a structure or not (matNMR datatype). The axis is only read in from a structure
  %if the variable QmatNMR.numbvars is 1 !!
  %
    QmatNMR.LastDualAxis = QmatNMR.uiInput2;
    
    if (QmatNMR.PlotType == 5) 	%for errorbar plot we need to evaluate the input in checkinputdual!
      %
      %What are the error bars?
      %
      QmatNMR.Q1DErrorBarsDual = QmatNMR.uiInput3;
    end
    checkinputdual
  
    %
    %in case an error has occurred.
    %
    if (QmatNMR.BREAK == 1)
      QmatNMR.BREAK = 0;
      return
    end
  
    if ((QmatNMR.PlotType == 2) | (QmatNMR.PlotType == 3)) 	%horizontal and vertical stack plots
      %
      %check whether the size of the new matrix is the same as that of the current 2D spectrum
      %
      if ~((QmatNMR.dualSizeTD1 == QmatNMR.SizeTD1) & (QmatNMR.dualSizeTD2 == QmatNMR.SizeTD2))
        disp('matNMR WARNING: for dual display of horizontal stack plot the matrix size MUST be the ');
        disp('matNMR WARNING: same as that of the current 2D spectrum. Aborting ...');
        return
      end
    end
  
    switch (QmatNMR.PlotType)
      case 1		%the default plot type
        %what type of scaling is asked for
        QmatNMR.LastDualType = QmatNMR.uiInput3; 
      
      
        QmatNMR.dimDualSpec = length(QmatNMR.dual);				%QmatNMR.dimDualSpec is the length of QmatNMR.dual, ie the spectrum
        QmatNMR.dimDualAxis = length(QmatNMR.dualaxis);			%QmatNMR.dimDualAxis is the length of the axis vector
        if (QmatNMR.dimDualAxis == QmatNMR.dimDualSpec)
          %
          %Now see whether the axis is ascending or descending
          %  
          CheckAxisDual
        
        
          %
          %Define the intensity of the new line
          %
          if (QmatNMR.LastDualType==1)			%equal integral --> take sum of real parts and multiply by the increment in the
          					%axis vector and divide by the number of points in the vector
            QTEMP9 = abs( (sum(real(QmatNMR.Spec1DPlot))*abs(QmatNMR.Axis1D(2)-QmatNMR.Axis1D(1))) / (sum(real(QmatNMR.dual))*abs(QmatNMR.dualaxis(2)-QmatNMR.dualaxis(1)))  );
            fprintf(1, '\nScaling for equal-integral dual display: %8.8f (or 1/%8.8f)\n', QTEMP9, 1/QTEMP9);
            QmatNMR.dual = QmatNMR.dual * QTEMP9;
      
          elseif (QmatNMR.LastDualType == 3)			%original intensity
            QmatNMR.dual = QmatNMR.dual;
          
          elseif (QmatNMR.LastDualType == 2)			%same maximum for both vectors
            if (QmatNMR.DisplayMode == 1)	%display mode is 'real'
              QTEMP9 = abs(max(real(QmatNMR.Spec1DPlot)) / max(real(QmatNMR.dual)));
            
            elseif (QmatNMR.DisplayMode == 2)	%display mode is 'imaginary'
              QTEMP9 = abs(max(imag(QmatNMR.Spec1DPlot)) / max(imag(QmatNMR.dual)));
            
            elseif (QmatNMR.DisplayMode == 3)	%display mode is 'both'
              QTEMP9 = abs(max([real(QmatNMR.Spec1DPlot) imag(QmatNMR.Spec1DPlot)]) / max([real(QmatNMR.dual) imag(QmatNMR.dual)]));
            
            
            elseif (QmatNMR.DisplayMode == 4)	%display mode is 'absolute'
              QTEMP9 = abs(max(abs(QmatNMR.Spec1DPlot)) / max(abs(QmatNMR.dual)));
            
            
            elseif (QmatNMR.DisplayMode == 5)	%display mode is 'power'
              QTEMP9 = abs(max(abs(QmatNMR.Spec1DPlot).^2) / max(abs(QmatNMR.dual).^2));
            end
            QmatNMR.dual = QmatNMR.dual * QTEMP9;
            fprintf(1, '\nScaling for equal-maximum dual display: %8.8f (or 1/%8.8f)\n', QTEMP9, 1/QTEMP9);
      
          else
            disp('matNMR WARNING: input for intensity not valid, dual display cancelled!');
            return
          end
      
      
      
      %
      %plot the new spectrum in the existing plot
      %
          hold on
          eval(['QTEMP = ' QmatNMR.DualPlotCommand]);
          set(QTEMP, 'LineWidth', QmatNMR.LineWidth, 'MarkerSize', QmatNMR.MarkerSize, 'buttondownfcn', 'MoveLine', ...
                     'hittest', 'on', 'Tag', QmatNMR.uiInput1);
          set(QmatNMR.TEMPAxis, 'nextplot', 'replacechildren');
      
          
          %
          %update the width of the plot to accomodate all spectra
          %
          axis auto
  
          %x-limit
          QTEMP1 = min([QmatNMR.xmin QmatNMR.dualaxis]);
          QmatNMR.totaalX = max([(QmatNMR.xmin+QmatNMR.totaalX) QmatNMR.dualaxis]) - QTEMP1;
          QmatNMR.xmin = QTEMP1;
  
          %y-limit
          QmatNMR.Ylimiet = get(gca, 'YLim');
          QmatNMR.minY = QmatNMR.Ylimiet(1,1);
          QmatNMR.maxY = QmatNMR.Ylimiet(1,2);
        
          QmatNMR.ymin = QmatNMR.minY;
          QmatNMR.totaalY = QmatNMR.maxY - QmatNMR.minY;
          if (abs(QmatNMR.totaalY) < eps^2)
            QmatNMR.ymin = QmatNMR.ymin - 1;
            QmatNMR.totaalY = 2;	      %to prevent Matlab from showing nothing
          end
  
          axis([QmatNMR.xmin (QmatNMR.xmin+QmatNMR.totaalX) QmatNMR.ymin (QmatNMR.ymin+QmatNMR.totaalY)]);
          %
          %set the axis limits properly and also set the ApplicationData such that the zoom function uses the new values
          %
          setappdata(QmatNMR.TEMPAxis, 'ZoomLimitsMatNMR', [QmatNMR.xmin (QmatNMR.xmin+QmatNMR.totaalX) QmatNMR.ymin (QmatNMR.ymin+QmatNMR.totaalY)]);
      
          
          %
          %update the counter for the number of spectra in the current plot
          %
          QmatNMR.nrspc = QmatNMR.nrspc + 1; 
          
          disp(['Dual display finished: ' QmatNMR.uiInput1 ' added (' num2str(QmatNMR.nrspc) ' spectra in the current figure)']);
      
        else
          if (QmatNMR.dimDualSpec == QmatNMR.Size1D)
            disp('matNMR WARNING: the size of the second variable should be the same as the current spectrum if no axis is supplied!');
            disp('matNMR WARNING: dual display aborted.')
            return
      
          else
            disp('matNMR WARNING: the size of the second variable should be the same as the supplied axis variable!');
            disp('matNMR WARNING: dual display aborted.')
            return
          end  
        end
  
  
      case 2			%horizontal stack plot
        %
        %what type of scaling is asked for
        %
        QmatNMR.LastDualType = QmatNMR.uiInput2; 
  
        hold on			      %set the hold state to on
        
        
        %
        %Now we create the dual plot by using exactly the same indices as used for the original
        %matrix.
        %
        %NOTE: THIS REQUIRES THAT THE INDICES DO NOT CHANGE IN BETWEEN. CURRENTLY ONLY THE STACK1D
        %ROUTINE USES THESE VARIABLES!
        %
        if (QmatNMR.Dim == 1)	      %current dimension = TD2
          %
          %We need to flip the spectrum according to the axis increment and the FIDstatus
          %Also, extract the part we need, based on the current zoom limits
          %
          if (QmatNMR.FIDstatus == 1)			%means it's a spectrum
            if (QmatNMR.Rincr > 0)			%ascending axis
              QTEMP1 = QmatNMR.dual;
              QmatNMR.num10 = QTEMP1(1:QmatNMR.num2, QmatNMR.num4:(QmatNMR.num4+QmatNMR.num3)).';	%these are the data points we want to show
            
            else						%descending axis
              QTEMP1 = QmatNMR.dual;
              QmatNMR.num10 = QTEMP1(1:QmatNMR.num2, QmatNMR.num4:(QmatNMR.num4+QmatNMR.num3)).';	%these are the data points we want to show
            end  
          
          else						%it's an FID
            if (QmatNMR.Rincr > 0)			%ascending axis
              QTEMP1 = fliplr(QmatNMR.dual);
              QmatNMR.num10 = QTEMP1(1:QmatNMR.num2, sort(QmatNMR.Size1D + 1 - (QmatNMR.num4:(QmatNMR.num4+QmatNMR.num3)))).';	%these are the data points we want to show
            
            else						%descending axis
              QTEMP1 = QmatNMR.dual;
              QmatNMR.num10 = QTEMP1(1:QmatNMR.num2, QmatNMR.num4:(QmatNMR.num4+QmatNMR.num3)).';	%these are the data points we want to show
            end  
          end  
          QmatNMR.num10( (QmatNMR.num3+2):(QmatNMR.num3+1+QmatNMR.num9), :) = NaN + sqrt(-1)*NaN;	%these are the extra points as NaN
  
        else			      %current dimension = TD1
          %
          %We need to flip the spectrum according to the axis increment and the FIDstatus
          %Also, extract the part we need, based on the current zoom limits
          %
          if (QmatNMR.FIDstatus == 1)			%means it's a spectrum
            if (QmatNMR.Rincr > 0)			%ascending axis
              QTEMP1 = QmatNMR.dual;
              QmatNMR.num10 = QTEMP1(QmatNMR.num4:(QmatNMR.num4+QmatNMR.num3), 1:QmatNMR.num2);      %these are the data points we want to show
            
            else						%descending axis
              QTEMP1 = QmatNMR.dual;
              QmatNMR.num10 = QTEMP1(QmatNMR.num4:(QmatNMR.num4+QmatNMR.num3), 1:QmatNMR.num2);      %these are the data points we want to show
            end  
          
          else						%it's an FID
            if (QmatNMR.Rincr > 0)			%ascending axis
              QTEMP1 = flipud(QmatNMR.dual);
              QmatNMR.num10 = QTEMP1(sort(QmatNMR.Size1D + 1 - (QmatNMR.num4:(QmatNMR.num4+QmatNMR.num3))), 1:QmatNMR.num2);      %these are the data points we want to show
            
            else						%descending axis
              QTEMP1 = QmatNMR.dual;
              QmatNMR.num10 = QTEMP1(QmatNMR.num4:(QmatNMR.num4+QmatNMR.num3), 1:QmatNMR.num2);      %these are the data points we want to show
            end  
          end  
          QmatNMR.num10( (QmatNMR.num3+2):(QmatNMR.num3+1+QmatNMR.num9), :) = NaN + sqrt(-1)*NaN;      	%these are the extra points as NaN
          QTEMP1 = [];
        end
        QmatNMR.dual = reshape(fliplr(QmatNMR.num10), 1, QmatNMR.num);
  
        %
        %Define the intensity of the new line
        %
        if (QmatNMR.LastDualType==1)		      %equal integral --> take sum of real parts and multiply by the increment in the
  					      %axis vector and divide by the number of points in the vector
          QTEMP8 = isfinite(QmatNMR.Stack1DHorizontalSpec);
  	QTEMP9 = abs( (sum(real(QmatNMR.Stack1DHorizontalSpec(QTEMP8)))*abs(QmatNMR.Axis1D(2)-QmatNMR.Axis1D(1))) / (sum(real(QmatNMR.dual(QTEMP8)))*abs(QmatNMR.dualaxis(2)-QmatNMR.dualaxis(1)))  );
  	fprintf(1, '\nScaling for equal-integral dual display: %8.8f (or 1/%8.8f)\n', QTEMP9, 1/QTEMP9);
  	QmatNMR.dual = QmatNMR.dual * QTEMP9;
    
        elseif (QmatNMR.LastDualType == 3)		      %original intensity
  	QmatNMR.dual = QmatNMR.dual;
        
        elseif (QmatNMR.LastDualType == 2)		      %same maximum for both vectors
  	if (QmatNMR.DisplayMode == 3)        %display mode is 'both'
  	  QTEMP9 = abs(max([real(QmatNMR.Stack1DHorizontalSpec) imag(QmatNMR.Stack1DHorizontalSpec)]) / max([real(QmatNMR.dual) imag(QmatNMR.dual)]));
  	  QmatNMR.dual = QmatNMR.dual * QTEMP9;
  	
  	else
  	  QTEMP9 = abs(max(real(QmatNMR.Stack1DHorizontalSpec)) / max(real(QmatNMR.dual)));
  	  QmatNMR.dual = QmatNMR.dual * QTEMP9;
  	end
  	fprintf(1, '\nScaling for equal-maximum dual display: %8.8f (or 1/%8.8f)\n', QTEMP9, 1/QTEMP9);
    
        else
  	disp('matNMR WARNING: input for intensity not valid, dual display cancelled!');
  	return
        end
  
  
        %
        %Plot
        %
        QmatNMR.dualaxisPlot = 1:QmatNMR.num;	%set the same dummy axis as in the original routine
        eval(['QTEMP = ' QmatNMR.DualPlotCommand]);
        set(QTEMP, 'LineWidth', QmatNMR.LineWidth, 'MarkerSize', QmatNMR.MarkerSize, 'buttondownfcn', 'MoveLine', ...
                   'hittest', 'on', 'Tag', QmatNMR.uiInput1);
    
    
        %
        %set the hold state back to replace the axis children
        %
        set(QmatNMR.TEMPAxis, 'nextplot', 'replacechildren');
      
          
        %
        %update the width of the plot to accomodate all spectra
        %
        axis auto
  
        %x-limit
        %For special plot types only the matrix is taken, not the axes, and it should be exactly
        %the same size as the original 2D matrix from which the special plot was made
        %
  
        %y-limit
        QmatNMR.Ylimiet = get(gca, 'YLim');
        QmatNMR.minY = QmatNMR.Ylimiet(1,1);
        QmatNMR.maxY = QmatNMR.Ylimiet(1,2);
       
        QmatNMR.ymin = QmatNMR.minY;
        QmatNMR.totaalY = QmatNMR.maxY - QmatNMR.minY;
        if (abs(QmatNMR.totaalY) < eps^2)
          QmatNMR.ymin = QmatNMR.ymin - 1;
          QmatNMR.totaalY = 2;        %to prevent Matlab from showing nothing
        end
  
        axis([QmatNMR.xmin (QmatNMR.xmin+QmatNMR.totaalX) QmatNMR.ymin (QmatNMR.ymin+QmatNMR.totaalY)]);
        %
        %set the axis limits properly and also set the ApplicationData such that the zoom function uses the new values
        %
        setappdata(QmatNMR.TEMPAxis, 'ZoomLimitsMatNMR', [QmatNMR.xmin (QmatNMR.xmin+QmatNMR.totaalX) QmatNMR.ymin (QmatNMR.ymin+QmatNMR.totaalY)]);
  
    
        %
        %update the counter for the number of spectra in the current plot
        %
        QmatNMR.nrspc = QmatNMR.nrspc + 1; 
          
        disp(['Dual display of horizontal Stack plot finished: ' QmatNMR.uiInput1 ' added (' num2str(QmatNMR.nrspc) ' spectra in the current figure)']);
  
  
      case 3			%vertical stack plot
        QTEMP4 = eval(QmatNMR.VerticalStackRange); 		%range of vertical stack plot
        QTEMP5 = eval(QmatNMR.VerticalStackDisplacement); 	%displacement factor, relative to current y-range (QmatNMR.ymin+QmatNMR.totaalY)
    
        hold on			      %set the hold state to on
  
        %
        %Now see whether the axis is ascending or descending
        %  
%        CheckAxisDual
  
        if (QmatNMR.Dim == 1)	      %current dimension = TD2
  	for QTEMP6 = 1:length(QTEMP4)
  	  QTEMP7 = strrep(QmatNMR.PlotCommand, 'QmatNMR.Spec1DPlot', ['QmatNMR.dual(QTEMP4(QTEMP6), :) - (1+sqrt(-1))*QTEMP5*(QTEMP6-1)*QmatNMR.VerticalStacktotaalY']);
            eval(['QTEMP8 = ' QTEMP7])
    
  	  set(QTEMP8, 'LineWidth', QmatNMR.LineWidth, 'MarkerSize', QmatNMR.MarkerSize, 'buttondownfcn', ...
  	     'MoveLine', 'hittest', 'on', 'Tag', QmatNMR.LineTag, 'color', QmatNMR.color(rem(QmatNMR.nrspc, length(QmatNMR.color)) + 1));
  	end
        else			      %current dimension = TD1
          for QTEMP6 = 1:length(QTEMP4)
            QTEMP7 = strrep(QmatNMR.PlotCommand, 'QmatNMR.Spec1DPlot', ['QmatNMR.dual(:, QTEMP4(QTEMP6)).'' - (1+sqrt(-1))*QTEMP5*(QTEMP6-1)*QmatNMR.VerticalStacktotaalY']);
            eval(['QTEMP8 = ' QTEMP7])
    
  	  set(QTEMP8, 'LineWidth', QmatNMR.LineWidth, 'MarkerSize', QmatNMR.MarkerSize, 'buttondownfcn', ...
  	     'MoveLine', 'hittest', 'on', 'Tag', QmatNMR.LineTag, 'color', QmatNMR.color(rem(QmatNMR.nrspc, length(QmatNMR.color)) + 1));
          end
        end
    
    
        %
        %set the hold state back to replace the axis children
        %
        set(QmatNMR.TEMPAxis, 'nextplot', 'replacechildren');
      
          
        %
        %update the width of the plot to accomodate all spectra
        %
        axis auto
  
        %x-limit
        %For special plot types only the matrix is taken, not the axes, and it should be exactly
        %the same size as the original 2D matrix from which the special plot was made
        %
  
        %y-limit
        QmatNMR.Ylimiet = get(gca, 'YLim');
        QmatNMR.minY = QmatNMR.Ylimiet(1,1);
        QmatNMR.maxY = QmatNMR.Ylimiet(1,2);
       
        QmatNMR.ymin = QmatNMR.minY;
        QmatNMR.totaalY = QmatNMR.maxY - QmatNMR.minY;
        if (abs(QmatNMR.totaalY) < eps^2)
          QmatNMR.ymin = QmatNMR.ymin - 1;
          QmatNMR.totaalY = 2;        %to prevent Matlab from showing nothing
        end
  
        axis([QmatNMR.xmin (QmatNMR.xmin+QmatNMR.totaalX) QmatNMR.ymin (QmatNMR.ymin+QmatNMR.totaalY)]);
        %
        %set the axis limits properly and also set the ApplicationData such that the zoom function uses the new values
        %
        setappdata(QmatNMR.TEMPAxis, 'ZoomLimitsMatNMR', [QmatNMR.xmin (QmatNMR.xmin+QmatNMR.totaalX) QmatNMR.ymin (QmatNMR.ymin+QmatNMR.totaalY)]);
  
    
        %
        %update the counter for the number of spectra in the current plot
        %
        QmatNMR.nrspc = QmatNMR.nrspc + 1; 
          
        disp(['Dual display of vertical Stack plot finished: ' QmatNMR.uiInput1 ' added (' num2str(QmatNMR.nrspc) ' spectra in the current figure)']);
  
      
      case 4		%1D bar plots
        %
        %what type of scaling is asked for
        %
        QmatNMR.LastDualType = QmatNMR.uiInput3; 
        %
        %what width and colours are asked for?
        %
        QmatNMR.Q1DBarWidthDual  = eval(QmatNMR.uiInput4);
        QmatNMR.Q1DBarColourDual = QmatNMR.uiInput5;
        QmatNMR.Q1DBarEdges = QmatNMR.uiInput6;
  
  
        QmatNMR.dimDualSpec = length(QmatNMR.dual);				%QmatNMR.dimDualSpec is the length of QmatNMR.dual, ie the spectrum
        QmatNMR.dimDualAxis = length(QmatNMR.dualaxis);				%QmatNMR.dimDualAxis is the length of the axis vector
        if (QmatNMR.dimDualAxis == QmatNMR.dimDualSpec)
          %
          %Now see whether the axis is ascending or descending
          %  
          CheckAxisDual
        
        
        %
        %Define the intensity of the new line
        %
        if (QmatNMR.LastDualType==1)		      %equal integral --> take sum of real parts and multiply by the increment in the
  					      %axis vector and divide by the number of points in the vector
  	QTEMP9 = abs( (sum(real(QmatNMR.Spec1DPlot))*abs(QmatNMR.Axis1D(2)-QmatNMR.Axis1D(1))/QmatNMR.Size1D) / (sum(real(QmatNMR.dual))*abs(QmatNMR.dualaxis(2)-QmatNMR.dualaxis(1))/QmatNMR.dimDualAxis)  );
  	fprintf(1, '\nScaling for equal-integral dual display: %8.8f (or 1/%8.8f)\n', QTEMP9, 1/QTEMP9);
  	QmatNMR.dual = QmatNMR.dual * QTEMP9;
    
        elseif (QmatNMR.LastDualType == 3)		      %original intensity
  	QmatNMR.dual = QmatNMR.dual;
        
        elseif (QmatNMR.LastDualType == 2)		      %same maximum for both vectors
  	if (QmatNMR.DisplayMode == 3)        %display mode is 'both'
  	  QTEMP9 = abs(max([real(QmatNMR.Spec1DPlot) imag(QmatNMR.Spec1DPlot)]) / max([real(QmatNMR.dual) imag(QmatNMR.dual)]));
  	  QmatNMR.dual = QmatNMR.dual * QTEMP9;
  	
  	else
  	  QTEMP9 = abs(max(real(QmatNMR.Spec1DPlot)) / max(real(QmatNMR.dual)));
  	  QmatNMR.dual = QmatNMR.dual * QTEMP9;
  	end
  	fprintf(1, '\nScaling for equal-maximum dual display: %8.8f (or 1/%8.8f)\n', QTEMP9, 1/QTEMP9);
    
        else
  	disp('matNMR WARNING: input for intensity not valid, dual display cancelled!');
  	return
        end
  
  
      %
      %plot the new spectrum in the existing plot taking into account the current display mode
      %
          hold on
          QTEMP9 = str2mat(' ', 'r', 'g', 'b', 'y', 'm', 'c', 'k', 'w');
  
          if (QmatNMR.DisplayMode == 1)			%Real spectrum
            QTEMP67 = bar(QmatNMR.dualaxisPlot, real(QmatNMR.dual), QmatNMR.Q1DBarWidthDual, deblank(QTEMP9(QmatNMR.Q1DBarColourDual, :)));
        
          elseif (QmatNMR.DisplayMode == 2)		%Imaginary spectrum
            QTEMP67 = bar(QmatNMR.dualaxisPlot, imag(QmatNMR.dual), QmatNMR.Q1DBarWidthDual, deblank(QTEMP9(QmatNMR.Q1DBarColourDual, :)));
        
          elseif (QmatNMR.DisplayMode == 4)		%Absolute spectrum
            QTEMP67 = bar(QmatNMR.dualaxisPlot, abs(QmatNMR.dual), QmatNMR.Q1DBarWidthDual, deblank(QTEMP9(QmatNMR.Q1DBarColourDual, :)));
        
          elseif (QmatNMR.DisplayMode == 5)		%Power spectrum
            QTEMP67 = bar(QmatNMR.dualaxisPlot, abs(QmatNMR.dual).^2, QmatNMR.Q1DBarWidthDual, deblank(QTEMP9(QmatNMR.Q1DBarColourDual, :)));
          end
    
      %
      %set the edge color the same as the face color, if asked for
      %
          if (QmatNMR.Q1DBarEdges)
            set(QTEMP67, 'edgecolor', get(QTEMP67, 'facecolor'));
          end

  
          set(QmatNMR.TEMPAxis, 'nextplot', 'replacechildren');
      
          
          %
          %update the width of the plot to accomodate all spectra
          %
          axis auto
    
          %x-limit
          %For special plot types only the matrix is taken, not the axes, and it should be exactly
          %the same size as the original 2D matrix from which the special plot was made
          %
    
          %y-limit
          QmatNMR.Ylimiet = get(gca, 'YLim');
          QmatNMR.minY = QmatNMR.Ylimiet(1,1);
          QmatNMR.maxY = QmatNMR.Ylimiet(1,2);
         
          QmatNMR.ymin = QmatNMR.minY;
          QmatNMR.totaalY = QmatNMR.maxY - QmatNMR.minY;
          if (abs(QmatNMR.totaalY) < eps^2)
            QmatNMR.ymin = QmatNMR.ymin - 1;
            QmatNMR.totaalY = 2;        %to prevent Matlab from showing nothing
          end
    
          axis([QmatNMR.xmin (QmatNMR.xmin+QmatNMR.totaalX) QmatNMR.ymin (QmatNMR.ymin+QmatNMR.totaalY)]);
          %
          %set the axis limits properly and also set the ApplicationData such that the zoom function uses the new values
          %
          setappdata(QmatNMR.TEMPAxis, 'ZoomLimitsMatNMR', [QmatNMR.xmin (QmatNMR.xmin+QmatNMR.totaalX) QmatNMR.ymin (QmatNMR.ymin+QmatNMR.totaalY)]);
      
          
          %
          %update the counter for the number of spectra in the current plot
          %
          QmatNMR.nrspc = QmatNMR.nrspc + 1; 
          
          disp(['Dual display finished: ' QmatNMR.uiInput1 ' added (' num2str(QmatNMR.nrspc) ' spectra in the current figure)']);
      
        else
          if (QmatNMR.dimDualSpec == QmatNMR.Size1D)
            disp('matNMR WARNING: the size of the second variable should be the same as the current spectrum if no axis is supplied!');
            disp('matNMR WARNING: dual display aborted.')
      
          else
            disp('matNMR WARNING: the size of the second variable should be the same as the supplied axis variable!');
            disp('matNMR WARNING: dual display aborted.')
          end  
        end
  
  
      case 5		%errorbar plot
        %
        %the vector of errorbars (see also checkinputdual!)
        %
        QTEMP1 = eval(QmatNMR.Q1DErrorBarsDual2);
  
  
        %
        %what type of scaling is asked for
        %
        QmatNMR.LastDualType = QmatNMR.uiInput4; 
  
  
        %
        %Now check whether the length of the vector is correct. A single number is interpreted
        %as the same error for all points.
        %
        if (length(QTEMP1) == 1)	%a single number has been entered
          QTEMP1 = QTEMP1*ones(1, length(QmatNMR.dual));
      
        else				%check to see if the length is correct
          [QTEMP2, QTEMP3] = size(QTEMP1);
          if ((QTEMP2 ~= 1) & (QTEMP3 ~= 1))	%is this really a 1D vector?
            disp('matNMR WARNING: error bar vector is not a 1D variable! Aborting ...');
            return
          end
      
          if (length(QTEMP1) ~= length(QmatNMR.dual)) 	%check to see if the length is correct
            disp('matNMR WARNING: error bar vector is of incorrect length. Aborting ...');
            return
          end
        end
  
  
        %
        %Start the dual display if the sizes are correct
        %
        QmatNMR.dimDualSpec = length(QmatNMR.dual);			%QmatNMR.dimDualSpec is the length of QmatNMR.dual, ie the spectrum
        QmatNMR.dimDualAxis = length(QmatNMR.dualaxis);			%QmatNMR.dimDualAxis is the length of the axis vector
        if (QmatNMR.dimDualAxis == QmatNMR.dimDualSpec)
          %
          %Now see whether the axis is ascending or descending
          %  
          CheckAxisDual
        
        
        %
        %Define the intensity of the new line
        %
        if (QmatNMR.LastDualType==1)		      %equal integral --> take sum of real parts and multiply by the increment in the
  					      %axis vector and divide by the number of points in the vector
  	QTEMP9 = abs( (sum(real(QmatNMR.Spec1DPlot))*abs(QmatNMR.Axis1D(2)-QmatNMR.Axis1D(1))/QmatNMR.Size1D) / (sum(real(QmatNMR.dual))*abs(QmatNMR.dualaxis(2)-QmatNMR.dualaxis(1))/QmatNMR.dimDualAxis)  );
  	fprintf(1, '\nScaling for equal-integral dual display: %8.8f (or 1/%8.8f)\n', QTEMP9, 1/QTEMP9);
  	QmatNMR.dual = QmatNMR.dual * QTEMP9;
    
        elseif (QmatNMR.LastDualType == 3)		      %original intensity
  	QmatNMR.dual = QmatNMR.dual;
        
        elseif (QmatNMR.LastDualType == 2)		      %same maximum for both vectors
  	if (QmatNMR.DisplayMode == 3)        %display mode is 'both'
  	  QTEMP9 = abs(max([real(QmatNMR.Spec1DPlot) imag(QmatNMR.Spec1DPlot)]) / max([real(QmatNMR.dual) imag(QmatNMR.dual)]));
  	  QmatNMR.dual = QmatNMR.dual * QTEMP9;
  	
  	else
  	  QTEMP9 = abs(max(real(QmatNMR.Spec1DPlot)) / max(real(QmatNMR.dual)));
  	  QmatNMR.dual = QmatNMR.dual * QTEMP9;
  	end
  	fprintf(1, '\nScaling for equal-maximum dual display: %8.8f (or 1/%8.8f)\n', QTEMP9, 1/QTEMP9);
    
        else
  	disp('matNMR WARNING: input for intensity not valid, dual display cancelled!');
  	return
        end
  
  
      %
      %plot the new spectrum in the existing plot taking into account the current display mode
      %
          hold on
          if (QmatNMR.DisplayMode == 1)			%Real spectrum
            errorbarMatNMR(QmatNMR.dualaxisPlot, real(QmatNMR.dual), QTEMP1, [QmatNMR.color(rem(QmatNMR.nrspc, length(QmatNMR.color)) + 1) QmatNMR.MarkerType QmatNMR.LineType])
        
          elseif (QmatNMR.DisplayMode == 2)			%Imaginary spectrum
            errorbarMatNMR(QmatNMR.dualaxisPlot, imag(QmatNMR.dual), QTEMP1, [QmatNMR.color(rem(QmatNMR.nrspc, length(QmatNMR.color)) + 1) QmatNMR.MarkerType QmatNMR.LineType])
        
          elseif (QmatNMR.DisplayMode == 4)			%Absolute spectrum
            errorbarMatNMR(QmatNMR.dualaxisPlot, abs(QmatNMR.dual), QTEMP1, [QmatNMR.color(rem(QmatNMR.nrspc, length(QmatNMR.color)) + 1) QmatNMR.MarkerType QmatNMR.LineType])
        
          elseif (QmatNMR.DisplayMode == 5)			%Power spectrum
            errorbarMatNMR(QmatNMR.dualaxisPlot, abs(QmatNMR.dual).^2, QTEMP1, [QmatNMR.color(rem(QmatNMR.nrspc, length(QmatNMR.color)) + 1) QmatNMR.MarkerType QmatNMR.LineType])
          end
          set(QmatNMR.TEMPAxis, 'nextplot', 'replacechildren');
      
          
          %
          %update the width of the plot to accomodate all spectra
          %
          axis auto
    
          %x-limit
          %For special plot types only the matrix is taken, not the axes, and it should be exactly
          %the same size as the original 2D matrix from which the special plot was made
          %
    
          %y-limit
          QmatNMR.Ylimiet = get(gca, 'YLim');
          QmatNMR.minY = QmatNMR.Ylimiet(1,1);
          QmatNMR.maxY = QmatNMR.Ylimiet(1,2);
         
          QmatNMR.ymin = QmatNMR.minY;
          QmatNMR.totaalY = QmatNMR.maxY - QmatNMR.minY;
          if (abs(QmatNMR.totaalY) < eps^2)
            QmatNMR.ymin = QmatNMR.ymin - 1;
            QmatNMR.totaalY = 2;        %to prevent Matlab from showing nothing
          end
    
          axis([QmatNMR.xmin (QmatNMR.xmin+QmatNMR.totaalX) QmatNMR.ymin (QmatNMR.ymin+QmatNMR.totaalY)]);
          %
          %set the axis limits properly and also set the ApplicationData such that the zoom function uses the new values
          %
          setappdata(QmatNMR.TEMPAxis, 'ZoomLimitsMatNMR', [QmatNMR.xmin (QmatNMR.xmin+QmatNMR.totaalX) QmatNMR.ymin (QmatNMR.ymin+QmatNMR.totaalY)]);
      
          
          %
          %update the counter for the number of spectra in the current plot
          %
          QmatNMR.nrspc = QmatNMR.nrspc + 1; 
          
          disp(['Dual display finished: ' QmatNMR.uiInput1 ' added (' num2str(QmatNMR.nrspc) ' spectra in the current figure)']);
      
        else
          if (QmatNMR.dimDualSpec == QmatNMR.Size1D)
            disp('matNMR WARNING: the size of the second variable should be the same as the current spectrum if no axis is supplied!');
            disp('matNMR WARNING: dual display aborted.')
      
          else
            disp('matNMR WARNING: the size of the second variable should be the same as the supplied axis variable!');
            disp('matNMR WARNING: dual display aborted.')
          end  
        end
  
  
      otherwise
        error('matNMR ERROR: unknown value for QPlotType! Aborting ...')
    end
      
    Arrowhead;
  
  else
    disp('No Dual display performed !');
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
