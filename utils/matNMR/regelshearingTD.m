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
%regelshearingTD.m performs a shearing transformation in the time domain.
%24-07-'97

try
  if QmatNMR.buttonList == 1						%= OK-button
    watch;
  
    %
    %create entry in the undo matrix
    %
    regelUNDO
  
    QmatNMR.ShearingFactor = eval(QmatNMR.uiInput1);
  
    QmatNMR.uiInput2 = QmatNMR.uiInput2;
    if ((QmatNMR.uiInput2(length(QmatNMR.uiInput2)) == 'k') | (QmatNMR.uiInput2(length(QmatNMR.uiInput2)) == 'K'))
      QmatNMR.SWTD2 = str2num(QmatNMR.uiInput2(1:(length(QmatNMR.uiInput2)-1))) * 1000;
    else
      QmatNMR.SWTD2 = str2num(QmatNMR.uiInput2);
    end
  
    QmatNMR.uiInput3 = QmatNMR.uiInput3;
    if ((QmatNMR.uiInput3(length(QmatNMR.uiInput3)) == 'k') | (QmatNMR.uiInput3(length(QmatNMR.uiInput3)) == 'K'))
      QmatNMR.SWTD1 = str2num(QmatNMR.uiInput3(1:(length(QmatNMR.uiInput3)-1))) * 1000;
    else
      QmatNMR.SWTD1 = str2num(QmatNMR.uiInput3);
    end
  
  
    if (QmatNMR.ShearingFactor)			%if zero, stop now
  %
  % REMEMBER:  QmatNMR.SizeTD2 = TD2 and QmatNMR.SizeTD1 = TD1 !!!!
  %
      QmatNMR.howFT = QmatNMR.four1;
    
      QmatNMR.z = 0:QmatNMR.SizeTD1-1;
      QmatNMR.zero = (floor(QmatNMR.SizeTD2/2)+1);
      Qi = sqrt(-1);
    
      QTEMP = (sqrt(-1) * 2 * pi * QmatNMR.ShearingFactor * QmatNMR.SWTD2 / QmatNMR.SWTD1 / QmatNMR.SizeTD2);
    
      if ((QmatNMR.howFT == 3) | (QmatNMR.howFT == 6))                  %States or States-TPPI (Hypercomplex)
        for QTEMP40=1:QmatNMR.SizeTD2
          QTEMP3 = exp(QTEMP * QmatNMR.z * (QTEMP40-QmatNMR.zero)).';
    
          QTEMP1 = (real(QmatNMR.Spec2D(:, QTEMP40)) + Qi*real(QmatNMR.Spec2Dhc(:, QTEMP40))) .* QTEMP3;
          QTEMP2 = (imag(QmatNMR.Spec2D(:, QTEMP40)) + Qi*imag(QmatNMR.Spec2Dhc(:, QTEMP40))) .* QTEMP3;
          
          QmatNMR.Spec2D(:, QTEMP40) = real(QTEMP1) + Qi*real(QTEMP2);
          QmatNMR.Spec2Dhc(:, QTEMP40) = imag(QTEMP1) + Qi*imag(QTEMP2);
        end
    
      else                                              %real, complex, TPPI and Phase modulated spectra
        for QTEMP40=1:QmatNMR.SizeTD2
          QTEMP3 = exp(QTEMP * QmatNMR.z * (QTEMP40-QmatNMR.zero)).';
    
          QmatNMR.Spec2D(:, QTEMP40) = QmatNMR.Spec2D(:, QTEMP40) .* QTEMP3;
        end
      end
  
  %%%
  %%% Just in case we ever want to introduce horizontal shearing in the time domain ...
  %%%
  %%%
  %%%    else 				%horizontal shearing
  %%%      QmatNMR.howFT = QmatNMR.four2;
  %%%  
  %%%      QmatNMR.z = 0:QmatNMR.SizeTD2-1;
  %%%      QmatNMR.zero = (floor(QmatNMR.SizeTD1/2)+1);
  %%%      Qi = sqrt(-1);
  %%%  
  %%%      QTEMP = (sqrt(-1) * 2 * pi * QmatNMR.ShearingFactor * QmatNMR.SWTD1 / QmatNMR.SWTD2 / QmatNMR.SizeTD1);
  %%%  
  %%%      if ((QmatNMR.howFT == 3) | (QmatNMR.howFT == 6))			%States or States-TPPI (Hypercomplex)
  %%%        for QTEMP40=1:QmatNMR.SizeTD1
  %%%          QTEMP3 = exp(QTEMP * QmatNMR.z * (QTEMP40-QmatNMR.zero));
  %%%  
  %%%          QmatNMR.Spec2D(QTEMP40, :) = QmatNMR.Spec2D(QTEMP40, :) .* QTEMP3;
  %%%          QmatNMR.Spec2Dhc(QTEMP40, :) = QmatNMR.Spec2Dhc(QTEMP40, :) .* QTEMP3;
  %%%        end
  %%%  
  %%%      else						%real, complex, TPPI and Phase modulated spectra
  %%%        for QTEMP40=1:QmatNMR.SizeTD1
  %%%          QTEMP3 = exp(QTEMP * QmatNMR.z * (QTEMP40-QmatNMR.zero));
  %%%  
  %%%          QmatNMR.Spec2D(QTEMP40, :) = QmatNMR.Spec2D(QTEMP40, :) .* QTEMP3;
  %%%        end
  %%%      end
  %%%    end
  
  
      getcurrentspectrum			%Reload slice or column into memory and display
  
      if (~QmatNMR.BusyWithMacro)
        asaanpas;
        Arrowhead;
      end
    
      disp(['TD Shearing transformation on TD1 finished (factor = ' num2str(QmatNMR.ShearingFactor) ') ...']); 
      QmatNMR.History = str2mat(QmatNMR.History, ['TD Shearing transformation on TD1 performed :  factor = ' num2str(QmatNMR.ShearingFactor, 5) ', SW TD2 = ' num2str(QmatNMR.SWTD2, 6) ' kHz, SW TD1 = ' num2str(QmatNMR.SWTD1, 6) ' kHz']);
      
      %first add dimension-specific information, and then the current command
      if (QmatNMR.Dim == 1) 	%TD2
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
  
      else
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
      end
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 116, 1, QmatNMR.ShearingFactor, QmatNMR.SWTD2, QmatNMR.SWTD1, QmatNMR.howFT);    
      
      if QmatNMR.RecordingMacro
        %first add dimension-specific information, and then the current command
        if (QmatNMR.Dim == 1) 	%TD2
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
  
        else
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
        end
  
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 116, 1, QmatNMR.ShearingFactor, QmatNMR.SWTD2, QmatNMR.SWTD1, QmatNMR.howFT);    
      end
  
    else
      disp('Shearing transformation in time domain cancelled !');
      Arrowhead;
    end  
  
  else
    disp('Shearing transformation in time domain cancelled !');
    Arrowhead;  
  end
  
  clear QTEMP* Qi

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
