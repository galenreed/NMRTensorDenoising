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
%stats1d takes care of a user window to get a scale in Hz or PPM
%13-12-'96

try
  if QmatNMR.statfig > 0
    figure(QmatNMR.statfig);			%It already exists so just pull to front
  else  
    QmatNMR.statfig = figure('Pointer', 'Arrow', 'units', 'normalized', 'Position',    [0.0503 0.3133 0.3411 0.20], 'Name', 'Enter the spectral information', ...
                             'menubar', 'none', ...
                             'Numbertitle', 'off', 'Resize', 'off', 'CloseRequestFCN', 'global QmatNMR; try; delete(QmatNMR.statfig); end; QmatNMR.statfig = [];', 'color', QmatNMR.ColorScheme.Figure1Back);
  
    %
    %To work around a Matlab bug (see BugFixes.txt, 11-05-'04) we redefine the position and units.
    %
    set(QmatNMR.statfig, 'units', 'normalized', 'position', [0.0503 0.3133 0.3411 0.20]);
  
    QmatNMR.s1d15= uicontrol('parent', QmatNMR.statfig, 'units', 'normalized', 'Style', 'Pushbutton', 'Position', [0.0120 0.0000 0.5198 0.1500], 'String', 'Save as external reference (optional)', 'backgroundcolor', QmatNMR.ColorScheme.Button12Back, 'foregroundcolor', QmatNMR.ColorScheme.Button12Fore);
    QmatNMR.s1d13= uicontrol('parent', QmatNMR.statfig, 'units', 'normalized', 'Style', 'Pushbutton', 'Position', [0.0120 0.1500 0.5198 0.1500], 'String', 'Save axis vector as (optional)', 'backgroundcolor', QmatNMR.ColorScheme.Button12Back, 'foregroundcolor', QmatNMR.ColorScheme.Button12Fore);
    QmatNMR.s1d1 = uicontrol('parent', QmatNMR.statfig, 'units', 'normalized', 'Style', 'Pushbutton', 'Position', [0.0120 0.3000 0.5198 0.1500], 'String', 'Spectral Width (kHz)     ', 'backgroundcolor', QmatNMR.ColorScheme.Button12Back, 'foregroundcolor', QmatNMR.ColorScheme.Button12Fore);
    QmatNMR.s1d2 = uicontrol('parent', QmatNMR.statfig, 'units', 'normalized', 'Style', 'Pushbutton', 'Position', [0.0120 0.4500 0.5198 0.1500], 'String', 'Spectrometer freq. (MHz)', 'backgroundcolor', QmatNMR.ColorScheme.Button12Back, 'foregroundcolor', QmatNMR.ColorScheme.Button12Fore);
    QmatNMR.s1d5 = uicontrol('parent', QmatNMR.statfig, 'units', 'normalized', 'Style', 'Pushbutton', 'Position', [0.0120 0.7500 0.3562 0.1800], 'String', 'Close Window', 'callback', 'global QmatNMR; try; delete(QmatNMR.statfig); end; QmatNMR.statfig = [];', 'backgroundcolor', QmatNMR.ColorScheme.Button3Back, 'foregroundcolor', QmatNMR.ColorScheme.Button3Fore); 
  
      				%check whether the current axis variable is a proper variable name
    if ~CheckVariableName(QmatNMR.UserDefRef)
      QmatNMR.UserDefRef = '';
    end
    QmatNMR.s1d16= uicontrol('parent', QmatNMR.statfig, 'units', 'normalized', 'Style', 'Edit', 'Position',       [0.5319 0.0000 0.4452 0.1500], 'callback', 'QmatNMR.UserDefRef = get(QmatNMR.s1d16, ''String'');', 'string', QmatNMR.UserDefRef, 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
    if ~CheckVariableName(QmatNMR.UserDefAxis)
      QmatNMR.UserDefAxis = '';
    end
    QmatNMR.s1d14= uicontrol('parent', QmatNMR.statfig, 'units', 'normalized', 'Style', 'Edit', 'Position',       [0.5319 0.1500 0.4452 0.1500], 'callback', 'QmatNMR.UserDefAxis = get(QmatNMR.s1d14, ''String'');', 'string', QmatNMR.UserDefAxis, 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
    QmatNMR.s1d6 = uicontrol('parent', QmatNMR.statfig, 'units', 'normalized', 'Style', 'Edit', 'Position',       [0.5319 0.3000 0.4452 0.1500], 'callback', 'getsweep1d', 'string', num2str(QmatNMR.SW1D, 15), 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
    QmatNMR.s1d7 = uicontrol('parent', QmatNMR.statfig, 'units', 'normalized', 'Style', 'Edit', 'Position',       [0.5319 0.4500 0.4452 0.1500], 'callback', 'regelstats1d', 'string', num2str(QmatNMR.SF1D, 15), 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  
    QmatNMR.s1d10= uicontrol('parent', QmatNMR.statfig, 'units', 'normalized', 'Style', 'Pushbutton', 'Position', [0.7226 0.7500 0.2545 0.1800], 'String', 'Continue', 'callback', 'global QmatNMR; try; delete(QmatNMR.statfig); end; QmatNMR.statfig = [];  prescale1d', 'backgroundcolor', QmatNMR.ColorScheme.Button4Back, 'foregroundcolor', QmatNMR.ColorScheme.Button4Fore);
    QmatNMR.s1d11= uicontrol('parent', QmatNMR.statfig, 'units', 'normalized', 'Style', 'Popup', 'Position',      [0.4427 0.8000 0.2036 0.1800], 'String', 'ppm | Hz | kHz | Time | Points | User Def.', 'callback', 'whataxis1d', 'value', QmatNMR.statuspar, 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  
    QmatNMR.s1d12= uicontrol('parent', QmatNMR.statfig, 'units', 'normalized', 'Style', 'Popup', 'Position',      [0.4427 0.6200 0.2036 0.1800], 'String', 'g > 0 | g < 0', 'FontName','Symbol', 'callback', 'whatgamma1d', 'value', QmatNMR.gamma1d, 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  end

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
