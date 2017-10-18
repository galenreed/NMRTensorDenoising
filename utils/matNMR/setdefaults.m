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
%setdefaults.m sets all default parameters as they were saved in the matNMR confirguration file
%
%25-09-'98

try
  			%Set Line and Text properties
  QmatNMR.LineType = QmatNMRsettings.DefaultLineType;
  QmatNMR.LineWidth = QmatNMRsettings.DefaultLineWidth;
  QmatNMR.MarkerType = QmatNMRsettings.DefaultMarkerType;
  QmatNMR.MarkerSize = QmatNMRsettings.DefaultMarkerSize;
  QmatNMR.TextFont = QmatNMRsettings.DefaultTextFont;
  QmatNMR.TextSize = QmatNMRsettings.DefaultTextSize;
  QmatNMR.TextAngle = QmatNMRsettings.DefaultTextAngle;
  QmatNMR.TextWeight = QmatNMRsettings.DefaultTextWeight;
  QmatNMR.UIFontSize = QmatNMRsettings.DefaultUIFontSize;
  QmatNMR.ColorScheme = QmatNMRsettings.DefaultColorScheme;
  QmatNMR.LineColor = QmatNMR.ColorScheme.LineMain;
  QmatNMR.color = QmatNMR.ColorScheme.LineDual;
  
  set(0, 'DefaultUIControlFontUnits', 'points', ...
         'DefaultUIControlFontSize', QmatNMR.UIFontSize, ...
         'DefaultUIControlFontAngle', 'normal', ...
         'DefaultUIControlFontName', 'Helvetica', ...
         'DefaultUIControlFontWeight', 'normal', ...
         'DefaultAxesFontUnits', 'points', ...
         'DefaultAxesFontSize', QmatNMR.TextSize, ...
         'DefaultAxesFontAngle', QmatNMR.TextAngle, ...
         'DefaultAxesFontWeight', QmatNMR.TextWeight, ...
         'DefaultAxesFontName', QmatNMR.TextFont, ...       
         'DefaultTextFontUnits', 'Points', ...
         'DefaultTextFontSize', QmatNMR.TextSize, ...
         'DefaultTextFontAngle', QmatNMR.TextAngle, ...
         'DefaultTextFontWeight', QmatNMR.TextWeight, ...
         'DefaultTextFontName', QmatNMR.TextFont)
         
  %%%       , ...
  %%%       'DefaultAxesXcolor', QmatNMR.ColorScheme.AxisFore, ...
  %%%       'DefaultAxesYcolor', QmatNMR.ColorScheme.AxisFore, ...
  %%%       'DefaultAxesZcolor', QmatNMR.ColorScheme.AxisFore, ...
  %%%       'DefaultTextColor', QmatNMR.ColorScheme.AxisFore);
  %%%
  
  			%Set screen settings
  QmatNMR.figLeftNorm	= QmatNMRsettings.figDefaultLeftNorm;
  QmatNMR.figBottomNorm	= QmatNMRsettings.figDefaultBottomNorm;
  QmatNMR.figWidthNorm	= QmatNMRsettings.figDefaultWidthNorm;
  QmatNMR.figHeightNorm	= QmatNMRsettings.figDefaultHeightNorm;
  
  QmatNMR.Q2D3DViewerLeft 	= QmatNMRsettings.Q2D3DViewerDefaultLeft;
  QmatNMR.Q2D3DViewerBottom 	= QmatNMRsettings.Q2D3DViewerDefaultBottom;
  QmatNMR.Q2D3DViewerWidth 	= QmatNMRsettings.Q2D3DViewerDefaultWidth;
  QmatNMR.Q2D3DViewerHeight	= QmatNMRsettings.Q2D3DViewerDefaultHeight;
  
  QmatNMR.Q2D3DViewerPanelLeft 	= QmatNMRsettings.Q2D3DViewerPanelDefaultLeft;
  QmatNMR.Q2D3DViewerPanelBottom 	= QmatNMRsettings.Q2D3DViewerPanelDefaultBottom;
  QmatNMR.Q2D3DViewerPanelWidth 	= QmatNMRsettings.Q2D3DViewerPanelDefaultWidth;
  QmatNMR.Q2D3DViewerPanelHeight	= QmatNMRsettings.Q2D3DViewerPanelDefaultHeight;
  
  
  
  			%Other settings ....
  QmatNMR.unittype = QmatNMRsettings.Defaultunittype;
  QmatNMR.yschaal = QmatNMRsettings.Defaultyschaal;
  QmatNMR.gridvar = QmatNMRsettings.Defaultgridvar;
  QmatNMR.xschaal = QmatNMRsettings.Defaultxschaal;
  QmatNMR.yrelative = QmatNMRsettings.Defaultyrelative;
  QmatNMR.under = QmatNMRsettings.Defaultunder;
  QmatNMR.over = QmatNMRsettings.Defaultover;
  QmatNMR.numbcont = QmatNMRsettings.Defaultnumbcont;
  QmatNMR.az = QmatNMRsettings.Defaultaz;
  QmatNMR.el = QmatNMRsettings.Defaultel;
  QmatNMR.stackaz = QmatNMRsettings.Defaultstackaz;
  QmatNMR.stackel = QmatNMRsettings.Defaultstackel;
  QmatNMR.four2 = QmatNMRsettings.Defaultfour2;
  QmatNMR.four1 = QmatNMRsettings.Defaultfour1;
  QmatNMR.negcont = QmatNMRsettings.DefaultNegConts;
  QmatNMR.FontList = QmatNMRsettings.DefaultFontList;
  QmatNMR.PaperOrientation =  QmatNMRsettings.DefaultPaperOrientation;
  QmatNMR.PaperSize = QmatNMRsettings.DefaultPaperSize;
  QmatNMR.UnDo1D = QmatNMRsettings.DefaultUnDo1D;
  QmatNMR.UnDo2D = QmatNMRsettings.DefaultUnDo2D;
  QmatNMR.fftstatus = QmatNMRsettings.Defaultfftstatus;
  
  QmatNMR.ShowLogo     = QmatNMRsettings.ShowLogo    ;
  QmatNMR.matNMRSafety = QmatNMRsettings.matNMRSafety;
  QmatNMR.Q1DMenu	     = QmatNMRsettings.Q1DMenu     ;
  QmatNMR.Q2DMenu      = QmatNMRsettings.Q2DMenu     ;
  QmatNMR.PhaseMenu    = QmatNMRsettings.PhaseMenu   ;
  
  QmatNMR.ReuseLastDirectory = QmatNMRsettings.DefaultReuseLastDirectory;
  QmatNMR.DefaultDirectory = QmatNMRsettings.DefaultDirectory;
  QmatNMR.Xpath = QmatNMR.DefaultDirectory;
  QmatNMR.SearchProfile = QmatNMRsettings.DefaultSearchProfile;

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
