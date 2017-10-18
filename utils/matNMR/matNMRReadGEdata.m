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
% function FID = matNMRReadGEdata(FileName, ByteOrdering, Format, HeaderSize, DataSize)
%
% FileName is a string that specifies the file name of the dataset that needs importing into Matlab
%
% ByteOrdering is a string that must be any of the format specified under "help fopen"
%		e.g. 'l' for little endian and 'b' for big endian
%
% Format is a string that must be any of the format specified under "help fread"
%		e.g. 'int16', 'int32' or 'float'
%
% HeaderSize is a number specifying the number of bytes that will be skipped at the
% 		start of the datafile
%
% DataSize specifies the total number of points to be read from the file
%
%
% Jacco van Beek
% 4-12-2009
%

function FID = matNMRReadGEdata(FileName, ByteOrdering, Format, HeaderSize, DataSize)

  id=fopen(FileName, 'r', ByteOrdering);
  fseek(id, HeaderSize, 0);				%jump to the size of the TecMag structure
  [FID, count] = fread(id, DataSize, Format);
  fclose(id);

