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
%convertBrukerqseq2d.m is used to convert 2D Bruker qseq (Redfield) experiments taken on a Bruker machine and 
%convert it to a format that can be used by matNMR. 
%The function is of the script is as follows :
%
% The data are ordered in the following way :
%
% Re  1  3  5  7  9
% Im   2  4  6  8  10
%
% Re  11  13  15  17  19
% Im   12  14  16  18  20
%
% Re  21  23  25  27  29
% Im   22  24  26  28  30
%
% To process this as a normal TPPI one has to make a real vector out of this and invert every 3rd and 4th
% data point
% Then a normal real FT will do the job. Throw away half of the points and you'll be finished.
%
% Jacco van Beek
% 24-03-'99
%

try
  if (QmatNMR.Dim == 0)
    disp('matNMR NOTICE: 2D processing functions are not allowed in 1D mode!')
  
  else  
    if QmatNMR.lbstatus | QmatNMR.bezigmetfase
      disp('matNMR WARNING:  not possible while apodizing or phasing!     convertBrukerqseq2d cancelled');
    
    else  
      watch
      
      %
      %create entry in the undo matrix
      %
      regelUNDO
    
      if imag(sum(sum(QmatNMR.Spec2D)))		%convert to a real matrix if it is complex.
        QTEMP1 = zeros(QmatNMR.SizeTD1, 2*QmatNMR.SizeTD2);
        QTEMP1(:, 1:2:2*QmatNMR.SizeTD2) = real(QmatNMR.Spec2D);
        QTEMP1(:, 2:2:2*QmatNMR.SizeTD2) = imag(QmatNMR.Spec2D);
        QmatNMR.Spec2D = QTEMP1;
        QmatNMR.SizeTD2 = 2*QmatNMR.SizeTD2;
        
      else
        disp('matNMR WARNING: 2D matrix is not complex and cannot be transformed.');
        disp('matNMR WARNING: conversion of Bruker qseq data cancelled.');
        return
      end  
      
      if (rem(QmatNMR.SizeTD2, 4))		%check whether the length of the fid in TD 2 is a multiple of 4. If not, make so
        QTEMP2 = (QmatNMR.Size1D+1):(QmatNMR.Size1D+rem(QmatNMR.Size1D, 4));
        QmatNMR.Spec2D(:, QTEMP2 ) = zeros(QmatNMR.SizeTD1, length(QTEMP2));
        [QmatNMR.SizeTD1 QmatNMR.SizeTD2] = size(QmatNMR.Spec2D);
      end
    
      				%combine and invert the four parts ...
      QmatNMR.Spec2D(:, 3:4:QmatNMR.SizeTD2) = -QTEMP1(:, 3:4:QmatNMR.SizeTD2);
      QmatNMR.Spec2D(:, 4:4:QmatNMR.SizeTD2) = -QTEMP1(:, 4:4:QmatNMR.SizeTD2);
      QTEMP1 = 0;
    
    				%finish up
      disp('Finished converting 2D Bruker qseq (Redfield) data to 2D TPPI/TPPI data ...');
      disp(['Size of the new 2D FID is :  ', num2str(QmatNMR.SizeTD1), ' x ', num2str(QmatNMR.SizeTD2), ' points (td1 x td2).']);
      QmatNMR.History = str2mat(QmatNMR.History, 'Converted 2D Bruker qseq FID to 2D TPPI/TPPI FID');
  
      %first add dimension-specific information, and then the current command
      if (QmatNMR.Dim == 1) 	%TD2
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
  
      else
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
      end
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 109);
      
      if QmatNMR.RecordingMacro
        %first add dimension-specific information, and then the current command
        if (QmatNMR.Dim == 1) 	%TD2
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
  
        else
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
        end
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 109);
      end
    
      getcurrentspectrum;
      
      %
      %ALWAYS revert to the default axis
      %
      QmatNMR.RulerXAxis = 0;		%Flag for default axis
  
      Qspcrel
      CheckAxis
      repair
    
      if (~QmatNMR.BusyWithMacro)
        asaanpas
      end  
      
      Arrowhead
    end
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
