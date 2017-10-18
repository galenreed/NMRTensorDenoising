function h=Qedittext(EH, command, arg, p1,v1,p2,v2,p3,v3,p4,v4,p5,v5,p6,v6,p7,v7,p8,v8,p9,v9,p10,v10)
%Qedittext Edit uicontrol for text with slide tools.
%
%
%	R=Qedittext(H, COMMAND, ARG, 'P1',V1,'P2',V2,P3,V3...)
%
%   Where:
%     H        : The edit uicontrol handle
%     COMMAND  : A valid command as shown below
%     ARG      : A valid argument as shown below
%     Pn       : Uicontrol property name (up to 10 parameters are allowed)
%     Vn       : Uicontrol property value
%     R        : When command is INIT: the edit ui handle
%                                GETTEXT: the edit text
%                                GETPOS: the [row col] position
%
%  This function allows you to create in a single call a usefull
%  uicontrol system to edit text. 
%  To build the controls call the function with command INIT,
%  in this case H is not used so can be anything but can not be
%  omitted.
%  
%  Different styles can be specified and very important the mode can
%  be set to READ_ONLY so that any modification in the text is not upgraded
%  or READ_WRITE where the modifications made by the user are upgraded
%  when the edit callback is evaluated. For example by cliking the mouse
%  outside the edit uicontrol or pressing Ctrl-Enter in X-windows systems.
%  To create a READ_WRITE edit call Qedittext with 'value' 1. The Mode can
%  also be changed later by calling Qedittext with command SETMODE.
%
%  The whole text is saved in the UserData property of the edit uicontrol
%  The edit value property contains three numbers: [A B C]
%    A = The mode flag: 0 for READ_ONLY, 1 for READ_WRITE.
%    B = The handle of the vertical slide if exist else NaN.
%    C = The handle of the horizontal slide if exist else NaN.
%  The UserData property of both slides contains the edit handle.
%
%  All the properties passed in the call will be applied to the edit
%  uicontrol and both slides. A starting text can be included in the 
%  first call by passing it as a string property. The text to be set
%  in the edit uicontrol DOES NOT required to be a matrix text as obtained
%  from the function STR2MAT but can be of any format. For example
%  multiple lines text is also obtained by separating the lines
%  by the '|' character or a carrige return. On the other hand
%  the returned text form the command GETTETX is always in a matrix
%  format.
%
%
%  RETURNED VALUES:
%  The returned value depend on the command used:
%  When the edit is built the first time (command INIT) the
%  returned value is the edit handle and the slide handles can 
%  be found in the edit value property (see above). The edit
%  handle must be kept for further calls by putting it in the
%  figure UserData for example. This is better than using a Tag
%  because the edit uicontrol can never be confused with other
%  similar edit present at the same moment. A tag can also
%  be specified in the INIT call and it will be assigned to
%  the edit and both slides.
%  Other returned values are self-explained in the command list.
%
%  If a tag is specified it is set to the edit uicontrol only.
%  Therefore, findobj('tag', 'MYTAG') will find only
%  one uicontrol.
%
%  IMPORTANT!!!
%  For the READ_WRITE mode type Ctrl-Enter to accept the modification
%  or click the mouse outside the edit uicontrol. If the slider are
%  use before of the mentioned operation the modifications will not be
%  kept.
%
%  The size of the slides can be modified in the first non-comment
%  line of this file.
%
% Valid COMMAND:
%	INIT,       (STYLE)    - Build the uicontrol edit with style STYLE
%	SETTEXT,    (TEXT)     - Set TEXT in the edit uicontrol
%	APPENDTEXT, (TEXT)     - Append TEXT to the existing one
%	GETTEXT                - Return the edited text
%	GETPOS                 - Return the [row col] position
%	GETSIZE                - Return the size of the text [rows cols]
%	GETMODE                - Return the Mode
%	CLEAR                  - Clear the edit uicontrol
%	GOTOLINE,   (LINE)     - Goto line LINE
%	GOTOCOL,    (COL)      - Goto col COL
%	REPLACE                - Upgrade the edit userdata (edit callback)
%	VISIBLE,    (ON / OFF) - Set the uicontrols visible property
%	ENABLE,     (ON / OFF) - Set the uicontrols enable property
%	SETMODE,    (READ_ONLY / READ_WRITE) - Set the mode
%	CLOSE                  - Delete the uicontrols
%
%
% Valid STYLE:
%	VTLHZB   - Vertical on the left horizontal on the bottom
%	VTRHZB   - Vertical on the right horizontal on the bottom
%	VTLHZT   - Vertical on the left horizontal on the top
%	VTRHZT   - Vertical on the right horizontal on the top
%	VTL      - Vertical on the left only
%	VTR      - Vertical on the right only
%	HZB      - Horizontal on the bottom only
%	HZT      - Horizontal on the top only
%	HZBVTL   - As 1
%	HZBVTR   - As 2
%	HZTVTL   - As 3
%	HZTVTR   - As 4
%	NONE     - No slide tools
%
%
% Example:
% h=Qedittext(0, 'init', 'VTRHZB', 'units', 'norm', 'pos', [0.1 0.1 0.8 0.8])
% Qedittext(h, 'settext', 'printf hello world!');
%
% See also: UICONTROL, EDITNUM, UIRADIO.

