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
%setphase1d.m handles the phase correction for 1D spectra in matNMR. 
%13-12-'96
%15-12-'00


try
  %
  %if the plot type is not the default plot type then we redraw the spectrum first to
  %avoid problems
  %
  if (QmatNMR.PlotType ~= 1)
    asaanpas
  end
  
  
  %
  %set the undo matrix
  %
  QTEMP = size(QmatNMR.History, 1);
  if (strcmp(QmatNMR.History(QTEMP, 1:5), 'Phase')) | (QmatNMR.Dim)	
  					%if the last entry in the history is a phase correction or we're in
    					%a 2D mode then overwrite that entry with the new values
    QmatNMR.BusyWith1DPhaseCorrection = 1;
  else
    QmatNMR.BusyWith1DPhaseCorrection = 0;
  end
  
  %
  %create entry in the undo matrix
  %
  regelUNDO
  
  QmatNMR.BusyWith1DPhaseCorrection = 0;
  
  
  %
  %test for ACME automatic phasing
  %
  if ~isfield(QmatNMR, 'ACMEphasing')
    QmatNMR.ACMEphasing = 0;
  end
  if (QmatNMR.ACMEphasing == 1)		%perform automatic phase correction using ACME algorithm
    QTEMP2 = optimset;
    %QTEMP2.Display = 'iter';
    tic
    [QTEMP1] = fminsearch('ACMEentropy_fun', [QmatNMR.fase0, QmatNMR.fase1],QTEMP2, QmatNMR.Spec1D, QmatNMR.fase1startIndex);
    disp(['Automatic phasing took ' num2str(toc) ' seconds']);
    QmatNMR.dph0 = QTEMP1(1);
    QmatNMR.dph1 = QTEMP1(2);
    %make sure QmatNMR.fase0 is within the range [-180 180]
    while (abs(QmatNMR.fase0 + QmatNMR.dph0) > 180)
      if ((QmatNMR.fase0 + QmatNMR.dph0) < 0)
        QmatNMR.dph0 = QmatNMR.dph0 + 360;
      else
        QmatNMR.dph0 = QmatNMR.dph0 - 360;
      end
    end
  
    QmatNMR.ACMEphasing = 0;
  end
  
  
  
  %
  %increment the phase and update the screen
  %
  Qi = sqrt(-1)*pi/180;
  
  if QmatNMR.dph0	%there is a 0th-order phase contribution
    QmatNMR.Spec1D = QmatNMR.Spec1D .* exp(Qi*QmatNMR.dph0);
  end
  
  if QmatNMR.dph1	%there is a 1st-order phase contribution
    QmatNMR.z = -((1:QmatNMR.Size1D)-QmatNMR.fase1startIndex)/(QmatNMR.Size1D);
    QmatNMR.Spec1D = QmatNMR.Spec1D .* exp(Qi*QmatNMR.dph1*QmatNMR.z);
  end
  
  if QmatNMR.dph2	%there is a 2nd-order phase contribution
    QmatNMR.z = -2*(((1:QmatNMR.Size1D)-floor(QmatNMR.Size1D/2)-1)/(QmatNMR.Size1D)).^2;
    QmatNMR.Spec1D = QmatNMR.Spec1D .* exp(Qi*QmatNMR.dph2*QmatNMR.z);
  end
  
  if (~QmatNMR.BusyWithMacro)
    Qspcrel
    CheckAxis
    simpelplot
  end  
  
  if (QmatNMR.dph0)
    QmatNMR.fase0 = QmatNMR.fase0 + QmatNMR.dph0;
    set(QmatNMR.p1, 'value', QmatNMR.fase0);				%resetting the sliders buttons in the figure window
    set(QmatNMR.p5, 'value', QmatNMR.fase0, 'string', QmatNMR.fase0);
    QmatNMR.dph0 = 0;
  end
  
  if (QmatNMR.dph1)
    QmatNMR.fase1 = QmatNMR.fase1 + QmatNMR.dph1;
    set(QmatNMR.p11, 'value', QmatNMR.fase1);
    set(QmatNMR.p15, 'value', QmatNMR.fase1, 'string', QmatNMR.fase1);
    QmatNMR.dph1 = 0;
  end
  
  if (QmatNMR.dph2)
    QmatNMR.fase2 = QmatNMR.fase2 + QmatNMR.dph2;
    set(QmatNMR.p24, 'value', QmatNMR.fase2);
    set(QmatNMR.p28, 'value', QmatNMR.fase2, 'string', QmatNMR.fase2);
    QmatNMR.dph2 = 0;
  end
  
  
  
  if ((QmatNMR.fase0 == 0) & (QmatNMR.fase1 == 0) & (QmatNMR.fase2 == 0))
    QmatNMR.bezigmetfase = 0;
  else  
    QmatNMR.bezigmetfase = 1;
  end
  
  
  %
  %2D phasing aid
  %
  update2Daid
  
  
  %
  %History stuff
  %
  if (QmatNMR.Dim == 0)		%Put phase correction in QmatNMR.History for 1D spectra only !
    QTEMP = size(QmatNMR.History, 1);
    if strcmp(QmatNMR.History(QTEMP, 1:5), 'Phase')	%if the last entry in the history is a phase correction
    						%then overwrite that entry with the new values
      if QmatNMR.fase2
        %
        %only mention the 2nd order phase correction if there is a value to report
        %
        QmatNMR.History = str2mat(QmatNMR.History((1:(QTEMP-1)), :), ['Phase correction for 1D spectrum   :  oth order = ' ...
                       num2str(QmatNMR.fase0, 5) '   1st order = ' num2str(QmatNMR.fase1, 5) '   2nd order = ' num2str(QmatNMR.fase2, 5) '   ref. peak Ph1 = ' num2str(QmatNMR.fase1start, 5)]);
  
      else
        %
        %no 2nd order phase correction
        %
        QmatNMR.History = str2mat(QmatNMR.History((1:(QTEMP-1)), :), ['Phase correction for 1D spectrum   :  oth order = ' ...
                       num2str(QmatNMR.fase0, 5) '   1st order = ' num2str(QmatNMR.fase1, 5) '   ref. peak Ph1 = ' num2str(QmatNMR.fase1start, 5)]);
      end
      	     
      QTEMP3 = size(QmatNMR.HistoryMacro, 1);
      QmatNMR.NRdimspecific = 0;
      while (QmatNMR.HistoryMacro(QTEMP3-1-QmatNMR.NRdimspecific, 1) == 400)	%detect any dimension-specific variable settings
        QmatNMR.NRdimspecific = QmatNMR.NRdimspecific + 1;
      end
      QmatNMR.HistoryMacro = QmatNMR.HistoryMacro(1:(QTEMP3-1-QmatNMR.NRdimspecific), :);		%delete previous phase step + dimension-specific step
  
      %first add dimension-specific information, and then the current command
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 12, QmatNMR.fase0, QmatNMR.fase1, QmatNMR.fase1start, QmatNMR.fase2, 1);
  
      if QmatNMR.RecordingMacro
        QTEMP4 = size(QmatNMR.Macro, 1);
        QmatNMR.NRdimspecific = 0;
        while (QmatNMR.Macro(QTEMP4-1-QmatNMR.NRdimspecific, 1) == 400)		%detect any dimension-specific variable settings
          QmatNMR.NRdimspecific = QmatNMR.NRdimspecific + 1;
        end
        QmatNMR.Macro = QmatNMR.Macro(1:(QTEMP4-1-QmatNMR.NRdimspecific), :);		%delete previous phase step + dimension-specific step
  
        %first add dimension-specific information, and then the current command
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 12, QmatNMR.fase0, QmatNMR.fase1, QmatNMR.fase1start, QmatNMR.fase2, 1);
      end  
  
    else                   
      if QmatNMR.fase2
        %
        %only mention the 2nd order phase correction if there is a value to report
        %
        QmatNMR.History = str2mat(QmatNMR.History, ['Phase correction for 1D spectrum   :  oth order = ' ...
                       num2str(QmatNMR.fase0, 5) '   1st order = ' num2str(QmatNMR.fase1, 5) '   2nd order = ' num2str(QmatNMR.fase2, 5) '   ref. peak Ph1 = ' num2str(QmatNMR.fase1start, 5)]);
  
      else
        %
        %no 2nd order phase correction to report
        %
        QmatNMR.History = str2mat(QmatNMR.History, ['Phase correction for 1D spectrum   :  oth order = ' ...
                       num2str(QmatNMR.fase0, 5) '   1st order = ' num2str(QmatNMR.fase1, 5) '   ref. peak Ph1 = ' num2str(QmatNMR.fase1start, 5)]);
      end
  
      %first add dimension-specific information, and then the current command
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 12, QmatNMR.fase0, QmatNMR.fase1, QmatNMR.fase1start, QmatNMR.fase2, 1);
  
      if QmatNMR.RecordingMacro
        %first add dimension-specific information, and then the current command
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 12, QmatNMR.fase0, QmatNMR.fase1, QmatNMR.fase1start, QmatNMR.fase2, 1);
      end  
    end
  
  
    %
    %clear the a posteriori entries
    %
    QmatNMR.APosterioriMacro = AddToMacro;
    QmatNMR.APosterioriHistory = '';
  
  
  else
      %
      %in case of a user apodizing a slice of a 2D spectrum, and afterwards switching to a 1D mode, then the
      %phase correction is added a posteriori in the SwitchTo1D routine.
      %
      QmatNMR.APosterioriMacro = AddToMacro;
      QmatNMR.APosterioriMacro = AddToMacro(QmatNMR.APosterioriMacro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
      QmatNMR.APosterioriMacro = AddToMacro(QmatNMR.APosterioriMacro, 12, QmatNMR.fase0, QmatNMR.fase1, QmatNMR.fase1start, QmatNMR.fase2, 1);
  
      QmatNMR.APosterioriHistory = ['Phase correction for 1D spectrum   :  oth order = ' num2str(QmatNMR.fase0, 5) '   1st order = ' num2str(QmatNMR.fase1, 5) '   ref. peak Ph1 = ' num2str(QmatNMR.fase1start, 5)];
  end
  
  clear Qi QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
