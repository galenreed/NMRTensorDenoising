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
%matprint.m makes a printing menu with all possible print options available. No changes to
%the figure axes position can be made however !!
%
% 07-03-2001: matprint now should be WYSIWYG. Before printing the window is changed such
%		that the current view on the screen is what is actually printed.
%		To do this parts of the exportfig.m routine by Ben Hinkle have been used.
%		(bhinkle@mathworks.com)
%
% Jacco van Beek
% 24-07-'97


function matprint(Param);

global QmatNMR


if isempty(QmatNMR)			%just in case that someone calls matprint without having started
  QmatNMR.PaperOrientation = 1;		%matNMR we define the paper orientation to portrait and the
  QmatNMR.PaperSize = 8;		%paper size to A4 by default
  QmatNMR.PlatformPC = 666;		%predefine the code for the Windows platform
  QmatNMR.Platform = DeterminePlatform;	%determine the platform

  %
  %The default color scheme 1 ("classic")
  %
  QmatNMR.ColorScheme.Frame1      = [0.40 0.00 0.00];
  QmatNMR.ColorScheme.Frame2      = [0.00 0.00 0.40];
  QmatNMR.ColorScheme.UImenuFore  = [0.00 0.00 0.00];
  QmatNMR.ColorScheme.Figure1Back = [0.00 0.00 0.00];
  QmatNMR.ColorScheme.Figure2Back = [0.20 0.20 0.40];
  QmatNMR.ColorScheme.AxisBack    = 'none';
  QmatNMR.ColorScheme.AxisFore    = [1.00 1.00 1.00];
  QmatNMR.ColorScheme.Button1Fore = [0.00 0.00 0.00];
  QmatNMR.ColorScheme.Button1Back = [0.70 0.70 0.70];
  QmatNMR.ColorScheme.Button2Fore = [1.00 1.00 0.00];
  QmatNMR.ColorScheme.Button2Back = [0.00 0.00 0.00];
  QmatNMR.ColorScheme.Button3Fore = [1.00 1.00 0.00];
  QmatNMR.ColorScheme.Button3Back = [0.40 0.00 0.00];
  QmatNMR.ColorScheme.Button4Fore = [1.00 1.00 0.00];
  QmatNMR.ColorScheme.Button4Back = [0.00 0.40 0.00];
  QmatNMR.ColorScheme.Button5Fore = [1.00 1.00 0.00];
  QmatNMR.ColorScheme.Button5Back = [0.00 0.00 0.40];
  QmatNMR.ColorScheme.Button6Fore = [1.00 1.00 0.00];
  QmatNMR.ColorScheme.Button6Back = [0.30 0.00 0.30];
  QmatNMR.ColorScheme.Button7Fore = [1.00 1.00 1.00];
  QmatNMR.ColorScheme.Button7Back = [0.00 0.00 0.00];
  QmatNMR.ColorScheme.Button8Fore = [1.00 1.00 1.00];
  QmatNMR.ColorScheme.Button8Back = [0.40 0.00 0.00];
  QmatNMR.ColorScheme.Button9Fore = [1.00 1.00 1.00];
  QmatNMR.ColorScheme.Button9Back = [0.00 0.40 0.00];
  QmatNMR.ColorScheme.Button10Fore= [1.00 1.00 1.00];
  QmatNMR.ColorScheme.Button10Back= [0.00 0.00 0.40];
  QmatNMR.ColorScheme.Button11Fore= [0.00 0.00 0.00];
  QmatNMR.ColorScheme.Button11Back= [1.00 1.00 0.00];
  QmatNMR.ColorScheme.Button12Fore= [1.00 1.00 0.00];
  QmatNMR.ColorScheme.Button12Back= [0.00 0.00 0.00];
  QmatNMR.ColorScheme.Button13Fore= [1.00 1.00 1.00];
  QmatNMR.ColorScheme.Button13Back= [0.00 0.00 0.00];
  QmatNMR.ColorScheme.Button14Fore= [1.00 0.00 0.00];
  QmatNMR.ColorScheme.Button14Back= [1.00 1.00 1.00];
  QmatNMR.ColorScheme.Text1Fore   = [1.00 1.00 1.00];
  QmatNMR.ColorScheme.Text1Back   = 'none';
  QmatNMR.ColorScheme.Text2Fore   = [0.49 0.41 1.00];
  QmatNMR.ColorScheme.Text2Back   = 'none';
  QmatNMR.ColorScheme.Text3Fore   = [1.00 1.00 1.00];
  QmatNMR.ColorScheme.Text3Back   = 'none';
  QmatNMR.ColorScheme.LineMain    = 'y';
  QmatNMR.ColorScheme.LineDual    = ['cmrbwg'];
end


%
%Devices from which can be chosen ...
%
PData1 = str2mat('Postscript', '-dps', '-dpsc', '-dps2', '-dpsc2', '-deps', '-depsc', '-deps2', '-depsc2', '-dpdf');
PData2 = str2mat('Other', '-P', '-dhpgl', '-dill', '-dmfile', '-djpeg', '-dtiff', '-dtiffnocompression', '-dpict', '-dpng');
PData3 = str2mat('Ghostscript', '-dlaserjet', '-dljetplus', '-dljet2p', '-dljet3', '-dljet4', '-ddeskjet', '-ddjet500', '-dcdeskjet', '-dcdjmono');
PData3 = str2mat(PData3, '-dcdjcolor', '-dcdj500', '-dcdj550', '-dpaintjet', '-dpjxl', '-dpjetxl', '-dpjxl300', '-ddnj650c', '-dbj10e');
PData3 = str2mat(PData3, '-dbj200', '-dbjc600', '-dln03', '-depson', '-depsonc', '-deps9high', '-dibmpro', '-dbmp256', '-dbmp16m');
PData3 = str2mat(PData3, '-dpcxmono', '-dpcx16', '-dpcx256', '-dpcx24b', '-dpbm', '-dpbmraw', '-dpgm', '-dpgmraw', '-dppm', '-dppmraw', '-dbit', '-dbitrgb', '-dbitcmyk');
PData4 = str2mat('Windows', '-dwin', '-dwinc', '-dmeta', '-dbitmap', '-dsetup');
PData5 = str2mat('Renderer: auto detect', '-zbuffer', '-painters', '-opengl');
PData6 = '-noui';
PData7 = str2mat('portrait', 'landscape');
PData8 = str2mat('usletter', 'uslegal', 'tabloid', 'A0', 'A1', 'A2', 'A3', 'A4', 'A5', 'B0', 'B1', 'B2', 'B3', 'B4', 'B5', ...
                 'arch-A', 'arch-B', 'arch-C', 'arch-D', 'arch-E', 'A', 'B', 'C', 'D', 'E');


