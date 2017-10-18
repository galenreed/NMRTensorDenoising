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
% getHumpvalues
%
% syntax: [Width, Status] = getHumpvalues(FreqVec, Lineshape, LevelPercent)
%
% Allows determining the widths for typical hump values, e.g. at 50% of the maximum of a lineshape.
%
% NOTE: this routine is not able to function for spectra with multiple lines, where the width of
% a single line is wanted.
%
% Jacco van Beek
%

function [Width, Status] = getHumpvalues(FreqVec, Lineshape, LevelPercent)

  Status = 1;
  Width = 0;

  FreqVec = real(FreqVec);
  Lineshape = real(Lineshape);
  Level = max(Lineshape) * LevelPercent/100;
  
  %
  %a quick way to determine the widths
  %
  Indices = find(Lineshape > Level);
  max_index = max(Indices);
  min_index = min(Indices);
  
  if (max_index < length(Lineshape))
    MaxFreq = interp1(Lineshape(max_index + [0 1]), FreqVec(max_index + [0 1]), Level);

  else
    %
    %The value could not be determined so we take the maximum of the FreqVec and set the status to 0
    %
    MaxFreq = max(FreqVec);
    Status = 0;
  end
  
  if (min_index > 1)
    MinFreq = interp1(Lineshape(min_index + [-1 0]), FreqVec(min_index + [-1 0]), Level);

  else
    MinFreq = min(FreqVec);
    Status = 0;
  end

  Width = abs(MaxFreq - MinFreq);
