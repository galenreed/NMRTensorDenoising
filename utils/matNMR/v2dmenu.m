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
%v2dmenu.m makes all buttons associated with the 2D panel visible again
%21-12-'96

try
  if QmatNMR.menu2d == 0 
    QmatNMR.menu2d = 1;
  
    set(QmatNMR.fr5, 'visible', 'on');
    set(QmatNMR.h43, 'visible', 'on');
    set(QmatNMR.h50, 'visible', 'on');
    set(QmatNMR.h51, 'visible', 'on');
    set(QmatNMR.h52, 'visible', 'on');
    set(QmatNMR.h53, 'visible', 'on');
    set(QmatNMR.h54, 'visible', 'on');
    set(QmatNMR.h55, 'visible', 'on');
    set(QmatNMR.h56, 'visible', 'on');
    set(QmatNMR.h57, 'visible', 'on');
    set(QmatNMR.h59, 'visible', 'on');
    set(QmatNMR.h60, 'visible', 'on');
    set(QmatNMR.h61, 'visible', 'on');
    set(QmatNMR.h62, 'visible', 'on');
    set(QmatNMR.h63, 'visible', 'on');
    set(QmatNMR.h64, 'visible', 'on');
    set(QmatNMR.h71, 'visible', 'on');
    set(QmatNMR.h72, 'visible', 'on');
    set(QmatNMR.h73, 'visible', 'on');
    set(QmatNMR.h74, 'visible', 'on');
  end

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
