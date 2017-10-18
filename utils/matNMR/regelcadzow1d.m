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
%regelcadzow1d.m performs the Cadzow filtering of 1D FID's
%
%03-03-'08

try
  if QmatNMR.buttonList == 1						%= OK-button
    watch;
    
    %
    %Delete any lines and text connected to Cadzow filtering
    %
    delete(findobj(allchild(QmatNMR.Fig), 'tag', 'CadzowPeaks'));
  
    if (QmatNMR.SwitchTo1D) 		%switch from 2D to 1D processing if necessary
      SwitchTo1D
    end
  
    %
    %create entry in the undo matrix
    %
    regelUNDO
  
    QmatNMR.CadzowWindow = eval(QmatNMR.uiInput1);
    QmatNMR.CadzowNrFreqs  = eval(['[' QmatNMR.uiInput2 ']']);
    QmatNMR.CadzowRepeat = eval(QmatNMR.uiInput3);
  
  
    if (QmatNMR.FIDstatus == 1) 		%frequency-domain data
      %
      %we only operate on the selected spectral windows
      %
      QTEMP5 = zeros(1, QmatNMR.Size1D);
      for QTEMP1 = 1:QmatNMR.CadzowNumPeaks
        QmatNMR.CadzowSV = [];
        
        QTEMP4 = ifft(fftshift(QmatNMR.Spec1D(QmatNMR.CadzowWindows(QTEMP1, 1):QmatNMR.CadzowWindows(QTEMP1, 2))));
        for QTEMP2 = 1:QmatNMR.CadzowRepeat
          [QTEMP4, QTEMP3] = cadzow(QTEMP4, QmatNMR.CadzowNrFreqs(QTEMP1), QmatNMR.CadzowWindow);
          QmatNMR.CadzowSV(QTEMP2, :) = QTEMP3;
        end
        QTEMP4(1) = QTEMP4(1) * 0.5;
        QTEMP5(QmatNMR.CadzowWindows(QTEMP1, 1):QmatNMR.CadzowWindows(QTEMP1, 2)) = fftshift(fft(QTEMP4));
      end
      
      QmatNMR.Spec1D = QTEMP5;
  
        					%Add action to history
      QmatNMR.History = str2mat(QmatNMR.History, ['Cadzow filtering in frequency domain: , ' num2str(QmatNMR.CadzowWindow) ' points for Hankel window, ' num2str(QmatNMR.CadzowNrFreqs) ' freqs, repeated' num2str(QmatNMR.CadzowRepeat) ' times']);
      
      %add indices of the spectral windows to the history
      QTEMP10 = [];
      for QTEMP1 = 1:QmatNMR.CadzowNumPeaks
        QTEMP10 = [QTEMP10 ' ' num2str(QmatNMR.CadzowWindows(QTEMP1, 1)) ' ' num2str(QmatNMR.CadzowWindows(QTEMP1, 2))];
      end
      QTEMP11 = double(['QmatNMR.CadzowWindows = [' QTEMP10 '];']);
      QTEMP12 = ceil(length(QTEMP11)/(QmatNMR.MacroLength-1));
      QTEMP13 = zeros(1, QTEMP12*(QmatNMR.MacroLength-1));
      QTEMP13(1:length(QTEMP11)) = QTEMP11;
      for QTEMP40=1:QTEMP12
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 711, QTEMP13((QTEMP40-1)*(QmatNMR.MacroLength-1)+ (1:(QmatNMR.MacroLength-1))));
      end
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 712);
      
      %first add dimension-specific information, and then the current command
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 25, QmatNMR.CadzowWindow, QmatNMR.CadzowRepeat, QmatNMR.CadzowNrFreqs);      %code for Cadzow filtering 1D
    
      if QmatNMR.RecordingMacro
        %add indices of the spectral windows to the history
        for QTEMP40=1:QTEMP12
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 711, QTEMP13((QTEMP40-1)*(QmatNMR.MacroLength-1)+ (1:(QmatNMR.MacroLength-1))));
        end
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 712);
  
        %first add dimension-specific information, and then the current command
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 25, QmatNMR.CadzowWindow, QmatNMR.CadzowRepeat, QmatNMR.CadzowNrFreqs);      %code for Cadzow filtering 1D
      end
    
    else 					%time-domain data
      QmatNMR.CadzowNrFreqs = QmatNMR.CadzowNrFreqs(1); 	%make sure there is only 1 value
  
      %
      %Execute Cadzow filter as many times as asked for
      %
      QmatNMR.CadzowSV = [];
      for QTEMP1 = 1:QmatNMR.CadzowRepeat
        [QmatNMR.Spec1D, QTEMP2] = cadzow(QmatNMR.Spec1D, QmatNMR.CadzowNrFreqs, QmatNMR.CadzowWindow);
        QmatNMR.CadzowSV(QTEMP1, :) = QTEMP2;
      end
  
        					%Add action to history
      QmatNMR.History = str2mat(QmatNMR.History, ['Cadzow filtering in time domain: , ' num2str(QmatNMR.CadzowWindow) ' points for Hankel window, ' num2str(QmatNMR.CadzowNrFreqs) ' freqs, repeated' num2str(QmatNMR.CadzowRepeat) ' times']);
      
      %first add dimension-specific information, and then the current command
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 23, QmatNMR.CadzowWindow, QmatNMR.CadzowRepeat, QmatNMR.CadzowNrFreqs);      %code for Cadzow filtering 1D
    
      if QmatNMR.RecordingMacro
        %first add dimension-specific information, and then the current command
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 23, QmatNMR.CadzowWindow, QmatNMR.CadzowNrFreqs, QmatNMR.CadzowRepeat);      %code for Cadzow filtering 1D
      end
    end
  
  
  
    if (~QmatNMR.BusyWithMacro)
      asaanpas
      Arrowhead
  
    else
      GetDefaultAxis
    end
  
    disp('1D Cadzow filtering finished ...');
  
  else
    delete(findobj(allchild(QmatNMR.Fig), 'tag', 'CadzowPeaks'));
  
    disp('No Cadzow filtering performed ...');
    QmatNMR.SwitchTo1D = 0;	%reset flag because it is possible that the user came from a 2D but cancelled the action
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
