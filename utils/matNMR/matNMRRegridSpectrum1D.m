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
% matNMRRegridSpectrum1D
%
% syntax:  MatrixOut = matNMRRegridSpectrum1D(MatrixIn, AxisOld, AxisNew, Algorithm)
%
% interpolates the spectrum to a new grid. The algorithm used is the standard Matlab function interp1, which
% has multiple ways to interpolate. The values for Algorithm can be 1=spline, 2=cubic, 3=linear, 4=nearest.
% By default spline is used (best quality but slowest).
%
% NOTE: only the real part of the matrix is returned!
% 
% Jacco van Beek
% 14-11-2007
%

function MatrixOut = matNMRRegridSpectrum2D(MatrixIn, AxisOld, AxisNew, Algorithm)

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
      disp('matNMRRegridSpectrum2D ERROR: data  is not 1D. Aborting ...');
      return;
  
    else
      Size = length(MatrixIn);
    end

  else
    beep
    disp('matNMRRegridSpectrum2D ERROR: data  is not 1D. Aborting ...');
    return
  end


%
%Check parameters
%
  if (nargin == 3)
    Algorithm = 1;
  
  elseif ((nargin < 3) | (nargin > 4))
    beep
    disp('matNMRRegridSpectrum2D ERROR: incorrect number of parameters. Aborting ...');
    return
  end
  if ((Algorithm < 1) | (Algorithm > 4))
    beep
    disp('matNMRRegridSpectrum2D ERROR: Algorithm parameter must be between 1 and 4. Aborting ...');
    return
  end


%
%Regrid the spectrum
%
  AlgorithmString = str2mat('spline', 'cubic', 'linear', 'nearest');
  MatrixOut = interp1(AxisOld, real(MatrixIn), AxisNew, deblank(AlgorithmString(Algorithm, :)));
