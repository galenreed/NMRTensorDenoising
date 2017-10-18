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
%regelconvertBruker.m takes care of converting a sequential states experiment into a simultaneous one
%see convertstates.m for more information
%
% Jacco van Beek
% 23-07-'97

try
  if (QmatNMR.Dim == 0)
    disp('matNMR NOTICE: 2D processing functions are not allowed in 1D mode!')
  
  else  
    if QmatNMR.lbstatus | QmatNMR.bezigmetfase
      disp('matNMR WARNING:  not possible while apodizing or phasing!     regelconvertBruker cancelled');
    
    else  
      %
      %create entry in the undo matrix
      %
      regelUNDO
    
      [QmatNMR.Spec2D QmatNMR.SizeTD2 QmatNMR.SizeTD1] = convertstates(QmatNMR.Spec2D);	%convert it now
      QmatNMR.Spec2Dhc = QmatNMR.Spec2D(:, (QmatNMR.SizeTD2/2+1):(QmatNMR.SizeTD2));	%perform the rearranging of the data
      QmatNMR.Spec2D = QmatNMR.Spec2D(:, 1:(QmatNMR.SizeTD2/2));
    
      QmatNMR.SizeTD2 = QmatNMR.SizeTD2 / 2;
    
      getcurrentspectrum			%extract the current row, i.e. the first one in this case
    
      %
      %ALWAYS revert to the default axis
      %
      QmatNMR.RulerXAxis = 0;		%Flag for default axis
    
      if (~QmatNMR.BusyWithMacro)
        asaanpas				%display the spectrum
      end  
    
      QmatNMR.howFT = get(QmatNMR.Four, 'value');
      if ~((QmatNMR.howFT == 3) | (QmatNMR.howFT == 6))	%States or States-TPPI
        set(QmatNMR.Four, 'value', 3);		%Set FT mode to States in the figure window
        					%if the current mode was not already States or States-TPPI
        QmatNMR.four1 = 3;			%set the FT mode for both dimensions
        QmatNMR.four2 = 3;
      end  

      %
      %data is hypercomplex now
      %
      QmatNMR.HyperComplex = 1;
    
      %
      %ALWAYS revert to the default axis
      %
      QmatNMR.RulerXAxis = 0;		%Flag for default axis
  
      QmatNMR.AxisTD2 = zeros(1, QmatNMR.SizeTD2);
      QmatNMR.AxisTD2(1:QmatNMR.SizeTD2) = 1:QmatNMR.SizeTD2; 
      QmatNMR.AxisTD1 = zeros(1, QmatNMR.SizeTD1);
      QmatNMR.AxisTD1(1:QmatNMR.SizeTD1) = 1:QmatNMR.SizeTD1; 
      QmatNMR.Axis1D = QmatNMR.AxisTD2;
      QmatNMR.Size1D = QmatNMR.SizeTD2;
      detaxisprops
    
      if (~QmatNMR.BusyWithMacro)
        asaanpas
      end  
    
  
      QmatNMR.History = str2mat(QmatNMR.History, 'Converted 2D Bruker States FID');
      QmatNMR.History = str2mat(QmatNMR.History, 'Matrix has been split and is ready for States processing');
      %first add dimension-specific information, and then the current command
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
  
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 110);
      
      if QmatNMR.RecordingMacro
        %first add dimension-specific information, and then the current command
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
  
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 110);
      end
    
      disp('Finished converting current 2D matrix (Bruker format) into a matNMR States matrix ...');
    end
  end

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
