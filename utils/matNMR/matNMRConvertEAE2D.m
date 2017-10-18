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
% matNMRConvertEAE2D
%
% syntax: [MatrixOut1 MatrixOut2] = matNMRConvertEAE2D(MatrixIn, DataFormat)
%
% Converts echo / anti-echo experiments to hypercomplex data.
% the format that is used by matNMR. MatNMR uses the same format as Chemagnetics does and so the
% FID-matrix should be built up like this :
%
% |----------------> real part of the matrix
% |ER           AER
% |
% |
% |
% |
% ------------------ complex part of the matrix
% |EI           AEI
% |
% |
% |
% |
% |
% 
% So the ER part is the echo part in t1 and real part in t2. The AER is the anti-echo part in t1 and the real part
% in t2, etc.
%
%
% On Bruker and Varian machines the imaginary parts in t1 will probably be alternated with the real parts in t1
% so:  (ER EI)1
%      (AER AEI)1
%      (ER EI)2
%      (AER AEI)2
% etc.
%
%
%
% Jacco van Beek
% 16-08-2006
%

function [MatrixOut1 MatrixOut2] = matNMRConvertEAE2D(MatrixIn, DataFormat)


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
    disp('matNMRConvertEAE2D ERROR: data is not 2D. Aborting ...');
    return
  end


%
%Only operate on even-sized matrices in TD2
%
  if (SizeTD2 ~= 2*round(SizeTD2/2))
    beep
    disp('matNMRConvertEAE2D ERROR: dimension size of TD2 is not an even number. Aborting ...');
    return
  end


%
%Convert Bruker/Varian data to the correct States-type format first
%
  if (DataFormat)
    [MatrixIn SizeTD2 SizeTD1] = convertstates(MatrixIn);
  end


%
%Convert the Echo / Anti-Echo data to States data
%
  [MatrixOut1 MatrixOut2 SizeTD2 SizeTD1] = convertEAE(MatrixIn);
