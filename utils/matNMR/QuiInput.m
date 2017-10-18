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
function QuiInput(title, buttonList, callback, siz,  n1,Qii1,   n2,Qii2,   n3,Qii3,   n4,Qii4,   n5,Qii5,   n6,Qii6, ...
                                                     n7,Qii7,   n8,Qii8,   n9,Qii9,  n10,Qii10, n11,Qii11, n12,Qii12, ...
						    n13,Qii13, n14,Qii14, n15,Qii15, n16,Qii16, n17,Qii17, n18,Qii18)

%QmatNMR.uiInput     Display dialog box with buttons and optionally allow text entry.
%
% QuiInput(title, buttonNames, callback)
%    Display the title and buttons and return.  The callback is evaluated
%    when the user clicks a button, with the global variable QmatNMR.uiInputButton
%    set to the button number clicked on.  The names in buttonNames should
%    be separated by | characters.  The title may contain newline characters
%    (value 10) for multi-line text.
%
% QuiInput(title, buttonlist, callback, size)
%    As above, but you can specify the size of the displayed box as
%    [wide high].  If the size is [] the default size is used.
%    If siz is a scalar, it is the width; the default height is used.
%
% QuiInput(title, buttonlist, callback, size, 'name', 'init')
%    As above, but also display a text box for the user to edit.
%    'name' is the caption appearing above the edit box, and 'init'
%    is the initial value of the edit box.  Upon callback, the global
%    variable QmatNMR.uiInput1 has the edited string.
%
% QuiInput(title, buttonlist, callback, size, name1, init1, name2, init2, ...)
%    As above, but show two or more edit boxes with captions, with
%    successive values in QmatNMR.uiInput2, QmatNMR.uiInput3, QmatNMR.uiInput4.  Up to four edit
%    boxes can be handled.  If empty, the last init string may be omitted.
%
% Examples:
% QuiInput('Replace file?', 'OK|Cancel', 'mycallback')
% QuiInput('', 'OK|Cancel', 'mycallback', [], 'New scaling value', num2str(x))
% QuiInput('Size', 'OK|Yes|Why not', 'mycallback', [], 'Length','','Height', '')
%
% Written by Dave Mellinger, dkm1@cornell.edu .  This version 1/18/94.
%
%
%  adjusted for matNMR by Jacco van Beek
%    14-4-1997
%  and
%    8-12-1997 (KeyPressFcn of QmatNMR.uiInputFig changed such that <RETURN> inside the
%               figure window equals pushing the OK-button. Typing <ENTER> in one of
%               the edit-buttons does not equal pushing OK. This can be dangerous
%               because then it is no longer possible to move the mouse pointer
%               off the QmatNMR.uiInputFig unfortunately)
%
%    23-12-1997: To have the possibility of check buttons in this function I have added
%               the following: when a name starts with "&CK" a check button will be
%               generated. The init value must be 0 or 1. Any other number will result in
%               a 0, i.e. the button is switched off initially.
%
%    13-10-1998: Now also popup buttons are implemented into the function. Start the name
%       	with "&PO" and a popup will appear.
%
%    15-12-1998: A buttonname can now also be given when using popup buttons. After &PO the
%		name of the button is given followed by a '|'.
%
%    24-03-1999: Font sizes are set relative to the defaultUIFontsize
%
%    21-03-2003: Callbacks can now be specified for buttons by using "&CA" at the start of the
% 		name.
%
%    16-01-2004: A new button was added to the window which allows widening the window to the
% 		width of the screen. This is useful for long strings.
%
%    13-10-2004: A new optional check button has been implemented which is positioned next to
% 		the normal edit buttons. The variable connected to this button is the same as
% 		that of the edit button but then with an "a" appended to it: QmatNMR.uiInput1 ->
% 		QmatNMR.uiInput1a. This variable will be 0 if the check button is switched off, or 1
% 		when it is switched on. The functionality can be called by adding "&CB" to the
% 		the string BUT NOT AT THE START!, followed by either 0 or 1 to set the initial state.
% 		Depending on the value the corresponding button is enabled or disabled.
%
%

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

  QmatNMR.UIFontSize    = 12;
