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
% matNMRApplyExternalReference
%
% syntax: [DefaultAxisRefkHz, DefaultAxisRefPPM] = matNMRApplyExternalReference(ReferenceFrequency, ReferenceValue, ReferenceUnit, SpectralFrequency, Gamma)
%
% Calculates the frequency in ppm and kHz at the carrier frequency of a given spectrum, based on an external reference. 
% The external reference requires an absolute frequency and a reference value ReferenceValue in a given unit ReferenceUnit 
% (1=ppm, 2=kHz). The SpectralFrequency is the carrier is the current spectrum and Gamma is used to denote the sign of the
% gyromagnetic ratio (1=positive, 2=negative). NOTE that all spectral frequencies are in MHz!
%
%
% Jacco van Beek
% 09-10-2007
%

function [DefaultAxisRefkHz, DefaultAxisRefPPM] = matNMRApplyExternalReference(ReferenceFrequency, ReferenceValue, ReferenceUnit, SpectralFrequency, Gamma)

  switch (ReferenceUnit)      %only accept the reference value if the units are in PPM or kHz!
    case 1        %PPM
      DefaultAxisRefPPM = ReferenceValue + (SpectralFrequency - ReferenceFrequency)*1e6/ReferenceFrequency;
      if (Gamma == 1)  %y > 0
        DefaultAxisRefkHz = -(DefaultAxisRefPPM * SpectralFrequency)/1000;
      else
        DefaultAxisRefkHz =  (DefaultAxisRefPPM * SpectralFrequency)/1000;
      end

    case 2        %kHz
      if (Gamma == 1)  %y > 0
        DefaultAxisRefkHz = (ReferenceValue - (SpectralFrequency - ReferenceFrequency)*1000);
        DefaultAxisRefPPM = -(DefaultAxisRefkHz * 1000 / SpectralFrequency);
      else
        DefaultAxisRefkHz = ReferenceValue + (SpectralFrequency - ReferenceFrequency)*1000;
        DefaultAxisRefPPM = (DefaultAxisRefkHz * 1000 / SpectralFrequency);
      end
          
    otherwise     %unknown code for the reference value
      disp('matNMR ERROR: encountered unknown code for the unit of the external reference. Aborting ...');
      return
  end
