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
%regelshearingFD.m performs a shearing transformation in the frequency domain.
%02-03-'99

try
  if QmatNMR.buttonList == 1						%= OK-button
    watch;
  
    %
    %create entry in the undo matrix
    %
    regelUNDO
  
    QmatNMR.ShearingFactor = eval(QmatNMR.uiInput1);
    QmatNMR.ShearingDirection = QmatNMR.uiInput4;
  
    if ((QmatNMR.uiInput2(length(QmatNMR.uiInput2)) == 'k') | (QmatNMR.uiInput2(length(QmatNMR.uiInput2)) == 'K'))
      QmatNMR.SWTD2 = str2num(QmatNMR.uiInput2(1:(length(QmatNMR.uiInput2)-1))) * 1000;
    else
      QmatNMR.SWTD2 = str2num(QmatNMR.uiInput2);
    end
  
    if ((QmatNMR.uiInput3(length(QmatNMR.uiInput3)) == 'k') | (QmatNMR.uiInput3(length(QmatNMR.uiInput3)) == 'K'))
      QmatNMR.SWTD1 = str2num(QmatNMR.uiInput3(1:(length(QmatNMR.uiInput3)-1))) * 1000;
    else
      QmatNMR.SWTD1 = str2num(QmatNMR.uiInput3);
    end
  
  
    if (QmatNMR.ShearingFactor)			%if zero, stop now
  %
  % REMEMBER:  QmatNMR.SizeTD2 = TD2 and QmatNMR.SizeTD1 = TD1 !!!!
  %
      if (QmatNMR.ShearingDirection == 1)	%vertical shearing
  					%Check which columns need to be right-shifted and which left
        QmatNMR.Middle = floor(QmatNMR.SizeTD2/2) + 1;
        QmatNMR.Shifts = ((1:QmatNMR.SizeTD2) - QmatNMR.Middle)*QmatNMR.ShearingFactor*QmatNMR.SWTD2*QmatNMR.SizeTD1/(QmatNMR.SizeTD2*QmatNMR.SWTD1);
  
        for QTEMP40=1:QmatNMR.SizeTD2
          fprintf(1, '\rProcessing row %4g out of %4g rows ... ', QTEMP40, QmatNMR.SizeTD2);
      					%first determine how many spectra need to be added to the
  					%spectrum to be able to shear the first point (maximum shear)
          QTEMP2 = ceil(max(abs(QmatNMR.Shifts(QTEMP40)))/QmatNMR.SizeTD1);
  
        					%first create a vector which the interpolation routine can use ...
          QTEMP3 = [];			%spectrum vector
          QTEMP4 = [];			%axis vector
          for QTEMP41 = 1:(2*QTEMP2 + 1)
            QTEMP3 = [QTEMP3 real(QmatNMR.Spec2D(:, QTEMP40)).'];				%this vector contains the repeated column from the spectrum
  	  QTEMP4 = [QTEMP4 ( (QTEMP41-QTEMP2-1)*QmatNMR.SizeTD1 + (1:QmatNMR.SizeTD1))];	%this vector contains the positions belonging to QTEMP3
  	end
  
          QmatNMR.Spec2D(:, QTEMP40) = interp1(QTEMP4, QTEMP3, ((1:QmatNMR.SizeTD1)+QmatNMR.Shifts(QTEMP40)), 'spline').';
        end
      
      else				%horizontal shearing
  					%Check which columns need to be right-shifted and which left
        QmatNMR.Middle = floor(QmatNMR.SizeTD1/2) + 1;
        QmatNMR.Shifts = ((1:QmatNMR.SizeTD1) - QmatNMR.Middle)*QmatNMR.ShearingFactor*QmatNMR.SWTD1*QmatNMR.SizeTD2/(QmatNMR.SizeTD1*QmatNMR.SWTD2);
xx = QmatNMR.Shifts
        for QTEMP40=1:QmatNMR.SizeTD1
          fprintf(1, '\rProcessing column %4g out of %4g columns ... ', QTEMP40, QmatNMR.SizeTD1);
      					%first determine how many spectra need to be added to the
  					%spectrum to be able to shear the first point (maximum shear)
          QTEMP2 = ceil(max(abs(QmatNMR.Shifts(QTEMP40)))/QmatNMR.SizeTD2);
  
        					%first create a vector which the interpolation routine can use ...
          QTEMP3 = [];			%spectrum vector
          QTEMP4 = [];			%axis vector
          for QTEMP41 = 1:(2*QTEMP2 + 1)
            QTEMP3 = [QTEMP3 real(QmatNMR.Spec2D(QTEMP40, :))];				%this vector contains the repeated column from the spectrum
  	  QTEMP4 = [QTEMP4 ( (QTEMP41-QTEMP2-1)*QmatNMR.SizeTD2 + (1:QmatNMR.SizeTD2))];	%this vector contains the positions belonging to QTEMP3
          end
  
          QmatNMR.Spec2D(QTEMP40, :) = interp1(QTEMP4, QTEMP3, ((1:QmatNMR.SizeTD2)+QmatNMR.Shifts(QTEMP40)), 'spline');
        end
      end
  
      QmatNMR.Spec2Dhc = zeros(QmatNMR.SizeTD1, QmatNMR.SizeTD2);	%zero the remaining imaginary parts and notify user
      disp('matNMR NOTICE: when shearing in frequency domain the imaginary parts are removed, hence phase correction is no longer possible!');
  
      getcurrentspectrum			%Reload slice or column into memory and display
      
      if (~QmatNMR.BusyWithMacro)
        asaanpas;
        Arrowhead;
      end
      
      QTEMP16 = str2mat('vertical', 'horizontal');
      disp(['FD Shearing transformation on TD1 finished (factor = ' num2str(QmatNMR.ShearingFactor) ', direction = ' deblank(QTEMP16(QmatNMR.ShearingDirection, :)) ') ...']); 
      QmatNMR.History = str2mat(QmatNMR.History, ['FD Shearing transformation on TD1 performed :  factor = ' num2str(QmatNMR.ShearingFactor, 5) ', direction = ' deblank(QTEMP16(QmatNMR.ShearingDirection, :))]);
  
      %first add dimension-specific information, and then the current command
      if (QmatNMR.Dim == 1) 	%TD2
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
  
      else
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
      end
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 116, 0, QmatNMR.ShearingFactor, QmatNMR.SWTD2, QmatNMR.SWTD1, QmatNMR.ShearingDirection);
      
      if QmatNMR.RecordingMacro
        %first add dimension-specific information, and then the current command
        if (QmatNMR.Dim == 1) 	%TD2
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
        
        else
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
        end
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 116, 0, QmatNMR.ShearingFactor, QmatNMR.SWTD2, QmatNMR.SWTD1, QmatNMR.ShearingDirection);
      end
  
    else
      disp('Shearing transformation in frequency domain cancelled !');
      Arrowhead;
    end
  
  else
    disp('Shearing transformation in frequency domain cancelled !');
    Arrowhead;  
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
