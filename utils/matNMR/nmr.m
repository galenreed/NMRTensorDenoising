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
% matNMR - processing toolbox for spectra and FID's
% 
%nmr.m is the script in which the matNMR window and all its global variables
%are defined once.
%
%be careful with the next variables !!
%   QmatNMR.SizeTD2 = TD2 en QmatNMR.SizeTD1 = TD1 !
%   QmatNMR.SWTD2 = TD2 en QmatNMR.SFTD2 = TD1
%   QmatNMR.AxisTD2 = TD2 !
%
%9-8-'96
%
%
%
%


			%check for the matNMR main window and go there if possible, else initialize.
global QmatNMR QmatNMRsettings

QmatNMR.Ph = findobj(allchild(0), 'tag', 'matNMRmainwindow');
if ~isempty(QmatNMR.Ph)
  figure(QmatNMR.Ph);
  drawnow;
  PutScreenRight;

else
  %
  %to reduce Matlab rubbish of not being able to find new functions
  %
  try
    if (~ isfield(QmatNMR, 'Fig'))			%Check whether matNMR is operating. If not, initialize the necessary variables
			%Start initilization
      disp('Please wait while matNMR is initializing ...');

      CheckForSpecificFile 		%to ensure that all of matNMRs files are in the current path cache

      matNMRinitvars

    
      %
      %  Show the matNMR window
      %
      if ((QmatNMR.ShowLogo) & isempty(QmatNMR.Fig2D3D))
        QmatNMR.LogoDeleteNecessary = 1;
        matNMRintro
      else  
        QmatNMR.LogoDeleteNecessary = 0;
      end
  
    else
    	%
        %the main window isn't open but the 2D/3D viewer is. Now we must take care to take the
    	%initial window size of the main window in pixels. This is usually done during the
  	%initialization of the variables in matNMRinitvars. Since that is not executed
  	%now we do it manually.
  	%
      QmatNMR.figLeft	= QmatNMRsettings.figDefaultLeft;
      QmatNMR.figBottom	= QmatNMRsettings.figDefaultBottom;
      QmatNMR.figWidth	= QmatNMRsettings.figDefaultWidth;
      QmatNMR.figHeight	= QmatNMRsettings.figDefaultHeight;
    end
  
    %for the paper size ...
    QTEMP9 = str2mat('usletter', 'uslegal', 'tabloid', 'A0', 'A1', 'A2', 'A3', 'A4', 'A5', 'B0', 'B1', 'B2', 'B3', 'B4', 'B5', ...
                   'arch-A', 'arch-B', 'arch-C', 'arch-D', 'arch-E', 'A', 'B', 'C', 'D', 'E');
  
    %for the userdata
    QTEMP = [];
    QTEMP.SubPlots = 1;

    %create the main figure window
    QmatNMR.Fig = figure('Pointer', 'Arrow', ...
                         'units', 'Pixels', ...
                         'Position', [QmatNMR.figLeft QmatNMR.figBottom QmatNMR.figWidth QmatNMR.figHeight], ...
                         'Name', ['   ' QmatNMR.VersionVar '   ---   processing toolbox for 1D and 2D NMR/EPR spectra   ---   written by Jacco van Beek'], ...
                         'Numbertitle', 'off', ...
                         'Resize', 'off', ...
                         'backingstore', 'on', ...
                         'paperorientation', 'landscape', ...
                         'papertype', deblank(QTEMP9(QmatNMR.PaperSize, :)), ...
                         'paperunits', 'normalized', ...
                         'paperposition', [0.1 0.1 0.8 0.8], ...
                         'userdata', QTEMP, ...
                         'menubar', 'none', ...
                         'visible', 'off', ...
                         'tag', 'matNMRmainwindow', ...
                         'color', QmatNMR.ColorScheme.Figure1Back, ...
                         'closerequestfcn', 'askstopnmr');
    set(QmatNMR.Fig, 'paperunits', 'centimeters')
  
  
    %
    %To work around a Matlab bug (see BugFixes.txt, 11-05-'04) we redefine the position and units.
    %
    set(QmatNMR.Fig, 'units', 'pixels', 'position', [QmatNMR.figLeft QmatNMR.figBottom QmatNMR.figWidth QmatNMR.figHeight]);
  
    clf;
  
    %create the axis in the main figure window
    CreateMainAxes
  
    %create the UI controls in the main figure window
    matNMR1DButtons
    
    %give a message in the axis
    StartupMessage
  
    drawnow
    set(QmatNMR.Fig, 'visible', 'on');
  
    %show the logo if asked for in the general options menu
    if ((QmatNMR.ShowLogo) & (QmatNMR.LogoDeleteNecessary))
      delete(QmatNMR.Intro);
      QmatNMR.Intro = 0;
      QmatNMR.LogoDeleteNecessary = 0;
    end
  
  catch
    %
    %some files could not be found during the startup of matNMR. This typically means the caches need to
    %be rehashed and so we do that and try to start matNMR again
    %
    if (~exist('QTEMP50') | isempty(QTEMP50))
      global QTEMP50
      QTEMP50 = '';
    end

    if ~strcmp(QTEMP50, lasterr)
      disp('matNMR WARNING: matNMR failed to initialize. Attempting to update the path caches and start again ...');
      disp(['              ERROR message: ' lasterr])
    
      QTEMP50 = lasterr;
      rehash toolboxreset
      rehash toolboxcache
      rehash path
      which nmr
      nmr

    else
      disp('matNMR WARNING: matNMR failed to initialize. Please send a bug report showing the following error message:');
      disp(lasterr)
      disp(' ');
      clear QTEMP50
    end
  end
end

clear QTEMP*
