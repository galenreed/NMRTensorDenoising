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
% matNMRExtract1D
%
% syntax: [MatrixOut, AxisOut] = matNMRExtract1D(MatrixIn, AxisIn, Range)
%
%         OR
%
%         MatrixOut = matNMRExtract1D(MatrixIn, Range)
%
% Allows extracting part of the data by entering a range in the unit of the axis vector
% <AxisIn>. <Range> MUST be a string and the format is either '<Start>:<End>' or 'Start:Increment:End'.
% Alternatively, the axis vector may be omitted, in which case the range must be specified in points.
%
% Jacco van Beek
% 25-07-2004
%

function [MatrixOut, AxisOut] = matNMRExtract1D(MatrixIn, AxisIn, Range)

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
      disp('matNMRExtract1D ERROR: data  is not 1D. Aborting ...');
      return;

    else
      Size = length(MatrixIn);
    end

  else
    beep
    disp('matNMRExtract1D ERROR: data  is not 1D. Aborting ...');
    return
  end


%
%Check whether an axis has been provided, if not assume an axis in points, and
%make sure it's of the correct length
%
  if (nargin == 2) 		%NO axis has been provided
    Range = AxisIn;
    AxisIn = 1:Size;

  else					%check whether axis is of correct length. We assume it is a 1D vector!
    if (length(AxisIn) ~= Size)
      beep
      disp('matNMRExtract1D ERROR: axis vector of incorrect length. Aborting ...');
      return;
    end
  end


%
%determine the axis start and increment
%
  [AxisOffset, AxisIncrement] = matNMRAxisProps(AxisIn);


%
%Check the range that was given as input
%
  QTEMP3 = findstr(Range, ':');	%range in 1D spectrum
  if (length(QTEMP3) == 1) 		%only 1 colon i.e. begin:end
    if (LinearAxis(AxisIn))	%for a linear axis the range can be given in the axis units
      eval(['QTEMP4 = sort([' Range(1:(QTEMP3(1)-1)) ' ' Range((QTEMP3(1)+1):(length(Range))) ']);']);
      ExtractionRangePoints = sort(round((QTEMP4-AxisOffset) ./ AxisIncrement));

    else				%for a non-linear axis the minimum distance to two points on the axis grid are determined
      eval(['QTEMP7 = abs(AxisIn - ' Range(1:(QTEMP3(1)-1)) ');']);
      eval(['QTEMP8 = abs(AxisIn - ' Range((QTEMP3(1)+1):(length(Range))) ');']);
      ExtractionRangePoints = sort([find(QTEMP7 == min(QTEMP7)) find(QTEMP8 == min(QTEMP8))]);
    end

    ExtractionRangePoints(3) = 1; 			%increment in points;
    ExtractionRangePoints(4) = 0; 			%increment in unit of axis (0=no increment given);

  elseif (length(QTEMP3) == 2)
    if (LinearAxis(AxisIn))	%for a linear axis the range is determined by using the axis increment and offset
      eval(['QTEMP4 = sort([' Range(1:(QTEMP3(1)-1)) ' ' Range((QTEMP3(2)+1):(length(Range))) ']);']);

      ExtractionRangePoints = sort(round((QTEMP4-AxisOffset) ./ AxisIncrement));
      eval(['ExtractionRangePoints(4) = ' Range((QTEMP3(1)+1):(QTEMP3(2)-1)) ';']); 	%increment in unit of axis (0=no increment given);
      ExtractionRangePoints(3) = round(abs(ExtractionRangePoints(4) / AxisIncrement));

      if (ExtractionRangePoints(3) == 0)
        beep
        disp('matNMRExtract1D ERROR: increment for TD2 is 0! Aborting extraction ...');
        return
      end

    else				%for a non-linear axis an increment is not accepted
      beep
      disp('matNMRExtract1D ERROR: specifying an increment is not allowed for a non-linear axis vector. Aborting ...');
      return
    end

  else
    beep
    disp('matNMRExtract1D ERROR: incorrect format for extraction range. Aborting ...');
    return
  end


%
%Check the range in points.
%
  if (ExtractionRangePoints(1) < 1); ExtractionRangePoints(1)=1; end
  if (ExtractionRangePoints(2) > Size); ExtractionRangePoints(2)=Size; end
  if ~(AxisIncrement == round(AxisIncrement))
    disp('matNMR WARNING: extraction ranges may suffer from rounding errors.');
  end


%
%The corrected range
%
  Range = [num2str(ExtractionRangePoints(1)) ':' num2str(ExtractionRangePoints(3)) ':' num2str(ExtractionRangePoints(2))];


%
%create the new spectrum
%
  MatrixOut = eval(['MatrixIn(' Range ')']);
  Size = length(MatrixOut);


%
%create the new axis
%
  if ((AxisIncrement == 1) & (AxisOffset == 0))	%if the previous axis was in points then keep it like that
    AxisOut = 1:Size;		%while starting at 1 again.
  else
    AxisOut = eval(['AxisIn(' Range ')']);
  end
