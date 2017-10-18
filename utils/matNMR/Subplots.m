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
%Subplots.m handles the creation of subplots in the contour and mesh window. The axes are
%selectable (the 'hittest' property is 'on', 'buttondownfcn', 'SelectAxis', 'nextplot', 'replacechildren') by clicking the mouse when the pointer is on them.
%
%Remember to change RestoreSubplots.m if changes are made to subplot configurations!!!
%
%06-07-'98

function Subplots(FigHandle, Var, UserDefValues)

%check input
  if (nargin == 2)
    UserDefValues = [];
    
    if Var == 99 	%if the current grid is user-defined, we revert to a single axis grid
      Var = 1;
    end
  end

%variables are needed to set the axis properties correct
  global QmatNMR QmatNMRsettings

%delete all existing axes; the allchild is needed to delete the axis for the supertitle which handle is invisible
  delete(findobj(allchild(FigHandle), 'type', 'axes'));

%create a variable to remember all axes handles
  QTEMP4 = [];

%create an axis for the super-title.
  QTEMP3 = axes('Position', [0 0 1 1], 'drawmode', 'fast', 'hittest', 'off', 'tag', 'SuperTitleAxis', 'selected', 'off');
  QTEMP = text('position', [0.5 0.98 0]);
  QTEMP1.posdata = [0 0 0];
  set(QTEMP, 'hittest', 'on', 'tag', 'SuperTitle', 'userdata', QTEMP1, 'buttondownfcn', 'SelectFigure; contzoomOFF; MoveAxis', 'fontsize', QmatNMR.TextSize+10);
  axis off
  set(QTEMP3, 'handlevisibility', 'off');	%this is needed to prevent rotate3d.m from accessing this axis
  