end


sep = 10;		% newline: separator character for successive lines

  nedit = floor((nargin - 3) / 2);
  if (nargin < 4), siz = [0 0]; end
  if (~length(siz)), siz = [0 0]; elseif (length(siz) == 1), siz = [siz 1]; end
  if (all(siz == [0 0])), siz = [400 1]; end	% MATLAB can't take [400 0]
  QmatNMR.uiInputCallback = callback;

  if (isfield(QmatNMR, 'uiInputFig')), if ~isempty(QmatNMR.uiInputFig), delete(QmatNMR.uiInputFig); end; end
  QmatNMR.uiInputFig = figure('Units', 'pixels', 'NumberTitle', 'off', ...
      'Position', [0 0 1 1], 'Color', QmatNMR.ColorScheme.Figure2Back, ...
      'Pointer', 'arrow', 'KeyPressFcn', 'QuiInput_3', ...
      'menubar', 'none', ...
      'tag', 'QmatNMR.uiInputWindow', 'CloseRequestFCN', 'delete(QmatNMR.uiInputFig); QmatNMR.uiInputFig=0;');

  QmatNMR.uiInputFigAxis = axes('visible', 'off', 'units', 'normalized', 'tag', 'QmatNMR.uiInputFigAxis', 'position', [0 0 1 1], 'units', 'pixels');

  bbot	 = 20;
  bhigh	 = 30;		% height of bottom buttons
  btop	 = 15;
  ebot	 = 0;
  ehigh	 = 24;		% height of user input boxes
  nbot	 =  8;		% space between message text and edit/check box
  nlhigh = 18;		% height of each line in name
  tbot	 = 10;
  tlhigh = 20;		% height of each line in title
  top	 = 5;
  deffontsize = QmatNMR.UIFontSize;

  bwide  = 80;
  bsep   = 20;
  tleft  = 15;
  eleft  = 25;
  eright = eleft;
  nleft  = eleft;


  % Create buttons.
  div = [0, find([buttonList,'|'] == '|')];
  nbut = length(div) - 1;
  btotw	 = nbut*bwide + (nbut-1)*bsep;
  left	 = (siz(1) - btotw) / 2 + (nbut-1)*(bwide + bsep);
  bot    = bbot;
  for Qii = nbut:-1:1
    uicontrol('Style', 'PushB', 'Units', 'pixels', ...
	'Position', [left bot bwide bhigh], ...
	'String', buttonList(div(Qii)+1 : div(Qii+1)-1), ...
	'Callback', ['QmatNMR.buttonList = ' num2str(Qii) '; QuiInput_2'], ...
	'parent', QmatNMR.uiInputFig, ...
	'backgroundcolor', QmatNMR.ColorScheme.Button1Back, ...
	'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
    left = left - bwide - bsep;
  end
  bot = bot + bhigh + btop;

  % Create edit boxes and names.
  ewide = siz(1) - eleft - eright;
  CallbacksNeeded = [];
  ExtraCheckButtonsNeeded = 0;
  QmatNMR.uiInputEdits = [];
  for Qii = nedit:-1:1			%Make all the buttons (nedit in total)
    s = num2str(Qii);
    bot = bot + ebot;
    if (nargin < 4 + Qii*2), eval(['Qii',s,' = '''';']); end

    ButtonValue = eval(['Qii',s]);
    ButtonName = eval(['n', s]);

    					%Create CHECK-button
    if ((length(ButtonName) > 3) & (ButtonName(1:3) == '&CK'))
      QTEMP2 = findstr(ButtonName, '&CB');	%check whether an additional check button was requested
      if ~isempty(QTEMP2)	%YES!
        QTEMP3 = 21;	%space needed for check button
	ExtraCheckButtonsNeeded = ExtraCheckButtonsNeeded + 1;
	ButtonValue2 = eval(ButtonName(QTEMP2(1)+3));	%index into QTEMP2 protects against multiple occurences of the &CBx code
	if ~ButtonValue2
          ButtonValue3 = 'off';
	else
          ButtonValue3 = 'on';
	end
        QmatNMR.uiInputEdits(nedit+ExtraCheckButtonsNeeded) = uicontrol('Style','Check','Value', ButtonValue2, 'String', ' ', ...
	  'Position',[eleft bot QTEMP3-1 ehigh], 'backgroundcolor', QmatNMR.ColorScheme.Button11Back, 'foregroundcolor', QmatNMR.ColorScheme.Button11Fore, 'FontName', 'Helvetica', ...
        'FontWeight', 'Bold', ...
          'parent', QmatNMR.uiInputFig, 'tag', [num2str(Qii) 'a'], 'callback', 'QuiInput_4');

	%delete the code string from the name
	ButtonName = [ButtonName(1:QTEMP2(1)-1) ButtonName(QTEMP2(1)+4:end)];	%index into QTEMP2 protects against multiple occurences of the &CBx code
      else
        QTEMP3 = 0;	%space needed for check button
        ButtonValue3 = 'on';
      end

      if ~ ((ButtonValue == 0) | (ButtonValue == 1))
        ButtonValue = 0;
      end

      QTEMP2 = findstr(ButtonName, '&CA');	%check whether a callback was asked for for this popup button.
      if isempty(QTEMP2)
						%no callback required
        QmatNMR.uiInputEdits(Qii) = uicontrol('Style','Check','Value', ButtonValue, 'String', ButtonName(4:length(ButtonName)), ...
	  'Position',[eleft+QTEMP3 bot ewide-QTEMP3 ehigh], 'backgroundcolor', QmatNMR.ColorScheme.Button11Back, 'foregroundcolor', QmatNMR.ColorScheme.Button11Fore, 'FontName', 'Helvetica', ...
        'FontWeight', 'Bold', ...
          'parent', QmatNMR.uiInputFig, 'tag', num2str(Qii), 'enable', ButtonValue3);
      else

        QTEMP4 = QTEMP2 - 1;			%callback is asked for
        QmatNMR.uiInputEdits(Qii) = uicontrol('Style','Check','Value', ButtonValue, 'String', ButtonName(4:QTEMP4), ...
	  'Position',[eleft+QTEMP3 bot ewide-QTEMP3 ehigh], 'backgroundcolor', QmatNMR.ColorScheme.Button11Back, 'foregroundcolor', QmatNMR.ColorScheme.Button11Fore, 'FontName', 'Helvetica', ...
        'FontWeight', 'Bold', ...
          'parent', QmatNMR.uiInputFig, 'tag', num2str(Qii), 'enable', ButtonValue3, 'callback', ButtonName(QTEMP4+4:length(ButtonName)));
	CallbacksNeeded = [CallbacksNeeded ';' ButtonName(QTEMP4+4:length(ButtonName))];
      end

      bot = bot + ehigh + nbot;
          
      t = uiMultiText(nleft, bot, ['-','Please Select :'], nlhigh, ...
	'Units', 'pixels', 'Color', QmatNMR.ColorScheme.Text3Fore, 'backgroundcolor', QmatNMR.ColorScheme.Text3Back, 'fontsize', deffontsize+1, 'FontName', 'Helvetica', ...
	'parent', QmatNMR.uiInputFigAxis, 'tag', [num2str(Qii) 't']);
      set(t, 'units', 'normalized');
      bot = bot + nlhigh*length(t);



					%create popup buttons
    elseif ((length(ButtonName) > 3) & (ButtonName(1:3) == '&PO'))
      QTEMP2 = findstr(ButtonName, '&CB');	%check whether an additional check button was requested
      if ~isempty(QTEMP2)	%YES!
        QTEMP3 = 21;	%space needed for check button
	ExtraCheckButtonsNeeded = ExtraCheckButtonsNeeded + 1;
	ButtonValue2 = eval(ButtonName(QTEMP2(1)+3));	%index into QTEMP2 protects against multiple occurences of the &CBx code
	if ~ButtonValue2
          ButtonValue3 = 'off';
	else
          ButtonValue3 = 'on';
	end
        QmatNMR.uiInputEdits(nedit+ExtraCheckButtonsNeeded) = uicontrol('Style','Check','Value', ButtonValue2, 'String', ' ', ...
	  'Position',[eleft bot QTEMP3-1 ehigh], 'backgroundcolor', QmatNMR.ColorScheme.Button11Back, 'foregroundcolor', QmatNMR.ColorScheme.Button11Fore, 'FontName', 'Helvetica', ...
        'FontWeight', 'Bold', ...
          'parent', QmatNMR.uiInputFig, 'tag', [num2str(Qii) 'a'], 'callback', 'QuiInput_4');

	%delete the code string from the name
	ButtonName = [ButtonName(1:QTEMP2(1)-1) ButtonName(QTEMP2(1)+4:end)];	%index into QTEMP2 protects against multiple occurences of the &CBx code
      else
        QTEMP3 = 0;	%space needed for check button
        ButtonValue3 = 'on';
      end

      QTEMP = findstr(ButtonName, '|');		%all text before the first separator forms the text button, everything
      if isempty(QTEMP)				%after it belongs to the popup button.
        QTEMP = 0;
      end

      QTEMP2 = findstr(ButtonName, '&CA');	%check whether a callback was asked for for this popup button.
      if isempty(QTEMP2)
						%no callback required
        QmatNMR.uiInputEdits(Qii) = uicontrol('Style','Popup','Value', ButtonValue, 'String', ButtonName((QTEMP(1)+1):length(ButtonName)), ...
	  'Position',[eleft+QTEMP3 bot ewide-QTEMP3 ehigh], 'backgroundcolor', QmatNMR.ColorScheme.Button11Back, 'foregroundcolor', QmatNMR.ColorScheme.Button11Fore, 'FontName', 'Helvetica', ...
        'FontWeight', 'Bold', ...
          'parent', QmatNMR.uiInputFig, 'tag', num2str(Qii), 'enable', ButtonValue3);

      else
        QTEMP4 = QTEMP2 - 1;			%callback is asked for
        QmatNMR.uiInputEdits(Qii) = uicontrol('Style','Popup','Value', ButtonValue, 'String', ButtonName((QTEMP(1)+1):QTEMP4), ...
	  'Position',[eleft+QTEMP3 bot ewide-QTEMP3 ehigh], 'backgroundcolor', QmatNMR.ColorScheme.Button11Back, 'foregroundcolor', QmatNMR.ColorScheme.Button11Fore, 'FontName', 'Helvetica', ...
        'FontWeight', 'Bold', ...
          'parent', QmatNMR.uiInputFig, 'tag', num2str(Qii), 'enable', ButtonValue3, 'callback', ButtonName(QTEMP4+4:length(ButtonName)));
	CallbacksNeeded = [CallbacksNeeded ';' ButtonName(QTEMP4+4:length(ButtonName))];
      end


      bot = bot + ehigh + nbot;
      t = uiMultiText(nleft, bot, ['-',ButtonName(4:(QTEMP(1)-1))], nlhigh, ...
	'Units', 'pixels', 'Color', QmatNMR.ColorScheme.Text3Fore, 'backgroundcolor', QmatNMR.ColorScheme.Text3Back, 'fontsize', deffontsize+1, 'FontName', 'Helvetica', ...
	'parent', QmatNMR.uiInputFigAxis, 'tag', [num2str(Qii) 't']);
      set(t, 'units', 'normalized');
      bot = bot + nlhigh*length(t);



    else				%Create normal EDIT-button
      QTEMP2 = findstr(ButtonName, '&CB');	%check whether an additional check button was requested
      if ~isempty(QTEMP2)	%YES!
        QTEMP3 = 21;	%space needed for check button
	ExtraCheckButtonsNeeded = ExtraCheckButtonsNeeded + 1;
	ButtonValue2 = eval(ButtonName(QTEMP2(1)+3));	%index into QTEMP2 protects against multiple occurences of the &CBx code
	if ~ButtonValue2
          ButtonValue3 = 'off';
	else
          ButtonValue3 = 'on';
	end
        QmatNMR.uiInputEdits(nedit+ExtraCheckButtonsNeeded) = uicontrol('Style','Check','Value', ButtonValue2, 'String', ' ', ...
	  'Position',[eleft bot QTEMP3-1 ehigh], 'backgroundcolor', QmatNMR.ColorScheme.Button11Back, 'foregroundcolor', QmatNMR.ColorScheme.Button11Fore, 'FontName', 'Helvetica', ...
        'FontWeight', 'Bold', ...
          'parent', QmatNMR.uiInputFig, 'tag', [num2str(Qii) 'a'], 'callback', 'QuiInput_4');

	%delete the code string from the name
	ButtonName = [ButtonName(1:QTEMP2(1)-1) ButtonName(QTEMP2(1)+4:end)];	%index into QTEMP2 protects against multiple occurences of the &CBx code
      else
        QTEMP3 = 0;	%space needed for check button
        ButtonValue3 = 'on';
      end

      QmatNMR.uiInputEdits(Qii) = uicontrol('Style','Edit','String', ButtonValue, ...
	'Position',[eleft+QTEMP3 bot ewide-QTEMP3 ehigh], 'backgroundcolor', QmatNMR.ColorScheme.Button11Back, 'foregroundcolor', QmatNMR.ColorScheme.Button11Fore, 'FontName', 'Helvetica', ...
        'FontWeight', 'Bold', ...
	'parent', QmatNMR.uiInputFig, 'tag', num2str(Qii), 'enable', ButtonValue3);

      bot = bot + ehigh + nbot;

      QTEMP2 = findstr(ButtonName, '&CA');	%check whether a callback was asked for for this popup button.
      if isempty(QTEMP2)			%no callback. normal text button
          t = uiMultiText(nleft, bot, ['-',ButtonName], nlhigh, ...
	  'Units', 'pixels', 'Color', QmatNMR.ColorScheme.Text3Fore, 'backgroundcolor', QmatNMR.ColorScheme.Text3Back, 'fontsize', deffontsize+1, 'FontName', 'Helvetica', ...
          'parent', QmatNMR.uiInputFigAxis, 'tag', [num2str(Qii) 't']);
        set(t, 'units', 'normalized');

      else					%callback so text for text button must be edited
        QTEMP3 = QTEMP2 - 1;
        set(QmatNMR.uiInputEdits(Qii), 'callback', ButtonName(QTEMP3+4:length(ButtonName)));
	CallbacksNeeded = [CallbacksNeeded ';' ButtonName(QTEMP3+4:length(ButtonName))];

        t = uiMultiText(nleft, bot, ['-',ButtonName(1:QTEMP3)], nlhigh, ...
	  'Units', 'pixels', 'Color', QmatNMR.ColorScheme.Text3Fore, 'backgroundcolor', QmatNMR.ColorScheme.Text3Back, 'fontsize', deffontsize+1, 'FontName', 'Helvetica', ...
          'parent', QmatNMR.uiInputFigAxis, 'tag', [num2str(Qii) 't']);
        set(t, 'units', 'normalized');
      end

      bot = bot + nlhigh*length(t);
    end
  end


  %execute all user-defined callbacks at least once
  if ~isempty(CallbacksNeeded)
    eval(CallbacksNeeded)
  end


  % Create title box.
  if length(title)
    bot = bot + tbot;

    t = uiMultiText(tleft, bot, ['-', title], tlhigh, 'Units', 'pixels', ...
	'Color', QmatNMR.ColorScheme.Text3Fore, 'backgroundcolor', QmatNMR.ColorScheme.Text3Back, ...
        'fontsize', deffontsize+3, 'FontName', 'Helvetica', ...
	'parent', QmatNMR.uiInputFigAxis);
    set(t, 'units', 'normalized');

    bot = bot + tlhigh * length(t);
  end
  bot = bot + top;

  % Put figure at correct position.
  set(0, 'Units', 'pixels');  ss = get(0, 'ScreenSize');
  if (siz(2) < 2), siz(2) = bot; end


			%check whether the input box is bigger than the screen
  if ((siz(1) <= ss(3)) & (siz(2) <= ss(4)))
    set(QmatNMR.uiInputFig, 'units', 'pixels', 'Position', [ss(3:4)/2 - siz/2, siz]);

  else			%the input window is too big for the screen --> make it smaller
    %
    %SET all uicontrols to the right size
    %
    QmatNMR.SETnumberbuttons = length(get(QmatNMR.uiInputFig, 'children'));
    QmatNMR.SETbuttons = get(QmatNMR.uiInputFig, 'children');

    if (siz(1)/ss(3)) > (siz(2)/ss(4))
      QmatNMR.Factor = 0.9*ss(3)/siz(1);
    else
      QmatNMR.Factor = 0.9*ss(4)/siz(2);
    end


    %
    %First change the sizes of any uicontrols
    %
    QmatNMR.ChangedValue = [QmatNMR.Factor QmatNMR.Factor QmatNMR.Factor QmatNMR.Factor];

    for QSETteller = 1:QmatNMR.SETnumberbuttons
      if length(get(QmatNMR.SETbuttons(QSETteller), 'type')) == 9		%This means it's a uicontrol !!!
        QTEMP = get(QmatNMR.SETbuttons(QSETteller), 'position');
        set(QmatNMR.SETbuttons(QSETteller), 'position', QTEMP .* QmatNMR.ChangedValue);
      end
    end

    %
    %Then set all texts to the right size
    %
    QmatNMR.SETnumberbuttons = length(get(QmatNMR.uiInputFigAxis, 'children'));
    QmatNMR.SETbuttons = get(QmatNMR.uiInputFigAxis, 'children');

    QmatNMR.ChangedValue = [QmatNMR.Factor QmatNMR.Factor 1];

    for QSETteller = 1:QmatNMR.SETnumberbuttons
      if strcmp(get(QmatNMR.SETbuttons(QSETteller), 'type'), 'text')		%This means it's a text !!!
        QTEMP = get(QmatNMR.SETbuttons(QSETteller), 'position');
	QTEMP2 = get(QmatNMR.SETbuttons(QSETteller), 'fontsize');
        set(QmatNMR.SETbuttons(QSETteller), 'position', QTEMP .* QmatNMR.ChangedValue, 'fontsize', round(QmatNMR.Factor*QTEMP2));
      end
    end


    %
    %Finally set the window size to its proper value
    %
    drawnow
    set(QmatNMR.uiInputFig, 'Position', QmatNMR.Factor*[ss(3:4)/2 - siz/2, siz]);
  end


  %
  %Finally add a special button that makes the input window the full width of the screen if pressed
  %
  QTEMP = get(QmatNMR.uiInputFig, 'Position');
  uicontrol('Style', 'PushButton', 'Position', [QTEMP(3)-70 QTEMP(4)-25 70 25], 'String', 'Full Width', ...
            'Callback', 'QTEMP=get(gcf, ''position''); set(gcf, ''position'', [0 QTEMP(2) 1 QTEMP(4)]);', ...
	    'backgroundcolor', QmatNMR.ColorScheme.Button3Back, 'foregroundcolor', QmatNMR.ColorScheme.Button3Fore);


  %
  %In order to make it possible to use the TAB button to flip through all buttons, we invert the order of the objects in the figure
  %because we have created them in the wrong order
  %
  AllKids = get(gcf, 'children');
  set(gcf, 'children', flipud(AllKids));


								%now make all objects resizeable (normalized units)
  set(get(QmatNMR.uiInputFigAxis, 'children'), 'units', 'normalized');
  QmatNMR.SETbuttons = get(QmatNMR.uiInputFig, 'children');
  set(QmatNMR.SETbuttons, 'units', 'normalized');
  set(QmatNMR.uiInputFigAxis,'Visible','off');
  set(QmatNMR.uiInputFig, 'units', 'normalized');
