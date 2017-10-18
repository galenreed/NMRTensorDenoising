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
%regelprojTD2.m shows the (partial) projection on TD2 for the current 2D spectrum
%last changed 05-09-'00

try
  if (QmatNMR.buttonList == 1)  
    watch;
  
    QmatNMR.FIDstatus = QmatNMR.FIDstatus2D1;		%Is this dimension still an FID ?
    set(QmatNMR.FID, 'value', QmatNMR.FIDstatus);
    regeldisplaymode
  
    %
    %determine the range in TD1
    %
    QTEMP5 = findstr(QmatNMR.uiInput1, ':');	%range TD1
    if (length(QTEMP5) == 1) 		%only 1 colon i.e. begin:end
      if (LinearAxis(QmatNMR.AxisTD1))	%for a linear axis the range can be given in the axis units
        QTEMP6 = sort([str2num(QmatNMR.uiInput1(1:(QTEMP5(1)-1))) str2num(QmatNMR.uiInput1((QTEMP5(1)+1):(length(QmatNMR.uiInput1))))]);
        QmatNMR.valTD1 = sort(round((QTEMP6-QmatNMR.Rnull2) ./ QmatNMR.Rincr2));
      
      else				%for a non-linear axis the minimum distance to two points on the axis grid are determined
        QTEMP7 = abs(QmatNMR.AxisTD1-str2num(QmatNMR.uiInput1(1:(QTEMP5(1)-1))));
        QTEMP8 = abs(QmatNMR.AxisTD1-str2num(QmatNMR.uiInput1((QTEMP5(1)+1):(length(QmatNMR.uiInput1)))));
        QmatNMR.valTD1 = sort([find(QTEMP7 == min(QTEMP7)) find(QTEMP8 == min(QTEMP8))]);
      end
      
      QmatNMR.valTD1(3) = 1; 			%increment in points;
      QmatNMR.valTD1(4) = 0; 			%increment in unit of axis (0=no increment given);
  
    elseif (length(QTEMP5) == 2) 		%2 colons i.e. begin:increment:end
      if (LinearAxis(QmatNMR.AxisTD1))	%for a linear axis the range can be given in the axis units
        QTEMP6 = sort([str2num(QmatNMR.uiInput1(1:(QTEMP5(1)-1))) str2num(QmatNMR.uiInput1((QTEMP5(2)+1):(length(QmatNMR.uiInput1))))]);
        QmatNMR.valTD1 = sort(round((QTEMP6-QmatNMR.Rnull2) ./ QmatNMR.Rincr2));
        QmatNMR.valTD1(3) = round(abs(str2num(QmatNMR.uiInput1((QTEMP5(1)+1):(QTEMP5(2)-1))) / QmatNMR.Rincr2));
        QmatNMR.valTD1(4) = str2num(QmatNMR.uiInput1((QTEMP5(1)+1):(QTEMP5(2)-1))); 	%increment in unit of axis (0=no increment given);
        
        if (QmatNMR.valTD1(3) == 0)
          disp('matNMR WARNING: increment for TD1 is 0! Aborting extraction ...');
          return
        end
      
      else				%for a non-linear axis an increment is not accepted
        disp('matNMR WARNING: specifying an increment is not allowed for a non-linear axis vector. Aborting ...');
        return
      end  
    else
      disp('matNMR WARNING: incorrect format for extraction range in TD1. Aborting ...');
      return
    end
  
  					%Check the given ranges in points.
    if (QmatNMR.valTD1(1) < 1); QmatNMR.valTD1(1)=1; end
    if (QmatNMR.valTD1(2) > QmatNMR.SizeTD1); QmatNMR.valTD1(2)=QmatNMR.SizeTD1; end
    
    if ~((QmatNMR.Rincr1 == round(QmatNMR.Rincr1)) & (QmatNMR.Rincr2 == round(QmatNMR.Rincr2)))
      disp('matNMR NOTICE: extraction ranges may suffer from rounding errors.');
    end
  
  
  					%perform the projection
    QmatNMR.Spec1D = Qview0(QmatNMR.Spec2D, QmatNMR.valTD1(1), QmatNMR.valTD1(2), QmatNMR.valTD1(3));
    QmatNMR.Axis1D = QmatNMR.AxisTD2;
    QmatNMR.Size1D = QmatNMR.SizeTD2;
    QmatNMR.Dim = 0;
  
    %parameters default axis
    QmatNMR.RulerXAxis = QmatNMR.RulerXAxis1;
    QmatNMR.gamma1d = QmatNMR.gamma1;				%set the sign of the gyromagnetic ratio
    QmatNMRsettings.DefaultAxisReferencekHz = QmatNMRsettings.DefaultAxisReferencekHz1;
    QmatNMRsettings.DefaultAxisReferencePPM = QmatNMRsettings.DefaultAxisReferencePPM1;
    QmatNMRsettings.DefaultAxisCarrierIndex = QmatNMRsettings.DefaultAxisCarrierIndex1;
    QmatNMR.SW1D = QmatNMR.SWTD2;
    QmatNMR.SF1D = QmatNMR.SFTD2;
  
    QmatNMR.texie = QmatNMR.texie1;
    setfourmode
    detaxisprops
    
  
  %add this action to the processing history
    QmatNMR.History = str2mat(QmatNMR.History, 'Switched from 2D to 1D mode');
    QmatNMR.History = str2mat(QmatNMR.History, 'Extracted a sum projection on TD2 from the spectrum');
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 204, QmatNMR.AxisTD1(QmatNMR.valTD1(1)), QmatNMR.AxisTD1(QmatNMR.valTD1(2)));	%code for sum TD2, start of range in TD1, end of range in TD1
    if QmatNMR.RecordingMacro
      QmatNMR.Macro = AddToMacro(QmatNMR.HistoryMacro, 204, QmatNMR.AxisTD1(QmatNMR.valTD1(1)), QmatNMR.AxisTD1(QmatNMR.valTD1(2)));	%code for sum TD2, start of range in TD1, end of range in TD1
    end
      
    if (~QmatNMR.BusyWithMacro)
      %clear the previous 1D undo matrix
      QmatNMR.UnDoMatrix1D = GenerateMatNMRStructure;
  
      asaanpas;
      title(['Sum Projection on TD2 from ' strrep(QmatNMR.Spec2DName, '_', '\_')], 'Color', QmatNMR.ColorScheme.AxisFore);
    end  
  
    disp('Sum Projection on TD2 finished');
    Arrowhead;
  
  else
    disp('Projection on TD2 cancelled');
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
