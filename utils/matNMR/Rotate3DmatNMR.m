function Rotate3DmatNMR(arg,arg2)
%Rotate3D Interactively rotate the view of a 3-D plot.
%   Rotate3D ON turns on mouse-based 3-D rotation.
%   Rotate3D OFF turns if off.
%   Rotate3D by itself toggles the state.
%
%   Rotate3D(FIG,...) works on the figure FIG.
%
%   Double click to restore the original view.
%
%   See also ZOOM.

%   Rotate3D on enables  text feedback
%   Rotate3D ON disables text feedback.

%   Revised by Rick Paxson 10-25-96
%   Clay M. Thompson 5-3-94
%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 1.35 $  $Date: 1998/08/21 20:02:05 $

%
%   adapted for matNMR by Jacco van Beek
%

if(nargin == 0)
   setState(gcf,'toggle');
elseif nargin==1
   if ishandle(arg)
      setState(arg,'toggle')
   else
      switch(lower(arg)) % how much performance hit here
      case 'motion'
         rotaMotionFcn
      case 'down'
         rotaButtonDownFcn
      case 'up'
         rotaButtonUpFcn
      case 'on'
         setState(gcf,arg);
      case 'off'
         setState(gcf,arg);
      otherwise
         error('Unknown action string.');
      end
   end
elseif nargin==2
   if ~ishandle(arg), error('Unknown figure.'); end
   switch(lower(arg2)) % how much performance hit here
   case 'on'
      setState(arg,arg2)
   case 'off'
      setState(arg,arg2);
   otherwise
      error('Unknown action string.');
   end
end

%--------------------------------
% Set activation state. Options on, ON, off
function setState(fig,state)
rotaObj = findobj(allchild(fig),'Tag','rotaObj');
if(strcmp(state,'toggle'))
   if(~isempty(rotaObj))
      setState(fig,'off');
   else
      setState(fig,'on');
   end
elseif(strcmp(lower(state),'on'))

   if(isempty(rotaObj))
      plotedit(fig,'locktoolbarvisibility');
      rotaObj = makeRotaObj(fig);
      set(findall(fig,'Tag','figToolRotate3D'),'State','on');
   end
   % Handle toggle of text feedback. ON means no feedback on means feedback.
   rdata = get(rotaObj,'UserData');
   if(strcmp(state,'on'))
      rdata.textState = 1;
   else
      rdata.textState = 0;
   end
   set(rotaObj,'UserData',rdata);
   set(fig,'ButtonDownFcn','SelectFigure');

elseif(strcmp(lower(state),'off'))
   set(findall(fig,'Tag','figToolRotate3D'),'State','off');
   if(~isempty(rotaObj))
      destroyRotaObj(rotaObj);
   end
   set(fig,'ButtonDownFcn','SelectFigure');
end

%---------------------------
% Button down callback
function rotaButtonDownFcn
rotaObj = findobj(allchild(gcbf),'Tag','rotaObj');
if(isempty(rotaObj))
   return;
