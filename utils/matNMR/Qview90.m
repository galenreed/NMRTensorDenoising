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
%view90.m returns the projection on TD1 of Matrix
%5-3-1997
%5-9-2000

function ret = view90(Matrix, Start, Finish, Increment);

if (nargin == 3)
  Increment = 1;
end

[i, j] = size(Matrix);
ret = zeros(1, i);

%define the increment if it hasn't been done yet
if (nargin==3)
  Increment = 1;
end

%define the projection range if it hasn't been done yet
if (nargin==2)
  Finish = j;
  Increment = 1;
end

if (nargin==1)
  Start=1;
  Finish = j;
  Increment = 1;
end


%now project along the first dimension
ret = sum(Matrix(:, Start:Increment:Finish), 2).';
