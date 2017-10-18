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
% AspectFloat(Variable)
%
% converts 6 uchar bits from the Bruker Aspect format into a float. Variable can be any
% array of size (x, 6).
%
% Jacco van Beek
% 19-03-'03
%

function ret = AspectFloat(Variable)

%
%constants needed for the conversion to real floats
%
c1 =         128;
c2 =       32768;
c3 =     8388608;
c5 =   268435456;
c6 = 68719476736;

expo = bitshift(Variable(:, 4), 3) + bitshift(Variable(:, 5), -5);
QTEMP = find(expo>1023);
expo(QTEMP) = expo(QTEMP) - 2048;

power = 2.^(expo+1*sign(expo));

mantissa = Variable(:, 1)/c1 + Variable(:, 2)/c2 + Variable(:, 3)/c3 + bitand(Variable(:, 4), 63)/c5 + Variable(:, 6)/c6;
QTEMP = find(mantissa > 1);
mantissa(QTEMP) = mantissa(QTEMP) - 2;

ret = mantissa .* power;



%
% Aspect3BitTo4(Variable, ByteSwap)
%
% This function converts the (x, 3) sized variable to a 24-bit integer word
% for each row of the variable. Each row thus should contain 3 uchar bits
% from the Bruker Aspect file format.
%
% ByteSwap is a flag that corresponds to big endian if it is set to 0
% and to little endian if it set to 1
%
% Jacco van Beek
% 19-03-'03
%

function ret = Aspect3BitTo4(Variable, ByteSwap)

if (nargin == 1)
  ByteSwap = 0;
end

if (ByteSwap)		%little endian
  ret =  bitshift(Variable(:, 1), 8) + bitshift(Variable(:,2), 16) + bitshift(Variable(:,3), 24);
  QTEMP = find(ret >= 2^31);
  ret(QTEMP) = ret(QTEMP) - 2^32;

else
  ret =  bitshift(Variable(:, 1), 16) + bitshift(Variable(:,2),8) + Variable(:,3);
  QTEMP = find(ret >= 2^23);
  ret(QTEMP) = ret(QTEMP) - 2^24;
end


%
% DetermineByteSwap(Variable)
%
% This function determines the byte swap of the Aspect file by looking at the first
% three bytes of the binary file. By making them into a 32 bit integer and checking
% the value, the byte swap can be determined. The variable ret is then set to
% the appropriate flag:
% 
%    result          -->         ret
%
%   4687093                       0        = Normal unswapped mode (big endian)
%   -687033                       1        = byte-swapped mode (little endian)
%
% Jacco van Beek
% 19-03-'03
%

function ret = DetermineByteSwap(Variable)

result = Aspect3BitTo4(Variable);
if (result == 4687093)
  ret = 0;

elseif (result == -687033)
  ret = 1;
  
else
  error('matNMR ERROR: unsupported byte swap in the Bruker Aspect file. Contact the author of matNMR!')
end
