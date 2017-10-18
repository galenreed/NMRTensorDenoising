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
%regelzero2d.m zeros entire rows and columns of a 2D matrix
%
%23-03-'99

try
  if QmatNMR.buttonList == 1
    					%zero rows first
    %
    %create entry in the undo matrix
    %
    regelUNDO
  
    if ~isempty(QmatNMR.uiInput1)
      QTEMP1 = eval(QmatNMR.uiInput1);
      QTEMP2 = length(QTEMP1);
      
      QmatNMR.Spec2D(QTEMP1, :) = zeros(QTEMP2, QmatNMR.SizeTD2);
      QmatNMR.Spec2Dhc(QTEMP1, :) = zeros(QTEMP2, QmatNMR.SizeTD2);
  
      %
      %Now determine the start, end and increment of the range to store in the history
      %macro. But only if the range is linear!
      %
      if LinearAxis(QTEMP1)
        QTEMP2 = QTEMP1(end);
        QTEMP5 = QTEMP1(2)-QTEMP1(1);
        QTEMP1 = QTEMP1(1);
      else
        disp('matNMR WARNING: the specified range for TD2 is non-linear and will not be stored in the history macro.');
        disp('matNMR WARNING: It will therefore NOT be executed during reprocessing!');
        QTEMP1 = 0;
        QTEMP2 = 0;
        QTEMP5 = 0;
      end
    else
      QmatNMR.uiInput1 = 'NONE';
      QTEMP1 = 0;
      QTEMP2 = 0;
      QTEMP5 = 0;
    end  
  
    					%then zero columns
    if ~isempty(QmatNMR.uiInput2)
      QTEMP3 = eval(QmatNMR.uiInput2);
      QTEMP4 = length(QTEMP3);
      QmatNMR.Spec2D(:, QTEMP3) = zeros(QmatNMR.SizeTD1, QTEMP4);
      QmatNMR.Spec2Dhc(:, QTEMP3) = zeros(QmatNMR.SizeTD1, QTEMP4);
  
      %
      %Now determine the start, end and increment of the range to store in the history
      %macro. But only if the range is linear!
      %
      if LinearAxis(QTEMP3)
        QTEMP4 = QTEMP3(end);
        QTEMP6 = QTEMP3(2)-QTEMP3(1);
        QTEMP3 = QTEMP3(1);
      else
        disp('matNMR WARNING: the specified range for TD1 is non-linear and will not be stored in the history macro.');
        disp('matNMR WARNING: It will therefore NOT be executed during reprocessing!');
        QTEMP3 = 0;
        QTEMP4 = 0;
        QTEMP6 = 0;
      end
    else
      QmatNMR.uiInput2 = 'NONE';
      QTEMP3 = 0;
      QTEMP4 = 0;
      QTEMP6 = 0;
    end  
  
    getcurrentspectrum;		%get correct row or column from 2D
  
    QmatNMR.History = str2mat(QmatNMR.History, ['Rows ' QmatNMR.uiInput1 ' and columns ' QmatNMR.uiInput2 ' have been zeroed.']);
  
    %first add dimension-specific information, and then the current command
    if (QmatNMR.Dim == 1)		%TD2
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
  
    else
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
    end  
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 108, QTEMP1, QTEMP2, QTEMP5, QTEMP3, QTEMP4, QTEMP6);	%code for zero part of 2D, ranges
  
    if (QmatNMR.RecordingMacro)
      %first add dimension-specific information, and then the current command
      if (QmatNMR.Dim == 1) 	%TD2
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
  
      else
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
      end
      
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 108, QTEMP1, QTEMP5, QTEMP2, QTEMP3, QTEMP6, QTEMP4);	%code for zero part of 2D, ranges
    end
    
    disp(['Rows ' QmatNMR.uiInput1 ' and columns ' QmatNMR.uiInput2 ' have been zeroed.']);
  
    if (~QmatNMR.BusyWithMacro)
      asaanpas
    end
  else
    disp('Zeroing part of a 2D matrix was cancelled ...');
  end  
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
