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
%Qoptions.m is the script that handles all general optional settings in matNMR
%9-8-'96

try
  if ~isempty(QmatNMR.ofig)
    figure(QmatNMR.ofig)		%if still exists, pull window to the front
  else  
    QmatNMR.height = 530;
    QmatNMR.ofig = figure('Pointer', 'Arrow', 'units', 'pixels', ...
                          'Position', [(QmatNMR.ComputerScreenSize(3)-393)/2 (QmatNMR.ComputerScreenSize(4)-QmatNMR.height)/2 393 QmatNMR.height], ...
                          'Name', 'General Options Menu', 'Numbertitle', 'off', 'Resize', 'off', 'CloseRequestFCN', 'delete(QmatNMR.ofig); QmatNMR.ofig = [];', ...
                          'menubar', 'none', ...
                          'color', QmatNMR.ColorScheme.Figure1Back);
    %
    %To work around a Matlab bug (see BugFixes.txt, 11-05-'04) we redefine the position and units.
    %
    drawnow
    set(QmatNMR.ofig, 'units', 'pixels', 'position', [(QmatNMR.ComputerScreenSize(3)-393)/2 (QmatNMR.ComputerScreenSize(4)-QmatNMR.height)/2 393 QmatNMR.height]);
  
    QmatNMR.o27 = uicontrol('Parent', QmatNMR.ofig, 'Style', 'check',	'Position', [ 10 (QmatNMR.height -  50) 180  30], 'String', 'Show matNMR logo', 'BackGroundColor', QmatNMR.ColorScheme.Button1Back, 'ForeGroundColor', QmatNMR.ColorScheme.Button1Fore);
    QmatNMR.o29 = uicontrol('Parent', QmatNMR.ofig, 'Style', 'check',	'Position', [205 (QmatNMR.height -  50) 180  30], 'String', 'Exit Safety', 'BackGroundColor', QmatNMR.ColorScheme.Button1Back, 'ForeGroundColor', QmatNMR.ColorScheme.Button1Fore);
  
           uicontrol('Parent', QmatNMR.ofig, 'Style', 'Pushbutton', 'Position', [10 (QmatNMR.height - 80) 110  30], 'String', 'Nr. of UNDO 1D:', 'BackGroundColor', QmatNMR.ColorScheme.Button1Back, 'ForeGroundColor', QmatNMR.ColorScheme.Button1Fore);
    QmatNMR.o33 = uicontrol('Parent', QmatNMR.ofig, 'Style', 'Edit', 	'Position', [130 (QmatNMR.height -  80)  60  30], 'String', '1', 'BackGroundColor', QmatNMR.ColorScheme.Button2Back, 'ForeGroundColor', QmatNMR.ColorScheme.Button2Fore);
           uicontrol('Parent', QmatNMR.ofig, 'Style', 'Pushbutton', 'Position', [205 (QmatNMR.height - 80) 110  30], 'String', 'Nr. of UNDO 2D:', 'BackGroundColor', QmatNMR.ColorScheme.Button1Back, 'ForeGroundColor', QmatNMR.ColorScheme.Button1Fore);
    QmatNMR.o34 = uicontrol('Parent', QmatNMR.ofig, 'Style', 'Edit', 	'Position', [325 (QmatNMR.height -  80)  60  30], 'String', '1', 'BackGroundColor', QmatNMR.ColorScheme.Button2Back, 'ForeGroundColor', QmatNMR.ColorScheme.Button2Fore);
  
  
    QmatNMR.o8  = uicontrol('Parent', QmatNMR.ofig, 'Style', 'check', 	'Position', [ 10 (QmatNMR.height - 110) 180  30], 'String', 'X Scale', 'BackGroundColor', QmatNMR.ColorScheme.Button1Back, 'ForeGroundColor', QmatNMR.ColorScheme.Button1Fore);
    QmatNMR.o3  = uicontrol('Parent', QmatNMR.ofig, 'Style', 'check', 	'Position', [205 (QmatNMR.height - 110) 180  30], 'String', 'Y Scale', 'BackGroundColor', QmatNMR.ColorScheme.Button1Back, 'ForeGroundColor', QmatNMR.ColorScheme.Button1Fore);
  
    QmatNMR.o6  = uicontrol('Parent', QmatNMR.ofig, 'Style', 'check', 	'Position', [ 10 (QmatNMR.height - 140) 120  30], 'String', '1D menu', 'BackGroundColor', QmatNMR.ColorScheme.Button1Back, 'ForeGroundColor', QmatNMR.ColorScheme.Button1Fore);
    QmatNMR.o6a = uicontrol('Parent', QmatNMR.ofig, 'Style', 'check', 	'Position', [138 (QmatNMR.height - 140) 120  30], 'String', 'Phase menu', 'BackGroundColor', QmatNMR.ColorScheme.Button1Back, 'ForeGroundColor', QmatNMR.ColorScheme.Button1Fore);
    QmatNMR.o6b = uicontrol('Parent', QmatNMR.ofig, 'Style', 'check', 	'Position', [265 (QmatNMR.height - 140) 120  30], 'String', '2D menu', 'BackGroundColor', QmatNMR.ColorScheme.Button1Back, 'ForeGroundColor', QmatNMR.ColorScheme.Button1Fore);
  
    QmatNMR.o9  = uicontrol('Parent', QmatNMR.ofig, 'Style', 'check', 	'Position', [ 10 (QmatNMR.height - 170) 120  30], 'String', 'Relative Y Scale', 'BackGroundColor', QmatNMR.ColorScheme.Button1Back, 'ForeGroundColor', QmatNMR.ColorScheme.Button1Fore);
    QmatNMR.o4  = uicontrol('Parent', QmatNMR.ofig, 'Style', 'check', 	'Position', [138 (QmatNMR.height - 170) 120  30], 'String', 'Grid', 'BackGroundColor', QmatNMR.ColorScheme.Button1Back, 'ForeGroundColor', QmatNMR.ColorScheme.Button1Fore);
    QmatNMR.o39 = uicontrol('Parent', QmatNMR.ofig, 'Style', 'check', 	'Position', [265 (QmatNMR.height - 170) 120  30], 'String', 'Mult by 0.5', 'BackGroundColor', QmatNMR.ColorScheme.Button1Back, 'ForeGroundColor', QmatNMR.ColorScheme.Button1Fore);
  
    QmatNMR.o21 = uicontrol('Parent', QmatNMR.ofig, 'Style', 'popup', 	'Position', [ 10 (QmatNMR.height - 200) 180  30], 'String', 'Complex FT TD2 | Real FT TD2 | States TD2 | TPPI TD2 | Whole Echo TD2 | States-TPPI TD2 | Bruker qseq TD2 | Sine FT TD2', 'BackGroundColor', QmatNMR.ColorScheme.Button1Back, 'ForeGroundColor', QmatNMR.ColorScheme.Button1Fore);
    QmatNMR.o22 = uicontrol('Parent', QmatNMR.ofig, 'Style', 'popup', 	'Position', [205 (QmatNMR.height - 200) 180  30], 'String', 'Complex FT TD1 | Real FT TD1 | States TD1 | TPPI TD1 | Whole Echo TD1 | States-TPPI TD1 | Bruker qseq TD1 | Sine FT TD1', 'BackGroundColor', QmatNMR.ColorScheme.Button1Back, 'ForeGroundColor', QmatNMR.ColorScheme.Button1Fore);
  
    QmatNMR.o37 = uicontrol('Parent', QmatNMR.ofig, 'Style', 'popup', 	'Position', [ 10 (QmatNMR.height - 230) 180  30], 'String', 'TD: Time TD2 | TD: Points TD2', 'BackGroundColor', QmatNMR.ColorScheme.Button1Back, 'ForeGroundColor', QmatNMR.ColorScheme.Button1Fore);
    QmatNMR.o38 = uicontrol('Parent', QmatNMR.ofig, 'Style', 'popup', 	'Position', [205 (QmatNMR.height - 230) 180  30], 'String', 'TD: Time TD1 | TD: Points TD1', 'BackGroundColor', QmatNMR.ColorScheme.Button1Back, 'ForeGroundColor', QmatNMR.ColorScheme.Button1Fore);
  
    QmatNMR.o35 = uicontrol('Parent', QmatNMR.ofig, 'Style', 'popup', 	'Position', [ 10 (QmatNMR.height - 260) 180  30], 'String', 'FD: kHz TD2 | FD: Hz TD2 | FD: PPM TD2 | FD: Points TD2', 'BackGroundColor', QmatNMR.ColorScheme.Button1Back, 'ForeGroundColor', QmatNMR.ColorScheme.Button1Fore);
    QmatNMR.o36 = uicontrol('Parent', QmatNMR.ofig, 'Style', 'popup', 	'Position', [205 (QmatNMR.height - 260) 180  30], 'String', 'FD: kHz TD1 | FD: Hz TD1 | FD: PPM TD1 | FD: Points TD1', 'BackGroundColor', QmatNMR.ColorScheme.Button1Back, 'ForeGroundColor', QmatNMR.ColorScheme.Button1Fore);
  
    QmatNMR.o28 = uicontrol('Parent', QmatNMR.ofig, 'Style', 'Popup',   'Position', [ 10 (QmatNMR.height - 300) 180  30], 'String', 'Only Positive|Only Negative|Abs. Pos. and Abs. Neg.|Positive and Negative rel. to Positive Maximum', 'BackGroundColor', QmatNMR.ColorScheme.Button1Back, 'ForeGroundColor', QmatNMR.ColorScheme.Button1Fore);
    QmatNMR.o11 = uicontrol('Parent', QmatNMR.ofig, 'Style','Pushbutton','Position',[205 (QmatNMR.height - 300) 110  30], 'String', 'Nr. of contours:', 'BackGroundColor', QmatNMR.ColorScheme.Button1Back, 'ForeGroundColor', QmatNMR.ColorScheme.Button1Fore);
    QmatNMR.o12 = uicontrol('Parent', QmatNMR.ofig, 'Style', 'Edit',  	'Position', [325 (QmatNMR.height - 300)  60  30], 'BackGroundColor', QmatNMR.ColorScheme.Button2Back, 'ForeGroundColor', QmatNMR.ColorScheme.Button2Fore);
  
    QmatNMR.o13 = uicontrol('Parent', QmatNMR.ofig, 'Style','Pushbutton','Position',[ 10 (QmatNMR.height - 330) 110  30], 'String', 'Lower Limit (%):', 'BackGroundColor', QmatNMR.ColorScheme.Button1Back, 'ForeGroundColor', QmatNMR.ColorScheme.Button1Fore);
    QmatNMR.o14 = uicontrol('Parent', QmatNMR.ofig, 'Style', 'Edit',  	'Position', [130 (QmatNMR.height - 330)  60  30], 'BackGroundColor', QmatNMR.ColorScheme.Button2Back, 'ForeGroundColor', QmatNMR.ColorScheme.Button2Fore);
    QmatNMR.o15 = uicontrol('Parent', QmatNMR.ofig, 'Style','Pushbutton','Position',[205 (QmatNMR.height - 330) 110  30], 'String', 'Upper Limit (%):', 'BackGroundColor', QmatNMR.ColorScheme.Button1Back, 'ForeGroundColor', QmatNMR.ColorScheme.Button1Fore);
    QmatNMR.o16 = uicontrol('Parent', QmatNMR.ofig, 'Style', 'Edit',  	'Position', [325 (QmatNMR.height - 330)  60  30], 'BackGroundColor', QmatNMR.ColorScheme.Button2Back, 'ForeGroundColor', QmatNMR.ColorScheme.Button2Fore);
    
    QmatNMR.o17 = uicontrol('Parent', QmatNMR.ofig, 'Style','Pushbutton','Position',[ 10 (QmatNMR.height - 360) 110  30], 'String', 'Mesh 3D Az:', 'BackGroundColor', QmatNMR.ColorScheme.Button1Back, 'ForeGroundColor', QmatNMR.ColorScheme.Button1Fore);
    QmatNMR.o18 = uicontrol('Parent', QmatNMR.ofig, 'Style', 'Edit',  	'Position', [130 (QmatNMR.height - 360)  60  30], 'BackGroundColor', QmatNMR.ColorScheme.Button2Back, 'ForeGroundColor', QmatNMR.ColorScheme.Button2Fore);
    QmatNMR.o19 = uicontrol('Parent', QmatNMR.ofig, 'Style','Pushbutton','Position',[205 (QmatNMR.height - 360) 110  30], 'String', 'Mesh 3D El:', 'BackGroundColor', QmatNMR.ColorScheme.Button1Back, 'ForeGroundColor', QmatNMR.ColorScheme.Button1Fore);
    QmatNMR.o20 = uicontrol('Parent', QmatNMR.ofig, 'Style', 'Edit',  	'Position', [325 (QmatNMR.height - 360)  60  30], 'BackGroundColor', QmatNMR.ColorScheme.Button2Back, 'ForeGroundColor', QmatNMR.ColorScheme.Button2Fore);
  
    QmatNMR.o23 = uicontrol('Parent', QmatNMR.ofig, 'Style','Pushbutton','Position',[ 10 (QmatNMR.height - 390) 110  30], 'String', '3D Stack Az:', 'BackGroundColor', QmatNMR.ColorScheme.Button1Back, 'ForeGroundColor', QmatNMR.ColorScheme.Button1Fore);
    QmatNMR.o24 = uicontrol('Parent', QmatNMR.ofig, 'Style', 'Edit',  	'Position', [130 (QmatNMR.height - 390)  60  30], 'BackGroundColor', QmatNMR.ColorScheme.Button2Back, 'ForeGroundColor', QmatNMR.ColorScheme.Button2Fore);
    QmatNMR.o25 = uicontrol('Parent', QmatNMR.ofig, 'Style','Pushbutton','Position',[205 (QmatNMR.height - 390) 110  30], 'String', '3D Stack El:', 'BackGroundColor', QmatNMR.ColorScheme.Button1Back, 'ForeGroundColor', QmatNMR.ColorScheme.Button1Fore);
    QmatNMR.o26 = uicontrol('Parent', QmatNMR.ofig, 'Style', 'Edit', 	'Position', [325 (QmatNMR.height - 390)  60  30], 'BackGroundColor', QmatNMR.ColorScheme.Button2Back, 'ForeGroundColor', QmatNMR.ColorScheme.Button2Fore);
  
    QmatNMR.o32 = uicontrol('Parent', QmatNMR.ofig, 'Style', 'popup', 	'Position', [ 10 (QmatNMR.height - 420) 180  30], 'String', QmatNMR.PopupStr, 'BackGroundColor', QmatNMR.ColorScheme.Button1Back, 'ForeGroundColor', QmatNMR.ColorScheme.Button1Fore);
  
    QmatNMR.o30 = uicontrol('Parent', QmatNMR.ofig, 'Style', 'popup', 	'Position', [ 10 (QmatNMR.height - 450) 180  30], 'String', 'portrait | landscape', 'BackGroundColor', QmatNMR.ColorScheme.Button1Back, 'ForeGroundColor', QmatNMR.ColorScheme.Button1Fore);
    QmatNMR.o31 = uicontrol('Parent', QmatNMR.ofig, 'Style', 'popup', 	'Position', [205 (QmatNMR.height - 450) 180  30], 'String', 'usletter | uslegal | tabloid | A0 | A1 | A2 | A3 | A4 | A5 | B0 | B1 | B2 | B3 | B4 | B5 | arch-A | arch-B | arch-C | arch-D | arch-E | A | B | C | D | E', 'BackGroundColor', QmatNMR.ColorScheme.Button1Back, 'ForeGroundColor', QmatNMR.ColorScheme.Button1Fore);
  
  %
  %the action buttons
  %
    QmatNMR.o1 = uicontrol('Parent', QmatNMR.ofig, 'Style', 'Pushbutton', 	'Position', [ 13  10 135  40], 'String', 'Execute + Close', ...
    	'callback', 'QmatNMR.doeopties = 2;  doeopties', 'BackGroundColor', QmatNMR.ColorScheme.Button4Back, 'ForeGroundColor', QmatNMR.ColorScheme.Button4Fore); 
    QmatNMR.o2 = uicontrol('Parent', QmatNMR.ofig, 'Style', 'Pushbutton', 	'Position', [281  10 100  40], 'String', 'Save Options', ...
    	'Callback', 'QmatNMR.doeopties = 1;  doeopties', 'BackGroundColor', QmatNMR.ColorScheme.Button3Back, 'ForeGroundColor', QmatNMR.ColorScheme.Button3Fore);
    QmatNMR.o7 = uicontrol('Parent', QmatNMR.ofig, 'Style', 'Pushbutton', 	'Position', [163  10 100 40], 'String', 'Execute', ...
    	'callback', 'QmatNMR.doeopties = 3;  doeopties', 'BackGroundColor', QmatNMR.ColorScheme.Button5Back, 'ForeGroundColor', QmatNMR.ColorScheme.Button5Fore);
  end
  
  set(QmatNMR.o3,  'value', QmatNMR.yschaal);
  set(QmatNMR.o4,  'Value', QmatNMR.gridvar);
  set(QmatNMR.o6,  'value', QmatNMR.Q1DMenu);
  set(QmatNMR.o6a, 'value', QmatNMR.PhaseMenu);
  set(QmatNMR.o6b, 'value', QmatNMR.Q2DMenu);
  set(QmatNMR.o8,  'Value', QmatNMR.xschaal);
  set(QmatNMR.o9,  'Value', QmatNMR.yrelative);
  set(QmatNMR.o12, 'String', QmatNMR.numbcont);
  set(QmatNMR.o14, 'String', QmatNMR.under);
  set(QmatNMR.o16, 'String', QmatNMR.over);
  set(QmatNMR.o18, 'String', QmatNMR.az);
  set(QmatNMR.o20, 'String', QmatNMR.el);
  set(QmatNMR.o21, 'value', QmatNMR.four2);
  set(QmatNMR.o22, 'value', QmatNMR.four1);
  set(QmatNMR.o24, 'String', QmatNMR.stackaz);
  set(QmatNMR.o26, 'String', QmatNMR.stackel);
  set(QmatNMR.o27, 'value', QmatNMR.ShowLogo);
  set(QmatNMR.o28, 'value', QmatNMRsettings.DefaultNegConts);
  set(QmatNMR.o29, 'value', QmatNMR.matNMRSafety);
  set(QmatNMR.o30, 'value', QmatNMR.PaperOrientation);
  set(QmatNMR.o31, 'value', QmatNMR.PaperSize);
  set(QmatNMR.o32, 'value', QmatNMRsettings.DefaultColormap);
  set(QmatNMR.o33, 'String', QmatNMR.UnDo1D);
  set(QmatNMR.o34, 'String', QmatNMR.UnDo2D);
  set(QmatNMR.u1, 'String', QmatNMR.UnDo1D);
  set(QmatNMR.u2, 'String', QmatNMR.UnDo2D);
  set(QmatNMR.o35, 'value', QmatNMRsettings.DefaultRulerXAxis1FREQ);
  set(QmatNMR.o36, 'value', QmatNMRsettings.DefaultRulerXAxis2FREQ);
  set(QmatNMR.o37, 'value', QmatNMRsettings.DefaultRulerXAxis1TIME);
  set(QmatNMR.o38, 'value', QmatNMRsettings.DefaultRulerXAxis2TIME);
  set(QmatNMR.o39, 'value', QmatNMR.fftstatus);

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
