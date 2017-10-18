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
%regelregrid1d.m takes care of the input for regridding the current 1D spectrum to a new axis
%14-11-'07

try
  if QmatNMR.buttonList == 1
    watch;
  
    %
    %create entry in the undo matrix
    %
    regelUNDO
  
  
    %
    %evaluate the new axes and algorithm input
    %
    try
      QmatNMR.RegridAxisTD2 = QmatNMR.uiInput1;
      QTEMP2 = eval(QmatNMR.uiInput1);
  
    catch
      beep
      error('matNMR WARNING: input did not result in proper axes. Please correct. Aborting ...');
      return
    end
    QmatNMR.RegridAlgorithm = QmatNMR.uiInput2;
  
  
    %
    %Regrid the spectrum
    %
    QmatNMR.Spec1D = matNMRRegridSpectrum1D(QmatNMR.Spec1D, QmatNMR.Axis1D, QTEMP2, QmatNMR.RegridAlgorithm);
  
  
    %
    %Define the new axes and spectrum size
    %
    QmatNMR.Axis1D = QTEMP2;
    QmatNMR.Size1D = length(QmatNMR.Axis1D);
    detaxisprops;
  
  
    %
    %create history entries before making all changes
    %
    QmatNMR.History = str2mat(QmatNMR.History, ['Spectrum regridded to new axes']);
  
    QTEMP6 = 0; 		%flag for linear axis in the history entry
    if (~LinearAxis(QmatNMR.Axis1D))
      %
      %non-linear axes are stored entirely in the processing macro
      %
      QmatNMR.RincrOLD = 'QmatNMR.uiInput1 = ''[';
      for QTEMP4 = 1:length(QmatNMR.Axis1D)
        QmatNMR.RincrOLD = [QmatNMR.RincrOLD num2str(QmatNMR.Axis1D(QTEMP4), 10) ' '];
      end
  
      QmatNMR.RincrOLD = [QmatNMR.RincrOLD ']'''];
      QTEMP11 = double(QmatNMR.RincrOLD);
      QTEMP12 = ceil(length(QTEMP11)/(QmatNMR.MacroLength-1));
      QTEMP11 = [QTEMP11 zeros(1, QTEMP12*(QmatNMR.MacroLength-1) - length(QTEMP11))];
      QTEMP13 = zeros(QTEMP12, QmatNMR.MacroLength);
      QTEMP13(:, 2:end) = reshape(QTEMP11, QmatNMR.MacroLength-1, QTEMP12).';
      QTEMP13(:, 1) = 711;
  
      QmatNMR.HistoryMacro = [QmatNMR.HistoryMacro; QTEMP13];
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 712);
  
      if QmatNMR.RecordingMacro
        QmatNMR.Macro = [QmatNMR.Macro; QTEMP13];
      end
      if QmatNMR.RecordingMacro
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 712);
      end
  
      QTEMP6 = 1;
    end
  
  
    %first add dimension-specific information, and then the current command
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 21, QmatNMR.Rincr, QmatNMR.Rnull, QTEMP6, QmatNMR.Size1D, QmatNMR.RegridAlgorithm);
  
    if QmatNMR.RecordingMacro
      %first add dimension-specific information, and then the current command
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 21, QmatNMR.Rincr, QmatNMR.Rnull, QTEMP6, QmatNMR.Size1D, QmatNMR.RegridAlgorithm);
    end
  
  
    %
    %Switch off the default axis
    %
    QmatNMR.RulerXAxis = 1;
    set(QmatNMR.h670, 'checked', 'off'); 	%switch off the check flag in the menubar
  
    CheckAxis;                        %checks whether the axis is ascending or descending and adjusts the
  					%plot0direction if necessary
  
    disp('Current 1D spectrum regridded to new axes');
    disp(['New size of the 1D is :  ', num2str(QmatNMR.Size1D) ' points.']);
  
  
    %
    %redraw
    %
    if (~QmatNMR.BusyWithMacro)
      asaanpas
      Arrowhead
    end
  
  
    clear QTEMP*
  
  else
    disp('Regridding of current 1D spectrum aborted !!');
    QmatNMR.SwitchTo1D = 0;	%reset flag because it is possible that the user came from a 2D but cancelled the action
  end

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
