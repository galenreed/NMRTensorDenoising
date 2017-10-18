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
%regelmem1d.m performs maximum entropy (MEM) reconstruction of 1D FID's
%
%10-06-'09

try
  if QmatNMR.buttonList == 1						%= OK-button
    watch;
  
    if (QmatNMR.SwitchTo1D) 		%switch from 2D to 1D processing if necessary
      SwitchTo1D
    end
  
    %
    %create entry in the undo matrix
    %
    regelUNDO
  
    QmatNMR.MEMNrPoints = eval(QmatNMR.uiInput1);
    QmatNMR.MEMNrPointsToUse = eval(QmatNMR.uiInput2);
    QmatNMR.MEMOrder  = eval(QmatNMR.uiInput3);
  
  
    %
    %use the lpc algorithm to analyze the time-domain data
    %
    QTEMP3 = QmatNMR.Spec1D(1:QmatNMR.MEMNrPointsToUse);
    if (QmatNMR.MEMOrder == -1)
      QTEMP2 = lpc(QTEMP3);
    else
      QTEMP2 = lpc(QTEMP3, QmatNMR.MEMOrder);
    end
  
    %
    %reconstruct the new FID from the filter coefficients
    %
    QmatNMR.Spec1D = filter([1 zeros(1, QmatNMR.MEMOrder)], QTEMP2, [QmatNMR.Spec1D(1) zeros(1, QmatNMR.MEMNrPoints-1)]);
  
  
  
      					%Add action to history
    QmatNMR.History = str2mat(QmatNMR.History, ['Maximum entropy reconstruction: LPC, ' num2str(QmatNMR.MEMNrPoints, 6) ' points in reconstructed FID, ' num2str(QmatNMR.MEMNrPointsToUse, 6) ' points used to do prediction, to order ' num2str(QmatNMR.MEMOrder, 6)]);
  
    %first add dimension-specific information, and then the current command
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 28, QmatNMR.MEMNrPoints, QmatNMR.MEMNrPointsToUse, QmatNMR.MEMOrder);  %code for MEM 1D
  
    if QmatNMR.RecordingMacro
      %first add dimension-specific information, and then the current command
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 28, QmatNMR.MEMNrPoints, QmatNMR.MEMNrPointsToUse, QmatNMR.MEMOrder);  %code for MEM 1D
    end
  
  
  					%redraw the spectrum and give output ....
    QmatNMR.Temp = get(QmatNMR.FID, 'String');
    [QTEMP20, QmatNMR.Size1D] = size(QmatNMR.Spec1D);
    if QmatNMR.Size1D == 1
      QmatNMR.Size1D = QTEMP20;
      QmatNMR.Spec1D = QmatNMR.Spec1D.';
    end
  
    QmatNMR.lbstatus = 0; 		%apodization flag is switched off, just in case
  
  
  
    disp(['size of the new 1D ' deblank(QmatNMR.Temp(QmatNMR.FIDstatus, :)) ' is :  ', num2str(QmatNMR.Size1D), ' points.']);
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
  
    QmatNMR.dph0 = 0;				%reset phase buttons
    QmatNMR.dph1 = 0;
    QmatNMR.dph2 = 0;
    QmatNMR.fase0 = 0;
    QmatNMR.fase1 = 0;
    QmatNMR.fase2 = 0;
    QmatNMR.fase1startIndex = floor(QmatNMR.Size1D/2)+1;
    repair
  
    disp('1D maximum entropy reconstruction finished ...');
  
  else
    disp('No maximum entropy reconstruction performed ...');
    QmatNMR.SwitchTo1D = 0;	%reset flag because it is possible that the user came from a 2D but cancelled the action
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