%First delete any old figure windows from matprint or find the ButtonList
%
QmatNMR.Ph = findobj(allchild(0),'tag','matprint');
set(QmatNMR.Ph, 'handlevisibility', 'off');
HandleOfPrintFigure = double(gcf);	%after setting the handlevisibility of the matprint window to 'off'
  				                          %the current figure should be the one that needs to be printed

set(QmatNMR.Ph, 'handlevisibility', 'on');

if ~isempty(QmatNMR.Ph)
  if (nargin < 1)		%window exists already so pull it in front, update the string and stop afterwards
    figure(QmatNMR.Ph);
    Arrowhead
    UserData = get(QmatNMR.Ph, 'userdata');
    ButtonList = UserData.ButtonHandles;

    PrintBut15 = ButtonList(16);
    PrintBut16 = ButtonList(17);

    matprint(2);

    return;
  else
    UserData = get(QmatNMR.Ph, 'userdata');
    ButtonList = UserData.ButtonHandles;
    OldPrintString = deblank(UserData.PrintString);
  end;
else
  ButtonList = [];
  OldPrintString = '';
end


%
%Extract buttons from the ButtonList
%
if (~isempty(ButtonList))
  PrintPrint = ButtonList(1);
  PrintBut1  = ButtonList(2);
  PrintBut2  = ButtonList(3);
  PrintBut3  = ButtonList(4);
  PrintBut4  = ButtonList(5);
  PrintBut5  = ButtonList(6);
  PrintBut6  = ButtonList(7);
  PrintBut7  = ButtonList(8);
  PrintBut8  = ButtonList(9);
  PrintBut9  = ButtonList(10);
  PrintBut10 = ButtonList(11);
  PrintBut11 = ButtonList(12);
  PrintBut12 = ButtonList(13);
  PrintBut13 = ButtonList(14);
  PrintBut14 = ButtonList(15);
  PrintBut15 = ButtonList(16);
  PrintBut16 = ButtonList(17);
  PrintBut17 = ButtonList(18);

  PrintText1 = ButtonList(19);
  PrintText2 = ButtonList(20);
  PrintText3 = ButtonList(21);
  PrintText4 = ButtonList(22);
  PrintText5 = ButtonList(23);
  PrintText6 = ButtonList(24);
  PDevice    = ButtonList(25);

  %
  %is WYSIWYG behaviour asked for?
  %
  WYSIWYGwanted = get(PrintBut17, 'value');
end