else
   rdata = get(rotaObj,'UserData');

   % Activate axis that is clicked in
   allAxes = findobj(datachildren(gcbf),'flat','type','axes');
   axes_found = 0;
   funits = get(gcbf,'units');
   set(gcbf,'units','pixels');
   for i=1:length(allAxes),
      ax=allAxes(i);
      if ~strcmp(get(ax, 'tag'), 'SuperTitleAxis') & ~strcmp(get(ax, 'tag'), 'rotaObj')
        cp = get(gcbf,'CurrentPoint');
        aunits = get(ax,'units');
        set(ax,'units','pixels')
        pos = get(ax,'position');
        set(ax,'units',aunits)

        %
        %here we check whether the position where the pointer was located when the user clicked the
        %button, is in a particular axis in the 2D/3D viewer. If so, then we remember the axis handle
        %and possibly set the axis as the current one.
        %
        if cp(1) >= pos(1) & cp(1) <= pos(1)+pos(3) & ...
           cp(2) >= pos(2) & cp(2) <= pos(2)+pos(4)
           axes_found = 1;
           set(gcbf,'currentaxes',ax);

           %
           %now we'll check whether the current axis is highlighted. In the 2D/3D viewer this denotes that
           %it is the current axis. For this we normally use the SelectAxis routine but that requires some
           %variables to be declared global
           %Jacco van Beek, 09-03-2005
           %
           if strcmp(get(ax, 'selected'), 'off')
             global QmatNMR
             SelectAxis
           end

           break
        end % if
     end
   end % for
   set(gcbf,'units',funits)
   if axes_found==0, return, end
   rdata.targetAxis = ax;
   
   % store the state on the zlabel:  that way if the user
   % plots over this axis, this state will be cleared and
   % we get to start over.
   viewData = getappdata(get(ax,'ZLabel'),'ROTATEAxesView');
   if isempty(viewData)
      setappdata(get(ax,'ZLabel'),'ROTATEAxesView', get(ax, 'View'));
   end
   
   selection_type = get(gcbf,'SelectionType');
   if strcmp(selection_type,'open')
      % this assumes that we will be getting a button up
      % callback after the open button down
      new_azel = getappdata(get(ax,'ZLabel'),'ROTATEAxesView');
      if(rdata.textState)
         set(rdata.textBoxText,'String',...
                 sprintf('Az: %4.0f El: %4.0f',new_azel));
      end
      set(rotaObj, 'View', new_azel);
      return
   end

   rdata.oldFigureUnits = get(gcbf,'Units');
   set(gcbf,'Units','pixels');
   rdata.oldPt = get(gcbf,'CurrentPoint');
   rdata.oldAzEl = get(rdata.targetAxis,'View');

   % Map azel from -180 to 180.
   rdata.oldAzEl = rem(rem(rdata.oldAzEl+360,360)+180,360)-180; 
   if abs(rdata.oldAzEl(2))>90
      % Switch az to other side.
      rdata.oldAzEl(1) = rem(rem(rdata.oldAzEl(1)+180,360)+180,360)-180;
      % Update el
      rdata.oldAzEl(2) = sign(rdata.oldAzEl(2))*(180-abs(rdata.oldAzEl(2)));
   end

   set(rotaObj,'UserData',rdata);
   setOutlineObjToFitAxes(rotaObj);
   copyAxisProps(rdata.targetAxis, rotaObj);

   rdata = get(rotaObj,'UserData');
   if(rdata.oldAzEl(2) < 0)
      rdata.CrossPos = 1;
      set(rdata.outlineObj,'ZData',rdata.scaledData(4,:));
   else
      rdata.CrossPos = 0;
      set(rdata.outlineObj,'ZData',rdata.scaledData(3,:));
   end
   set(rotaObj,'UserData',rdata);
   
   if(rdata.textState)
      fig_color = get(gcbf,'Color');
      c = sum([.3 .6 .1].*fig_color);
      set(rdata.textBoxText,'BackgroundColor',fig_color);
      if(c > .5)
         set(rdata.textBoxText,'ForegroundColor',[0 0 0]);
      else
         set(rdata.textBoxText,'ForegroundColor',[1 1 1]);
      end
      set(rdata.textBoxText,'Visible','on');
   end
   set(rdata.outlineObj,'Visible','on');
   set(gcbf,'WindowButtonMotionFcn','Rotate3DmatNMR(''motion'')');
end

%-------------------------------
% Button up callback
function rotaButtonUpFcn
rotaObj = findobj(allchild(gcbf),'Tag','rotaObj');
if isempty(rotaObj) | ...
    ~strcmp(get(gcbf,'WindowButtonMotionFcn'),'Rotate3DmatNMR(''motion'')')
   return;
else
   set(gcbf,'WindowButtonMotionFcn','');
   rdata = get(rotaObj,'UserData');
   set([rdata.outlineObj rdata.textBoxText],'Visible','off');
   rdata.oldAzEl = get(rotaObj,'View');
   set(rdata.targetAxis,'View',rdata.oldAzEl);
   set(gcbf,'Units',rdata.oldFigureUnits);
   set(rotaObj,'UserData',rdata)
end

%-----------------------------
% Mouse motion callback
function rotaMotionFcn
rotaObj = findobj(allchild(gcbf),'Tag','rotaObj');
rdata = get(rotaObj,'UserData');
new_pt = get(gcbf,'CurrentPoint');
old_pt = rdata.oldPt;
dx = new_pt(1) - old_pt(1);
dy = new_pt(2) - old_pt(2);
new_azel = mappingFunction(rdata, dx, dy);
set(rotaObj,'View',new_azel);
if(new_azel(2) < 0 & rdata.crossPos == 0)
   set(rdata.outlineObj,'ZData',rdata.scaledData(4,:));
   rdata.crossPos = 1;
   set(rotaObj,'UserData',rdata);
end
if(new_azel(2) > 0 & rdata.crossPos == 1) 
   set(rdata.outlineObj,'ZData',rdata.scaledData(3,:));
   rdata.crossPos = 0;
   set(rotaObj,'UserData',rdata);
