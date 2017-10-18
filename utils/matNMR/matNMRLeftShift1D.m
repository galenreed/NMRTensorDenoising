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
%matNMRLeftShift1D
%
% syntax: MatrixOut = matNMRLeftShift1d(MatrixIn, NrPointsToShift)
%
% allows shifting the data in <MatrixIn> by <NrPointsToShift> points. If <NrPointsToShift> is a positive
% number then the data is shifted left, i.e. the first <NrPointsToShift> points are taken away and
% the same number of points are added at the end of the data but of zero intensity. If <NrPointsToShift>
% is a negative number then the reverse is done.
%
% Jacco van Beek
% 25-07-2004
%

function MatrixOut = matNMRLeftShift1D(MatrixIn, NrPointsToShift)

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
      disp('matNMRLeftShift1D ERROR: data  is not 1D. Aborting ...');
      return;
  
    else
      Size = length(MatrixIn);
    end

  else
    beep
    disp('matNMRLeftShift1D ERROR: data  is not 1D. Aborting ...');
    return
  end


%
%Now shift the data. This is divided in sections for left and right shifts
%
  if (NrPointsToShift > 0)		%left shift
    MatrixOut = zeros(SizeTD1, SizeTD2);
    MatrixOut(1:(Size-NrPointsToShift)) = MatrixIn((1+NrPointsToShift):Size);

  elseif (NrPointsToShift < 0)		%right shift
    MatrixOut = zeros(SizeTD1, SizeTD2);
    MatrixOut((1-NrPointsToShift):Size) = MatrixIn(1:(Size+NrPointsToShift));

  else 					%no shift = no action
    MatrixOut = MatrixIn;
  end
