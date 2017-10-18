function [h, buttons] = editnum(hfig, mn, mx, inc, type, p1,v1,p2,v2,p3,v3,p4,v4,p5,v5,p6,v6,p7,v7,p8,v8,p9,v9,p10,v10)
%EDITNUM  Edit uicontrol for number input with increment buttons/slide tool.
%
%   H=EDITNUM(HFIG, MIN, MAX, INC, TYPE, 'P1',V1,'P2',V2,P3,V3...)
%
%   Where:
%    HFIG : The figure handle (default gcf)
%    MIN  : The lower limit of the input range (default -inf)
%    MAX  : The higher limit of the input range (default +inf)
%    INC  : The increment applied by the buttons/slide (default 1)
%    TYPE : Specify the different input number type (default INT_NN)
%    Pn   : Uicontrol property name (up to 7 parameters are allowed)
%    Vn   : Uicontrol property value
%    H    : The handle of the 'edit' uicontrol object created
%
%
%  This function allow you to create in a single call a useful
%  uicontrol system for numbers input. 
%  The number in input can be restricted to a defined range and
%  the increment can also be specified. This avoid mistakes
%  when typing the number.
%  Different increment tools can be specified to modify the 
%  input value with the mouse by a defined increment.
%  Setting the 'style' to 'text' (instead of the default 'edit'
%  allow the user to modify the number only with the mouse.
%
%  The displayed string is always stored as a number in the 
%  'value' property. To read the number use: 
%
%    num=get(H, 'value');
%  
%  To set the number internally to a function use:
%
%    set(H, 'string', num2str(newnum));
%    set(get(H, 'parent'), 'CurrentObject', H);
%    eval(get(H, 'CallBack'));
%
%
%  If the parameter position is specified it refers to the
%  total size of the uicontrols (edit plus buttons/slide) created.
%
%  Valid types are:
%      INT_BT_RR     : Integer number with buttons on the right
%      INT_BT_LL     : Integer number with buttons on the left
%      INT_BT_TT     : Integer number with buttons on the top
%      INT_BT_BB     : Integer number with buttons on the bottom
%      INT_BT_LR     : Integer number with buttons on the left and right
%      INT_BT_TB     : Integer number with buttons on the top and bottom 
%      INT_SL_T      : Integer number with slide on the top
%      INT_SL_B      : Integer number with slide on the bottom
%      INT_SL_L      : Integer number with slide on the left
%      INT_SL_R      : Integer number with slide on the right
%      INT_NN        : Integer number without increment tools
%      FLOAT_BT_RR   : Float number with buttons on the right
%      FLOAT_BT_LL   : Float number with buttons on the left
%      FLOAT_BT_TT   : Float number with buttons on the top
%      FLOAT_BT_BB   : Float number with buttons on the bottom
%      FLOAT_BT_LR   : Float number with buttons on the left and right
%      FLOAT_BT_TB   : Float number with buttons on the top and bottom 
%      FLOAT_SL_T    : Float number with slide on the top
%      FLOAT_SL_B    : Float number with slide on the bottom
%      FLOAT_SL_L    : Float number with slide on the left
%      FLOAT_SL_R    : Float number with slide on the right
%      FLOAT_NN      : Float number without increment tools
%
%    The INT_NN  and FLOAT_NN types can be used when the increment
%    tools are not need but the range control is still necessary. 
%    
%    Note: if one of the properties is a callback, it will be evaluated
%    also when the increment tools are pushed with the mouse.
%    The Qstr2val function is always added before the edit callback.
%    To start with a particular value put it in the 'string' property.
%    The pushbuttons handles or the slide handle are stored
%    in the 'edit' uicontrol userdata.
%    The size and the string of the buttons or slide can be changed
%    in the first lines of this function.
%
%    If a tag is specified it is set to the edit uicontrol only.
%    Therefore, findobj('tag', 'MYTAG') will find only
%    one uicontrol.
%
%    Bugs: When the slide is on the left or right and the 'edit'
%    uicontrol usually it is not high enough and the slide arrows
%    will not be shown. This is a Matlab problem that I was not 
%    able to overcome.
%
%    Example:
%    figure('position',  [200 400 280  80]);
%    cbk='set(gcf, ''color'', [0 0 get(gco, ''value'')])';
%    p=[.2 .2 0.4 0.3];
%    h=editnum(gcf,0,1,.1, 'FLOAT_BT_RR', 'units','norm','pos', p, 'callback', cbk)
%
%    See also: Qstr2val, UICONTROL, EDITTEXT, UIRADIO.

% This function can be modified with the only restriction that the
% next two lines have to be reteined.
%             Copyright (c) 1996 by Claudio Rivetti 
%                  claudio@alice.uoregon.edu
%
% Last version: June 8, 1996.
% Let me define this function as a 'chicca' of the Matlab GUI.
% ENJOY IT!
%

%
% Adapted for matNMR by Jacco van Beek
% April 7, 1997.
%

buttons = 0;	%buttons is used as an array with the handles of the buttons that are created

% definition of the increment tools size in pixels.
BT_SIZE=16;
SL_SIZE=14;

% definition of the buttons 'string'.
BT2_STR='+';
BT1_STR='-';


if nargin > 25
	error('Too many input arguments.');
end

%Set the default values if needed
if nargin<5
	if nargin == 0, hfig=gcf; mn=-inf; mx=inf; inc=1; type='INT_NN'; end
	if nargin == 1, mn=-inf; mx=inf; inc=1; type='INT_NN'; end
	if nargin == 2, mx=inf; inc=1; type='INT_NN'; end
	if nargin == 3, inc=1; type='INT_NN'; end
	if nargin == 4, type='INT_NN'; end
end


s=sort([mn mx]);
mn=s(1);
mx=s(2);
type=upper(strrep(type, ' ', ''));

valid_types=[	'INT_BT_RR  ';...
				'INT_BT_LL  ';...
				'INT_BT_TT  ';...
				'INT_BT_BB  ';...
				'INT_BT_LR  ';...
				'INT_BT_TB  ';...
				'INT_SL_T   ';...
				'INT_SL_B   ';...
				'INT_SL_L   ';...
				'INT_SL_R   ';...
				'INT_NN     ';...
				'FLOAT_BT_RR';...
				'FLOAT_BT_LL';...
				'FLOAT_BT_TT';...
				'FLOAT_BT_BB';...
				'FLOAT_BT_LR';...
				'FLOAT_BT_TB';...
				'FLOAT_SL_T ';...
				'FLOAT_SL_B ';...
				'FLOAT_SL_L ';...
				'FLOAT_SL_R ';...
				'FLOAT_NN   '];	

% Check if type is a valid string 	
ok=0;			
for i=1:size(valid_types,1)
	if strcmp(strrep(valid_types(i,:), ' ',''), type)
		ok=1;
	end
end

if ~ok
	error([type ' is not a valid type.']);
end

% Split the type string
[num_type, type]=strtok(type, '_');
[uic_type, type]=strtok(type, '_');
[pos_type, type]=strtok(type, '_');

if strcmp(uic_type, 'SL') & (abs(mn)==inf | abs(mx)==inf)
	error('Slide type can not have infinite limits');
end


% Create the edit uicontrol
h=uicontrol(hfig, 'style', 'edit');

% Set the passed parameters in the h properties
if nargin > 5,
        if (nargin-5)/2-fix((nargin-5)/2),
                error('Incorrect number of input arguments')
        end
        cmdstr='';
        for i=1:(nargin-5)/2-1,
                cmdstr = [cmdstr,'p',num2str(i),',v',num2str(i),','];
        end
        cmdstr = [cmdstr,'p',num2str((nargin-5)/2),',v',num2str((nargin-5)/2)];
        eval(['set(h,',cmdstr,');']);
end


% Set the starting value
Qstr2val(h, mn, mx, num_type, 6);

% Build the edit callback
cbk=get(h, 'CallBack');
ed_cbk=sprintf('%s,%f,%f,''%s'', %u);%s;', 'Qstr2val(gco', mn, mx, num_type, 6, cbk);

if strcmp(uic_type, 'SL')
	ed_cbk=[ed_cbk 'set(get(gco, ''userdata''), ''value'', get(gco, ''value''))'];
end

set(h, 'CallBack', ed_cbk);

old_units=get(h, 'units');
set(h, 'units', 'pixels');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        BUTTONS CASE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if strcmp(uic_type, 'BT')

	if strcmp(pos_type, 'RR')
		pos=get(h, 'pos');
		bw=BT_SIZE;
		pos(3)=pos(3)-bw;
		set(h, 'pos', pos);
		pb1=[pos(1)+pos(3) pos(2)          bw pos(4)/2];
		pb2=[pos(1)+pos(3) pos(2)+pos(4)/2 bw pos(4)/2];
	end
	if strcmp(pos_type, 'LL')
		pos=get(h, 'pos');
		bw=BT_SIZE;
		pos(1)=pos(1)+bw;
		pos(3)=pos(3)-bw;
		set(h, 'pos', pos);
		pb1=[pos(1)-bw pos(2)          bw pos(4)/2];
		pb2=[pos(1)-bw pos(2)+pos(4)/2 bw pos(4)/2];
	end
	if strcmp(pos_type, 'TT')
		pos=get(h, 'pos');
		bh=BT_SIZE;
		pos(4)=pos(4)-bh;
		set(h, 'pos', pos);
		pb1=[pos(1)          pos(2)+pos(4) pos(3)/2 bh];
		pb2=[pos(1)+pos(3)/2 pos(2)+pos(4) pos(3)/2 bh];
	end
	if strcmp(pos_type, 'BB')
		pos=get(h, 'pos');
		bh=BT_SIZE;
		pos(2)=pos(2)+bh;
		pos(4)=pos(4)-bh;
		set(h, 'pos', pos);
		pb1=[pos(1)          pos(2)-bh pos(3)/2 bh];
		pb2=[pos(1)+pos(3)/2 pos(2)-bh pos(3)/2 bh];
	end
	if strcmp(pos_type, 'LR')
		pos=get(h, 'pos');
		bw=BT_SIZE;
		pos(1)=pos(1)+bw;
		pos(3)=pos(3)-2*bw;
		set(h, 'pos', pos);
		pb1=[pos(1)-bw     pos(2) bw pos(4)];
		pb2=[pos(1)+pos(3) pos(2) bw pos(4)];
	end
	if strcmp(pos_type, 'TB')
		pos=get(h, 'pos');
		bh=BT_SIZE;
		pos(2)=pos(2)+bh;
		pos(4)=pos(4)-2*bh;
		set(h, 'pos', pos);
		pb1=[pos(1) pos(2)-bh     pos(3) bh];
		pb2=[pos(1) pos(2)+pos(4) pos(3) bh];
	end
	
	
	bt_cbk1='set(get(gco, ''userdata''), ''string'', num2str(get(get(gco, ''userdata''), ''value'')+get(gco, ''min'')));';
	bt_cbk2='set(gcf, ''CurrentObject'', get(gco, ''userdata''));eval(get(gco, ''callback''));';
	bt_cbk=[bt_cbk1 bt_cbk2];
	
	v1=abs(inc)*(-1);
	v2=abs(inc);
	b1=uicontrol(hfig,  'style', 'push',...
						'Units', get(h, 'Units'),...
						'pos', pb1,...
						'string', BT1_STR,...
						'BackgroundColor', get(h, 'BackgroundColor'),...
						'ForegroundColor', get(h, 'ForegroundColor'),...
						'HorizontalAlignment', 'center',...
						'Visible', get(h, 'Visible'),...
						'Enable', get(h, 'Enable'),...
						'Userdata', h,...
						'min', v1,...
						'CallBack', bt_cbk);
						
	b2=uicontrol(hfig,  'style', 'push',...
						'Units', get(h, 'Units'),...
						'pos', pb2,...
						'string', BT2_STR,...
						'BackgroundColor', get(h, 'BackgroundColor'),...
						'ForegroundColor', get(h, 'ForegroundColor'),...
						'HorizontalAlignment', 'center',...
						'Visible', get(h, 'Visible'),...
						'Enable', get(h, 'Enable'),...
						'Userdata', h,...
						'min', v2,...
						'CallBack', bt_cbk);
						
						
	set(h, 'userdata', [b1 b2], 'units', old_units);
	set(b1, 'units',  old_units);
	set(b2, 'units',  old_units);

	buttons = [b1 b2];
end  %BUTTONS CASE





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        SLIDE CASE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if strcmp(uic_type, 'SL')
	
	if strcmp(pos_type, 'B')
		pos=get(h, 'pos');
		sh=pos(4)/3;
		sh=SL_SIZE;
		pos(4)=pos(4)-sh;
		pos(2)=pos(2)+sh;
		set(h, 'pos', pos);
		sl_pos=[pos(1) pos(2)-sh pos(3) sh];
	end
	if strcmp(pos_type, 'T')
		pos=get(h, 'pos');
		sh=SL_SIZE;
		pos(4)=pos(4)-sh;
		set(h, 'pos', pos);
		sl_pos=[pos(1) pos(2)+pos(4) pos(3) sh];
	end
	if strcmp(pos_type, 'R')
		pos=get(h, 'pos');
		sw=SL_SIZE;
		pos(3)=pos(3)-sw;
		set(h, 'pos', pos);
		sl_pos=[pos(1)+pos(3) pos(2) sw pos(4)];
	end
	if strcmp(pos_type, 'L')
		pos=get(h, 'pos');
		sw=SL_SIZE;
		pos(3)=pos(3)-sw;
		pos(1)=pos(1)+sw;
		set(h, 'pos', pos);
		sl_pos=[pos(1)-sw pos(2) sw pos(4)];
	end

	
	sl_cbk1=['set(gco,  ''value'',  get(get(gco, ''userdata''), ''value'') + max(abs(get(get(gco, ''userdata''), ''value'')-get(gco,  ''value'')), str2num(get(gco,  ''string'')))*sign(get(gco,  ''value'')-get(get(gco, ''userdata''), ''value'')));', ...
			'set(gco,  ''value'',  round(get(gco,  ''value'')/str2num(get(gco,  ''string'')))*str2num(get(gco,  ''string'')));'];
	
	sl_cbk2='set(get(gco, ''userdata''), ''string'', num2str(get(gco,  ''value'')));';
	sl_cbk3='set(gcf, ''CurrentObject'', get(gco, ''userdata''));eval(get(gco, ''callback''));';
	sl_cbk=[sl_cbk1 sl_cbk2 sl_cbk3];
	

	strinc=num2str(abs(inc));
	sl=uicontrol(hfig,  'style', 'slide',...
						'Units', get(h, 'Units'),...
						'pos', sl_pos,...
						'string', strinc,...
						'BackgroundColor', get(h, 'BackgroundColor'),...
						'ForegroundColor', get(h, 'ForegroundColor'),...
						'Visible', get(h, 'Visible'),...
						'Userdata', h,...
						'min', mn,...
						'max', mx,...
						'value', get(h, 'value'),...
						'CallBack', sl_cbk);
						
	set(h, 'userdata', sl, 'units', old_units);
	set(sl, 'units',  old_units);

end %  SLIDE CASE


return



