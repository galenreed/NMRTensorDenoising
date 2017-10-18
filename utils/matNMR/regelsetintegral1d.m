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
%regelsetintegral1d.m handles setting the integral of a 1D spectrum from the matNMR main window
%16-10-'06

try
  if (QmatNMR.buttonList == 1)
    watch
  
    if (QmatNMR.SwitchTo1D) 		%switch from 2D to 1D processing if necessary
      SwitchTo1D
    end
  
    %
    %create entry in the undo matrix
    %
    regelUNDO
  
    					%
  					%re-Check the range that was given as input
  					%
    QTEMP3 = findstr(QmatNMR.uiInput1, ':');	%range in 1D spectrum
    if (length(QTEMP3) == 1) 		%only 1 colon i.e. begin:end
      if (LinearAxis(QmatNMR.Axis1D))	%for a linear axis the range can be given in the axis units
        QTEMP4 = sort([str2num(QmatNMR.uiInput1(1:(QTEMP3(1)-1))) str2num(QmatNMR.uiInput1((QTEMP3(1)+1):(length(QmatNMR.uiInput1))))]);
        QmatNMR.valTD2 = sort(round((QTEMP4-QmatNMR.Rnull) ./ QmatNMR.Rincr));
  
      else				%for a non-linear axis the minimum distance to two points on the axis grid are determined
        QTEMP7 = abs(QmatNMR.Axis1D-str2num(QmatNMR.uiInput1(1:(QTEMP3(1)-1))));
        QTEMP8 = abs(QmatNMR.Axis1D-str2num(QmatNMR.uiInput1((QTEMP3(1)+1):(length(QmatNMR.uiInput1)))));
        QmatNMR.valTD2 = sort([find(QTEMP7 == min(QTEMP7)) find(QTEMP8 == min(QTEMP8))]);
      end
  
      QmatNMR.valTD2(3) = 1; 			%increment in points;
      QmatNMR.valTD2(4) = 0; 			%increment in unit of axis (0=no increment given);
  
    elseif (length(QTEMP3) == 2) 		%2 colons i.e. begin:increment:end
      if (LinearAxis(QmatNMR.AxisTD2))	%for a linear axis the range is determined by using the axis increment and offset
        QTEMP4 = sort([str2num(QmatNMR.uiInput1(1:(QTEMP3(1)-1))) str2num(QmatNMR.uiInput1((QTEMP3(2)+1):(length(QmatNMR.uiInput1))))]);
        QmatNMR.valTD2 = sort(round((QTEMP4-QmatNMR.Rnull1) ./ QmatNMR.Rincr1));
        QmatNMR.valTD2(3) = round(abs(str2num(QmatNMR.uiInput1((QTEMP3(1)+1):(QTEMP3(2)-1))) / QmatNMR.Rincr1));
        QmatNMR.valTD2(4) = str2num(QmatNMR.uiInput1((QTEMP3(1)+1):(QTEMP3(2)-1))); 	%increment in unit of axis (0=no increment given);
  
        if (QmatNMR.valTD2(3) == 0)
          disp('matNMR WARNING: increment for TD2 is 0! Aborting extraction ...');
          return
        end
  
      else				%for a non-linear axis an increment is not accepted
        disp('matNMR WARNING: specifying an increment is not allowed for a non-linear axis vector. Aborting ...');
        return
      end
    else
      disp('matNMR WARNING: incorrect format for integration range. Aborting ...');
      return
    end
  
  					%Check the given ranges in points.
    if (QmatNMR.valTD2(1) < 1); QmatNMR.valTD2(1)=1; end
    if (QmatNMR.valTD2(2) > QmatNMR.Size1D); QmatNMR.valTD2(2)=QmatNMR.Size1D; end
    if ~(QmatNMR.Rincr == round(QmatNMR.Rincr))
      disp('matNMR NOTICE: integration range may suffer from rounding errors.');
    end
  
    %
    %test integrity of integration value
    %
    try
      QTEMP2 = eval(QmatNMR.uiInput2);
    catch
      disp('matNMR WARNING: incorrect integration value. Please check ...');
      beep
      return
    end
  
  
  
  					%activate corrected range
    QTEMP = [num2str(QmatNMR.valTD2(1), 10) ':' num2str(QmatNMR.valTD2(3), 10) ':' num2str(QmatNMR.valTD2(2), 10)];
    eval(['QmatNMR.Spec1D = ' QmatNMR.uiInput2 '*QmatNMR.Spec1D/sum(real(QmatNMR.Spec1D(' QTEMP ')));']);
  
    disp(['Spectrum integrated to ' QmatNMR.uiInput2 ' for range : (' QmatNMR.uiInput1 ')']);
    QmatNMR.History = str2mat(QmatNMR.History, ['Spectrum integrated to ' QmatNMR.uiInput2 ' for range : (' QmatNMR.uiInput1 ')']);
  
    %first add dimension-specific information, and then the current command
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 20, QmatNMR.Axis1D(QmatNMR.valTD2(1)), QmatNMR.Axis1D(QmatNMR.valTD2(2)), QmatNMR.valTD2(4), QTEMP2);
  
    if QmatNMR.RecordingMacro
      %first add dimension-specific information, and then the current command
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 20, QmatNMR.Axis1D(QmatNMR.valTD2(1)), QmatNMR.Axis1D(QmatNMR.valTD2(2)), QmatNMR.valTD2(4), QTEMP2);
    end
  
  
    if (~QmatNMR.BusyWithMacro)
      asaanpas
      Arrowhead
    end
  
  else
    disp('Setting the integral of the 1D spectrum was cancelled ...');
    QmatNMR.SwitchTo1D = 0;	%reset flag because it is possible that the user came from a 2D but cancelled the action
  end;
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
