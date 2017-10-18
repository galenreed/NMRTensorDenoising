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
%regelextract1d.m cuts takes a part from a 1D spectrum/FID and makes it the new spectrum
%
%11-06-'98
%renamed 24-09-'03

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
  
	  %
		%re-Check the range that was given as input
		%
    QTEMP3 = findstr(QmatNMR.uiInput1, ':');	%range in 1D spectrum
    if (length(QTEMP3) == 1) 		%only 1 colon i.e. begin:end
      if (LinearAxis(QmatNMR.Axis1D))	%for a linear axis the range can be given in the axis units
        eval(['QTEMP4 = sort([' QmatNMR.uiInput1(1:(QTEMP3(1)-1)) ' ' QmatNMR.uiInput1((QTEMP3(1)+1):(length(QmatNMR.uiInput1))) ']);']);
        QmatNMR.valTD2 = sort(round((QTEMP4-QmatNMR.Rnull) ./ QmatNMR.Rincr));
  
      else				%for a non-linear axis the minimum distance to two points on the axis grid are determined
        eval(['QTEMP7 = abs(QmatNMR.Axis1D - ' QmatNMR.uiInput1(1:(QTEMP3(1)-1)) ');']);
        eval(['QTEMP8 = abs(QmatNMR.Axis1D - ' QmatNMR.uiInput1((QTEMP3(1)+1):(length(QmatNMR.uiInput1))) ');']);
        QmatNMR.valTD2 = sort([find(QTEMP7 == min(QTEMP7)) find(QTEMP8 == min(QTEMP8))]);
      end
  
      QmatNMR.valTD2(3) = 1; 			%increment in points;
      QmatNMR.valTD2(4) = 0; 			%increment in unit of axis (0=no increment given);
  
    elseif (length(QTEMP3) == 2) 		%2 colons i.e. begin:increment:end
      if (LinearAxis(QmatNMR.Axis1D))	%for a linear axis the range is determined by using the axis increment and offset
        eval(['QTEMP4 = sort([' QmatNMR.uiInput1(1:(QTEMP3(1)-1)) ' ' QmatNMR.uiInput1((QTEMP3(2)+1):(length(QmatNMR.uiInput1))) ']);']);
  
        QmatNMR.valTD2 = sort(round((QTEMP4-QmatNMR.Rnull) ./ QmatNMR.Rincr));
        eval(['QmatNMR.valTD2(4) = ' QmatNMR.uiInput1((QTEMP3(1)+1):(QTEMP3(2)-1)) ';']); 	%increment in unit of axis (0=no increment given);
        QmatNMR.valTD2(3) = round(abs(QmatNMR.valTD2(4) / QmatNMR.Rincr));
  
        if (QmatNMR.valTD2(3) == 0)
          disp('matNMR WARNING: increment for TD2 is 0! Aborting extraction ...');
          return
        end
  
      else				%for a non-linear axis an increment is not accepted
        disp('matNMR WARNING: specifying an increment is not allowed for a non-linear axis vector. Aborting ...');
        return
      end
    else
      disp('matNMR WARNING: incorrect format for extraction range. Aborting ...');
      return
    end
  
  
  					%Check the given ranges in points.
    if (QmatNMR.valTD2(1) < 1); QmatNMR.valTD2(1)=1; end
    if (QmatNMR.valTD2(2) > QmatNMR.Size1D); QmatNMR.valTD2(2)=QmatNMR.Size1D; end
    if ~(QmatNMR.Rincr == round(QmatNMR.Rincr))
      disp('matNMR NOTICE: extraction range may suffer from rounding errors.');
    end
  
  					%activate corrected ranges
    QmatNMR.uiInput1 = [num2str(QmatNMR.valTD2(1), 10) ':' num2str(QmatNMR.valTD2(3), 10) ':' num2str(QmatNMR.valTD2(2), 10)];
  
    %
    %create history entries before making all changes
    %
    QmatNMR.History = str2mat(QmatNMR.History, ['Range extracted from 1D: ' QmatNMR.uiInput1], ['The new size of the 1D spectrum is : ', num2str(QmatNMR.Size1D)]);
  
    %first add dimension-specific information, and then the current command
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 3, QmatNMR.Axis1D(QmatNMR.valTD2(1)), QmatNMR.Axis1D(QmatNMR.valTD2(2)), QmatNMR.valTD2(4));
  
    if QmatNMR.RecordingMacro
      %first add dimension-specific information, and then the current command
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 3, QmatNMR.Axis1D(QmatNMR.valTD2(1)), QmatNMR.Axis1D(QmatNMR.valTD2(2)), QmatNMR.valTD2(4));
    end
  
    %
    %create the new spectrum
    %
    QmatNMR.Spec1D = eval(['QmatNMR.Spec1D(' QmatNMR.uiInput1 ')']);
  
    %
    %update the sweepwidth
    %
    QTEMP17 = QmatNMR.SW1D;
    QmatNMR.SW1D = QmatNMR.SW1D*length(QmatNMR.Spec1D)/QmatNMR.Size1D;
  
    %
    %Then determine the new size
    %
    [QTEMP20, QmatNMR.Size1D] = size(QmatNMR.Spec1D);
  
    %
    %adapt the reference values for the default axis for the extracted part of the spectrum, just in case the user will revert back
    %
    if (QmatNMR.FIDstatus == 1) 		%spectrum
      %determine the position of the carrier relative to the center of the new axis
      QmatNMRsettings.DefaultAxisCarrierIndex = QmatNMRsettings.DefaultAxisCarrierIndex + 1 - QmatNMR.valTD2(1);
  
      %determine the position of the reference for 1st-order phase correction relative to the center of the new axis
      QmatNMR.fase1startIndex = QmatNMR.fase1startIndex + 1 - QmatNMR.valTD2(1);
      if (QmatNMR.fase1startIndex < 1) | (QmatNMR.fase1startIndex > QmatNMR.Size1D)
        %old reference is no longer in the spectrum. so we take the center of the spectrum again
        QmatNMR.fase1startIndex = floor(QmatNMR.Size1D/2)+1;
      end
    end
  
    %
    %create the new axis
    %
    if (QmatNMR.RulerXAxis == 1)		%flag for user-defined axis
      if ((QmatNMR.Rincr == 1) & (QmatNMR.Rnull == 0))	%if the previous axis was in points then keep it like that
        QmatNMR.Axis1D = 1:QmatNMR.Size1D;		%while starting at 1 again.
      else
        QmatNMR.Axis1D = eval(['QmatNMR.Axis1D(' QmatNMR.uiInput1 ')']);
      end
  
    else
      GetDefaultAxis
    end
    detaxisprops
  
    %
    %Other stuff ...
    %
    QmatNMR.lbstatus=0;				%reset linebroadening flag and button
  
    setfourmode
    disp(['The new size of the 1D spectrum is : ', num2str(QmatNMR.Size1D) ' points.']);
  
    if (~QmatNMR.BusyWithMacro)
      asaanpas
      Arrowhead
    end
  
  else
    disp('No changes made in the size of the spectrum !');
    QmatNMR.SwitchTo1D = 0;	%reset flag because it is possible that the user came from a 2D but cancelled the action
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
