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
%QuiInput_3.m handles the callback for QuiInput.m when the user has struck a key inside the
%uiInput figure window (such that all global variables are still available)
%8-12-'97

try
  global QmatNMR
  
  QTEMP = get(gcf,'CurrentCharacter');
  
  if (QTEMP == 13)
    QmatNMR.buttonList = 1;	%Pushing <ENTER> equals pushing the OK-button
    QuiInput_2;
  
  elseif (QTEMP == 27)	%Pushing <ESC> equals pushing the CANCEL-button
  			%Get the number of push buttons in the input window
  			%The last one is always the cancel button so ....
    QmatNMR.buttonList = length(findobj(allchild(gcf), 'style', 'pushbutton')); 
    QuiInput_2;
  
  else
    return
  end

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
