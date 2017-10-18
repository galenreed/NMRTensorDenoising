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
% matNMRSetPhase1D
%
% syntax: MatrixOut = matNMRSetPhase1D(MatrixIn, Zeroth, First, AxisIn, ReferenceFirst, Second)
%
% Allows performing phase correction on the input matrix <MatrixIn>. <First>, <ReferenceFirst> 
% and <Second> are optional arguments (<ReferenceFirst> is set to 0 if not present). All phase 
% corrections are expected in degrees.
% The second-order phase correction has a reference of 0 and can be useful for getting rid
% of filter-induced artefacts.
%
%
% syntax: MatrixOut = matNMRSetPhase1D(MatrixIn)
%
% Allows performing an automatic phase correction on the input matrix <MatrixIn>. This uses the
% ACME algorithm (Chen, L., Weng, Z., Goh, L. and Garland, M., JMR 158 (2002).
% 164-168). For difficult spectra it's not very useful but for high-resolution spectra it works quite reasonable.
% NOTE: this routine is decent for spectra without baseline distortions. Such distortions however will screw up
% the non-negativity penalty. Furthermore, the non-negativity penalty is typically huge because the spectrum is
% not normalized, whereas the derivative spectrum (used for the entropy) is. This means that non-negativity
% overwhelmes the entropy if there is any, and this also means that the algorithm will tend to overestimate the
% first-order phase correction in order to cause a baseline distortion that yields an all-positive signal. 
%
%
% Jacco van Beek
% 25-07-2004
%

function MatrixOut = matNMRSetPhase1D(MatrixIn, Zeroth, First, AxisIn, ReferenceFirst, Second)

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
      disp('matNMRSetPhase1D ERROR: data  is not 1D. Aborting ...');
      return;
  
    else
      Size = length(MatrixIn);
      if (Size == SizeTD2)
        FlipFlag = 0;
      else
        FlipFlag = 1;
      end
      MatrixIn = MatrixIn(:).';
    end

  else
    disp('matNMRSetPhase1D ERROR: data  is not 1D. Aborting ...');
    return
  end


%
%Check input
%
  if (nargin < 1)
    disp('matNMRSetPhase1D ERROR: not enough input parameters. Aborting ...');
    return

  elseif (nargin == 1)
    %
    %ACME phase correction
    %
    AxisIn = 1:Size;
    ReferenceFirstIndex = floor(Size/2) + 1;
    ReferenceFirst = floor(Size/2) + 1;

    QTEMP2 = optimset;
    %QTEMP2.Display = 'iter';
    tic
    [QTEMP1] = fminsearch('ACMEentropy_fun', [0 0], QTEMP2, MatrixIn, ReferenceFirstIndex);
    disp(['Automatic phasing took ' num2str(toc) ' seconds']);
    Zeroth = QTEMP1(1);
    First = QTEMP1(2);
    %make sure Zeroth is within the range [-180 180]
    while (abs(Zeroth) > 180)
      if ((Zeroth) < 0)
        Zeroth = Zeroth + 360;
      else
        Zeroth = Zeroth - 360;
      end
    end
    Second = 0;

  elseif (nargin == 2)
    First = 0;
    AxisIn = 1:Size;
    ReferenceFirst = 0;
    Second = 0;

  elseif (nargin == 3)
    AxisIn = 1:Size;
    ReferenceFirst = 0;
    Second = 0;

  elseif (nargin == 5)
    Second = 0;
  end


%
%determine the position of the reference using the axis vector
%
  ReferenceFirstIndex = interp1(AxisIn, (1:Size).', ReferenceFirst);
  if isnan(ReferenceFirstIndex)
    ReferenceFirstIndex = 1;
  end


%
%Finalize the phase correction
%
  Qi = sqrt(-1)*pi/180;
  QmatNMR.z = -((1:Size)-ReferenceFirstIndex)/(Size);
  QmatNMR.z2 = -2*(((1:Size)-ceil(Size/2))/(Size)).^2;
  Apodizer = exp(Qi * (Zeroth + First*QmatNMR.z + Second*QmatNMR.z2));
  if (size(MatrixIn, 1) == 1)
    MatrixOut = MatrixIn .* Apodizer;
  else
    MatrixOut = MatrixIn .* (Apodizer.');
  end

  if (FlipFlag)
    MatrixOut = MatrixOut(:);
  end
