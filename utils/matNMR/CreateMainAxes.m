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
%CreateMainAxes creates the axes for the main figure window. If an axis already
%exists then it will be deleted and a new one will be created.
%29-10-'03

try
  %
  %look for existing axes and legends in the main figure window
  %
  delete(findobj(QmatNMR.Fig, 'tag', 'legend'));    	%remove any legends present                                                                
  delete(findobj(QmatNMR.Fig, 'userdata', 1));		%userdata=1 because there are no subplots (yet) for the
  						%main figure window
  
  %
  %Create the new axes
  %
  QTEMP1 = axes('Position', [0.14 0.38 0.775 0.55], ...
       'box', 'off', ...
       'ytick', [], ...
       'Drawmode', 'fast', ...
       'userdata', 1, ...
       'tag', 'MainAxis', ...
       'Color', QmatNMR.ColorScheme.AxisBack, ...
       'xcolor', QmatNMR.ColorScheme.AxisFore, ...
       'ycolor', QmatNMR.ColorScheme.AxisFore, ...
       'zcolor', QmatNMR.ColorScheme.AxisFore, ...
       'nextplot', 'replacechildren');
  
  %
  %set the colours of the colour scheme also for the title
  %
  set(get(QTEMP1, 'title'), 'color', QmatNMR.ColorScheme.AxisFore);
  
  axis('off');
  drawnow;
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