%create the new axes
  QmatNMR.ContSubplots = Var;
  QmatNMR.AxisNR2D3D = 1;
  switch Var,
  
  case 1,				%1x1
    QTEMP4 = [QTEMP4 axes('Position', [0.10 0.10 0.80 0.80], 'userdata', 1, 'parent', FigHandle)];
    NrAxes = 1;

        
  case 3,				%2x1
    QTEMP4 = [QTEMP4 axes('Position', [0.10 0.55 0.80 0.35], 'userdata', 1, 'parent', FigHandle)];
    QTEMP4 = [QTEMP4 axes('Position', [0.10 0.10 0.80 0.35], 'userdata', 2, 'parent', FigHandle)];
    NrAxes = 2;
        
        
  case 14,				%3x1
    QTEMP4 = [QTEMP4 axes('Position', [0.10 0.68 0.80 0.22], 'userdata', 1, 'parent', FigHandle)];
    QTEMP4 = [QTEMP4 axes('Position', [0.10 0.39 0.80 0.22], 'userdata', 2, 'parent', FigHandle)];
    QTEMP4 = [QTEMP4 axes('Position', [0.10 0.10 0.80 0.22], 'userdata', 3, 'parent', FigHandle)];
    NrAxes = 3;
        
        
  case 15,				%4x1
    QTEMP4 = [QTEMP4 axes('Position', [0.10 0.76 0.80 0.17], 'userdata', 1, 'parent', FigHandle)];
    QTEMP4 = [QTEMP4 axes('Position', [0.10 0.53 0.80 0.17], 'userdata', 2, 'parent', FigHandle)];
    QTEMP4 = [QTEMP4 axes('Position', [0.10 0.30 0.80 0.17], 'userdata', 3, 'parent', FigHandle)];
    QTEMP4 = [QTEMP4 axes('Position', [0.10 0.07 0.80 0.17], 'userdata', 4, 'parent', FigHandle)];
    NrAxes = 4;
        
        
  case 16,				%5x1
    QTEMP4 = [QTEMP4 axes('Position', [0.10 0.79 0.80 0.15], 'userdata', 1, 'parent', FigHandle)];
    QTEMP4 = [QTEMP4 axes('Position', [0.10 0.61 0.80 0.15], 'userdata', 2, 'parent', FigHandle)];
    QTEMP4 = [QTEMP4 axes('Position', [0.10 0.43 0.80 0.15], 'userdata', 3, 'parent', FigHandle)];
    QTEMP4 = [QTEMP4 axes('Position', [0.10 0.25 0.80 0.15], 'userdata', 4, 'parent', FigHandle)];
    QTEMP4 = [QTEMP4 axes('Position', [0.10 0.07 0.80 0.15], 'userdata', 5, 'parent', FigHandle)];
    NrAxes = 5;
        
        
  case 17,				%6x1
    QTEMP4 = [QTEMP4 axes('Position', [0.10 0.85 0.80 0.10], 'userdata', 1, 'parent', FigHandle)];
    QTEMP4 = [QTEMP4 axes('Position', [0.10 0.69 0.80 0.10], 'userdata', 2, 'parent', FigHandle)];
    QTEMP4 = [QTEMP4 axes('Position', [0.10 0.53 0.80 0.10], 'userdata', 3, 'parent', FigHandle)];
    QTEMP4 = [QTEMP4 axes('Position', [0.10 0.37 0.80 0.10], 'userdata', 4, 'parent', FigHandle)];
    QTEMP4 = [QTEMP4 axes('Position', [0.10 0.21 0.80 0.10], 'userdata', 5, 'parent', FigHandle)];
    QTEMP4 = [QTEMP4 axes('Position', [0.10 0.05 0.80 0.10], 'userdata', 6, 'parent', FigHandle)];
    NrAxes = 6;

    
  case 2,				%1x2
    QTEMP4 = [QTEMP4 axes('Position', [0.10 0.10 0.35 0.80], 'userdata', 1, 'parent', FigHandle)];
    QTEMP4 = [QTEMP4 axes('Position', [0.55 0.10 0.35 0.80], 'userdata', 2, 'parent', FigHandle)];
    NrAxes = 2;

        
  case 4,				%2x2
    QTEMP4 = [QTEMP4 axes('Position', [0.10 0.55 0.35 0.35], 'userdata', 1, 'parent', FigHandle)];
    QTEMP4 = [QTEMP4 axes('Position', [0.55 0.55 0.35 0.35], 'userdata', 2, 'parent', FigHandle)];
    QTEMP4 = [QTEMP4 axes('Position', [0.10 0.10 0.35 0.35], 'userdata', 3, 'parent', FigHandle)];
    QTEMP4 = [QTEMP4 axes('Position', [0.55 0.10 0.35 0.35], 'userdata', 4, 'parent', FigHandle)];
    NrAxes = 4;

    
  case 8,				%3x2
    QTEMP4 = [QTEMP4 axes('Position', [0.10 0.68 0.35 0.22], 'userdata', 1, 'parent', FigHandle)];
    QTEMP4 = [QTEMP4 axes('Position', [0.55 0.68 0.35 0.22], 'userdata', 2, 'parent', FigHandle)];
    QTEMP4 = [QTEMP4 axes('Position', [0.10 0.39 0.35 0.22], 'userdata', 3, 'parent', FigHandle)];
    QTEMP4 = [QTEMP4 axes('Position', [0.55 0.39 0.35 0.22], 'userdata', 4, 'parent', FigHandle)];
    QTEMP4 = [QTEMP4 axes('Position', [0.10 0.10 0.35 0.22], 'userdata', 5, 'parent', FigHandle)];
    QTEMP4 = [QTEMP4 axes('Position', [0.55 0.10 0.35 0.22], 'userdata', 6, 'parent', FigHandle)];
    NrAxes = 6;

    
  case 19,        %4x2
    QTEMP4 = [QTEMP4 axes('Position', [0.10 0.76 0.35 0.17], 'userdata', 1, 'parent', FigHandle)];
    QTEMP4 = [QTEMP4 axes('Position', [0.55 0.76 0.35 0.17], 'userdata', 2, 'parent', FigHandle)];
    QTEMP4 = [QTEMP4 axes('Position', [0.10 0.53 0.35 0.17], 'userdata', 3, 'parent', FigHandle)];
    QTEMP4 = [QTEMP4 axes('Position', [0.55 0.53 0.35 0.17], 'userdata', 4, 'parent', FigHandle)];
    QTEMP4 = [QTEMP4 axes('Position', [0.10 0.30 0.35 0.17], 'userdata', 5, 'parent', FigHandle)];
    QTEMP4 = [QTEMP4 axes('Position', [0.55 0.30 0.35 0.17], 'userdata', 6, 'parent', FigHandle)];
    QTEMP4 = [QTEMP4 axes('Position', [0.10 0.07 0.35 0.17], 'userdata', 7, 'parent', FigHandle)];
    QTEMP4 = [QTEMP4 axes('Position', [0.55 0.07 0.35 0.17], 'userdata', 8, 'parent', FigHandle)];
    NrAxes = 8;

    
  case 35,        %5x2
    for tel1=1:5
      for tel2=1:2
        QTEMP4 = [QTEMP4 axes('Position', [0.10+(tel2-1)*0.45 0.79-(tel1-1)*0.18 0.35 0.15], 'userdata', (tel1-1)*4+tel2, 'parent', FigHandle)];
      end
    end     
    NrAxes = 10;

    
  case 7,				%2x3
    QTEMP4 = [QTEMP4 axes('Position', [0.10 0.55 0.22 0.35], 'userdata', 1, 'parent', FigHandle)];
    QTEMP4 = [QTEMP4 axes('Position', [0.39 0.55 0.22 0.35], 'userdata', 2, 'parent', FigHandle)];
    QTEMP4 = [QTEMP4 axes('Position', [0.69 0.55 0.22 0.35], 'userdata', 3, 'parent', FigHandle)];
    QTEMP4 = [QTEMP4 axes('Position', [0.10 0.10 0.22 0.35], 'userdata', 4, 'parent', FigHandle)];
    QTEMP4 = [QTEMP4 axes('Position', [0.39 0.10 0.22 0.35], 'userdata', 5, 'parent', FigHandle)];
    QTEMP4 = [QTEMP4 axes('Position', [0.69 0.10 0.22 0.35], 'userdata', 6, 'parent', FigHandle)];
    NrAxes = 6;

        
  case 5,				%3x3
    for tel1=1:3
      for tel2=1:3
        QTEMP4 = [QTEMP4 axes('Position', [0.10+(tel2-1)*0.29 0.68-(tel1-1)*0.29 0.22 0.22], 'userdata', (tel1-1)*3+tel2, 'parent', FigHandle)];
      end
    end     
    NrAxes = 9;
  

  case 12,				%4x3
    for tel1=1:4
      for tel2=1:3
        QTEMP4 = [QTEMP4 axes('Position', [0.10+(tel2-1)*0.29 0.76-(tel1-1)*0.23 0.22 0.17], 'userdata', (tel1-1)*3+tel2, 'parent', FigHandle)];
      end
    end     
    NrAxes = 12;

    
  case 18,				%2x4
    for tel1=1:2
      for tel2=1:4
        QTEMP4 = [QTEMP4 axes('Position', [0.07+(tel2-1)*0.23 0.55-(tel1-1)*0.45 0.17 0.35], 'userdata', (tel1-1)*4+tel2, 'parent', FigHandle)];
      end
    end     
    NrAxes = 8;


  case 11,				%3x4
    for tel1=1:3
      for tel2=1:4
        QTEMP4 = [QTEMP4 axes('Position', [0.07+(tel2-1)*0.23 0.68-(tel1-1)*0.29 0.17 0.22], 'userdata', (tel1-1)*4+tel2, 'parent', FigHandle)];
      end
    end     
    NrAxes = 12;
  
        
  case 6,				%4x4
    for tel1=1:4
      for tel2=1:4
        QTEMP4 = [QTEMP4 axes('Position', [0.07+(tel2-1)*0.23 0.76-(tel1-1)*0.23 0.17 0.17], 'userdata', (tel1-1)*4+tel2, 'parent', FigHandle)];
      end
    end     
    NrAxes = 16;
 
    
  case 31,				%5x4
    for tel1=1:5
      for tel2=1:4
        QTEMP4 = [QTEMP4 axes('Position', [0.07+(tel2-1)*0.23 0.79-(tel1-1)*0.18 0.17 0.15], 'userdata', (tel1-1)*4+tel2, 'parent', FigHandle)];
      end
    end     
    NrAxes = 20;
 
    
  case 32,				%6x4
    for tel1=1:6
      for tel2=1:4
        QTEMP4 = [QTEMP4 axes('Position', [0.07+(tel2-1)*0.23 0.81-(tel1-1)*0.15 0.17 0.12], 'userdata', (tel1-1)*4+tel2, 'parent', FigHandle)];
      end
    end     
    NrAxes = 24;
 
    
  case 33,				%7x4
    for tel1=1:7
      for tel2=1:4
        QTEMP4 = [QTEMP4 axes('Position', [0.07+(tel2-1)*0.23 0.84-(tel1-1)*0.13 0.17 0.10], 'userdata', (tel1-1)*4+tel2, 'parent', FigHandle)];
      end
    end     
    NrAxes = 28;
 
    
  case 34,				%8x4
    for tel1=1:8
      for tel2=1:4
        QTEMP4 = [QTEMP4 axes('Position', [0.07+(tel2-1)*0.23 0.84-(tel1-1)*0.11 0.17 0.10], 'userdata', (tel1-1)*4+tel2, 'parent', FigHandle)];
      end
    end     
    NrAxes = 32;
 
    
  case 13,				%4x5
    for tel1=1:4
      for tel2=1:5
        QTEMP4 = [QTEMP4 axes('Position', [0.08+(tel2-1)*0.18 0.73-(tel1-1)*0.21 0.15 0.16], 'userdata', (tel1-1)*5+tel2, 'parent', FigHandle)];
      end
    end     
    NrAxes = 20;


  case 9,				%5x5
    for tel1=1:5
      for tel2=1:5
        QTEMP4 = [QTEMP4 axes('Position', [0.08+(tel2-1)*0.18 0.79-(tel1-1)*0.18 0.15 0.15], 'userdata', (tel1-1)*5+tel2, 'parent', FigHandle)];
      end
    end     
    NrAxes = 25;


  case 30,				%6x5
    for tel1=1:6
      for tel2=1:5
        QTEMP4 = [QTEMP4 axes('Position', [0.08+(tel2-1)*0.18 0.81-(tel1-1)*0.15 0.15 0.12], 'userdata', (tel1-1)*5+tel2, 'parent', FigHandle)];
      end
    end     
    NrAxes = 30;


  case 10,				%6x6
    for tel1=1:6
      for tel2=1:6
        QTEMP4 = [QTEMP4 axes('Position', [0.04+(tel2-1)*0.16 0.81-(tel1-1)*0.15 0.12 0.12], 'userdata', (tel1-1)*6+tel2, 'parent', FigHandle)];
      end
    end     
    NrAxes = 36;
    


  case 20,				%7x7
    for tel1=1:7
      for tel2=1:7
        QTEMP4 = [QTEMP4 axes('Position', [0.06+(tel2-1)*0.13 0.84-(tel1-1)*0.13 0.10 0.10], 'userdata', (tel1-1)*7+tel2, 'parent', FigHandle)];
      end
    end     
    NrAxes = 49;
    


  case 21,				%8x8
    for tel1=1:8
      for tel2=1:8
        QTEMP4 = [QTEMP4 axes('Position', [0.06+(tel2-1)*0.11 0.84-(tel1-1)*0.11 0.10 0.10], 'userdata', (tel1-1)*8+tel2, 'parent', FigHandle)];
      end
    end     
    NrAxes = 64;
    


  case 22,				%9x9
    for tel1=1:9
      for tel2=1:9
        QTEMP4 = [QTEMP4 axes('Position', [0.05+(tel2-1)*0.10 0.86-(tel1-1)*0.10 0.092 0.092], 'userdata', (tel1-1)*9+tel2, 'parent', FigHandle)];
      end
    end     
    NrAxes = 81;
    


  case 23,				%10x10
    for tel1=1:10
      for tel2=1:10
        QTEMP4 = [QTEMP4 axes('Position', [0.05+(tel2-1)*0.09 0.87-(tel1-1)*0.09 0.083 0.083], 'userdata', (tel1-1)*10+tel2, 'parent', FigHandle)];
      end
    end     
    NrAxes = 100;
    


  case 24,				%11x11
    for tel1=1:11
      for tel2=1:11
        QTEMP4 = [QTEMP4 axes('Position', [0.049+(tel2-1)*0.082 0.88-(tel1-1)*0.082 0.075 0.075], 'userdata', (tel1-1)*11+tel2, 'parent', FigHandle)];
      end
    end     
    NrAxes = 121;
    


  case 25,				%12x12
    for tel1=1:12
      for tel2=1:12
        QTEMP4 = [QTEMP4 axes('Position', [0.05+(tel2-1)*0.075 0.885-(tel1-1)*0.075 0.068 0.068], 'userdata', (tel1-1)*12+tel2, 'parent', FigHandle)];
      end
    end     
    NrAxes = 144;
    


  case 26,				%13x13
    for tel1=1:13
      for tel2=1:13
        QTEMP4 = [QTEMP4 axes('Position', [0.045+(tel2-1)*0.07 0.890-(tel1-1)*0.07 0.063 0.063], 'userdata', (tel1-1)*13+tel2, 'parent', FigHandle)];
      end
    end     
    NrAxes = 169;
    


  case 29,				%14x14
    for tel1=1:14
      for tel2=1:14
        QTEMP4 = [QTEMP4 axes('Position', [0.045+(tel2-1)*0.065 0.890-(tel1-1)*0.065 0.059 0.059], 'userdata', (tel1-1)*14+tel2, 'parent', FigHandle)];
      end
    end     
    NrAxes = 196;
    


  case 27,				%19x19
    for tel1=1:19
      for tel2=1:19
        QTEMP4 = [QTEMP4 axes('Position', [0.0535+(tel2-1)*0.047 0.890-(tel1-1)*0.047 0.04 0.04], 'userdata', (tel1-1)*19+tel2, 'parent', FigHandle)];
      end
    end     
    NrAxes = 361;
    


  case 28,				%37x37
    for tel1=1:37
      for tel2=1:37
        QTEMP4 = [QTEMP4 axes('Position', [0.0535+(tel2-1)*0.0243 0.890-(tel1-1)*0.0243 0.023 0.023], 'userdata', (tel1-1)*37+tel2, 'parent', FigHandle)];
      end
    end     
    NrAxes = 1369;
    


  case 99,				%user-defined
    %
    %The UserDefValues should be a vector with [NrPlotsX OffsetX WidthAxisX SpaceX NrPlotsY OffsetY WidthAxisY SpaceY]
    %
    NrPlotsX   = UserDefValues(1);
    OffsetX    = UserDefValues(2);
    WidthAxisX = UserDefValues(3);
    SpaceX     = UserDefValues(4);
    NrPlotsY   = UserDefValues(5);
    OffsetY    = UserDefValues(6);
    WidthAxisY = UserDefValues(7);
    SpaceY     = UserDefValues(8);
    for tel1=1:NrPlotsY
      for tel2=1:NrPlotsX
        QTEMP4 = [QTEMP4 axes('Position', [OffsetX+(tel2-1)*SpaceX OffsetY-(tel1-1)*SpaceY WidthAxisX WidthAxisY], 'userdata', (tel1-1)*NrPlotsX+tel2, 'parent', FigHandle)];
      end
    end     
    NrAxes = NrPlotsX*NrPlotsY;
    QmatNMR.ContSubplots = [Var UserDefValues];



  otherwise
    disp('matNMR ERROR: unknown type specified for Subplots.m. Refusing to act ...');
    beep
    return
  end  



