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
%transponeer.m transposes the current 2D spectrum.
%10-12-'97

try
  if (QmatNMR.Dim == 0)
    disp('matNMR NOTICE: 2D processing functions are not allowed in 1D mode!')
  
  else  
    if QmatNMR.lbstatus | QmatNMR.bezigmetfase
      disp('matNMR WARNING:  not possible while apodizing or phasing!     transpose cancelled');
    
    else
      watch;
    
      %
      %create entry in the undo matrix
      %
      regelUNDO
    
      QmatNMR.Spec2D = QmatNMR.Spec2D.';
      QmatNMR.Spec2Dhc = QmatNMR.Spec2Dhc.';
    
      [QmatNMR.SizeTD1, QmatNMR.SizeTD2] = size(QmatNMR.Spec2D);
      disp(['New size of the 2D FID/spectrum is :  ', num2str(QmatNMR.SizeTD1), ' x ', num2str(QmatNMR.SizeTD2), ' points (td1 x td2).']);
  
  
      %
      %Add the action to the history
      %
      QmatNMR.History = str2mat(QmatNMR.History, ['2D matrix transposed ... New size of the 2D FID/spectrum is :  ', num2str(QmatNMR.SizeTD1), ' x ', num2str(QmatNMR.SizeTD2), ' points (td1 x td2).']);
  
      %first add dimension-specific information, and then the current command
      if (QmatNMR.Dim == 1)		%TD2
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
      
      else
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
      end
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 120);
    
      if QmatNMR.RecordingMacro
        %first add dimension-specific information, and then the current command
        if (QmatNMR.Dim == 1)	%TD2
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
        
        else
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
        end
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 120);
      end
  
  
      
      QmatNMR.lbstatus=0;				%reset linebroadening flag and button
    
      QTEMP1 = QmatNMR.AxisTD2;			%swap the axes
      QmatNMR.AxisTD2 = QmatNMR.AxisTD1;
      QmatNMR.AxisTD1 = QTEMP1;
      QmatNMR.Axis1D = QmatNMR.AxisTD2;
      
      QTEMP1 = QmatNMR.RulerXAxis2;		%swap the flag for user-defined axis
      QmatNMR.RulerXAxis2 = QmatNMR.RulerXAxis1;
      QmatNMR.RulerXAxis1 = QTEMP1;
      
      QTEMP1 = QmatNMR.texie2;			%swap the axis unit description
      QmatNMR.texie2 = QmatNMR.texie1;
      QmatNMR.texie1 = QTEMP1;
  
      QTEMP1 = QmatNMR.FIDstatus2D2;		%swap the FID status
      QmatNMR.FIDstatus2D2 = QmatNMR.FIDstatus2D1;
      QmatNMR.FIDstatus2D1 = QTEMP1;
      
      if (QmatNMR.Dim==1)
        QmatNMR.Size1D = QmatNMR.SizeTD2;
        QmatNMR.texie = QmatNMR.texie1;
        QmatNMR.RulerXAxis = QmatNMR.RulerXAxis1;
        QmatNMR.FIDstatus = QmatNMR.FIDstatus2D1;
        
      else
        QmatNMR.Size1D = QmatNMR.SizeTD1;
        QmatNMR.texie = QmatNMR.texie2;
        QmatNMR.RulerXAxis = QmatNMR.RulerXAxis2;
        QmatNMR.FIDstatus = QmatNMR.FIDstatus2D2;
      end
          
      detaxisprops
     
      %reset the phase variables
      QmatNMR.fase0 = 0;
      QmatNMR.fase1 = 0;
      QmatNMR.fase2 = 0;
      QmatNMR.fase1startIndex = floor(QmatNMR.Size1D/2)+1;
      QmatNMR.fase1start = interp1((1:QmatNMR.Size1D).', QmatNMR.Axis1D, QmatNMR.fase1startIndex);
    
      QmatNMR.dph0 = 0;
      QmatNMR.dph1 = 0;
      QmatNMR.dph2 = 0;
      
    
      %reset the current row and column numbers
      QmatNMR.rijnr = 1;
      QmatNMR.kolomnr = 1;
     
      getcurrentspectrum			%get spectrum to show on the screen
      Qspcrel
    
      repair;
    
      if (~QmatNMR.BusyWithMacro)
        Arrowhead;
        asaanpas;
      end  
    end
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
