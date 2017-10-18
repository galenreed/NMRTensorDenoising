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
%basl1dmenu.m creates a GUI interface for the 1D baseline correction menu in matNMR
%20-1-98


try
  if (QmatNMR.DisplayMode == 3)
    disp('matNMR NOTICE:  not possible in display mode "both"!     basl1dmenu cancelled.');
  
  else
    if (QmatNMR.SwitchTo1D) 		%switch from 2D to 1D processing if necessary
      SwitchTo1D
    end
    
    %
    %To make sure that the 2D baseline routine isn't open as well, I'll close it.
    %That way there can be no interference between the two routines.
    %
    try
      delete(QmatNMR.Basl2Dfig);
      QmatNMR.Basl2Dfig = [];
    end  

    if ~isempty(QmatNMR.Basl1Dfig)
      figure(QmatNMR.Basl1Dfig);			%It already exists so just pull to front
    
      QmatNMR.backup = QmatNMR.Spec1D;
      QmatNMR.baslcornoise = [];
      
    else  
      regelUNDO
      
      QTEMP = CenterOfScreen;
      QmatNMR.Basl1Dfig = figure('Pointer', 'Arrow', 'units', 'pixels', 'Position', [(QTEMP(1)-250) 50 500 120], 'Name', '1D Baseline correction', ...
                                 'menubar', 'none', ...
                                 'Numbertitle', 'off', 'Resize', 'off', 'tag', 'baslcormenufig', 'closerequestfcn', 'QTEMP = 1; stopbasl1d', 'color', QmatNMR.ColorScheme.Figure1Back);
      %
      %To work around a Matlab bug (see BugFixes.txt, 11-05-'04) we redefine the position and units.
      %
      set(QmatNMR.Basl1Dfig, 'units', 'pixels', 'position', [(QTEMP(1)-250) 50 500 120]);
    
      set(gca, 'visible', 'off');
    
      QmatNMR.bas1 = uicontrol('Style', 'Pushbutton', 'Position', [ 10  10 110  30], 'String', 'Reject Fit', 'callback', 'QTEMP = 1; stopbasl1d', 'BackgroundColor', QmatNMR.ColorScheme.Button3Back, 'ForegroundColor', QmatNMR.ColorScheme.Button3Fore); 
      QmatNMR.bas2 = uicontrol('Style', 'Pushbutton', 'Position', [380  40 110  30], 'String', 'Fit', 'callback', 'doebasl1dcor', 'BackgroundColor', QmatNMR.ColorScheme.Button5Back, 'ForegroundColor', QmatNMR.ColorScheme.Button5Fore);
      QmatNMR.bas3 = uicontrol('Style', 'Popup',      'Position', [150  10 150  30], 'String', 'Polynomial | Bernstein Polynomial | Cosine Series', 'value', QmatNMR.Basl1DFunction, 'BackgroundColor', QmatNMR.ColorScheme.Button1Back, 'ForegroundColor', QmatNMR.ColorScheme.Button1Fore);
      QmatNMR.bas30= uicontrol('Style', 'Popup',      'Position', [150  45 150  30], 'String', 'Interactive', 'value', QmatNMR.Basl1DAutoFlag, 'BackgroundColor', QmatNMR.ColorScheme.Button1Back, 'ForegroundColor', QmatNMR.ColorScheme.Button1Fore);

      QmatNMR.bas4 = uicontrol('Style', 'Pushbutton', 'Position', [380  70 110  30], 'String', 'Define peaks', 'callback', 'defpeaks1d', 'BackgroundColor', QmatNMR.ColorScheme.Button1Back, 'ForegroundColor', QmatNMR.ColorScheme.Button1Fore);
      QmatNMR.bas37 = uicontrol('Style', 'Text',      'Position', [310  25  50  30], 'String', 'Order:', 'BackgroundColor', QmatNMR.ColorScheme.Button12Back, 'ForegroundColor', QmatNMR.ColorScheme.Button12Fore);
      QmatNMR.bas5 = uicontrol('Style', 'Edit',       'Position', [310  10  50  30], 'Callback', '', 'String', QmatNMR.Basl1DOrder, 'BackgroundColor', QmatNMR.ColorScheme.Button1Back, 'ForegroundColor', QmatNMR.ColorScheme.Button1Fore);
      QmatNMR.bas6 = uicontrol('Style', 'Pushbutton', 'Position', [380  10 110  30], 'String', 'Undo', 'callback', 'QTEMP = 3; stopbasl1d', 'fontweight', 'bold', 'BackgroundColor', QmatNMR.ColorScheme.Button1Back, 'ForegroundColor', QmatNMR.ColorScheme.Button1Fore);
      QmatNMR.bas7 = uicontrol('Style', 'Pushbutton', 'Position', [ 10  45 110  30], 'String', 'Accept Fit', 'callback', 'QTEMP = 2; stopbasl1d', 'BackgroundColor', QmatNMR.ColorScheme.Button4Back, 'ForegroundColor', QmatNMR.ColorScheme.Button4Fore); 
    
    
      QmatNMR.backup = QmatNMR.Spec1D;
      QmatNMR.baslcornoise = [];
    
      QmatNMR.FitPerformed = 0;
      disablephasebuttons;
      clear QTEMP
    end
  end

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