% This function can be modified with the only restriction that the
% next two lines have to be reteined.
%             Copyright (c) 1996 by Claudio Rivetti 
%                  claudio@alice.uoregon.edu
%
% Last version: June 22,  1996.
% ENJOY IT!


% definition of the slide tools size in pixels.
% Change the size here if you wish.
SL_SIZE=14;

if nargin > 23
        error('Too many input arguments.');
end
if nargin < 2
        error('Too few input arguments.');
end

command=upper(strrep(command, ' ', ''));



if strcmp(command, 'APPENDTEXT')

	sl=get(EH, 'value');
	slv=sl(2);
	slh=sl(3);
	
	set(EH, 'string', arg);
	arg=get(EH, 'string');
	
	usr=get(EH, 'user');
	j=isempty(usr)+1;
	usr=str2mat(usr,arg);
	usr=usr(j:size(usr,1),:);
	
	set(EH, 'user', usr);
	col=1;
	if isobj(slv)
		set(slv, 'min', size(usr,1));
	end
	if isobj(slh)
		set(slh, 'max', size(usr,2));
		col=get(slh, 'value');
	end
	
	Qedittext(EH, 'GOTOCOL', col);
	
	return

end  %APPENDTEXT



if strcmp(command, 'SETTEXT')

	sl=get(EH, 'value');
	slv=sl(2);
	slh=sl(3);
	set(EH, 'string', arg);
	str=get(EH, 'string');
	set(EH, 'user', str);
	if isobj(slv)
		set(slv, 'min', size(str,1), 'value', 1);
	end
	if isobj(slh)
		set(slh, 'max', size(str,2), 'value', 1);
	end
	
	return

end  %SETTEXT


if strcmp(command, 'REPLACE')

	sl=get(EH, 'value');
	slv=sl(2);
	slh=sl(3);
	if sl(1)==1
		slv=sl(2);
		slh=sl(3);
		str=get(EH, 'string');
		txt=get(EH, 'user');
		if isobj(slv)
			row=get(slv, 'value');
		else
			row=1;
		end
		
		if isobj(slh)
			col=get(slh, 'value');
		else
			col=1;
		end
		
		r=max(row-1+size(str,1),size(txt,1));
		c=max(col-1+size(str,2),size(txt,2));

		new_txt=setstr(zeros(r,c)+32);

		new_txt(1:min(size(txt,1),r),1:min(size(txt,2),c))=txt(1:min(size(txt,1),r),1:min(size(txt,2),c));
		new_txt(row:row+size(str,1)-1, col:col+size(str,2)-1)=str;

		set(EH, 'user', new_txt);
		if isobj(slv)
			set(slv, 'min', size(new_txt,1));
		end
		if isobj(slh)
			set(slh, 'max', size(new_txt,2));
		end
	else
		p=Qedittext(EH, 'GETPOS');
		if isobj(slv)
			Qedittext(EH, 'GOTOLINE', p(1));
		end
		if isobj(slh)
			Qedittext(EH, 'GOTOCOL', p(2));
		end
		if ~isobj(slv) & ~isobj(slh)
			Qedittext(EH, 'GOTOLINE', 1);
		end
	end
	
	return

