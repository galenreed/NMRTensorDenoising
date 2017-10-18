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
% matNMRConvertBrukerqseq1D
%
% syntax: MatrixOut = matNMRConvertBrukerqseq1D(MatrixIn)
%
% Allows converting data that was taken in sequential mode (Redfield) on a Bruker machine.
% The data are then ordered in the following way :
%
% Re  1  3  5  7  9
% Im   2  4  6  8  10
%
% To process this as a normal TPPI one has to make a real vector out of this and invert every 3rd and 4th
% data point
% Then a normal real FT will do the job. Throw away half of the points and you'll be finished.
%
% Jacco van Beek
% 25-07-2004
%

function MatrixOut = matNMRConvertBrukerqseq1D(MatrixIn)

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
      disp('matNMRConvertBrukerqseq1D ERROR: data  is not 1D. Aborting ...');
      return;
  
    else
      Size = length(MatrixIn);
    end

  else
    beep
    disp('matNMRConvertBrukerqseq1D ERROR: data  is not 1D. Aborting ...');
    return
  end


%
%Convert the data to a real vector if it is complex
%
  if (imag(sum(MatrixIn))
    MatrixOut = zeros(1, 2*Size);
    MatrixOut(1:2:2*Size) = real(MatrixIn);
    MatrixOut(2:2:2*Size) = imag(MatrixIn);
    Size = 2*Size;

  else
    beep
    disp('matNMRConvertBrukerqseq1D ERROR: data is not complex. Aborting ...');
    return
  end


%
%Check whether the length of the fid is a multiple of 4. If not, make it so
%
  if (rem(Size, 4))		
    MatrixOut( (Size+1):(Size+rem(Size, 4)) ) = 0;
    Size = length(MatrixOut);
  end


%
%Combine and invert the four parts ...
%
  MatrixOut(1, 3:4:Size) = -MatrixOut(3:4:Size);
  MatrixOut(1, 4:4:Size) = -MatrixOut(4:4:Size);
