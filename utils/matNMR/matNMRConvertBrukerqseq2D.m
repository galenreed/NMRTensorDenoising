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
% matNMRConvertBrukerqseq2D
%
% syntax: MatrixOut = matNMRConvertBrukerqseq2D(MatrixIn)
%
% Allows converting data that was taken in sequential mode (Redfield) on a Bruker machine.
% The data are then ordered in the following way :
%
% Re  1  3  5  7  9
% Im   2  4  6  8  10
%
% Re  11  13  15  17  19
% Im   12  14  16  18  20
%
% Re  21  23  25  27  29
% Im   22  24  26  28  30
%
% To process this as a normal TPPI one has to make a real vector out of this and invert every 
% 3rd and 4th data point. Then a normal real FT will do the job. Throw away half of the points 
% and you're finished.
%
% Jacco van Beek
% 25-07-2004
%

function MatrixOut = matNMRConvertBrukerqseq2D(MatrixIn)

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
    disp('matNMRConvertBrukerqseq2D ERROR: data is not 2D. Aborting ...');
    return
  end


%
%Convert the data to a real vector if it is complex
%
  if imag(sum(sum(MatrixIn)))	      %convert to a real matrix if it is complex.
    MatrixOut = zeros(SizeTD1, 2*SizeTD2);
    MatrixOut(:, 1:2:2*SizeTD2) = real(MatrixIn);
    MatrixOut(:, 2:2:2*SizeTD2) = imag(MatrixIn);
    SizeTD2 = 2*SizeTD2;
    
  else
    beep
    disp('matNMRConvertBrukerqseq2D ERROR: data is not complex. Aborting ...');
    return
  end  


%
%Check whether the length of the fid is a multiple of 4. If not, make it so
%
  if (rem(SizeTD2, 4))		
    MatrixOut(:,  (SizeTD2+1):(SizeTD2+rem(Size, 4)) ) = 0;
    SizeTD2 = size(MatrixOut, 2);
  end


%
%Combine and invert the four parts ...
%
  MatrixOut(:, 3:4:SizeTD2) = -MatrixOut(:, 3:4:SizeTD2);
  MatrixOut(:, 4:4:SizeTD2) = -MatrixOut(:, 4:4:SizeTD2);
