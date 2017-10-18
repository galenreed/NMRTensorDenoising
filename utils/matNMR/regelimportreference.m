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
%regelimportreference deals with importing an external reference from disk.
%
%26-07-'04

try
  if (QmatNMR.buttonList == 1)				%OK-button 
    watch;
    disp('Please wait while matNMR is reading the appropriate file with the reference values ...');
  
    QmatNMR.Xpath = QmatNMR.uiInput1;
    QmatNMR.DataFormat = QmatNMR.uiInput2;		%what format to read in
    QmatNMR.ExternalReferenceVar = QmatNMR.uiInput3; 	%variable name to store external reference in
  
    %
    %Now import the reference values
    %
    [QTEMP1, QTEMP2, QTEMP3, QTEMP4, QTEMP5] = QReadReferenceParameterFiles(QmatNMR.DataFormat, QmatNMR.Xpath);
    if (QmatNMR.Dim == 0)	    %1D mode
      QmatNMRsettings.DefaultAxisReferencekHz = QTEMP1(1);
      QmatNMRsettings.DefaultAxisReferencePPM = QTEMP2(1);
  
      %
      %Add to history
      %
      QmatNMR.History = str2mat(QmatNMR.History, ['External reference defined']);
  
      %first add dimension-specific information, and then the current command
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 19, QTEMP3, QTEMP4, QTEMP5);	%code for external reference
  
      if QmatNMR.RecordingMacro
        %first add dimension-specific information, and then the current command
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 19, QTEMP3, QTEMP4, QTEMP5);			%code for external reference
      end
  
    else
      QmatNMRsettings.DefaultAxisReferencekHz1 = QTEMP1(1);
      QmatNMRsettings.DefaultAxisReferencekHz2 = QTEMP1(2);
  
      QmatNMRsettings.DefaultAxisReferencePPM1 = QTEMP2(1);
      QmatNMRsettings.DefaultAxisReferencePPM2 = QTEMP2(2);
  
  
      %
      %Add to history
      %
      QmatNMR.History = str2mat(QmatNMR.History, ['External reference defined']);
  
      %first add dimension-specific information, and then the current command
      if (QmatNMR.Dim == 1)
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
  
      else
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
      end
  
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 125, [QTEMP3 QTEMP3], [QTEMP4 QTEMP4], [QTEMP5 QTEMP5]);	%code for external reference
  
      if QmatNMR.RecordingMacro
        %first add dimension-specific information, and then the current command
        if (QmatNMR.Dim == 1)
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
    
        else
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
        end
  
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 125, [QTEMP3 QTEMP3], [QTEMP4 QTEMP4], [QTEMP5 QTEMP5]);			%code for external reference
      end
    end
  
    
    %
    %store the reference values in the workspace is asked for
    %
    if ~isempty(QmatNMR.ExternalReferenceVar)
      eval(['clear ' QmatNMR.ExternalReferenceVar]);
      eval([QmatNMR.ExternalReferenceVar '.ReferenceFrequency = QTEMP3;']);
      eval([QmatNMR.ExternalReferenceVar '.ReferenceValue = QTEMP4;']);
      eval([QmatNMR.ExternalReferenceVar '.ReferenceUnit = QTEMP5;']);
    end
  
    asaanpas
    Arrowhead
  
  else
    disp('Importing of external reference values cancelled ...');
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
