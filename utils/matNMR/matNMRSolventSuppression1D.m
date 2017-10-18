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
% matNMRSolventSuppression1D
%
% syntax: MatrixOut = matNMRSolventSuppression1D(MatrixIn, WindowFunction, WindowWidth, JumpSize)
%
% Deconvolutes a low-frequency peak from the spectrum, typically the solvent which is
% on-resonance. It follows the description given in 
%            Marion, Ikura and Bax in Journal of Magnetic Resonance, 84, 425-430 (1989)
% <WindowFunction> determines what window function is used. The coding is:
% 1 = Gaussian, 2 = Sine Bell and 3 = Rectangle. <WindowWidth> is the width of the window 
% function in points and <JumpSize> the jump size for the extrapolation.
%
%
% Jacco van Beek
% 25-07-2004
%

function MatrixOut = matNMRSolventSuppression1D(MatrixIn, WindowFunction, WindowWidth, JumpSize)

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
      disp('matNMRSolventSuppression1D ERROR: data  is not 1D. Aborting ...');
      return;
  
    else
      Size = length(MatrixIn);
    end

  else
    beep
    disp('matNMRSolventSuppression1D ERROR: data  is not 1D. Aborting ...');
    return
  end


%
%initialize some temporary variables
%
  QTEMP1 = zeros(1, Size);
  QTEMP4 = zeros(1, Size);
  QTEMP3 = -WindowWidth:WindowWidth;


%
%Define the shape of the window function and its normalization factor
%
  if (WindowFunction == 1) 		%use gaussian window function
    %
    %First we calculate the normalization factor
    %
    QmatNMR.NormalizationFactor = sum(exp(-4*QTEMP3.^2/WindowWidth^2));
    QTEMP5 = (exp(-4*QTEMP3.^2/WindowWidth^2));

  elseif (WindowFunction == 2) 	%use sine-bell function
    %
    %First we calculate the normalization factor
    %
    QmatNMR.NormalizationFactor = sum(cos(QTEMP3*pi/(2*WindowWidth+2)));
    QTEMP5 = (cos(QTEMP3*pi/(2*WindowWidth+2)));
    
  else  					%use rectangular function
    %
    %First we calculate the normalization factor
    %
    QmatNMR.NormalizationFactor = 2*WindowWidth+1;
    QTEMP5 = ones(1, length(QTEMP3));
  end


%
%Then we calculate all the points that need not be extrapolated
%
  for QTEMP2=1:(2*WindowWidth+1)
    QTEMP1((1+WindowWidth):(Size-WindowWidth)) = QTEMP1((1+WindowWidth):(Size-WindowWidth)) + QTEMP5(QTEMP2) .*(real(MatrixIn( ((1+WindowWidth):(Size-WindowWidth)) + QTEMP2 - WindowWidth - 1)));
    QTEMP4((1+WindowWidth):(Size-WindowWidth)) = QTEMP4((1+WindowWidth):(Size-WindowWidth)) + QTEMP5(QTEMP2) .*(imag(MatrixIn( ((1+WindowWidth):(Size-WindowWidth)) + QTEMP2 - WindowWidth - 1)));
  end


%
%And finally we calculate all the points that must be extrapolated
%
  QTEMP2 = (QTEMP1(WindowWidth+1)-QTEMP1(WindowWidth+JumpSize))/JumpSize;
  QTEMP1(1:WindowWidth) = QTEMP1(WindowWidth+1) + (WindowWidth:-1:1)*QTEMP2;
  QTEMP2 = (QTEMP4(WindowWidth+1)-QTEMP4(WindowWidth+JumpSize))/JumpSize;
  QTEMP4(1:WindowWidth) = QTEMP4(WindowWidth+1) + (WindowWidth:-1:1)*QTEMP2;
  
  QTEMP2 = (-QTEMP1(Size-WindowWidth)+QTEMP1(Size-WindowWidth-JumpSize+1))/JumpSize;
  QTEMP1( (Size-WindowWidth+1):Size ) = QTEMP1(Size-WindowWidth) + (1:WindowWidth)*QTEMP2;
  QTEMP2 = (-QTEMP4(Size-WindowWidth)+QTEMP4(Size-WindowWidth-JumpSize+1))/JumpSize;
  QTEMP4( (Size-WindowWidth+1):Size ) = QTEMP4(Size-WindowWidth) + (1:WindowWidth)*QTEMP2;


%
%substract the low-frequency approximation from the FID
%
  MatrixOut = MatrixIn - (QTEMP1 + sqrt(-1)*QTEMP4)/QmatNMR.NormalizationFactor;
