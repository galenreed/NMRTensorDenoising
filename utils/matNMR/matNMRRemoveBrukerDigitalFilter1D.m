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
% matNMRRemoveBrukerDigitalFilter1D
%
% syntax: MatrixOut = matNMRRemoveBrukerDigitalFilter1D(MatrixIn, ACQUSFileName)
%
% Removes the influence of the Bruker digital filter, which typically shows up as a
% time-shift of the FID. NOTE that the wiggly part at the end of the FID after the
% correction is important and will cause a slight baseline distortion if removed
% (e.g. by apodization!). <ACQUSFileName> MUST be a string which points to the 
% acqus file on disk which contains the acquisition parameters to the FID.
%
% OR
%
% syntax: MatrixOut = matNMRRemoveBrukerDigitalFilter1D(MatrixIn, NrOfPointsToShift)
%
% Removes the influence of the Bruker digital filter, which typically shows up as a
% time-shift of the FID. NOTE that the wiggly part at the end of the FID after the
% correction is important and will cause a slight baseline distortion if removed
% (e.g. by apodization!). <NrOfPointsToShift> is the number of points that are used
% by the digital filter. NOTE that this may be non-integer!!
%
%
% Jacco van Beek
% 25-07-2004
%

function MatrixOut = matNMRRemoveBrukerDigitalFilter1D(MatrixIn, Extra)

%
%define an empty output variable by default
%
  MatrixOut = [];


%
%Check whether data is truly 1D
%
  if ((ndims(MatrixIn) == 2) & ~isa(MatrixIn, 'struct'))
    [SizeTD1, SizeTD2] = size(MatrixIn);
    if ((SizeTD1 ~= 1) & (SizeTD2 ~= 1))
      beep
      disp('matNMRRemoveBrukerDigitalFilter1D ERROR: data  is not 1D. Aborting ...');
      return;
  
    else
      Size = length(MatrixIn);
    end

  else
    beep
    disp('matNMRRemoveBrukerDigitalFilter1D ERROR: data  is not 1D. Aborting ...');
    return
  end


%
%Check whether we need to read in the parameters from disk or not
%
  if isa(Extra, 'char')		%read acqus file from disk and determine value automatically
    NrOfPointsToShift = DetermineBrukerDigitalFilter(Extra);
    if isempty(NrOfPointsToShift) 	%empty means that we couldn't determine the value from the dataset
  					%and an appropriate message was given in the console window.
      return

    end
  
  else
    NrOfPointsToShift = Extra;
  end


%
%perform the circular shift, using FFT and a first-order phase correction
%
  MatrixIn = fliplr(fftshift(fft(MatrixIn)));
  QmatNMR.z = ((1:Size) - floor(Size/2))/(Size);
  MatrixIn = MatrixIn .* exp(-sqrt(-1)*(NrOfPointsToShift*2*pi*QmatNMR.z));
  MatrixOut = ifft(fftshift(fliplr(MatrixIn)));