%
%set a common tag to denote that these are regular axes
%
set(QTEMP4, 'tag', 'RegularAxis');


%
%set the colours of the colour scheme for the axes and the titles
%
set(QTEMP4, 'Color', QmatNMR.ColorScheme.AxisBack, ...
            'xcolor', QmatNMR.ColorScheme.AxisFore, ...
            'ycolor', QmatNMR.ColorScheme.AxisFore, ...
            'zcolor', QmatNMR.ColorScheme.AxisFore);
for QTEMP98 = 1:length(QTEMP4)
  set(get(QTEMP4(QTEMP98), 'title'), 'color', QmatNMR.ColorScheme.AxisFore);
end


%
%remove axis labels if a certain threshold is surpassed
%
  if (NrAxes >= 25)
    set(QTEMP4, 'xtick', [], 'ytick', []);
  
    for QTEMP98 = 1:length(QTEMP4)
      set(get(QTEMP4(QTEMP98), 'xlabel'), 'string', '');
      set(get(QTEMP4(QTEMP98), 'ylabel'), 'string', '');
      set(get(QTEMP4(QTEMP98), 'zlabel'), 'string', '');
      set(get(QTEMP4(QTEMP98), 'title'), 'string', '');
    end
  end



%set all the current default axis and text properties
  CurAxis = findobj(allchild(FigHandle), 'type', 'axes');
  
  set(CurAxis, 'drawmode', 'fast', 'hittest', 'on', 'buttondownfcn', 'SelectAxis', ...
  	       'nextplot', 'replacechildren', 'Color', QmatNMR.ColorScheme.AxisBack, 'xcolor', QmatNMR.ColorScheme.AxisFore, 'ycolor', QmatNMR.ColorScheme.AxisFore, 'zcolor', QmatNMR.ColorScheme.AxisFore);
  
  if (length(CurAxis) > 1)
    tempx = get(CurAxis, 'xlabel');
    tempy = get(CurAxis, 'ylabel');
    tempz = get(CurAxis, 'zlabel');
    AxesChildren = [CurAxis; cat(1, tempx{:}); cat(1, tempy{:}); cat(1, tempz{:})];
  else
    AxesChildren = [CurAxis; get(CurAxis, 'xlabel'); get(CurAxis, 'ylabel'); get(CurAxis, 'zlabel')];
  end   

  set(AxesChildren, 'FontName', QmatNMR.TextFont, 'FontSize', QmatNMR.TextSize, 'FontAngle', QmatNMR.TextAngle, 'FontWeight', QmatNMR.TextWeight);


