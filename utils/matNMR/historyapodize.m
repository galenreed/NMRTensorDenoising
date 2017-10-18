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
%historyapodize puts the apodization information into the history clipboard
%14-1-'98

try
  if QmatNMR.lbstatus == 0						%NO line broadening function
    QTEMP = '';							
    QTEMP2 = size(QmatNMR.History);
    if (QmatNMR.History(QTEMP2(1), 1:5) == 'Apodi')			%delete the current line broadening entry from the
      QmatNMR.History = QmatNMR.History(1:(QTEMP2(1)-1), :);		%History if this was the last action performed.
  
      QTEMP3 = size(QmatNMR.HistoryMacro);
      QmatNMR.HistoryMacro = QmatNMR.HistoryMacro(1:(QTEMP3(1)-1), :);
      while (QmatNMR.HistoryMacro(end, 1) == 400)			%take away dimension-specific information as well
        QmatNMR.HistoryMacro = QmatNMR.HistoryMacro(1:(end-1), :);
      end
      
      if QmatNMR.RecordingMacro
        QTEMP4 = size(QmatNMR.Macro);
        QmatNMR.Macro = QmatNMR.Macro(1:(QTEMP4(1)-1), :);
  
        while (QmatNMR.Macro(end, 1) == 400)			%take away dimension-specific information as well
          QmatNMR.Macro = QmatNMR.Macro(1:(end-1), :);
        end
      end
    end 
  
  else
    switch QmatNMR.lbstatus
      case -99						%cos^2 function
        QTEMP = 'COS^2';
        QTEMP4 = [QmatNMR.PhaseFactor QmatNMR.Cos2Span];
  
      case -60					%block and exponential function
        QTEMP = ['Block and Exponential, ' num2str(QmatNMR.blocklength) ' points, ' num2str(QmatNMR.lb) ' Hz'];
        QTEMP4 = [QmatNMR.blocklength QmatNMR.lb QmatNMR.SW1D];
  
      case -50
        QTEMP = ['Block and COS^2, ' num2str(QmatNMR.blocklength) ' points'];
        QTEMP4 = [QmatNMR.blocklength];
  
      case -40						%Hanning
        QTEMP = 'Hanning';
        QTEMP4 = [QmatNMR.PhaseFactor];
  
      case -30						%Hamming
        QTEMP = 'Hamming';
        QTEMP4 = [QmatNMR.PhaseFactor];
  
      case 10					%gaussian
        QTEMP = ['Exponential, ' num2str(QmatNMR.lb) ' Hz    Gaussian, ' num2str(QmatNMR.gb) ' Hz'];
        QTEMP4 = [QmatNMR.lb QmatNMR.gb QmatNMR.SW1D];
  
      case 50					%exponential		
        QTEMP = ['Exponential, ' num2str(QmatNMR.lb) ' Hz'];
        QTEMP4 = [QmatNMR.lb QmatNMR.SW1D];
      
      case 100					%Shifting Gaussian
        QTEMP = ['Shifting Gaussian, ' num2str(QmatNMR.gb) ' Hz '];
        QTEMP4 = [QmatNMR.gb QmatNMR.SWTD2 QmatNMR.SWTD1 QmatNMR.ShearingFactor QmatNMR.EchoMaximum QmatNMR.ShiftDirection];
  
      case 101					%gaussian for full echo processing
        QTEMP = ['Exponential (echo), ' num2str(QmatNMR.lb) ' Hz    Gaussian (echo), ' num2str(QmatNMR.gb) ' Hz'];
        QTEMP4 = [QmatNMR.lb QmatNMR.gb QmatNMR.SW1D];
  
      case 501					%exponential for whole echo processing
        QTEMP = ['Exponential (echo), ' num2str(QmatNMR.lb) ' Hz'];
        QTEMP4 = [QmatNMR.lb QmatNMR.SW1D];
      
      case 1001					%Shifting Gaussian for whole echo processing
        QTEMP = ['Shifting Gaussian (echo), ' num2str(QmatNMR.gb) ' Hz, shearing factor = ' num2str(QmatNMR.ShearingFactor)];  
        QTEMP4 = [QmatNMR.gb QmatNMR.SWTD2 QmatNMR.SWTD1 QmatNMR.ShearingFactor QmatNMR.EchoMaximum];
  
      otherwise
        error('matNMR ERROR: Unknown code for apodization function!');
    end
  
    if (QmatNMR.APosterioriHistoryEntry == 0)
      %
      %the default option
      %
  
      %
      %clear the a posteriori entries
      %
      QmatNMR.APosterioriMacro = AddToMacro;
      QmatNMR.APosterioriHistory = '';
  
      
      %
      %add to the history and history macros
      %
      if (QmatNMR.Dim == 0)			%1D FID
        QTEMP2 = size(QmatNMR.History);
        if (QmatNMR.History(QTEMP2(1), 1:5) == 'Apodi')		%check whether the last entry in the history is an apodization. If so
        								%then this will be overwritten
          QmatNMR.History = str2mat(QmatNMR.History((1:(QTEMP2(1)-1)), :), ['Apodization of 1D FID :  ' QTEMP '   SW =  ' num2str(QmatNMR.SW1D, 7) ' Hz']);
          QTEMP3 = size(QmatNMR.HistoryMacro);
          QmatNMR.HistoryMacro = QmatNMR.HistoryMacro(1:(QTEMP3(1)-1), :);
          %first add dimension-specific information, and then the current command
          QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
          QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 11, QmatNMR.lbstatus, QTEMP4);
    
          if QmatNMR.RecordingMacro
            QTEMP4 = size(QmatNMR.Macro);
            QmatNMR.Macro = QmatNMR.Macro(1:(QTEMP4(1)-1), :);
    
            %first add dimension-specific information, and then the current command
            QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
            QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 11, QmatNMR.lbstatus, QTEMP4);
          end  
    
        else                   
          QmatNMR.History = str2mat(QmatNMR.History, ['Apodization of 1D FID :  ' QTEMP '   SW =  ' num2str(QmatNMR.SW1D, 7) ' Hz']);
    
          %first add dimension-specific information, and then the current command
          QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
          QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 11, QmatNMR.lbstatus, QTEMP4);
    
          if QmatNMR.RecordingMacro
            %first add dimension-specific information, and then the current command
            QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
            QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 11, QmatNMR.lbstatus, QTEMP4);
          end  
        end;  
    
      elseif (QmatNMR.Dim == 1)			%2D FID, TD 2
        QmatNMR.History = str2mat(QmatNMR.History, ['Apodization of TD 2 of 2D FID :  ' QTEMP '   SW TD2 =  ' num2str(QmatNMR.SW1D, 7) ' Hz']);
        QmatNMR.howFT = get(QmatNMR.Four, 'value');				%States processing ?
    
        %first add dimension-specific information, and then the current command
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
    
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 107, QmatNMR.lbstatus, QmatNMR.Dim, QmatNMR.howFT, QTEMP4);
    
        if QmatNMR.RecordingMacro
          %first add dimension-specific information, and then the current command
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
    
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 107, QmatNMR.lbstatus, QmatNMR.Dim, QmatNMR.howFT, QTEMP4);
        end
    
      else					%2D FID, TD 1
        QmatNMR.History = str2mat(QmatNMR.History, ['Apodization of TD 1 of 2D FID :  ' QTEMP '   SW TD1 =  ' num2str(QmatNMR.SW1D, 7) ' Hz']);
        QmatNMR.howFT = get(QmatNMR.Four, 'value');				%States processing ?
    
        %first add dimension-specific information, and then the current command
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
    
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 107, QmatNMR.lbstatus, QmatNMR.Dim, QmatNMR.howFT, QTEMP4);
    
        if QmatNMR.RecordingMacro
          %first add dimension-specific information, and then the current command
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
    
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 107, QmatNMR.lbstatus, QmatNMR.Dim, QmatNMR.howFT, QTEMP4);
        end
      end
      
    else
      %
      %in case of a user apodizing a slice of a 2D spectrum, and afterwards switching to a 1D mode, then the
      %apodization is added a posteriori in the SwitchTo1D routine.
      %
      QmatNMR.APosterioriMacro = AddToMacro;
      QmatNMR.APosterioriMacro = AddToMacro(QmatNMR.APosterioriMacro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
      QmatNMR.APosterioriMacro = AddToMacro(QmatNMR.APosterioriMacro, 11, QmatNMR.lbstatus, QTEMP4);
  
      QmatNMR.APosterioriHistory = ['Apodization of 1D FID :  ' QTEMP '   SW =  ' num2str(QmatNMR.SW1D, 7) ' Hz'];
    end
  end  
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
