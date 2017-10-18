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
function [ed,ck, fitbut, TolBut, NrIterBut, redisbut, lijstbut, simplexbut, stopbut, printbut, refreshbut, defparsbut, logbut, txt1, txt2, txt5, txt6, txt7, txt8, txt9, txt10] = Diffpk_udata();

% break out components of handle_list into usable arrays
% 5-3-94 SMB (Bren@SLAC.stanford.edu)

%
% adapted for matNMR by Jacco van Beek
% 1-1-'97
%

QTEMP = get(findobj(0, 'Tag', 'Difffit'),'userdata');
handle_list = QTEMP.Handles;

for i=2:12,
	ed(i-1) = handle_list(i);
end
for i=13:22,
	ck(i-12)= handle_list(i);
end

fitbut 		= handle_list(1);
TolBut 		= handle_list(23);		%These buttons are used in Difffit and are therefore extracted
NrIterBut 	= handle_list(24);		%from the handle_list that is put in the figure window as
redisbut 	= handle_list(25);		%userdata
lijstbut 	= handle_list(26);
simplexbut 	= handle_list(27);
stopbut 	= handle_list(28);
printbut 	= handle_list(29);
refreshbut 	= handle_list(30);
defparsbut 	= handle_list(31);
logbut 		= handle_list(32);
txt1 		= handle_list(33);
txt2 		= handle_list(34);
txt5 		= handle_list(35);
txt6 		= handle_list(36);
txt7 		= handle_list(37);
txt8 		= handle_list(38);
txt9 		= handle_list(39);
txt10		= handle_list(40);
txt11		= handle_list(41);
