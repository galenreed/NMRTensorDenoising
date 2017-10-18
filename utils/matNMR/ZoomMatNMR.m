function ZoomMatNMR(Target, Action)
%ZOOM	Zoom in and out on a 2-D plot.
%	ZOOM ON turns zoom on for the current figure.  Click 
%	the left mouse button to zoom in on the point under the 
%	mouse.  Click the right mouse button to zoom out 
%	(shift-click on the Macintosh).  Each time you click, 
%	the axes limits will be changed by a factor of 2 (in or out).
%	You can also click and drag to zoom into an area.
%	
%	ZOOM OFF turns zoom off. ZOOM with no arguments 
%	toggles the zoom status.  ZOOM OUT returns the plot
%	to its initial (full) zoom.

%	Clay M. Thompson 1-25-93
%	Revised 11 Jan 94 by Steven L. Eddins
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	$Revision: 1.10 $  $Date: 1994/02/14 17:00:34 $

%
%   Matlab 5.3 version of zoom, adjusted for matNMR
%
%   All actions remain the same but a target must be specified first. An unknown target will
%   make the routine use the current figure window (gcf).
%
%   Jacco van Beek

global QmatNMR

if (nargin == 1)
  Action = '';
end


%
%first determine the current axis to operate on
%
if strcmp(Target, 'MainWindow')
  TargetFigure = QmatNMR.Fig;
  TargetAxis = findobj(allchild(TargetFigure), 'tag', 'MainAxis');

  %
  %protect the routine against not finding a target axis to work upon
  %
  if (isempty(TargetAxis))
    TargetAxis = gca;
  end
  
elseif strcmp(Target, '2D3DViewer')
  TargetFigure = QmatNMR.Fig2D3D; 	%current 2D/3D viewer window
  TargetAxis = gca;

  if (TargetAxis ~= QmatNMR.AxisHandle2D3D)
    %
    %Only zoom when the current axis is the one that was clicked inside. Otherwise the
    %axis will be selected AND zoomed into, which is not nice.
    %
    %An exception is made for switching the zoom on or off.
    %
    if ~((strcmp(Action,'off')) | (strcmp(Action,'on')))
      return
    end
  end
  TargetAxis = QmatNMR.AxisHandle2D3D; 	%current axis in the current 2D/3D viewer window
  
  
else
  TargetFigure = gcf; 			%current window
  TargetAxis = gca; 			%current axis
end

set(TargetFigure, 'currentaxes', TargetAxis);

%
%perform a generic check to make sure ALL axes in the figure are in 2D-view mode
%
AllAxesInWindow = findobj(allchild(TargetFigure), 'type', 'axes');
for count=1:length(AllAxesInWindow)
  if any(get(AllAxesInWindow(count),'view')~=[0 90])
%    beep
%    disp('ZoomMatNMR WARNING: Only works for 2-D plots');
    return
  end
end


