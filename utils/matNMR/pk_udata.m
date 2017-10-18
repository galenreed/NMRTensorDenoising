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
function [ed,ck,rb, FitBut, CurBut, TolBut, NrIterBut, noibut, zombut, redisbut, lijstbut, MinSlice, ...
          MaxSlice, ViewSlice, parambut, morebut, refreshbut, printbut, stopbut, txt1, txt2, txt3, txt4, ...
	  txt5, txt6, txt7, txt8, txt9, ViewText, MaxText, MinText, ViewButs, MaxButs, MinButs]=pk_udata();

% break out components of handle_list into usable arrays
% 5-3-94 SMB (Bren@SLAC.stanford.edu)

%
% adapted for matNMR by Jacco van Beek
% 1-1-'97
%

QTEMP = get(findobj(0, 'Tag', 'Peakfit'),'userdata');
handle_list = QTEMP.Handles;

FitBut 		= handle_list(  1);
CurBut 		= handle_list(  2);
ed(1:146) 	= handle_list(  3:148);
ck(1:146) 	= handle_list(149:294);
rb(1:74) 	= handle_list(295:368);
TolBut 		= handle_list(370);
NrIterBut 	= handle_list(371);
noibut 		= handle_list(372);
zombut 		= handle_list(373);
redisbut 	= handle_list(374);
lijstbut 	= handle_list(375);
MinSlice 	= handle_list(376);
MaxSlice 	= handle_list(377);
ViewSlice 	= handle_list(378);
parambut 	= handle_list(379);
morebut 	= handle_list(380);
refreshbut 	= handle_list(381);
printbut 	= handle_list(382);
stopbut 	= handle_list(383);
txt1 		= handle_list(384);
txt2 		= handle_list(385);
txt3 		= handle_list(386);
txt4 		= handle_list(387);
txt5 		= handle_list(388);
txt6 		= handle_list(389);
txt7 		= handle_list(390);
txt8 		= handle_list(391);
txt9 		= handle_list(392);
ViewText 	= handle_list(393);
MaxText 	= handle_list(394);
MinText 	= handle_list(395);
ViewButs 	= handle_list(396:397);
MaxButs		= handle_list(398:399);
MinButs 	= handle_list(400:401);
