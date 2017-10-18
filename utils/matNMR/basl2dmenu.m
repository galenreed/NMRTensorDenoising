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
%basl2dmenu.m creates a GUI interface for the 1D baseline correction menu in matNMR
%20-1-98

try
  if (QmatNMR.Dim == 0)
    disp('matNMR NOTICE:  not possible to open the 2D baseline correction during 1D processing!     basl2dmenu cancelled.');
  
  elseif (QmatNMR.lbstatus | QmatNMR.bezigmetfase)
    disp('matNMR NOTICE:  not possible while apodizing or phasing!     basl2dmenu cancelled.');
  
  elseif (QmatNMR.DisplayMode == 3)
    disp('matNMR NOTICE:  not possible in display mode "both"!     basl2dmenu cancelled.');
  
  else  
  
    %
    %To make sure that the 1D baseline routine isn't open as well, I'll close it.
    %That way there can be no interference between the two routines.
    %
    if ~isempty(QmatNMR.Basl1Dfig)
      delete(QmatNMR.Basl1Dfig);
      QmatNMR.Basl1Dfig = [];
    end  
  
    if QmatNMR.Basl2Dfig > 0
      figure(QmatNMR.Basl2Dfig);			%It already exists so just pull to front
    else
      regelUNDO
      
      QTEMP = CenterOfScreen;
      QmatNMR.Basl2Dfig = figure('Pointer', 'Arrow', 'units', 'pixels', 'Position', [(QTEMP(1)-250) 120 500 150], 'Name', '2D Baseline correction', 'Numbertitle', 'off', ...
                                 'menubar', 'none', ...
                                 'Resize', 'off', 'tag', 'baslcormenufig', 'closerequestfcn', 'QTEMP = 1; stopbasl2d', 'color', QmatNMR.ColorScheme.Figure1Back);
    %
    %To work around a Matlab bug (see BugFixes.txt, 11-05-'04) we redefine the position and units.
    %
    set(QmatNMR.Basl2Dfig, 'units', 'pixels', 'position', [(QTEMP(1)-250) 120 500 150]);
  
      QmatNMR.Q2dbas1 = uicontrol('Style', 'Pushbutton', 'Position', [ 10  10 110  30], 'String', 'Reject Fit', 'callback', 'QTEMP = 1; stopbasl2d', 'BackgroundColor', QmatNMR.ColorScheme.Button3Back, 'ForegroundColor', QmatNMR.ColorScheme.Button3Fore); 
      QmatNMR.Q2dbas2 = uicontrol('Style', 'Pushbutton', 'Position', [380  10 110  30], 'String', 'Fit', 'callback', 'doebasl2dcor', 'BackgroundColor', QmatNMR.ColorScheme.Button5Back, 'ForegroundColor', QmatNMR.ColorScheme.Button5Fore);
      QmatNMR.Q2dbas3 = uicontrol('Style', 'Popup',      'Position', [150  10 150  30], 'String', 'Polynomial | Bernstein | Cosine Series', 'value', QmatNMR.Basl2DFunction, 'BackgroundColor', QmatNMR.ColorScheme.Button1Back, 'ForegroundColor', QmatNMR.ColorScheme.Button1Fore);
  
      QmatNMR.Q2dbas13= uicontrol('Style', 'Check',      'Position', [ 10 120 130  30], 'String', 'Show Projection', 'value', 1);
      QmatNMR.Q2dbas4 = uicontrol('Style', 'Pushbutton', 'Position', [ 10  90 110  30], 'String', 'Define peaks', 'callback', 'defpeaks2d', 'BackgroundColor', QmatNMR.ColorScheme.Button1Back, 'ForegroundColor', QmatNMR.ColorScheme.Button1Fore);
  
      QmatNMR.Q2dbas12= uicontrol('Style', 'Text',       'Position', [310  25  50  30], 'String', 'Order:', 'BackgroundColor', QmatNMR.ColorScheme.Button7Back, 'ForegroundColor', QmatNMR.ColorScheme.Button7Fore);
      QmatNMR.Q2dbas5 = uicontrol('Style', 'Edit',       'Position', [310  10  50  30], 'Callback', '', 'String', QmatNMR.Basl2DOrder, 'BackgroundColor', QmatNMR.ColorScheme.Button1Back, 'ForegroundColor', QmatNMR.ColorScheme.Button1Fore);
      QmatNMR.Q2dbas6 = uicontrol('Style', 'Pushbutton', 'Position', [380 110 110  30], 'String', 'Undo', 'callback', 'QTEMP = 3; stopbasl2d', 'BackgroundColor', QmatNMR.ColorScheme.Button1Back, 'ForegroundColor', QmatNMR.ColorScheme.Button1Fore);
      QmatNMR.Q2dbas7 = uicontrol('Style', 'Pushbutton', 'Position', [ 10  45 110  30], 'String', 'Accept Fit', 'callback', 'QTEMP = 2; stopbasl2d', 'BackgroundColor', QmatNMR.ColorScheme.Button4Back, 'ForegroundColor', QmatNMR.ColorScheme.Button4Fore); 
  
      QmatNMR.Q2dbas8 = uicontrol('Style', 'Pushbutton', 'Position', [150  70 150  30], 'String', 'Ending Row/Column :', 'BackgroundColor', QmatNMR.ColorScheme.Button2Back, 'ForegroundColor', QmatNMR.ColorScheme.Button2Fore);
      QmatNMR.Q2dbas9 = uicontrol('Style', 'Edit',       'Position', [301  70  70  30], 'Callback', '', 'String', '', 'BackgroundColor', QmatNMR.ColorScheme.Button1Back, 'ForegroundColor', QmatNMR.ColorScheme.Button1Fore);
      QmatNMR.Q2dbas10= uicontrol('Style', 'Pushbutton', 'Position', [150 100 150  30], 'String', 'Starting Row/Column :', 'BackgroundColor', QmatNMR.ColorScheme.Button2Back, 'ForegroundColor', QmatNMR.ColorScheme.Button2Fore);
      QmatNMR.Q2dbas11= uicontrol('Style', 'Edit',       'Position', [301 100  70  30], 'Callback', '', 'String', '', 'BackgroundColor', QmatNMR.ColorScheme.Button1Back, 'ForegroundColor', QmatNMR.ColorScheme.Button1Fore);
  
      QmatNMR.FitPerformed = 0;
      disablephasebuttons;
      clear QTEMP
    end
  
    QmatNMR.backup = real(QmatNMR.Spec2D);
    QmatNMR.baslcornoise = [];
  end

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
