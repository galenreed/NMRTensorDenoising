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
% matNMRBaselineCorrection1D
%
% syntax: MatrixOut = matNMRBaselineCorrection1D(MatrixIn, AxisIn, NoisePositions, Type, Order, Phase)
%
% Performs a baseline correction on the 1D spectrum MatrixIn. Areas must be defined in the spectrum
% that contain noise. These areas are fitted with the baseline of type <Type>. NoisePositions must
% be a vector that contains the start and end of each noise block in the unit of the axis AxisIn, 
% e.g. NoisePositions = [1 100 150 190 200 600]
% Currently, three types of baselines are implemented: (1) polynomial, (2) Bernstein polynomial and
% (3) cosine series. The Order determines how many terms the series contains.
% Phase is a parameter that allows a phase change for the cosine series. Typically this might be the
% zeroth-order phase correction for the 1D.
%
% Jacco van Beek
% 10-10-2007
%

function MatrixOut = matNMRBaselineCorrection1D(MatrixIn, AxisIn, NoisePositions, Type, Order, Phase)

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
      disp('matNMRBaselineCorrection1D ERROR: data  is not 1D. Aborting ...');
      return;
  
    else
      Size = length(MatrixIn);
    end

  else
    beep
    disp('matNMRBaselineCorrection1D ERROR: data  is not 1D. Aborting ...');
    return
  end


%
%First construct a list of indices that correspond to real data points in the spectrum without signal (noise)
%
  if isempty(NoisePositions) 		%no positions have been entered so we take everything as noise (to be fitted)
    NoisePositions = [1 Size];
  end

  %
  %Blocks of noise are entered in pairs so it's easy to determine how many blocks were specified
  %
  NumberOfNoiseBlocks = length(NoisePositions)/2 - 1;

  %
  %first we make sure that the positions are within the range of the axis vector
  %
  NoisePositions(find(NoisePositions < min(AxisIn))) = min(AxisIn);
  NoisePositions(find(NoisePositions > max(AxisIn))) = max(AxisIn);

  %
  %Then we interpolate to obtain indices corresponding to the blocks
  %
  NoiseIndices = round(interp1(AxisIn, 1:Size, NoisePositions));
  NoiseVector = [];
  for QTEMP=1:NumberOfNoiseBlocks+1
    QTEMP1 = sort([NoiseIndices((QTEMP-1)*2+1) NoiseIndices(QTEMP*2)]);
    NoiseVector = [NoiseVector QTEMP1(1):QTEMP1(2)];
  end

  %
  %Finally, we make sure we do not take the same point more than once
  %
  NoiseVector = unique(NoiseVector);
  NoiseVector = NoiseVector(:);		%make sure this is a column vector


%
%Then we apply the baseline correction
%
  %
  %now make the regression matrix
  %
  QTEMP = zeros(length(NoiseVector), Order+1);
  if (Type == 1)	%Polynomial function
    QTEMP(:, 1) = ones(length(NoiseVector),1);
    for QTEMP40=1:Order
      QTEMP(:, QTEMP40+1) = NoiseVector.^QTEMP40;
    end
  
  
  elseif (Type == 2)	%Bernstein polynomials
    for QTEMP40=0:Order
      QTEMP(:, QTEMP40+1) = (NoiseVector.^QTEMP40).*((1-NoiseVector).^(Order-QTEMP40));
    end
  
  
  elseif (Type == 3)	%Cosine series
    QTEMP(:, 1) = ones(length(NoiseVector),1);
    for QTEMP40=1:Order
      QTEMP(:, QTEMP40+1) = cos(QTEMP40*pi*(NoiseVector-1)/Size + Phase*pi/180);
    end
  end
  

  %
  %Do the actual linear regression
  %
  [QTEMP1, QTEMP2] = qr(QTEMP, 0); 	%see polyfit.m
  FittedCoefficients = QTEMP2\(QTEMP1.' * real(MatrixIn(NoiseVector)).');    % Same as p = V\y;


  %
  %Now calculate the resulting baseline
  %
  if (Type == 1)	%Polynomial function(A+Bx+Cx^2+Dx^3...)
    BaselineCorrection = FittedCoefficients(1)*ones(1, Size);
    for QTEMP40=1:Order
      BaselineCorrection =  BaselineCorrection + FittedCoefficients(QTEMP40+1)*((1:Size).^QTEMP40);
    end
  
  elseif (Type == 2)	%Bernstein polynomial
    BaselineCorrection = FittedCoefficients(1)*((1 - (1:Size)).^Order);
    for QTEMP40=1:Order
      BaselineCorrection = BaselineCorrection + FittedCoefficients(QTEMP40+1)*(((1:Size).^QTEMP40).*((1 - (1:Size)).^(Order-QTEMP40)));
    end
  
  elseif (Type == 3)	%Cosine series
    BaselineCorrection = FittedCoefficients(1)*ones(1, Size);
    for QTEMP40=1:Order
      BaselineCorrection =  BaselineCorrection + FittedCoefficients(QTEMP40+1)*cos(QTEMP40*pi*(0:(Size-1))/Size + Phase*pi/180);
    end
  end  

  
  %
  %Generate the corrected spectrum
  %
  MatrixOut = MatrixIn-BaselineCorrection;