%
%When no action is specified we toggle the zoom mode status, otherwise we process the action
%
rbbox_mode = 0;
if nargin==1, % Toggle buttondown function
  if ~isempty(strfind(get(TargetFigure,'windowbuttondownfcn'),'ZoomMatNMR'))
    %
    %switch zoom off and uicontextmenu back on (if there is one defined)
    %
    set(TargetFigure, 'windowbuttondownfcn','', 'windowbuttonupfcn','', 'windowbuttonmotionfcn','');

    if strcmp(Target, 'MainWindow')
      QmatNMR.ContextMain = findobj(allchild(TargetFigure), 'tag', 'MainContextMenu');
      set(TargetAxis, 'uicontextmenu', QmatNMR.ContextMain)
      
    elseif strcmp(Target, '2D3DViewer')
      QmatNMR.Context2D3D = findobj(allchild(TargetFigure), 'tag', '2D3DContextMenu');
      set(TargetAxis, 'uicontextmenu', QmatNMR.Context2D3D)
    end

  else
    %
    %switch zoom on and uicontextmenu off
    %
    set(TargetFigure,'windowbuttondownfcn',['ZoomMatNMR(''' Target ''', ''down'')'], ...
                     'windowbuttonupfcn','1;', ...
                     'windowbuttonmotionfcn','', ...
                     'interruptible','on');
    set(TargetAxis, 'uicontextmenu', '', 'interruptible','on')
    figure(TargetFigure)
  end
  return

elseif nargin==2, % Process callbacks
%
% here we use the axis property ApplicationData to retrieve the original zoom limits. In the standard
% version of zoom this used the UserData property of the axis property ZLabel. This is much better!
% Jacco van Beek, 6-4-2007
%
  if isappdata(TargetAxis, 'ZoomLimitsMatNMR')
    limits = getappdata(TargetAxis, 'ZoomLimitsMatNMR');
  else
    %
    %no limits found ... should mean that an axis without a plot was chosen. Extract the current
    %axis limits and use those
    %
    limits = axis;
    setappdata(TargetAxis, 'ZoomLimitsMatNMR', limits);
  end

  if isstr(Action),
    Action = lower(Action);
    if strcmp(Action,'down'),
      %
      % if the axis that was clicked in is not the same as the targetaxis 
      % (restricted by matNMR) then zoom is refused.
      % Note that the point in the figure where the mouse button was clicked
      % may fall into multiple axes. Only the axis that is on top will be chosen
      % all others will never be used.
      %
      ax = get(TargetFigure,'Children');
      ZOOM_found = 0;
      for Qii=1:length(ax),
        if strcmp(get(ax(Qii),'Type'),'axes'),
          ZOOM_Pt1 = get(ax(Qii),'CurrentPoint');
          xlim = get(ax(Qii),'XLim');
          ylim = get(ax(Qii),'YLim');
          
          if (xlim(1) <= ZOOM_Pt1(1,1) & ZOOM_Pt1(1,1) <= xlim(2) & ...
              ylim(1) <= ZOOM_Pt1(1,2) & ZOOM_Pt1(1,2) <= ylim(2))

            if (TargetAxis == ax(Qii))
              ZOOM_found = 1;
            end

            break
          end
        end
      end

      if ZOOM_found==0, return, end

      % Check for selection type
      selection_type = get(TargetFigure,'SelectionType');
      if (strcmp(selection_type, 'normal'))
        % Zoom in
        Action = 1;
      elseif (strcmp(selection_type, 'open'))
        % Zoom all the way out
        ZoomMatNMR(Target, 'out');
        return;
      else
        % Zoom partially out
        Action = -1;
      end
      
      ZOOM_Pt1 = get(TargetAxis,'currentpoint');
      ZOOM_Pt2 = ZOOM_Pt1;
      center = ZOOM_Pt1(1,1:2);
      
      if (Action == 1)
        % Zoom in
        rbbox([get(TargetFigure,'currentpoint') 0 0],get(TargetFigure,'currentpoint'))
        ZOOM_Pt2 = get(TargetAxis,'currentpoint');

        % Note the currenpoint is set by having a non-trivial up function.
        if min(abs(ZOOM_Pt1(1,1:2)-ZOOM_Pt2(1,1:2))) >= ...
	      min(.01*[diff(get(TargetAxis,'xlim')) diff(get(TargetAxis,'ylim'))]),
          % determine axis from rbbox 
          a = [ZOOM_Pt1(1,1:2);ZOOM_Pt2(1,1:2)]; a = [min(a);max(a)];
          rbbox_mode = 1;
        end
      end

    elseif strcmp(Action,'on'),
      set(TargetFigure,'windowbuttondownfcn',['ZoomMatNMR(''' Target ''', ''down'')'], ...
              'windowbuttonupfcn','1;', ...
              'windowbuttonmotionfcn','',...
              'interruptible','on');
      set(TargetAxis, 'uicontextmenu', '', 'interruptible','on')
      figure(TargetFigure)       
      return

    elseif strcmp(Action,'off'),
      set(TargetFigure, 'windowbuttondownfcn','', 'windowbuttonupfcn','', 'windowbuttonmotionfcn','');

      if strcmp(Target, 'MainWindow')
        QmatNMR.ContextMain = findobj(allchild(TargetFigure), 'tag', 'MainContextMenu');
        set(TargetAxis, 'uicontextmenu', QmatNMR.ContextMain)
        
      elseif strcmp(Target, '2D3DViewer')
        QmatNMR.Context2D3D = findobj(allchild(TargetFigure), 'tag', '2D3DContextMenu');
        set(TargetAxis, 'uicontextmenu', QmatNMR.Context2D3D)
      end

      return

    elseif strcmp(Action,'out'),
      center = [sum(get(TargetAxis,'Xlim'))/2 sum(get(TargetAxis,'Ylim'))/2];
      Action = -inf; % Zoom totally out
    else
      error(['Unknown option: ',Action,'.']);
    end

  else
    error('Only takes the strings ''on'',''off'', or ''out''.')
  end
end


%
% Actual zoom operation
%
if rbbox_mode,
  axis(a(:)');
  
  %
  %store data for matNMR depending on the target
  %
  if strcmp(Target, 'MainWindow')
    QmatNMR.xmin = a(1);
    QmatNMR.totaalX = a(2) - a(1);
    QmatNMR.ymin = a(3);
    QmatNMR.totaalY = a(4) - a(3);
    
  elseif strcmp(Target, '2D3DViewer')
    QmatNMR.aswaarden = [a(1) a(2) a(3) a(4)];

    updateprojectionaxes
  end

else
  xmin = limits(1); xmax = limits(2); ymin = limits(3); ymax = limits(4);
  if Action==(-inf),
    dx = xmax-xmin;
    dy = ymax-ymin;
  else
    dx = diff(get(TargetAxis,'Xlim'))*(2.^(-Action-1)); dx = min(dx,xmax-xmin);
    dy = diff(get(TargetAxis,'Ylim'))*(2.^(-Action-1)); dy = min(dy,ymax-ymin);
  end

  % Limit zoom.
  center = max(center,[xmin ymin] + [dx dy]);
  center = min(center,[xmax ymax] - [dx dy]);
  axis([max(xmin,center(1)-dx) min(xmax,center(1)+dx) ...
       max(ymin,center(2)-dy) min(ymax,center(2)+dy)])

  
  %
  %store data for matNMR depending on the target
  %
  if strcmp(Target, 'MainWindow')
    QmatNMR.xmin    = max(xmin,center(1)-dx);
    QmatNMR.totaalX = min(xmax,center(1)+dx) - max(xmin,center(1)-dx);
    QmatNMR.ymin    = max(ymin,center(2)-dy);
    QmatNMR.totaalY = min(ymax,center(2)+dy) - max(ymin,center(2)-dy);
    
  elseif strcmp(Target, '2D3DViewer')
    QmatNMR.aswaarden = [max(xmin,center(1)-dx) min(xmax,center(1)+dx) max(ymin,center(2)-dy) min(ymax,center(2)+dy)];
    
    updateprojectionaxes

  end
end


%
%make the target axis the current axis
%
set(TargetFigure, 'currentaxes', TargetAxis);
