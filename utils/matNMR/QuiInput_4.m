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
%QuiInput_4.m handles the callback for additional check buttons in the input window, i.e.
%the ones next to normal button to denote whether these entries should be used or not.
%the normal button is enabled or disabled depending on the state of the check button
%13-10-'04

try
  global QmatNMR
  
  QTEMP1 = gco; 			%this is the handle to the check button
  QTEMP2 = get(QTEMP1, 'value');	%value shows whether button must be enabled or disabled
  if QTEMP2
    QTEMP2 = 'on';
  else
    QTEMP2 = 'off';
  end
  QTEMP3 = get(QTEMP1, 'tag');	%tag shows which button to enable or disable
  
  %
  %enable or disable the button in the input window
  %
  set(QmatNMR.uiInputEdits(str2num(QTEMP3(1))), 'enable', QTEMP2);

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
