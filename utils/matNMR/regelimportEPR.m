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
% regelimportEPR
%
% interface to the eprload routine from easyspin (by Stefan Stoll)
% 27-01-'10

try
  if (QmatNMR.buttonList == 1)				%OK-button
    watch;
    disp('Please wait while matNMR is reading the EPR data file ...');

    QmatNMR.namelast = QmatNMR.uiInput1;		%the variable name
    QmatNMR.LoadINTOmatNMRDirectly = QmatNMR.uiInput2; 	%load into matNMR directly?

    %
    %create the data variable
    %
    eval([QmatNMR.namelast ' = GenerateMatNMRStructure;']);
    eval([QmatNMR.namelast '.Spectrum = QmatNMR.EPRData;']);
    eval([QmatNMR.namelast '.EPRparameters = QmatNMR.EPRPars;']);
    
    if ~iscell(QmatNMR.EPRAxis)
      %1D data
      eval([QmatNMR.namelast '.AxisTD2 = QmatNMR.EPRAxis(:).'';']);

    elseif (length(QmatNMR.EPRAxis) == 2)
      %2D data
      eval([QmatNMR.namelast '.AxisTD1 = QmatNMR.EPRAxis{1}(:).'';']);
      eval([QmatNMR.namelast '.AxisTD2 = QmatNMR.EPRAxis{2}(:).'';']);

    elseif (length(QmatNMR.EPRAxis) == 3)
      %3D data
      eval([QmatNMR.namelast '.AxisTD1 = QmatNMR.EPRAxis{2}(:).'';']);
      eval([QmatNMR.namelast '.AxisTD2 = QmatNMR.EPRAxis{3}(:).'';']);
      eval([QmatNMR.namelast '.AxisTD3 = QmatNMR.EPRAxis{1}(:).'';']);

    else
      beep
      disp('matNMR WARNING: EPR data appear to be more than 3-dimensional. Aborting ...');
      return
    end


    %
    %display status output
    %
    [QmatNMR.T2, QmatNMR.T1] = size(QmatNMR.EPRData);
    disp(['Finished importing EPR data. (', num2str(QmatNMR.T2), ' x ', num2str(QmatNMR.T1), ' points).']);
    disp(['The FID was saved in workspace as: ' QmatNMR.uiInput1]);
    Arrowhead;


    %
    %finish by either loading the spectrum into matNMR or by only adding the name of the list
    %
    if (QmatNMR.LoadINTOmatNMRDirectly)
      %
      %load the new FID into matNMR
      %
      disp(['Loading the FID into matNMR ...']);

      if (QmatNMR.T1 == 1)
        QmatNMR.uiInput2 = '';

        %
        %automatically load this variable as an FID into matNMR
        %
        QmatNMR.ask = 1;
        QmatNMR.buttonList = 1;
        regelnaam

      else
        QmatNMR.uiInput2 = '';
        QmatNMR.uiInput3 = '';

        %
        %automatically load this variable as an FID into matNMR
        %
        QmatNMR.ask = 2;
        QmatNMR.buttonList = 1;
        regelnaam
      end

    else
      %
      %Only store the variable in the workspace
      %
      QmatNMR.newinlist.Spectrum = QmatNMR.uiInput1;
      if (QmatNMR.T1 == 1)
        QmatNMR.newinlist.Axis = '';
        putinlist1d;

      else
        QmatNMR.newinlist.AxisTD2 = '';
        QmatNMR.newinlist.AxisTD1 = '';
        putinlist2d;
      end
    end
  else

    disp('Importing of EPR data cancelled ...');
  end

  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
