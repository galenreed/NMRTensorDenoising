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
%matNMRinitvars.m initializes all variables that are needed by matNMR and its components
%In principle this should not be really necessary I guess but else MATLAB starts complaining.
%06-12-'97
%05-10-'00
%
% Here is a small list with important variables inmatNMR (things that can be useful to know...)
%
% QmatNMR.Spec1D	the current 1D spectrum
% QmatNMR.Axis1D	the axis vector belonging to QmatNMR.Spec1D
% QmatNMR.Size1D	the dimension size of the current 1D spectrum
%
% QmatNMR.Spec2D	the current 2D spectrum containing the RR and RI parts of the spectrum (hypercomplex dataset)
% QmatNMR.Spec2Dhc	the current 2D spectrum containing the IR and II parts of the spectrum (hypercomplex dataset)
% QmatNMR.AxisTD2	the axis vector for TD2 belonging to QmatNMR.Spec2D
% QmatNMR.AxisTD1	the axis vector for TD1 belonging to QmatNMR.Spec2D
% QmatNMR.SizeTD2	the dimension size of TD2
% QmatNMR.SizeTD1	the dimension size of TD1
%
% QmatNMR.Dim		the current dimension (0=1D, 1=TD2, 2=TD1)
%
%


try
  clear functions
  
  
  %
  %The beginning ... all variables need to be given an initial value first ...
  %
  
  %
  %Determine on which platform we are working today ...
  %
    QmatNMR.PlatformPC = 666;		%MS Windows, i.e. diabolical
    QmatNMR.PlatformMAC = 0;		%MAC, i.e. nothing
    QmatNMR.PlatformVMS = 1;		%VMS, almost nothing
    QmatNMR.PlatformUNIX = 3;		%UNIX, i.e. pretty good!   
    QmatNMR.Platform = DeterminePlatform;
  
  
  %
  % First some default screen sizes. Don't bother changing these as they can be set
  % in the screen options menu !!
  %
 	%Figure window for matNMR in points
  QmatNMR.ComputerScreenSize	= get(0, 'ScreenSize');
  QTEMP			= version;		%Version dependent positioning ... unfortunately necessary
  QmatNMR.MatlabVersion  	= str2num(QTEMP(1:3));
  if (QmatNMR.MatlabVersion < 6.5)
    QTEMP2 = [7 52];
    disp('matNMR WARNING: the current version of matNMR is NOT supported by your Matlab version.')
    disp('matNMR WARNING: Current support level is version 6.5 up until 8.6.');
  
  elseif ((QmatNMR.MatlabVersion >= 6.5) & (QmatNMR.MatlabVersion <= 8.6))
    QTEMP2 = [7 52];
    
  else
    disp('MatNMR has not recognized the version of MATLAB you are using. This may affect the');
    disp('functionability! Current support level is version 6.5 up until 8.6');
    QTEMP2 = [0 0];
  end;    
  
  QmatNMRsettings.figDefaultLeft			= 1 + QTEMP2(1);		%DO NOT CHANGE THESE !
  QmatNMRsettings.figDefaultBottom		= QmatNMR.ComputerScreenSize(4) - 700 - QTEMP2(2);	%DO NOT CHANGE THESE !
  QmatNMRsettings.figDefaultWidth			= 1140;				%DO NOT CHANGE THESE !
  QmatNMRsettings.figDefaultHeight		= 700;				%DO NOT CHANGE THESE !
  
  QmatNMRsettings.figDefaultLeftNorm		= 0.0063;		
  QmatNMRsettings.figDefaultBottomNorm		= 0.2578;		
  QmatNMRsettings.figDefaultWidthNorm		= 0.8906;		
  QmatNMRsettings.figDefaultHeightNorm		= 0.6836;
  
  QmatNMRsettings.Q2D3DViewerDefaultLeft 		= 0.1406;
  QmatNMRsettings.Q2D3DViewerDefaultBottom 	= 0.1592;
  QmatNMRsettings.Q2D3DViewerDefaultWidth 	= 0.7188;
  QmatNMRsettings.Q2D3DViewerDefaultHeight	= 0.7812;
  
  QmatNMRsettings.Q2D3DViewerPanelDefaultLeft 	= 0.0538;
  QmatNMRsettings.Q2D3DViewerPanelDefaultBottom 	= 0.0056;
  QmatNMRsettings.Q2D3DViewerPanelDefaultWidth 	= 0.8681;
  QmatNMRsettings.Q2D3DViewerPanelDefaultHeight	= 0.1889;
  
  QmatNMR.figLeft					= QmatNMRsettings.figDefaultLeft;
  QmatNMR.figBottom				= QmatNMRsettings.figDefaultBottom;
  QmatNMR.figWidth				= QmatNMRsettings.figDefaultWidth;
  QmatNMR.figHeight				= QmatNMRsettings.figDefaultHeight;
  
  QmatNMR.figLeftNorm              		= QmatNMRsettings.figDefaultLeftNorm;               
  QmatNMR.figBottomNorm            		= QmatNMRsettings.figDefaultBottomNorm;               
  QmatNMR.figWidthNorm             		= QmatNMRsettings.figDefaultWidthNorm;               
  QmatNMR.figHeightNorm            		= QmatNMRsettings.figDefaultHeightNorm;
  
  QmatNMR.Q2D3DViewerLeft          		= QmatNMRsettings.Q2D3DViewerDefaultLeft;
  QmatNMR.Q2D3DViewerBottom        		= QmatNMRsettings.Q2D3DViewerDefaultBottom;
  QmatNMR.Q2D3DViewerWidth         		= QmatNMRsettings.Q2D3DViewerDefaultWidth;
  QmatNMR.Q2D3DViewerHeight        		= QmatNMRsettings.Q2D3DViewerDefaultHeight;
  
  QmatNMR.Q2D3DViewerPanelLeft     		= QmatNMRsettings.Q2D3DViewerPanelDefaultLeft;
  QmatNMR.Q2D3DViewerPanelBottom   		= QmatNMRsettings.Q2D3DViewerPanelDefaultBottom;
  QmatNMR.Q2D3DViewerPanelWidth    		= QmatNMRsettings.Q2D3DViewerPanelDefaultWidth;
  QmatNMR.Q2D3DViewerPanelHeight   		= QmatNMRsettings.Q2D3DViewerPanelDefaultHeight;
  
  
  %
  %The default color scheme 1 ("Default")
  %
  QmatNMR.DefaultColorScheme1.Frame1      = [0.20 0.20 0.20];
  QmatNMR.DefaultColorScheme1.Frame2      = [0.20 0.20 0.40];
  QmatNMR.DefaultColorScheme1.UImenuFore  = [0.00 0.00 0.00];
  QmatNMR.DefaultColorScheme1.Figure1Back = [0.12 0.12 0.12];
  QmatNMR.DefaultColorScheme1.Figure2Back = [0.20 0.20 0.40];
  QmatNMR.DefaultColorScheme1.AxisBack    = [0.00 0.00 0.00];
  QmatNMR.DefaultColorScheme1.AxisFore    = [1.00 1.00 1.00];
  QmatNMR.DefaultColorScheme1.Button1Fore = [0.00 0.00 0.00];
  QmatNMR.DefaultColorScheme1.Button1Back = [0.70 0.70 0.70];
  QmatNMR.DefaultColorScheme1.Button2Fore = [1.00 1.00 0.00];
  QmatNMR.DefaultColorScheme1.Button2Back = [0.00 0.00 0.00];
  QmatNMR.DefaultColorScheme1.Button3Fore = [1.00 1.00 0.00];
  QmatNMR.DefaultColorScheme1.Button3Back = [0.40 0.10 0.10];
  QmatNMR.DefaultColorScheme1.Button4Fore = [1.00 1.00 0.00];
  QmatNMR.DefaultColorScheme1.Button4Back = [0.10 0.40 0.10];
  QmatNMR.DefaultColorScheme1.Button5Fore = [1.00 1.00 0.00];
  QmatNMR.DefaultColorScheme1.Button5Back = [0.20 0.20 0.40];
  QmatNMR.DefaultColorScheme1.Button6Fore = [1.00 1.00 0.00];
  QmatNMR.DefaultColorScheme1.Button6Back = [0.30 0.00 0.30];
  QmatNMR.DefaultColorScheme1.Button7Fore = [1.00 1.00 1.00];
  QmatNMR.DefaultColorScheme1.Button7Back = [0.00 0.00 0.00];
  QmatNMR.DefaultColorScheme1.Button8Fore = [1.00 1.00 1.00];
  QmatNMR.DefaultColorScheme1.Button8Back = [0.40 0.10 0.10];
  QmatNMR.DefaultColorScheme1.Button9Fore = [1.00 1.00 1.00];
  QmatNMR.DefaultColorScheme1.Button9Back = [0.10 0.40 0.10];
  QmatNMR.DefaultColorScheme1.Button10Fore= [1.00 1.00 1.00];
  QmatNMR.DefaultColorScheme1.Button10Back= [0.20 0.20 0.40];
  QmatNMR.DefaultColorScheme1.Button11Fore= [0.00 0.00 0.00];
  QmatNMR.DefaultColorScheme1.Button11Back= [0.90 0.90 0.20];
  QmatNMR.DefaultColorScheme1.Button12Fore= [1.00 1.00 0.00];
  QmatNMR.DefaultColorScheme1.Button12Back= [0.12 0.12 0.12];
  QmatNMR.DefaultColorScheme1.Button13Fore= [1.00 1.00 1.00];
  QmatNMR.DefaultColorScheme1.Button13Back= [0.12 0.12 0.12];
  QmatNMR.DefaultColorScheme1.Button14Fore= [1.00 0.00 0.00];
  QmatNMR.DefaultColorScheme1.Button14Back= [1.00 1.00 1.00];
  QmatNMR.DefaultColorScheme1.Text1Fore   = [1.00 1.00 1.00];
  QmatNMR.DefaultColorScheme1.Text1Back   = 'none';
  QmatNMR.DefaultColorScheme1.Text2Fore   = [0.49 0.41 1.00];
  QmatNMR.DefaultColorScheme1.Text2Back   = 'none';
  QmatNMR.DefaultColorScheme1.Text3Fore   = [1.00 1.00 1.00];
  QmatNMR.DefaultColorScheme1.Text3Back   = 'none';
  QmatNMR.DefaultColorScheme1.LineMain    = 'y';
  QmatNMR.DefaultColorScheme1.LineDual    = ['crbmwg'];
  
  
  %
  %The default color scheme 2 ("classic")
  %
  QmatNMR.DefaultColorScheme2.Frame1      = [0.40 0.00 0.00];
  QmatNMR.DefaultColorScheme2.Frame2      = [0.00 0.00 0.40];
  QmatNMR.DefaultColorScheme2.UImenuFore  = [0.00 0.00 0.00];
  QmatNMR.DefaultColorScheme2.Figure1Back = [0.00 0.00 0.00];
  QmatNMR.DefaultColorScheme2.Figure2Back = [0.20 0.20 0.40];
  QmatNMR.DefaultColorScheme2.AxisBack    = 'none';
  QmatNMR.DefaultColorScheme2.AxisFore    = [1.00 1.00 1.00];
  QmatNMR.DefaultColorScheme2.Button1Fore = [0.00 0.00 0.00];
  QmatNMR.DefaultColorScheme2.Button1Back = [0.70 0.70 0.70];
  QmatNMR.DefaultColorScheme2.Button2Fore = [1.00 1.00 0.00];
  QmatNMR.DefaultColorScheme2.Button2Back = [0.00 0.00 0.00];
  QmatNMR.DefaultColorScheme2.Button3Fore = [1.00 1.00 0.00];
  QmatNMR.DefaultColorScheme2.Button3Back = [0.40 0.00 0.00];
  QmatNMR.DefaultColorScheme2.Button4Fore = [1.00 1.00 0.00];
  QmatNMR.DefaultColorScheme2.Button4Back = [0.00 0.40 0.00];
  QmatNMR.DefaultColorScheme2.Button5Fore = [1.00 1.00 0.00];
  QmatNMR.DefaultColorScheme2.Button5Back = [0.00 0.00 0.40];
  QmatNMR.DefaultColorScheme2.Button6Fore = [1.00 1.00 0.00];
  QmatNMR.DefaultColorScheme2.Button6Back = [0.30 0.00 0.30];
  QmatNMR.DefaultColorScheme2.Button7Fore = [1.00 1.00 1.00];
  QmatNMR.DefaultColorScheme2.Button7Back = [0.00 0.00 0.00];
  QmatNMR.DefaultColorScheme2.Button8Fore = [1.00 1.00 1.00];
  QmatNMR.DefaultColorScheme2.Button8Back = [0.40 0.00 0.00];
  QmatNMR.DefaultColorScheme2.Button9Fore = [1.00 1.00 1.00];
  QmatNMR.DefaultColorScheme2.Button9Back = [0.00 0.40 0.00];
  QmatNMR.DefaultColorScheme2.Button10Fore= [1.00 1.00 1.00];
  QmatNMR.DefaultColorScheme2.Button10Back= [0.00 0.00 0.40];
  QmatNMR.DefaultColorScheme2.Button11Fore= [0.00 0.00 0.00];
  QmatNMR.DefaultColorScheme2.Button11Back= [1.00 1.00 0.00];
  QmatNMR.DefaultColorScheme2.Button12Fore= [1.00 1.00 0.00];
  QmatNMR.DefaultColorScheme2.Button12Back= [0.00 0.00 0.00];
  QmatNMR.DefaultColorScheme2.Button13Fore= [1.00 1.00 1.00];
  QmatNMR.DefaultColorScheme2.Button13Back= [0.00 0.00 0.00];
  QmatNMR.DefaultColorScheme2.Button14Fore= [1.00 0.00 0.00];
  QmatNMR.DefaultColorScheme2.Button14Back= [1.00 1.00 1.00];
  QmatNMR.DefaultColorScheme2.Text1Fore   = [1.00 1.00 1.00];
  QmatNMR.DefaultColorScheme2.Text1Back   = 'none';
  QmatNMR.DefaultColorScheme2.Text2Fore   = [0.49 0.41 1.00];
  QmatNMR.DefaultColorScheme2.Text2Back   = 'none';
  QmatNMR.DefaultColorScheme2.Text3Fore   = [1.00 1.00 1.00];
  QmatNMR.DefaultColorScheme2.Text3Back   = 'none';
  QmatNMR.DefaultColorScheme2.LineMain    = 'y';
  QmatNMR.DefaultColorScheme2.LineDual    = ['crbmwg'];
  
  %
  %The default color scheme 3 ("boring grey", loosely based on Matlab 5 and higher settings)
  %
  QmatNMR.DefaultColorScheme3.Frame1      = [0.50 0.50 0.50];
  QmatNMR.DefaultColorScheme3.Frame2      = [0.50 0.50 0.50];
  QmatNMR.DefaultColorScheme3.UImenuFore  = [0.00 0.00 0.00];
  QmatNMR.DefaultColorScheme3.Figure1Back = [0.80 0.80 0.80];
  QmatNMR.DefaultColorScheme3.Figure2Back = [0.80 0.80 0.80];
  QmatNMR.DefaultColorScheme3.AxisBack    = [1.00 1.00 1.00];
  QmatNMR.DefaultColorScheme3.AxisFore    = [0.00 0.00 0.00];
  QmatNMR.DefaultColorScheme3.Button1Fore = [0.00 0.00 0.00];
  QmatNMR.DefaultColorScheme3.Button1Back = [0.70 0.70 0.70];
  QmatNMR.DefaultColorScheme3.Button2Fore = [1.00 1.00 0.00];
  QmatNMR.DefaultColorScheme3.Button2Back = [0.30 0.30 0.30];
  QmatNMR.DefaultColorScheme3.Button3Fore = [1.00 1.00 0.00];
  QmatNMR.DefaultColorScheme3.Button3Back = [0.55 0.30 0.30];
  QmatNMR.DefaultColorScheme3.Button4Fore = [1.00 1.00 0.00];
  QmatNMR.DefaultColorScheme3.Button4Back = [0.30 0.45 0.30];
  QmatNMR.DefaultColorScheme3.Button5Fore = [1.00 1.00 0.00];
  QmatNMR.DefaultColorScheme3.Button5Back = [0.30 0.30 0.45];
  QmatNMR.DefaultColorScheme3.Button6Fore = [1.00 1.00 0.00];
  QmatNMR.DefaultColorScheme3.Button6Back = [0.30 0.20 0.30];
  QmatNMR.DefaultColorScheme3.Button7Fore = [1.00 1.00 1.00];
  QmatNMR.DefaultColorScheme3.Button7Back = [0.30 0.30 0.30];
  QmatNMR.DefaultColorScheme3.Button8Fore = [1.00 1.00 1.00];
  QmatNMR.DefaultColorScheme3.Button8Back = [0.55 0.30 0.30];
  QmatNMR.DefaultColorScheme3.Button9Fore = [1.00 1.00 1.00];
  QmatNMR.DefaultColorScheme3.Button9Back = [0.30 0.45 0.30];
  QmatNMR.DefaultColorScheme3.Button10Fore= [1.00 1.00 1.00];
  QmatNMR.DefaultColorScheme3.Button10Back= [0.30 0.30 0.45];
  QmatNMR.DefaultColorScheme3.Button11Fore= [0.00 0.00 0.00];
  QmatNMR.DefaultColorScheme3.Button11Back= [0.70 0.70 0.70];
  QmatNMR.DefaultColorScheme3.Button12Fore= [0.00 0.00 0.00];
  QmatNMR.DefaultColorScheme3.Button12Back= [0.80 0.80 0.80];
  QmatNMR.DefaultColorScheme3.Button13Fore= [0.00 0.00 0.00];
  QmatNMR.DefaultColorScheme3.Button13Back= [0.80 0.80 0.80];
  QmatNMR.DefaultColorScheme3.Button14Fore= [1.00 0.00 0.00];
  QmatNMR.DefaultColorScheme3.Button14Back= [1.00 1.00 1.00];
  QmatNMR.DefaultColorScheme3.Text1Fore   = [0.00 0.00 0.00];
  QmatNMR.DefaultColorScheme3.Text1Back   = 'none';
  QmatNMR.DefaultColorScheme3.Text2Fore   = [1.00 0.20 0.00];
  QmatNMR.DefaultColorScheme3.Text2Back   = 'none';
  QmatNMR.DefaultColorScheme3.Text3Fore   = [0.10 0.10 1.00];
  QmatNMR.DefaultColorScheme3.Text3Back   = 'none';
  QmatNMR.DefaultColorScheme3.LineMain    = 'b';
  QmatNMR.DefaultColorScheme3.LineDual    = ['ymgkrc'];
  
  %
  %The default color scheme 4 ("psycho red", by Bernd Fritzinger)
  %
  QmatNMR.DefaultColorScheme4.Frame1      = [0.60 0.30 0.00];
  QmatNMR.DefaultColorScheme4.Frame2      = [0.50 0.50 0.50];
  QmatNMR.DefaultColorScheme4.UImenuFore  = [0.00 0.00 0.00];
  QmatNMR.DefaultColorScheme4.Figure1Back = [0.50 0.10 0.00];
  QmatNMR.DefaultColorScheme4.Figure2Back = [0.70 0.40 0.00];
  QmatNMR.DefaultColorScheme4.AxisBack    = [0.00 0.00 0.00];
  QmatNMR.DefaultColorScheme4.AxisFore    = [1.00 1.00 1.00];
  QmatNMR.DefaultColorScheme4.Button1Fore = [0.00 0.00 0.00];
  QmatNMR.DefaultColorScheme4.Button1Back = [0.70 0.70 0.70];
  QmatNMR.DefaultColorScheme4.Button2Fore = [1.00 1.00 0.00];
  QmatNMR.DefaultColorScheme4.Button2Back = [0.30 0.30 0.30];
  QmatNMR.DefaultColorScheme4.Button3Fore = [0.00 0.00 1.00];
  QmatNMR.DefaultColorScheme4.Button3Back = [0.90 0.60 0.00];
  QmatNMR.DefaultColorScheme4.Button4Fore = [1.00 1.00 0.00];
  QmatNMR.DefaultColorScheme4.Button4Back = [0.10 0.40 0.10];
  QmatNMR.DefaultColorScheme4.Button5Fore = [1.00 1.00 0.00];
  QmatNMR.DefaultColorScheme4.Button5Back = [0.10 0.20 0.65];
  QmatNMR.DefaultColorScheme4.Button6Fore = [1.00 1.00 0.00];
  QmatNMR.DefaultColorScheme4.Button6Back = [0.50 0.20 0.50];
  QmatNMR.DefaultColorScheme4.Button7Fore = [1.00 1.00 1.00];
  QmatNMR.DefaultColorScheme4.Button7Back = [0.05 0.05 0.40];
  QmatNMR.DefaultColorScheme4.Button8Fore = [1.00 1.00 1.00];
  QmatNMR.DefaultColorScheme4.Button8Back = [0.55 0.30 0.30];
  QmatNMR.DefaultColorScheme4.Button9Fore = [1.00 1.00 1.00];
  QmatNMR.DefaultColorScheme4.Button9Back = [0.10 0.40 0.10];
  QmatNMR.DefaultColorScheme4.Button10Fore= [1.00 1.00 1.00];
  QmatNMR.DefaultColorScheme4.Button10Back= [0.10 0.20 0.65];
  QmatNMR.DefaultColorScheme4.Button11Fore= [0.00 0.00 0.00];
  QmatNMR.DefaultColorScheme4.Button11Back= [0.70 0.70 0.70];
  QmatNMR.DefaultColorScheme4.Button12Fore= [1.00 1.00 1.00];
  QmatNMR.DefaultColorScheme4.Button12Back= [0.50 0.10 0.00];
  QmatNMR.DefaultColorScheme4.Button13Fore= [1.00 1.00 1.00];
  QmatNMR.DefaultColorScheme4.Button13Back= [0.50 0.10 0.00];
  QmatNMR.DefaultColorScheme4.Button14Fore= [1.00 0.00 0.00];
  QmatNMR.DefaultColorScheme4.Button14Back= [1.00 1.00 1.00];
  QmatNMR.DefaultColorScheme4.Text1Fore   = [1.00 1.00 1.00];
  QmatNMR.DefaultColorScheme4.Text1Back   = 'none';
  QmatNMR.DefaultColorScheme4.Text2Fore   = [1.00 0.20 0.00];
  QmatNMR.DefaultColorScheme4.Text2Back   = 'none';
  QmatNMR.DefaultColorScheme4.Text3Fore   = [0.10 0.10 0.80];
  QmatNMR.DefaultColorScheme4.Text3Back   = 'none';
  QmatNMR.DefaultColorScheme4.LineMain    = 'w';
  QmatNMR.DefaultColorScheme4.LineDual    = ['ymgbrc'];
  
  %
  %The default color scheme 5 ("Blue Gene")
  %
  QmatNMR.DefaultColorScheme5.Frame1      = [0.10 0.15 0.25];
  QmatNMR.DefaultColorScheme5.Frame2      = [0.10 0.15 0.25];
  QmatNMR.DefaultColorScheme5.UImenuFore  = [0.00 0.00 0.00];
  QmatNMR.DefaultColorScheme5.Figure1Back = [0.20 0.30 0.50];
  QmatNMR.DefaultColorScheme5.Figure2Back = [0.10 0.15 0.25];
  QmatNMR.DefaultColorScheme5.AxisBack    = [0.25 0.25 0.25];
  QmatNMR.DefaultColorScheme5.AxisFore    = [1.00 1.00 1.00];
  QmatNMR.DefaultColorScheme5.Button1Fore = [0.00 0.00 0.00];
  QmatNMR.DefaultColorScheme5.Button1Back = [0.60 0.60 0.60];
  QmatNMR.DefaultColorScheme5.Button2Fore = [1.00 1.00 0.00];
  QmatNMR.DefaultColorScheme5.Button2Back = [0.30 0.30 0.30];
  QmatNMR.DefaultColorScheme5.Button3Fore = [1.00 1.00 0.00];
  QmatNMR.DefaultColorScheme5.Button3Back = [0.55 0.25 0.25];
  QmatNMR.DefaultColorScheme5.Button4Fore = [1.00 1.00 0.00];
  QmatNMR.DefaultColorScheme5.Button4Back = [0.25 0.45 0.25];
  QmatNMR.DefaultColorScheme5.Button5Fore = [1.00 1.00 0.00];
  QmatNMR.DefaultColorScheme5.Button5Back = [0.25 0.25 0.45];
  QmatNMR.DefaultColorScheme5.Button6Fore = [1.00 1.00 0.00];
  QmatNMR.DefaultColorScheme5.Button6Back = [0.30 0.10 0.30];
  QmatNMR.DefaultColorScheme5.Button7Fore = [1.00 1.00 1.00];
  QmatNMR.DefaultColorScheme5.Button7Back = [0.30 0.30 0.30];
  QmatNMR.DefaultColorScheme5.Button8Fore = [1.00 1.00 1.00];
  QmatNMR.DefaultColorScheme5.Button8Back = [0.55 0.25 0.25];
  QmatNMR.DefaultColorScheme5.Button9Fore = [1.00 1.00 1.00];
  QmatNMR.DefaultColorScheme5.Button9Back = [0.25 0.45 0.25];
  QmatNMR.DefaultColorScheme5.Button10Fore= [1.00 1.00 1.00];
  QmatNMR.DefaultColorScheme5.Button10Back= [0.25 0.25 0.45];
  QmatNMR.DefaultColorScheme5.Button11Fore= [0.00 0.00 0.00];
  QmatNMR.DefaultColorScheme5.Button11Back= [0.70 0.70 0.70];
  QmatNMR.DefaultColorScheme5.Button12Fore= [0.00 0.00 0.00];
  QmatNMR.DefaultColorScheme5.Button12Back= [0.80 0.80 0.80];
  QmatNMR.DefaultColorScheme5.Button13Fore= [0.00 0.00 0.00];
  QmatNMR.DefaultColorScheme5.Button13Back= [0.80 0.80 0.80];
  QmatNMR.DefaultColorScheme5.Button14Fore= [1.00 0.00 0.00];
  QmatNMR.DefaultColorScheme5.Button14Back= [1.00 1.00 1.00];
  QmatNMR.DefaultColorScheme5.Text1Fore   = [1.00 1.00 0.00];
  QmatNMR.DefaultColorScheme5.Text1Back   = 'none';
  QmatNMR.DefaultColorScheme5.Text2Fore   = [1.00 0.60 0.00];
  QmatNMR.DefaultColorScheme5.Text2Back   = 'none';
  QmatNMR.DefaultColorScheme5.Text3Fore   = [1.00 1.00 0.00];
  QmatNMR.DefaultColorScheme5.Text3Back   = 'none';
  QmatNMR.DefaultColorScheme5.LineMain    = 'y';
  QmatNMR.DefaultColorScheme5.LineDual    = ['bmgkrc'];
  
  QmatNMRsettings.DefaultColorScheme = QmatNMR.DefaultColorScheme1;
  
  %
  %
  %
  QmatNMRsettings.DefaultAxisCarrierIndex  = 513;
  QmatNMRsettings.DefaultAxisCarrierIndex1 = 513; 
  QmatNMRsettings.DefaultAxisCarrierIndex2 = 513;
  QmatNMRsettings.DefaultAxisReference1D.ReferenceFrequency = 100;
  QmatNMRsettings.DefaultAxisReference1D.ReferenceValue = 0;
  QmatNMRsettings.DefaultAxisReference1D.ReferenceUnit = 1;
  QmatNMRsettings.DefaultAxisReference2D.ReferenceFrequency = [100 100];
  QmatNMRsettings.DefaultAxisReference2D.ReferenceValue = [0 0];
  QmatNMRsettings.DefaultAxisReference2D.ReferenceUnit = [1 1];
  QmatNMRsettings.DefaultAxisReferencekHz= 0; 		%1D mode
  QmatNMRsettings.DefaultAxisReferencekHz1= 0; 		%TD2
  QmatNMRsettings.DefaultAxisReferencekHz2= 0; 		%TD1
  QmatNMRsettings.DefaultAxisReferencePPM= 0;		%1D mode
  QmatNMRsettings.DefaultAxisReferencePPM1= 0; 		%TD2
  QmatNMRsettings.DefaultAxisReferencePPM2= 0;		%TD1
  QmatNMRsettings.DefaultColormap 	= 4;	%hsv
  QmatNMRsettings.Defaultfftstatus 	= 1;
  QmatNMRsettings.DefaultLineColor	= 'y';
  QmatNMRsettings.DefaultLineType	= '-';
  QmatNMRsettings.DefaultLineWidth	= 0.5;
  QmatNMRsettings.DefaultMarkerSize	= 6;
  QmatNMRsettings.DefaultMarkerType	= '';
  QmatNMRsettings.DefaultNegConts	= 1;
  QmatNMRsettings.DefaultPaperOrientation= 1;	%portrait
  QmatNMRsettings.DefaultPaperSize	= 8;	%A4
  QmatNMRsettings.DefaultRulerXAxis1FREQ = 1;	%by default select kHz axis for TD2
  QmatNMRsettings.DefaultRulerXAxis2FREQ = 1;	%by default select kHz axis for TD1
  QmatNMRsettings.DefaultRulerXAxis1TIME = 1;	%by default select kHz axis for TD2
  QmatNMRsettings.DefaultRulerXAxis2TIME = 1;	%by default select kHz axis for TD1
  QmatNMRsettings.DefaultTextAngle	= 'normal';
  QmatNMRsettings.DefaultTextFont		= 'helvetica';
  QmatNMRsettings.DefaultTextSize		= 12;
  QmatNMRsettings.DefaultTextWeight	= 'normal';
  QmatNMRsettings.DefaultUIFontSize	= 12;
  QmatNMRsettings.DefaultUnDo1D 		= 1;
  QmatNMRsettings.DefaultUnDo2D 		= 1;
  QmatNMRsettings.ShowLogo		= 1;
  QmatNMRsettings.matNMRSafety		= 1;
  QmatNMRsettings.Q1DMenu			= 0;
  QmatNMRsettings.Q2DMenu 		= 0;
  QmatNMRsettings.PhaseMenu 		= 0;
  QmatNMRsettings.DefaultReuseLastDirectory 	= 0;
  QmatNMRsettings.DefaultDirectory 	= '.';
  QmatNMRsettings.DefaultSearchProfile = '*.*';
  
  QmatNMR.TextFont        		= QmatNMRsettings.DefaultTextFont;
  QmatNMR.TextSize        		= QmatNMRsettings.DefaultTextSize;
  QmatNMR.TextAngle       		= QmatNMRsettings.DefaultTextAngle;
  QmatNMR.TextWeight       		= QmatNMRsettings.DefaultTextWeight;
  
  
  %
  % Other settable variables
  %
  
    QmatNMRsettings.Defaultyschaal 		= 0;
    QmatNMRsettings.Defaultgridvar 		= 0;
    QmatNMRsettings.Defaultunittype 		= 0;
    QmatNMRsettings.Defaultxschaal 		= 1;
    QmatNMRsettings.Defaultyrelative 		= 0;
    QmatNMRsettings.Defaultunder 			= 1;
    QmatNMRsettings.Defaultover 			= 100;
    QmatNMRsettings.Defaultnumbcont 		= 10;
    QmatNMRsettings.Defaultaz 			= 45;
    QmatNMRsettings.Defaultel 			= 45;
    QmatNMRsettings.Defaultstackaz 		= 45;
    QmatNMRsettings.Defaultstackel 		= 45;
    QmatNMRsettings.Defaultfour2 			= 1;
    QmatNMRsettings.Defaultfour1 			= 3;
    QmatNMRsettings.DefaultNegContsDefault 	= 1;
    QmatNMR.matNMRSafety 				= 1;
  
  
  %
  % Other variables ...
  %
  QmatNMR.MacroLength 		= 15;		%===>>> THIS MUST BE BEFORE DEFITION OF FIRST USE OF ADDTOMACRO !!!!
  QmatNMR.AddVariablesCommonString = 'name';
  QmatNMR.AddVariablesNewName 	= 'name2';
  QmatNMR.AddVariablesNormalize 	= 0;
  QmatNMR.AddVariablesRange 	= '1:1';
  QmatNMR.AddVariablesRetain 	= 1;
  QmatNMR.AllAxes 		= 0;
  QmatNMR.APosterioriHistory 	= '';
  QmatNMR.APosterioriHistoryEntry = 0;
  QmatNMR.APosterioriMacro 	= AddToMacro;
  QmatNMR.as1d 			= [0 1024];
  QmatNMR.ask 			= 0;
  QmatNMR.aswaarden		= [1 2 1 2];
  QmatNMR.Axis1D 			= (1:1024);
  QmatNMR.Axis1DPlot 		= 0;
  QmatNMR.Axis2D3DTD1 	    	= 0;
  QmatNMR.Axis2D3DTD1Plot		= 0;
  QmatNMR.Axis2D3DTD2 	    	= 0;
  QmatNMR.Axis2D3DTD2Plot 		= 0;
  QmatNMR.AxisHandle2D3D 		= 0;
  QmatNMR.AxisNR2D3D		= 1;
  QmatNMR.AxisPlotDirection 	= 'reverse';
  QmatNMR.AxisTD1 		= 1:1024;
  QmatNMR.AxisTD2 		= 1:1024;
  QmatNMR.az			= 45;
  QmatNMR.backup 			= 0;
  QmatNMR.Bar3DType 		= 1;
  QmatNMR.Basl1DAutoFlag 		= 1;
  QmatNMR.Basl1Dfig		= [];
  QmatNMR.Basl1DFunction 		= 1;
  QmatNMR.Basl1DOrder 		= 2;
  QmatNMR.Basl2Dfig		= [];
  QmatNMR.Basl2DFunction 		= 1;
  QmatNMR.Basl2DOrder 		= 2;
  QmatNMR.baslcornoise   		= 0;
  QmatNMR.BaslcorPeakList		= [];
  QmatNMR.bezigmetfase		= 0;
  QmatNMR.Black 			= 0;
  QmatNMR.BlockingTD1 		= 0;
  QmatNMR.BlockingTD2 		= 0;
  QmatNMR.blocklength		= 0;
  QmatNMR.BREAK 			= 0;
  QmatNMR.BrukerByteOrdering 	= 1;
  QmatNMR.BrukerFIDstatus 	= 1;
  QmatNMR.BrukerSpectrumName 	= '';
  QmatNMR.BusyWith1DPhaseCorrection = 0;
  QmatNMR.BusyWithExternalRef 	= 0;
  QmatNMR.BusyWithMacro		= 0;
  QmatNMR.BusyWithMacro3D 	= 0;
  QmatNMR.buttonList		= 0;
  QmatNMR.ByteOrder 		= 0;
  QmatNMR.CadzowLPSVDpoints 	= 1024;
  QmatNMR.CadzowNrFreqs 		= 1;
  QmatNMR.CadzowRepeat 		= 1;
  QmatNMR.CadzowSV 		= 0;
  QmatNMR.CadzowWindow 		= 0.33;
  QmatNMR.CadzowWindows 		= [];
  QmatNMR.c10 			= 0;
  QmatNMR.c16 			= 0;
  QmatNMR.c19 			= 0;
  QmatNMR.color			= QmatNMRsettings.DefaultColorScheme.LineDual;
  QmatNMR.ColorScheme 		= QmatNMRsettings.DefaultColorScheme;
  QmatNMR.command 		= 0;
  QmatNMR.command4		= 0;
  QmatNMR.ConcatenateDirection 	= 2;
  QmatNMR.ConcatenateTimes 	= 1;
  QmatNMR.ConnectAxisToVariable2D	= 0;
  QmatNMR.contcolorbar		= 0;
  QmatNMR.ContColorbarIndicator 	= 0;
  QmatNMR.Context2D3D 		= 0;
  QmatNMR.ContextMain 		= 0;
  QmatNMR.ContLightAz 		= 0;
  QmatNMR.ContLightEl 		= 0;
  QmatNMR.ContNrSubplots 		= 1;
  QmatNMR.Contourlast		= '0:0.1:1';
  QmatNMR.ContourLineSpec		= '';
  QmatNMR.ContSpecHistoryMacro 	= 0;
  QmatNMR.ContType		= 0;
  QmatNMR.Cos2Span 		= 1.0;
  QmatNMR.MacroConversionVariable = '';
  QmatNMR.CPM1 			= 0;
  QmatNMR.CPM1Plot 		= 0;
  QmatNMR.CPM2 			= 0;
  QmatNMR.CPM2Plot 		= 0;
  QmatNMR.CPM3 			= 0;
  QmatNMR.CPM3Plot		= 0;
  QmatNMR.CPMfilledcontours 	= 1;
  QmatNMR.CPMfullprobability 	= 0;
  QmatNMR.CPMmax 			= 100;
  QmatNMR.CPMmin  		= 0;
  QmatNMR.CPMmultiplier 		= 30;
  QmatNMR.CPMnumbcont 		= 100;
  QmatNMR.CPMthreshold 		= 0.05;
  QmatNMR.CPMvec1 		= 0;
  QmatNMR.CPMvec2 		= 0;
  QmatNMR.Crosshair2DSlices 	= 0;
  QmatNMR.CurrentColorMap  	= '';
  QmatNMR.CutLinesTD2 		= 0;
  QmatNMR.CutLinesTD1 		= 0;
  QmatNMR.CutLinestyle 		= 'w:';
  QmatNMR.CutRangeTD1 		= '';
  QmatNMR.CutRangeTD2 		= '';
  QmatNMR.CutSaveVariable 	= '';
  QmatNMR.CutSubplotValues 	= [];
  QmatNMR.CutTicksTD1 		= '';
  QmatNMR.CutTicksTD2 		= '';
  QmatNMR.DataPath1D 		= '';
  QmatNMR.DataPath2D 		= '';
  QmatNMR.DataFormat 		= 1;
  QmatNMR.DefaultDirectory 	= '.';
  QmatNMR.Diffalpha 		= 3;
  QmatNMR.Diffbeta 		= 2;
  QmatNMR.Diffdelta		= 1;
  QmatNMR.DiffDELTA 		= 1;
  QmatNMR.DiffFitArray 		= 0;
  QmatNMR.DiffFitResults 		= 0;
  QmatNMR.DiffGamma 		= 42.5774825;	%gyromagnetic ratio for protons in MHz/T
  QmatNMR.Difftau 		= 0;
  QmatNMR.Dim 			= 0;				%denotes a 1D spectrum
  QmatNMR.DisplayMode 		= 1; 		%by default use 'real' for display mode
  QmatNMR.doeopties 		= 0;
  QmatNMR.dph0 			= 0;		%increment in oth order phase correction
  QmatNMR.dph1 			= 0;		%increment in 1st order phase correction
  QmatNMR.dph2 			= 0;		%increment in 2nd order phase correction
  QmatNMR.dualaxis 		= 0;
  QmatNMR.dualaxisincr 		= 0;
  QmatNMR.dualaxisnull 		= 0;
  QmatNMR.dualaxisPlot 		= 0;
  QmatNMR.DualPlotCommand	= 'plot(QmatNMR.dualaxisPlot, real(QmatNMR.dual), [QmatNMR.color(rem(QmatNMR.nrspc, length(QmatNMR.color)) + 1) QmatNMR.MarkerType QmatNMR.LineType]);';
  QmatNMR.EchoMaximum 		= 1;
  QmatNMR.el			= 45;
  QmatNMR.ExecutingMacro 		= AddToMacro;
  QmatNMR.ExecutingMacro3D 	= AddToMacro;
  QmatNMR.ExternalReferenceFreq  = 0;
  QmatNMR.ExternalReferenceUnit 	= 1;
  QmatNMR.ExternalReferenceValue = 0;
  QmatNMR.ExternalReferenceVar 	= '';
  QmatNMR.fase0 			= 0;		%value for oth order phase correction
  QmatNMR.fase1 			= 0;		%value for 1st order phase correction
  QmatNMR.fase1start 		= 0;
  QmatNMR.fase1startIndex		= 513;
  QmatNMR.fase2 			= 0;		%value for 2nd order phase correction
  QmatNMR.fftstatus 		= 1;		%always multiply 1st pnt of FID times 0.5 !!
  QmatNMR.FIDRangeIn 		= '1';
  QmatNMR.FIDRangeOut		= '1';
  QmatNMR.FIDstatus		= 2;
  QmatNMR.FIDstatus2D1		= 2;
  QmatNMR.FIDstatus2D2		= 2;
  QmatNMR.FIDstatusLast  		= 2;
  QmatNMR.Fig			= [];		%the handle for the matNMR main figure window
  QmatNMR.Fig2D3D			= [];
  QmatNMR.fig3D			= [];		%the handle for the 3D panel in the matNMR main figure window
  QmatNMR.FigureStepwise 		= [];
  QmatNMR.FitPerformed 		= 0;
  QmatNMR.FitResults		= 0;
  QmatNMR.FlagCutSpectrum		= 0;
  QmatNMR.four1			= 0;	%standard real FT in TD1 (TPPI)
  QmatNMR.four2			= 1;	%standard complex FT in TD2
  QmatNMR.gamma1			= 1;	%positive gyromagnetic ratio for TD2 in main window
  QmatNMR.gamma1d			= 1;	%positive gyromagnetic ratio for 1D
  QmatNMR.gamma2			= 1;	%positive gyromagnetic ratio for TD1 in main window
  QmatNMR.gamma2d1		= 1;	%positive gyromagnetic ratio for TD2 in 2D/3D viewer
  QmatNMR.gamma2d2		= 1;	%positive gyromagnetic ratio for TD1 in 2D/3D Viewer
  QmatNMR.gb			= 0;				%Gaussian broadening factor
  QmatNMR.GENERICByteOrdering 	= 1;
  QmatNMR.GENERICDataFormat 	= 1;
  QmatNMR.GENERICDataOrdering 	= 1;
  QmatNMR.GENERICHeaderBytes1 	= 0;
  QmatNMR.GENERICHeaderBytes2 	= 0;
  QmatNMR.GetString		= '';
  QmatNMR.GetVar			= 0;
  QmatNMR.GradientAxisDwell	= 0;
  QmatNMR.GradientAxisStart 	= 0;
  QmatNMR.gridvar 		= 0;
  QmatNMR.History			= str2mat('', 'Processing History :', '', 'Name of the variable          :  defaultspec', 'size of the new 1D FID is     :  1024 points');
  QmatNMR.History2D3D		= '';
  QmatNMR.HistoryMacro 		= AddToMacro;
  QmatNMR.Hold2D3D 		= 0;
  QmatNMR.howFT 			= 1;
  QmatNMR.HyperComplex 		= 1;
  QmatNMR.IntegrateVar 		= 'QResultsVar';
  QmatNMR.IntegrationValue 	= 1;
  QmatNMR.InverseFTflag 		= 0;
  QmatNMR.kolomnr 		= 1;
  QmatNMR.last.Spectrum		= '';	%variable for reloading last 1D/2D spectrum
  QmatNMR.LastDualAxis 		= '';
  QmatNMR.LastDualType 		= 3;
  QmatNMR.LastMacroVariable 	= '';
  QmatNMR.LastVar			= 1;
  QmatNMR.LastVariableNames1D(1).Axis 		= '';
  QmatNMR.LastVariableNames1D(1).Spectrum 	= '';
  QmatNMR.LastVariableNames2D(1).AxisTD1 	= '';
  QmatNMR.LastVariableNames2D(1).AxisTD2 	= '';
  QmatNMR.LastVariableNames2D(1).Spectrum 	= '';
  QmatNMR.LastVariableNames3D(1).AxisTD1 	= '';
  QmatNMR.LastVariableNames3D(1).AxisTD2 	= '';
  QmatNMR.LastVariableNames3D(1).Spectrum 	= '';
  for QTEMP40=2:10
    QmatNMR.LastVariableNames1D(QTEMP40).Spectrum 	= '';
    QmatNMR.LastVariableNames1D(QTEMP40).Axis 	= '';
  
    QmatNMR.LastVariableNames2D(QTEMP40).Spectrum 	= '';
    QmatNMR.LastVariableNames2D(QTEMP40).AxisTD2 	= '';
    QmatNMR.LastVariableNames2D(QTEMP40).AxisTD1 	= '';
  
    QmatNMR.LastVariableNames3D(QTEMP40).Spectrum 	= '';
    QmatNMR.LastVariableNames3D(QTEMP40).AxisTD2 	= '';
    QmatNMR.LastVariableNames3D(QTEMP40).AxisTD1 	= '';
  end
  QmatNMR.lb 			= 0;				%Line broadening factor
  QmatNMR.lbstatus		= 0;				%no apodization yet ...
  QmatNMR.lbTempstatus 		= 0;
  QmatNMR.leginp			= [];
  QmatNMR.leginp2			= [];
  QmatNMR.leginp3			= [];
  QmatNMR.leginp4 		= [];
  QmatNMR.leginp5 		= [];
  QmatNMR.leginp6 		= [];
  QmatNMR.LineColor 		= QmatNMRsettings.DefaultColorScheme.LineMain;
  QmatNMR.LineTag 		= '';
  QmatNMR.LineTag1D 		= '';
  QmatNMR.LineTag2D 		= '';
  QmatNMR.LineType 		= '- ';
  QmatNMR.LoadINTOmatNMRDirectly = 1;
  QmatNMR.LogoDeleteNecessary 	= 0;
  QmatNMR.lpNrFreqs 		= 1;
  QmatNMR.lpNrPoints 		= 1;
  QmatNMR.lpNrPointsToUse 	= 0;
  QmatNMR.LPPeakList 		= 0;
  QmatNMR.LPPeakListIndices 	= 0;
  QmatNMR.lpSNratio		= 1000;
  QmatNMR.Macro 			= AddToMacro;
  QmatNMR.MarkerType		= '  ';
  QmatNMR.matNMRdate		= dir(which('nmr.m'));
  QmatNMR.matNMRRunMacroFlag 	= 0;
  QmatNMR.maxY 			= 1024;
  QmatNMR.MEMNrPoints 		= 1;
  QmatNMR.MEMNrPointsToUse 	= 0;
  QmatNMR.MEMPeakList 		= 0;
  QmatNMR.MEMPeakListIndices 	= 0;
  QmatNMR.MEMOrder		= -1;
  QmatNMR.menu1d 			= 1;
  QmatNMR.menu2d 			= 1;
  QmatNMR.mesh			= 0;
  QmatNMR.meshcolorbar		= 0;
  QmatNMR.MeshNrSubplots 		= 1;
  QmatNMR.min 			= 0;
  QmatNMR.minY 			= 0;
  QmatNMR.multcont       		= 1;
  QmatNMR.namelast		= 'name';
  QmatNMR.negcont			= 1;
  QmatNMR.NewAxisTD1 		= [];
  QmatNMR.NewAxisTD2 		= [];
  QmatNMR.newinlist.Axis 		= '';
  QmatNMR.newinlist.AxisTD1 	= '';
  QmatNMR.newinlist.AxisTD2	= '';
  QmatNMR.newinlist.Spectrum 	= '';
  QmatNMR.NormalizeVariablesFlag = 1;
  QmatNMR.NrDigitalFilter	= 0;
  QmatNMR.NrLeftShift 		= 0;
  QmatNMR.nrspc			= 0;
  QmatNMR.NucleusTD2 		= '';
  QmatNMR.NucleusTD1 		= '';
  QmatNMR.numbcont		= 10;
  QmatNMR.numbstructs		= 0;
  QmatNMR.numbvars 		= 0;
  QmatNMR.ofig			= [];
  QmatNMR.over 			= 100;
  QmatNMR.PaperMap 		= 0;
  QmatNMR.PaperMap2		= 0;
  QmatNMR.PaperOrientation 	= 1;	%portrait
  QmatNMR.PaperSize 		= 8;	%A4
  QmatNMR.PeakList		= [];
  QmatNMR.PeakListNums		= [];
  QmatNMR.PeakListText		= [];
  QmatNMR.PeakPickSearchDir 	= 1;		%default search type is only positive peaks for peak picking
  QmatNMR.PhaseFactor 		= 0;
  QmatNMR.PhaseMenu 		= 0;
  QmatNMR.phasing 		= 1;
  QmatNMR.PlotCommand		= 'plot(QmatNMR.Axis1DPlot, real(QmatNMR.Spec1DPlot), [QmatNMR.LineColor QmatNMR.LineType QmatNMR.MarkerType]);';
  QmatNMR.PlotString 		= '';
  QmatNMR.PlotType 		= 1;
  QmatNMR.PolarPlotAxis 		= 1;
  QmatNMR.PolarPlotContourLevels	= '0:0.1:1';
  QmatNMR.PolarPlotPlotType 	= 1;
  QmatNMR.PopupStr		= str2mat('Colormap', 'INVERT', 'ADJUST P/N', 'RESET P/N', 'jet', 'hsv', 'PosNeg', 'PosNeg2', 'PosNeg3', 'PaperMap', 'PaperMap2', 'PowerMap', 'White', 'Black', 'hot', 'pink', 'bone');
  QmatNMR.PopupStr2		= str2mat('Colormap', '', '', '', 'jet', 'hsv', 'QmatNMR.PosNeg', 'QmatNMR.PosNeg2', 'QmatNMR.PosNeg3', 'QmatNMR.PaperMap', 'QmatNMR.PaperMap2', 'QmatNMR.PowerMap', 'QmatNMR.White', 'QmatNMR.Black', 'hot', 'pink', 'bone');
  QmatNMR.PosNeg			= 0;		%Colormaps for spectra with negative peaks
  QmatNMR.PosNegMap		= 0;
  QmatNMR.ProjectionType 		= 1;
  QmatNMR.ProjectionRangeTD2 	= '';
  QmatNMR.ProjectionRangeTD1 	= '';
  QmatNMR.Q1DBarColour 		= 1;
  QmatNMR.Q1DBarColourDual 	= 1;
  QmatNMR.Q1DBarEdges 		= 0;
  QmatNMR.Q1DBarWidth 		= 0.8;
  QmatNMR.Q1DBarWidthDual		= 0.8;
  QmatNMR.Q1DErrorBars 		= 0;
  QmatNMR.Q1DErrorBars2 		= 0;
  QmatNMR.Q1DErrorBarsDual 	= 0;
  QmatNMR.Q1DMenu 		= 0;
  QmatNMR.Q2D3DMacro 		= '';
  QmatNMR.Q2D3DPlottingSeries 	= 0;
  QmatNMR.Q2D3DPlotType 		= 0;
  QmatNMR.Q2D3DWindowNumbering 	= 0;
  QmatNMR.Q2DButtonPanel 		= 0;
  QmatNMR.Q2DMenu 		= 0;
  QmatNMR.Q3DIndex 		= 1;
  QmatNMR.Q3DInput 		= 'NONE';
  QmatNMR.Q3DInput2 		= 'NONE';
  QmatNMR.Q3DLastType		= 0;
  QmatNMR.Q3DMacro 		= '';
  QmatNMR.Q3DNewIndex 		= 1;
  QmatNMR.Q3DOutput 		= '';
  QmatNMR.Q3DSizeOut1  		= 1;
  QmatNMR.Q3DSizeOut2 		= 1;
  QmatNMR.Q3DSizeOut3 		= 1;
  QmatNMR.Rasterbut3		= 0;
  QmatNMR.rasterdisplay		= 'real';
  QmatNMR.rasterdisplaystring	= 'real';
  QmatNMR.RasterSamplingFactor 	= 16;
  QmatNMR.ReadHypercomplex 	= 1;
  QmatNMR.ReadImaginaryFlag 	= 1;
  QmatNMR.ReadParameterFilesFlag	= 1;
  QmatNMR.RecordingMacro		= 0;
  QmatNMR.RecordingPlottingMacro 	= 0;
  QmatNMR.RegridAlgorithm 	= 1;
  QmatNMR.RegridAxisTD2 		= '';
  QmatNMR.RegridAxisTD1 		= '';
  QmatNMR.resolution		= 1;
  QmatNMR.RestoreUserDefaultValues 	= '';
  QmatNMR.ReturnZoomFlag 		= 0;
  QmatNMR.ReuseLastDirectory 	= 0;
  QmatNMR.rijnr 			= 1;
  QmatNMR.Rincr 			= 1;
  QmatNMR.Rincr1 			= 1;
  QmatNMR.Rincr2 			= 1;
  QmatNMR.Rnull 			= 0;
  QmatNMR.Rnull1 			= 0;
  QmatNMR.Rnull2 			= 0;
  QmatNMR.RulerXAxis 		= 0;
  QmatNMR.RulerXAxis1 		= 0;
  QmatNMR.RulerXAxis2 		= 0;
  QmatNMR.SaveAxis 		= 1;
  QmatNMR.SaveAxisName 		= '';
  QmatNMR.SaveHistory  		= 1;
  QmatNMR.SaveHypercomplex	= 0;
  QmatNMR.SaveImaginary		= 1;
  QmatNMR.SDPeakListIndices 	= [];
  QmatNMR.SelectedArea 		= [1 1024];
  QmatNMR.SelectedAreaHistoryCode= [1 1024];
  QmatNMR.SelectedAxes 		= [];
  QmatNMR.SF1D 			= 100;
  QmatNMR.SFTD1 			= 100;
  QmatNMR.SFTD2 			= 100;
  QmatNMR.ShearingDirection 	= 1;
  QmatNMR.ShearingFactor		= 0;
  QmatNMR.ShiftDirection		= 0;
  QmatNMR.ShiftSpectrum 		= 0;
  QmatNMR.ShowLogo		= 1;
  QmatNMR.sidebandColour 		= 1;
  QmatNMR.sidebandLineStyle 	= 1;
  QmatNMR.sidebandLinewidth 	= 1;
  QmatNMR.sidebandMarker 		= 1;
  QmatNMR.sidebandMarkerSize 	= 1;
  QmatNMR.SimpsonASCIIName 	= 'simpson';
  QmatNMR.SingleSlice 		= 0;
  QmatNMR.Size1D 			= 1024;
  QmatNMR.size1last		= 1;
  QmatNMR.size2last		= 1;
  QmatNMR.Size3D 			= 1;
  QmatNMR.SizeTD1 		= 1;
  QmatNMR.SizeTD2 		= 1;
  QmatNMR.SkyLineAngle 		= 0;
  QmatNMR.SolventSuppressionExtrapolate = 16;
  QmatNMR.SolventSuppressionWidth = 8;
  QmatNMR.SolventSuppressionWindow = 1;
  QmatNMR.Spec1D 			= exp(-sqrt(-1)*(0:1023) - 0.015*(0:1023));
  QmatNMR.Spec1DBackup 		= 0;
  QmatNMR.Spec1DName		= '';
  QmatNMR.Spec1DPlot  		= exp(-sqrt(-1)*(0:1023) - 0.015*(0:1023));
  QmatNMR.Spec2D 			= 0;
  QmatNMR.Spec2D3D 		= '';
  QmatNMR.Spec2D3DPlot 		= 0;
  QmatNMR.Spec2Dhc		= 0;
  QmatNMR.Spec2DName 		= '';
  QmatNMR.Spec3DName 		= '';
  QmatNMR.SpecName2D3D 		= '';
  QmatNMR.SpecName2D3DProc 	= '';
  QmatNMR.SpecNameProc		= '';
  QmatNMR.spinningspeed 		= 10;
  QmatNMR.Stack3DDimension 	= 1;
  QmatNMR.stack3Dfig		= [];
  QmatNMR.stackaz			= -70;
  QmatNMR.stackdisplay		= 'real';
  QmatNMR.stackdisplaystring	= 'real';
  QmatNMR.stackel			= 15;
  QmatNMR.statfig			= [];
  QmatNMR.statfig2d		= [];
  QmatNMR.statuspar 		= 1;
  QmatNMR.statuspar2d 		= 1;
  QmatNMR.StepWiseExecutingMacro = AddToMacro;
  QmatNMR.StepWiseNRSteps		= 0;
  QmatNMR.StepWiseNumbering 	= 0;
  QmatNMR.StepWiseProcessNumber 	= 1;
  QmatNMR.StepWiseTempNumber 	= 0;
  QmatNMR.StepWiseText 		= '';
  QmatNMR.surfltext		= '';
  QmatNMR.SW1D			= 50;		%Standard sweepwidth
  QmatNMR.SwapEcho 		= 0;
  QmatNMR.SwitchTo1D		= 0;		%flag to swicth from the 2D to the 1D processing mode
  QmatNMR.SWTD1			= 50;		%Standard sweepwidth
  QmatNMR.SWTD2			= 50;		%Standard sweepwidth
  QmatNMR.T1FitArray 		= 0;
  QmatNMR.T1FitResults 		= 0;
  QmatNMR.TempAxis1Cont 		= [];
  QmatNMR.TempAxis2Cont 		= [];
  QmatNMR.TempAxis3Cont 		= [];
  QmatNMR.TEMPCommandString 	= '';
  QmatNMR.TempHandle 		= [];
  QmatNMR.texie			= 'Points';
  QmatNMR.texie1			= 'Points';
  QmatNMR.texie2			= 'Points';
  QmatNMR.Tfig			= [];
  QmatNMR.TimeAxisDwell 		= 1;
  QmatNMR.TimeAxisDwellTD1 	= 1;
  QmatNMR.TimeAxisDwellTD2 	= 1;
  QmatNMR.TimeAxisStart 		= 0;
  QmatNMR.TimeAxisStartTD1 	= 0;
  QmatNMR.TimeAxisStartTD2 	= 0;
  QmatNMR.Timing 			= 0;
  QmatNMR.TitleEdit		= 0;
  QmatNMR.totaalX 		= 1024;
  QmatNMR.totaalY 		= 1024;
  QmatNMR.Ttitlefig 		= [];
  QmatNMR.UIFontSize 		= 12;
  QmatNMR.uiInput1 		= 0;	%for QuiInput.m
  QmatNMR.uiInput10		= 0;
  QmatNMR.uiInput10a		= 0;
  QmatNMR.uiInput11		= 0;
  QmatNMR.uiInput11a		= 0;
  QmatNMR.uiInput12		= 0;
  QmatNMR.uiInput12a		= 0;
  QmatNMR.uiInput13		= 0;
  QmatNMR.uiInput13a		= 0;
  QmatNMR.uiInput14		= 0;
  QmatNMR.uiInput14a		= 0;
  QmatNMR.uiInput15		= 0;
  QmatNMR.uiInput15a		= 0;
  QmatNMR.uiInput1a		= 0;	%for QuiInput.m
  QmatNMR.uiInput2 		= 0;
  QmatNMR.uiInput2a		= 0;
  QmatNMR.uiInput3 		= 0;
  QmatNMR.uiInput3a		= 0;
  QmatNMR.uiInput4		= 0;
  QmatNMR.uiInput4a		= 0;
  QmatNMR.uiInput5		= 0;
  QmatNMR.uiInput5a		= 0;
  QmatNMR.uiInput6		= 0;
  QmatNMR.uiInput6a		= 0;
  QmatNMR.uiInput7		= 0;
  QmatNMR.uiInput7a		= 0;
  QmatNMR.uiInput8		= 0;
  QmatNMR.uiInput8a		= 0;
  QmatNMR.uiInput9		= 0;
  QmatNMR.uiInput9a		= 0;
  QmatNMR.uiInputFig 		= [];
  QmatNMR.under 			= 1;
  QmatNMR.UnDo1D 			= 1;
  QmatNMR.UnDo2D 			= 1;
  QmatNMR.UnDoMatrix1D 		= GenerateMatNMRStructure(1);
  QmatNMR.UnDoMatrix2D		= GenerateMatNMRStructure(1);
  QmatNMR.unittype 		= 0; %units 	= pixel
  QmatNMR.UserCommandString 	= '';
  QmatNMR.UserDefAxis		= '';
  QmatNMR.UserDefAxisT1		= '';
  QmatNMR.UserDefAxisT1Cont	= '';
  QmatNMR.UserDefAxisT1ContSeries= '';
  QmatNMR.UserDefAxisT1Main 	= '';
  QmatNMR.UserDefAxisT2		= '';
  QmatNMR.UserDefAxisT2Cont	= '';
  QmatNMR.UserDefAxisT2ContSeries= '';
  QmatNMR.UserDefAxisT2Main 	= '';
  QmatNMR.UserDefNrPlotsX   	= 0;
  QmatNMR.UserDefNrPlotsY   	= 0;
  QmatNMR.UserDefOffsetX    	= 0;
  QmatNMR.UserDefOffsetY    	= 0;
  QmatNMR.UserDefRef 		= '';
  QmatNMR.UserDefSpaceX     	= 0;
  QmatNMR.UserDefSpaceY     	= 0;
  QmatNMR.UserDefWidthAxisX 	= 0;
  QmatNMR.UserDefWidthAxisY 	= 0;
  QmatNMR.VariableNameCSAFit 	= 'QCSAFitResults';
  QmatNMR.VariableNameDiffFit	= 'QDiffFitResults';
  QmatNMR.VariableNamePeakFit 	= 'QFitResults';
  QmatNMR.VariableNameQuadFit 	= 'QQuadFitResults';
  QmatNMR.VariableNameSSAFit 	= 'QSSAFitResults';
  QmatNMR.VariableNameT1Fit 	= 'QT1FitResults';
  QmatNMR.VersionVar		= ['matNMR, UNKNOWN version (please check matNMRVersion file!)'];
  QmatNMR.VerticalStackDisplacement = 1;
  QmatNMR.VerticalStackRange  	= 1;
  QmatNMR.ViewNameCSAFit      	= 'QCSAFitResults';
  QmatNMR.ViewNameDiffFit     	= 'QDiffFitResults';
  QmatNMR.ViewNamePeakFit     	= 'QFitResults';
  QmatNMR.ViewNameQuadFit     	= 'QQuadFitResults';
  QmatNMR.ViewNameSSAFit		= 'QSSAFitResults';
  QmatNMR.ViewNameT1Fit       	= 'QT1FitResults';
  QmatNMR.WarningSettings 	= '';
  QmatNMR.White			= 0;
  QmatNMR.Xfilename 		= 0;
  QmatNMR.XlabelEdit		= 0;
  QmatNMR.xmin 			= 0;
  QmatNMR.Xpath 			= '.';
  QmatNMR.xschaal 		= 1;
  QmatNMR.Xsize 			= '';
  QmatNMR.Xtext 			= '';
  QmatNMR.YlabelEdit		= 0;
  QmatNMR.ymin 			= 0;
  QmatNMR.yrelative 		= 0;
  QmatNMR.yschaal 		= 0;
  QmatNMR.ZAxisIndicator 		= 0;
  QmatNMR.ZlabelEdit		= 0;
  
  
  %
  %A few platform dependent things
  %
  if (QmatNMR.Platform == QmatNMR.PlatformPC)
    QmatNMR.UIFontSize 		= 7;
    QmatNMRsettings.DefaultUIFontSize	= 7;
  end
  
  if (QmatNMR.Platform == QmatNMR.PlatformMAC)
    QmatNMR.UIFontSize 		= 7;
    QmatNMRsettings.DefaultUIFontSize	= 12;
  end
  
  QmatNMR.SearchProfile	= '*.*';	%what files to look for when searching binary fid's
  
  %
  %The standard list of fonts that matNMR recognizes ...
  %
  QmatNMRsettings.DefaultFontList = str2mat('avantgarde', 'bookman', 'courier', 'helvetica', 'bembo', 'rockwell', 'new Century Schoolbook', 'palatino', 'symbol', 'times', 'zapfchancery', 'zapfdingbats');
  QmatNMR.FontList = QmatNMRsettings.DefaultFontList;
  
  
  
  %
  % Some refinements for the eye ... (default MATLAB v. 5 settings will be changed)
  %
  settings
  
  
  			%Load standard options as saved by the user
  QmatNMR.matnmrpath = which('matnmroptions.mat');
  if isempty(QmatNMR.matnmrpath)
    disp('matNMR ERROR: cannot find options file. Please reinstall matNMR!')
  
  else
    try
      CheckConversionOptionsFile
      load(QmatNMR.matnmrpath, 'QmatNMRsettings');

    catch
      disp(['matNMR ERROR: cannot read options file "' QmatNMR.matnmrpath '"']);
      disp('matNMR ERROR: Possibly the options file was saved with a newer Matlab version.');
      disp(['matNMR ERROR: Please copy the options file from the matNMR directory to "' QmatNMR.matnmrpath '"']);
      disp('matNMR ERROR: and setup matNMR again with this version of Matlab.');
      disp('Trying to revert to the options file supplied with the matNMR code ...');
      QmatNMR.matnmrpath = which('nmr.m');
      QmatNMR.matnmrpath = [QmatNMR.matnmrpath(1:end-5) 'matnmroptions.mat'];
      
      try
        CheckConversionOptionsFile
        load(QmatNMR.matnmrpath, 'QmatNMRsettings');
  
      catch
        disp(' ');
        disp('matNMR ERROR: cannot read the options file supplied with matNMR. Please reinstall matNMR!')
      end
    end
  end
  
  
  QmatNMR.HelpPath = which('nmr.m');
  QmatNMR.HelpPath = [QmatNMR.HelpPath(1:(length(QmatNMR.HelpPath)-5)) 'docs'];
  path(path, QmatNMR.HelpPath);
  
  
  %
  %read the current version number from the matNMRVersion file
  %
  QTEMP = which('matNMRVersion.');
  QTEMP1 = fopen(QTEMP, 'r');
  QmatNMR.VersionVar = fscanf(QTEMP1, '%s');
  fclose(QTEMP1);
  QmatNMR.VersionVar		= ['matNMR v. ' QmatNMR.VersionVar ' (last updated on ' QmatNMR.matNMRdate.date(1:11) ')'];
  
  
  %
  %now we check whether the options file contains the colour scheme variable. If not, then we open a display
  %window to state the the new scheme has been selected and saved in the options file. If the user wants to
  %change the colour scheme then he/she needs to go to the appropriate options menu
  %
  checkforcolourscheme
  
  
  %
  %set default parameters
  %
  setdefaults
  
  						%load colormaps as they are not already present ...
  QTEMP1 = load('ColorMaps.mat');					%Contains special colormaps
  %
  %copy the matNMR colormaps into the QmatNMR variable
  %
  QmatNMR.PosNegMap  = QTEMP1.QPosNegMap;
  QmatNMR.PosNegMap2 = QTEMP1.QPosNegMap2;
  QmatNMR.PosNegMap3 = QTEMP1.QPosNegMap3;
  QmatNMR.PaperMap   = QTEMP1.QPaperMap;
  QmatNMR.PaperMap2  = QTEMP1.QPaperMap2;
  QmatNMR.PowerMap   = QTEMP1.QPowerMap;
  QmatNMR.White      = QTEMP1.QWhite;
  QmatNMR.Black      = QTEMP1.QBlack;
  
  %
  %Now set the PosNeg colormaps to default
  %
  QmatNMR.PosNeg  = QTEMP1.QPosNegMap;
  QmatNMR.PosNeg2 = QTEMP1.QPosNegMap2;
  QmatNMR.PosNeg3 = QTEMP1.QPosNegMap3;
  %the next variable is used to store the name of the last-used PosNeg colourmap
  if (QmatNMRsettings.DefaultColormap == 7)
    QmatNMR.PosNegMapLast = 'QmatNMR.PosNeg';
  elseif (QmatNMRsettings.DefaultColormap == 8)
    QmatNMR.PosNegMapLast = 'QmatNMR.PosNeg2';
  elseif (QmatNMRsettings.DefaultColormap == 9)
    QmatNMR.PosNegMapLast = 'QmatNMR.PosNeg3';
  else
    QmatNMR.PosNegMapLast = 'QmatNMR.PosNeg';
  end
  
  
  %
  %order the fields names in QmatNMR for easy user access
  %
  QmatNMR = orderfields(QmatNMR);
  
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
