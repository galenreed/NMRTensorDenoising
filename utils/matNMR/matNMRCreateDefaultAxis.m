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
%
% matNMRCreateDefaultAxis
%
% syntax: AxisOut = matNMRCreateDefaultAxis(SizeTD2, SpectralWidth, SpectralFrequency, Gamma, Domain, RefkHz, RefPPM, CarrierIndex, UnitType)
%
% Calculates an axis for the time or frequency domain, based on the given spectral parameters, the size of the data and the type
% of unit that is required.
% SizeTD2 is in points, SpectralWidth is in kHz, SpectralFrequency is in MHz, Gamma is only important for the sign. Domain denotes whether
% the data is an FID (0) or a spectrum (1). RefkHz and RefPPM are reference values (typically from an external reference)which give the
% frequency at the reference poisition CarrierIndex. UnitType defines what units are used. For frequency domain this can be (1) kHz, (2) Hz, (3) ppm
% and (4) points. For the time domain this can be (1) Time or (2) points.
%
% Jacco van Beek
% 08-10-2007
%

function AxisOut = matNMRCreateDefaultAxis(SizeTD2, SpectralWidth, SpectralFrequency, Gamma, Domain, RefkHz, RefPPM, CarrierIndex, UnitType)

if (Domain == 1)		%Frequency domain
  switch UnitType
    case 1		%kHz
      AxisOut = zeros(1, SizeTD2);
      if (Gamma == 1)	%y > 0
        AxisOut =  RefkHz - ((1:SizeTD2)-CarrierIndex)*SpectralWidth/SizeTD2;
    
      else			%y < 0
        AxisOut =  RefkHz + ((1:SizeTD2)-CarrierIndex)*SpectralWidth/SizeTD2;
      end

    case 2 		%Hz
      AxisOut = zeros(1, SizeTD2);
      if (Gamma == 1)	%y > 0
        AxisOut =  RefkHz*1000 - ((1:SizeTD2)-CarrierIndex)*SpectralWidth/SizeTD2*1000;
    
      else			%y < 0
        AxisOut =  RefkHz*1000 + ((1:SizeTD2)-CarrierIndex)*SpectralWidth/SizeTD2*1000;
      end

    case 3 		%PPM
      AxisOut = zeros(1, SizeTD2);
      AxisOut = RefPPM + ((1:SizeTD2)-CarrierIndex)*SpectralWidth*1000/(SizeTD2*SpectralFrequency);

    case 4 		%Points
      AxisOut = zeros(1, SizeTD2);
      AxisOut = 1:SizeTD2;

    otherwise
      disp('matNMR ERROR: unknown code for default axis!')
  end
  
else		%Time domain
  switch UnitType
    case 1		%Time
      AxisOut = zeros(1, SizeTD2);
      AxisOut = 1e3/SpectralWidth*(0:SizeTD2-1);	%time axis is in us

    case 2 		%Points
      AxisOut = zeros(1, SizeTD2);
      AxisOut = 1:SizeTD2;

    otherwise
      disp('matNMR ERROR: unknown code for default axis!')
  end

end