end  %REPLACE




%%%%%%%%%%%%%  BUILD ALL THE NECESSARY OBJECTS   %%%%%%%%%%%%%%%%%

if strcmp(command, 'INIT')
	
	arg=upper(strrep(arg, ' ', ''));
	
	valid_args=['VTLHZB';...
				'VTRHZB';...
				'VTLHZT';...
				'VTRHZT';...
				'VTL   ';...
				'VTR   ';...
				'HZB   ';...
				'HZT   ';...
				'HZBVTL';...
				'HZBVTR';...
				'HZTVTL';...
				'HZTVTR';...
				'NONE  ']; 

ok=0;                   
for i=1:size(valid_args,1)
        if strcmp(strrep(valid_args(i,:), ' ',''), arg)
                ok=1;
        end
end

if ~ok
        error([arg ' is not a valid argument.']);
end


	
	%Create the edit uicontrol
	EH=uicontrol('style', 'edit');
	
	if nargin > 3,
		if (nargin-3)/2-fix((nargin-3)/2),
			error('Incorrect number of input arguments')
		end
		cmdstr='';
		for i=1:(nargin-3)/2-1,
			cmdstr = [cmdstr,'p',num2str(i),',v',num2str(i),','];
		end
		cmdstr = [cmdstr,'p',num2str((nargin-3)/2),',v',num2str((nargin-3)/2)];
		eval(['set(EH,',cmdstr,');']);
	end

	set(EH, 'min', 1, 'max', 10, 'Userdata', get(EH, 'string'), 'CallBack', 'Qedittext(gco, ''REPLACE'')');
	sl=[nan nan];
	
	if ~strcmp(arg, 'NONE')
		
		slv_cbk='Qedittext(get(gco, ''userdata''), ''GOTOLINE'', get(gco, ''value''))';
		slh_cbk='Qedittext(get(gco, ''userdata''), ''GOTOCOL'', get(gco, ''value''))';
		
		old_units=get(EH, 'units');
		set(EH, 'units', 'pixels');
		
		pos=get(EH, 'pos');
		sw=SL_SIZE;
		
		if findstr('VTL', arg)
			pos(1)=pos(1)+sw;
			pos(3)=pos(3)-sw;
			slv_pos=[pos(1)-sw pos(2) sw pos(4)];
		end
		if findstr('VTR', arg)
			pos(3)=pos(3)-sw;
			slv_pos=[pos(1)+pos(3) pos(2) sw pos(4)];
		end
		if findstr('HZT', arg)
			pos(4)=pos(4)-sw;
			slh_pos=[pos(1) pos(2)+pos(4) pos(3) sw];
			slv_pos(4)=slv_pos(4)-sw;
		end
		if findstr('HZB', arg)
			pos(2)=pos(2)+sw;
			pos(4)=pos(4)-sw;
			slh_pos=[pos(1) pos(2)-sw pos(3) sw];
			slv_pos(2)=slv_pos(2)+sw;
			slv_pos(4)=slv_pos(4)-sw;
		end
		
		set(EH, 'pos', pos);
		str=get(EH, 'userdata');
		mx=max(1,size(str,1));
		
		if findstr('VT', arg)
			slv=uicontrol('style', 'slide',...
						'pos', slv_pos,...
						'BackgroundColor', get(EH, 'BackgroundColor'),...
						'ForegroundColor', get(EH, 'ForegroundColor'),...
						'Units', get(EH, 'Units'),...
						'Visible', get(EH, 'Visible'),...
						'Enable', get(EH, 'Enable'),...
						'Userdata', EH,...
						'min', mx,...
						'max', 1,...
						'value', 1,...
						'string', '1',...
						'CallBack', slv_cbk);
			set(slv, 'units',  old_units);
			sl(1)=slv;
		end
		
		mx=max(1,size(str,2));
		if findstr('HZ', arg)
			slh=uicontrol('style', 'slide',...
						'pos', slh_pos,...
						'BackgroundColor', get(EH, 'BackgroundColor'),...
						'ForegroundColor', get(EH, 'ForegroundColor'),...
						'Units', get(EH, 'Units'),...
						'Visible', get(EH, 'Visible'),...
						'Enable', get(EH, 'Enable'),...
						'Userdata', EH,...
						'min', 1,...
						'max', mx,...
						'value', 1,...
						'string', '1',...
						'CallBack', slh_cbk);
							
			set(slh, 'units',  old_units);
			sl(2)=slh;
		end
		
		set(EH, 'units', old_units);						 
	end

	set(EH, 'value', [get(EH, 'value') sl]);
	h=EH;
	return
	
