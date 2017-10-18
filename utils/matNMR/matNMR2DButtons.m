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
%matNMR2DButtons.m creates the figure window for the 2D/3D Viewer routine
%05-01-'00

try
    %
    %This variable keeps track of how many window have been opened sofar in this session.
    %The number is put into the figure window title as a means of recognition of the window.
    %It will however NOT be updated recursively when a window is deleted.
    %
    QmatNMR.AxisNR2D3D = 1;
    QmatNMR.Q2D3DWindowNumbering = QmatNMR.Q2D3DWindowNumbering + 1;
  
    %for the paper size ...
    QTEMP9 = str2mat('usletter', 'uslegal', 'tabloid', 'A0', 'A1', 'A2', 'A3', 'A4', 'A5', 'B0', 'B1', 'B2', 'B3', 'B4', 'B5', ...
                   'arch-A', 'arch-B', 'arch-C', 'arch-D', 'arch-E', 'A', 'B', 'C', 'D', 'E');
  
    QmatNMR.Fig2D3D = figure('Pointer', 'Arrow', ...
                             'units', 'pixels', ...
                             'Position', [115  48 920 800], ...
                             'Numbertitle', 'off', ...
                             'Resize', 'off', ...
                             'PaperUnits', 'normalized', ...
                             'paperposition', [0.1 0.1 0.8 0.8], ...
                             'backingstore', 'on', ...
                             'Visible', 'off', ...
                             'papertype', deblank(QTEMP9(QmatNMR.PaperSize, :)), 'paperorientation', 'portrait', ...
                             'buttondownfcn', 'SelectFigure', ...
                             'menubar', 'none', ...
                             'Name', [num2str(QmatNMR.Q2D3DWindowNumbering) ' -  2D/3D Viewer for ' QmatNMR.VersionVar '   ---   written by Jacco van Beek   - ' num2str(QmatNMR.Q2D3DWindowNumbering)], ...
                             'tag', '2D/3D Viewer', 'closerequestfcn', 'askclosenmr2d', 'colormap', hsv, ...
                             'color', QmatNMR.ColorScheme.Figure1Back);
    set(QmatNMR.Fig2D3D, 'PaperUnits', 'centimeters');
  
    %
    %create a button to allow selecting this window as the current window
    %
    uicontrol('Parent', QmatNMR.Fig2D3D, 'Style', 'Pushbutton', 'units', 'normalized', 'Position', [0 0.975 0.06 0.025], 'callback', 'SelectFigure', 'String', 'Select', 'backgroundcolor', QmatNMR.ColorScheme.Button4Back, 'foregroundcolor', QmatNMR.ColorScheme.Button4Fore);
  
  
    %
    %set the renderer mode to painters, unless we are working under Windows
    %
    if (QmatNMR.Platform ~= QmatNMR.PlatformPC)
      set(QmatNMR.Fig2D3D, 'renderer', 'painters');
    else  
      set(QmatNMR.Fig2D3D, 'renderer', 'zbuffer');
    end
  
  
    %
    %To work around a Matlab bug (see BugFixes.txt, 11-05-'04) we redefine the position and units.
    %
    set(QmatNMR.Fig2D3D, 'units', 'pixels', 'position', [115  48 920 800]);
  
    QmatNMR.ContAxis = axes('parent', QmatNMR.Fig2D3D, 'Position', [0.1 0.15 0.8 0.8], 'box', 'off', 'drawmode', 'fast', 'hittest', 'on', 'Color', QmatNMR.ColorScheme.AxisBack, 'xcolor', QmatNMR.ColorScheme.AxisFore, 'ycolor', QmatNMR.ColorScheme.AxisFore, 'zcolor', QmatNMR.ColorScheme.AxisFore);
  
    axis('off');
  
  
  %
  % All the items from the menubar
  %
    QmatNMR.c1 = uimenu(QmatNMR.Fig2D3D, 'label', 'Stop 2D/3D', 'position', [1]);
  	uimenu(QmatNMR.c1, 'Label', 'Close Window', 'callback', 'findcurrentfigure; askclosenmr2d', 'accelerator', 'w');
  	uimenu(QmatNMR.c1, 'Label', 'Stop 2D/3D', 'callback', 'findcurrentfigure; askstopnmr2d');
  	uimenu(QmatNMR.c1, 'Label', 'Stop matNMR', 'callback', 'findcurrentfigure; askstopmatnmr', 'separator', 'on');
  	uimenu(QmatNMR.c1, 'Label', 'Quit MATLAB', 'callback', 'findcurrentfigure; asktoquit', 'separator', 'on');
  
    QmatNMR.PP1= uimenu(QmatNMR.Fig2D3D, 'label', 'Plot Manipulations', 'position', [2]);
    uimenu(QmatNMR.PP1, 'label', 'New Window', 'callback', 'findcurrentfigure; makenew2D3D');
    QmatNMR.c102= uimenu(QmatNMR.PP1, 'label', 'Subplots');
  		uimenu(QmatNMR.c102,'label', '1x1'  , 'callback', 'QmatNMR.ContSubplots =  1; makenew2D3DSubplot');
  		uimenu(QmatNMR.c102,'label', '2x1'  , 'callback', 'QmatNMR.ContSubplots =  3; makenew2D3DSubplot');
  		uimenu(QmatNMR.c102,'label', '3x1'  , 'callback', 'QmatNMR.ContSubplots = 14; makenew2D3DSubplot');
  		uimenu(QmatNMR.c102,'label', '4x1'  , 'callback', 'QmatNMR.ContSubplots = 15; makenew2D3DSubplot');
  		uimenu(QmatNMR.c102,'label', '5x1'  , 'callback', 'QmatNMR.ContSubplots = 16; makenew2D3DSubplot');
  		uimenu(QmatNMR.c102,'label', '6x1'  , 'callback', 'QmatNMR.ContSubplots = 17; makenew2D3DSubplot');
  
  		uimenu(QmatNMR.c102,'label', '1x2'  , 'callback', 'QmatNMR.ContSubplots =  2; makenew2D3DSubplot', 'separator', 'on');
  		uimenu(QmatNMR.c102,'label', '2x2'  , 'callback', 'QmatNMR.ContSubplots =  4; makenew2D3DSubplot');
  		uimenu(QmatNMR.c102,'label', '3x2'  , 'callback', 'QmatNMR.ContSubplots =  8; makenew2D3DSubplot');
      uimenu(QmatNMR.c102,'label', '4x2'  , 'callback', 'QmatNMR.ContSubplots = 19; makenew2D3DSubplot');
      uimenu(QmatNMR.c102,'label', '5x2'  , 'callback', 'QmatNMR.ContSubplots = 35; makenew2D3DSubplot');
  
  		uimenu(QmatNMR.c102,'label', '2x3'  , 'callback', 'QmatNMR.ContSubplots =  7; makenew2D3DSubplot', 'separator', 'on');
  		uimenu(QmatNMR.c102,'label', '3x3'  , 'callback', 'QmatNMR.ContSubplots =  5; makenew2D3DSubplot');
  		uimenu(QmatNMR.c102,'label', '4x3'  , 'callback', 'QmatNMR.ContSubplots = 12; makenew2D3DSubplot');
  
  		uimenu(QmatNMR.c102,'label', '2x4'  , 'callback', 'QmatNMR.ContSubplots = 18; makenew2D3DSubplot', 'separator', 'on');
  		uimenu(QmatNMR.c102,'label', '3x4'  , 'callback', 'QmatNMR.ContSubplots = 11; makenew2D3DSubplot');
  		uimenu(QmatNMR.c102,'label', '4x4'  , 'callback', 'QmatNMR.ContSubplots =  6; makenew2D3DSubplot');
  		uimenu(QmatNMR.c102,'label', '5x4'  , 'callback', 'QmatNMR.ContSubplots = 31; makenew2D3DSubplot');
  		uimenu(QmatNMR.c102,'label', '6x4'  , 'callback', 'QmatNMR.ContSubplots = 32; makenew2D3DSubplot');
  		uimenu(QmatNMR.c102,'label', '7x4'  , 'callback', 'QmatNMR.ContSubplots = 33; makenew2D3DSubplot');
  		uimenu(QmatNMR.c102,'label', '8x4'  , 'callback', 'QmatNMR.ContSubplots = 34; makenew2D3DSubplot');
  
  		uimenu(QmatNMR.c102,'label', '4x5'  , 'callback', 'QmatNMR.ContSubplots = 13; makenew2D3DSubplot', 'separator', 'on');
  		uimenu(QmatNMR.c102,'label', '5x5'  , 'callback', 'QmatNMR.ContSubplots =  9; makenew2D3DSubplot');
  		uimenu(QmatNMR.c102,'label', '6x5'  , 'callback', 'QmatNMR.ContSubplots = 30; makenew2D3DSubplot');

  		uimenu(QmatNMR.c102,'label', '6x6'  , 'callback', 'QmatNMR.ContSubplots = 10; makenew2D3DSubplot', 'separator', 'on');
  		uimenu(QmatNMR.c102,'label', '7x7'  , 'callback', 'QmatNMR.ContSubplots = 20; makenew2D3DSubplot');
  		uimenu(QmatNMR.c102,'label', '8x8'  , 'callback', 'QmatNMR.ContSubplots = 21; makenew2D3DSubplot');
  		uimenu(QmatNMR.c102,'label', '9x9'  , 'callback', 'QmatNMR.ContSubplots = 22; makenew2D3DSubplot');
  		uimenu(QmatNMR.c102,'label', '10x10', 'callback', 'QmatNMR.ContSubplots = 23; makenew2D3DSubplot');
  		uimenu(QmatNMR.c102,'label', '11x11', 'callback', 'QmatNMR.ContSubplots = 24; makenew2D3DSubplot');
  		uimenu(QmatNMR.c102,'label', '12x12', 'callback', 'QmatNMR.ContSubplots = 25; makenew2D3DSubplot');
  		uimenu(QmatNMR.c102,'label', '13x13', 'callback', 'QmatNMR.ContSubplots = 26; makenew2D3DSubplot');
  		uimenu(QmatNMR.c102,'label', '14x14', 'callback', 'QmatNMR.ContSubplots = 29; makenew2D3DSubplot');
  		uimenu(QmatNMR.c102,'label', '19x19', 'callback', 'QmatNMR.ContSubplots = 27; makenew2D3DSubplot');
  		uimenu(QmatNMR.c102,'label', '37x37', 'callback', 'QmatNMR.ContSubplots = 28; makenew2D3DSubplot');
  		uimenu(QmatNMR.c102,'label', 'User-defined', 'callback', 'askuserdefsubplots', 'separator', 'on');
  
      uimenu(QmatNMR.PP1, 'label', 'Zoom', 'callback', 'findcurrentfigure; zoomcont');
      uimenu(QmatNMR.PP1, 'label', 'Rotate3D', 'callback', 'findcurrentfigure; rotcont');
  
      QmatNMR.pp1 = uimenu(QmatNMR.PP1, 'label', 'Plotting Functions', 'separator', 'on');
    	uimenu(QmatNMR.pp1, 'label', 'Bar 2D plot', 'callback', 'findcurrentfigure; asknamebar');
    	uimenu(QmatNMR.pp1, 'label', 'Bar 3D plot', 'callback', 'findcurrentfigure; asknamepcolor3d');
    	uimenu(QmatNMR.pp1, 'label', 'Contour plot (abs.)', 'callback', 'findcurrentfigure; asknamecontabs');
    	uimenu(QmatNMR.pp1, 'label', 'Contour plot (rel.)', 'callback', 'findcurrentfigure; asknamecontrel');
    	uimenu(QmatNMR.pp1, 'label', 'Line plot', 'callback', 'findcurrentfigure; asknameline');
    	uimenu(QmatNMR.pp1, 'label', 'Polar plot', 'callback', 'findcurrentfigure; asknamepolarplot');
    	uimenu(QmatNMR.pp1, 'label', 'Raster 2D plot', 'callback', 'findcurrentfigure; asknameraster2D');
    	uimenu(QmatNMR.pp1, 'label', 'Surface plot', 'callback', 'findcurrentfigure; asknamemesh');
    	uimenu(QmatNMR.pp1, 'label', 'Stack 3D plot', 'callback', 'findcurrentfigure; asknamestack3D');
  
      QmatNMR.PP1Features = uimenu(QmatNMR.PP1, 'label', 'Features');
  	    uimenu(QmatNMR.PP1Features, 'label', 'Axis Rulers', 'callback', 'findcurrentfigure; stats2d', 'separator', 'on');
  	    uimenu(QmatNMR.PP1Features, 'label', 'Color Bar', 'callback', 'findcurrentfigure; askcontcbar');
  	    uimenu(QmatNMR.PP1Features, 'label', 'Color Mapping (caxis)', 'callback', 'findcurrentfigure; askcaxis');
  	    uimenu(QmatNMR.PP1Features, 'label', 'Print', 'callback', 'findcurrentfigure; print2D3D');
  	    uimenu(QmatNMR.PP1Features, 'label', 'Super Title', 'callback', 'findcurrentfigure; asksupertitle');
  	    uimenu(QmatNMR.PP1Features, 'label', 'Title / Axis Labels', 'callback', 'findcurrentfigure; QmatNMR.command2 = 0;  clabels');
  
  	    uimenu(QmatNMR.PP1Features, 'label', 'Create Square Plots', 'callback', 'findcurrentfigure; asksquareplots', 'separator', 'on');
  	    uimenu(QmatNMR.PP1Features, 'label', 'Extract Area', 'callback', 'findcurrentfigure; extract', 'separator', 'on');
  	    uimenu(QmatNMR.PP1Features, 'label', 'Define Strip-Plot Limits', 'callback', 'findcurrentfigure; askcutspectrum');
  	    uimenu(QmatNMR.PP1Features, 'label', 'Define Plot Limits', 'callback', 'findcurrentfigure; askdefineplotlimits');
  	    uimenu(QmatNMR.PP1Features, 'label', 'Get Position', 'callback', 'findcurrentfigure; QmatNMR.Crosshair2DSlices = 0; whereamicont');
  	    uimenu(QmatNMR.PP1Features, 'label', 'Get Position + Slices', 'callback', 'findcurrentfigure; QmatNMR.Crosshair2DSlices = 1; whereamicont');
  	    uimenu(QmatNMR.PP1Features, 'label', 'Get Integral', 'callback', 'findcurrentfigure; QmatNMR.IntegrateAction = 1; integrate');
  	    uimenu(QmatNMR.PP1Features, 'label', 'Set Integral', 'callback', 'findcurrentfigure; QmatNMR.IntegrateAction = 2; integrate');
  	    uimenu(QmatNMR.PP1Features, 'label', 'Show Projections', 'callback', 'findcurrentfigure; askshowprojections');
  	    uimenu(QmatNMR.PP1Features, 'label', 'Create CPMs', 'callback', 'findcurrentfigure; askcreateCPMs', 'separator', 'on');
  	    QmatNMR.pp1= uimenu(QmatNMR.PP1Features, 'label', 'Peak Picking');
    		uimenu(QmatNMR.pp1, 'label', 'Peak Picking', 'callback', 'findcurrentfigure; QTEMP1 = 1; peakpick;');
  		uimenu(QmatNMR.pp1, 'label', 'Peak Picking + Draw Lines', 'callback', 'findcurrentfigure; QTEMP1 = 2; peakpick;');
  		uimenu(QmatNMR.pp1, 'label', 'Search Specifications', 'callback', 'findcurrentfigure; askdefpeakpickdir');
  		uimenu(QmatNMR.pp1, 'label', 'Save List to ASCII file', 'callback', 'findcurrentfigure; asknamepeaklist');
  		uimenu(QmatNMR.pp1, 'label', 'Save List in Structure', 'callback', 'findcurrentfigure; asksaveliststructure');
  	  	uimenu(QmatNMR.pp1, 'label', 'Draw all labels', 'callback', 'findcurrentfigure; drawalllabels', 'separator', 'on');
    		uimenu(QmatNMR.pp1, 'label', 'Delete labels', 'callback', 'findcurrentfigure; deletelabels');
  	  	uimenu(QmatNMR.pp1, 'label', 'Delete lines', 'callback', 'findcurrentfigure; deletelines');
    		uimenu(QmatNMR.pp1, 'label', 'Clear List', 'callback', 'findcurrentfigure; QmatNMR.PeakList = []; disp(''Peak List cleared'');');
  	  	uimenu(QmatNMR.pp1, 'label', 'Clear List + Labels', 'callback', 'findcurrentfigure; deletelabels; deletelines; QmatNMR.PeakList = []; disp(''Peak List cleared'');');
  		uimenu(QmatNMR.pp1, 'label', 'Clear Axis vectors from structure', 'callback', 'findcurrentfigure; clearaxesstruct');
  	    uimenu(QmatNMR.PP1Features, 'label', 'Surface-based color mapping', 'callback', 'findcurrentfigure; askSBCM');
  
  
      QmatNMR.PP1Various = uimenu(QmatNMR.PP1, 'label', 'Direct Manipulations');
    	QmatNMR.PP11 = uimenu(QmatNMR.PP1Various, 'label', 'Mouse Pointer', 'separator', 'on');
    		uimenu(QmatNMR.PP11, 'label', 'Arrow', 'callback', 'findcurrentfigure; set(QmatNMR.Fig2D3D, ''pointer'', ''arrow'')');
  		uimenu(QmatNMR.PP11, 'label', 'Arrowhead', 'callback', 'findcurrentfigure; set(QmatNMR.Fig2D3D, ''pointer'', ''Arrowhead'')');
  		uimenu(QmatNMR.PP11, 'label', 'crosshair', 'callback', 'findcurrentfigure; set(QmatNMR.Fig2D3D, ''pointer'', ''crosshair'')');
  		uimenu(QmatNMR.PP11, 'label', 'Ibeam', 'callback', 'findcurrentfigure; set(QmatNMR.Fig2D3D, ''pointer'', ''Ibeam'')');
  		uimenu(QmatNMR.PP11, 'label', 'Circle', 'callback', 'findcurrentfigure; set(QmatNMR.Fig2D3D, ''pointer'', ''circle'')');
  		uimenu(QmatNMR.PP11, 'label', 'Cross', 'callback', 'findcurrentfigure; set(QmatNMR.Fig2D3D, ''pointer'', ''cross'')');
  		uimenu(QmatNMR.PP11, 'label', 'Fleur', 'callback', 'findcurrentfigure; set(QmatNMR.Fig2D3D, ''pointer'', ''fleur'')');
  		uimenu(QmatNMR.PP11, 'label', 'Top', 'callback', 'findcurrentfigure; set(QmatNMR.Fig2D3D, ''pointer'', ''top'')');
  		uimenu(QmatNMR.PP11, 'label', 'Topl', 'callback', 'findcurrentfigure; set(QmatNMR.Fig2D3D, ''pointer'', ''topl'')');
  		uimenu(QmatNMR.PP11, 'label', 'Topr', 'callback', 'findcurrentfigure; set(QmatNMR.Fig2D3D, ''pointer'', ''topr'')');
  		uimenu(QmatNMR.PP11, 'label', 'Left', 'callback', 'findcurrentfigure; set(QmatNMR.Fig2D3D, ''pointer'', ''left'')');
  		uimenu(QmatNMR.PP11, 'label', 'Right', 'callback', 'findcurrentfigure; set(QmatNMR.Fig2D3D, ''pointer'', ''right'')');
  		uimenu(QmatNMR.PP11, 'label', 'Bottom', 'callback', 'findcurrentfigure; set(QmatNMR.Fig2D3D, ''pointer'', ''bottom'')');
  		uimenu(QmatNMR.PP11, 'label', 'Botl', 'callback', 'findcurrentfigure; set(QmatNMR.Fig2D3D, ''pointer'', ''botl'')');
  		uimenu(QmatNMR.PP11, 'label', 'Botr', 'callback', 'findcurrentfigure; set(QmatNMR.Fig2D3D, ''pointer'', ''botr'')');
  		uimenu(QmatNMR.PP11, 'label', 'Watch', 'callback', 'findcurrentfigure; set(QmatNMR.Fig2D3D, ''pointer'', ''watch'')');
  
  	QmatNMR.PP1Axis = uimenu(QmatNMR.PP1Various, 'label', 'Axis properties');
  		uimenu(QmatNMR.PP1Axis, 'label', 'Axis On/Off/Etc', 'callback', 'findcurrentfigure; askaxis');
  		uimenu(QmatNMR.PP1Axis, 'label', 'Clear Axis', 'callback', 'findcurrentfigure; askclearaxis');
  		uimenu(QmatNMR.PP1Axis, 'label', 'Axis Colors', 'callback', 'findcurrentfigure; askaxiscolors');
  		uimenu(QmatNMR.PP1Axis, 'label', 'Axis Directions', 'callback', 'findcurrentfigure; askdirs');
  		uimenu(QmatNMR.PP1Axis, 'label', 'Axis Labels', 'callback', 'findcurrentfigure; askaxislabels');
  		uimenu(QmatNMR.PP1Axis, 'label', 'Axis Locations', 'callback', 'findcurrentfigure; askaxislocation');
  		uimenu(QmatNMR.PP1Axis, 'label', 'Axis Position', 'callback', 'findcurrentfigure; askaxisposition');
  		uimenu(QmatNMR.PP1Axis, 'label', 'Axis View', 'callback', 'findcurrentfigure; askaxisview');
  		uimenu(QmatNMR.PP1Axis, 'label', 'Title', 'callback', 'findcurrentfigure; asktitle');
  
  	uimenu(QmatNMR.PP1Various, 'label', 'Box', 'callback', 'findcurrentfigure; askbox');
  	uimenu(QmatNMR.PP1Various, 'label', 'Font Properties', 'callback', 'findcurrentfigure; askfont');
  	uimenu(QmatNMR.PP1Various, 'label', 'Grid', 'callback', 'findcurrentfigure; askgrid');
  	uimenu(QmatNMR.PP1Various, 'label', 'Hold', 'callback', 'findcurrentfigure; askhold');
  
  	uimenu(QmatNMR.PP1Various, 'label', 'Light', 'callback', 'asklight');
  
  	QmatNMR.PP1Line = uimenu(QmatNMR.PP1Various, 'label', 'Line properties');
  		uimenu(QmatNMR.PP1Line, 'label', 'Line Color', 'callback', 'asklinecolor');
  		QmatNMR.c109= uimenu(QmatNMR.PP1Line, 'label', 'Line Style');
  			uimenu(QmatNMR.c109,'label', '-', 'callback', 'findcurrentfigure; Linestyle(''-''); disp(''Linestyle set to solid'');');
  			uimenu(QmatNMR.c109,'label', '--', 'callback', 'findcurrentfigure; Linestyle(''--''); disp(''Linestyle set to dashed'');');
  			uimenu(QmatNMR.c109,'label', ':', 'callback', 'findcurrentfigure; Linestyle('':''); disp(''Linestyle set to dotted'');');
  			uimenu(QmatNMR.c109,'label', '-.', 'callback', 'findcurrentfigure; Linestyle(''-.''); disp(''Linestyle set to dash-dot'');');
  			uimenu(QmatNMR.c109,'label', 'None', 'callback', 'findcurrentfigure; Linestyle(''none''); disp(''Linestyle set to none'');');
  		QmatNMR.c93 = uimenu(QmatNMR.PP1Line, 'label', 'Line Width');
  			uimenu(QmatNMR.c93, 'label', '0.05', 'callback', 'findcurrentfigure; Linewidth(0.05); disp(''Linewidth set to 0.05 for the current axis'');');	
  			uimenu(QmatNMR.c93, 'label', '0.10', 'callback', 'findcurrentfigure; Linewidth(0.1); disp(''Linewidth set to 0.10 for the current axis'');');	
  			uimenu(QmatNMR.c93, 'label', '0.15', 'callback', 'findcurrentfigure; Linewidth(0.15); disp(''Linewidth set to 0.15 for the current axis'');');	
  			uimenu(QmatNMR.c93, 'label', '0.25', 'callback', 'findcurrentfigure; Linewidth(0.25); disp(''Linewidth set to 0.25 for the current axis'');');	
  			uimenu(QmatNMR.c93, 'label', '0.5', 'callback', 'findcurrentfigure; Linewidth(0.5); disp(''Linewidth set to 0.5 for the current axis'');');	
  			uimenu(QmatNMR.c93, 'label', '1.0', 'callback', 'findcurrentfigure; Linewidth(1.0); disp(''Linewidth set to 1.0 for the current axis'');');	
  			uimenu(QmatNMR.c93, 'label', '1.5', 'callback', 'findcurrentfigure; Linewidth(1.5); disp(''Linewidth set to 1.5 for the current axis'');');	
  			uimenu(QmatNMR.c93, 'label', '2.0', 'callback', 'findcurrentfigure; Linewidth(2.0); disp(''Linewidth set to 2.0 for the current axis'');');	
  			uimenu(QmatNMR.c93, 'label', '3.0', 'callback', 'findcurrentfigure; Linewidth(3.0); disp(''Linewidth set to 3.0 for the current axis'');');	
  			uimenu(QmatNMR.c93, 'label', '4.0', 'callback', 'findcurrentfigure; Linewidth(4.0); disp(''Linewidth set to 4.0 for the current axis'');');	
  			uimenu(QmatNMR.c93, 'label', '5.0', 'callback', 'findcurrentfigure; Linewidth(5.0); disp(''Linewidth set to 5.0 for the current axis'');');	
  			uimenu(QmatNMR.c93, 'label', '6.0', 'callback', 'findcurrentfigure; Linewidth(6.0); disp(''Linewidth set to 6.0 for the current axis'');');	
  			uimenu(QmatNMR.c93, 'label', '7.0', 'callback', 'findcurrentfigure; Linewidth(7.0); disp(''Linewidth set to 7.0 for the current axis'');');	
  			uimenu(QmatNMR.c93, 'label', '8.0', 'callback', 'findcurrentfigure; Linewidth(8.0); disp(''Linewidth set to 8.0 for the current axis'');');	
  			uimenu(QmatNMR.c93, 'label', '9.0', 'callback', 'findcurrentfigure; Linewidth(9.0); disp(''Linewidth set to 9.0 for the current axis'');');	
  			uimenu(QmatNMR.c93, 'label', '10.0', 'callback', 'findcurrentfigure; Linewidth(10.0); disp(''Linewidth set to 10.0 for the current axis'');');	
  		QmatNMR.c110= uimenu(QmatNMR.PP1Line, 'label', 'Marker');
  			uimenu(QmatNMR.c110,'label', 'None', 'callback', 'findcurrentfigure; Marker(''none''); disp(''Marker set to none'');');
  			uimenu(QmatNMR.c110,'label', 'Point', 'callback', 'findcurrentfigure; Marker(''.''); disp(''Marker set to point'');');
  			uimenu(QmatNMR.c110,'label', 'Plus', 'callback', 'findcurrentfigure; Marker(''+''); disp(''Marker set to plus'');');
  			uimenu(QmatNMR.c110,'label', 'Circle', 'callback', 'findcurrentfigure; Marker(''o''); disp(''Marker set to circle'');');
  			uimenu(QmatNMR.c110,'label', 'Asterisk', 'callback', 'findcurrentfigure; Marker(''*''); disp(''Marker set to asterisk'');');
  			uimenu(QmatNMR.c110,'label', 'Cross', 'callback', 'findcurrentfigure; Marker(''x''); disp(''Marker set to cross'');');
  			uimenu(QmatNMR.c110,'label', 'Square', 'callback', 'findcurrentfigure; Marker(''s''); disp(''Marker set to square'');');
  			uimenu(QmatNMR.c110,'label', 'Diamond', 'callback', 'findcurrentfigure; Marker(''d''); disp(''Marker set to triangle diamond'');');
  			uimenu(QmatNMR.c110,'label', 'Triangle up', 'callback', 'findcurrentfigure; Marker(''^''); disp(''Marker set to triangle up'');');
  			uimenu(QmatNMR.c110,'label', 'Triangle down', 'callback', 'findcurrentfigure; Marker(''v''); disp(''Marker set to triangle down'');');
  			uimenu(QmatNMR.c110,'label', 'Triangle right', 'callback', 'findcurrentfigure; Marker(''>''); disp(''Marker set to triangle right'');');
  			uimenu(QmatNMR.c110,'label', 'Triangle left', 'callback', 'findcurrentfigure; Marker(''<''); disp(''Marker set to triangle left'');');
  			uimenu(QmatNMR.c110,'label', 'Pentagram', 'callback', 'findcurrentfigure; Marker(''p''); disp(''Marker set to pentagram'');');
  			uimenu(QmatNMR.c110,'label', 'Hexagram', 'callback', 'findcurrentfigure; Marker(''h''); disp(''Marker set to hexagram'');');
  		QmatNMR.c111= uimenu(QmatNMR.PP1Line, 'label', 'Marker Size');
  			uimenu(QmatNMR.c111, 'label', '0.5', 'callback', 'findcurrentfigure; Markersize(0.5); disp(''Marker Size set to 0.5'');');	
  			uimenu(QmatNMR.c111, 'label', '1.0', 'callback', 'findcurrentfigure; Markersize(1.0); disp(''Marker Size set to 1.0'');');	
  			uimenu(QmatNMR.c111, 'label', '1.5', 'callback', 'findcurrentfigure; Markersize(1.5); disp(''Marker Size set to 1.5'');');	
  			uimenu(QmatNMR.c111, 'label', '2.0', 'callback', 'findcurrentfigure; Markersize(2.0); disp(''Marker Size set to 2.0'');');	
  			uimenu(QmatNMR.c111, 'label', '3.0', 'callback', 'findcurrentfigure; Markersize(3.0); disp(''Marker Size set to 3.0'');');	
  			uimenu(QmatNMR.c111, 'label', '4.0', 'callback', 'findcurrentfigure; Markersize(4.0); disp(''Marker Size set to 4.0'');');	
  			uimenu(QmatNMR.c111, 'label', '5.0', 'callback', 'findcurrentfigure; Markersize(5.0); disp(''Marker Size set to 5.0'');');	
  			uimenu(QmatNMR.c111, 'label', '6.0', 'callback', 'findcurrentfigure; Markersize(6.0); disp(''Marker Size set to 6.0'');');	
  			uimenu(QmatNMR.c111, 'label', '7.0', 'callback', 'findcurrentfigure; Markersize(7.0); disp(''Marker Size set to 7.0'');');	
  			uimenu(QmatNMR.c111, 'label', '8.0', 'callback', 'findcurrentfigure; Markersize(8.0); disp(''Marker Size set to 8.0'');');	
  			uimenu(QmatNMR.c111, 'label', '9.0', 'callback', 'findcurrentfigure; Markersize(9.0); disp(''Marker Size set to 9.0'');');	
  			uimenu(QmatNMR.c111, 'label', '10.0', 'callback', 'findcurrentfigure; Markersize(10.0); disp(''Marker Size set to 10.0'');');	
  
  	uimenu(QmatNMR.PP1Various, 'label', 'Scaling Limits', 'callback', 'findcurrentfigure; asklims');
  	uimenu(QmatNMR.PP1Various, 'label', 'Scaling Types', 'callback', 'findcurrentfigure; askscales');
  	uimenu(QmatNMR.PP1Various, 'label', 'Shading', 'callback', 'findcurrentfigure; askshading');
  	QmatNMR.PP1Tick = uimenu(QmatNMR.PP1Various, 'label', 'Tick properties');
  		uimenu(QmatNMR.PP1Tick, 'label', 'Tick direction', 'callback', 'findcurrentfigure; asktickdir');
  		uimenu(QmatNMR.PP1Tick, 'label', 'Tick Labels', 'callback', 'findcurrentfigure; askticklabel');	
  		uimenu(QmatNMR.PP1Tick, 'label', 'Tick Lengths', 'callback', 'findcurrentfigure; askticklengths');	
  		uimenu(QmatNMR.PP1Tick, 'label', 'Tick Positions', 'callback', 'findcurrentfigure; asktick');
  
    QmatNMR.Hc = uimenu(QmatNMR.Fig2D3D, 'label', 'History / Macro', 'Position', [3]);
    	uimenu(QmatNMR.Hc, 'label', 'Show History', 'callback', 'findcurrentfigure; matnmrhelp(QmatNMR.History2D3D, ''QmatNMR.History2D3D'');');
  	uimenu(QmatNMR.Hc, 'label', 'Start Recording Macro', 'callback', 'QmatNMR.buttonList=1; QmatNMR.uiInput1=2; regelstartrecordingmacro', 'separator', 'on');
  	uimenu(QmatNMR.Hc, 'label', 'Stop Recording Macro', 'callback', 'askstoprecordingmacro');
  	uimenu(QmatNMR.Hc, 'label', 'Execute Macro', 'callback', 'QmatNMR.StepWise = 0; askexecutemacro', 'accelerator', 'e');
  	uimenu(QmatNMR.Hc, 'label', 'Execute Macro Stepwise', 'callback', 'QmatNMR.StepWise = 1; askexecutemacro');
  
    
    QmatNMR.prtc = uimenu(QmatNMR.Fig2D3D, 'label', 'Create Output', 'position', [4]);
    	uimenu(QmatNMR.prtc, 'label', 'Printing Menu', 'callback', 'findcurrentfigure; set(gca, ''selected'', ''off''); matprint', 'accelerator', 'p');
  	uimenu(QmatNMR.prtc, 'label', 'Save plot on disk', 'callback', 'asksavefitdisk');
    	uimenu(QmatNMR.prtc, 'label', 'Copy Figure', 'callback', 'findcurrentfigure; copyfignmr2d');
  	
    QmatNMR.c5 = uimenu(QmatNMR.Fig2D3D, 'label', 'Options', 'position', [5]);
          uimenu(QmatNMR.c5, 'Label', 'Screen Settings', 'callback', 'findcurrentfigure; Qscreenops');
  	uimenu(QmatNMR.c5, 'label', 'Colour Scheme', 'callback', 'Qsetcolorscheme');
    	uimenu(QmatNMR.c5, 'label', 'Text Properties', 'callback', 'findcurrentfigure; Qtextdata');
  		
  
  QTEMP = uimenu(QmatNMR.Fig2D3D, 'label', 'HELP ?', 'position', [6]);
  	uimenu(QTEMP, 'label', 'Copyright', 'callback', 'findcurrentfigure; matnmrhelp(''Copyright.hlp'', ''Copyright'')');
  	uimenu(QTEMP, 'label', 'Help desk', 'callback', ['web file://' QmatNMR.HelpPath filesep 'manual' filesep 'index.html;']);
  
  QmatNMR.clear = uimenu(QmatNMR.Fig2D3D, 'label', 'Clear Functions', 'position', [7]);
  	uimenu(QmatNMR.clear, 'Label', 'Clear Functions', 'callback', 'findcurrentfigure; clear functions; disp(''Clear Functions performed ...''); Arrowhead');
    
  
  
  %
  % All the items from the contextmenu that is connected to the figure window only!
  %
    QmatNMR.Context2D3D = uicontextmenu;
    set(QmatNMR.Context2D3D, 'tag', '2D3DContextMenu');
    set(QmatNMR.Fig2D3D, 'uicontextmenu', QmatNMR.Context2D3D);
  
    uimenu(QmatNMR.Context2D3D, 'label', '  New Window   ', 'callback', 'findcurrentfigure; matNMR2DButtons; Subplots(gcf, QmatNMR.ContSubplots)');
    QmatNMR.c102= uimenu(QmatNMR.Context2D3D, 'label', '  Subplots   ');
  		uimenu(QmatNMR.c102,'label', '1x1', 'callback', 'findcurrentfigure; Subplots(QmatNMR.Fig2D3D,  1);');
  		uimenu(QmatNMR.c102,'label', '2x1', 'callback', 'findcurrentfigure; Subplots(QmatNMR.Fig2D3D,  3);');
  		uimenu(QmatNMR.c102,'label', '3x1', 'callback', 'findcurrentfigure; Subplots(QmatNMR.Fig2D3D, 14);');
  		uimenu(QmatNMR.c102,'label', '4x1', 'callback', 'findcurrentfigure; Subplots(QmatNMR.Fig2D3D, 15);');
  		uimenu(QmatNMR.c102,'label', '5x1', 'callback', 'findcurrentfigure; Subplots(QmatNMR.Fig2D3D, 16);');
  		uimenu(QmatNMR.c102,'label', '6x1', 'callback', 'findcurrentfigure; Subplots(QmatNMR.Fig2D3D, 17);');
  
  		uimenu(QmatNMR.c102,'label', '1x2', 'callback', 'findcurrentfigure; Subplots(QmatNMR.Fig2D3D,  2);', 'separator', 'on');
  		uimenu(QmatNMR.c102,'label', '2x2', 'callback', 'findcurrentfigure; Subplots(QmatNMR.Fig2D3D,  4);');
  		uimenu(QmatNMR.c102,'label', '3x2', 'callback', 'findcurrentfigure; Subplots(QmatNMR.Fig2D3D,  8);');
  		uimenu(QmatNMR.c102,'label', '4x2', 'callback', 'findcurrentfigure; Subplots(QmatNMR.Fig2D3D, 19);');
  
  		uimenu(QmatNMR.c102,'label', '2x3', 'callback', 'findcurrentfigure; Subplots(QmatNMR.Fig2D3D,  7);', 'separator', 'on');
  		uimenu(QmatNMR.c102,'label', '3x3', 'callback', 'findcurrentfigure; Subplots(QmatNMR.Fig2D3D,  5);');
  		uimenu(QmatNMR.c102,'label', '4x3', 'callback', 'findcurrentfigure; Subplots(QmatNMR.Fig2D3D, 12);');
  
  		uimenu(QmatNMR.c102,'label', '2x4', 'callback', 'findcurrentfigure; Subplots(QmatNMR.Fig2D3D, 18);', 'separator', 'on');
  		uimenu(QmatNMR.c102,'label', '3x4', 'callback', 'findcurrentfigure; Subplots(QmatNMR.Fig2D3D, 11);');
  		uimenu(QmatNMR.c102,'label', '4x4', 'callback', 'findcurrentfigure; Subplots(QmatNMR.Fig2D3D,  6);');
  
  		uimenu(QmatNMR.c102,'label', '4x5', 'callback', 'findcurrentfigure; Subplots(QmatNMR.Fig2D3D, 13);', 'separator', 'on');
  		uimenu(QmatNMR.c102,'label', '5x5', 'callback', 'findcurrentfigure; Subplots(QmatNMR.Fig2D3D,  9);');
  
  		uimenu(QmatNMR.c102,'label', '6x6', 'callback', 'findcurrentfigure; Subplots(QmatNMR.Fig2D3D, 10);', 'separator', 'on');
  		uimenu(QmatNMR.c102,'label', '7x7', 'callback', 'findcurrentfigure; Subplots(QmatNMR.Fig2D3D, 20);');
  		uimenu(QmatNMR.c102,'label', '8x8', 'callback', 'findcurrentfigure; Subplots(QmatNMR.Fig2D3D, 21);');
  		uimenu(QmatNMR.c102,'label', '9x9', 'callback', 'findcurrentfigure; Subplots(QmatNMR.Fig2D3D, 22);');
  		uimenu(QmatNMR.c102,'label', '10x10', 'callback', 'findcurrentfigure; Subplots(QmatNMR.Fig2D3D, 23);');
  		uimenu(QmatNMR.c102,'label', '11x11', 'callback', 'findcurrentfigure; Subplots(QmatNMR.Fig2D3D, 24);');
  		uimenu(QmatNMR.c102,'label', '12x12', 'callback', 'findcurrentfigure; Subplots(QmatNMR.Fig2D3D, 25);');
  		uimenu(QmatNMR.c102,'label', '13x13', 'callback', 'findcurrentfigure; Subplots(QmatNMR.Fig2D3D, 26);');
  		uimenu(QmatNMR.c102,'label', '19x19', 'callback', 'findcurrentfigure; Subplots(QmatNMR.Fig2D3D, 27);');
  
      uimenu(QmatNMR.Context2D3D, 'label', '  Zoom   ', 'callback', 'findcurrentfigure; zoomcont');
      uimenu(QmatNMR.Context2D3D, 'label', '  Rotate3D   ', 'callback', 'findcurrentfigure; rotcont');
  
      QmatNMR.pp1 = uimenu(QmatNMR.Context2D3D, 'label', '  Plotting Functions   ', 'separator', 'on');
    	uimenu(QmatNMR.pp1, 'label', 'Bar 2D plot', 'callback', 'findcurrentfigure; asknamebar');
    	uimenu(QmatNMR.pp1, 'label', 'Contour plot (abs.)', 'callback', 'findcurrentfigure; asknamecontabs');
    	uimenu(QmatNMR.pp1, 'label', 'Contour plot (rel.)', 'callback', 'findcurrentfigure; asknamecontrel');
    	uimenu(QmatNMR.pp1, 'label', 'Line plot', 'callback', 'findcurrentfigure; asknameline');
    	uimenu(QmatNMR.pp1, 'label', 'Polar plot', 'callback', 'findcurrentfigure; asknamepolarplot');
    	uimenu(QmatNMR.pp1, 'label', 'Raster 2D plot', 'callback', 'findcurrentfigure; asknameraster2D');
    	uimenu(QmatNMR.pp1, 'label', 'Surface plot', 'callback', 'findcurrentfigure; asknamemesh');
    	uimenu(QmatNMR.pp1, 'label', 'Stack 3D plot', 'callback', 'findcurrentfigure; asknamestack3D');
  
      QmatNMR.PP1Features = uimenu(QmatNMR.Context2D3D, 'label', '  Features   ');
  	    uimenu(QmatNMR.PP1Features, 'label', 'Axis Rulers', 'callback', 'findcurrentfigure; stats2d', 'separator', 'on');
  	    uimenu(QmatNMR.PP1Features, 'label', 'Color Bar', 'callback', 'findcurrentfigure; askcontcbar');
  	    uimenu(QmatNMR.PP1Features, 'label', 'Color Mapping (caxis)', 'callback', 'findcurrentfigure; askcaxis');
  	    uimenu(QmatNMR.PP1Features, 'label', 'Print', 'callback', 'findcurrentfigure; print2D3D');
  	    uimenu(QmatNMR.PP1Features, 'label', 'Super Title', 'callback', 'findcurrentfigure; asksupertitle');
  	    uimenu(QmatNMR.PP1Features, 'label', 'Title / Axis Labels', 'callback', 'findcurrentfigure; QmatNMR.command2 = 0;  clabels');
  
  	    uimenu(QmatNMR.PP1Features, 'label', 'Extract Area', 'callback', 'findcurrentfigure; extract', 'separator', 'on');
  	    uimenu(QmatNMR.PP1Features, 'label', 'Define Cut Limits', 'callback', 'findcurrentfigure; askcutspectrum');
  	    uimenu(QmatNMR.PP1Features, 'label', 'Define Plot Limits', 'callback', 'findcurrentfigure; defineplotlimits');
  	    uimenu(QmatNMR.PP1Features, 'label', 'Get Position', 'callback', 'findcurrentfigure; whereamicont');
  	    uimenu(QmatNMR.PP1Features, 'label', 'Get Integral', 'callback', 'findcurrentfigure; QmatNMR.IntegrateAction = 1; integrate');
  	    uimenu(QmatNMR.PP1Features, 'label', 'Set Integral', 'callback', 'findcurrentfigure; QmatNMR.IntegrateAction = 2; integrate');
  	    uimenu(QmatNMR.PP1Features, 'label', 'Create CPMs', 'callback', 'findcurrentfigure; askcreateCPMs', 'separator', 'on');
  	    QmatNMR.pp1= uimenu(QmatNMR.PP1Features, 'label', 'Peak Picking');
    		uimenu(QmatNMR.pp1, 'label', 'Peak Picking', 'callback', 'findcurrentfigure; QTEMP1 = 1; peakpick;');
  		uimenu(QmatNMR.pp1, 'label', 'Peak Picking + Draw Lines', 'callback', 'findcurrentfigure; QTEMP1 = 2; peakpick;');
  		uimenu(QmatNMR.pp1, 'label', 'Search Specifications', 'callback', 'findcurrentfigure; askdefpeakpickdir');
  		uimenu(QmatNMR.pp1, 'label', 'Save List to ASCII file', 'callback', 'findcurrentfigure; asknamepeaklist');
  		uimenu(QmatNMR.pp1, 'label', 'Save List in Structure', 'callback', 'findcurrentfigure; asksaveliststructure');
  	  	uimenu(QmatNMR.pp1, 'label', 'Draw all labels', 'callback', 'findcurrentfigure; drawalllabels', 'separator', 'on');
    		uimenu(QmatNMR.pp1, 'label', 'Delete labels', 'callback', 'findcurrentfigure; deletelabels');
  	  	uimenu(QmatNMR.pp1, 'label', 'Delete lines', 'callback', 'findcurrentfigure; deletelines');
    		uimenu(QmatNMR.pp1, 'label', 'Clear List', 'callback', 'findcurrentfigure; QmatNMR.PeakList = []; disp(''Peak List cleared'');');
  	  	uimenu(QmatNMR.pp1, 'label', 'Clear List + Labels', 'callback', 'findcurrentfigure; deletelabels; deletelines; QmatNMR.PeakList = []; disp(''Peak List cleared'');');
  		uimenu(QmatNMR.pp1, 'label', 'Clear Axis vectors from structure', 'callback', 'findcurrentfigure; clearaxesstruct');
  
  
      QmatNMR.PP1Various = uimenu(QmatNMR.Context2D3D, 'label', '  Direct Manipulations   ');
    	QmatNMR.PP11 = uimenu(QmatNMR.PP1Various, 'label', 'Mouse Pointer', 'separator', 'on');
    		uimenu(QmatNMR.PP11, 'label', 'Arrow', 'callback', 'findcurrentfigure; set(QmatNMR.Fig2D3D, ''pointer'', ''arrow'')');
  		uimenu(QmatNMR.PP11, 'label', 'Arrowhead', 'callback', 'findcurrentfigure; set(QmatNMR.Fig2D3D, ''pointer'', ''Arrowhead'')');
  		uimenu(QmatNMR.PP11, 'label', 'crosshair', 'callback', 'findcurrentfigure; set(QmatNMR.Fig2D3D, ''pointer'', ''crosshair'')');
  		uimenu(QmatNMR.PP11, 'label', 'Ibeam', 'callback', 'findcurrentfigure; set(QmatNMR.Fig2D3D, ''pointer'', ''Ibeam'')');
  		uimenu(QmatNMR.PP11, 'label', 'Circle', 'callback', 'findcurrentfigure; set(QmatNMR.Fig2D3D, ''pointer'', ''circle'')');
  		uimenu(QmatNMR.PP11, 'label', 'Cross', 'callback', 'findcurrentfigure; set(QmatNMR.Fig2D3D, ''pointer'', ''cross'')');
  		uimenu(QmatNMR.PP11, 'label', 'Fleur', 'callback', 'findcurrentfigure; set(QmatNMR.Fig2D3D, ''pointer'', ''fleur'')');
  		uimenu(QmatNMR.PP11, 'label', 'Top', 'callback', 'findcurrentfigure; set(QmatNMR.Fig2D3D, ''pointer'', ''top'')');
  		uimenu(QmatNMR.PP11, 'label', 'Topl', 'callback', 'findcurrentfigure; set(QmatNMR.Fig2D3D, ''pointer'', ''topl'')');
  		uimenu(QmatNMR.PP11, 'label', 'Topr', 'callback', 'findcurrentfigure; set(QmatNMR.Fig2D3D, ''pointer'', ''topr'')');
  		uimenu(QmatNMR.PP11, 'label', 'Left', 'callback', 'findcurrentfigure; set(QmatNMR.Fig2D3D, ''pointer'', ''left'')');
  		uimenu(QmatNMR.PP11, 'label', 'Right', 'callback', 'findcurrentfigure; set(QmatNMR.Fig2D3D, ''pointer'', ''right'')');
  		uimenu(QmatNMR.PP11, 'label', 'Bottom', 'callback', 'findcurrentfigure; set(QmatNMR.Fig2D3D, ''pointer'', ''bottom'')');
  		uimenu(QmatNMR.PP11, 'label', 'Botl', 'callback', 'findcurrentfigure; set(QmatNMR.Fig2D3D, ''pointer'', ''botl'')');
  		uimenu(QmatNMR.PP11, 'label', 'Botr', 'callback', 'findcurrentfigure; set(QmatNMR.Fig2D3D, ''pointer'', ''botr'')');
  		uimenu(QmatNMR.PP11, 'label', 'Watch', 'callback', 'findcurrentfigure; set(QmatNMR.Fig2D3D, ''pointer'', ''watch'')');
  
  	QmatNMR.PP1Axis = uimenu(QmatNMR.PP1Various, 'label', 'Axis properties');
  		uimenu(QmatNMR.PP1Axis, 'label', 'Axis On/Off/Etc', 'callback', 'findcurrentfigure; askaxis');
  		uimenu(QmatNMR.PP1Axis, 'label', 'Clear Axis', 'callback', 'findcurrentfigure; askclearaxis');	
  		uimenu(QmatNMR.PP1Axis, 'label', 'Axis Colors', 'callback', 'findcurrentfigure; askaxiscolors');	
  		uimenu(QmatNMR.PP1Axis, 'label', 'Axis Directions', 'callback', 'findcurrentfigure; askdirs');	
  		uimenu(QmatNMR.PP1Axis, 'label', 'Axis Labels', 'callback', 'findcurrentfigure; askaxislabels');	
  		uimenu(QmatNMR.PP1Axis, 'label', 'Axis Locations', 'callback', 'findcurrentfigure; askaxislocation');	
  		uimenu(QmatNMR.PP1Axis, 'label', 'Axis Position', 'callback', 'findcurrentfigure; askaxisposition');
  		uimenu(QmatNMR.PP1Axis, 'label', 'Axis View', 'callback', 'findcurrentfigure; askaxisview');	
  		uimenu(QmatNMR.PP1Axis, 'label', 'Title', 'callback', 'findcurrentfigure; asktitle');
  
  	uimenu(QmatNMR.PP1Various, 'label', 'Box', 'callback', 'findcurrentfigure; askbox');
  	uimenu(QmatNMR.PP1Various, 'label', 'Font Properties', 'callback', 'findcurrentfigure; askfont');
  	uimenu(QmatNMR.PP1Various, 'label', 'Grid', 'callback', 'findcurrentfigure; askgrid');
  	uimenu(QmatNMR.PP1Various, 'label', 'Hold', 'callback', 'findcurrentfigure; askhold');
  
  	QmatNMR.PP1Line = uimenu(QmatNMR.PP1Various, 'label', 'Line properties');
  		QmatNMR.c109= uimenu(QmatNMR.PP1Line, 'label', 'LineStyle');
  			uimenu(QmatNMR.c109,'label', '-', 'callback', 'findcurrentfigure; Linestyle(''-''); disp(''Linestyle set to solid'');');
  			uimenu(QmatNMR.c109,'label', '--', 'callback', 'findcurrentfigure; Linestyle(''--''); disp(''Linestyle set to dashed'');');
  			uimenu(QmatNMR.c109,'label', ':', 'callback', 'findcurrentfigure; Linestyle('':''); disp(''Linestyle set to dotted'');');
  			uimenu(QmatNMR.c109,'label', '-.', 'callback', 'findcurrentfigure; Linestyle(''-.''); disp(''Linestyle set to dash-dot'');');
  			uimenu(QmatNMR.c109,'label', 'None', 'callback', 'findcurrentfigure; Linestyle(''none''); disp(''Linestyle set to none'');');
  		QmatNMR.c93 = uimenu(QmatNMR.PP1Line, 'label', 'LineWidth');
  			uimenu(QmatNMR.c93, 'label', '0.05', 'callback', 'findcurrentfigure; Linewidth(0.05); disp(''Linewidth set to 0.05 for the current axis'');');	
  			uimenu(QmatNMR.c93, 'label', '0.10', 'callback', 'findcurrentfigure; Linewidth(0.1); disp(''Linewidth set to 0.10 for the current axis'');');	
  			uimenu(QmatNMR.c93, 'label', '0.15', 'callback', 'findcurrentfigure; Linewidth(0.15); disp(''Linewidth set to 0.15 for the current axis'');');	
  			uimenu(QmatNMR.c93, 'label', '0.25', 'callback', 'findcurrentfigure; Linewidth(0.25); disp(''Linewidth set to 0.25 for the current axis'');');	
  			uimenu(QmatNMR.c93, 'label', '0.5', 'callback', 'findcurrentfigure; Linewidth(0.5); disp(''Linewidth set to 0.5 for the current axis'');');	
  			uimenu(QmatNMR.c93, 'label', '1.0', 'callback', 'findcurrentfigure; Linewidth(1.0); disp(''Linewidth set to 1.0 for the current axis'');');	
  			uimenu(QmatNMR.c93, 'label', '1.5', 'callback', 'findcurrentfigure; Linewidth(1.5); disp(''Linewidth set to 1.5 for the current axis'');');	
  			uimenu(QmatNMR.c93, 'label', '2.0', 'callback', 'findcurrentfigure; Linewidth(2.0); disp(''Linewidth set to 2.0 for the current axis'');');	
  			uimenu(QmatNMR.c93, 'label', '3.0', 'callback', 'findcurrentfigure; Linewidth(3.0); disp(''Linewidth set to 3.0 for the current axis'');');	
  			uimenu(QmatNMR.c93, 'label', '4.0', 'callback', 'findcurrentfigure; Linewidth(4.0); disp(''Linewidth set to 4.0 for the current axis'');');	
  			uimenu(QmatNMR.c93, 'label', '5.0', 'callback', 'findcurrentfigure; Linewidth(5.0); disp(''Linewidth set to 5.0 for the current axis'');');	
  			uimenu(QmatNMR.c93, 'label', '6.0', 'callback', 'findcurrentfigure; Linewidth(6.0); disp(''Linewidth set to 6.0 for the current axis'');');	
  			uimenu(QmatNMR.c93, 'label', '7.0', 'callback', 'findcurrentfigure; Linewidth(7.0); disp(''Linewidth set to 7.0 for the current axis'');');	
  			uimenu(QmatNMR.c93, 'label', '8.0', 'callback', 'findcurrentfigure; Linewidth(8.0); disp(''Linewidth set to 8.0 for the current axis'');');	
  			uimenu(QmatNMR.c93, 'label', '9.0', 'callback', 'findcurrentfigure; Linewidth(9.0); disp(''Linewidth set to 9.0 for the current axis'');');	
  			uimenu(QmatNMR.c93, 'label', '10.0', 'callback', 'findcurrentfigure; Linewidth(10.0); disp(''Linewidth set to 10.0 for the current axis'');');	
  		QmatNMR.c110= uimenu(QmatNMR.PP1Line, 'label', 'Marker');
  			uimenu(QmatNMR.c110,'label', 'None', 'callback', 'findcurrentfigure; Marker(''none''); disp(''Marker set to none'');');
  			uimenu(QmatNMR.c110,'label', 'Point', 'callback', 'findcurrentfigure; Marker(''.''); disp(''Marker set to point'');');
  			uimenu(QmatNMR.c110,'label', 'Plus', 'callback', 'findcurrentfigure; Marker(''+''); disp(''Marker set to plus'');');
  			uimenu(QmatNMR.c110,'label', 'Circle', 'callback', 'findcurrentfigure; Marker(''o''); disp(''Marker set to circle'');');
  			uimenu(QmatNMR.c110,'label', 'Asterisk', 'callback', 'findcurrentfigure; Marker(''*''); disp(''Marker set to asterisk'');');
  			uimenu(QmatNMR.c110,'label', 'Cross', 'callback', 'findcurrentfigure; Marker(''x''); disp(''Marker set to cross'');');
  			uimenu(QmatNMR.c110,'label', 'Square', 'callback', 'findcurrentfigure; Marker(''s''); disp(''Marker set to square'');');
  			uimenu(QmatNMR.c110,'label', 'Diamond', 'callback', 'findcurrentfigure; Marker(''d''); disp(''Marker set to triangle diamond'');');
  			uimenu(QmatNMR.c110,'label', 'Triangle up', 'callback', 'findcurrentfigure; Marker(''^''); disp(''Marker set to triangle up'');');
  			uimenu(QmatNMR.c110,'label', 'Triangle down', 'callback', 'findcurrentfigure; Marker(''v''); disp(''Marker set to triangle down'');');
  			uimenu(QmatNMR.c110,'label', 'Triangle right', 'callback', 'findcurrentfigure; Marker(''>''); disp(''Marker set to triangle right'');');
  			uimenu(QmatNMR.c110,'label', 'Triangle left', 'callback', 'findcurrentfigure; Marker(''<''); disp(''Marker set to triangle left'');');
  			uimenu(QmatNMR.c110,'label', 'Pentagram', 'callback', 'findcurrentfigure; Marker(''p''); disp(''Marker set to pentagram'');');
  			uimenu(QmatNMR.c110,'label', 'Hexagram', 'callback', 'findcurrentfigure; Marker(''h''); disp(''Marker set to hexagram'');');
  		QmatNMR.c111= uimenu(QmatNMR.PP1Line, 'label', 'Marker Size');
  			uimenu(QmatNMR.c111, 'label', '0.5', 'callback', 'findcurrentfigure; Markersize(0.5); disp(''Marker Size set to 0.5'');');	
  			uimenu(QmatNMR.c111, 'label', '1.0', 'callback', 'findcurrentfigure; Markersize(1.0); disp(''Marker Size set to 1.0'');');	
  			uimenu(QmatNMR.c111, 'label', '1.5', 'callback', 'findcurrentfigure; Markersize(1.5); disp(''Marker Size set to 1.5'');');	
  			uimenu(QmatNMR.c111, 'label', '2.0', 'callback', 'findcurrentfigure; Markersize(2.0); disp(''Marker Size set to 2.0'');');	
  			uimenu(QmatNMR.c111, 'label', '3.0', 'callback', 'findcurrentfigure; Markersize(3.0); disp(''Marker Size set to 3.0'');');	
  			uimenu(QmatNMR.c111, 'label', '4.0', 'callback', 'findcurrentfigure; Markersize(4.0); disp(''Marker Size set to 4.0'');');	
  			uimenu(QmatNMR.c111, 'label', '5.0', 'callback', 'findcurrentfigure; Markersize(5.0); disp(''Marker Size set to 5.0'');');	
  			uimenu(QmatNMR.c111, 'label', '6.0', 'callback', 'findcurrentfigure; Markersize(6.0); disp(''Marker Size set to 6.0'');');	
  			uimenu(QmatNMR.c111, 'label', '7.0', 'callback', 'findcurrentfigure; Markersize(7.0); disp(''Marker Size set to 7.0'');');	
  			uimenu(QmatNMR.c111, 'label', '8.0', 'callback', 'findcurrentfigure; Markersize(8.0); disp(''Marker Size set to 8.0'');');	
  			uimenu(QmatNMR.c111, 'label', '9.0', 'callback', 'findcurrentfigure; Markersize(9.0); disp(''Marker Size set to 9.0'');');	
  			uimenu(QmatNMR.c111, 'label', '10.0', 'callback', 'findcurrentfigure; Markersize(10.0); disp(''Marker Size set to 10.0'');');	
  
  	uimenu(QmatNMR.PP1Various, 'label', 'Scaling Limits', 'callback', 'findcurrentfigure; asklims');
  	uimenu(QmatNMR.PP1Various, 'label', 'Scaling Types', 'callback', 'findcurrentfigure; askscales');
  	uimenu(QmatNMR.PP1Various, 'label', 'Shading', 'callback', 'findcurrentfigure; askshading');
  	QmatNMR.PP1Tick = uimenu(QmatNMR.PP1Various, 'label', 'Tick properties');
  		uimenu(QmatNMR.PP1Tick, 'label', 'Tick direction', 'callback', 'findcurrentfigure; asktickdir');
  		uimenu(QmatNMR.PP1Tick, 'label', 'Tick Labels', 'callback', 'findcurrentfigure; askticklabel');	
  		uimenu(QmatNMR.PP1Tick, 'label', 'Tick Lengths', 'callback', 'findcurrentfigure; askticklengths');	
  		uimenu(QmatNMR.PP1Tick, 'label', 'Tick Positions', 'callback', 'findcurrentfigure; asktick');
  
    QmatNMR.Hc = uimenu(QmatNMR.Context2D3D, 'label', '  History / Macro   ');
    	uimenu(QmatNMR.Hc, 'label', 'Show History', 'callback', 'findcurrentfigure; matnmrhelp(QmatNMR.History2D3D, ''QmatNMR.History2D3D'');');
  	uimenu(QmatNMR.Hc, 'label', 'Start Recording Macro', 'callback', 'QmatNMR.buttonList=1; QmatNMR.uiInput1=2; regelstartrecordingmacro', 'separator', 'on');
  	uimenu(QmatNMR.Hc, 'label', 'Stop Recording Macro', 'callback', 'askstoprecordingmacro');
  	uimenu(QmatNMR.Hc, 'label', 'Execute Macro', 'callback', 'QmatNMR.StepWise = 0; askexecutemacro', 'accelerator', 'e');
  	uimenu(QmatNMR.Hc, 'label', 'Execute Macro Stepwise', 'callback', 'QmatNMR.StepWise = 1; askexecutemacro');
    
    uimenu(QmatNMR.Context2D3D, 'label', '  Printing Menu   ', 'callback', 'findcurrentfigure; set(gca, ''selected'', ''off''); matprint');
  
  
  %
  %set the foreground colour of the uimenus according to the colour scheme
  %
  set(findobj(QmatNMR.Fig2D3D, 'type', 'uimenu'), 'foregroundcolor', QmatNMR.ColorScheme.UImenuFore);
  
  
  
  %
  % Finish off
  %
    %
    %Correct the window if the screensize is too small for the original size of the window and buttons
    %
    if ((QmatNMR.ComputerScreenSize(3) < 920) | (QmatNMR.ComputerScreenSize(4) < 800))
      QmatNMR.ChangeFrom = [1  1 920 800];
      QTEMP1 = QmatNMR.Fig2D3D;	     %define the window handle
      CorrectWindow
    end  
  
  
    %
    %set all units to normalized
    %
    set(QmatNMR.ContAxis, 'units', 'normalized');
    set(QmatNMR.Fig2D3D, 'units', 'normalized', 'position', [QmatNMR.Q2D3DViewerLeft QmatNMR.Q2D3DViewerBottom QmatNMR.Q2D3DViewerWidth QmatNMR.Q2D3DViewerHeight]);
    
    if QmatNMR.unittype == 1		     %Resizeable windows needed ...
      set(QmatNMR.Fig2D3D, 'resize', 'on');
    else
      set(QmatNMR.Fig2D3D, 'resize', 'off');
    end
  
    set(QmatNMR.Fig2D3D, 'Visible', 'on');  
    drawnow
  
    %
    %Check whether the position is halfway decent since especially the bottom value often gets
    %sets incorrectly
    %
    QTEMP1 = get(QmatNMR.Fig2D3D, 'position');
    QTEMP11 = 0;
    while ((abs((QmatNMR.Q2D3DViewerBottom - QTEMP1(2))/QmatNMR.Q2D3DViewerBottom) > 0.05) & (QTEMP11 < 5))
      QTEMP1 = get(QmatNMR.Fig2D3D, 'position');
      set(QmatNMR.Fig2D3D, 'Position', [QmatNMR.Q2D3DViewerLeft QmatNMR.Q2D3DViewerBottom QmatNMR.Q2D3DViewerWidth QmatNMR.Q2D3DViewerHeight]);
      drawnow
    
      QTEMP11 = QTEMP11 + 1;
    end
  
    if (QTEMP11 == 5)
      disp('matNMR NOTICE: couldn''t position window correctly. Abandoning attempts ...');
    end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
