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
%matNMRLeftShift2D
%
% syntax: MatrixOut = matNMRLeftShift2d(MatrixIn, NrPointsToShiftTD2, NrPointsToShiftTD1)
%
% allows shifting the data in <MatrixIn> by <NrPointsToShiftTD2> and <NrPointsToShiftTD1> 
% points in TD2 and TD1 respectively. If the values are positive numbers then the data is
% shifted left, i.e. the first <NrPointsToShiftTD2> points are taken away and
% the same number of points are added at the end of the data but of zero intensity. 
% If the values are negative numberd then the reverse is done.
%
% Jacco van Beek
% 25-07-2004
%

function MatrixOut = matNMRLeftShift2D(MatrixIn, NrPointsToShiftTD2, NrPointsToShiftTD1)

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
    disp('matNMRLeftShift2D ERROR: data is not 2D. Aborting ...');
    return
  end


%
%Check parameters
%
if (nargin ~= 3)
  beep
  disp('matNMRLeftShift2D ERROR: incorrect number of input parameters. Aborting ...');
  return
end


%
%Now shift the data. First for TD2 then for TD1
%Each is divided in sections for left and right shifts
%
  MatrixOut = zeros(SizeTD1, SizeTD2);
  %
  %TD2
  %
  if (NrPointsToShiftTD2 > 0)		%left shift
    
    MatrixOut(:, 1:(SizeTD2-NrPointsToShiftTD2)) = MatrixIn(:, (1+NrPointsToShiftTD2):SizeTD2);
    MatrixIn = MatrixOut;

  elseif (NrPointsToShiftTD2 < 0)	%right shift
    MatrixOut(:, (1-NrPointsToShiftTD2):SizeTD2) = MatrixIn(:, 1:(NrPointsToShiftTD2+SizeTD2));
    MatrixIn = MatrixOut;

  else 					%no shift = no action
  end


  %
  %TD1
  %
  if (NrPointsToShiftTD1 > 0)		%left shift
    
    MatrixOut(1:(SizeTD1-NrPointsToShiftTD1), :) = MatrixIn((1+NrPointsToShiftTD1):SizeTD1, :);

  elseif (NrPointsToShiftTD1 < 0)	%right shift
    MatrixOut((1-NrPointsToShiftTD1):SizeTD1, :) = MatrixIn(1:(NrPointsToShiftTD1+SizeTD1), :);

  else 					%no shift = no action
    MatrixOut = MatrixIn;
  end
