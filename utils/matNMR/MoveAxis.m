function MoveAxis(arg)
%MoveAxis Used to grab and move objects in general
%   To use, click and hold down a mouse button while
%   the cursor is near the lower left corner of the
%   axis you want to move. Wait for the cursor to change
%   to a fleur (4 way arrows), then drag the legend or axis
%   to the desired location and release the mouse button.
%
%   To enable, set the figure window's WINDOWBUTTONDOWNFCN
%   property to 'MoveAxis'. For example,
%
%            set(gcf,'WindowButtonDownFcn','MoveAxis')

%   10/5/93  D.Thomas
%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 5.7 $  $Date: 1997/11/21 23:33:05 $

%
%   adapted for matNMR by Jacco van Beek
%   19-12-'98
%
%
%   This function should now work for all objects. In the original moveaxis.m,
%   in the userdata property of the object all necessary parameters were stored. 
%   This is still so but now ONLY the position is stored!
%


global OLDCA DELTA HL FIGUTS
if nargin==0,
st=get(gcf,'SelectionType');

					%Actions according to which button was pressed!
if (strcmp(st,'normal'))
    MoveAxis(1);

elseif strcmp(st,'open'),
  if strcmp(get(gco,'Type'),'text')	%text objects can be edited in this fashion
    TextHandle=gco;
    set(TextHandle,'Editing','on');
    waitfor(TextHandle,'Editing');
  end
  
elseif strcmp(st, 'alt')
  if strcmp(get(gco,'Type'),'text')	%text objects can be changed in this fashion
    askedittext
  end
end


elseif arg==1,
    FIGUTS = get(gcf,'units');
    set(gcf,'pointer','fleur');
    if strcmp(FIGUTS,'normalized'),
        pnt = get(gcf,'currentpoint');
        set(gcf,'units','pixels');  
        pos = get(gcf,'position');
        pnt = [pnt(1) * pos(3) pnt(2) * pos(4)];
    else,
        set(gcf,'units','pixels');
        pnt=get(gcf,'currentpoint');
    end

    Object = gco;
  
    mn=1e20;
    mi=1;
%
%The following makes this routine only usefull for legends and I want it as a general routine ...
%
%Jacco van Beek
%
%        if strcmp(get(Object,'type'),'axes') & ...
%           strcmp(get(Object,'tag'),'legend')
%
    units=get(Object,'units');
    set(Object,'units','pixels')
    cap=get(Object,'position');
    if sum((pnt-cap(1:2)).^2)<mn,
       mn=sum((pnt-cap(1:2)).^2);
       DELTA=cap(1:2)-pnt;
    end
    set(Object,'units',units);

    ud = get(Object,'userdata');
    tmp=ud.posdata;
    OLDCA=gca;  

    HL=[Object abs(get(Object,'units'))];
    set(Object,'units','pixels');
    set(gcf,'windowbuttonmotionfcn','MoveAxis(2)')
    set(gcf,'windowbuttonupfcn','MoveAxis(3)');


elseif arg==2,
    ud = get(gco, 'userdata');
    if (length(ud.posdata) == 3)		%holds for text objects
      pos=get(gco, 'position');
      set(gco,'units','pixels', 'position',[get(gcf,'currentpoint')+DELTA pos(3)]);
    
    elseif (length(ud.posdata) == 4)		%holds for axes
      pos=get(gco,'position');
      set(gco,'units','pixels', 'position',[get(gcf,'currentpoint')+DELTA pos(3:4)]);
    end  


elseif arg==3,
    set(gcf,'WindowButtonMotionfcn','', ...
        'pointer','arrow','currentaxes',OLDCA, ...
        'windowbuttonupfcn','');
    set(HL(1),'units',setstr(HL(2:length(HL))));
    set(gcf,'units',FIGUTS);
end



