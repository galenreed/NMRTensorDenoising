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
%defpeaksCadzow.m asks the user to mark all peaks in the current 1D spectrum before Cadzow filtering is started
%13-03-2008

try
  disp('matNMR Notice: Please define all peak areas by clicking on the left mouse button. This defines the middle');
  disp('matNMR Notice: of each window used for Cadzow filtering.');
  disp('matNMR Notice: If no peak areas are defined then the entire spectrum is taken.');
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
  
  				%delete previous lines from defpeaksLP.m
  delete(findobj(allchild(QmatNMR.TEMPAxis), 'tag', 'CadzowPeaks'))
  
  
  %
  %ask for peaks
  %
  QmatNMR.Error = 0;
  QmatNMR.ButSoort = 1;
  QmatNMR.CadzowNumPeaks = 0;
  QmatNMR.CadzowWindows = [];
  while ((~QmatNMR.Error) & (QmatNMR.ButSoort == 1))
    [QmatNMR.xpos, QmatNMR.ypos, QmatNMR.ButSoort] = ginput(1);
    QmatNMR.Error = pk_inbds(QmatNMR.xpos, QmatNMR.ypos);		%See whether button was pushed inside the axis !
  
    QTEMP = round( (QmatNMR.xpos-QmatNMR.Rnull)/QmatNMR.Rincr );%Check whether the point is not outside the vectors
    if (QTEMP < 1)			%actual length....
      QTEMP = 1;
    end
    if (QTEMP > QmatNMR.Size1D)
      QTEMP = QmatNMR.Size1D;
    end
    
  
    %
    %indicate the window in the spectrum unless an error has occured
    %
    if ((~ QmatNMR.Error) & (QmatNMR.ButSoort == 1))
      QmatNMR.CadzowNumPeaks = QmatNMR.CadzowNumPeaks + 1;
      
    
      %
      %From this we construct a window of 256 points in size
      %
      QmatNMR.CadzowWindows(QmatNMR.CadzowNumPeaks, :) = [QTEMP-127 QTEMP+128];
      if (QmatNMR.CadzowWindows(QmatNMR.CadzowNumPeaks, 1) < 1)			%actual length....
        QmatNMR.CadzowWindows(QmatNMR.CadzowNumPeaks, 1) = 1;
      end
      if (QmatNMR.CadzowWindows(QmatNMR.CadzowNumPeaks, 2) > QmatNMR.Size1D)
        QmatNMR.CadzowWindows(QmatNMR.CadzowNumPeaks, 2) = QmatNMR.Size1D;
      end
      
      
      %
      %Plot lines
      %
      hold on
      QTEMP22 = axis;
      QmatNMR.PlotHandle = [plot([QmatNMR.Axis1D(QmatNMR.CadzowWindows(QmatNMR.CadzowNumPeaks, 1)) QmatNMR.Axis1D(QmatNMR.CadzowWindows(QmatNMR.CadzowNumPeaks, 1))], [(QTEMP22(3)-3*QTEMP22(4)) (QTEMP22(3)+4*QTEMP22(4))], 'r--') ...
                            plot([QmatNMR.Axis1D(QmatNMR.CadzowWindows(QmatNMR.CadzowNumPeaks, 2)) QmatNMR.Axis1D(QmatNMR.CadzowWindows(QmatNMR.CadzowNumPeaks, 2))], [(QTEMP22(3)-3*QTEMP22(4)) (QTEMP22(3)+4*QTEMP22(4))], 'r--')];
      hold off
      set(QmatNMR.PlotHandle, 'tag', 'CadzowPeaks');
      set(QmatNMR.TEMPAxis, 'tag', 'MainWindow');
      text(QmatNMR.Axis1D(QTEMP), QTEMP22(3)+1.5*QTEMP22(4), num2str(QmatNMR.CadzowNumPeaks), 'tag', 'CadzowPeaks', 'fontsize', QmatNMR.TextSize+6);
  
    else
      						%All peaks have been entered ...
      fprintf(1, '\nDefining peak areas finished: %d areas with peaks were assigned\n', QmatNMR.CadzowNumPeaks);
    end  
  end
  
  if (QTEMPzoomFlag)		%Switch 1D zoom on if it was turned on before this routine
    switchzoomon
  end
  
  drawnow
  if (~isempty(QTEMPuicontextFlag))   %Switch context menu on if it existed before
    set(QmatNMR.TEMPAxis, 'uicontextmenu', QTEMPuicontextFlag);
  end
  
  
  clear QTEMP*
  
  %
  %continue with an input window to enter the number of peaks for each specified window
  %

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
