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
%GetDefaultAxis creates a default axis based on the current settings defined in
%the general options menu
%
%13-10-2003

try
  QmatNMR.RulerXAxis = 0;		%Flag for default axis
  
  if (QmatNMR.FIDstatus == 1)		%Frequency domain
    if (QmatNMR.Dim == 0)		%1D spectrum
      QTEMP7 = QmatNMRsettings.DefaultRulerXAxis1FREQ;	%TD2
      QTEMP8 = QmatNMR.gamma1d;
      QTEMP10= QmatNMRsettings.DefaultAxisReferencekHz;
      QTEMP11= QmatNMRsettings.DefaultAxisReferencePPM;
      QTEMP12= QmatNMRsettings.DefaultAxisCarrierIndex;
      
    elseif (QmatNMR.Dim == 1)	%TD2
      QTEMP7 = QmatNMRsettings.DefaultRulerXAxis1FREQ;	%TD2
      QTEMP8 = QmatNMR.gamma1;
      QTEMP10= QmatNMRsettings.DefaultAxisReferencekHz1;
      QTEMP11= QmatNMRsettings.DefaultAxisReferencePPM1;
      QTEMP12= QmatNMRsettings.DefaultAxisCarrierIndex1;
      
    elseif (QmatNMR.Dim == 2)	%TD1
      QTEMP7 = QmatNMRsettings.DefaultRulerXAxis2FREQ;	%TD1
      QTEMP8 = QmatNMR.gamma2;
      QTEMP10= QmatNMRsettings.DefaultAxisReferencekHz2;
      QTEMP11= QmatNMRsettings.DefaultAxisReferencePPM2;
      QTEMP12= QmatNMRsettings.DefaultAxisCarrierIndex2;
    end

    switch QTEMP7
      case 1		%kHz
        QmatNMR.Axis1D = zeros(1, QmatNMR.Size1D);
        if (QTEMP8 == 1)	%y > 0
          QmatNMR.Axis1D =  QTEMP10 - ((1:QmatNMR.Size1D)-QTEMP12)*QmatNMR.SW1D/QmatNMR.Size1D;
      
        else			%y < 0
          QmatNMR.Axis1D =  QTEMP10 + ((1:QmatNMR.Size1D)-QTEMP12)*QmatNMR.SW1D/QmatNMR.Size1D;
        end
        
        QmatNMR.texie = 'kHz';
  
      case 2 		%Hz
        QmatNMR.Axis1D = zeros(1, QmatNMR.Size1D);
        if (QTEMP8 == 1)	%y > 0
          QmatNMR.Axis1D =  QTEMP10*1000 - ((1:QmatNMR.Size1D)-QTEMP12)*QmatNMR.SW1D*1000/QmatNMR.Size1D;
      
        else			%y < 0
          QmatNMR.Axis1D =  QTEMP10*1000 + ((1:QmatNMR.Size1D)-QTEMP12)*QmatNMR.SW1D*1000/QmatNMR.Size1D;
        end
        
        QmatNMR.texie = 'Hz';
  
      case 3 		%PPM
        QmatNMR.Axis1D = zeros(1, QmatNMR.Size1D);
        QmatNMR.Axis1D = QTEMP11 + ((1:QmatNMR.Size1D) - QTEMP12)*QmatNMR.SW1D*1000/(QmatNMR.Size1D*QmatNMR.SF1D);
        
        QmatNMR.texie = 'ppm';
  
      case 4 		%Points
        QmatNMR.Axis1D = zeros(1, QmatNMR.Size1D);
        QmatNMR.Axis1D = 1:QmatNMR.Size1D;
        
        QmatNMR.texie = 'Points';
  
      otherwise
        beep
        disp('matNMR ERROR: unknown code for default axis!')
        return
    end
    
  else		%Time domain
    if (QmatNMR.Dim == 0)		%1D spectrum
      QTEMP7 = QmatNMRsettings.DefaultRulerXAxis1TIME;	%TD2
      
    elseif (QmatNMR.Dim == 1)	%TD2
      QmatNMR.RulerXAxis1 = 0;		%Flag for default axis
      QTEMP7 = QmatNMRsettings.DefaultRulerXAxis1TIME;	%TD2
      
    elseif (QmatNMR.Dim == 2)	%TD1
      QmatNMR.RulerXAxis2 = 0;		%Flag for default axis
      QTEMP7 = QmatNMRsettings.DefaultRulerXAxis2TIME;	%TD1
    end
  
    switch QTEMP7
      case 1		%Time
        QmatNMR.Axis1D = zeros(1, QmatNMR.Size1D);
        QmatNMR.Axis1D = 1e3/QmatNMR.SW1D*(0:QmatNMR.Size1D-1);	%time axis is in us
        
        QmatNMR.texie = 'Time (\mus)';
  
      case 2 		%Points
        QmatNMR.Axis1D = zeros(1, QmatNMR.Size1D);
        QmatNMR.Axis1D = 1:QmatNMR.Size1D;
        QmatNMR.texie = 'Points';
  
      otherwise
        beep
        disp('matNMR ERROR: unknown code for default axis!')
        return
    end
  
  end
  
  
  %
  %change settings in the menubar and in the uicontrol in the main window
  %
  set(QmatNMR.h670, 'checked', 'on');
  if (QmatNMR.FIDstatus == 1) 	%Frequency domain
    switch (QTEMP7)
      case 1
        set(QmatNMR.defaultaxisbutton, 'value', 4);
  
      case 2
        set(QmatNMR.defaultaxisbutton, 'value', 5);
  
      case 3
        set(QmatNMR.defaultaxisbutton, 'value', 6);
  
      case 4
        set(QmatNMR.defaultaxisbutton, 'value', 7);
    end
  
  else
    switch (QTEMP7)
      case 1
        set(QmatNMR.defaultaxisbutton, 'value', 2);
  
      case 2
        set(QmatNMR.defaultaxisbutton, 'value', 3);
    end
  end
  
  
  %
  %update the reference position for the first-order phase correction based on the new axis
  %
  QmatNMR.fase1start = interp1((1:QmatNMR.Size1D).', QmatNMR.Axis1D, QmatNMR.fase1startIndex);
  
  
  %
  %change the axes of the 2D spectrum if we are working in 2D mode
  %
  if (QmatNMR.Dim == 1)
    QmatNMR.AxisTD2 = QmatNMR.Axis1D;
    QmatNMR.texie1 = QmatNMR.texie;
    QmatNMR.RulerXAxis1 = 0;
  
  elseif (QmatNMR.Dim == 2)
    QmatNMR.AxisTD1 = QmatNMR.Axis1D;
    QmatNMR.texie2 = QmatNMR.texie;
    QmatNMR.RulerXAxis2 = 0;
  end
  
  detaxisprops
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
