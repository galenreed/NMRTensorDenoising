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
%defpeaksSD.m asks the user to mark all peaks in the current 2D spectrum before solvent deconvolution is started
%19-03-2007

try
  disp('matNMR Notice: Please define all peak areas by clicking on the mouse button on the left and right of it');
  disp('matNMR Notice: by clicking outside the axis the function stops and you can continue');
  disp('matNMR Notice: If no peak areas are defined then the entire spectrum is predicted.');
  figure(QmatNMR.Fig);
  
  %get the axis handle
  QmatNMR.TEMPAxis = gca;
  
  QTEMPuicontextFlag = get(QmatNMR.TEMPAxis, 'uicontextmenu');
  if (~isempty(QTEMPuicontextFlag))	%Switch context menu off if it exists
    set(QmatNMR.TEMPAxis, 'uicontextmenu', '');
  end
  QTEMPzoomFlag = get(QmatNMR.h41, 'Value');
  if (QTEMPzoomFlag)		%Switch 1D zoom off if it is turned on
    switchzoomoff
  end
  
  				%delete previous lines from defpeaksSD.m
  delete(findobj(allchild(QmatNMR.TEMPAxis), 'tag', 'SDPeaks'))
  
  %
  %Now create the projection on the other dimension and plot it
  %
  cla
  if QmatNMR.Dim == 1
    QmatNMR.dual = Qview90(abs(QmatNMR.Spec2D));
    QTEMPaxis = QmatNMR.AxisTD1;
    QTEMPincr = QmatNMR.Rincr2;
    QTEMPnull = QmatNMR.Rnull2;
    QTEMPdim = QmatNMR.SizeTD1;
    QTEMPFIDstatus = QmatNMR.FIDstatus2D2;
  
  else
    QmatNMR.dual = Qview0(abs(QmatNMR.Spec2D));
    QTEMPaxis = QmatNMR.AxisTD2;
    QTEMPincr = QmatNMR.Rincr1;
    QTEMPnull = QmatNMR.Rnull1;
    QTEMPdim = QmatNMR.SizeTD2;
    QTEMPFIDstatus = QmatNMR.FIDstatus2D1;
  end
  
  %the plot direction is determined by the increment of the axis vector AND whether we're dealing with an FID or a spectrum
  if (QTEMPincr > 0)
    QTEMP1 = plot(QTEMPaxis, QmatNMR.dual, QmatNMR.color(3));
  else
    QTEMP1 = plot(fliplr(QTEMPaxis), fliplr(QmatNMR.dual), QmatNMR.color(3));
  end
  
  set(QmatNMR.TEMPAxis, 'FontSize', QmatNMR.TextSize, ...
         'FontName', QmatNMR.TextFont, ...
         'FontAngle', QmatNMR.TextAngle, ...
         'FontWeight', QmatNMR.TextWeight, ...
         'LineWidth', QmatNMR.LineWidth, ...
         'Color', QmatNMR.ColorScheme.AxisBack, ...
         'xcolor', QmatNMR.ColorScheme.AxisFore, ...
         'ycolor', QmatNMR.ColorScheme.AxisFore, ...
         'zcolor', QmatNMR.ColorScheme.AxisFore, ...
         'box', 'on', ...
         'userdata', 1, ...
         'tag', 'MainAxis', ...
         'view', [0 90], ...
         'visible', 'on', ...
         'xscale', 'linear', ...
         'yscale', 'linear', ...
         'zscale', 'linear', ...
         'xticklabelmode', 'auto', ...
         'yticklabelmode', 'auto', ...
         'zticklabelmode', 'auto', ...
         'selected', 'off', ...
         'ydir', 'normal', ...
         'zdir', 'normal', ...
         'XDir', QmatNMR.AxisPlotDirection);		%CheckAxis.m determines whether the direction should be normal or reverse
  
  if ((QTEMPFIDstatus == 1) & (QTEMPincr > 0))	%is this a spectrum with a positive axis increment?
    set(QmatNMR.TEMPAxis, 'xdir', 'reverse')
  else						%no, it's an FID or a spectrum with a negative axis increment
    set(QmatNMR.TEMPAxis, 'xdir', 'normal')
  end
  
  set(QTEMP1, 'tag', 'SDProjectionDisp');
  QTEMPmin = min(QmatNMR.dual);
  QTEMPmax = max(QmatNMR.dual);
  QTEMPtotaal = QTEMPmax - QTEMPmin;
  axis([sort(QTEMPaxis([1 end])) QTEMPmin QTEMPmax]);
  title('Please specify the regions of interest by left-clicking in the plot ...', 'Color', QmatNMR.ColorScheme.AxisFore)
  
  
  %
  %ask for peaks
  %
  QmatNMR.Error = 0;
  QmatNMR.ButSoort = 1;
  QmatNMR.PiekTeller = 0;
  QmatNMR.NumPeaks = 0;
  QmatNMR.SDPeakList = [];
  QmatNMR.SDPeakListIndices = [];
  
  while ((~QmatNMR.Error) & (QmatNMR.ButSoort == 1))
    [QmatNMR.xpos, QmatNMR.ypos, QmatNMR.ButSoort] = ginput(1);
    QmatNMR.Error = pk_inbds(QmatNMR.xpos, QmatNMR.ypos);		%See whether button was pushed inside the axis !
    QmatNMR.PiekTeller = QmatNMR.PiekTeller + 1;
  
    QTEMP(QmatNMR.PiekTeller) = round( (QmatNMR.xpos-QTEMPnull)/QTEMPincr );%Check whether the point is not outside the vectors
    if (QTEMP(QmatNMR.PiekTeller) < 1)			%actual length....
      QTEMP(QmatNMR.PiekTeller) = 1;
    end
    if (QTEMP(QmatNMR.PiekTeller) > QTEMPdim)
      QTEMP(QmatNMR.PiekTeller) = QTEMPdim;
    end
  
    if ((~ QmatNMR.Error) & (QmatNMR.ButSoort == 1)) 
      hold on
      QTEMP22 = axis;
      QmatNMR.PlotHandle = plot([QTEMPaxis(QTEMP(QmatNMR.PiekTeller)) QTEMPaxis(QTEMP(QmatNMR.PiekTeller))], [(QTEMP22(3)-3*QTEMP22(4)) (QTEMP22(3)+4*QTEMP22(4))], 'r--');
      hold off
      set(QmatNMR.PlotHandle, 'tag', 'SDPeaks');
      set(QmatNMR.TEMPAxis, 'tag', 'MainWindow');
  
      if (QmatNMR.PiekTeller == 2)			%Two positions have been pointed --> peak present !!
        QTEMP = sort(QTEMP);			%Sort assigned positions
        QmatNMR.SDPeakListIndices = [QmatNMR.SDPeakListIndices QTEMP(1) QTEMP(2)];
        QmatNMR.SDPeakList = [QmatNMR.SDPeakList QTEMP(1):QTEMP(2)];
        if (QTEMPincr > 0)				%ascending axis
          QTEMP2 = QTEMPaxis(QTEMP(1)):QTEMPaxis(QTEMP(2));	%create a raster area in the current plot
        else
          QTEMP2 = QTEMPaxis(QTEMP(2)):QTEMPaxis(QTEMP(1));	%create a raster area in the current plot
        end
  	
        if length(QTEMP2) > 15
          QTEMP7 = round(length(QTEMP2)/15);
  	if (QTEMPincr > 0)				%ascending axis
            QTEMP2 = QTEMPaxis(QTEMP(1)):0.1:QTEMP7:QTEMPaxis(QTEMP(2));
  	else  
            QTEMP2 = QTEMPaxis(QTEMP(2)):0.1:QTEMP7:QTEMPaxis(QTEMP(1));
  	end  
        end;  
        QTEMP3 = (QTEMPmin-QTEMPtotaal):(3*QTEMPtotaal/10):(QTEMPmin+2*QTEMPtotaal);	%length is always 11 points
        %
        %sometimes rounding errors can make this vector be only 10 points long. So we
        %ensure it is always 11 points by setting the 11th point to the final value
        %
        QTEMP3(11) = (QTEMPmin+2*QTEMPtotaal);
        QTEMP4 = [];						%x-coordinates for raster
        QTEMP5 = [];						%y-coordinates for raster
        for QTEMP40=1:11
          QTEMP4((QTEMP40-1)*length(QTEMP2)+1:(QTEMP40*length(QTEMP2))) = QTEMP2;
        end;  
        for QTEMP40=1:length(QTEMP2)
          QTEMP5((QTEMP40-1)*11+1:(QTEMP40*11)) = QTEMP3;
        end
        QTEMP6 = line(QTEMP4, QTEMP5);
        set(QTEMP6, 'linestyle', ':', 'color', 'r', 'tag', 'SDPeaks');
        
        QmatNMR.NumPeaks = QmatNMR.NumPeaks + 1;
        QmatNMR.PiekTeller = 0;
      end
  
    else
      						%All peaks have been entered ...
      if QmatNMR.NumPeaks > 0
        QmatNMR.SDPeakList = sort(QmatNMR.SDPeakList);
      end
  
      fprintf(1, '\nDefining peak areas finished: %d areas with peaks were assigned\n', QmatNMR.NumPeaks);
    end  
  end
  
  %restore the title
  title(strrep(QmatNMR.LastVariableNames2D(1).Spectrum, '_', '\_'), 'Color', QmatNMR.ColorScheme.AxisFore);
  
  if (QTEMPzoomFlag)		%Switch 1D zoom on if it was turned on before this routine
    switchzoomon
  end
  
  drawnow
  if (~isempty(QTEMPuicontextFlag))   %Switch context menu on if it existed before
    set(QmatNMR.TEMPAxis, 'uicontextmenu', QTEMPuicontextFlag);
  end
  
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
