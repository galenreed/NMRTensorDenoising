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
% matNMRSetSize1D
%
% syntax: MatrixOut = matNMRSetSize1D(MatrixIn, NewSize1D, EchoFlag)
%
% Allows changing of the size of the matrix <MatrixIn>. If <NewSize1D> is larger than the
% current size then zeros are appended at the end of the matrix. If the value is smaller then
% the necessary points are taken away from the end of the matrix.<NewSize1D> may be a string
% in order to be able to enter size in "k", e.g. "8k".
%
% EchoFlag may be selected whenever a whole-echo processing is required. matNMR then changes
% the size of the FID from the middle instead from the end of the FID!
%
% Jacco van Beek
% 25-07-2004
%

function MatrixOut = matNMRSetSize1D(MatrixIn, NewSize1D, EchoFlag)

%
%define an empty output variable by default
%
  MatrixOut = [];


%
%
%
  if (nargin == 2)
    EchoFlag = 0;
  end


%
%Check whether data is truly 1D
%
  if ((ndims(MatrixIn) == 2) & ~isa(MatrixIn, 'struct'))
    [SizeTD1, SizeTD2] = size(MatrixIn);
    if ((SizeTD1 ~= 1) & (SizeTD2 ~= 1))
      beep
      disp('matNMRSetSize1D ERROR: data  is not 1D. Aborting ...');
      return;
  
    else
      Size = length(MatrixIn);
    end

  else
    beep
    disp('matNMRSetSize1D ERROR: data  is not 1D. Aborting ...');
    return
  end


%
%If NewSize1D is a string then we interpret it
%
  if (isa(NewSize1D, 'char'))
    NewSize1D = deblank(NewSize1D);
    QTEMP9 = length(NewSize1D);
    if ((NewSize1D(QTEMP9) == 'k') | (NewSize1D(QTEMP9) == 'K'))
      NewSize1D = round(str2num(NewSize1D(1:(QTEMP9-1))) * 1024 );
    else
      NewSize1D = round(str2num(NewSize1D));
    end
  end


%
%Create new matrix
%
  if (EchoFlag == 0)
    %
    %default case: append or delete from end of FID
    %
    if (NewSize1D > Size)
      MatrixOut = zeros(1, NewSize1D);
      MatrixOut(1:Size) = MatrixIn;
  
    else
      MatrixOut = MatrixIn(1:NewSize1D);
    end

  else
    %
    %whole-echo case: append or delete from the middle of the FID
    %
    if (NewSize1D > Size)
      MatrixOut(1:ceil(Size/2)) = MatrixIn(1:ceil(Size/2));
      MatrixOut((NewSize1D+1-floor(Size/2)):NewSize1D) = MatrixIn((ceil(Size/2)+1):Size);
  
    else
      MatrixOut = zeros(1, NewSize1D);
      MatrixOut(1:ceil(NewSize1D/2)) = MatrixIn(1:ceil(NewSize1D/2));
      MatrixOut((ceil(NewSize1D/2)+1):NewSize1D) = MatrixIn((Size+1-floor(NewSize1D/2)):Size);
    end
  end
