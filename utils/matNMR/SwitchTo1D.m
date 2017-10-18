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
%SwitchTo1D takes cares of switching from 2D to 1D. It sets the appropriate variables.
%
%07-05-2004

try
  QmatNMR.SwitchTo1D 	= 0; 		%the flag variable that calls this routine
  if (QmatNMR.Dim)			%if we are currently in a 2D mode then
    %
    %take over the Fourier mode setting
    %
    QmatNMR.four2 = QmatNMR.howFT;					%Read current fourier mode
    
    
    QmatNMR.LineTag1D 	= QmatNMR.LineTag2D; 	%since we're switching mode we take the 2D line tag
    QmatNMR.LineTag      = QmatNMR.LineTag1D;
    
    %set the external reference data for the 1D equal to that of the 2D
    QmatNMRsettings.DefaultAxisReference1D = QmatNMRsettings.DefaultAxisReference2D;
  
    
    %
    %make sure that:
    % - the current 2D slice is remembered by the history macro
    % - the reference values for the default axis are taken over into the 1D mode
    %
    if (QmatNMR.Dim == 1)		%current dimension is TD2
      %first add dimension-specific information, and then the current command
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 401);
  
      if QmatNMR.RecordingMacro
        %first add dimension-specific information, and then the current command
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 401);
      end
      
      QmatNMRsettings.DefaultAxisReferencekHz = QmatNMRsettings.DefaultAxisReferencekHz1;
      QmatNMRsettings.DefaultAxisReferencePPM = QmatNMRsettings.DefaultAxisReferencePPM1;
      QmatNMRsettings.DefaultAxisCarrierIndex = QmatNMRsettings.DefaultAxisCarrierIndex1;
    
    else
      %first add dimension-specific information, and then the current command
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 401);
  
      if QmatNMR.RecordingMacro
        %first add dimension-specific information, and then the current command
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 401);
      end
  
      QmatNMRsettings.DefaultAxisReferencekHz = QmatNMRsettings.DefaultAxisReferencekHz2;
      QmatNMRsettings.DefaultAxisReferencePPM = QmatNMRsettings.DefaultAxisReferencePPM2;
      QmatNMRsettings.DefaultAxisCarrierIndex = QmatNMRsettings.DefaultAxisCarrierIndex2;
    end
  
    
    %
    %Add a statement to the history
    %
    QmatNMR.History = str2mat(QmatNMR.History, 'Switched from 2D to 1D mode');
  
  
    %
    %Just in case that we need to append to the history and history macro
    %
    if (size(QmatNMR.APosterioriMacro, 1) > 1)
      QmatNMR.History = str2mat(QmatNMR.History, QmatNMR.APosterioriHistory);
      QmatNMR.HistoryMacro = [QmatNMR.HistoryMacro; QmatNMR.APosterioriMacro(2:end, :)];
  
      if QmatNMR.RecordingMacro
        QmatNMR.Macro = [QmatNMR.Macro; QmatNMR.APosterioriMacro(2:end, :)];
      end
    end
  end
  
  %
  %set the flag for 1D mode
  %
  QmatNMR.Dim 	= 0;
  
  %
  %switch off the 2D phasing aid if necessary
  %
  switch2Daid
  

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
