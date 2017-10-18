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
%regelprojTD1.m shows the projection on TD1 for the current 2D spectrum
%last changed 05-09-'00

try
  if (QmatNMR.buttonList == 1)  
    watch;
  
    QmatNMR.FIDstatus = QmatNMR.FIDstatus2D2;		%Is this dimension still an FID ?
    set(QmatNMR.FID, 'value', QmatNMR.FIDstatus);
    regeldisplaymode
  
    %
    %determine the range in TD2
    %
    QTEMP3 = findstr(QmatNMR.uiInput1, ':');	%range TD2
    if (length(QTEMP3) == 1) 		%only 1 colon i.e. begin:end
      if (LinearAxis(QmatNMR.AxisTD2))	%for a linear axis the range is determined by using the axis increment and offset
        QTEMP4 = sort([str2num(QmatNMR.uiInput1(1:(QTEMP3(1)-1))) str2num(QmatNMR.uiInput1((QTEMP3(1)+1):(length(QmatNMR.uiInput1))))]);
        QmatNMR.valTD2 = sort(round((QTEMP4-QmatNMR.Rnull1) ./ QmatNMR.Rincr1));
      
      else				%for a non-linear axis the minimum distance to two points on the axis grid are determined
        QTEMP7 = abs(QmatNMR.AxisTD2-str2num(QmatNMR.uiInput1(1:(QTEMP3(1)-1))));
        QTEMP8 = abs(QmatNMR.AxisTD2-str2num(QmatNMR.uiInput1((QTEMP3(1)+1):(length(QmatNMR.uiInput1)))));
        QmatNMR.valTD2 = sort([find(QTEMP7 == min(QTEMP7)) find(QTEMP8 == min(QTEMP8))]);
      end
  
      QmatNMR.valTD2(3) = 1; 			%increment in points;
      QmatNMR.valTD2(4) = 0; 			%increment in unit of axis (0=no increment given);
  
    elseif (length(QTEMP3) == 2) 		%2 colons i.e. begin:increment:end
      if (LinearAxis(QmatNMR.AxisTD2))	%for a linear axis the range is determined by using the axis increment and offset
        QTEMP4 = sort([str2num(QmatNMR.uiInput1(1:(QTEMP3(1)-1))) str2num(QmatNMR.uiInput1((QTEMP3(2)+1):(length(QmatNMR.uiInput1))))]);
        QmatNMR.valTD2 = sort(round((QTEMP4-QmatNMR.Rnull1) ./ QmatNMR.Rincr1));
        QmatNMR.valTD2(3) = round(abs(str2num(QmatNMR.uiInput1((QTEMP3(1)+1):(QTEMP3(2)-1))) / QmatNMR.Rincr1));
        QmatNMR.valTD2(4) = str2num(QmatNMR.uiInput1((QTEMP3(1)+1):(QTEMP3(2)-1))); 	%increment in unit of axis (0=no increment given);
        
        if (QmatNMR.valTD2(3) == 0)
          disp('matNMR WARNING: increment for TD2 is 0! Aborting extraction ...');
          return
        end
      
      else				%for a non-linear axis an increment is not accepted
        disp('matNMR WARNING: specifying an increment is not allowed for a non-linear axis vector. Aborting ...');
        return
      end
    else
      disp('matNMR WARNING: incorrect format for extraction range in TD2. Aborting ...');
      return
    end
  
  
  
  					%Check the given ranges in points.
    if (QmatNMR.valTD2(1) < 1); QmatNMR.valTD2(1)=1; end
    if (QmatNMR.valTD2(2) > QmatNMR.SizeTD2); QmatNMR.valTD2(2)=QmatNMR.SizeTD2; end
    if ~((QmatNMR.Rincr1 == round(QmatNMR.Rincr1)) & (QmatNMR.Rincr2 == round(QmatNMR.Rincr2)))
      disp('matNMR NOTICE: ranges may suffer from rounding errors.');
    end
  
  
  
  					%perform the projection
    QmatNMR.Spec1D = Qview90(QmatNMR.Spec2D, QmatNMR.valTD2(1), QmatNMR.valTD2(2), QmatNMR.valTD2(3));
    QmatNMR.Axis1D = QmatNMR.AxisTD1;
    QmatNMR.Size1D = QmatNMR.SizeTD1;
    QmatNMR.Dim = 0;
  
    %parameters default axis
    QmatNMR.RulerXAxis = QmatNMR.RulerXAxis2;
    QmatNMR.gamma1d = QmatNMR.gamma2;				%set the sign of the gyromagnetic ratio
    QmatNMRsettings.DefaultAxisReferencekHz = QmatNMRsettings.DefaultAxisReferencekHz2;
    QmatNMRsettings.DefaultAxisReferencePPM = QmatNMRsettings.DefaultAxisReferencePPM2;
    QmatNMRsettings.DefaultAxisCarrierIndex = QmatNMRsettings.DefaultAxisCarrierIndex2;
    QmatNMR.SW1D = QmatNMR.SWTD1;
    QmatNMR.SF1D = QmatNMR.SFTD1;
  
    QmatNMR.texie = QmatNMR.texie1;
    setfourmode
    detaxisprops
  
    QmatNMR.texie = QmatNMR.texie2;
    setfourmode
    detaxisprops
  
  %add this action to the processing history
    QmatNMR.History = str2mat(QmatNMR.History, 'Switched from 2D to 1D mode');
    QmatNMR.History = str2mat(QmatNMR.History, 'Extracted a sum projection on TD1 from the spectrum');
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 203, QmatNMR.AxisTD2(QmatNMR.valTD2(1)), QmatNMR.AxisTD2(QmatNMR.valTD2(2)));	%code for sum TD1, start of range in TD2, end of range in TD2
    if QmatNMR.RecordingMacro
      QmatNMR.Macro = AddToMacro(QmatNMR.HistoryMacro, 203, QmatNMR.AxisTD2(QmatNMR.valTD2(1)), QmatNMR.AxisTD2(QmatNMR.valTD2(2)));	%code for sum TD1, start of range in TD2, end of range in TD2
    end
  
    if (~QmatNMR.BusyWithMacro)
      %clear the previous 1D undo matrix
      QmatNMR.UnDoMatrix1D = GenerateMatNMRStructure;
  
      asaanpas;
      title(['Sum Projection on TD1 from ' strrep(QmatNMR.Spec2DName, '_', '\_')], 'Color', QmatNMR.ColorScheme.AxisFore);
    end  
  
    disp('Sum Projection on TD1 finished');
    Arrowhead;
  else
    disp('Projection on TD1 cancelled');
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
