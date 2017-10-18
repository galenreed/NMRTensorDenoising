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
%regelsetintegral2d.m handles setting the integral of a 2D spectrum from the matNMR main
%window
%26-03-'99

try
  if (QmatNMR.buttonList == 1)
    watch
    
    %
    %create entry in the undo matrix
    %
    regelUNDO
  
    					%
  					%re-Check the range that was given as input
  					%
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
  
    %
    %determine the range in TD1
    %
    QTEMP5 = findstr(QmatNMR.uiInput2, ':');	%range TD1
    if (length(QTEMP5) == 1) 			%only 1 colon i.e. begin:end
      if (LinearAxis(QmatNMR.AxisTD1))		%for a linear axis the range can be given in the axis units
        QTEMP6 = sort([str2num(QmatNMR.uiInput2(1:(QTEMP5(1)-1))) str2num(QmatNMR.uiInput2((QTEMP5(1)+1):(length(QmatNMR.uiInput2))))]);
        QmatNMR.valTD1 = sort(round((QTEMP6-QmatNMR.Rnull2) ./ QmatNMR.Rincr2));
      
      else					%for a non-linear axis the minimum distance to two points on the axis grid are determined
        QTEMP7 = abs(QmatNMR.AxisTD1-str2num(QmatNMR.uiInput2(1:(QTEMP5(1)-1))));
        QTEMP8 = abs(QmatNMR.AxisTD1-str2num(QmatNMR.uiInput2((QTEMP5(1)+1):(length(QmatNMR.uiInput2)))));
        QmatNMR.valTD1 = sort([find(QTEMP7 == min(QTEMP7)) find(QTEMP8 == min(QTEMP8))]);
      end
      
      QmatNMR.valTD1(3) = 1; 			%increment in points;
      QmatNMR.valTD1(4) = 0; 			%increment in unit of axis (0=no increment given);
  
    elseif (length(QTEMP5) == 2) 			%2 colons i.e. begin:increment:end
      if (LinearAxis(QmatNMR.AxisTD1))		%for a linear axis the range can be given in the axis units
        QTEMP6 = sort([str2num(QmatNMR.uiInput2(1:(QTEMP5(1)-1))) str2num(QmatNMR.uiInput2((QTEMP5(2)+1):(length(QmatNMR.uiInput2))))]);
        QmatNMR.valTD1 = sort(round((QTEMP6-QmatNMR.Rnull2) ./ QmatNMR.Rincr2));
        QmatNMR.valTD1(3) = round(abs(str2num(QmatNMR.uiInput2((QTEMP5(1)+1):(QTEMP5(2)-1))) / QmatNMR.Rincr2));
        QmatNMR.valTD1(4) = str2num(QmatNMR.uiInput2((QTEMP5(1)+1):(QTEMP5(2)-1))); 	%increment in unit of axis (0=no increment given);
        
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
    if (QmatNMR.valTD2(1) < 1); QmatNMR.valTD2(1)=1; end
    if (QmatNMR.valTD2(2) > QmatNMR.SizeTD2); QmatNMR.valTD2(2)=QmatNMR.SizeTD2; end
    
    if (QmatNMR.valTD1(1) < 1); QmatNMR.valTD1(1)=1; end
    if (QmatNMR.valTD1(2) > QmatNMR.SizeTD1); QmatNMR.valTD1(2)=QmatNMR.SizeTD1; end
    
    if ~((QmatNMR.Rincr1 == round(QmatNMR.Rincr1)) & (QmatNMR.Rincr2 == round(QmatNMR.Rincr2)))
      disp('matNMR NOTICE: extraction ranges may suffer from rounding errors.');
    end
  
  
  					%activate corrected ranges
    QTEMP4 = [num2str(QmatNMR.valTD2(1), 10) ':' num2str(QmatNMR.valTD2(3), 10) ':' num2str(QmatNMR.valTD2(2), 10)];
    QTEMP5 = [num2str(QmatNMR.valTD1(1), 10) ':' num2str(QmatNMR.valTD1(3), 10) ':' num2str(QmatNMR.valTD1(2), 10)];
    eval(['QmatNMR.Spec2D = ' QmatNMR.uiInput3 '*QmatNMR.Spec2D/sum(sum(QmatNMR.Spec2D(' QTEMP5 ',' QTEMP4 ')));']);
  
  
    getcurrentspectrum
    disp(['Spectrum integrated to ' QmatNMR.uiInput3 ' for range (TD1, TD2): (' QmatNMR.uiInput2 ', ' QmatNMR.uiInput1 ')']);  
    QmatNMR.History = str2mat(QmatNMR.History, ['Spectrum integrated to ' QmatNMR.uiInput3 ' for range (TD1, TD2): (' QmatNMR.uiInput2 ', ' QmatNMR.uiInput1 ')']);
    QTEMP = eval(QmatNMR.uiInput1);	%range TD2
    QTEMP2 = eval(QmatNMR.uiInput2);	%range TD1
  
    %first add dimension-specific information, and then the current command
    if (QmatNMR.Dim == 1)		%TD2
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
  
    else
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
    end
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 119, QmatNMR.AxisTD2(QmatNMR.valTD2(1)), QmatNMR.AxisTD2(QmatNMR.valTD2(2)), QmatNMR.AxisTD1(QmatNMR.valTD1(1)), QmatNMR.AxisTD1(QmatNMR.valTD1(2)), QmatNMR.valTD2(4), QmatNMR.valTD1(4), eval(QmatNMR.uiInput3));
    
    if QmatNMR.RecordingMacro
      %first add dimension-specific information, and then the current command
      if (QmatNMR.Dim == 1)		%TD2
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
  
      else
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
      end
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 119, QmatNMR.AxisTD2(QmatNMR.valTD2(1)), QmatNMR.AxisTD2(QmatNMR.valTD2(2)), QmatNMR.AxisTD1(QmatNMR.valTD1(1)), QmatNMR.AxisTD1(QmatNMR.valTD1(2)), QmatNMR.valTD2(4), QmatNMR.valTD1(4), eval(QmatNMR.uiInput3));
    end
  
    if (~QmatNMR.BusyWithMacro)
      asaanpas
      Arrowhead
    end  
  else
    disp('Setting the integral of the 2D spectrum was cancelled ...');
  end; 
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
