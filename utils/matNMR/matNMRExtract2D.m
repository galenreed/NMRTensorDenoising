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
% matNMRExtract2D
%
% syntax: [MatrixOut, AxisOutTD2, AxisOutTD1] = matNMRExtract2D(MatrixIn, AxisInTD2, RangeTD2, AxisInTD1, RangeTD1)
%
%         OR
%
%         MatrixOut = matNMRExtract2D(MatrixIn, RangeTD2, RangeTD1)
%
% Allows extracting part of the data by entering a range in the units of the axis vectors
% <AxisInTD2> and <AxisInTD1>. <RangeTD2> and <RangeTD1> MUST be strings and the format is
% either '<Start>:<End>' or 'Start:Increment:End'.
% Alternatively, the axis vectors may be omitted, in which case the ranges must be specified in points.
%
% Jacco van Beek
% 25-07-2004
%

function [MatrixOut, AxisOutTD2, AxisOutTD1] = matNMRExtract2D(MatrixIn, AxisInTD2, RangeTD2, AxisInTD1, RangeTD1)

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
    disp('matNMRExtract2D ERROR: data is not 2D. Aborting ...');
    return
  end


%
%Check whether axes have been provided, if not assume an axis in points, and
%make sure it's of the correct length
%
  if (nargin == 3) 		%NO axes have been provided
    RangeTD1 = RangeTD2;
    RangeTD2 = AxisInTD2;

    AxisInTD2 = 1:SizeTD2;
    AxisInTD1 = 1:SizeTD1;

  else					%check whether axis is of correct length. We assume it is a 1D vector!
    if (length(AxisInTD2) ~= SizeTD2)
      beep
      disp('matNMRExtract2D ERROR: axis vector for TD2 of incorrect length. Aborting ...');
      return;
    end
    if (length(AxisInTD1) ~= SizeTD1)
      beep
      disp('matNMRExtract2D ERROR: axis vector for TD1 of incorrect length. Aborting ...');
      return;
    end
  end


%
%determine the axis starts and increments
%
  [AxisOffsetTD2, AxisIncrementTD2] = matNMRAxisProps(AxisInTD2);
  [AxisOffsetTD1, AxisIncrementTD1] = matNMRAxisProps(AxisInTD1);


