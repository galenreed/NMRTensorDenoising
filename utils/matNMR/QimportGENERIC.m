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
% QimportGERENIC.m reads a generic binary files
% 07-05-2010

function [y, SizeTD2, SizeTD1] = QimportGENERIC(fname, SizeTD2, SizeTD1, ByteOrder, DataFormat, Header1, Header2, DataOrdering);

ByteOrderString = str2mat('l', 'b', 'd', 'g', 'c', 'a', 's');
DataFormatString = str2mat('float32', 'float64', 'single', 'double', 'int8', 'int16', 'int32', 'int64', 'uint8', 'uint16', 'uint32', 'uint64', 'uchar', 'schar');

%
%open the file for reading
%
id=fopen(fname, 'r', deblank(ByteOrderString(ByteOrder, :)));

%
%read the data (skipping all headers where needed)
%
a = zeros(SizeTD2*SizeTD1, 1);
fseek(id, Header1, -1);
for count=1:SizeTD1
  fseek(id, Header2, 0);
  a((count-1)*SizeTD2 + (1:SizeTD2)) = fread(id, SizeTD2, deblank(DataFormatString(DataFormat, :)));
end
fclose(id);

%
%Combine the data into complex information
%
switch (DataOrdering)
  case (1) 		%complex, RI RI RI
    y = zeros(SizeTD1, SizeTD2/2);
    for tel=1:SizeTD1
      y(tel, 1:(SizeTD2/2)) = (a((tel-1)*SizeTD2 + (1 : 2 : SizeTD2-1)) + sqrt(-1)*a((tel-1)*SizeTD2 + (2 : 2 : SizeTD2))).';
    end
  
  case (2)
    y = zeros(SizeTD1, SizeTD2/2);
    for tel=1:SizeTD1
      y(tel, 1:(SizeTD2/2)) = (a( ((tel-1)*SizeTD2/2 + 1) : ((tel)*SizeTD2/2)) + sqrt(-1)*a( ((tel-1)*SizeTD2/2 + SizeTD1*SizeTD2/2 + 1) : ((tel)*SizeTD2/2 + SizeTD1*SizeTD2/2)) ).';
    end; 
  
  case (3)		%only real data
    y = zeros(SizeTD1, SizeTD2);
    y = reshape(a, SizeTD2, SizeTD1).';
  
  otherwise
    beep
    disp('QimportGENERIC ERROR: ordering flag for complex information unknown. Aborting ...');
    return
end
