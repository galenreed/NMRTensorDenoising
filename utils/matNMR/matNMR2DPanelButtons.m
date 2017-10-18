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
%matNMR2DPanelButtons.m creates the button Panel figure window for the 2D/3D Viewer routine
%05-01-'00


try
  QmatNMR.Q2DButtonPanel = figure('units', 'pixels', 'Position', [50 5 1000 170], 'Name', '2D/3D Button Panel', 'Numbertitle', 'off', ...
                                  'Resize', 'off', 'hittest', 'off', 'closerequestfcn', 'askstopnmr2d', 'visible', 'off', ...
                                  'menubar', 'none', ...
  			        'WindowButtonDownFcn', 'Arrowhead', 'tag', '2D/3D Button Panel', 'color', QmatNMR.ColorScheme.Figure1Back);
  
    %
    %To work around a Matlab bug (see BugFixes.txt, 11-05-'04) we redefine the position and units.
    %
    set(QmatNMR.Q2DButtonPanel, 'units', 'pixels', 'position', [50 5 1000 170]);
  
  %position offsets
    QmatNMR.ToolsStart = 0;
    QmatNMR.ContoursStart = 210;
    QmatNMR.MeshStart = 360;
    QmatNMR.StackStart = 510;
    QmatNMR.RasterStart = 730;
    
  %Tools  
    uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'text', 'String', 'Tools', 'position', [QmatNMR.ToolsStart+1 135 200  30], 'FontSize', QmatNMR.UIFontSize+4, 'backgroundcolor', QmatNMR.ColorScheme.Button13Back, 'foregroundcolor', QmatNMR.ColorScheme.Button13Fore);
    uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'frame', 'Position', [QmatNMR.ToolsStart+1 1 200 145], 'backgroundcolor', QmatNMR.ColorScheme.Frame1);
    QmatNMR.c11 = uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'Check', 'Position', [QmatNMR.ToolsStart+103 120 95 23], 'callback', 'holdcont', 'String', 'Hold', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
    QmatNMR.c10 = uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'Check', 'Position', [QmatNMR.ToolsStart+103  97 95 23], 'callback', 'zoomcont', 'String', 'Zoom', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
    QmatNMR.c16 = uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'Check', 'Position', [QmatNMR.ToolsStart+103  74 95 23], 'callback', 'rotcont', 'String', 'Rotate 3D', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore); 
    QmatNMR.c19 = uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'Check', 'Position', [QmatNMR.ToolsStart+103  51 95 23], 'callback', 'QmatNMR.buttonList = 1; QmatNMR.uiInput1 = get(QmatNMR.c19, ''value''); QmatNMR.uiInput2 = 0; QmatNMR.uiInput3 = 1; contcbar', 'String', 'Color Bar', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore); 
    QmatNMR.c8  = uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'popup', 'Position', [QmatNMR.ToolsStart+103  26 95 25], 'callback', 'contcmap', 'String', QmatNMR.PopupStr, 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
    QmatNMR.meshshadingstring = str2mat('faceted', 'flat', 'interp');
    QmatNMR.MM42  = uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'popup', 'Position', [QmatNMR.ToolsStart+103  1 95 25], 'callback', 'QShading(get(QmatNMR.MM42, ''Value'')); set(QmatNMR.MM42, ''value'', 1);', 'String', 'Shading | faceted | flat | interp', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  
    uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'Pushbutton', 'Position', [QmatNMR.ToolsStart+3 120 100 23], 'callback', 'definecutspectrum', 'String', 'Define strip plot', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
    uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'Pushbutton', 'Position', [QmatNMR.ToolsStart+3  97 100 23], 'callback', 'askdefineplotlimits', 'String', 'Define Plot', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
    uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'Pushbutton', 'Position', [QmatNMR.ToolsStart+3  74 100 23], 'callback', 'QmatNMR.Crosshair2DSlices = 0; whereamicont', 'String', 'Get Position', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
    uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'Pushbutton', 'Position', [QmatNMR.ToolsStart+3  51 100 23], 'Callback', 'stats2d', 'String', 'Axis Rulers', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
    uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'Pushbutton', 'Position', [QmatNMR.ToolsStart+3  26 100 25], 'callback', 'QmatNMR.command2 = 0;  clabels', 'String', 'Title / labels', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
    uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'Pushbutton', 'Position', [QmatNMR.ToolsStart+3   1 100 25], 'callback', 'print2D3D', 'String', 'Print', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  
  %Contours
    uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'text', 'String', 'Contours', 'position', [QmatNMR.ContoursStart+1 135 140  30], 'FontSize', QmatNMR.UIFontSize+4, 'backgroundcolor', QmatNMR.ColorScheme.Button13Back, 'foregroundcolor', QmatNMR.ColorScheme.Button13Fore);
    uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'frame', 'Position', [QmatNMR.ContoursStart+1   1 140 145], 'backgroundcolor', QmatNMR.ColorScheme.Frame2);
    uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'Pushbutton', 'Position', [QmatNMR.ContoursStart+11  41 120 40], 'callback', 'asknamecontrel', 'String', 'Relative Contrs.', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
    uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'Pushbutton', 'Position', [QmatNMR.ContoursStart+11   1 120 40], 'callback', 'asknamecontabs', 'String', 'Absolute Contrs.', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
    QmatNMR.contourtypestring = str2mat('contour', 'contourf', 'contour3');
    QmatNMR.c18 = uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'Popup', 'Position', [QmatNMR.ContoursStart+21 111 100 25], 'String', 'Contour | Contourf | Contour3', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
    QmatNMR.contdisplaystring = ['real' ; 'imag' ; ' abs'];
    QmatNMR.c17 = uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'Popup', 'Position', [QmatNMR.ContoursStart+21  85 100 25], 'string', 'Real | Imaginary | Absolute', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
    
  
  %Mesh 3D
    uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'text', 'String', 'Mesh 3D', 'position', [QmatNMR.MeshStart+1 135 140  30], 'FontSize', QmatNMR.UIFontSize+4, 'backgroundcolor', QmatNMR.ColorScheme.Button13Back, 'foregroundcolor', QmatNMR.ColorScheme.Button13Fore);
    uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'frame', 'Position', [QmatNMR.MeshStart+1 1 140 145], 'backgroundcolor', QmatNMR.ColorScheme.Frame2);
    uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'Pushbutton', 'Position', [QmatNMR.MeshStart+11  1 120 40], 'callback', 'asknamemesh', 'String', ' Mesh 3D plot ', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
    QmatNMR.meshtypestring = str2mat('mesh', 'meshc', 'meshz', ' surf', 'surfc', 'surfl', 'pcolor', 'waterfall');
    QmatNMR.MM29  = uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'Popup', 'Position', [QmatNMR.MeshStart+21 101 100 25], 'String', 'Mesh | Meshc | Meshz | Surf | Surfc | Surfl | Pcolor | Waterfall', 'value', 4, 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore); 
    QmatNMR.meshdisplaystring = ['real' ; 'imag' ; ' abs'];
    QmatNMR.MM20  = uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'Popup', 'Position', [QmatNMR.MeshStart+21 76 100 25], 'String', 'Real | Imaginary | Absolute', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
    QmatNMR.meshstylestring = ['both  '; 'row   '; 'column'];
    QmatNMR.MM41  = uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'popup', 'Position', [QmatNMR.MeshStart+21 51 100 25], 'String', 'Both | Row | Column', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  
  
  %Stack3D
    uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'text', 'String', 'Stack 3D', 'position', [QmatNMR.StackStart+1 135 210  30], 'FontSize', QmatNMR.UIFontSize+4, 'backgroundcolor', QmatNMR.ColorScheme.Button13Back, 'foregroundcolor', QmatNMR.ColorScheme.Button13Fore);
    uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'frame',      'Position', [QmatNMR.StackStart+1   1 210 145], 'backgroundcolor', QmatNMR.ColorScheme.Frame2);
  
    uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'PushButton', 'Position', [QmatNMR.StackStart+6  107 110 30], 'String', 'Lower z-limit', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
    QmatNMR.R29  = uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'Edit', 'Position', [QmatNMR.StackStart+115 107 90 30], 'callback', 'QmatNMR.RZlim1 = str2num(get(QmatNMR.R29, ''string'')); figure(QmatNMR.Fig2D3D); set(gca, ''zlim'', [QmatNMR.RZlim1 QmatNMR.RZlim2]);', 'backgroundcolor', QmatNMR.ColorScheme.Button2Back, 'foregroundcolor', QmatNMR.ColorScheme.Button2Fore);
    uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'PushButton', 'Position', [QmatNMR.StackStart+6 77 110 30], 'String', 'Upper z-limit', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
    QmatNMR.R30  = uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'Edit', 'Position', [QmatNMR.StackStart+115 77 90 30], 'callback', 'QmatNMR.RZlim2 = str2num(get(QmatNMR.R30, ''string'')); figure(QmatNMR.Fig2D3D); set(gca, ''zlim'', [QmatNMR.RZlim1 QmatNMR.RZlim2]);', 'backgroundcolor', QmatNMR.ColorScheme.Button2Back, 'foregroundcolor', QmatNMR.ColorScheme.Button2Fore);
  
    QmatNMR.R31  = uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'Popup', 'Position', [QmatNMR.StackStart+75 51 130 25], 'String', 'YDir Default | YDir Reverse | YDir Normal', 'callback', 'stack3dreverse', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
    QmatNMR.R27  = uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'Check', 'Position', [QmatNMR.StackStart+106 26 100 25], 'callback', 'regelzaxis', 'value', 1, 'String', 'Z-axis', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
    QmatNMR.R32  = uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'Check', 'Position', [QmatNMR.StackStart+106 1 100 25], 'callback', 'regelyaxis', 'value', 1, 'String', 'Y-tick', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
    QmatNMR.stackdisplaystring = ['real' ; 'imag' ; ' abs'];
    QmatNMR.R17 = uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'Popup', 'Position', [QmatNMR.StackStart+6  51 70 25], 'string', 'Real | Imaginary | Absolute', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
    uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'PushButton', 'Position', [QmatNMR.StackStart+6 1 100 40], 'callback', 'asknamestack3D', 'String', 'Stack 3D', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  
  
  %Raster
    uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'text', 'String', 'Raster', 'position', [QmatNMR.RasterStart+1 135 110  30], 'FontSize', QmatNMR.UIFontSize+4, 'backgroundcolor', QmatNMR.ColorScheme.Button13Back, 'foregroundcolor', QmatNMR.ColorScheme.Button13Fore);
    uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'frame', 'Position', [QmatNMR.RasterStart+1 1 110 145], 'backgroundcolor', QmatNMR.ColorScheme.Frame2);
  
    QmatNMR.stackdisplaystring = ['real' ; 'imag' ; ' abs'];
    uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'Pushbutton', 'Position', [QmatNMR.RasterStart+11 105 90 30], 'String', 'Sampling', 'backgroundcolor', QmatNMR.ColorScheme.Button2Back, 'foregroundcolor', QmatNMR.ColorScheme.Button2Fore);
  
    QmatNMR.Rasterbut3 = uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'edit', 'Position', [QmatNMR.RasterStart+11 80 90 25], 'string', '16', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
    QTEMP1 = ['global QmatNMR; QmatNMR.RasterSamplingFactor = eval(get(QmatNMR.Rasterbut3, ''string'')); dispraster2D'];
    set(QmatNMR.Rasterbut3, 'callback', QTEMP1);
    
    QmatNMR.rasterdisplaystring = ['real' ; 'imag' ; ' abs'];
    QmatNMR.Rasterbut1 = uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'Popup', 'Position', [QmatNMR.RasterStart+11  51 90 25], 'string', 'Real | Imaginary | Absolute', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
    uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'PushButton', 'Position', [QmatNMR.RasterStart+11 1 90 40], 'callback', 'asknameraster2D', 'String', 'Raster 2D', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  
  
  %Stop, new window and main window buttons
    uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'Pushbutton', 'Position', [855 145 135 25], 'callback', 'nmr', 'String', 'Open Main Window', 'backgroundcolor', QmatNMR.ColorScheme.Button4Back, 'foregroundcolor', QmatNMR.ColorScheme.Button4Fore);
    uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'Pushbutton', 'Position', [855  80 135 40], 'callback', 'makenew2D3D', 'String', ' New 2D/3D Window ', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
    uicontrol('Parent', QmatNMR.Q2DButtonPanel, 'Style', 'Pushbutton', 'Position', [855   6 135 60], 'callback', 'askclosenmr2d', 'String', ' Close Window ', 'backgroundcolor', QmatNMR.ColorScheme.Button3Back, 'foregroundcolor', QmatNMR.ColorScheme.Button3Fore);
  
    
    %
    %Correct the window if the screensize is too small for the original size of the window and buttons
    %
    if ((QmatNMR.ComputerScreenSize(3) < 1000) | (QmatNMR.ComputerScreenSize(4) < 170))
      QmatNMR.ChangeFrom = [1 1 1000 170];
      QTEMP1 = QmatNMR.Q2DButtonPanel;		%define the window handle
      CorrectWindow
    end  
  
    %
    %set all units to normalized
    %
    QmatNMR.SETbuttons = findobj(allchild(QmatNMR.Q2DButtonPanel), 'type', 'uicontrol');
    set(QmatNMR.SETbuttons, 'units', 'normalized');
  
    set(QmatNMR.Q2DButtonPanel, 'units', 'normalized', 'position', [QmatNMR.Q2D3DViewerPanelLeft QmatNMR.Q2D3DViewerPanelBottom QmatNMR.Q2D3DViewerPanelWidth QmatNMR.Q2D3DViewerPanelHeight]);
    set(QmatNMR.Q2DButtonPanel, 'units', 'normalized', 'visible', 'on');
  
    if QmatNMR.unittype == 1			%Resizeable windows needed ...
      set(QmatNMR.Q2DButtonPanel, 'resize', 'on');
    else
      set(QmatNMR.Q2DButtonPanel, 'resize', 'off');  
    end
  
    set(QmatNMR.Q2DButtonPanel, 'visible', 'on');
    drawnow
  
    %
    %Check whether the position is halfway decent since especially the bottom value often gets
    %sets incorrectly
    %
    QTEMP1 = get(QmatNMR.Q2DButtonPanel, 'position');
    QTEMP11 = 0;
    while ((abs((QmatNMR.Q2D3DViewerPanelBottom - QTEMP1(2))/QmatNMR.Q2D3DViewerPanelBottom) > 0.05) & (QTEMP11 < 5))
      QTEMP1 = get(QmatNMR.Q2DButtonPanel, 'position');
      set(QmatNMR.Q2DButtonPanel, 'Position', [QmatNMR.Q2D3DViewerPanelLeft QmatNMR.Q2D3DViewerPanelBottom QmatNMR.Q2D3DViewerPanelWidth QmatNMR.Q2D3DViewerPanelHeight]);
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