%
%Check the ranges that were given as input
%
  QTEMP3 = findstr(RangeTD2, ':');	%range in TD2
  if (length(QTEMP3) == 1) 		%only 1 colon i.e. begin:end
    if (LinearAxis(AxisInTD2))	%for a linear axis the range can be given in the axis units
      eval(['QTEMP4 = sort([' RangeTD2(1:(QTEMP3(1)-1)) ' ' RangeTD2((QTEMP3(1)+1):(length(RangeTD2))) ']);']);
      ExtractionRangePointsTD2 = sort(round((QTEMP4-AxisOffsetTD2) ./ AxisIncrementTD2));

    else				%for a non-linear axis the minimum distance to two points on the axis grid are determined
      eval(['QTEMP7 = abs(AxisInTD2 - ' RangeTD2(1:(QTEMP3(1)-1)) ');']);
      eval(['QTEMP8 = abs(AxisInTD2 - ' RangeTD2((QTEMP3(1)+1):(length(RangeTD2))) ');']);
      ExtractionRangePointsTD2 = sort([find(QTEMP7 == min(QTEMP7)) find(QTEMP8 == min(QTEMP8))]);
    end

    ExtractionRangePointsTD2(3) = 1; 			%increment in points;
    ExtractionRangePointsTD2(4) = 0; 			%increment in unit of axis (0=no increment given);
  
  elseif (length(QTEMP3) == 2)
    if (LinearAxis(AxisInTD2))	%for a linear axis the range is determined by using the axis increment and offset
      eval(['QTEMP4 = sort([' RangeTD2(1:(QTEMP3(1)-1)) ' ' RangeTD2((QTEMP3(2)+1):(length(RangeTD2))) ']);']);
      ExtractionRangePointsTD2 = sort(round((QTEMP4-AxisOffsetTD2) ./ AxisIncrementTD2));
      eval(['ExtractionRangePointsTD2(4) = ' RangeTD2((QTEMP3(1)+1):(QTEMP3(2)-1)) ';']); 	%increment in unit of axis (0=no increment given);
      ExtractionRangePointsTD2(3) = round(abs(ExtractionRangePointsTD2(4) / AxisIncrementTD2));

      if (ExtractionRangePointsTD2(3) == 0)
        beep
        disp('matNMRExtract2D ERROR: increment for TD2 is 0! Aborting extraction ...');
        return
      end
    
    else				%for a non-linear axis an increment is not accepted
      beep
      disp('matNMRExtract2D ERROR: specifying an increment is not allowed for a non-linear axis vector. Aborting ...');
      return
    end

  else
    beep
    disp('matNMRExtract2D ERROR: incorrect format for extraction range in TD2. Aborting ...');
    return
  end


  QTEMP3 = findstr(RangeTD1, ':');	%range in TD1
  if (length(QTEMP3) == 1) 		%only 1 colon i.e. begin:end
    if (LinearAxis(AxisInTD1))	%for a linear axis the range can be given in the axis units
      QTEMP4 = sort([str2num(RangeTD1(1:(QTEMP3(1)-1))) str2num(RangeTD1((QTEMP3(1)+1):(length(RangeTD1))))]);
      ExtractionRangePointsTD1 = sort(round((QTEMP4-AxisOffsetTD1) ./ AxisIncrementTD1));
  
    else				%for a non-linear axis the minimum distance to two points on the axis grid are determined
      QTEMP7 = abs(AxisInTD1-str2num(RangeTD1(1:(QTEMP3(1)-1))));
      QTEMP8 = abs(AxisInTD1-str2num(RangeTD1((QTEMP3(1)+1):(length(RangeTD1)))));
      ExtractionRangePointsTD1 = sort([find(QTEMP7 == min(QTEMP7)) find(QTEMP8 == min(QTEMP8))]);
    end

    ExtractionRangePointsTD1(3) = 1; 			%increment in points;
    ExtractionRangePointsTD1(4) = 0; 			%increment in unit of axis (0=no increment given);
  
  elseif (length(QTEMP3) == 2)
    if (LinearAxis(AxisInTD1))	%for a linear axis the range is determined by using the axis increment and offset
      eval(['QTEMP4 = sort([' RangeTD1(1:(QTEMP3(1)-1)) ' ' RangeTD1((QTEMP3(2)+1):(length(RangeTD1))) ']);']);
      ExtractionRangePointsTD1 = sort(round((QTEMP4-AxisOffsetTD1) ./ AxisIncrementTD1));
      eval(['ExtractionRangePointsTD1(4) = ' RangeTD1((QTEMP3(1)+1):(QTEMP3(2)-1)) ';']); 	%increment in unit of axis (0=no increment given);
      ExtractionRangePointsTD1(3) = round(abs(ExtractionRangePointsTD1(4) / AxisIncrementTD2));

      if (ExtractionRangePointsTD1(3) == 0)
        beep
        disp('matNMRExtract2D ERROR: increment for TD12 is 0! Aborting extraction ...');
        return
      end
    
    else				%for a non-linear axis an increment is not accepted
      beep
      disp('matNMRExtract2D ERROR: specifying an increment is not allowed for a non-linear axis vector. Aborting ...');
      return
    end

  else
    beep
    disp('matNMRExtract2D ERROR: incorrect format for extraction range in TD1. Aborting ...');
    return
  end


%
%Check the range in points.
%
  %TD2
  if (ExtractionRangePointsTD2(1) < 1); ExtractionRangePointsTD2(1)=1; end
  if (ExtractionRangePointsTD2(2) > SizeTD2); ExtractionRangePointsTD2(2)=SizeTD2; end
  %TD1
  if (ExtractionRangePointsTD1(1) < 1); ExtractionRangePointsTD1(1)=1; end
  if (ExtractionRangePointsTD1(2) > SizeTD1); ExtractionRangePointsTD1(2)=SizeTD1; end

  if ~(AxisIncrementTD2 == round(AxisIncrementTD2)) | ~(AxisIncrementTD1 == round(AxisIncrementTD1))
    disp('matNMRExtract2D WARNING: extraction ranges may suffer from rounding errors.');
  end


%
%The corrected ranges
%
  RangeTD2 = [num2str(ExtractionRangePointsTD2(1)) ':' num2str(ExtractionRangePointsTD2(3)) ':' num2str(ExtractionRangePointsTD2(2))];
  RangeTD1 = [num2str(ExtractionRangePointsTD1(1)) ':' num2str(ExtractionRangePointsTD1(3)) ':' num2str(ExtractionRangePointsTD1(2))];


%
%create the new spectrum
%
  MatrixOut = eval(['MatrixIn(' RangeTD1 ',' RangeTD2 ')']);
  [SizeTD1, SizeTD2] = size(MatrixOut);


%
%create the new axes
%
  if ((AxisIncrementTD2 == 1) & (AxisOffsetTD2 == 0))	%if the previous axis was in points then keep it like that
    AxisOutTD2 = 1:SizeTD2;		%while starting at 1 again.
  else
    AxisOutTD2 = eval(['AxisInTD2(' RangeTD2 ')']);
  end
  if ((AxisIncrementTD1 == 1) & (AxisOffsetTD1 == 0))	%if the previous axis was in points then keep it like that
    AxisOutTD1 = 1:SizeTD1;		%while starting at 1 again.
  else
    AxisOutTD1 = eval(['AxisInTD1(' RangeTD1 ')']);
  end
