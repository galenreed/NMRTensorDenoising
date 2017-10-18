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
% readBrukerProcessedData.m reads XWINNMR processed spectra.
%
% syntax: readBrukerProcessedData(File Name, sizeTD2, sizeTD1, Blocking Factor TD2, Blocking Factor TD1, ByteOrdering);
%
% For the Blocking Factor look in the procs and proc2s files in the directory
% of the spectrum. Needed are the XDIM parameters (procs is for TD2 and proc2s
% is for TD1).
%
% ByteOrdering is an optional parameter which specifies the byte ordering, as this may vary across
% architectures. By default it is 1, meaning "big endian". The other possibilities are
%     2 = little endian
%
% Jacco van Beek
% ETH Zurich
% 20-07-'00

function Return = readBrukerProcessedData(FileName, SizeTD2, SizeTD1, BlockingTD2, BlockingTD1, ByteOrdering);

if (nargin == 5)
  ByteOrdering = 1;
end

if (ByteOrdering == 1)
  ByteOrdering = 'b';
else
  ByteOrdering = 'l';
end

Return = zeros(SizeTD1,SizeTD2);

f1 = SizeTD1 / BlockingTD1;
f2 = SizeTD2 / BlockingTD2;

id = fopen(FileName, 'r', ByteOrdering);

k=1:BlockingTD2;
for o=1:f1
  for p=1:f2
    for i=1:BlockingTD1;
      [a,count] = fread(id, BlockingTD2, 'int32');
      Return(i + (o-1)*BlockingTD1 ,k + (p-1)*BlockingTD2) = a.';
    end
  end
end

fclose(id);

Return = fliplr(flipud(Return));
