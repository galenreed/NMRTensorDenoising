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
% matNMRSetPhase2D
%
% syntax: MatrixOut = matNMRSetPhase2D(MatrixIn1, Dimension, Zeroth, First, ReferenceFirst, Axis, Second, MatrixIn2)
%
% Allows performing phase correction on the 2D input matrix <MatrixIn1>. <Dimension> specifies
% either TD2 (1) or TD1 (2). 
% <First>, <ReferenceFirst>, Axis are optional arguments for first-order phase correction.
% <ReferenceFirst> is the position of the reference (pivot point) in the units of the axis, given by Axis.
% <ReferenceFirst> is set to 0 if not present and the axis is assumed in points if not provided. 
%
% All phase corrections are expected in degrees.
%
% The second-order phase correction has a reference of 0 and can be useful for getting rid
% of filter-induced artefacts.
%
% <MatrixIn2> is an optional parameter that contains the hypercomplex complement to MatrixIn1.
%
% Jacco van Beek
% 25-07-2004
%

function [MatrixOut1, MatrixOut2] = matNMRSetPhase2D(MatrixIn1, Dimension, Zeroth, First, ReferenceFirst, Axis, Second, MatrixIn2)

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
    disp('matNMRSetPhase2D ERROR: data is not 2D. Aborting ...');
    return
  end


%
%Check input
%
  if (nargin < 3)
    beep
    disp('matNMRSetPhase2D ERROR: not enough input parameters. Aborting ...');
    return

  elseif (nargin == 3)
    First = 0;
    ReferenceFirst = 0;
    if (Dimension == 1)
      Axis = 1:SizeTD2;
    else
      Axis = 1:SizeTD1;
    end
    Second = 0;

  elseif (nargin == 4)
    ReferenceFirst = 0;
    if (Dimension == 1)
      Axis = 1:SizeTD2;
    else
      Axis = 1:SizeTD1;
    end
    Second = 0;

  elseif (nargin == 5)
    if (Dimension == 1)
      Axis = 1:SizeTD2;
    else
      Axis = 1:SizeTD1;
    end
    Second = 0;

  elseif (nargin == 6)
    Second = 0;
  end


%
%Finalize the phase correction
%
  Qi = sqrt(-1)*pi/180;

  if (Dimension == 1)	%TD2
    %
    %determine the position of the reference using the axis vector
    %
    if (abs(First) > 1e-6)
      ReferenceFirstIndex = interp1(Axis, (1:SizeTD2).', ReferenceFirst);
    else
      ReferenceFirstIndex = 0;
    end

    QmatNMR.z = -((1:SizeTD2)-ReferenceFirstIndex)/(SizeTD2);
    QmatNMR.z2 = -2*(((1:SizeTD2)-ceil(SizeTD2/2))/(SizeTD2)).^2;
    Apodizer = exp(Qi * (Zeroth + First*QmatNMR.z + Second*QmatNMR.z2)).';

    MatrixOut1 = MatrixIn1.'; 		%it's faster to transpose the spectrum twice and operate on columns
    					%than it is to operate on rows!
    if (nargin == 8)
      MatrixOut2 = MatrixIn2.';
    end

    %
    %phase correction
    %
    if (nargin == 8)
      for tel=1:SizeTD1
        MatrixOut1(:, tel) = MatrixOut1(:, tel) .* Apodizer;
        MatrixOut2(:, tel) = MatrixOut2(:, tel) .* Apodizer;
      end

    else
      for tel=1:SizeTD1
        MatrixOut1(:, tel) = MatrixOut1(:, tel) .* Apodizer;
      end
    end

    %
    %transpose back
    %
    MatrixOut1 = MatrixOut1.';
    if (nargin == 8)
      MatrixOut2 = MatrixOut2.';
    end

  else			%TD1
    %
    %determine the position of the reference using the axis vector
    %
    if (abs(First) > 1e-6)
      ReferenceFirstIndex = interp1(Axis, (1:SizeTD1).', ReferenceFirst);
    else
      ReferenceFirstIndex = 0;
    end

    QmatNMR.z = -((1:SizeTD1)-ReferenceFirstIndex)/(SizeTD1);
    QmatNMR.z2 = -2*(((1:SizeTD1)-ceil(SizeTD1/2))/(SizeTD1)).^2;
    Apodizer = exp(Qi * (Zeroth + First*QmatNMR.z + Second*QmatNMR.z2)).';

    if (nargin == 8) 		%hypercomplex dataset
      MatrixOut1 = MatrixIn1;
      MatrixOut2 = MatrixIn2;

      MatrixIn1 = real(MatrixOut1) + sqrt(-1) * real(MatrixOut2);
      MatrixIn2 = imag(MatrixOut1) + sqrt(-1) * imag(MatrixOut2);
      
      for tel=1:SizeTD2
        MatrixIn1(:, tel) = MatrixIn1(:, tel) .* Apodizer;
        MatrixIn2(:, tel) = MatrixIn2(:, tel) .* Apodizer;
      end

      MatrixOut1 = real(MatrixIn1) + sqrt(-1)*real(MatrixIn2);
      MatrixOut2 = imag(MatrixIn1) + sqrt(-1)*imag(MatrixIn2);

    else 			%dataset is not hypercomplex
      MatrixOut1 = MatrixIn1;
      for tel=1:SizeTD2
        MatrixOut1(:, tel) = MatrixIn1(:, tel) .* Apodizer;
      end
    end
  end
