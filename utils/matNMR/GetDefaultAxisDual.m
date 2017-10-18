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
%GetDefaultAxisDual creates a default axis for the dual plot, based on the current settings 
%defined in the general options menu
%
%30-04-2004

function Qdualaxis = GetDefaultAxisDual(DimSize, Sweepwidth, SpectralFrequency, Gamma, FIDstatus, RefkHz, RefPPM, CarrierIndex)

global QmatNMR QmatNMRsettings

if (FIDstatus == 1)		%Frequency domain
  if (QmatNMR.Dim == 0)		%1D spectrum
    QTEMP7 = QmatNMRsettings.DefaultRulerXAxis1FREQ;	%TD2
    
  elseif (QmatNMR.Dim == 1)	%TD2
    QTEMP7 = QmatNMRsettings.DefaultRulerXAxis1FREQ;	%TD2
    
  elseif (QmatNMR.Dim == 2)	%TD1
    QTEMP7 = QmatNMRsettings.DefaultRulerXAxis2FREQ;	%TD1
  end

  switch QTEMP7
    case 1		%kHz
      Qdualaxis = zeros(1, DimSize);
      if (Gamma == 1)	%y > 0
        Qdualaxis =  RefkHz - ((1:DimSize)-CarrierIndex)*Sweepwidth/DimSize;
    
      else			%y < 0
        Qdualaxis =  RefkHz + ((1:DimSize)-CarrierIndex)*Sweepwidth/DimSize;
      end
      
      QmatNMR.texie = 'kHz';

    case 2 		%Hz
      Qdualaxis = zeros(1, DimSize);
      if (Gamma == 1)	%y > 0
        Qdualaxis =  RefkHz*1000 - ((1:DimSize)-CarrierIndex)*Sweepwidth/DimSize*1000;
    
      else			%y < 0
        Qdualaxis =  RefkHz*1000 + ((1:DimSize)-CarrierIndex)*Sweepwidth/DimSize*1000;
      end
      
      QmatNMR.texie = 'Hz';

    case 3 		%ppm
      Qdualaxis = zeros(1, DimSize);
      Qdualaxis = RefPPM + ((1:DimSize)-CarrierIndex)*Sweepwidth*1000/(DimSize*SpectralFrequency);
      
      QmatNMR.texie = 'ppm';

    case 4 		%Points
      Qdualaxis = zeros(1, DimSize);
      Qdualaxis = 1:DimSize;
      
      QmatNMR.texie = 'Points';

    otherwise
      disp('matNMR ERROR: unknown code for default axis!')
  end
  
else		%Time domain
  if (QmatNMR.Dim == 0)		%1D spectrum
    QTEMP7 = QmatNMRsettings.DefaultRulerXAxis1TIME;	%TD2
    
  elseif (QmatNMR.Dim == 1)	%TD2
    QTEMP7 = QmatNMRsettings.DefaultRulerXAxis1TIME;	%TD2
    
  elseif (QmatNMR.Dim == 2)	%TD1
    QTEMP7 = QmatNMRsettings.DefaultRulerXAxis2TIME;	%TD1
  end

  switch QTEMP7
    case 1		%Time
      Qdualaxis = zeros(1, DimSize);
      Qdualaxis = 1e3/Sweepwidth*(0:DimSize-1);	%time axis is in us
      
      QmatNMR.texie = 'Time (\mus)';

    case 2 		%Points
      Qdualaxis = zeros(1, DimSize);
      Qdualaxis = 1:DimSize;
      QmatNMR.texie = 'Points';

    otherwise
      disp('matNMR ERROR: unknown code for default axis!')
  end

end
