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
%regelswapecho.m swaps a whole echo FID such that the maximum of the echo is the first point
%of the new FID. All points before the maximum are put at the end of the FID.
%When the echo maximum is exactly in the center of the spectrum a fftshift also works!
%
%5-11-'98

try
  if QmatNMR.buttonList == 1
    watch
  
    if (QmatNMR.SwitchTo1D) 		%switch from 2D to 1D processing if necessary
      SwitchTo1D
    end
  
    %
    %create entry in the undo matrix
    %
    regelUNDO
  
    QmatNMR.SwapEcho = round(str2num(QmatNMR.uiInput1));
  
    if (QmatNMR.Dim == 0)			%for 1D FID's
      QmatNMR.Spec1D = [QmatNMR.Spec1D(QmatNMR.SwapEcho:QmatNMR.Size1D) QmatNMR.Spec1D(1:(QmatNMR.SwapEcho-1))];
  
      QmatNMR.History = str2mat(QmatNMR.History, ['1D whle echo FID swapped around point ' num2str(QmatNMR.SwapEcho)]);
  
      %first add dimension-specific information, and then the current command
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 2, QmatNMR.SwapEcho);	%code for swap echo, center to swap around
  
      if QmatNMR.RecordingMacro
        %first add dimension-specific information, and then the current command
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 2, QmatNMR.SwapEcho);	%code for swap echo, center to swap around
      end
  
      repair
      disp(['1D whole echo FID swapped around point ' num2str(QmatNMR.SwapEcho)]);
  
  
    elseif (QmatNMR.Dim == 1)		%apply on 2D row (TD2)
      QmatNMR.Spec2D = [QmatNMR.Spec2D(:, QmatNMR.SwapEcho:QmatNMR.SizeTD2) QmatNMR.Spec2D(:, 1:(QmatNMR.SwapEcho-1))];
      QmatNMR.Spec2Dhc = [QmatNMR.Spec2Dhc(:, QmatNMR.SwapEcho:QmatNMR.SizeTD2) QmatNMR.Spec2Dhc(:, 1:(QmatNMR.SwapEcho-1))];
      getcurrentspectrum;		%get correct row or column from 2D
  
      QmatNMR.History = str2mat(QmatNMR.History, ['TD2 domain of 2D whole echo FID swapped around point ' num2str(QmatNMR.SwapEcho)]);
  
      %first add dimension-specific information, and then the current command
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
  
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 104, QmatNMR.SwapEcho, QmatNMR.Dim);	%code for swap echo, center to swap around, dimension
  
      if QmatNMR.RecordingMacro
        %first add dimension-specific information, and then the current command
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
  
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 104, QmatNMR.SwapEcho, QmatNMR.Dim);	%code for swap echo, center to swap around, dimension
      end
  
      disp(['TD2 domain of 2D whole echo FID swapped around point ' num2str(QmatNMR.SwapEcho)]);
  
  
    else					%apply on 2D columns (TD1)
      QmatNMR.Spec2D = [QmatNMR.Spec2D(QmatNMR.SwapEcho:QmatNMR.SizeTD2, :) QmatNMR.Spec2D(1:(QmatNMR.SwapEcho-1), :)];
      QmatNMR.Spec2Dhc = [QmatNMR.Spec2Dhc(QmatNMR.SwapEcho:QmatNMR.SizeTD2, :) QmatNMR.Spec2Dhc(1:(QmatNMR.SwapEcho-1), :)];
      getcurrentspectrum;		%get correct row or column from 2D
  
      QmatNMR.History = str2mat(QmatNMR.History, ['TD1 domain of 2D whole echo FID swapped around point ' num2str(QmatNMR.SwapEcho)]);
  
      %first add dimension-specific information, and then the current command
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
  
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 104, QmatNMR.SwapEcho, QmatNMR.Dim);	%code for swap echo, center to swap around, dimension
  
      if QmatNMR.RecordingMacro
        %first add dimension-specific information, and then the current command
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
  
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 104, QmatNMR.SwapEcho, QmatNMR.Dim);	%code for swap echo, center to swap around, dimension
      end
  
      disp(['TD1 domain of 2D whole echo FID swapped around point ' num2str(QmatNMR.SwapEcho)]);
  
    end
  
    %
    %additionally we set the FT mode to whole-echo to speed up things.
    %
    QmatNMR.howFT = 5;
    set(QmatNMR.Four, 'value', QmatNMR.howFT);
    resetfourmode
  
    if (~QmatNMR.BusyWithMacro)
      asaanpas
      Arrowhead;
    end
  
  else
    disp('Swapping of the whole echo FID is cancelled ...');
    QmatNMR.SwitchTo1D = 0;	%reset flag because it is possible that the user came from a 2D but cancelled the action
  end

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
