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
%shiftFFT2d.m performs a FFT shift on the current dimension of a 2d matrix
%NOTE: as the fftshift command on a matrix is completely
%	different than for a vector this is done by using a for loop.
%20-03-'98

try
  if (QmatNMR.Dim == 0)
    disp('matNMR NOTICE: 2D processing functions are not allowed in 1D mode!')
  
  else  
    if QmatNMR.lbstatus | QmatNMR.bezigmetfase
      disp('matNMR WARNING:  not possible while apodizing or phasing!     regelconvertBruker cancelled');
    
    else  
      watch
        
      %
      %create entry in the undo matrix
      %
      regelUNDO
    
      if (QmatNMR.Dim == 1)		%TD2
        if (rem(QmatNMR.SizeTD2, 2)==1)	%issue warning message if the spectrum is of odd length
          disp('matNMR WARNING: size TD2 is of odd length. Multiple FFTshift''s will change peak positions!')
        end  
    
        for QTEMP40 = 1:QmatNMR.SizeTD1
          QmatNMR.Spec2D(QTEMP40, :) = fftshift(QmatNMR.Spec2D(QTEMP40, :));
          QmatNMR.Spec2Dhc(QTEMP40, :) = fftshift(QmatNMR.Spec2Dhc(QTEMP40, :));
        end 
        
        getcurrentspectrum
        Qspcrel
        CheckAxis
    
        QmatNMR.History = str2mat(QmatNMR.History, 'FFT shift on TD2');
  
        %first add dimension-specific information, and then the current command
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
  
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 105, QmatNMR.Dim);	%code for FFT shift 2D, dimension
  
        if QmatNMR.RecordingMacro
          %first add dimension-specific information, and then the current command
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
  
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 105, QmatNMR.Dim);	%code for FFT shift 2D, dimension
        end
        
        disp('Finished performing fftshift on TD2 ...');
    
        if (~QmatNMR.BusyWithMacro)
          simpelplot;
          resetXaxis;		%reset the x-limits
          Arrowhead; 
        end
        
      elseif (QmatNMR.Dim == 2)	%TD1
        if (rem(QmatNMR.SizeTD1, 2)==1)	%issue warning message if the spectrum is of odd length
          disp('matNMR WARNING: size TD1 is of odd length. Multiple FFTshift''s will change peak positions!')
        end  
    
        for QTEMP40 = 1:QmatNMR.SizeTD2
          QmatNMR.Spec2D(:, QTEMP40) = fftshift(QmatNMR.Spec2D(:, QTEMP40));
          QmatNMR.Spec2Dhc(:, QTEMP40) = fftshift(QmatNMR.Spec2Dhc(:, QTEMP40));
        end 
        
        getcurrentspectrum
        Qspcrel
        CheckAxis
        
        QmatNMR.History = str2mat(QmatNMR.History, 'FFT shift on TD1');
  
        %first add dimension-specific information, and then the current command
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
  
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 105, QmatNMR.Dim);	%code for FFT shift 2D, dimension
  
        if QmatNMR.RecordingMacro
          %first add dimension-specific information, and then the current command
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
  
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 105, QmatNMR.Dim);	%code for FFT shift 2D, dimension
        end
    
        disp('Finished performing fftshift on TD1 ...');
    
        if (~QmatNMR.BusyWithMacro)
          simpelplot;
          resetXaxis;		%reset the x-limits
          Arrowhead; 
        end
      
      else
        disp('ERROR: trying to do a 2D function on a 1D spectrum. Request Cancelled');
        Arrowhead
      end
    end
  end

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
