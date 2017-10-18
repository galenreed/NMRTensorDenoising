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
%resetdefaultaxis resets the necessary variables for selecting a default axis (based
%on the setting in the general options menu), and updates the plot
%
%29-07-2005

try
  %
  %set the necessary flags for default axes, depending on dimension
  %
  QmatNMR.RulerXAxis = 0;
  if (QmatNMR.Dim == 0)
    QmatNMR.RulerXAxis1 = 0;
    QmatNMRsettings.DefaultAxisReferencekHz= 0; 		%1D mode
    QmatNMRsettings.DefaultAxisReferencePPM= 0;		%1D mode
    QmatNMRsettings.DefaultAxisCarrierIndex = floor(QmatNMR.Size1D/2)+1;
  
  elseif (QmatNMR.Dim == 1)			%TD2
    QmatNMR.RulerXAxis1 = 0;
    QmatNMRsettings.DefaultAxisReferencekHz  = 0; 	%1D mode
    QmatNMRsettings.DefaultAxisReferencekHz1 = 0; 	%TD2
  
    QmatNMRsettings.DefaultAxisReferencePPM  = 0;	%1D mode
    QmatNMRsettings.DefaultAxisReferencePPM1 = 0; 	%TD2
    
    QmatNMRsettings.DefaultAxisCarrierIndex  = floor(QmatNMR.Size1D/2)+1;
    QmatNMRsettings.DefaultAxisCarrierIndex1 = floor(QmatNMR.Size1D/2)+1;
  
  elseif (QmatNMR.Dim == 2)
    QmatNMR.RulerXAxis2 = 0;
    QmatNMRsettings.DefaultAxisReferencekHz  = 0; 	%1D mode
    QmatNMRsettings.DefaultAxisReferencekHz2 = 0; 	%TD1
  
    QmatNMRsettings.DefaultAxisReferencePPM  = 0;	%1D mode
    QmatNMRsettings.DefaultAxisReferencePPM2 = 0;	%TD1
    
    QmatNMRsettings.DefaultAxisCarrierIndex  = floor(QmatNMR.Size1D/2)+1;
    QmatNMRsettings.DefaultAxisCarrierIndex2 = floor(QmatNMR.Size1D/2)+1;
  end
  
  
  %
  %make an entry to the history macro with dimension-specific information only
  %
  if (QmatNMR.Dim == 0) 		%1D
    %first add dimension-specific information, and then the current command
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
  
    if QmatNMR.RecordingMacro
      %first add dimension-specific information, and then the current command
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
    end
    
    QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 19, QmatNMR.SF1D, 0, 1);	%code for external reference
  
  elseif (QmatNMR.Dim == 1) 	%TD2
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
  
    if QmatNMR.RecordingMacro
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
    end
    
    QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 125, QmatNMR.SFTD2, 0, 1);	%code for external reference
  
  else 				%TD1
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
  
    if QmatNMR.RecordingMacro
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
    end
    
    QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 125, QmatNMR.SFTD1, 0, 1);	%code for external reference
  end
  
  asaanpas

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
