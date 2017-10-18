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
%DCcorr2d.m performs a DC offset correction on the current dimension of the 2D FID

try
  if QmatNMR.buttonList == 1						%= OK-button
    watch
  
    %
    %create entry in the undo matrix
    %
    regelUNDO
  
    QTEMP1 = eval(QmatNMR.uiInput1);
  
    if (QmatNMR.Dim == 1)
      for QTEMP40 = 1:QmatNMR.SizeTD1
        QTEMP = QmatNMR.Spec2D(QTEMP40, :);
        QmatNMR.Spec2D(QTEMP40, :) = QTEMP - mean(real(QTEMP(QTEMP1))) - sqrt(-1)*mean(imag(QTEMP(QTEMP1)));
        QTEMP = QmatNMR.Spec2Dhc(QTEMP40, :);
        QmatNMR.Spec2Dhc(QTEMP40, :) = QTEMP - mean(real(QTEMP(QTEMP1))) - sqrt(-1)*mean(imag(QTEMP(QTEMP1)));
      end
      
      QmatNMR.History = str2mat(QmatNMR.History, ['DC offset correction on TD2 performed, noise range = ' num2str(QTEMP1(1)) ':' num2str(QTEMP1(length(QTEMP1)))]);
  
      %first add dimension-specific information, and then the current command
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
  
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 121, QmatNMR.Dim, QTEMP1(1), QTEMP1(length(QTEMP1)));	%code for DC corr 2D, dimension, range
  
      if QmatNMR.RecordingMacro
        %first add dimension-specific information, and then the current command
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
  
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 121, QmatNMR.Dim, QTEMP1(1), QTEMP1(length(QTEMP1)));	%code for DC corr 2D, dimension, range
      end
  
      disp(['DC offset correction on TD2 performed, noise range = ' num2str(QTEMP1(1)) ':' num2str(QTEMP1(length(QTEMP1)))]);
    
    elseif (QmatNMR.Dim == 2)
      for QTEMP40 = 1:QmatNMR.SizeTD2
        QTEMP = QmatNMR.Spec2D(:, QTEMP40);
        QmatNMR.Spec2D(:, QTEMP40) = QTEMP - mean(real(QTEMP(QTEMP1))) - sqrt(-1)*mean(imag(QTEMP(QTEMP1)));
        QTEMP = QmatNMR.Spec2Dhc(:, QTEMP40);
        QmatNMR.Spec2Dhc(:, QTEMP40) = QTEMP - mean(real(QTEMP(QTEMP1))) - sqrt(-1)*mean(imag(QTEMP(QTEMP1)));
      end
  
      QmatNMR.History = str2mat(QmatNMR.History, ['DC offset correction on TD1 performed, noise range = ' num2str(QTEMP1(1)) ':' num2str(QTEMP1(length(QTEMP1)))]);
  
      %first add dimension-specific information, and then the current command
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
  
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 121, QmatNMR.Dim, QTEMP1(1), QTEMP1(length(QTEMP1)));	%code for DC corr 2D, dimension, range
  
      if QmatNMR.RecordingMacro
        %first add dimension-specific information, and then the current command
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
  
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 121, QmatNMR.Dim, QTEMP1(1), QTEMP1(length(QTEMP1)));	%code for DC corr 2D, dimension, range
      end
  
      disp(['DC offset correction on TD1 performed, noise range = ' num2str(QTEMP1(1)) ':' num2str(QTEMP1(length(QTEMP1)))]);
    end
  
    getcurrentspectrum		%get spectrum to show on the screen
    if (~QmatNMR.BusyWithMacro)
      asaanpas;
      Arrowhead;
    end
    
  else
    disp('2D DC offset correction cancelled ...');
  end  
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