%write the axes handles in the user data of the current figure
  QTEMP2.AxesHandles = QTEMP4;

%Take care of the Zoom and Rotate3D
  QTEMP2.Zoom = 0;
  QTEMP2.Rotate3D = 0;
  
%turn on the rotate3d if necessary
  if (get(QmatNMR.c16, 'value') == 1)
    Rotate3DmatNMR on
    QTEMP2.Rotate3D = 1;
  end

%
%allocate an array to store the plot type
%
%1 = relative contours
%2 = absolute contours
%3 = mesh/surface plot
%4 = stack 3D plot
%5 = raster plot
%6 = polar plot
%7 = bar plot
%8 = line plot
%
  QTEMP2.PlotType = zeros(1, NrAxes);

%save the flag for the subplots
  if (Var == 99)
    QTEMP2.SubPlots = [Var UserDefValues];
  else
    QTEMP2.SubPlots = Var;
  end

%make axis nr 1 (see tag) the current axis
  QmatNMR.AxisHandle2D3D = QTEMP2.AxesHandles(1);
  set(QmatNMR.AxisHandle2D3D, 'selected', 'on');
  axes(QmatNMR.AxisHandle2D3D);

%turn on the zoom if necessary
  if (get(QmatNMR.c10, 'value') == 1)
    ZoomMatNMR 2D3DViewer on
    QTEMP2.Zoom = 1;
  end  
  
