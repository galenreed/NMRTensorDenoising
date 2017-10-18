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
% SetOptions sets all or specific options to make sure the settings variable contains all parameters
% and its latest values.
%
% 13-11-2006
%

function SetOptions(Par)

global QmatNMR QmatNMRsettings

if (nargin == 0)
  Par = 0;
end

switch (Par)
  case 0 		%set all parameters
    SetOptions(1)
    SetOptions(2)
    SetOptions(3)
    SetOptions(4)
    SetOptions(5)
    SetOptions(6)

  case 1 		%general options
    QmatNMRsettings.Defaultyschaal 			= QmatNMR.yschaal;
    QmatNMRsettings.Defaultgridvar 			= QmatNMR.gridvar;
    QmatNMRsettings.Defaultxschaal 			= QmatNMR.xschaal;
    QmatNMRsettings.Defaultyrelative 			= QmatNMR.yrelative;
    QmatNMRsettings.Defaultunder 			= QmatNMR.under;
    QmatNMRsettings.Defaultover 			= QmatNMR.over;
    QmatNMRsettings.Defaultnumbcont 			= QmatNMR.numbcont;
    QmatNMRsettings.Defaultaz 				= QmatNMR.az;
    QmatNMRsettings.Defaultel 				= QmatNMR.el;
    QmatNMRsettings.Defaultstackaz 			= QmatNMR.stackaz;
    QmatNMRsettings.Defaultstackel 			= QmatNMR.stackel;
    QmatNMRsettings.Defaultfour2 			= QmatNMR.four2;
    QmatNMRsettings.Defaultfour1 			= QmatNMR.four1;
    QmatNMRsettings.DefaultNegConts 			= QmatNMR.negcont;
    QmatNMRsettings.DefaultPaperOrientation 		= QmatNMR.PaperOrientation;
    QmatNMRsettings.DefaultPaperSize 			= QmatNMR.PaperSize;
    QmatNMRsettings.DefaultUnDo1D 			= QmatNMR.UnDo1D;
    QmatNMRsettings.DefaultUnDo2D 			= QmatNMR.UnDo2D;
    QmatNMRsettings.Defaultfftstatus 			= QmatNMR.fftstatus;
    
    QmatNMRsettings.ShowLogo     			= QmatNMR.ShowLogo;
    QmatNMRsettings.matNMRSafety 			= QmatNMR.matNMRSafety;
    QmatNMRsettings.Q1DMenu      			= QmatNMR.Q1DMenu;
    QmatNMRsettings.Q2DMenu      			= QmatNMR.Q2DMenu;
    QmatNMRsettings.PhaseMenu    			= QmatNMR.PhaseMenu;

  case 2 		%colour scheme
    QmatNMRsettings.DefaultColorScheme = QmatNMR.ColorScheme;

  case 3 		%screen settings
    QmatNMRsettings.figDefaultLeftNorm			= QmatNMR.figLeftNorm;
    QmatNMRsettings.figDefaultBottomNorm		= QmatNMR.figBottomNorm;
    QmatNMRsettings.figDefaultWidthNorm			= QmatNMR.figWidthNorm;
    QmatNMRsettings.figDefaultHeightNorm		= QmatNMR.figHeightNorm;
    
    QmatNMRsettings.Q2D3DViewerDefaultLeft 		= QmatNMR.Q2D3DViewerLeft;
    QmatNMRsettings.Q2D3DViewerDefaultBottom 		= QmatNMR.Q2D3DViewerBottom;
    QmatNMRsettings.Q2D3DViewerDefaultWidth 		= QmatNMR.Q2D3DViewerWidth;
    QmatNMRsettings.Q2D3DViewerDefaultHeight 		= QmatNMR.Q2D3DViewerHeight;
    
    QmatNMRsettings.Q2D3DViewerPanelDefaultLeft 	= QmatNMR.Q2D3DViewerPanelLeft;
    QmatNMRsettings.Q2D3DViewerPanelDefaultBottom 	= QmatNMR.Q2D3DViewerPanelBottom;
    QmatNMRsettings.Q2D3DViewerPanelDefaultWidth 	= QmatNMR.Q2D3DViewerPanelWidth;
    QmatNMRsettings.Q2D3DViewerPanelDefaultHeight	= QmatNMR.Q2D3DViewerPanelHeight;
    
    QmatNMRsettings.Defaultunittype 			= QmatNMR.unittype;
    QmatNMRsettings.DefaultUIFontSize 			= QmatNMR.UIFontSize;

  case 4 		%fonts
    QmatNMRsettings.DefaultFontList 			= QmatNMR.FontList;

  case 5 		%line properties
    QmatNMRsettings.DefaultLineType 			= QmatNMR.LineType;
    QmatNMRsettings.DefaultMarkerType 			= QmatNMR.MarkerType;
    QmatNMRsettings.DefaultLineColor 			= QmatNMR.LineColor;
    QmatNMRsettings.DefaultColorScheme 			= QmatNMR.ColorScheme;

  case 6 		%text properties
    QmatNMRsettings.DefaultTextFont 			= QmatNMR.TextFont;
    QmatNMRsettings.DefaultTextSize 			= QmatNMR.TextSize;
    QmatNMRsettings.DefaultTextAngle 			= QmatNMR.TextAngle;
    QmatNMRsettings.DefaultTextWeight 			= QmatNMR.TextWeight;

  case 7 		%file properties
    QmatNMRsettings.DefaultDirectory 			= QmatNMR.DefaultDirectory;
    QmatNMRsettings.DefaultReuseLastDirectory    = QmatNMR.ReuseLastDirectory;
    QmatNMRsettings.DefaultSearchProfile         = QmatNMR.SearchProfile;

  otherwise
    error('SetOptions error: incorrect code for action. Aborting!')
end
  
