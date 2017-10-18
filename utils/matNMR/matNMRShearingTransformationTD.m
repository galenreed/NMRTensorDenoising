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
% matNMRShearingTransformationTD
%
% syntax: MatrixOut = matNMRShearingTransformationTD(MatrixIn1, ShearingFactor, SpectralWidthTD2, SpectralWidthTD1, MatrixIn2)
%
% Performs a shearing transformation in the time domain by performing a TD1-dependent
% 1st order phase correction to TD2. This means this operation should only be used
% AFTER FT in TD2 and before FT in TD1! 
% The amount of shearing is determined by <ShearingFactor> and the ratio of the 
% spectral widths in both dimensions.
%
% NOTE: in case of a TPPI-modulated experiment, the spectral width in TD1 is defined as
% 1/dwell so this might seem as having to write a twice as large spectral width than
% shown in some other software packages.
%
% <MatrixIn2> is an optional parameter that contains the hypercomplex complement to MatrixIn1.
%
% Jacco van Beek
% 25-07-2004
%

function [MatrixOut1, MatrixOut2] = matNMRShearingTransformationTD(MatrixIn1, ShearingFactor, SpectralWidthTD2, SpectralWidthTD1, MatrixIn2)

%
%define an empty output variable by default
%
  MatrixOut1 = [];
  MatrixOut2 = [];


%
%Check whether data is truly 2D
%
  if ((ndims(MatrixIn1) == 2) & ~isa(MatrixIn1, 'struct'))
    [SizeTD1, SizeTD2] = size(MatrixIn1);

  else
    beep
    disp('matNMRShearingTransformationTD ERROR: data is not 2D. Aborting ...');
    return
  end


%
%Shear away ...
%
  MatrixOut1 = MatrixIn1;
  if (nargin == 5)            %hypercomplex dataset
    MatrixOut2 = MatrixIn2;
  end

  if (ShearingFactor)			%if zero, stop now
    QmatNMR.z = 0:SizeTD1-1;
    QmatNMR.zero = (floor(SizeTD2/2)+1);
    Qi = sqrt(-1);
    QTEMP = (Qi * 2 * pi * ShearingFactor * SpectralWidthTD2 / SpectralWidthTD1 / SizeTD2);

    if (nargin == 5)            %hypercomplex dataset
      %rearrange the hypercomplex dataset such that a phase correction across the hypercomplex plane can be executed
      MatrixIn1 = real(MatrixOut1) + Qi * real(MatrixOut2);
      MatrixIn2 = imag(MatrixOut1) + Qi * imag(MatrixOut2);

      for QTEMP40=1:SizeTD2
        QTEMP3 = exp(QTEMP * QmatNMR.z * (QTEMP40-QmatNMR.zero)).';

        MatrixIn1(:, QTEMP40) = MatrixIn1(:, QTEMP40) .* QTEMP3;
        MatrixIn2(:, QTEMP40) = MatrixIn2(:, QTEMP40) .* QTEMP3;
      end
      MatrixOut1 = real(MatrixIn1) + Qi*real(MatrixIn2);
      MatrixOut2 = imag(MatrixIn1) + Qi*imag(MatrixIn2);

    else						%real, complex, TPPI and Phase modulated spectra
      for QTEMP40=1:QmatNMR.SizeTD2
        QTEMP3 = exp(QTEMP * QmatNMR.z * (QTEMP40-QmatNMR.zero)).';

        MatrixOut1(:, QTEMP40) = MatrixOut1(:, QTEMP40) .* QTEMP3;
      end
    end
  end
