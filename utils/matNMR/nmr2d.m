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
%nmr2d.m is the 2D display/plotting routine from matNMR. It can be used separate !!
%03-01-'00

%
%to reduce Matlab rubbish of not being able to find new functions
%
global QmatNMR QmatNMRsettings
try
  if (~ isfield(QmatNMR, 'Fig'))			%Check whether nmr.m is operating. If not, initialize the necessary variables
    %Start initilization
    disp('Please wait while matNMR is initializing ...');

    matNMRinitvars;
  end

  QmatNMR.command2 = 0;
  QmatNMR.command3 = 0;
  
  if ~isempty(QmatNMR.Fig2D3D)
    figure(QmatNMR.Q2DButtonPanel);
    figure(QmatNMR.Fig2D3D)			%It already exists so just pull to the front again ...
  else  
    %
    %  Show the matNMR window
    %
      if ((QmatNMR.ShowLogo) & (QmatNMR.Fig == 0))
        QmatNMR.LogoDeleteNecessary = 1;
        matNMRintro
      else  
        QmatNMR.LogoDeleteNecessary = 0;
      end
  
    QmatNMR.titelstring1 = '';			%standard parameters ... rather trivial
    QmatNMR.titelstring2 = '2D/3D Viewer';
  
    matNMR2DPanelButtons
    matNMR2DButtons			%create the figure window and all uitools inside it.
    set(QmatNMR.Q2DButtonPanel, 'handlevisibility', 'off');
    QmatNMR.ContSubplots = 1; 
    Subplots(QmatNMR.Fig2D3D, 1) 
     
    if ((QmatNMR.ShowLogo) & (QmatNMR.LogoDeleteNecessary))
      delete(QmatNMR.Intro);
      QmatNMR.Intro = 0;
      QmatNMR.LogoDeleteNecessary = 0;
    end
  
    disp('2D/3D Viewer succesfully initiated ...');
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
    nmr2d

  else
    disp('matNMR WARNING: matNMR failed to initialize. Please send a bug report showing the following error message:');
    disp(lasterr)
    disp(' ');
    clear QTEMP50
  end
end

clear QTEMP*
