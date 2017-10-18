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
%DCcorr1d.m performs a DC offset correction on a 1D FID

try
  if QmatNMR.buttonList == 1						%= OK-button
    watch
  
    if (QmatNMR.SwitchTo1D) 		%switch from 2D to 1D processing if necessary
      SwitchTo1D
    end
  
    %
    %create entry in the undo matrix
    %
    regelUNDO
  
    QTEMP1 = eval(QmatNMR.uiInput1);
    QmatNMR.Spec1D = QmatNMR.Spec1D - mean(real(QmatNMR.Spec1D(QTEMP1))) - sqrt(-1)*mean(imag(QmatNMR.Spec1D(QTEMP1)));
  
    QmatNMR.History = str2mat(QmatNMR.History, ['DC offset correction on 1D FID performed, noise range = ' num2str(QTEMP1(1)) ':' num2str(QTEMP1(length(QTEMP1)))]);
  
    %first add dimension-specific information, and then the current command
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 15, QTEMP1(1), QTEMP1(length(QTEMP1)));	%code for DC corr 1D, range
  
    if QmatNMR.RecordingMacro
      %first add dimension-specific information, and then the current command
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 15, QTEMP1(1), QTEMP1(length(QTEMP1)));	%code for DC corr 1D, range
    end
  
    disp(['1D DC offset correction performed, noise range = ' num2str(QTEMP1(1)) ':' num2str(QTEMP1(length(QTEMP1)))]);
  
    if (~QmatNMR.BusyWithMacro)
      asaanpas
      Arrowhead;
    end
  
  else
    disp('1D DC offset correction cancelled ...');
    QmatNMR.SwitchTo1D = 0;	%reset flag because it is possible that the user came from a 2D but cancelled the action
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
