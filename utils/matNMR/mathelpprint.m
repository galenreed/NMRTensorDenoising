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
%mathelpprint.m allows to print the text currently shown in the mathelp window
%01-09-1999

try
  %first get the string from the window
    QmatNMR.ListBox = findobj(gcf,'Tag','ListBox');
    QmatNMR.helpstr = get(QmatNMR.ListBox, 'string');
    
  %then remove all empty lines from the top  
    [QmatNMR.x QmatNMR.y] = size(QmatNMR.helpstr);
    QmatNMR.Cutter = 1;
    for QTEMP40=1:QmatNMR.x
      if strcmp(deblank(QmatNMR.helpstr(QTEMP40, :)), '')
        QmatNMR.Cutter = QmatNMR.Cutter + 1;
      else
        break
      end
    end
    QmatNMR.helpstr = QmatNMR.helpstr(3:QmatNMR.x, :);      
      
  
  %then create a new window
    QmatNMR.Fig2 = figure;
    set(QmatNMR.Fig2, 'paperorientation', 'landscape', 'name', 'Print matHelp message :', 'tag', 'mathelpprint');
    QmatNMR.Text2 = text(0, 0, QmatNMR.helpstr, 'Color', [1 1 1]);
    set(gca, 'units', 'normalized', 'position', [0.1 0.1 .8 .8]);
    set(QmatNMR.Text2, 'verticalalignment', 'top', 'fontsize', 12, 'position', [0 1 0], 'Tag', 'QmatNMR.Text2')
    axis off
    QmatNMR.ButMes = uicontrol('style', 'pushbutton', 'string', 'Font Size:', 'position', [0 0 100 30], 'backgroundcolor', [0 0 0], 'ForeGroundColor', [1 1 1]);
    QmatNMR.ButVal = uicontrol('style', 'Edit', 'string', '12', 'position', [100 0 40 30], 'backgroundcolor', [0 0 0], 'ForeGroundColor', [1 1 0], 'callback', 'QmatNMR.Stroing = get(gco, ''string''); set(findobj(allchild(gca), ''tag'', ''QmatNMR.Text2''), ''fontsize'', str2num(QmatNMR.Stroing))');
  
    QmatNMR.PrintBut1 = uicontrol('style', 'pushbutton', 'string', 'Print', 'position', [200, 0, 100, 30], 'callback', 'print -noui', 'backgroundcolor', [0 0 0.4], 'ForeGroundColor', [1 1 0]);
    QmatNMR.PrintBut2 = uicontrol('style', 'pushbutton', 'string', 'Printing Menu', 'position', [300, 0, 100, 30], 'callback', 'figure(gcf); matprint', 'backgroundcolor', [0 0 0.4], 'ForeGroundColor', [1 1 0]);
    
    QmatNMR.CloseBut = uicontrol('style', 'pushbutton', 'string', 'Close', 'position', [460, 0, 100, 30], 'callback', 'close', 'backgroundcolor', [0.4 0 0], 'ForeGroundColor', [1 1 0]);

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