end %INIT


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



if strcmp(command, 'GETTEXT')
	h=get(EH, 'userdata');
	return
end  %GETTEXT


if strcmp(command, 'GETPOS')
	sl=get(EH, 'value');
	if isobj(sl(2))
		r=get(sl(2), 'value');
	end
	if isobj(sl(3))
		c=get(sl(3), 'value');
	end
	h=[r c];
	return
end  %GETPOS


if strcmp(command, 'GETSIZE')
	h=size(get(EH, 'Userdata'));
	return
end  %GETSIZE

if strcmp(command, 'GETMODE')
	m=['READ_ONLY ';'READ_WRITE'];
	v=get(EH, 'Value');
	h=strrep(m(v(1)+1,:), ' ','');
	return
end  %GETMODE



if strcmp(command, 'CLEAR')
	Qedittext(EH, 'SETTEXT', '');
	return
end  %CLEAR


if strcmp(command, 'GOTOLINE')

	sl=get(EH, 'value');
	slv=sl(2);
	slh=sl(3);
	row=arg;
	if isobj(slv)
		prev_row=str2num(get(slv, 'string'));
		if row >= prev_row
			row=min(ceil(row), get(slv, 'min'));
		else
			row=max(fix(row), 1);
		end
		set(slv, 'value', row, 'string', num2str(row));
	end
	if isobj(slh)
		col=get(slh, 'value');
	else
		col=1;
	end
	str=get(EH, 'User');
	if ~isempty(str)
		str=str(row:size(str,1), col:size(str,2));
		set(EH, 'string', str);
		if isobj(slv)
			set(slv, 'value', row);
		end
		if isobj(slh)
			set(slh, 'value', col);
		end
	end

	return
end  %GOTOLINE



if strcmp(command, 'GOTOCOL')

	sl=get(EH, 'value');
	slv=sl(2);
	slh=sl(3);
	col=arg;
	if isobj(slh)
		prev_col=str2num(get(slh, 'string'));
		if col >= prev_col
			col=min(ceil(col), get(slh,'max'));
		else
			col=max(fix(col),1);
		end
		set(slh, 'value', col, 'string', num2str(col));
	end
	if isobj(slv)
		row=get(slv, 'value');
	else
		row=1;
	end
	str=get(EH, 'User');
	if ~isempty(str)
		str=str(row:size(str,1), col:size(str,2));
		set(EH, 'string', str);
		if isobj(slv)
			set(slv, 'value', row);
		end
		if isobj(slh)
			set(slh, 'value', col);
		end
	end
	return
	
end  %GOTOCOL




if strcmp(command, 'VISIBLE')

	sl=get(EH, 'value');
	set(EH, 'visible', arg);

	if isobj(sl(2))
		set(sl(2), 'visible', arg);
	end
	if isobj(sl(3))
		set(sl(3), 'visible', arg);
	end
	return
			
end  %VISIBLE



if strcmp(command, 'ENABLE')

	sl=get(EH, 'value');
	set(EH, 'enable', arg);

	if isobj(sl(2))
		set(sl(2), 'enable', arg);
	end
	if isobj(sl(3))
		set(sl(3), 'enable', arg);
	end
	return
			
end  %ENABLE



if strcmp(command, 'SETMODE')

	v=get(EH, 'value');
	
	if strcmp(upper(arg), 'READ_ONLY')
		v(1)=0;
	end
	if strcmp(upper(arg), 'READ_WRITE')
		v(1)=1;
	end
	
	set(EH, 'value', v);
	return
		
end  %SETMODE




if strcmp(command, 'CLOSE')

	sl=get(EH, 'value');
	delete(EH);
	if isobj(sl(2))
		delete(sl(2));
	end
	if isobj(sl(3))
		delete(sl(3));
	end
	return
		
end  %CLOSE

return