%reset the colorbar indicators and define the current number of subplots
  QmatNMR.ContColorbarIndicator = zeros(1, NrAxes);
  QmatNMR.contcolorbar = QmatNMR.ContColorbarIndicator;

  QTEMP2.ColorBarIndicator = QmatNMR.ContColorbarIndicator;
  QTEMP2.ColorBarHandles = QmatNMR.ContColorbarIndicator;
  QTEMP2.NrAxes = NrAxes;

  set(QmatNMR.c19, 'value', 0);
  QmatNMR.ContNrSubplots = NrAxes;


%set the colormap to the default value (general options menu) if none was defined previously
  if isempty(QmatNMR.CurrentColorMap)
    colormap(eval(QmatNMR.PopupStr2(QmatNMRsettings.DefaultColormap, :)));
    QmatNMR.CurrentColorMap = QmatNMR.PopupStr2(QmatNMRsettings.DefaultColormap, :);

  else
    colormap(eval(QmatNMR.CurrentColorMap));
  end
  QTEMP2.ColorMap = QmatNMR.CurrentColorMap;
  

%reset the z-axis indicator
  QmatNMR.ZAxisIndicator = QmatNMR.ContColorbarIndicator;
  QTEMP2.ZAxisIndicator = QmatNMR.ZAxisIndicator;
  set(QmatNMR.R27, 'value', 0);
  
  
