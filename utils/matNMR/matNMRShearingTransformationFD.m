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
% matNMRShearingTransformationFD
%
% syntax: MatrixOut = matNMRShearingTransformationFD(MatrixIn, Direction, ShearingFactor, SpectralWidthTD2, SpectralWidthTD1)
%
% Performs a shearing transformation in the frequency domain by performing a spline 
% interpolation. <Direction> determines whether the shear is vertical (=1) or horizontal 
% (=2). The amount of shearing is determined by <ShearingFactor> and the ratio of the 
% spectral widths in both dimensions.
%
% Jacco van Beek
% 25-07-2004
%

function MatrixOut = matNMRShearingTransformationFD(MatrixIn, Direction, ShearingFactor, SpectralWidthTD2, SpectralWidthTD1)

%
%define an empty output variable by default
%
  MatrixOut = [];


%
%Check whether data is truly 2D
%
  if ((ndims(MatrixIn) == 2) & ~isa(MatrixIn, 'struct'))
    [SizeTD1, SizeTD2] = size(MatrixIn);

  else
    beep
    disp('matNMRShearingTransformationFD ERROR: data is not 2D. Aborting ...');
    return
  end


%
%Check parameters
%
if ((Direction ~= 1) & (Direction ~= 2))
  beep
  disp('matNMRShearingTransformationFD ERROR: Direction must be 1 or 2. Aborting ...');
  return
end


%
%Shear away ...
%
  MatrixOut = MatrixIn;
  if (ShearingFactor)			%if zero, stop now
    if (Direction == 1)	%vertical shearing
					%Check which columns need to be right-shifted and which left
      QmatNMR.Middle = floor(SizeTD2/2)+1;
      QmatNMR.Shifts = ((1:SizeTD2) - QmatNMR.Middle)*ShearingFactor*SpectralWidthTD2*SizeTD1/(SizeTD2*SpectralWidthTD1);

      for QTEMP40=1:SizeTD2
    					%first determine how many spectra need to be added to the
					%spectrum to be able to shear the first point (maximum shear)
        QTEMP2 = ceil(max(abs(QmatNMR.Shifts(QTEMP40)))/SizeTD1);

      					%first create a vector which the interpolation routine can use ...
        QTEMP3 = [];			%spectrum vector
        QTEMP4 = [];			%axis vector
        for QTEMP41 = 1:(2*QTEMP2 + 1)
          QTEMP3 = [QTEMP3 real(MatrixIn(:, QTEMP40)).'];			%this vector contains the repeated column from the spectrum
	  QTEMP4 = [QTEMP4 ( (QTEMP41-QTEMP2-1)*SizeTD1 + (1:SizeTD1))];	%this vector contains the positions belonging to QTEMP3
	end

        MatrixOut(:, QTEMP40) = interp1(QTEMP4, QTEMP3, ((1:SizeTD1)+QmatNMR.Shifts(QTEMP40)), 'spline').';
      end
    
    else				%horizontal shearing
					%Check which columns need to be right-shifted and which left
      QmatNMR.Middle = SizeTD1/2;
      QmatNMR.Shifts = ((1:SizeTD1) - QmatNMR.Middle)*ShearingFactor*SpectralWidthTD1*SizeTD2/(SizeTD1*SpectralWidthTD2);

      for QTEMP40=1:SizeTD1
    					%first determine how many spectra need to be added to the
					%spectrum to be able to shear the first point (maximum shear)
        QTEMP2 = ceil(max(abs(QmatNMR.Shifts(QTEMP40)))/SizeTD2);

      					%first create a vector which the interpolation routine can use ...
        QTEMP3 = [];			%spectrum vector
        QTEMP4 = [];			%axis vector
        for QTEMP41 = 1:(2*QTEMP2 + 1)
          QTEMP3 = [QTEMP3 real(MatrixIn(QTEMP40, :))];			%this vector contains the repeated column from the spectrum
	  QTEMP4 = [QTEMP4 ( (QTEMP41-QTEMP2-1)*SizeTD2 + (1:SizeTD2))];	%this vector contains the positions belonging to QTEMP3
        end

        MatrixOut(QTEMP40, :) = interp1(QTEMP4, QTEMP3, ((1:SizeTD2)+QmatNMR.Shifts(QTEMP40)), 'spline');
      end
    end
  end
