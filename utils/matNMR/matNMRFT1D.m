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
% matNMRFT1D
%
% syntax: MatrixOut = matNMRFT1D(MatrixIn, FTtype, MultiplyByHalf, InverseFT)
%
% Allows performing various types of Fourier transform on the 1D data. <FTtype> is a flag which 
% codes for :
% 1 = complex FT (also used for whole-echo acquisition)
% 2 = real FT
% 3 = TPPI FT
% 4 = Bruker qseq FT (Redfield)
% 5 = Sine FT (real FT + 90 degree phase shift and inversion of first half of the spectrum
%
% <MultiplyByHalf> is an optional flag which states whether the first point of the FID needs to 
% be multiplied by 0.5. This is required for all FID's which are apodized to zero in order to
% avoid needing to do a baseline correction. By default this is set to 1 if left away.
%
% <InverseFT> is an optional flag which allows performing an inverse FT.
%
% Jacco van Beek
% 25-07-2004
%

function MatrixOut = matNMRFT1D(MatrixIn, FTtype, MultiplyByHalf, InverseFT)

%
%define an empty output variable by default
%
  MatrixOut = [];


%
%process input parameters
%
if (nargin == 2)
  MultiplyByHalf = 1;
  InverseFT = 0;
end

if (nargin == 3)
  InverseFT = 0;
end


%
%Check whether data is truly 1D
%
  if ((ndims(MatrixIn) == 2) & ~isa(MatrixIn, 'struct'))
    [SizeTD1, SizeTD2] = size(MatrixIn);
    if ((SizeTD1 ~= 1) & (SizeTD2 ~= 1))
      beep
      disp('matNMRFT1D ERROR: data  is not 1D. Aborting ...');
      return;
  
    else
      Size = length(MatrixIn);
    end

  else
    beep
    disp('matNMRFT1D ERROR: data  is not 1D. Aborting ...');
    return
  end


  if (InverseFT == 0) 	%forward FT
  %
  %Multiply first point by 0.5 is requested
  %
    if (MultiplyByHalf == 1)
      MatrixIn(1) = MatrixIn(1) * 0.5;
    end
  
  
  %
  %Execute requested FT
  %
    switch (FTtype)
      case 1      %Complex FT
        MatrixOut = fftshift(fft(MatrixIn, Size));
    
      case 2      %Real FT
        MatrixOut = fftshift(fft(real(MatrixIn), Size));
  
      case 3      %TPPI FT
        MatrixOut = fft(real(MatrixIn), 2*Size);
        MatrixOut = MatrixOut(1:Size);
  
      case 4      %Bruker qseq FT
        MatrixOut = zeros(1, 2*Size);		%the complex data vector first needs to be put into a real vector and then every
        MatrixIn(2:2:Size) = -MatrixIn(2:2:Size);%third and fourth point must be negated before doing a TPPI-like transformation
   									%as the vector is still complex the third and fourth points are in fact all even complex points!
        MatrixOut(1:2:2*Size) = real(MatrixIn);
        MatrixOut(2:2:2*Size) = imag(MatrixIn);
        MatrixOut = fft(real(MatrixOut), 2*Size);
        MatrixOut = MatrixOut(1:Size);

      case 5      %Sine FT
        %
        %in case of a Sine FT we perform a real FT + 90 degree phase shift and invert half of the spectrum
        %
        MatrixOut = fftshift(fft(real(MatrixIn), Size));
        MatrixOut = -imag(MatrixOut) + sqrt(-1)*real(MatrixOut);
        MatrixOut(1:floor(Size/2)) = -MatrixOut(1:floor(Size/2));
  
      otherwise
        beep
        disp('matNMRFT1D ERROR: unknown code for FTtype! Aborting ...');
        return
    end

  else 			%inverse FT
    if ((FTtype == 1) | (FTtype == 2))
      MatrixOut = ifft(fftshift(MatrixIn), Size);
      if (MultiplyByHalf == 1)
        MatrixOut(1) = MatrixOut(1) / 0.5;
      end

    else
      disp('matNMRFT1D NOTICE: inverse FT not implemented for demanded FT mode. Aborting ...');
    end
  end
