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
%regelgetcolumn.m takes a column from the current 2D spectrum and plots it as a 2D spectrum.
%24-12-'96

try
  if QmatNMR.buttonList == 1						%= OK-button
    %get the axis handle
    QmatNMR.TEMPAxis = gca;
  
    if (strcmp(QmatNMR.uiInput1, 'end'))
      QmatNMR.uiInput1 = num2str(QmatNMR.SizeTD2, 10);
    end
  
    if ((eval(QmatNMR.uiInput1) > 0) & (eval(QmatNMR.uiInput1) <= QmatNMR.SizeTD2))
      QmatNMR.kolomnr = eval(QmatNMR.uiInput1);
  
      if ((QmatNMR.Dim ~= 2) | (QmatNMR.PlotType ~= 1)) 	%change the scaling if current dimension is TD2 or plot type is not default
        if (QmatNMR.Dim == 0) 	%are we in a 1D mode now?
          SwitchTo2D
        end
        QmatNMR.Dim = 2;
        setfourmode;			%change the Fourier mode button
        
        QmatNMR.FIDstatus = QmatNMR.FIDstatus2D2;	%Is this dimension still an FID ?
        regeldisplaymode
      
        getcurrentspectrum		%get spectrum to show on the screen
      
        QmatNMR.min=0;
        removecurrentline
        QmatNMR.lbstatus = 0;
        QmatNMR.SW1D = QmatNMR.SWTD1;
        QmatNMR.SF1D = QmatNMR.SFTD1;
        QmatNMR.texie = QmatNMR.texie2;
        QmatNMR.RulerXAxis = QmatNMR.RulerXAxis2;
        QmatNMRsettings.DefaultAxisReferencekHz = QmatNMRsettings.DefaultAxisReferencekHz2;
        QmatNMRsettings.DefaultAxisReferencePPM = QmatNMRsettings.DefaultAxisReferencePPM2;
        QmatNMRsettings.DefaultAxisCarrierIndex = QmatNMRsettings.DefaultAxisCarrierIndex2;
  
        QmatNMR.gamma1d = QmatNMR.gamma2;		%set the sign of the gyromagnetic ratio
  
        updatebuttons
        
        QmatNMR.Axis1D = QmatNMR.AxisTD1;
        QmatNMR.Size1D = QmatNMR.SizeTD1;
        if (QmatNMR.RulerXAxis == 0)	%use default axis for plotting of spectra
          GetDefaultAxis
        end
        detaxisprops
  
        Qspcrel;
        CheckAxis;			%checks whether the axis is ascending or descending and adjusts the
  					%plot0direction if necessary
        simpelplot;
        title(strrep(QmatNMR.Spec2DName, '_', '\_'), 'Color', QmatNMR.ColorScheme.AxisFore);
  
        axis auto
        DetermineNewAxisLimits
  
        %reset phase buttons
        QmatNMR.fase1startIndex = floor(QmatNMR.Size1D/2)+1;
        QmatNMR.fase1start = interp1((1:QmatNMR.Size1D).', QmatNMR.Axis1D, QmatNMR.fase1startIndex);
        repair
        
        axis([QmatNMR.xmin (QmatNMR.xmin+QmatNMR.totaalX) QmatNMR.ymin (QmatNMR.ymin+QmatNMR.totaalY)]);
        setappdata(QmatNMR.TEMPAxis, 'ZoomLimitsMatNMR', [QmatNMR.xmin (QmatNMR.xmin+QmatNMR.totaalX) QmatNMR.ymin (QmatNMR.ymin+QmatNMR.totaalY)]);
  
      else
        getcurrentspectrum		%get spectrum to show on the screen
  
        if (QmatNMR.bezigmetfase == 1)
          docurrentphase
        end  
          
        Qspcrel;
        updatebuttons
        CheckAxis;			%checks whether the axis is ascending or descending and adjusts the
  					%plot direction if necessary
        simpelplot;
        axis auto;
        title(strrep(QmatNMR.Spec2DName, '_', '\_'), 'Color', QmatNMR.ColorScheme.AxisFore);
  
        DetermineNewAxisLimits
        axis([QmatNMR.xmin (QmatNMR.xmin+QmatNMR.totaalX) QmatNMR.ymin (QmatNMR.ymin+QmatNMR.totaalY)]);
        setappdata(QmatNMR.TEMPAxis, 'ZoomLimitsMatNMR', [QmatNMR.xmin (QmatNMR.xmin+QmatNMR.totaalX) QmatNMR.ymin (QmatNMR.ymin+QmatNMR.totaalY)]);
      end
  
  						%general actions to be taken
  
      set(gca, 'FontSize', QmatNMR.TextSize, ...
         'FontName', QmatNMR.TextFont, ...
         'FontAngle', QmatNMR.TextAngle, ...
         'FontWeight', QmatNMR.TextWeight, ...
         'box', 'on');
  
      if (QmatNMR.FIDstatus == 1)			%means it's a spectrum
        set(gca, 'XDir', QmatNMR.AxisPlotDirection);	%CheckAxis.m determines whether the direction should be normal or reverse
    
      else					%means it's an FID
        set(gca, 'XDir', 'normal');
      end
  
      if QmatNMR.gridvar 
        set(gca, 'ytickmode', 'auto');
        grid on;
        QmatNMR.gridvar = 1;
        if ~ QmatNMR.yschaal
          set(gca, 'ytick', []);
        end
      else 
        grid off;
        if QmatNMR.yschaal 
          set(gca, 'ytickmode', 'auto');
        else
          set(gca, 'ytick', []);
        end
      end
  
      if QmatNMR.xschaal
        set(gca, 'xtickmode', 'auto');
      else
        set(gca, 'xtick', []);
      end
      
      title(strrep(QmatNMR.Spec1DName, '_', '\_'), 'Color', QmatNMR.ColorScheme.AxisFore);
    else
      disp('ERROR: number of requested column is out of bounds !!!');
    end
    
    set(QmatNMR.h72, 'string', num2str(QmatNMR.kolomnr, 10));
  else
    disp('No changes were made !');
  end

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
