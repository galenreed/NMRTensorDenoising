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
%stats2d.m allows the user to create a PPM or frequency scale in 2D and 3D plots
%
%03-07-1997

try
  %
  %First we check whether the current plot is of the right type as the axis rulers cannot
  %be changed for all plot types
  %
  QTEMP1 = get(QmatNMR.Fig2D3D, 'userdata');
  if (QTEMP1.PlotType(QmatNMR.AxisNR2D3D) > 5)
    disp('matNMR NOTICE: Changing of the axis rulers is not supported for the current plot type!');
  
  else
    %
    %Then we check whether the window already exists and just needs to be pulled forward.
    %
    if ~isempty(QmatNMR.statfig2d)
      figure(QmatNMR.statfig2d);
    else
      QmatNMR.statfig2d = figure('Pointer', 'Arrow', 'units', 'normalized', 'Position', [0.0078 0.0433 0.3342 0.3222], ...
                                 'Name', 'Enter the spectral information', 'Numbertitle', 'off', 'Resize', 'on', 'CloseRequestFCN', 'delete(QmatNMR.statfig2d); QmatNMR.statfig2d = [];', ...
                                 'menubar', 'none', ...
                                 'CloseRequestFCN', 'global QmatNMR; try; delete(QmatNMR.statfig2d); end; QmatNMR.statfig2d = [];', 'color', QmatNMR.ColorScheme.Figure1Back);
  
    %
    %To work around a Matlab bug (see BugFixes.txt, 11-05-'04) we redefine the position and units.
    %
    set(QmatNMR.statfig2d, 'units', 'normalized', 'position', [0.0078 0.0433 0.3342 0.3222]);
    
      QmatNMR.s12= uicontrol('parent', QmatNMR.statfig2d, 'units', 'normalized', 'Style', 'Pushbutton', 'Position',  [0.0104 0      0.5195 0.0931], 'String', 'Save vector T1 as (optional) :', 'backgroundcolor', QmatNMR.ColorScheme.Button12Back, 'foregroundcolor', QmatNMR.ColorScheme.Button12Fore);
      QmatNMR.s1 = uicontrol('parent', QmatNMR.statfig2d, 'units', 'normalized', 'Style', 'Pushbutton', 'Position',  [0.0104 0.0931 0.5195 0.0931], 'String', 'Spectral Width T1 (kHz) :          ', 'backgroundcolor', QmatNMR.ColorScheme.Button12Back, 'foregroundcolor', QmatNMR.ColorScheme.Button12Fore);
      QmatNMR.s2 = uicontrol('parent', QmatNMR.statfig2d, 'units', 'normalized', 'Style', 'Pushbutton', 'Position',  [0.0104 0.1862 0.5195 0.0931], 'String', 'Spectrometer freq. T1 (MHz) : ', 'backgroundcolor', QmatNMR.ColorScheme.Button12Back, 'foregroundcolor', QmatNMR.ColorScheme.Button12Fore);
      QmatNMR.s13= uicontrol('parent', QmatNMR.statfig2d, 'units', 'normalized', 'Style', 'Pushbutton', 'Position',  [0.0104 0.4960 0.5195 0.0931], 'String', 'Save vector T2 as (optional) :', 'backgroundcolor', QmatNMR.ColorScheme.Button12Back, 'foregroundcolor', QmatNMR.ColorScheme.Button12Fore);
      QmatNMR.s3 = uicontrol('parent', QmatNMR.statfig2d, 'units', 'normalized', 'Style', 'Pushbutton', 'Position',  [0.0104 0.5891 0.5195 0.0931], 'String', 'Spectral Width T2 (kHz) :          ', 'backgroundcolor', QmatNMR.ColorScheme.Button12Back, 'foregroundcolor', QmatNMR.ColorScheme.Button12Fore);
      QmatNMR.s4 = uicontrol('parent', QmatNMR.statfig2d, 'units', 'normalized', 'Style', 'Pushbutton', 'Position',  [0.0104 0.6822 0.5195 0.0931], 'String', 'Spectrometer freq. T2 (MHz) : ', 'backgroundcolor', QmatNMR.ColorScheme.Button12Back, 'foregroundcolor', QmatNMR.ColorScheme.Button12Fore);
    
      QmatNMR.s5 = uicontrol('parent', QmatNMR.statfig2d, 'units', 'normalized', 'Style', 'Pushbutton', 'Position',  [0.0104 0.8414 0.3636 0.1379], 'String', 'Close Window', 'callback', 'global QmatNMR; try; delete(QmatNMR.statfig2d); end; QmatNMR.statfig2d = [];', 'backgroundcolor', QmatNMR.ColorScheme.Button3Back, 'foregroundcolor', QmatNMR.ColorScheme.Button3Fore); 
      QmatNMR.s10= uicontrol('parent', QmatNMR.statfig2d, 'units', 'normalized', 'Style', 'Pushbutton', 'Position',  [0.7247 0.8414 0.2597 0.1379], 'String', 'Continue', 'callback', 'global QmatNMR; try; delete(QmatNMR.statfig2d); end; QmatNMR.statfig2d = []; prescale2d', 'backgroundcolor', QmatNMR.ColorScheme.Button4Back, 'foregroundcolor', QmatNMR.ColorScheme.Button4Fore);
    
            uicontrol('parent', QmatNMR.statfig2d, 'units', 'normalized', 'style', 'text',       'position',  [0      0.3898 0.1499 0.0690], 'string', 'TD2:', 'backgroundcolor', QmatNMR.ColorScheme.Button12Back, 'foregroundcolor', QmatNMR.ColorScheme.Button12Fore);
      QmatNMR.s20= uicontrol('parent', QmatNMR.statfig2d, 'units', 'normalized', 'Style', 'Popup',      'Position',  [0.1329 0.3870 0.1718 0.0966], 'String', 'g > 0 |g < 0', 'FontName','Symbol', 'callback', 'whatgamma2d', 'value',QmatNMR.gamma2d1, 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
            uicontrol('parent', QmatNMR.statfig2d, 'units', 'normalized', 'style', 'text',       'position',  [0      0.2948 0.1499 0.0690], 'string', 'TD1:', 'backgroundcolor', QmatNMR.ColorScheme.Button12Back, 'foregroundcolor', QmatNMR.ColorScheme.Button12Fore);
      QmatNMR.s21= uicontrol('parent', QmatNMR.statfig2d, 'units', 'normalized', 'Style', 'Popup',      'Position',  [0.1329 0.2900 0.1718 0.0966], 'String', 'g > 0 |g < 0', 'FontName','Symbol', 'callback', 'whatgamma2d', 'value',QmatNMR.gamma2d2, 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
    
      QmatNMR.s11= uicontrol('parent', QmatNMR.statfig2d, 'units', 'normalized', 'Style', 'Popup',      'Position',  [0.3500 0.3387 0.1878 0.1034], 'String', 'ppm | Hz | kHz | Time | Points | User Def.', 'callback', 'whataxis2d','value', QmatNMR.statuspar2d, 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
      QmatNMR.s22= uicontrol('parent', QmatNMR.statfig2d, 'units', 'normalized', 'Style', 'Check',      'Position',  [0.6000 0.3387 0.3800 0.0966], 'string', 'Connect to variable ? ', 'Value', QmatNMR.ConnectAxisToVariable2D, 'callback', 'QmatNMR.ConnectAxisToVariable2D = get(QmatNMR.s22, ''value'');', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
    
      				%check whether the current axis variable is a proper variable name
      if ~CheckVariableName(QmatNMR.UserDefAxisT1Cont)
        QmatNMR.UserDefAxisT1Cont = '';
      end
      QmatNMR.s14= uicontrol('parent', QmatNMR.statfig2d, 'units', 'normalized', 'Style', 'Edit', 'Position',        [0.6208 0      0.3636 0.0931], 'String', QmatNMR.UserDefAxisT1Cont, 'callback', 'QmatNMR.UserDefAxisT1Cont = get(QmatNMR.s14, ''String'');', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
      QmatNMR.s6 = uicontrol('parent', QmatNMR.statfig2d, 'units', 'normalized', 'Style', 'Edit', 'Position',        [0.6208 0.0931 0.3636 0.0931], 'callback', 'getsweep2', 'String', QmatNMR.SWTD1, 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
      QmatNMR.s7 = uicontrol('parent', QmatNMR.statfig2d, 'units', 'normalized', 'Style', 'Edit', 'Position',        [0.6208 0.1862 0.3636 0.0931], 'callback', 'regelstats2', 'string', num2str(QmatNMR.SFTD1, 10), 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
    
      				%check whether the current axis variable is a proper variable name
      if ~CheckVariableName(QmatNMR.UserDefAxisT2Cont)
        QmatNMR.UserDefAxisT2Cont = '';
      end
      QmatNMR.s15= uicontrol('parent', QmatNMR.statfig2d, 'units', 'normalized', 'Style', 'Edit', 'Position',        [0.6208 0.4960 0.3636 0.0931], 'String', QmatNMR.UserDefAxisT2Cont, 'callback', 'QmatNMR.UserDefAxisT2Cont = get(QmatNMR.s15, ''String'');', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
      QmatNMR.s8 = uicontrol('parent', QmatNMR.statfig2d, 'units', 'normalized', 'Style', 'Edit', 'Position',        [0.6208 0.5891 0.3636 0.0931], 'callback', 'getsweep1', 'String', QmatNMR.SWTD2, 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
      QmatNMR.s9 = uicontrol('parent', QmatNMR.statfig2d, 'units', 'normalized', 'Style', 'Edit', 'Position',        [0.6208 0.6822 0.3636 0.0931], 'callback', 'regelstats1', 'string', num2str(QmatNMR.SFTD2, 10), 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
    end
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
