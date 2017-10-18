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
%regellp1d.m performs the linear prediction of 1D FID's
%
%11-06-'98

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
  
    QmatNMR.lpNrPoints = eval(QmatNMR.uiInput1);
    QmatNMR.lpNrPointsToUse = eval(QmatNMR.uiInput2);
    QmatNMR.lpNrFreqs  = eval(QmatNMR.uiInput3);
    QmatNMR.lpSNratio  = eval(QmatNMR.uiInput4);
  
  
    %
    %give warning if too many points should be taken into account because things get really slow
    %
    if (QmatNMR.lpNrPointsToUse > 256)
      disp('matNMR NOTICE: linear prediction inherently becomes very slow when more than 256 points from the FID')
      disp('matNMR NOTICE: should be used to predict from, and often without improvement over e.g. 128 points.')
      disp('matNMR NOTICE: Please consider to reduce this number!')
    end
  
  					%analyse spectrum: gives damping, ampl., phase, frequency
    if ((QmatNMR.LPtype == 1) | (QmatNMR.LPtype == 3))	%lpsvd method
      if (QmatNMR.lpNrFreqs < 1)
        disp('matNMR WARNING: number of frequencies cannot be smaller than 1 for lpsvd! Aborting ...')
        return;
      end
  
      QTEMP3 = QmatNMR.Spec1D(1:QmatNMR.lpNrPointsToUse);
  
      %account for Fourier mode
      if ((QmatNMR.howFT == 2) | (QmatNMR.howFT == 4) | (QmatNMR.howFT == 8))	%real FT and TPPI and sine FT
        QTEMP3 = real(QTEMP3);
      end
  
      if (norm(QTEMP3) > 100*eps)
        QTEMP2 = lpsvd(QTEMP3, QmatNMR.lpNrFreqs);
      else
        QTEMP2 = [];
      end
      if isempty(QTEMP2)
        QTEMP2 = zeros(1, 4);
      end
  
    else					%itmpm method
      QTEMP3 = QmatNMR.Spec1D(1:QmatNMR.lpNrPointsToUse);
  
      %account for Fourier mode
      if ((QmatNMR.howFT == 2) | (QmatNMR.howFT == 4) | (QmatNMR.howFT == 8))	%real FT and TPPI and sine FT
        QTEMP3 = real(QTEMP3);
      end
  
      if (norm(QTEMP3) > 100*eps)
        QTEMP2 = itcmp(QTEMP3, QmatNMR.lpNrFreqs);
      else
        QTEMP2 = [];
      end
      if isempty(QTEMP2)
        QTEMP2 = zeros(1, 4);
      end
    end
  
  					%Now check whether the algorythms have found
  					%a decent solution: if not, an empty vector is returned ...
    if (length(QTEMP2) < 1)
      disp('ERROR: LP algorythm did not find a proper result, nothing changed !')
    else
  					%predict points and add to the spectrum
      if (QmatNMR.LPtype < 3)		%backward prediction
        QTEMP3 = (cegnt( (-QmatNMR.lpNrPoints):(-1) , QTEMP2, QmatNMR.lpSNratio, 100*rand(1,1))).';
  
        QmatNMR.Spec1D = [QTEMP3 QmatNMR.Spec1D];
  
      					%Add action to history
        if (QmatNMR.LPtype == 1)
          QmatNMR.History = str2mat(QmatNMR.History, ['Linear back prediction: LPSVD, ' num2str(QmatNMR.lpNrPoints) ' points predicted, ' num2str(QmatNMR.lpNrPointsToUse) ' points used to do prediction, ' num2str(QmatNMR.lpNrFreqs) ' freqs, ' num2str(QmatNMR.lpSNratio) ' SN ratio']);
  
          %first add dimension-specific information, and then the current command
          QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
          QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 10, 1, QmatNMR.lpNrPoints, QmatNMR.lpNrPointsToUse, QmatNMR.lpNrFreqs, QmatNMR.lpSNratio);	%code for LP 1D, backward LPSVD, etc ...
  
  	if QmatNMR.RecordingMacro
            %first add dimension-specific information, and then the current command
            QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
            QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 10, 1, QmatNMR.lpNrPoints, QmatNMR.lpNrPointsToUse, QmatNMR.lpNrFreqs, QmatNMR.lpSNratio);	%code for LP 1D, backward LPSVD, etc ...
  	end
  
        else
          QmatNMR.History = str2mat(QmatNMR.History, ['Linear back prediction: ITMPM, ' num2str(QmatNMR.lpNrPoints) ' points predicted, ' num2str(QmatNMR.lpNrPointsToUse) ' points used to do prediction, ' num2str(QmatNMR.lpNrFreqs) ' freqs, ' num2str(QmatNMR.lpSNratio) ' SN ratio']);
  
          %first add dimension-specific information, and then the current command
          QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
          QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 10, 2, QmatNMR.lpNrPoints, QmatNMR.lpNrPointsToUse, QmatNMR.lpNrFreqs, QmatNMR.lpSNratio);	%code for LP 1D, backward ITMPM, etc ...
  
  	if QmatNMR.RecordingMacro
            %first add dimension-specific information, and then the current command
            QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
            QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 10, 2, QmatNMR.lpNrPoints, QmatNMR.lpNrPointsToUse, QmatNMR.lpNrFreqs, QmatNMR.lpSNratio);	%code for LP 1D, backward LPSVD, etc ...
  	end
        end
  
      else				%forward prediction
        QTEMP3 = (cegnt( (QmatNMR.Size1D):(QmatNMR.Size1D+QmatNMR.lpNrPoints-1) , QTEMP2, QmatNMR.lpSNratio, 100*rand(1,1))).';
  
        QmatNMR.Spec1D = [QmatNMR.Spec1D QTEMP3];
  
      					%Add action to history
        if (QmatNMR.LPtype == 3)
          QmatNMR.History = str2mat(QmatNMR.History, ['Linear forward prediction: LPSVD, ' num2str(QmatNMR.lpNrPoints) ' points predicted, ' num2str(QmatNMR.lpNrPointsToUse) ' points used to do prediction, ' num2str(QmatNMR.lpNrFreqs) ' freqs, ' num2str(QmatNMR.lpSNratio) ' SN ratio']);
  
          %first add dimension-specific information, and then the current command
          QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
          QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 10, 3, QmatNMR.lpNrPoints, QmatNMR.lpNrPointsToUse, QmatNMR.lpNrFreqs, QmatNMR.lpSNratio);	%code for LP 1D, forward LPSVD, etc ...
  
  	if QmatNMR.RecordingMacro
            %first add dimension-specific information, and then the current command
            QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
            QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 10, 3, QmatNMR.lpNrPoints, QmatNMR.lpNrPointsToUse, QmatNMR.lpNrFreqs, QmatNMR.lpSNratio);	%code for LP 1D, backward LPSVD, etc ...
  	end
  
        else
          QmatNMR.History = str2mat(QmatNMR.History, ['Linear forward prediction: ITMPM, ' num2str(QmatNMR.lpNrPoints) ' points predicted, ' num2str(QmatNMR.lpNrPointsToUse) ' points used to do prediction, ' num2str(QmatNMR.lpNrFreqs) ' freqs, ' num2str(QmatNMR.lpSNratio) ' SN ratio']);
  
          %first add dimension-specific information, and then the current command
          QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
          QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 10, 4, QmatNMR.lpNrPoints, QmatNMR.lpNrPointsToUse, QmatNMR.lpNrFreqs, QmatNMR.lpSNratio);	%code for LP 1D, forward ITMPM, etc ...
  
  	if QmatNMR.RecordingMacro
            %first add dimension-specific information, and then the current command
            QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
            QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 10, 4, QmatNMR.lpNrPoints, QmatNMR.lpNrPointsToUse, QmatNMR.lpNrFreqs, QmatNMR.lpSNratio);	%code for LP 1D, backward LPSVD, etc ...
  	end
        end
      end
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
  
    disp('1D Linear prediction finished ...');
  
  else
    disp('No linear prediction performed ...');
    QmatNMR.SwitchTo1D = 0;	%reset flag because it is possible that the user came from a 2D but cancelled the action
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
