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
%symmetrize2d.m symmetrizes the current 2D spectrum by summing the opposite
%elements.
%NOTE: the spectrum must be square !
%19-03-'98

try
  if (QmatNMR.Dim == 0)
    disp('matNMR NOTICE: 2D processing functions are not allowed in 1D mode!')
  
  else  
    if QmatNMR.lbstatus | QmatNMR.bezigmetfase
      disp('matNMR WARNING:  not possible while apodizing or phasing!     symmetrize2d cancelled');
    
    else  
      if (QmatNMR.SizeTD2 ~= QmatNMR.SizeTD1)
        disp('Symmetrization failed because the spectrum is not square !');
      
      else
        watch;
    
        %
        %create entry in the undo matrix
        %
        regelUNDO
    
        QTEMP1 = tril(QmatNMR.Spec2D);
        QTEMP2 = triu(QmatNMR.Spec2D);
        
        if (QmatNMR.SYMMtype == 1)		%symmetrize with average values
          QTEMP3 = ((QTEMP1 + QTEMP1.' + QTEMP2 + QTEMP2.') / 2) - diag(diag(QmatNMR.Spec2D));
          QmatNMR.Spec2D = QTEMP3;
    
          QmatNMR.History = str2mat(QmatNMR.History, 'Spectrum symmetrized (average values taken)');
          disp('Symmetrization (average values) completed ...');
          
        else  			%symmetrize with highest values
          QTEMP3 = find(QTEMP2 >  QTEMP1);
          QTEMP1(QTEMP3) = QTEMP2(QTEMP3);
      
          QmatNMR.Spec2D = ((QTEMP1 + QTEMP1.') - diag(diag(QTEMP1)));
    
          QmatNMR.History = str2mat(QmatNMR.History, 'Spectrum symmetrized (highest values taken)');
          disp('Symmetrization (highest values) completed ...');
        end
  
        if (QmatNMR.Dim == 1)	%TD2
          %first add dimension-specific information, and then the current command
          QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
          QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
  
        else
          %first add dimension-specific information, and then the current command
          QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
          QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
        end
        
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 115, QmatNMR.SYMMtype);
        
        if QmatNMR.RecordingMacro
          if (QmatNMR.Dim == 1)	%TD2
            %first add dimension-specific information, and then the current command
            QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
            QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
    
          else
            %first add dimension-specific information, and then the current command
            QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
            QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
          end
  
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 115, QmatNMR.SYMMtype);
        end
        
        clear QTEMP*
      
        getcurrentspectrum
    
        if (~QmatNMR.BusyWithMacro)
          asaanpas;
          Arrowhead
        end
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
