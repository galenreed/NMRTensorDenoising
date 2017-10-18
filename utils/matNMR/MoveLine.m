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
% MoveLine.m allows to manually shift a line in the main window by using the mouse and dragging it.
%
% 20-09-'99
%
% changed on 09-09-2003:
%
% Previously this function moved the line regardless of which mouse button was pressed.
% Now it only moves the line for selection type "normal", i.e. the left mouse button.
% Otherwise it displays information about the line in the main window.
%

try
  if (get(QmatNMR.h41, 'value')==1)
  %
  %Zoom is on: the routine cannot function properly then and will do nothing!
  %
  
  elseif (~isempty(findobj(gca, 'Tag', 'GetPositionLine')))
  %
  %The "get position" routine is running and so we don't want to do anything now!
  %
  
  else
    QTEMP1 = gco;					%retrieve the handle of the line that was selected
    QTEMP2 = get(gca, 'currentpoint');		%retrieve the original y-value of the line
    QTEMP9 = get(gcf, 'SelectionType');
    if strcmp(QTEMP9, 'normal')
      [QTEMP3 QTEMP4 QTEMP5] = ginput(1);		%get the new coordinate values and the button type
    
  						%finish the move of the line
      set(QTEMP1, 'xdata', get(QTEMP1, 'xdata') + QTEMP3 - QTEMP2(1, 1), 'ydata', get(QTEMP1, 'ydata') + QTEMP4 - QTEMP2(1, 2));
      disp('Line position changed manually ...');
  
    else
    	%display information about the line in the main window
      fprintf(1, '\nSelected line is:        %s\n', get(QTEMP1, 'Tag'));
    end
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
