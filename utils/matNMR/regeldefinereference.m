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
%regeldefinereference allows manual definition of an external spectral reference.
%
%29-09-'04:

try
  if (QmatNMR.buttonList == 1) 		%OK button
    watch;
  
    QmatNMR.ExternalReferenceFreq  = eval(['[' QmatNMR.uiInput1 ']']);
    QmatNMR.ExternalReferenceValue = eval(['[' QmatNMR.uiInput2 ']']);
    QmatNMR.ExternalReferenceUnit  = eval(['[' QmatNMR.uiInput3 ']']);
    if ~isempty(QmatNMR.uiInput4)
      QmatNMR.ExternalReferenceVar = QmatNMR.uiInput4; 	%variable name to store external reference in
    end
  
  
    %
    %first we check that all three reference input are of equal length and that they correspond
    %to the processing mode (1D or 2D)
    %
    QTEMP1 = [length(QmatNMR.ExternalReferenceFreq) length(QmatNMR.ExternalReferenceValue) length(QmatNMR.ExternalReferenceUnit)];
    if (~isequal(diff(QTEMP1), zeros(1, 2)))
      disp('matNMR WARNING: external reference input incommensurate with processing mode. Please correct!');
      askdefinereference
      return
  
    elseif ((QmatNMR.Dim == 0) & (length(QmatNMR.ExternalReferenceFreq) == 2))
      disp('matNMR WARNING: external reference input incommensurate with processing mode. Please correct!');
      askdefinereference
      return
  
    elseif ((QmatNMR.Dim > 0) & (length(QmatNMR.ExternalReferenceFreq) == 1))
      if (QmatNMR.Dim == 1) 	%only apply these values to TD2
        QmatNMR.ExternalReferenceFreq = [QmatNMR.ExternalReferenceFreq 0];
        QmatNMR.ExternalReferenceValue = [QmatNMR.ExternalReferenceValue 0];
        QmatNMR.ExternalReferenceUnit = [QmatNMR.ExternalReferenceUnit 0];
  
      else			%only apply these values to TD1
        QmatNMR.ExternalReferenceFreq = [0 QmatNMR.ExternalReferenceFreq];
        QmatNMR.ExternalReferenceValue = [0 QmatNMR.ExternalReferenceValue];
        QmatNMR.ExternalReferenceUnit = [0 QmatNMR.ExternalReferenceUnit];
      end
    end
  
  
  
    %
    %All is well to apply the external reference values to the current spectrum
    %  
    if (QmatNMR.Dim == 0) 	%1D mode
      switch (QmatNMR.ExternalReferenceUnit)      %only accept the reference value if the units are in PPM or kHz!
        case 1	    %PPM
      	QmatNMRsettings.DefaultAxisReferencePPM = QmatNMR.ExternalReferenceValue + (QmatNMR.SF1D - QmatNMR.ExternalReferenceFreq)*1e6/QmatNMR.ExternalReferenceFreq;
      	if (QmatNMR.gamma1d == 1)  %y > 0
  	  QmatNMRsettings.DefaultAxisReferencekHz = -(QmatNMRsettings.DefaultAxisReferencePPM * QmatNMR.SF1D)/1000;
      	else
  	  QmatNMRsettings.DefaultAxisReferencekHz =  (QmatNMRsettings.DefaultAxisReferencePPM * QmatNMR.SF1D)/1000;
      	end
      	disp('Applying a reference in ppm for current 1D');
  
        case 2	    %kHz
      	if (QmatNMR.gamma1d == 1)  %y > 0
  	  QmatNMRsettings.DefaultAxisReferencekHz = (QmatNMR.ExternalReferenceValue - (QmatNMR.SF1D - QmatNMR.ExternalReferenceFreq)*1000);
  	  QmatNMRsettings.DefaultAxisReferencePPM = -(QmatNMRsettings.DefaultAxisReferencekHz * 1000 / QmatNMR.SF1D);
      	else
  	  QmatNMRsettings.DefaultAxisReferencekHz = QmatNMR.ExternalReferenceValue + (QmatNMR.SF1D - QmatNMR.ExternalReferenceFreq)*1000;
  	  QmatNMRsettings.DefaultAxisReferencePPM = (QmatNMRsettings.DefaultAxisReferencekHz * 1000 / QmatNMR.SF1D);
      	end
      	disp('Applying a reference in kHz for current 1D');
  	    
        otherwise     %unknown code for the reference value
  	disp('matNMR ERROR: encountered unknown code for the unit of the external reference. Aborting ...');
  	return
      end
  
      %
      %Add to history
      %
      QmatNMR.History = str2mat(QmatNMR.History, ['External reference defined']);
  
      %first add dimension-specific information, and then the current command
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 19, QmatNMR.ExternalReferenceFreq, QmatNMR.ExternalReferenceValue, QmatNMR.ExternalReferenceUnit);	%code for external reference
  
      if QmatNMR.RecordingMacro
        %first add dimension-specific information, and then the current command
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 19, QmatNMR.ExternalReferenceFreq, QmatNMR.ExternalReferenceValue, QmatNMR.ExternalReferenceUnit);			%code for external reference
      end
  
    
    else		%2D mode
      %first TD2
      switch (QmatNMR.ExternalReferenceUnit(1))      %only accept the reference value if the units are in PPM, kHz or Hz!
        case 0	    %no change
  
        case 1	    %PPM
      	QmatNMRsettings.DefaultAxisReferencePPM1 = QmatNMR.ExternalReferenceValue(1) + (QmatNMR.SFTD2 - QmatNMR.ExternalReferenceFreq(1))*1e6/QmatNMR.ExternalReferenceFreq(1);
      	if (QmatNMR.gamma1 == 1)  %y > 0
  	  QmatNMRsettings.DefaultAxisReferencekHz1 = -(QmatNMRsettings.DefaultAxisReferencePPM1 * QmatNMR.SFTD2)/1000;
      	else
  	  QmatNMRsettings.DefaultAxisReferencekHz1 =  (QmatNMRsettings.DefaultAxisReferencePPM1 * QmatNMR.SFTD2)/1000;
      	end
      	disp('Applying a reference in ppm for current 2D');
  
        case 2	    %kHz
      	if (QmatNMR.gamma1 == 1)  %y > 0
  	  QmatNMRsettings.DefaultAxisReferencekHz1 = (QmatNMR.ExternalReferenceValue(1) - (QmatNMR.SFTD2 - QmatNMR.ExternalReferenceFreq(1))*1000);
  	  QmatNMRsettings.DefaultAxisReferencePPM1 = -(QmatNMRsettings.DefaultAxisReferencekHz1 * 1000 / QmatNMR.SFTD2);
      	else
  	  QmatNMRsettings.DefaultAxisReferencekHz1 = QmatNMR.ExternalReferenceValue(1) + (QmatNMR.SFTD2 - QmatNMR.ExternalReferenceFreq(1))*1000;
  	  QmatNMRsettings.DefaultAxisReferencePPM1 = (QmatNMRsettings.DefaultAxisReferencekHz1 * 1000 / QmatNMR.SFTD2);
      	end
      	disp('Applying a reference in kHz for current 2D');
  	    
        otherwise     %unknown code for the reference value
  	disp('matNMR ERROR: encountered unknown code for the unit of the external reference. Aborting ...');
  	return
      end
    
      %then TD1
      switch (QmatNMR.ExternalReferenceUnit(2))      %only accept the reference value if the units are in PPM, kHz or Hz!
        case 0	    %no change
  
        case 1	    %PPM
      	QmatNMRsettings.DefaultAxisReferencePPM2 = QmatNMR.ExternalReferenceValue(2) + (QmatNMR.SFTD1 - QmatNMR.ExternalReferenceFreq(2))*1e6/QmatNMR.ExternalReferenceFreq(2);
      	if (QmatNMR.gamma2 == 1)  %y > 0
  	  QmatNMRsettings.DefaultAxisReferencekHz2 = -(QmatNMRsettings.DefaultAxisReferencePPM2 * QmatNMR.SFTD1)/1000;
      	else
  	  QmatNMRsettings.DefaultAxisReferencekHz2 =  (QmatNMRsettings.DefaultAxisReferencePPM2 * QmatNMR.SFTD1)/1000;
      	end
  
        case 2	    %kHz
      	if (QmatNMR.gamma2 == 1)  %y > 0
  	  QmatNMRsettings.DefaultAxisReferencekHz2 = (QmatNMR.ExternalReferenceValue(2) - (QmatNMR.SFTD1 - QmatNMR.ExternalReferenceFreq(2))*1000);
  	  QmatNMRsettings.DefaultAxisReferencePPM2 = -(QmatNMRsettings.DefaultAxisReferencekHz2 * 1000 / QmatNMR.SFTD1);
      	else
  	  QmatNMRsettings.DefaultAxisReferencekHz2 = QmatNMR.ExternalReferenceValue(1) + (QmatNMR.SFTD1 - QmatNMR.ExternalReferenceFreq(2))*1000;
  	  QmatNMRsettings.DefaultAxisReferencePPM2 = (QmatNMRsettings.DefaultAxisReferencekHz2 * 1000 / QmatNMR.SFTD1);
      	end
  	    
        otherwise     %unknown code for the reference value
  	disp('matNMR ERROR: encountered unknown code for the unit of the external reference. Aborting ...');
  	return
      end
  
  
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
  
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 125, QmatNMR.ExternalReferenceFreq, QmatNMR.ExternalReferenceValue, QmatNMR.ExternalReferenceUnit);	%code for external reference
  
      if QmatNMR.RecordingMacro
        %first add dimension-specific information, and then the current command
        if (QmatNMR.Dim == 1)
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
    
        else
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
        end
  
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 125, QmatNMR.ExternalReferenceFreq, QmatNMR.ExternalReferenceValue, QmatNMR.ExternalReferenceUnit);	%code for external reference
      end
    end
  
  
    %
    %it is necessary to force the explicit definition of the default axes for the dimension(s) that are in default
    %mode because otherwise the axes aren't defined yet. This in turn may cause problems when the user saves the
    %spectrum or goes into the 2D/3D viewer thinking the axes are there but they aren't. 
    %In the checkinput2d routine some variables are simply set as if
    %the dimension was changed and the standard GetDefaultAxis routine is called. Here we do something similar.
    %
    QmatNMR.TEMPRulerXAxis = QmatNMR.RulerXAxis; 	%is the current dimension in default-axis mode?
    if (QmatNMR.Dim == 1) 		%TD2
      if (QmatNMR.ExternalReferenceUnit(2))
        %change the axis for TD1 and force it to default-axis mode if a value was entered
        QmatNMR.Dim = 2;
        QmatNMR.Size1D = QmatNMR.SizeTD1;
        QmatNMR.gamma1d = QmatNMR.gamma2;
        QmatNMR.SW1D = QmatNMR.SWTD1;
        QmatNMR.SF1D = QmatNMR.SFTD1;
        QmatNMR.FIDstatus = QmatNMR.FIDstatus2D2;
        GetDefaultAxis
      end
      
      %reset the dimension-specific parameters
      QmatNMR.Dim = 1;
      QmatNMR.Size1D = QmatNMR.SizeTD2;
      QmatNMR.gamma1d = QmatNMR.gamma1;
      QmatNMR.SW1D = QmatNMR.SWTD2;
      QmatNMR.SF1D = QmatNMR.SFTD2;
      QmatNMR.FIDstatus = QmatNMR.FIDstatus2D1;
      QmatNMR.RulerXAxis = QmatNMR.TEMPRulerXAxis;
  
      %change the axis for TD2 if it is in default-axis mode
      if (QmatNMR.RulerXAxis1 == 0)
        GetDefaultAxis
      end
  
    elseif (QmatNMR.Dim == 2) 	%TD1
      if (QmatNMR.ExternalReferenceUnit(1))
        %change the axis for TD2 and force it to default-axis mode if a value was entered
        QmatNMR.Dim = 1;
        QmatNMR.Size1D = QmatNMR.SizeTD2;
        QmatNMR.gamma1d = QmatNMR.gamma1;
        QmatNMR.SW1D = QmatNMR.SWTD2;
        QmatNMR.SF1D = QmatNMR.SFTD2;
        QmatNMR.FIDstatus = QmatNMR.FIDstatus2D1;
        GetDefaultAxis
      end
  
      %reset the dimension-specific parameters
      QmatNMR.Dim = 2;
      QmatNMR.Size1D = QmatNMR.SizeTD1;
      QmatNMR.gamma1d = QmatNMR.gamma2;
      QmatNMR.SW1D = QmatNMR.SWTD1;
      QmatNMR.SF1D = QmatNMR.SFTD1;
      QmatNMR.FIDstatus = QmatNMR.FIDstatus2D2;
      QmatNMR.RulerXAxis = QmatNMR.TEMPRulerXAxis;
  
      %change the axis for TD1 if it is in default-axis mode
      if (QmatNMR.RulerXAxis2 == 0)
        GetDefaultAxis
      end
    end  
  
  
    %
    %store the reference values in a structure that will be saved along with the spectrum
    %
    QmatNMRsettings.DefaultAxisReference1D.ReferenceFrequency = QmatNMR.ExternalReferenceFreq;
    QmatNMRsettings.DefaultAxisReference1D.ReferenceValue = QmatNMR.ExternalReferenceValue;
    QmatNMRsettings.DefaultAxisReference1D.ReferenceUnit = QmatNMR.ExternalReferenceUnit;
    if (QmatNMR.Dim > 0)
      QmatNMRsettings.DefaultAxisReference2D = QmatNMRsettings.DefaultAxisReference1D;
    end
  
  
    %
    %store the reference values in the workspace if asked for in the input window
    %
    if ~isempty(QmatNMR.uiInput4)
      eval([QmatNMR.ExternalReferenceVar '.ReferenceFrequency = QmatNMR.ExternalReferenceFreq;']);
      eval([QmatNMR.ExternalReferenceVar '.ReferenceValue = QmatNMR.ExternalReferenceValue;']);
      eval([QmatNMR.ExternalReferenceVar '.ReferenceUnit = QmatNMR.ExternalReferenceUnit;']);
    end
  
  
    %
    %Finally update the screen
    %
    asaanpas
    Arrowhead
  
  else
    disp('Manual definition of external reference values cancelled ...');
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
