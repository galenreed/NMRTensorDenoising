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
%colorbarmatNMR provides an interface between matNMR and the MATLAB colorbar routine.
%Since the colorbar routine has changed a lot in MATLAB 7 I've made this routine to
%call a MATLAB 6-style colorbar when working with MATLAB 7. This keeps everything backwards
%compatible (and allows me to think of a more permanent solution)
%
%Jacco van Beek
%02-03-2006

function handle = colorbarmatNMR(arg1)

  global QmatNMR

  if (QmatNMR.MatlabVersion >= 7.0)
    handle = colorbar('v6', arg1);

  else
    handle = colorbar(arg1);
  end

 %add SelectAxis to the buttondownfunction of the colorbar
 set(handle, 'buttondownfcn', 'SelectAxis');

 %set the colors of the axes properly
 set(handle, 'xcolor', QmatNMR.ColorScheme.AxisFore, ...
             'ycolor', QmatNMR.ColorScheme.AxisFore, ...
             'zcolor', QmatNMR.ColorScheme.AxisFore);
 set(get(handle, 'title'), 'color', QmatNMR.ColorScheme.AxisFore);
