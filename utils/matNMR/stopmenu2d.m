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
%stopmenu2d.m removes all buttoffs associated with the 2D panel from the users view
%21-12-'96

try
  if QmatNMR.menu2d == 1
    QmatNMR.menu2d = 0;
    
    set(QmatNMR.fr5, 'visible', 'off');
    set(QmatNMR.h43, 'visible', 'off');
    set(QmatNMR.h50, 'visible', 'off');
    set(QmatNMR.h51, 'visible', 'off');
    set(QmatNMR.h52, 'visible', 'off');
    set(QmatNMR.h53, 'visible', 'off');
    set(QmatNMR.h54, 'visible', 'off');
    set(QmatNMR.h55, 'visible', 'off');
    set(QmatNMR.h56, 'visible', 'off');
    set(QmatNMR.h57, 'visible', 'off');
    set(QmatNMR.h59, 'visible', 'off');
    set(QmatNMR.h60, 'visible', 'off');
    set(QmatNMR.h61, 'visible', 'off');
    set(QmatNMR.h62, 'visible', 'off');
    set(QmatNMR.h63, 'visible', 'off');
    set(QmatNMR.h64, 'visible', 'off');
    set(QmatNMR.h71, 'visible', 'off');
    set(QmatNMR.h72, 'visible', 'off');
    set(QmatNMR.h73, 'visible', 'off');
    set(QmatNMR.h74, 'visible', 'off');
  end

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
