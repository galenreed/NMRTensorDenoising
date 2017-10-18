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
%historyFT.m fills the history buffer for the FT procedure
%19-1-'98


try
  if (QmatNMR.Dim == 0)			%1D FID
    QTEMP = str2mat('Complex FT 1D', 'Real FT 1D', 'Complex FT 1D', 'TPPI 1D', 'Complex FT 1D', 'Complex FT 1D', 'Bruker qseq', 'Sine FT');
    if (QmatNMR.InverseFTflag == 1)
      QmatNMR.History = str2mat(QmatNMR.History, ['Type of inverse FT for 1D FID              :  ' QTEMP(QmatNMR.four2, :)]);
    else
      QmatNMR.History = str2mat(QmatNMR.History, ['Type of FT for 1D FID              :  ' QTEMP(QmatNMR.four2, :)]);
    end
    
    %first add dimension-specific information, and then the current command
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 5, QmatNMR.howFT, QmatNMR.fftstatus, QmatNMR.InverseFTflag);	%code for FT, FT type
  
    if QmatNMR.RecordingMacro
      %first add dimension-specific information, and then the current command
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 5, QmatNMR.howFT, QmatNMR.fftstatus, QmatNMR.InverseFTflag);	%code for FT, FT type
    end
  
  elseif (QmatNMR.Dim == 1)			%2D FID, TD 2
    QTEMP = str2mat('Complex FT TD2', 'Real FT TD2', 'States TD2', 'TPPI TD2', 'Whole Echo TD2', 'States-TPPI TD2', 'Bruker qseq TD2', 'Sine FT TD2');
    if (QmatNMR.InverseFTflag == 1)
      QmatNMR.History = str2mat(QmatNMR.History, ['Type of inverse FT in TD2 for 2D FID  :  ' QTEMP(QmatNMR.four2, :)]);
    else
      QmatNMR.History = str2mat(QmatNMR.History, ['Type of FT in TD2 for 2D FID  :  ' QTEMP(QmatNMR.four2, :)]);
    end
  
    %first add dimension-specific information, and then the current command
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
  
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 101, QmatNMR.howFT, QmatNMR.fftstatus, QmatNMR.Dim, QmatNMR.InverseFTflag);	%code for FT, FT type
  
    if QmatNMR.RecordingMacro
      %first add dimension-specific information, and then the current command
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
  
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 101, QmatNMR.howFT, QmatNMR.fftstatus, QmatNMR.Dim, QmatNMR.InverseFTflag);	%code for FT, FT type
    end
  
  else					%2D FID, TD 1
    QTEMP = str2mat('Complex FT TD1', 'Real FT TD1', 'States TD1', 'TPPI TD1', 'Whole Echo TD1', 'States-TPPI TD1', 'Bruker qseq TD1', 'Sine FT TD1');
    if (QmatNMR.InverseFTflag == 1)
      QmatNMR.History = str2mat(QmatNMR.History, ['Type of inverse FT in TD1 for 2D FID  :  ' QTEMP(QmatNMR.four1, :)]);
    else
      QmatNMR.History = str2mat(QmatNMR.History, ['Type of FT in TD1 for 2D FID  :  ' QTEMP(QmatNMR.four1, :)]);
    end
    
  
    %first add dimension-specific information, and then the current command
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
  
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 101, QmatNMR.howFT, QmatNMR.fftstatus, QmatNMR.Dim, QmatNMR.InverseFTflag);	%code for FT, FT type
  
    if QmatNMR.RecordingMacro
      %first add dimension-specific information, and then the current command
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
  
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 101, QmatNMR.howFT, QmatNMR.fftstatus, QmatNMR.Dim, QmatNMR.InverseFTflag);	%code for FT, FT type
    end
  end
  
  clear QTEMP
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
