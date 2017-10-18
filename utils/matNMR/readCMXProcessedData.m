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
% readCMXProcessedData.m reads Spinsight processed spectra.
%
% syntax: readBrukerProcessedData(File Name, sizeTD2, sizeTD1, FTflagTD1);
%
% If FTflagTD1=1 then it is assumed that the data has been Fourier transformed in TD1
% which means it will need to be flipped around.
%
% Jacco van Beek
% ETH Zurich
% 23-05-'05

function ret = readCMXProcessedData(FileName, SizeTD2, SizeTD1, FTflagTD1)

fp = fopen(FileName, 'r', 'b');       %big endian
a = fread(fp, 'float32');
if (length(a) ~= SizeTD2*SizeTD1)
  error('readCMXProcessedData ERROR: incorrect size of spectrum specified!');
end

ret = fliplr(reshape(a(1:floor(SizeTD2/2)*SizeTD1)+sqrt(-1)*a(floor(SizeTD2/2)*SizeTD1+1:end), floor(SizeTD2/2), SizeTD1).');
if (FTflagTD1)
  ret = flipud(ret);
end

fclose(fp);