if ((nargin < 1) & (isempty(ButtonList)))		%make new figure window if needed
%
%Create new figure window and uicontrols
%
	Param = 99;


	%Now make new figure window
	%
	QmatNMR.Center = CenterOfScreen;
	PrintCoord = [QmatNMR.Center(1)-300 QmatNMR.Center(2)-100 600 400];

	QmatNMR.Ph = figure('Pointer', 'Arrow', ...
                   'units', 'pixels', ...
                   'Position', PrintCoord, ...
                   'Name', ['matNMR Printing Menu'], ...
                   'Numbertitle', 'off', ...
                   'Resize', 'off', ...
		   'CloseRequestFCN', 'matprint(-99)', ...
                   'menubar', 'none', ...
		   'color', QmatNMR.ColorScheme.Figure1Back, ...
                   'Tag', 'matprint');

  %
  %To work around a Matlab bug (see BugFixes.txt, 11-05-'04) we redefine the position and units.
  %
  drawnow
  set(QmatNMR.Ph, 'units', 'pixels', 'position', PrintCoord);

	PrintClose = uicontrol('Style', 'Pushbutton', ...
	               'parent', QmatNMR.Ph, ...
                       'units', 'pixels', ...
                       'Position', [450  10 100  40], ...
                       'String', 'Close', ...
                       'BackgroundColor', QmatNMR.ColorScheme.Button8Back, ...
                       'ForegroundColor', QmatNMR.ColorScheme.Button8Fore, ...
                       'Callback', 'matprint(-99);');


	PrintHide = uicontrol('Style', 'Pushbutton', ...
	               'parent', QmatNMR.Ph, ...
                       'units', 'pixels', ...
                       'Position', [350  10 100  40], ...
                       'String', 'Hide', ...
                       'BackgroundColor', QmatNMR.ColorScheme.Button10Back, ...
                       'ForegroundColor', QmatNMR.ColorScheme.Button10Fore, ...
                       'Callback', 'matprint(-98);');

	PrintPrint = uicontrol('Style', 'Pushbutton', ...
	               'parent', QmatNMR.Ph, ...
                       'units', 'pixels', ...
                       'Position', [ 50  10 100  40], ...
                       'String', 'Print', ...
                       'BackgroundColor', QmatNMR.ColorScheme.Button9Back, ...
                       'ForegroundColor', QmatNMR.ColorScheme.Button9Fore, ...
                       'Callback', 'matprint(0);');

	PrintText1 = uicontrol('Style', 'Text', ...
	               'parent', QmatNMR.Ph, ...
                       'units', 'pixels', ...
                       'Position', [ 10  90 350  30], ...
                       'String', 'Print command :', ...
                       'BackgroundColor', QmatNMR.ColorScheme.Button12Back, ...
                       'ForegroundColor', QmatNMR.ColorScheme.Button12Fore, ...
                       'HorizontalALignment', 'left');

	PrintBut1  = uicontrol('Style', 'Edit', ...
	               'parent', QmatNMR.Ph, ...
                       'units', 'pixels', ...
                       'Position', [ 10  65 580  30], ...
                       'BackgroundColor', QmatNMR.ColorScheme.Button12Back, ...
                       'ForegroundColor', QmatNMR.ColorScheme.Button12Fore, ...
                       'HorizontalAlignment', 'Left', ...
                       'callback', 'matprint(1);');


	%
	% general options :
	%

	PrintText2 = uicontrol('Style', 'Text', ...
	               'parent', QmatNMR.Ph, ...
                       'units', 'pixels', ...
                       'Position', [ 10 355 200  30], ...
                       'String', 'General Options :', ...
                       'BackgroundColor', QmatNMR.ColorScheme.Button12Back, ...
                       'ForegroundColor', QmatNMR.ColorScheme.Button12Fore, ...
                       'HorizontalALignment', 'left');

	PrintBut2  = uicontrol('Style', 'Check', ...
	               'parent', QmatNMR.Ph, ...
                       'units', 'pixels', ...
                       'Position', [ 30 335  90  25], ...
                       'String', PData6, ...
                       'value', 1, ...
                       'BackgroundColor', QmatNMR.ColorScheme.Button1Back, ...
                       'ForegroundColor', QmatNMR.ColorScheme.Button1Fore, ...
                       'Callback', 'matprint(2);');

	PrintBut3  = uicontrol('Style', 'Popup', ...
	               'parent', QmatNMR.Ph, ...
                       'units', 'pixels', ...
                       'Position', [220 335 180  25], ...
                       'String', PData5, ...
                       'Value', 1, ...
                       'BackgroundColor', QmatNMR.ColorScheme.Button1Back, ...
                       'ForegroundColor', QmatNMR.ColorScheme.Button1Fore, ...
                       'Callback', 'matprint(3);');

	PrintBut15 = uicontrol('Style', 'Popup', ...
	               'parent', QmatNMR.Ph, ...
                       'units', 'pixels', ...
                       'Position', [120 335 100  25], ...
                       'String', PData7, ...
                       'value', QmatNMR.PaperOrientation, ...
                       'BackgroundColor', QmatNMR.ColorScheme.Button1Back, ...
                       'ForegroundColor', QmatNMR.ColorScheme.Button1Fore, ...
                       'Callback', 'matprint(-1);');

	PrintBut16 = uicontrol('Style', 'Popup', ...
	               'parent', QmatNMR.Ph, ...
                       'units', 'pixels', ...
                       'Position', [120 310 100  25], ...
                       'String', PData8, ...
                       'Value', QmatNMR.PaperSize, ...
                       'BackgroundColor', QmatNMR.ColorScheme.Button1Back, ...
                       'ForegroundColor', QmatNMR.ColorScheme.Button1Fore, ...
                       'Callback', 'matprint(-2);');

	PrintBut17 = uicontrol('Style', 'Check', ...
	               'parent', QmatNMR.Ph, ...
                       'units', 'pixels', ...
                       'Position', [220 310 180  25], ...
                       'String', 'Enforce WYSIWYG', ...
                       'BackgroundColor', QmatNMR.ColorScheme.Button1Back, ...
                       'ForegroundColor', QmatNMR.ColorScheme.Button1Fore, ...
                       'value', 1, ...
                       'Callback', 'matprint(22);');



	%
	% Devices :
	%

	PrintText3 = uicontrol('Style', 'Text', ...
	               'parent', QmatNMR.Ph, ...
                       'units', 'pixels', ...
                       'Position', [405 355  65  30], ...
                       'String', 'Devices :', ...
                       'BackgroundColor', QmatNMR.ColorScheme.Button12Back, ...
                       'ForegroundColor', QmatNMR.ColorScheme.Button12Fore, ...
                       'HorizontalALignment', 'Left');

	PrintBut4  = uicontrol('Style', 'Popup', ...
	               'parent', QmatNMR.Ph, ...
                       'units', 'pixels', ...
                       'Position', [470 365 120  20], ...
                       'String', PData1, ...
                       'Value', 1, ...
                       'Callback', 'matprint(4);', ...
                       'BackgroundColor', QmatNMR.ColorScheme.Button1Back, ...
                       'ForegroundColor', QmatNMR.ColorScheme.Button1Fore, ...
                       'HorizontalALignment', 'Left');

	PrintBut5  = uicontrol('Style', 'Popup', ...
	               'parent', QmatNMR.Ph, ...
                       'units', 'pixels', ...
                       'Position', [470 344 120  20], ...
                       'String', PData3, ...
                       'Value', 1, ...
                       'Callback', 'matprint(5);', ...
                       'BackgroundColor', QmatNMR.ColorScheme.Button1Back, ...
                       'ForegroundColor', QmatNMR.ColorScheme.Button1Fore, ...
                       'HorizontalALignment', 'Left');

	PrintBut6  = uicontrol('Style', 'Popup', ...
	               'parent', QmatNMR.Ph, ...
                       'units', 'pixels', ...
                       'Position', [470 323 120  20], ...
                       'String', PData2, ...
                       'Value', 1, ...
                       'Callback', 'matprint(6);', ...
                       'BackgroundColor', QmatNMR.ColorScheme.Button1Back, ...
                       'ForegroundColor', QmatNMR.ColorScheme.Button1Fore, ...
                       'HorizontalALignment', 'Left');

	PrintBut13  = uicontrol('Style', 'Popup', ...
	               'parent', QmatNMR.Ph, ...
                       'units', 'pixels', ...
                       'Position', [470 302 120  20], ...
                       'String', PData4, ...
                       'Value', 1, ...
                       'Callback', 'matprint(13);', ...
                       'BackgroundColor', QmatNMR.ColorScheme.Button1Back, ...
                       'ForegroundColor', QmatNMR.ColorScheme.Button1Fore, ...
                       'HorizontalALignment', 'Left');


	%
	% Postscript Options :
	%

	PrintText4 = uicontrol('Style', 'Text', ...
	               'parent', QmatNMR.Ph, ...
                       'units', 'pixels', ...
                       'Position', [ 10 250 200  30], ...
                       'String', 'Postscript Options :', ...
                       'BackgroundColor', QmatNMR.ColorScheme.Button12Back, ...
                       'ForegroundColor', QmatNMR.ColorScheme.Button12Fore, ...
                       'HorizontalALignment', 'Left');

	PrintBut7  = uicontrol('Style', 'Check', ...
	               'parent', QmatNMR.Ph, ...
                       'units', 'pixels', ...
                       'Position', [ 30 230 120 25], ...
                       'String', '-loose', ...
                       'Value', 0, ...
                       'BackgroundColor', QmatNMR.ColorScheme.Button1Back, ...
                       'ForegroundColor', QmatNMR.ColorScheme.Button1Fore, ...
                       'Callback', 'matprint(7);');

	PrintBut8  = uicontrol('Style', 'Check', ...
	               'parent', QmatNMR.Ph, ...
                       'units', 'pixels', ...
                       'Position', [ 30 205 120 25], ...
                       'String', '-append', ...
                       'Value', 0, ...
                       'BackgroundColor', QmatNMR.ColorScheme.Button1Back, ...
                       'ForegroundColor', QmatNMR.ColorScheme.Button1Fore, ...
                       'Callback', 'matprint(8);');


	PrintBut9  = uicontrol('Style', 'Check', ...
	               'parent', QmatNMR.Ph, ...
                       'units', 'pixels', ...
                       'Position', [ 30 180 120 25], ...
                       'String', '-tiff', ...
                       'Value', 0, ...
                       'BackgroundColor', QmatNMR.ColorScheme.Button1Back, ...
                       'ForegroundColor', QmatNMR.ColorScheme.Button1Fore, ...
                       'Callback', 'matprint(9);');

	PrintBut10 = uicontrol('Style', 'Check', ...
	               'parent', QmatNMR.Ph, ...
                       'units', 'pixels', ...
                       'Position', [ 30 155 120 25], ...
                       'String', '-cmyk', ...
                       'Value', 0, ...
                       'BackgroundColor', QmatNMR.ColorScheme.Button1Back, ...
                       'ForegroundColor', QmatNMR.ColorScheme.Button1Fore, ...
                       'Callback', 'matprint(10);');

	PrintBut11 = uicontrol('Style', 'Check', ...
	               'parent', QmatNMR.Ph, ...
                       'units', 'pixels', ...
                       'Position', [ 30 130 120 25], ...
                       'String', '-adobecset', ...
                       'Value', 0, ...
                       'BackgroundColor', QmatNMR.ColorScheme.Button1Back, ...
                       'ForegroundColor', QmatNMR.ColorScheme.Button1Fore, ...
                       'Callback', 'matprint(11);');

	PrintText5 = uicontrol('Style', 'Text', ...
	               'parent', QmatNMR.Ph, ...
                       'units', 'pixels', ...
                       'Position', [150 230 150  25], ...
                       'String', 'Resolution (dpi) :', ...
                       'BackgroundColor', QmatNMR.ColorScheme.Button12Back, ...
                       'ForegroundColor', QmatNMR.ColorScheme.Button12Fore, ...
                       'HorizontalALignment', 'Left');

	PrintBut12 = uicontrol('Style', 'Edit', ...		%string for resolution
	               'parent', QmatNMR.Ph, ...
                       'units', 'pixels', ...
                       'Position', [170 210 100 25], ...
                       'String', '400', ...
                       'BackgroundColor', QmatNMR.ColorScheme.Button12Back, ...
                       'ForegroundColor', QmatNMR.ColorScheme.Button12Fore, ...
                       'Callback', 'matprint(12);');

	%
	% Windows options :
	%

	PrintText6 = uicontrol('Style', 'Text', ...
	               'parent', QmatNMR.Ph, ...
                       'units', 'pixels', ...
                       'Position', [330 250 150  30], ...
                       'String', 'Windows Options :', ...
                       'BackgroundColor', QmatNMR.ColorScheme.Button12Back, ...
                       'ForegroundColor', QmatNMR.ColorScheme.Button12Fore, ...
                       'HorizontalALignment', 'Left');

	PrintBut14 = uicontrol('Style', 'Check', ...
	               'parent', QmatNMR.Ph, ...
                       'units', 'pixels', ...
                       'Position', [360 230 100 25], ...
                       'String', '-v', ...
                       'BackgroundColor', QmatNMR.ColorScheme.Button1Back, ...
                       'ForegroundColor', QmatNMR.ColorScheme.Button1Fore, ...
                       'Value', 0);

	%Turn Postscript functions off by default
	%
	set(PrintBut7 , 'enable', 'off');
	set(PrintBut8 , 'enable', 'off');
	set(PrintBut9 , 'enable', 'off');
	set(PrintBut10, 'enable', 'off');
	set(PrintBut11, 'enable', 'off');
	set(PrintBut12, 'enable', 'off');


	%Last variable that will be written into the userdata of the figure window
	%
	PDevice = 0;


elseif Param == -1		%Change paper orientation
  QmatNMR.PaperOrientation = get(PrintBut15, 'value');


elseif Param == -2		%Change paper type
  QmatNMR.PaperSize = get(PrintBut16, 'value');


elseif Param == 4		%Postscript devices
  if (get(PrintBut4, 'value') > 1)	%a postscript device was chosen. Turn all other devices off
    set(PrintBut5 , 'value', 1);
    set(PrintBut6 , 'value', 1);
    set(PrintBut13, 'value', 1);
    set(PrintBut7 , 'enable', 'on');
    set(PrintBut8 , 'enable', 'on');
    set(PrintBut9 , 'enable', 'on');
    set(PrintBut10, 'enable', 'on');
    set(PrintBut11, 'enable', 'on');
    set(PrintBut12, 'enable', 'on');
    PDevice = 1;

  else
    set(PrintBut7 , 'enable', 'off');
    set(PrintBut8 , 'enable', 'off');
    set(PrintBut9 , 'enable', 'off');
    set(PrintBut10, 'enable', 'off');
    set(PrintBut11, 'enable', 'off');
    set(PrintBut12, 'enable', 'off');
    if PDevice == 1
      PDevice = 0;
    end
  end

elseif Param == 5		%Ghostscript devices
  if get(PrintBut5, 'value') > 1	%a ghostscript device was chosen. Turn all other devices off
    set(PrintBut4 , 'value', 1);
    set(PrintBut6 , 'value', 1);
    set(PrintBut13, 'value', 1);
    set(PrintBut7 , 'enable', 'off');
    set(PrintBut8 , 'enable', 'off');
    set(PrintBut9 , 'enable', 'off');
    set(PrintBut10, 'enable', 'off');
    set(PrintBut11, 'enable', 'off');
    set(PrintBut12, 'enable', 'on');
    PDevice = 2;
  else
    if PDevice == 2
      PDevice = 0;
    end
  end

elseif Param == 6		%Other devices
  if get(PrintBut6, 'value') > 1	%some other device type was chosen. Turn all other devices off
    set(PrintBut4 , 'value', 1);
    set(PrintBut5 , 'value', 1);
    set(PrintBut13, 'value', 1);
    set(PrintBut7 , 'enable', 'off');
    set(PrintBut8 , 'enable', 'off');
    set(PrintBut9 , 'enable', 'off');
    set(PrintBut10, 'enable', 'off');
    set(PrintBut11, 'enable', 'off');

    QTEMP = deblank(PData2(get(PrintBut6, 'value'), :));	%if jpeg or tiff then leave resolution on
    if (WYSIWYGwanted)
      set(PrintBut12, 'String', '0', 'enable', 'off');
    else
      if (strcmp(QTEMP, '-dtiff') | strcmp(QTEMP, '-djpeg') | strcmp(QTEMP, '-dpict') | strcmp(QTEMP, '-dill') | strcmp(QTEMP, '-dpng'))
        set(PrintBut12, 'enable', 'on');
      else
        set(PrintBut12, 'enable', 'off');
      end
    end
    PDevice = 3;
  else
    if PDevice == 3
      PDevice = 0;
    end
  end


elseif Param == 13		%Windows devices
  if get(PrintBut13, 'value') > 1	%some other device type was chosen. Turn all other devices off
    set(PrintBut4 , 'value', 1);
    set(PrintBut5 , 'value', 1);
    set(PrintBut6 , 'value', 1);
    set(PrintBut7 , 'enable', 'off');
    set(PrintBut8 , 'enable', 'off');
    set(PrintBut9 , 'enable', 'off');
    set(PrintBut10, 'enable', 'off');
    set(PrintBut11, 'enable', 'off');
    set(PrintBut12, 'enable', 'off');
    PDevice = 4;
  else
    if PDevice == 4
      PDevice = 0;
    end
  end


elseif (Param == -98)		%hide the matprint window from view

				%make the matprint window handle invisible
  set(QmatNMR.Ph, 'visible', 'off');

  				%set current figure pointer to other window
  figure(HandleOfPrintFigure);


elseif (Param == -99)		%close the matprint window

				%make the matprint window handle invisible
  set(QmatNMR.Ph, 'handlevisibility', 'off');

  				%the matNMR contour and mesher window have multiple plots and the 'selected' property of the current axis
				%has to be switched off before printing if one doesn't want to see the selection box in the printed
				%plot. Now turn it back on!
  if strcmp(get(HandleOfPrintFigure, 'tag'), '2D/3D Viewer')
    set(gca, 'selected', 'on');
  end

				%now refind the matprint window and delete it
  set(0, 'showhiddenhandles', 'on');
  delete(QmatNMR.Ph);
  set(0, 'showhiddenhandles', 'off');

  clear P*
  disp('Printing menu closed ...');
  return
end


%
%A button has been changed, now update the print command in the window
%
if (Param > 1)		%Don't change the print command when the user adds a file name or when the print button is pushed !
	%
	% Update the plotcommand in the edit button
	%


	%
	%First we try to determine what the user has added to the command line. This assumes
	%that nothing has been changed in the part that was added by matNMR. If something
	%was changed then the user-added changes will be lost! Else, we determine the
	%user-added part and append it to the end of the updated string
	%
	CurrentStringInWindow = get(PrintBut1, 'String');
	if (findstr(CurrentStringInWindow, OldPrintString) == 1)
	  UserAddedStringPart = CurrentStringInWindow(1+length(OldPrintString):end);
	  %now take away all spaces at the beginning and end
	  UserAddedStringPart = deblank(fliplr(deblank(fliplr(UserAddedStringPart))));

	else
	  UserAddedStringPart = 'FILENAME';
	end




	%
        %renderer more. If auto is chosen we use the mode from the window that needs to be printed,
        %unless we're working on a Windows machine and the renderer has been set to zbuffer because of
        %a MATLAB 7 bug that yields a bad colorbar in painters mode. For printing the painters mode works
        %correctly, I believe.
	%
        if (get(PrintBut3, 'value') == 1) 	%auto
          PComm1 = ['-' lower(get(HandleOfPrintFigure, 'renderer'))];

          %for Windows we check whether there is a need to have zbuffer instead of painters
          if strcmp(lower(get(HandleOfPrintFigure, 'renderer')), 'zbuffer')
            if isempty(findobj(allchild(HandleOfPrintFigure), 'type', 'surface'))
              PComm1 = '-painters';
            end
          end
        else
	  PComm1 = PData5(get(PrintBut3, 'value'), :);
        end


	%
        %-noui
	%
	if get(PrintBut2, 'value');
	  PComm2 = '-noui';
	else;
	  PComm2 = '';
	end;

	%
        %Devices
	%
	if PDevice == 1	%Postscript devices
	  PComm3 = PData1(get(PrintBut4, 'value'), :);	%device name

	  if get(PrintBut7, 'value')
	    PComm4 = ' -loose';				%-loose
	  else
	    PComm4 = '';
	  end

	  if get(PrintBut8, 'value')
	    PComm5 = ' -append';			%-append
	  else
	    PComm5 = '';
	  end

	  if get(PrintBut9, 'value')
	    PComm6 = ' -tiff';				%-epsi = tiff preview
	  else
	    PComm6 = '';
	  end

	  if get(PrintBut10, 'value')
	    PComm7 = ' -cmyk';				%-cmyk
	  else
	    PComm7 = '';
	  end

	  if get(PrintBut11, 'value')
	    PComm8 = ' -adobecset';			%-adobecset
	  else
	    PComm8 = '';
	  end

	  PComm9 = [' -r' num2str(get(PrintBut12, 'String'))];		%Resolution

	else
	  PComm4 = '';  PComm5 = '';  PComm6 = '';
	  PComm7 = '';  PComm8 = '';  PComm9 = '';

	  if PDevice == 2		%ghostscript devices
	    PComm3 = PData3(get(PrintBut5, 'value'), :);

            PComm4 = [' -r' num2str(get(PrintBut12, 'String'))];	%Resolution

	  elseif PDevice == 3		%other devices
	    PComm3 = deblank(PData2(get(PrintBut6, 'value'), :));

            QTEMP = deblank(PData2(get(PrintBut6, 'value'), :));	%if jpeg or tiff then leave resolution on, except when WYSIWYG behaviour is wanted
            if (WYSIWYGwanted)
              set(PrintBut12, 'String', '0', 'enable', 'off');
              PComm4 = ' -r0';
            else
              set(PrintBut12, 'enable', 'on');
              if (strcmp(QTEMP, '-dtiff') | strcmp(QTEMP, '-djpeg') | strcmp(QTEMP, '-dpict') | strcmp(QTEMP, '-dill') | strcmp(QTEMP, '-dpng'))
                PComm4 = [' -r' get(PrintBut12, 'String')];	%Resolution
	      end
            end

	  elseif PDevice == 4
	    PComm3 = deblank(PData4(get(PrintBut13, 'value'), :));
	  else
	    PComm3 = '';
	  end
	end

	%
        %-v option for windows users
	%
	if get(PrintBut14, 'value')
	  PComm10 = ' -v';			%-v
	else
	  PComm10 = '';
	end


	%
	%Now update the command line in the edit window, including the user-added part
	%
	if PDevice == 1
	  PrintString = ['print -f' num2str(HandleOfPrintFigure) ' ' PComm1 ' ' PComm2 ' ' PComm4 ' ' PComm5 ' ' PComm6 ' ' PComm7 ' ' PComm8 ' ' PComm9 ' ' PComm10 ' ' PComm3 ' '];
	else
          if strcmp(PComm3, '-P')
            PrintString = ['print -f' num2str(HandleOfPrintFigure) ' ' PComm1 ' ' PComm2 ' ' PComm10 ' ' PComm4 ' ' PComm3];
          else
            PrintString = ['print -f' num2str(HandleOfPrintFigure) ' ' PComm1 ' ' PComm2 ' ' PComm10 ' ' PComm4 ' ' PComm3 ' '];
          end
	end


	%
	%remove double spaces
	%
        PrintStringTotal = [PrintString UserAddedStringPart];
	QTEMP0 = findstr(PrintString, ' ');
	QTEMP1 = find(diff(QTEMP0) == 1);
	for QTEMP3=length(QTEMP1):-1:1
	  PrintString(QTEMP0(QTEMP1(QTEMP3))) = '';
	end


	%
	%update the string in the edit button
	%
	set(PrintBut1, 'String', [PrintString UserAddedStringPart]);


	%
	%Store the handles and the printstring in the userdata of the matprint figure window
	%
	ButtonList = [PrintPrint PrintBut1 PrintBut2 PrintBut3 PrintBut4 PrintBut5 PrintBut6 PrintBut7 PrintBut8 PrintBut9 ...
	      		PrintBut10 PrintBut11 PrintBut12 PrintBut13 PrintBut14 PrintBut15 PrintBut16 PrintBut17 ...
	      		PrintText1 PrintText2 PrintText3 PrintText4 PrintText5 PrintText6 PDevice];
        UserData.ButtonHandles = ButtonList;
	UserData.PrintString = PrintString;
	set(QmatNMR.Ph, 'userdata', UserData);
end







if (Param == 0)			%Perform print action
  watch;		%change mouse pointer to watch in the matprint window
  ShowHiddenHandles = get(0, 'showhiddenhandles');
  set(QmatNMR.Ph, 'handlevisibility', 'off');
  PrintString = fliplr(deblank(fliplr(deblank(get(PrintBut1, 'String')))));



%
%remember the position of the window that needs to be printed, so that it can be restored afterwards
%
  OrigPosition = get(HandleOfPrintFigure, 'position');



%
%set the paper type and orientation to the value that is specified. Remember the current
%values though to set them back after printing is finished!!
%
  QTEMP8 = get(HandleOfPrintFigure, 'paperorientation');
  QTEMP9 = get(HandleOfPrintFigure, 'papertype');
  set(HandleOfPrintFigure, 'paperorientation', deblank(PData7(QmatNMR.PaperOrientation, :)));
  set(HandleOfPrintFigure, 'papertype', deblank(PData8(QmatNMR.PaperSize, :)));



%
%check the file name if necessary (to avoid crashing of matNMR: usually when the print
%command cannot finish properly, the window must be closed)
%
  QTEMP1 = findstr(PrintString, ' ');
  QTEMP2 = PrintString(QTEMP1(length(QTEMP1))+1:length(PrintString));
  if (length(QTEMP2)<2)
    fid = fopen(QTEMP2, 'w');
    if (fid > 0)
      fclose(fid);

    else
      error('matNMR ERROR: Unable to open file. Please check for writing errors.');
    end

  else
    if ~(QTEMP2(1:2) == '-P')
      fid = fopen(QTEMP2, 'w');
      if (fid > 0)
        fclose(fid);

      else
        error('matNMR ERROR: Unable to open file. Please check for writing errors.');
      end
    end
  end

  if (WYSIWYGwanted)
  %
  %Now we make the window such that we have true WYSIWYG behaviour while printing
  %
    %
    %old contains all property values before printing (they will be restored after printing!)
    %
    old.objs = {};
    old.prop = {};
    old.values = {};

    %
    %first we lock the axis labels, tick marks, etc
    %
    set(0, 'showhiddenhandles', 'on');
    allLines  = findall(HandleOfPrintFigure, 'type', 'line');
    allText   = findall(HandleOfPrintFigure, 'type', 'text');
    allAxes   = findall(HandleOfPrintFigure, 'type', 'axes');
    allImages = findall(HandleOfPrintFigure, 'type', 'image');
    allLights = findall(HandleOfPrintFigure, 'type', 'light');
    allPatch  = findall(HandleOfPrintFigure, 'type', 'patch');
    allSurf   = findall(HandleOfPrintFigure, 'type', 'surface');
    allRect   = findall(HandleOfPrintFigure, 'type', 'rectangle');
    allFont   = [allText; allAxes];
    allColor  = [allLines; allText; allAxes; allLights];
    allMarker = [allLines; allPatch; allSurf];
    allEdge   = [allPatch; allSurf];
    allCData  = [allImages; allPatch; allSurf];


    %
    %Set all modes to manual as far as possible to make sure MATLAB doesn't change them
    %for printing
    %
    old = LocalManualAxesMode(old, allAxes, 'TickMode');
    old = LocalManualAxesMode(old, allAxes, 'TickLabelMode');
    old = LocalManualAxesMode(old, allAxes, 'LimMode');


    %
    %Perform a check on the length of vectors containing the tick positions and labels. If these
    %are NOT equal then Matlab generally screws up the plot (not on the screen). A warning is given
    %to the user but for now no action is taken
    %
    xticklabel = get(allAxes, 'xticklabel');
    xtick = get(allAxes, 'xtick');
    if iscell(xtick)
      for tel=1:size(xtick, 1)
        viewpoint = get(allAxes(tel), 'view');
        if (mod(viewpoint, 180) ~= [90, 0])
          xticktmp = cell2mat(xtick(tel));
          xticklabeltmp = cell2mat(xticklabel(tel));
          
          if (size(xticklabeltmp, 1)>0) & (size(xticklabeltmp, 1) ~= size(xticktmp, 2))
            beep
            disp(' ');
            disp('matNMR NOTICE: the lengths of some of the tick position vectors and tick label vectors are unequal (xtick), which may cause problems during printing!');
            fprintf(1, '               (%d tick positions, %d tick labels)\n', size(xticktmp, 2), size(xticklabeltmp, 1));
          end
        end
      end

    else
      viewpoint = get(allAxes, 'view');
      if (mod(viewpoint, 180) ~= [90, 0])
        if (size(xticklabel, 1)>0) & (size(xticklabel, 1) ~= size(xtick, 2))
          beep
          disp(' ');
          disp('matNMR NOTICE: the lengths of some of the tick position vectors and tick label vectors are unequal (xtick), which may cause problems during printing!');
          fprintf(1, '               (%d tick positions, %d tick labels)\n', size(xtick, 2), size(xticklabel, 1));
        end
      end
    end

    yticklabel = get(allAxes, 'yticklabel');
    ytick = get(allAxes, 'ytick');
    if iscell(ytick)
      for tel=1:size(ytick, 1)
        viewpoint = get(allAxes(tel), 'view');
        if (mod(viewpoint, 180) ~= [0, 0])
          yticktmp = cell2mat(ytick(tel));
          yticklabeltmp = cell2mat(yticklabel(tel));
        
          if (size(yticklabeltmp, 1)>0) & (size(yticklabeltmp, 1) ~= size(yticktmp, 2))
            beep
            disp(' ');
            disp('matNMR NOTICE: the lengths of some of the tick position vectors and tick label vectors are unequal (ytick), which may cause problems during printing!');
            fprintf(1, '               (%d tick positions, %d tick labels)\n', size(yticktmp, 2), size(yticklabeltmp, 1));
          end
        end
      end

    else
      viewpoint = get(allAxes, 'view');
      if (mod(viewpoint, 180) ~= [0, 0])
        if (size(yticklabel, 1)>0) & (size(yticklabel, 1) ~= size(ytick, 2))
          beep
          disp(' ');
          disp('matNMR NOTICE: the lengths of some of the tick position vectors and tick label vectors are unequal (ytick), which may cause problems during printing!');
          fprintf(1, '               (%d tick positions, %d tick labels)\n', size(ytick, 2), size(yticklabel, 1));
        end
      end
    end

    %
    %for zticks we check whether the view is 2D or 3D
    %
    zticklabel = get(allAxes, 'zticklabel');
    ztick = get(allAxes, 'ztick');
    if iscell(ztick)
      for tel=1:size(ztick, 1)
        viewpoint = get(allAxes(tel), 'view');
        if (mod(viewpoint(2), 180) ~= 90)
          zticktmp = cell2mat(ztick(tel));
          zticklabeltmp = cell2mat(zticklabel(tel));
          
          if (size(zticklabeltmp, 1)>0) & (size(zticklabeltmp, 1) ~= size(zticktmp, 2))
            beep
            disp(' ');
            disp('matNMR NOTICE: the lengths of some of the tick position vectors and tick label vectors are unequal (ztick), which may cause problems during printing!');
            fprintf(1, '               (%d tick positions, %d tick labels)\n', size(zticktmp, 2), size(zticklabeltmp, 1));
          end
        end
      end

    else
      viewpoint = get(allAxes, 'view');
      if (mod(viewpoint(2), 180) ~= 90)
        if (size(zticklabel, 1)>0) & (size(zticklabel, 1) ~= size(ztick, 2))
          beep
          disp(' ');
          disp('matNMR NOTICE: the lengths of some of the tick position vectors and tick label vectors are unequal (ztick), which may cause problems during printing!');
          fprintf(1, '               (%d tick positions, %d tick labels)\n', size(ztick, 2), size(zticklabel, 1));
        end
      end
    end



    %
    %Then we let MATLAB determine the proper paper position etc.
    %
    figurePaperUnits = get(HandleOfPrintFigure, 'PaperUnits');
    oldFigureUnits = get(HandleOfPrintFigure, 'Units');
    oldFigPos = get(HandleOfPrintFigure,'Position');

    set(HandleOfPrintFigure, 'Units', 'centimeters', 'PaperUnits', 'centimeters');
    figPos = get(HandleOfPrintFigure,'Position');
    papersize = get(HandleOfPrintFigure, 'papersize');		%real paper size
    refsize = figPos(3:4);					%figure window size in same units as the paper size
    opts.width = 0.85*papersize(1);
    opts.height = 0.85*papersize(2);

    wscale = opts.width/refsize(1);
    hscale = opts.height/refsize(2);
    sizescale = min(wscale,hscale);
    set(HandleOfPrintFigure, 'Units', oldFigureUnits, 'PaperUnits', figurePaperUnits);

    set(HandleOfPrintFigure, 'visible', 'off');
    if (sizescale < 1)		%rescale the window and all its objects IF NECESSARY
      %
      %Write out warning message because MATLAB doesn't rescale properly
      %
      disp('  ');
      disp('matNMR NOTICE: The absolute window size is too big!! For WYSIWYG behaviour');
      if ((wscale < 1) & (hscale >= 1))
        disp(['matNMR NOTICE: the width must be made smaller by at least ' num2str(100*(1-sizescale)) '%.']);

      elseif ((hscale < 1) & (wscale >= 1))
        disp(['matNMR NOTICE: the height must be made smaller by at least ' num2str(100*(1-sizescale)) '%.']);

      else
        disp(['matNMR NOTICE: the width and height must be made smaller by at least ' num2str(100*(1-hscale)) '% and ' num2str(100*(1-wscale)) '% resp.']);
      end
      disp('matNMR NOTICE: As MATLAB doesn''t scale the fonts properly and some bitmap printing');
      disp('matNMR NOTICE: devices (like tiff) are buggy for anything but screen resolution it may be');
      disp('matNMR NOTICE: better to resize the window yourself instead of letting matNMR do it.');
      disp('  ');


      %
      %Reset units of the figure window
      %
      set(HandleOfPrintFigure, 'Units', figurePaperUnits);


      %
      %Axes
      %
      oldaunits = LocalGetAsCell(allAxes, 'Units');
      set(allAxes,'units','normalized');
      old = LocalPushOldData(old, allAxes, {'Units'}, oldaunits);

      %
      %Fonts
      %
      oldfontunits = LocalGetAsCell(allFont,'FontUnits');
      set(allFont,'FontUnits','normalized');
      old = LocalPushOldData(old, allFont, {'FontUnits'}, oldfontunits);

      oldfontsizes = LocalGetAsCell(allFont,'FontSize');
      old = LocalPushOldData(old, allFont, {'FontSize'}, oldfontsizes);

      %
      %Window
      %
      QTEMP7 = get(HandleOfPrintFigure, 'position');
      set(HandleOfPrintFigure, 'position', [QTEMP7(1:2) sizescale*QTEMP7(3:4)]);
    end


    %
    %Whether we need to rescale or not, before we can print we must move all axes to the center
    %of the screen because else MATLAB produces all kinds of crap results. Alternatively I could
    %also take away all buttons from the main window and put them in separate panel windows ....
    %
    oldapositions = LocalGetAsCell(allAxes, 'Position');
    old = LocalPushOldData(old, allAxes, {'Position'}, oldapositions);
    QTEMP3 = [];
    for tel1=1:length(oldapositions)
      QTEMP3(tel1, :) = oldapositions{tel1};
    end

    %determine the total combined width of all axes in the figure window
    MinWidth  = min(QTEMP3(:, 1));
    MaxWidth  = max(QTEMP3(:, 1)+QTEMP3(:, 3));
    MinHeight = min(QTEMP3(:, 2));
    MaxHeight = max(QTEMP3(:, 2)+QTEMP3(:, 4));

    %and then determine the offsets from the center for each individual axis
    NewStartWidth  = (1-MaxWidth)/2;
    NewStartHeight = (1-MaxHeight)/2;
    DiffWidth  = NewStartWidth  - 0.9*MinWidth;
    DiffHeight = NewStartHeight - 0.9*MinHeight;

    %set the temporary positions for all axes.
    for tel1=1:length(allAxes)
      set(allAxes(tel1), 'position', [QTEMP3(tel1, 1)+DiffWidth QTEMP3(tel1, 2)+DiffHeight QTEMP3(tel1, 3:4)]);
    end


    %
    %The most important thing for WYSIWYG is that the paperpositionmode is set to auto.
    %As this is not done by default for matNMR (windows with buttons don't print nicely that way)
    %this will have to be changed now. Afterwards the previous settings will be restored.
    %
    old = LocalPushOldData(old, HandleOfPrintFigure, 'PaperPositionMode', ...
  			get(HandleOfPrintFigure,'PaperPositionMode'));
    old = LocalPushOldData(old, HandleOfPrintFigure, 'PaperPosition', ...
  			get(HandleOfPrintFigure,'PaperPosition'));

    set(HandleOfPrintFigure, 'PaperPositionMode', 'auto');
    set(HandleOfPrintFigure, 'Units', oldFigureUnits);

    drawnow
    set(HandleOfPrintFigure, 'visible', 'on');
  end


%
%Ready for printing --> GO!
%
  %
  %execute a warning message if a resolution other than 0 is asked for in case of bitmap output
  %since MATLAB doesn't handle the font sizes properly then.
  %
  QTEMP = deblank(PData2(get(PrintBut6, 'value'), :));	%if jpeg or tiff then leave resolution on
  if (strcmp(QTEMP, '-dtiff') | strcmp(QTEMP, '-djpeg') | strcmp(QTEMP, '-dpict') | strcmp(QTEMP, '-dill') | strcmp(QTEMP, '-dpng'))
    if (str2num(get(PrintBut12, 'String')) ~= 0)
      disp('  ');
      disp('matNMR WARNING: Bitmap output is generally distorted by Matlab for resolution larger than 0 (screen resolution)');
      disp('  ');
    end
  end

  set(0, 'showhiddenhandles', 'off');
  				%Matlab 5.2 weak spot .... patches cannot be printed in black and white without
				%setting the edgecolor to black, for a short period of time ....
  QTEMP1 = version;
  if (QTEMP1(1:3) == '5.2')
    if any([findstr(PrintString, ' -dps ') findstr(PrintString, ' -dps2 ') findstr(PrintString, ' -deps ') findstr(PrintString, ' -deps2 ') findstr(PrintString, ' -P')])
      set(findobj(HandleOfPrintFigure, 'type', 'patch'), 'edgecolor', 'w');
    end
  end
  
  
  eval(PrintString);
  disp('Current figure window printed ...');


  				%Matlab 5.2 weak spot .... patches cannot be printed in black and white without
				%setting the edgecolor to black, for a short period of time ....
  if (QTEMP1(1:3) == '5.2')
    if any([findstr(PrintString, ' -dps ') findstr(PrintString, ' -dps2 ') findstr(PrintString, ' -deps ') findstr(PrintString, ' -deps2 ') findstr(PrintString, ' -P')])
      set(findobj(HandleOfPrintFigure, 'type', 'patch'), 'edgecolor', 'flat');
    end
  end


%
%Finished printing, now restore the figure to normal
%
  if (WYSIWYGwanted)
    set(HandleOfPrintFigure, 'visible', 'off');

    %
    %Restore figure settings concerning WYSIWYG
    %
    if (sizescale < 1)
      set(HandleOfPrintFigure, 'Units', figurePaperUnits);
      set(HandleOfPrintFigure, 'position', QTEMP7);
      set(HandleOfPrintFigure, 'Units', oldFigureUnits);
    end

    for n=1:length(old.objs)
      if ~iscell(old.values{n}) & iscell(old.prop{n})
        old.values{n} = {old.values{n}};
      end
      set(old.objs{n}, old.prop{n}, old.values{n});
      
      %
      %this drawnow was inserted because without it Matlab did not return the font size properly.
      %Jacco, 23-02-2011
      %
      drawnow
    end
  end


  %the 2D/3D Viewer windows have multiple plots and the 'selected' property of the current axis
  %has to be switched off before printing if one doesn't want to see the selection box in the printed
  %plot. Now turn it back on!
  if strcmp(get(HandleOfPrintFigure, 'tag'), '2D/3D Viewer')
    set(gca, 'selected', 'on');
  end


  set(0, 'showhiddenhandles', 'on');


%
%restore the original paper type and orientation settings
%
  set(HandleOfPrintFigure, 'paperorientation', QTEMP8);
  set(HandleOfPrintFigure, 'papertype', QTEMP9);


%
%The setting of the coordinates is necessary because MATLAB is not able to keep its figure windows
%in the same position for some operations ....
%
  QmatNMR.Center = CenterOfScreen;				%The coordinates of the figure window
  PrintCoord = [QmatNMR.Center(1)-300 QmatNMR.Center(2)-100 600 400];

  set(QmatNMR.Ph, 'handlevisibility', 'on', 'visible', 'off', 'position', PrintCoord);
  set(0, 'showhiddenhandles', ShowHiddenHandles);
  Arrowhead;		%change mouse pointer to arrowhead in the matprint window
  figure(HandleOfPrintFigure);
  drawnow
  set(HandleOfPrintFigure, 'visible', 'on');

%
%finally we reset the position of the figure window to its original values until Matlab has done it correctly
%
  QTEMP1 = get(HandleOfPrintFigure, 'position');
  QTEMP11 = 0;
  while ((abs((OrigPosition(2) - QTEMP1(2))/OrigPosition(2)) > 0.05) & (QTEMP11 < 5))
    QTEMP1 = get(HandleOfPrintFigure, 'position');
    set(HandleOfPrintFigure, 'Position', OrigPosition);
    drawnow

    QTEMP11 = QTEMP11 + 1;
  end

  if (QTEMP11 == 5)
    disp('matNMR NOTICE: couldn''t position window correctly. Abandoning attempts ...');
  end
end











%
%  Local Functions
%
function outData = LocalManualAxesMode(old, allAxes, base)
  xs = ['X' base];
  ys = ['Y' base];
  zs = ['Z' base];
  oldXMode = LocalGetAsCell(allAxes,xs);
  oldYMode = LocalGetAsCell(allAxes,ys);
  oldZMode = LocalGetAsCell(allAxes,zs);
  old = LocalPushOldData(old, allAxes, {xs}, oldXMode);
  old = LocalPushOldData(old, allAxes, {ys}, oldYMode);
  old = LocalPushOldData(old, allAxes, {zs}, oldZMode);
  set(allAxes,xs,'manual');
  set(allAxes,ys,'manual');
  set(allAxes,zs,'manual');
  outData = old;

function outData = LocalPushOldData(inData, objs, prop, values)
  outData.objs = {objs, inData.objs{:}};
  outData.prop = {prop, inData.prop{:}};
  outData.values = {values, inData.values{:}};

function cellArray = LocalGetAsCell(fig,prop,allowemptycell);
  cellArray = get(fig,prop);
  if nargin < 3
    allowemptycell = 0;
  end
  if ~iscell(cellArray) & (allowemptycell | ~isempty(cellArray))
    cellArray = {cellArray};
  end
