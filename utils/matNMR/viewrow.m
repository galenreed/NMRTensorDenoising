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
%viewrow.m changes the number of the row by one and plots the new row without
%changing the scaling.
%9-8-'96

try
  if QmatNMR.rijnr < 1
    QmatNMR.rijnr = 1;
  end
  
  if QmatNMR.rijnr > QmatNMR.SizeTD1
    QmatNMR.rijnr = QmatNMR.SizeTD1;
  end
  
  
  if ((QmatNMR.Dim ~= 1) | (QmatNMR.PlotType ~= 1)) 	%change the scaling if current dimension is TD1 or plot type is not default
    if (QmatNMR.Dim == 0)     %are we in a 1D mode now?
      SwitchTo2D
    end
    QmatNMR.Dim = 1;
    setfourmode;					%change the Fourier mode button
        
    QmatNMR.FIDstatus = QmatNMR.FIDstatus2D1;			%Is this dimension still an FID ?
    regeldisplaymode
  
    getcurrentspectrum				%get spectrum to show on the screen
    QmatNMR.Axis1D = QmatNMR.AxisTD2;			%set x-axis accordingly
    QmatNMR.Size1D = QmatNMR.SizeTD2;
    detaxisprops
    QmatNMR.lbstatus=0;					%reset linebroadening flag and button
    QmatNMR.texie = QmatNMR.texie1;
    QmatNMR.RulerXAxis = QmatNMR.RulerXAxis1;
    QmatNMRsettings.DefaultAxisReferencekHz = QmatNMRsettings.DefaultAxisReferencekHz1;
    QmatNMRsettings.DefaultAxisReferencePPM = QmatNMRsettings.DefaultAxisReferencePPM1;
    QmatNMRsettings.DefaultAxisCarrierIndex = QmatNMRsettings.DefaultAxisCarrierIndex1;
  
    set(QmatNMR.Four, 'value', QmatNMR.four2);		    %set FT-mode back to standard for TD2
  
    QmatNMR.SW1D = QmatNMR.SWTD2;			%set the sweep width and spectrometer frequencies for this dimension
    QmatNMR.SF1D = QmatNMR.SFTD2;
    
    QmatNMR.gamma1d = QmatNMR.gamma1;				%set the sign of the gyromagnetic ratio
    set(QmatNMR.gammabutton, 'value', QmatNMR.gamma1d);
  
    asaanpas;
  
    %reset phase buttons
    QmatNMR.fase1startIndex = floor(QmatNMR.Size1D/2)+1;
    QmatNMR.fase1start = interp1((1:QmatNMR.Size1D).', QmatNMR.Axis1D, QmatNMR.fase1startIndex);
    repair
  
  else
    getcurrentspectrum				%get spectrum to show on the screen
  
    if (~(length(QmatNMR.Axis1D) == length(QmatNMR.Spec1D)))
      QmatNMR.Axis1D = QmatNMR.AxisTD2;
      QmatNMR.Size1D = QmatNMR.SizeTD2;
      detaxisprops;
    end
  
    if (QmatNMR.bezigmetfase == 1)
      docurrentphase
    end  
  
    Qspcrel
    CheckAxis
    updatebuttons
    simpelplot
  end
  
  title(strrep(QmatNMR.Spec2DName, '_', '\_'), 'Color', QmatNMR.ColorScheme.AxisFore);

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
