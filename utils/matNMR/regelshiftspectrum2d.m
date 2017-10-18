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
%regelshiftspectrum2d.m performs a shift of the spectrum by application of a phase modulation to the time domain
%
%26-05-'08

try
  if QmatNMR.buttonList == 1						%= OK-button
    watch;
  
    %
    %create entry in the undo matrix
    %
    regelUNDO
  
    QmatNMR.ShiftSpectrum = eval(QmatNMR.uiInput1);
  
  
    %
    %Shift the spectrum by applying a phase modulation
    %
    
    %
    %Determine the FT mode
    %
    QmatNMR.howFT = get(QmatNMR.Four, 'value');
  
    if (QmatNMR.Dim == 1) 	% TD2
      QTEMP = exp((0:QmatNMR.SizeTD2-1)*sqrt(-1)*2*pi*QmatNMR.ShiftSpectrum);
  
      if ((QmatNMR.howFT == 3) | (QmatNMR.howFT == 6))	%States FT or States-TPPI
        for QTEMP40 = 1:QmatNMR.SizeTD1
          QmatNMR.Spec2D  (QTEMP40, :) = QmatNMR.Spec2D  (QTEMP40, :) .* QTEMP;
          QmatNMR.Spec2Dhc(QTEMP40, :) = QmatNMR.Spec2Dhc(QTEMP40, :) .* QTEMP;
        end
  
      else
        for QTEMP40 = 1:QmatNMR.SizeTD1
          QmatNMR.Spec2D  (QTEMP40, :) = QmatNMR.Spec2D  (QTEMP40, :) .* QTEMP;
        end
      end
  
    else 				% TD1
      QTEMP = exp((0:QmatNMR.SizeTD1-1)*sqrt(-1)*2*pi*QmatNMR.ShiftSpectrum).';
  
      if ((QmatNMR.howFT == 3) | (QmatNMR.howFT == 6))                  %States or States-TPPI (Hypercomplex)
        for QTEMP40=1:QmatNMR.SizeTD2
          QTEMP1 = (real(QmatNMR.Spec2D(:, QTEMP40)) + sqrt(-1)*real(QmatNMR.Spec2Dhc(:, QTEMP40))) .* QTEMP;
          QTEMP2 = (imag(QmatNMR.Spec2D(:, QTEMP40)) + sqrt(-1)*imag(QmatNMR.Spec2Dhc(:, QTEMP40))) .* QTEMP;
          
          QmatNMR.Spec2D(:, QTEMP40) = real(QTEMP1) + sqrt(-1)*real(QTEMP2);
          QmatNMR.Spec2Dhc(:, QTEMP40) = imag(QTEMP1) + sqrt(-1)*imag(QTEMP2);
        end
    
      else                                              %real, complex, TPPI and Phase modulated spectra
        for QTEMP40=1:QmatNMR.SizeTD2
          QmatNMR.Spec2D(:, QTEMP40) = QmatNMR.Spec2D(:, QTEMP40) .* QTEMP;
        end
      end
    end
  
  
    %
    %History stuff
    %
    if (QmatNMR.Dim == 1)     %TD2
      QmatNMR.History = str2mat(QmatNMR.History, ['Shifted 2D dataset in TD2 of the FID by factor  :  ' num2str(QmatNMR.ShiftSpectrum, 10)]);

    else
      QmatNMR.History = str2mat(QmatNMR.History, ['Shifted 2D dataset in TD1 of the FID by factor  :  ' num2str(QmatNMR.ShiftSpectrum, 10)]);
    end

    %first add dimension-specific information, and then the current command
    if (QmatNMR.Dim == 1)       %TD2
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
  
    else
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
    end
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 131, QmatNMR.ShiftSpectrum, QmatNMR.Dim);
  
    if QmatNMR.RecordingMacro
      %first add dimension-specific information, and then the current command
      if (QmatNMR.Dim == 1)     %TD2
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
  
      else
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
      end
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 131, QmatNMR.ShiftSpectrum, QmatNMR.Dim);
    end  
  
  
    %
    %replot the spectrum
    %
    getcurrentspectrum		%get spectrum to show on the screen
  
    if (~QmatNMR.BusyWithMacro)
      asaanpas
      Arrowhead
  
    else
      GetDefaultAxis
    end
  
    disp('Spectrum shifted in frequency domain by applying a phase modulation in time domain ...');
  
  else
    disp('Shifting of spectrum (phase modulation to FID) was cancelled ...');
    QmatNMR.SwitchTo1D = 0;	%reset flag because it is possible that the user came from a 2D but cancelled the action
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
