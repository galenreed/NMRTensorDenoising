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
  
    if (QmatNMR.FIDstatus ~= 1) 		%time-domain only
      QTEMP9 = length(QmatNMR.uiInput4);
      if ((QmatNMR.uiInput4(QTEMP9) == 'k') | (QmatNMR.uiInput4(QTEMP9) == 'K'))
        QmatNMR.CadzowLPSVDpoints = round(str2num(QmatNMR.uiInput4(1:(QTEMP9-1))) * 1024 );
      else
        QmatNMR.CadzowLPSVDpoints = round(str2num(QmatNMR.uiInput4));
      end
    end
  
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
  
        %
        %Execute the LPSVD analysis to estimate the peaks
        %
        QTEMP6 = lpsvd(QTEMP4, QmatNMR.CadzowNrFreqs(QTEMP1));
        QTEMP6(:, 4) = 0;        %set the phase to zero for all peaks
        
        
        %
        %Generate an FID based on the peak parameters
        %
        QTEMP7 = cegnt(0:255, QTEMP6, 1e8, 0);
        QTEMP7(1) = QTEMP7(1)*0.5;
        
        
        %
        %Add result to the idealized spectrum
        %
        QTEMP5(QmatNMR.CadzowWindows(QTEMP1, 1):QmatNMR.CadzowWindows(QTEMP1, 2)) = fftshift(fft(QTEMP7));
      end
      
      
      %
      %Voila, the perfect spectrum
      %
      QmatNMR.Spec1D = QTEMP5;
  
  
        					%Add action to history
      QmatNMR.History = str2mat(QmatNMR.History, ['Cadzow filtering + LPSVD in frequency domain: , ' num2str(QmatNMR.CadzowWindow) ' points for Hankel window, ' num2str(QmatNMR.CadzowNrFreqs) ' freqs, repeated' num2str(QmatNMR.CadzowRepeat) ' times']);
      
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
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 26, QmatNMR.CadzowWindow, QmatNMR.CadzowRepeat, QmatNMR.CadzowNrFreqs);      %code for Cadzow filtering frequency domain 1D
    
      if QmatNMR.RecordingMacro
        %add indices of the spectral windows to the history
        for QTEMP40=1:QTEMP12
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 711, QTEMP13((QTEMP40-1)*(QmatNMR.MacroLength-1)+ (1:(QmatNMR.MacroLength-1))));
        end
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 712);
  
        %first add dimension-specific information, and then the current command
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 26, QmatNMR.CadzowWindow, QmatNMR.CadzowRepeat, QmatNMR.CadzowNrFreqs);      %code for Cadzow filtering + LPSVD frequency domain 1D
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
      
      
      %
      %Execute the LPSVD analysis to estimate the peaks
      %
      QTEMP1 = lpsvd(QmatNMR.Spec1D, QmatNMR.CadzowNrFreqs);
      QTEMP1(:, 4) = 0;	%set the phase to zero for all peaks
      
      
      %
      %Generate an FID based on the peak parameters
      %
      QmatNMR.Spec1D = cegnt(0:(QmatNMR.CadzowLPSVDpoints-1), QTEMP1, 1e8, 0);
      
    
        					%Add action to history
      QmatNMR.History = str2mat(QmatNMR.History, ['Cadzow filtering + LPSVD in time domain : , ' num2str(QmatNMR.CadzowWindow) ' points for Hankel window, ' num2str(QmatNMR.CadzowNrFreqs) ' freqs, repeated' num2str(QmatNMR.CadzowRepeat) ' times']);
    
      %first add dimension-specific information, and then the current command
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 24, 1, QmatNMR.CadzowWindow, QmatNMR.CadzowNrFreqs, QmatNMR.CadzowRepeat, QmatNMR.CadzowLPSVDpoints);      %code for Cadzow filtering + LPSVD time domain 1D
    
      if QmatNMR.RecordingMacro
        %first add dimension-specific information, and then the current command
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 24, 1, QmatNMR.CadzowWindow, QmatNMR.CadzowNrFreqs, QmatNMR.CadzowRepeat, QmatNMR.CadzowLPSVDpoints);      %code for Cadzow filtering + LPSVD time domain 1D
      end
    end
  
  
  					%redraw the spectrum and give output ....
    QmatNMR.Temp = get(QmatNMR.FID, 'String');
    [QTEMP20, QmatNMR.Size1D] = size(QmatNMR.Spec1D);
    if QmatNMR.Size1D == 1
      QmatNMR.Size1D = QTEMP20;
      QmatNMR.Spec1D = QmatNMR.Spec1D.';
    end
  
    QmatNMR.lbstatus = 0; 		%apodization flag is switched off, just in case
  
  
    QmatNMR.dph0 = 0;				%reset phase buttons
    QmatNMR.dph1 = 0;
    QmatNMR.dph2 = 0;
    QmatNMR.fase0 = 0;
    QmatNMR.fase1 = 0;
    QmatNMR.fase2 = 0;
    QmatNMR.fase1startIndex = floor(QmatNMR.Size1D/2)+1;
    repair
  
  
    disp(['size of the new 1D ' deblank(QmatNMR.Temp(QmatNMR.FIDstatus, :)) ' is :  ', num2str(QmatNMR.Size1D), ' points.']);
    repair
    %
    %ALWAYS revert to the default axis
    %
    QmatNMR.RulerXAxis = 0;		%Flag for default axis
  
  
    if (~QmatNMR.BusyWithMacro)
      asaanpas
      Arrowhead
  
    else
      GetDefaultAxis
    end
  
    disp('1D Cadzow filtering and LPSVD estimation finished ...');
  
  else
    %
    %Delete any lines and text connected to Cadzow filtering
    %
    delete(findobj(allchild(QmatNMR.Fig), 'tag', 'CadzowPeaks'));
  
    disp('No Cadzow filtering and LPSVD estimation performed ...');
    QmatNMR.SwitchTo1D = 0;	%reset flag because it is possible that the user came from a 2D but cancelled the action
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
