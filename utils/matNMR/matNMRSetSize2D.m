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
% matNMRSetSize2D
%
% syntax: MatrixOut = matNMRSetSize2D(MatrixIn, NewSizeTD1, NewSizeTD2, CenterFlag)
%
% Allows changing of the size of the matrix <MatrixIn>. If either sizes are larger than the
% current size then zeros are appended at the end of the matrix. If the value is smaller then
% the necessary points are taken away from the end of the matrix.Both <NewSizeTD1> and
% <NewSizeTD2> may be a strings in order to be able to enter size in "k", e.g. "8k".
% <CenterFlag> is an optional parameter which dictates whether the additional points in
% TD2 are appended from the right of the matrix (0) or from the center (1). This is useful 
% for e.g. whole-echo FID's. By default this is set to 0! Note that this only works in TD2
% and not for TD1!
%
%
% Jacco van Beek
% 25-07-2004
%

function MatrixOut = matNMRSetSize2D(MatrixIn, NewSizeTD1, NewSizeTD2, CenterFlag)

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
    disp('matNMRSetSize2D ERROR: data is not 2D. Aborting ...');
    return
  end


%
%Check parameters
%
  if (nargin == 3)
    CenterFlag = 0;
  end


%
%If NewSizeTD1 and NewSizeTD2 are strings then we interpret them
%
  if (isa(NewSizeTD1, 'char'))
    NewSizeTD1 = deblank(NewSizeTD1);
    QTEMP9 = length(NewSizeTD1);
    if ((NewSizeTD1(QTEMP9) == 'k') | (NewSizeTD1(QTEMP9) == 'K'))
      NewSizeTD1 = round(str2num(NewSizeTD1(1:(QTEMP9-1))) * 1024 );
    else
      NewSizeTD1 = round(str2num(NewSizeTD1));
    end
  end
  if (isa(NewSizeTD2, 'char'))
    NewSizeTD2 = deblank(NewSizeTD2);
    QTEMP9 = length(NewSizeTD2);
    if ((NewSizeTD2(QTEMP9) == 'k') | (NewSizeTD2(QTEMP9) == 'K'))
      NewSizeTD2 = round(str2num(NewSizeTD2(1:(QTEMP9-1))) * 1024 );
    else
      NewSizeTD2 = round(str2num(NewSizeTD2));
    end
  end


%
%Create new matrix
%
  %
  %now we put the original matrices in the newly-proportioned matrix. If asked for
  %(CenterFlag=1) we will append from the center in TD2, otherwise (CenterFlag=0)
  %we append from the right-hand side
  %
  MatrixOut = zeros(NewSizeTD1, NewSizeTD2);
  if (CenterFlag == 0)		%all but whole-echo
    if (SizeTD2 >= NewSizeTD2) & (SizeTD1 >= NewSizeTD1)				%change the size of the spectrum
      MatrixOut(1:NewSizeTD1, 1:NewSizeTD2) = MatrixIn(1:NewSizeTD1, 1:NewSizeTD2);	%new size is smaller in both time domains !
      
    elseif (SizeTD2 >= NewSizeTD2)
      MatrixOut(1:SizeTD1, 1:NewSizeTD2) = MatrixIn(1:SizeTD1, 1:NewSizeTD2);		%new size of TD 2 is smaller than before, TD 1 NOT !
  
    elseif (SizeTD1 >= NewSizeTD1)
      MatrixOut(1:NewSizeTD1, 1:SizeTD2) = MatrixIn(1:NewSizeTD1, 1:SizeTD2);		%new size of TD 1 is smaller than before, TD 2 NOT !
      
    else
      MatrixOut(1:SizeTD1, 1:SizeTD2) = MatrixIn;					%new size is bigger than old one in both time domains!
    end

  else				%whole-echo in TD2
    if (SizeTD2 >= NewSizeTD2) & (SizeTD1 >= NewSizeTD1)				%change the size of the spectrum
      MatrixOut(1:NewSizeTD1, 1:ceil(NewSizeTD2/2)) = MatrixIn(1:NewSizeTD1, 1:ceil(NewSizeTD2/2));			%new size is smaller in both time domains !
      MatrixOut(1:NewSizeTD1, (ceil(NewSizeTD2/2)+1):NewSizeTD2) = MatrixIn(1:NewSizeTD1, (SizeTD2+1-floor(NewSizeTD2/2)):SizeTD2);	%new size is smaller in both time domains !

    elseif (SizeTD2 >= NewSizeTD2)
      MatrixOut(1:SizeTD1, 1:ceil(NewSizeTD2/2)) = MatrixIn(1:SizeTD1, 1:ceil(NewSizeTD2/2));			%new size of TD 2 is smaller than before, TD 1 NOT !
      MatrixOut(1:SizeTD1, (ceil(NewSizeTD2/2)+1):NewSizeTD2) = MatrixIn(1:SizeTD1, (SizeTD2+1-floor(NewSizeTD2/2)):SizeTD2);	%new size of TD 2 is smaller than before, TD 1 NOT !
  
    elseif (SizeTD1 >= NewSizeTD1)
      MatrixOut(1:NewSizeTD1, 1:ceil(SizeTD2/2)) = MatrixIn(1:NewSizeTD1, 1:ceil(SizeTD2/2));			%new size of TD 1 is smaller than before, TD 2 NOT !
      MatrixOut(1:NewSizeTD1, (NewSizeTD2+1-floor(SizeTD2/2)):NewSizeTD2) = MatrixIn(1:NewSizeTD1, (ceil(SizeTD2/2)+1):SizeTD2);	%new size of TD 1 is smaller than before, TD 2 NOT !
      
    else
      MatrixOut(1:SizeTD1, 1:ceil(SizeTD2/2)) = MatrixIn(:, 1:ceil(SizeTD2/2));			%new size is bigger than old one in both time domains!
      MatrixOut(1:SizeTD1, (NewSizeTD2+1-floor(SizeTD2/2)):NewSizeTD2) = MatrixIn(:, (ceil(SizeTD2/2)+1):SizeTD2);	%new size is bigger than old one in both time domains!
    end
  end