end
if(rdata.textState)
   set(rdata.textBoxText,'String',sprintf('Az: %4.0f El: %4.0f',new_azel));
end

%----------------------------
% Map a dx dy to an azimuth and elevation
function azel = mappingFunction(rdata, dx, dy)
delta_az = round(rdata.GAIN*(-dx));
delta_el = round(rdata.GAIN*(-dy));
azel(1) = rdata.oldAzEl(1) + delta_az;
azel(2) = min(max(rdata.oldAzEl(2) + 2*delta_el,-90),90);
if abs(azel(2))>90
   % Switch az to other side.
   azel(1) = rem(rem(azel(1)+180,360)+180,360)-180; % Map new az from -180 to 180.
   % Update el
   azel(2) = sign(azel(2))*(180-abs(azel(2)));
end

%-----------------------------
% Scale data to fit target axes limits
function setOutlineObjToFitAxes(rotaObj)
rdata = get(rotaObj,'UserData');
ax = rdata.targetAxis;
x_extent = get(ax,'XLim');
y_extent = get(ax,'YLim');
z_extent = get(ax,'ZLim');
X = rdata.outlineData;
X(1,:) = X(1,:)*diff(x_extent) + x_extent(1);
X(2,:) = X(2,:)*diff(y_extent) + y_extent(1);
X(3,:) = X(3,:)*diff(z_extent) + z_extent(1);
X(4,:) = X(4,:)*diff(z_extent) + z_extent(1);
set(rdata.outlineObj,'XData',X(1,:),'YData',X(2,:),'ZData',X(3,:));
rdata.scaledData = X;
set(rotaObj,'UserData',rdata);

%-------------------------------
% Copy properties from one axes to another.
function copyAxisProps(original, dest)
props = {
   'DataAspectRatio'
   'DataAspectRatioMode'
   'CameraViewAngle'
   'CameraViewAngleMode'
   'XLim'
   'YLim'
   'ZLim'
   'PlotBoxAspectRatio'
   'PlotBoxAspectRatioMode'
   'Units'
   'Position'
   'View'
   'Projection'
};
values = get(original,props);
set(dest,props,values);

%-------------------------------------------
% Constructor for the Rotate object.
function rotaObj = makeRotaObj(fig)

% save the previous state of the figure window
rdata.uistate = uiclearmode(fig,'Rotate3DmatNMR',fig,'off');

rdata.targetAxis = []; % Axis that is being rotated (target axis)
rdata.GAIN    = 0.4;    % Motion gain
rdata.oldPt   = [];  % Point where the button down happened
rdata.oldAzEl = [];
curax = get(fig,'currentaxes');
rotaObj = axes('Parent',fig,'Visible','off','HandleVisibility','off','Drawmode','fast');
% Data points for the outline box.
rdata.outlineData = [0 0 1 0;0 1 1 0;1 1 1 0;1 1 0 1;0 0 0 1;0 0 1 0; ...
      1 0 1 0;1 0 0 1;0 0 0 1;0 1 0 1;1 1 0 1;1 0 0 1;0 1 0 1;0 1 1 0; ...
      NaN NaN NaN NaN;1 1 1 0;1 0 1 0]'; 
rdata.outlineObj = line(rdata.outlineData(1,:),rdata.outlineData(2,:),rdata.outlineData(3,:), ...
   'Parent',rotaObj,'Erasemode','xor','Visible','off','HandleVisibility','off', ...
   'Clipping','off');

% Make text box.
rdata.textBoxText = uicontrol('parent',fig,'Units','Pixels','Position',[2 2 130 20],'Visible','off', ...
   'Style','text','HandleVisibility','off');

rdata.textState = [];
rdata.oldFigureUnits = '';
rdata.crossPos = 0;  % where do we put the X at zmin or zmax? 0 means zmin 1 means zmax
rdata.scaledData = rdata.outlineData;

set(fig,'WindowButtonDownFcn','Rotate3DmatNMR(''down'')');
set(fig,'WindowButtonUpFcn'  ,'Rotate3DmatNMR(''up'')');
set(fig,'WindowButtonMotionFcn','');

set(rotaObj,'Tag','rotaObj','UserData',rdata);
set(fig,'currentaxes',curax)

%----------------------------------
% Deactivate rotate object
function destroyRotaObj(rotaObj)
rdata = get(rotaObj,'UserData');

uirestore(rdata.uistate);

delete(rdata.textBoxText);
delete(rotaObj);
