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
%AdjustPosNeg adjusts the PosNeg colourmaps based on the maximum and minimum intensity supplied
%to the routine.
%
%10-06-'05

function AdjustPosNeg(Minimum, Maximum)

global QmatNMR

if (nargin == 0)
  %
  %Now set the PosNeg colormaps to default
  %
  QmatNMR.PosNeg = QmatNMR.PosNegMap;
  QmatNMR.PosNeg2 = QmatNMR.PosNegMap2;
  QmatNMR.PosNeg3 = QmatNMR.PosNegMap3;

else
  %
  %check whether the maximum is larger than the minimum
  %
  if (Minimum > Maximum)
    QTEMP   = Minimum;
    Minimum = Maximum;
    Maximum = QTEMP;
  end
  
  %
  %Now adjust the QmatNMR.PosNegMap colormap such that the 121nd element (which is green) = 0 in the color axis
  %
  if (Minimum >= 0)
    QmatNMR.PosNeg  = [QmatNMR.PosNegMap(361:721, :)];
    QmatNMR.PosNeg2 = [QmatNMR.PosNegMap2(121:241, :)];
    QmatNMR.PosNeg3 = [QmatNMR.PosNegMap3(305:603, :)];
  
  elseif (Maximum <= 0)
    QmatNMR.PosNeg  = [QmatNMR.PosNegMap(1:361, :)];
    QmatNMR.PosNeg2 = [QmatNMR.PosNegMap2(1:121, :)];
    QmatNMR.PosNeg3 = [QmatNMR.PosNegMap3(1:305, :)];
  
  
  elseif (abs(Maximum) > abs(Minimum))            %more positive than negative intensity
    QmatNMR.factor = 119 / (round(120/abs(Maximum / Minimum)) - 1);
    if (QmatNMR.factor==inf)           %jump is very very big, still we make sure at least two elements are taken
      QmatNMR.factor = 119;
    end;        
    QmatNMR.factor2 = 303 / (round(304/abs(Maximum / Minimum)) - 1);
    if (QmatNMR.factor2==inf)          %jump is very very big, still we make sure at least two elements are taken
      QmatNMR.factor2 = 303;           %QmatNMR.PosNeg3 is longer than the other two and needs a different jump in this emergency case
    end
    QmatNMR.PosNeg  = [QmatNMR.PosNegMap(round(1:(QmatNMR.factor):360), :);  QmatNMR.PosNegMap(361:721, :)];
    QmatNMR.PosNeg2 = [QmatNMR.PosNegMap2(round(1:(QmatNMR.factor):120), :); QmatNMR.PosNegMap2(121:241, :)];
    QmatNMR.PosNeg3 = [QmatNMR.PosNegMap3(round(1:(QmatNMR.factor2):304), :); QmatNMR.PosNegMap3(305:603, :)];
  
  else                                          %more negative than positive intensity
    QmatNMR.factor = 119 / (round(120/abs(Minimum / Maximum)) - 1);
    if (QmatNMR.factor==inf)           %jump is very very big, still we make sure at least two elements are taken
      QmatNMR.factor = 119;
    end;        
    QmatNMR.factor2 = 303 / (round(304/abs(Minimum / Maximum)) - 1);
    if (QmatNMR.factor2==inf)          %jump is very very big, still we make sure at least two elements are taken
      QmatNMR.factor2 = 303;           %QmatNMR.PosNeg3 is longer than the other two and needs a different jump in this emergency case
    end;        
    QmatNMR.PosNeg  = [QmatNMR.PosNegMap(1:361, :);  QmatNMR.PosNegMap(round(362:(QmatNMR.factor):721), :)];
    QmatNMR.PosNeg2 = [QmatNMR.PosNegMap2(1:121, :); QmatNMR.PosNegMap2(round(122:(QmatNMR.factor):241), :)];
    QmatNMR.PosNeg3 = [QmatNMR.PosNegMap3(1:304, :); QmatNMR.PosNegMap3(round(305:(QmatNMR.factor2):603), :)];
  end
end
