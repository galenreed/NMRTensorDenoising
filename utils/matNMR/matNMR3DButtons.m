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
%matNMR3DButtons.m creates the figure window for the 3D panel for the main window
%07-07-'04

try
  if ~isempty(QmatNMR.fig3D) 	%does the window already exist?
    figure(QmatNMR.fig3D);		%then pull it forward
    
  else
    QTEMP1 = [600   0 500 175];
    QmatNMR.fig3D = figure('Pointer', 'Arrow', 'units', 'pixels', 'Position', QTEMP1, 'Numbertitle', 'off', 'Resize', 'off', ...
                           'Visible', 'off', 'Name', '3D panel for main window', 'tag', '3D panel for main window', ...
                           'menubar', 'none', ...
  		         'closerequestfcn', 'try; delete(QmatNMR.fig3D); end; QmatNMR.fig3D = [];', 'color', QmatNMR.ColorScheme.Figure1Back);
  
    %
    %To work around a Matlab bug (see BugFixes.txt, 11-05-'04) we redefine the position and units.
    %
    set(QmatNMR.fig3D, 'units', 'pixels', 'position', QTEMP1);
  
  
    %
    %create all UI controls
    %
    uicontrol('Parent', QmatNMR.fig3D, 'Style', 'Pushbutton', 'Position', [  5   5 120 40], 'callback', 'delete(QmatNMR.fig3D); QmatNMR.fig3D=0;', 'String', 'Close Window', 'backgroundcolor', QmatNMR.ColorScheme.Button3Back, 'foregroundcolor', QmatNMR.ColorScheme.Button3Fore);
    uicontrol('Parent', QmatNMR.fig3D, 'Style', 'Pushbutton', 'Position', [155   5 120 40], 'callback', 'askexecutemacro3d', 'String', 'Run Macro on 3D', 'backgroundcolor', QmatNMR.ColorScheme.Button5Back, 'foregroundcolor', QmatNMR.ColorScheme.Button5Fore);
  
    QTEMP8 = sprintf('| %s', QmatNMR.LastVariableNames3D(:).Spectrum);
    QmatNMR.textstring = ['Load 3D ' QTEMP8];
    QmatNMR.but3D1 = uicontrol('parent', QmatNMR.fig3D, 'Style', 'Popup',      'Position', [105 110 150  30], 'String', QmatNMR.textstring, 'Callback', 'regel3d', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  
    uicontrol('parent', QmatNMR.fig3D, 'Style', 'Pushbutton', 'Position', [105 140 150  30], 'String', 'Reload Last 3D', 'callback', 'reload3d', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  
    QmatNMR.but3D2 = uicontrol('parent', QmatNMR.fig3D, 'Style', 'Pushbutton', 'Position', [  5  80 100  30], 'String', 'Input 3D from :', 'backgroundcolor', QmatNMR.ColorScheme.Button7Back, 'foregroundcolor', QmatNMR.ColorScheme.Button7Fore);
    QmatNMR.but3D3 = uicontrol('parent', QmatNMR.fig3D, 'Style', 'Pushbutton', 'Position', [105  80 150  30], 'String', QmatNMR.Q3DInput, 'backgroundcolor', QmatNMR.ColorScheme.Button2Back, 'foregroundcolor', QmatNMR.ColorScheme.Button2Fore);
  
    QmatNMR.but3D4 = uicontrol('parent', QmatNMR.fig3D, 'Style', 'Pushbutton', 'Position', [  5  50 100  30], 'String', 'Output 3D to :', 'backgroundcolor', QmatNMR.ColorScheme.Button7Back, 'foregroundcolor', QmatNMR.ColorScheme.Button7Fore);
    QmatNMR.but3D5 = uicontrol('parent', QmatNMR.fig3D, 'Style', 'Edit',       'Position', [105  50 150  30], 'String', QmatNMR.Q3DOutput, 'callback', 'regeloutput3d', 'backgroundcolor', QmatNMR.ColorScheme.Button2Back, 'foregroundcolor', QmatNMR.ColorScheme.Button2Fore);
  
    QmatNMR.but3D6 = uicontrol('parent', QmatNMR.fig3D, 'Style', 'Pushbutton', 'Position', [291 110 100  30], 'String', 'Current 2D :', 'backgroundcolor', QmatNMR.ColorScheme.Button7Back, 'foregroundcolor', QmatNMR.ColorScheme.Button7Fore);
    QmatNMR.but3D7 = uicontrol('parent', QmatNMR.fig3D, 'Style', 'Edit',       'Position', [391 110 100  30], 'String', QmatNMR.Q3DIndex, 'callback', 'QmatNMR.Q3DNewIndex = str2num(get(QmatNMR.but3D7, ''string'')); view2d', 'backgroundcolor', QmatNMR.ColorScheme.Button2Back, 'foregroundcolor', QmatNMR.ColorScheme.Button2Fore);
  
    QmatNMR.but3D8 = uicontrol('parent', QmatNMR.fig3D, 'Style', 'Pushbutton', 'Position', [291  80 100  30], 'callback', 'QmatNMR.Q3DLastType = 0; QmatNMR.Q3DNewIndex = QmatNMR.Q3DIndex-1; view2d', 'String', 'Prev 2D IN', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
    QmatNMR.but3D9 = uicontrol('parent', QmatNMR.fig3D, 'Style', 'Pushbutton', 'Position', [392  80 100  30], 'callback', 'QmatNMR.Q3DLastType = 0; QmatNMR.Q3DNewIndex = QmatNMR.Q3DIndex+1; view2d', 'String', 'Next 2D IN', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  
    QmatNMR.but3D10= uicontrol('parent', QmatNMR.fig3D, 'Style', 'Pushbutton', 'Position', [291  50 100  30], 'callback', 'QmatNMR.Q3DLastType = 1; QmatNMR.Q3DNewIndex = QmatNMR.Q3DIndex-1; view2d', 'String', 'Prev 2D OUT', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
    QmatNMR.but3D11= uicontrol('parent', QmatNMR.fig3D, 'Style', 'Pushbutton', 'Position', [392  50 100  30], 'callback', 'QmatNMR.Q3DLastType = 1; QmatNMR.Q3DNewIndex = QmatNMR.Q3DIndex+1; view2d', 'String', 'Next 2D OUT', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  
    QmatNMR.but3D12= uicontrol('parent', QmatNMR.fig3D, 'Style', 'Pushbutton', 'Position', [392   5 100  30], 'callback', 'askuserdef3', 'String', 'define axis', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  
  
    %
    %make all UI controls normalized and also the figure window itself
    %
    QmatNMR.tmp1 = (get(QmatNMR.fig3D, 'children'));
    set(QmatNMR.tmp1, 'units', 'normalized');
  
    set(QmatNMR.fig3D, 'units', 'normalized', 'resize', 'on', 'position', [0.6063 0.0811 0.3906 0.1416]); 
  
  
    %
    %finalize the window before showing it
    %
    drawnow
    set(QmatNMR.fig3D, 'Visible', 'on');  
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