%define the plot parameters for each axis
  for tel=1:NrAxes
    QTEMP2.PlotParams(tel).Name = 'NO_Name';
    QTEMP2.PlotParams(tel).History = 'No History available!';
    QTEMP2.PlotParams(tel).MaxInt  = 0;
    QTEMP2.PlotParams(tel).MinInt  = 0;
    QTEMP2.PlotParams(tel).SizeTD2 = 1;
    QTEMP2.PlotParams(tel).SizeTD1 = 1;
    QTEMP2.PlotParams(tel).AxisProps = ones(1, 4);
    QTEMP2.PlotParams(tel).AnalyserAxisTD2 = 0;
    QTEMP2.PlotParams(tel).AnalyserAxisTD1 = 0;
    QTEMP2.PlotParams(tel).AxisTD2 = 0;
    QTEMP2.PlotParams(tel).AxisTD1 = 0;
    QTEMP2.PlotParams(tel).Hold    = 0;
  end  


%
%set hold status to off by default
%
QmatNMR.Hold2D3D = 0;
set(QmatNMR.c11, 'value', 0);


%
%write all into the userdata of the figure
%renderer is set to painters except for Windows because Matlab 7 screws up the colormap in painters mode
%
  if (QmatNMR.Platform ~= QmatNMR.PlatformPC)
    set(QmatNMR.Fig2D3D, 'userdata', QTEMP2, 'renderer', 'painters');
 
  else
    set(QmatNMR.Fig2D3D, 'userdata', QTEMP2, 'renderer', 'zbuffer');
  end
