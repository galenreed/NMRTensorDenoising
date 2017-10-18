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
%regelregrid2d.m takes care of the input for regridding the current 2D spectrum to new axes
%14-11-'07

try
  if QmatNMR.buttonList == 1
    watch;
  
    %
    %create entry in the undo matrix
    %
    regelUNDO
  
  
    %
    %evaluate the new axes and algorithm input
    %
    try
      QmatNMR.RegridAxisTD2 = QmatNMR.uiInput1;
      QTEMP2 = eval(QmatNMR.uiInput1);
  
      QmatNMR.RegridAxisTD1 = QmatNMR.uiInput2;
      QTEMP1 = eval(QmatNMR.uiInput2);
  
    catch
      beep
      error('matNMR WARNING: input did not result in proper axes. Please correct. Aborting ...');
      return
    end
    QmatNMR.RegridAlgorithm = QmatNMR.uiInput3;
  
  
    %
    %Regrid the spectrum
    %
    QmatNMR.Spec2D = matNMRRegridSpectrum2D(QmatNMR.Spec2D, QmatNMR.AxisTD2, QmatNMR.AxisTD1, QTEMP2, QTEMP1, QmatNMR.RegridAlgorithm);
    QmatNMR.Spec2Dhc = 0*QmatNMR.Spec2D; 	%zero any hypercomplex part there may be
    QmatNMR.HyperComplex = 0;
  
  
    %
    %Define the new axes and spectrum size
    %
    QmatNMR.AxisTD2 = QTEMP2;
    QmatNMR.AxisTD1 = QTEMP1;
    QmatNMR.SizeTD2 = length(QmatNMR.AxisTD2);
    QmatNMR.SizeTD1 = length(QmatNMR.AxisTD1);
    if (QmatNMR.Dim == 1) 	%TD2
      QmatNMR.Axis1D = QmatNMR.AxisTD2;
      QmatNMR.Size1D = QmatNMR.SizeTD2;
  
    else
      QmatNMR.Axis1D = QmatNMR.AxisTD1;
      QmatNMR.Size1D = QmatNMR.SizeTD1;
    end
  
    detaxisprops;
  
  
    %
    %create history entries before making all changes
    %
    QmatNMR.History = str2mat(QmatNMR.History, ['Spectrum regridded to new axes']);
  
    QTEMP6 = 0; 		%flag for linear axis in TD2 in the history entry
    if (~LinearAxis(QmatNMR.AxisTD2))
      %
      %non-linear axes are stored entirely in the processing macro
      %
      QmatNMR.RincrOLD = 'QmatNMR.uiInput1 = ''[';
      for QTEMP4 = 1:length(QmatNMR.AxisTD2)
        QmatNMR.RincrOLD = [QmatNMR.RincrOLD num2str(QmatNMR.AxisTD2(QTEMP4), 10) ' '];
      end
  
      QmatNMR.RincrOLD = [QmatNMR.RincrOLD ']'''];
      QTEMP11 = double(QmatNMR.RincrOLD);
      QTEMP12 = ceil(length(QTEMP11)/(QmatNMR.MacroLength-1));
      QTEMP11 = [QTEMP11 zeros(1, QTEMP12*(QmatNMR.MacroLength-1) - length(QTEMP11))];
      QTEMP13 = zeros(QTEMP12, QmatNMR.MacroLength);
      QTEMP13(:, 2:end) = reshape(QTEMP11, QmatNMR.MacroLength-1, QTEMP12).';
      QTEMP13(:, 1) = 711;
  
      QmatNMR.HistoryMacro = [QmatNMR.HistoryMacro; QTEMP13];
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 712);
  
      if QmatNMR.RecordingMacro
        QmatNMR.Macro = [QmatNMR.Macro; QTEMP13];
      end
      if QmatNMR.RecordingMacro
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 712);
      end
  
      QTEMP6 = 1;
    end
  
    QTEMP7 = 0; 		%flag for linear axis in TD1 in the history entry
    if (~LinearAxis(QmatNMR.AxisTD1))
      %
      %non-linear axes are stored entirely in the processing macro
      %
      QmatNMR.RincrOLD = 'QmatNMR.uiInput2 = ''[';
      for QTEMP4 = 1:length(QmatNMR.AxisTD1)
        QmatNMR.RincrOLD = [QmatNMR.RincrOLD num2str(QmatNMR.AxisTD1(QTEMP4), 10) ' '];
      end
  
      QmatNMR.RincrOLD = [QmatNMR.RincrOLD ']'''];
      QTEMP11 = double(QmatNMR.RincrOLD);
      QTEMP12 = ceil(length(QTEMP11)/(QmatNMR.MacroLength-1));
      QTEMP11 = [QTEMP11 zeros(1, QTEMP12*(QmatNMR.MacroLength-1) - length(QTEMP11))];
      QTEMP13 = zeros(QTEMP12, QmatNMR.MacroLength);
      QTEMP13(:, 2:end) = reshape(QTEMP11, QmatNMR.MacroLength-1, QTEMP12).';
      QTEMP13(:, 1) = 711;
  
      QmatNMR.HistoryMacro = [QmatNMR.HistoryMacro; QTEMP13];
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 712);
  
      if QmatNMR.RecordingMacro
        QmatNMR.Macro = [QmatNMR.Macro; QTEMP13];
      end
      if QmatNMR.RecordingMacro
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 712);
      end
  
      QTEMP7 = 1;
    end
  
  
    %first add dimension-specific information, and then the current command
    if (QmatNMR.Dim == 1)		%TD2
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
  
    else
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
    end
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 130, QmatNMR.Rincr1, QmatNMR.Rnull1, QTEMP6, QmatNMR.SizeTD2, QmatNMR.Rincr2, QmatNMR.Rnull2, QTEMP7, QmatNMR.SizeTD1, QmatNMR.RegridAlgorithm);
  
    if QmatNMR.RecordingMacro
      %first add dimension-specific information, and then the current command
      if (QmatNMR.Dim == 1) 	%TD2
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
  
      else
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
      end
  
     QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 130, QmatNMR.Rincr1, QmatNMR.Rnull1, QTEMP6, QmatNMR.SizeTD2, QmatNMR.Rincr2, QmatNMR.Rnull2, QTEMP7, QmatNMR.SizeTD1, QmatNMR.RegridAlgorithm);
    end
  
  
    %
    %Switch off the default axis
    %
    QmatNMR.RulerXAxis = 1;
    QmatNMR.RulerXAxis1 = 1;
    QmatNMR.RulerXAxis2 = 1;
    set(QmatNMR.h670, 'checked', 'off'); 	%switch off the check flag in the menubar
  
  
    %
    %set some more parameters relevant to further proceedings
    %
    QmatNMR.kolomnr = 1;
    QmatNMR.rijnr = 1;
    QmatNMR.fase1startIndex = floor(QmatNMR.Size1D/2)+1;
    QmatNMR.fase1start = interp1((1:QmatNMR.Size1D).', QmatNMR.Axis1D, QmatNMR.fase1startIndex);
    QmatNMR.fase0 = 0;
    QmatNMR.fase1 = 0;
    QmatNMR.fase2 = 0;
    QmatNMR.dph0 = 0;
    QmatNMR.dph1 = 0;
    QmatNMR.dph2 = 0;
    getcurrentspectrum
    Qspcrel;
    CheckAxis;                        %checks whether the axis is ascending or descending and adjusts the
  					%plot0direction if necessary
  
    disp('Current 2D spectrum regridded to new axes');
    disp(['New size of the 2D is :  ', num2str(QmatNMR.SizeTD1), ' x ', num2str(QmatNMR.SizeTD2), ' points (td1 x td2).']);
  
  
    %
    %redraw
    %
    if (~QmatNMR.BusyWithMacro)
      asaanpas
      Arrowhead
    end
  
  
    clear QTEMP*
  
  else
    disp('Regridding of current 2D spectrum aborted !!');
  end

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
