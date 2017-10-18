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
%flipspec.m is the file that flips a 1 or 2D spectrum or FID from left to right.
%12-12-'96

try
  watch;
  
  if (QmatNMR.SwitchTo1D) 		%switch from 2D to 1D processing if necessary
    SwitchTo1D
  end
  
  %
  %create entry in the undo matrix
  %
  regelUNDO
  
  
  if (QmatNMR.Dim == 0)		%1D spectrum
    QmatNMR.Spec1DPlot  = conj(fliplr(QmatNMR.Spec1DPlot));
    QmatNMR.Spec1D = conj(fliplr(QmatNMR.Spec1D));
  
    QmatNMR.History = str2mat(QmatNMR.History, ['1D spectrum flipped left-right']);
  
    %first add dimension-specific information, and then the current command
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 7);		%code for flip l/r 1D
    
    if QmatNMR.RecordingMacro
      %first add dimension-specific information, and then the current command
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 7);		%code for flip l/r 1D
    end
    
    repair 
    disp('1D spectrum flipped.');
    
  elseif (QmatNMR.Dim == 1)	%2D spectrum, TD2
    if QmatNMR.lbstatus | QmatNMR.bezigmetfase
      disp('matNMR WARNING:  not possible while apodizing or phasing!     flipspec cancelled');
    
    else  
      QmatNMR.Spec2D = conj(fliplr(QmatNMR.Spec2D));
      QmatNMR.Spec2Dhc = conj(fliplr(QmatNMR.Spec2Dhc));
        
      getcurrentspectrum		%get spectrum to show on the screen
      
      disp('TD2 domain flipped for current 2D spectrum');
      QmatNMR.History = str2mat(QmatNMR.History, ['TD2 of 2D spectrum flipped left-right']);
    
      %first add dimension-specific information, and then the current command
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
    
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 106, QmatNMR.Dim);		%code for flip l/r 2D, dimension
      
      if QmatNMR.RecordingMacro
        %first add dimension-specific information, and then the current command
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
    
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 106, QmatNMR.Dim);		%code for flip l/r 2D, dimension
      end
    end
  
  else				%2D spectrum, TD1
    if QmatNMR.lbstatus | QmatNMR.bezigmetfase
      disp('matNMR WARNING:  not possible while apodizing or phasing!     flipspec cancelled');
    
    else  
      QmatNMR.Spec2D = flipud(QmatNMR.Spec2D);
      QmatNMR.Spec2Dhc = -flipud(QmatNMR.Spec2Dhc);
        
      getcurrentspectrum		%get spectrum to show on the screen
    
      disp('TD1 domain flipped for current 2D spectrum');    
      QmatNMR.History = str2mat(QmatNMR.History, ['TD1 of 2D spectrum flipped left-right']);
    
      %first add dimension-specific information, and then the current command
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
    
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 106, QmatNMR.Dim);		%code for flip l/r 2D, dimension
      
      if QmatNMR.RecordingMacro
        %first add dimension-specific information, and then the current command
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
    
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 106, QmatNMR.Dim);		%code for flip l/r 2D, dimension
      end
    end
  end
  
  %the following variables are reset.....
  
    %phase variables
    QmatNMR.fase0 = 0;
    QmatNMR.fase1 = 0;
    QmatNMR.fase2 = 0;
    QmatNMR.dph0 = 0;
    QmatNMR.dph1 = 0;
    QmatNMR.dph2 = 0;
    
    %axis variables
    QmatNMR.min = 0;
    QmatNMR.Size1D = 500000;
    QmatNMR.xmin = 0;
    QmatNMR.totaalX = 500000;
    QmatNMR.totaalY = 500000;
    QmatNMR.minY = 0;
    QmatNMR.maxY = 500000;
    QmatNMR.ymin = 0;
    
    %line broadening
    QmatNMR.lb = 0;
  
  
  repair;
  if (~QmatNMR.BusyWithMacro)
    asaanpas;
    Arrowhead;
  end

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
