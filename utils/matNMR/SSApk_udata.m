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
function [FitBut, SimBut, ed, ck, TolBut, NrIterBut, noibut, noibute, zombut, redisbut, simplexbut, gradbut, gammabut, carrierbut, omegarbut, refreshbut, printbut, stopbut, verbbut] = SSApk_udata

% break out components of handle_list into usable arrays
% 5-3-94 SMB (Bren@SLAC.stanford.edu)

%
% adapted for matNMR by Jacco van Beek
% 1-1-'97
%

QTEMP = get(findobj(allchild(0), 'Tag', 'SSAFit'), 'userdata');
handle_list = QTEMP.Handles;

FitBut 		= handle_list( 1);
SimBut 		= handle_list( 2);
ed  		= handle_list( 3:9);
ck  		= handle_list(10:12);
TolBut 		= handle_list(13);
NrIterBut 	= handle_list(14);
noibut 		= handle_list(15);
noibute		= handle_list(16);
zombut 		= handle_list(17);
redisbut 	= handle_list(18);
simplexbut 	= handle_list(19);
gradbut 	= handle_list(20);
gammabut 	= handle_list(21);
carrierbut 	= handle_list(22);
omegarbut 	= handle_list(23);
refreshbut 	= handle_list(24);
printbut 	= handle_list(25);
stopbut 	= handle_list(26);
verbbut 	= handle_list(27);
