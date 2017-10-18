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
%defpeaks1d.m asks the user to mark all peaks in the current 1D spectrum before the baseline correction
%routine can start.
%20-1-'98

try
  disp('NOTE: please define all peaks by clicking on the mouse button on the left and right of it');
  disp('NOTE: by clicking outside the axis the function stops and you can continue');
  
  QTEMPTargetFigure = QmatNMR.Fig;
  QTEMPTargetAxis = findobj(allchild(QTEMPTargetFigure), 'tag', 'MainAxis');
  
  figure(QTEMPTargetFigure);
  
  QTEMPuicontextFlag = get(QTEMPTargetAxis, 'uicontextmenu');
  if (~isempty(QTEMPuicontextFlag))	%Switch context menu off if it exists
    set(QTEMPTargetAxis, 'uicontextmenu', '');
  end
  QTEMPzoomFlag = get(QmatNMR.h41, 'Value');
  if (QTEMPzoomFlag)		%Switch 1D zoom off if it is turned on
    switchzoomoff
  end
  
	%delete previous lines from defpeaks.m
  try
    delete(findobj(allchild(QTEMPTargetAxis), 'tag', 'BaselinePeaks'))
  end
  
  QmatNMR.Error = 0;
  QmatNMR.ButSoort = 1;
  QmatNMR.PiekTeller = 0;
  QmatNMR.NumPeaks = 0;
  QmatNMR.BaslcorPeakList = [];
  QmatNMR.baslcornoise = [];
  
  while ((~QmatNMR.Error) & (QmatNMR.ButSoort == 1))
    [QmatNMR.xpos, QmatNMR.ypos, QmatNMR.ButSoort] = ginput(1);
    QmatNMR.Error = pk_inbds(QmatNMR.xpos, QmatNMR.ypos);		%See whether button was pushed inside the axis !
    QmatNMR.PiekTeller = QmatNMR.PiekTeller + 1;
  
    QTEMP(QmatNMR.PiekTeller) = round( (QmatNMR.xpos-QmatNMR.Rnull)/QmatNMR.Rincr );%Check whether the point is not outside the vectors
    if (QTEMP(QmatNMR.PiekTeller) < 1)			%actual length....
      QTEMP(QmatNMR.PiekTeller) = 1;
    end
    if (QTEMP(QmatNMR.PiekTeller) > QmatNMR.Size1D)
      QTEMP(QmatNMR.PiekTeller) = QmatNMR.Size1D;
    end
  
    if ((~ QmatNMR.Error) & (QmatNMR.ButSoort == 1)) 
      hold on
      QmatNMR.PlotHandle = plot([QmatNMR.Axis1D(QTEMP(QmatNMR.PiekTeller)) QmatNMR.Axis1D(QTEMP(QmatNMR.PiekTeller))], [(QmatNMR.ymin-3*QmatNMR.totaalY) (QmatNMR.ymin+4*QmatNMR.totaalY)], 'r--');
      hold off
      set(QmatNMR.PlotHandle, 'tag', 'BaselinePeaks');
  
      if (QmatNMR.PiekTeller == 2)			%Two positions have been pointed --> peak present !!
        QTEMP = sort(QTEMP);			%Sort assigned positions
        QmatNMR.BaslcorPeakList = [QmatNMR.BaslcorPeakList QTEMP];
        if (QmatNMR.Rincr > 0)				%ascending axis
          QTEMP2 = QmatNMR.Axis1D(QTEMP(1)):QmatNMR.Axis1D(QTEMP(2));	%create a raster area in the current plot
        else
          QTEMP2 = QmatNMR.Axis1D(QTEMP(2)):QmatNMR.Axis1D(QTEMP(1));	%create a raster area in the current plot
        end
  	
        if length(QTEMP2) > 15
          QTEMP7 = round(length(QTEMP2)/15);
        	if (QmatNMR.Rincr > 0)				%ascending axis
            QTEMP2 = QmatNMR.Axis1D(QTEMP(1)):QTEMP7:QmatNMR.Axis1D(QTEMP(2));
  	     else  
            QTEMP2 = QmatNMR.Axis1D(QTEMP(2)):QTEMP7:QmatNMR.Axis1D(QTEMP(1));
        	end  
        end
        QTEMP3 = (QmatNMR.ymin-3*QmatNMR.totaalY):(7*QmatNMR.totaalY/10):(QmatNMR.ymin+4*QmatNMR.totaalY);	%length is always 11 points
        %
        %sometimes rounding errors can make this vector be only 10 points long. So we
        %ensure it is always 11 points by setting the 11th point to the final value
        %
        QTEMP3(11) = (QmatNMR.ymin+4*QmatNMR.totaalY);
        QTEMP4 = [];						%x-coordinates for raster
        QTEMP5 = [];						%y-coordinates for raster
        for QTEMP40=1:11
          QTEMP4((QTEMP40-1)*length(QTEMP2)+1:(QTEMP40*length(QTEMP2))) = QTEMP2;
        end;  
        for QTEMP40=1:length(QTEMP2)
          QTEMP5((QTEMP40-1)*11+1:(QTEMP40*11)) = QTEMP3;
        end
        QTEMP6 = line(QTEMP4, QTEMP5);
        set(QTEMP6, 'linestyle', ':', 'color', 'r', 'tag', 'BaselinePeaks');
        
        QmatNMR.NumPeaks = QmatNMR.NumPeaks + 1;
        QmatNMR.PiekTeller = 0;
      end
    else
      						%All peaks have been entered ...
      if QmatNMR.NumPeaks > 0
        QmatNMR.BaslcorPeakList = sort(QmatNMR.BaslcorPeakList);
      end
      QmatNMR.BaslcorPeakList = [1 QmatNMR.BaslcorPeakList QmatNMR.Size1D];
      
      for QTEMP40=1:QmatNMR.NumPeaks+1
        QmatNMR.baslcornoise = [QmatNMR.baslcornoise (QmatNMR.BaslcorPeakList((QTEMP40-1)*2+1):QmatNMR.BaslcorPeakList(QTEMP40*2))];
      end  
  
  
      if (QTEMPzoomFlag)		%Switch 1D zoom on if it was turned on before this routine
        switchzoomon
      end
  
      drawnow
      if (~isempty(QTEMPuicontextFlag))	%Switch context menu on if it existed before
        set(QTEMPTargetAxis, 'uicontextmenu', QTEMPuicontextFlag);
      end
  
      
      fprintf(1, '\nDefining peak areas finished: %d areas with peaks were assigned\n', QmatNMR.NumPeaks);
      figure(findobj(allchild(0), 'tag', 'baslcormenufig'));
    end  
  end
  
  %replot
  drawnow
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
