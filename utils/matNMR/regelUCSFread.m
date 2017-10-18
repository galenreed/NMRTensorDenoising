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
%regelUCSFread.m reads a binary Sparky UCSF file from disk.
%28-01-'09

try
  if (QmatNMR.buttonList == 1)				%OK-button
    watch;
    disp('Please wait while matNMR is reading the spectrum ...');

    QmatNMR.Fname = QmatNMR.uiInput1;
    QmatNMR.namelast = QmatNMR.uiInput2;
    QmatNMR.LoadINTOmatNMRDirectly = QmatNMR.uiInput3; 	%load into matNMR directly?


  %
  %Detect whether a series of files must be loaded
  %
    if (isempty(findstr(QmatNMR.Fname, '$')))
      %
      %load single file
      %

      %
      %read the spectrum into the workspace
      %
      eval(['[' QmatNMR.namelast ', QTEMP] = readUCSF(QmatNMR.Fname);']);


      %
      %display status output
      %
      if (length(QTEMP) == 1)
        disp(['Finished loading Sparky UCSF data ', QmatNMR.Fname, '. (', num2str(QTEMP(1)) ' points).']);
      elseif (length(QTEMP) == 2)
        disp(['Finished loading Sparky UCSF data ', QmatNMR.Fname, '. (', num2str(QTEMP(1)), ' x ', num2str(QTEMP(2)), ' points).']);
      elseif (length(QTEMP) == 3)
        disp(['Finished loading Sparky UCSF data ', QmatNMR.Fname, '. (', num2str(QTEMP(1)), ' x ', num2str(QTEMP(2)), ' x ', num2str(QTEMP(3)), ' points).']);
      end
      disp(['The spectrum was saved in workspace as: ' QmatNMR.namelast]);
      Arrowhead;

      %
      %finish by either loading the spectrum into matNMR or by only adding the name of the list
      %
      if (QmatNMR.LoadINTOmatNMRDirectly)
        %
        %load the new FID into matNMR
        %
        disp(['Loading the FID into matNMR ...']);

        QmatNMR.uiInput1 = QmatNMR.namelast;
        if (length(QTEMP) == 1)
          QmatNMR.uiInput2 = '';

          %
          %automatically load this variable as a spectrum into matNMR
          %
          QmatNMR.ask = 1;
          QmatNMR.buttonList = 2;
          regelnaam

        else
          QmatNMR.uiInput2 = '';
          QmatNMR.uiInput3 = '';

          %
          %automatically load this variable as a spectrum into matNMR
          %
          QmatNMR.ask = 2;
          QmatNMR.buttonList = 2;
          regelnaam
        end

      else
        %
        %Only store the variable in the workspace
        %
        QmatNMR.newinlist.Spectrum = QmatNMR.namelast;
        if (length(QTEMP) == 1)
          QmatNMR.newinlist.Axis = '';
          putinlist1d;

        else
          QmatNMR.newinlist.AxisTD2 = '';
          QmatNMR.newinlist.AxisTD1 = '';
          putinlist2d;
        end
      end

    else
      %
      %load series of files
      %

      %
      %Extract and check the ranges first
      %
      QTEMP2 = findstr(QmatNMR.Fname, '$');
      QTEMP61 = QmatNMR.Fname( (QTEMP2(1)):(QTEMP2(2)) );

      if (length(QTEMP2) ~= 2)
        beep
        disp('matNMR WARNING: incorrect syntax for loading series of binary data files. Aborting ...');
        return
      end

      try
        QmatNMR.SeriesRangeIn = eval(QmatNMR.Fname( (QTEMP2(1)+1):(QTEMP2(2)-1) ));
      end

      try
        QTEMP2 = findstr(QmatNMR.namelast, '$');
        QTEMP62 = QmatNMR.namelast( (QTEMP2(1)):(QTEMP2(2)) );

        if (length(QTEMP2) == 2)
          QmatNMR.SeriesRangeOut = eval(QmatNMR.namelast( (QTEMP2(1)+1):(QTEMP2(2)-1) ));
        end
      end


      %
      %Now that all input parameters have been read we need to check whether the range for
      %the variable names is equal or longer than for the file names
      %
      if (length(QmatNMR.SeriesRangeIn) > length(QmatNMR.SeriesRangeOut))
        error('matNMR ERROR: range for variable names is too short!');
      end

      %
      %Now we perform a loop over the range of the file names and execute the lot
      %
      for QTEMP3 = 1:length(QmatNMR.SeriesRangeIn)
        %
        %create the file name for the current element of the series
        %
        QmatNMR.SeriesName = strrep(QmatNMR.Fname, QTEMP61, num2str(QmatNMR.SeriesRangeIn(QTEMP3), 10));

        %
        %separate the path and file names
        %
        QTEMP = findstr(QmatNMR.SeriesName, filesep);		%extract the filename and path depending on the platform

        %
        %the path and file name
        %
        QmatNMR.Xpath = deblank(QmatNMR.SeriesName(1:QTEMP(length(QTEMP))));
        QmatNMR.Xfilename = deblank(QmatNMR.SeriesName((QTEMP(length(QTEMP))+1):length(QmatNMR.SeriesName)));
        %check whether the file really exists. If not then skip this one and go to the next
        QmatNMR.SeriesVarName = dir([QmatNMR.Xpath QmatNMR.Xfilename]);
        if isempty(QmatNMR.SeriesVarName)
          disp('');
          disp(['matNMR NOTICE: file doesn''t exist. Aborting reading of binary FID "' QmatNMR.Xpath QmatNMR.Xfilename '" ...']);
          disp('');
          beep

        else
          %
          %create the variable name for the current element of the series
          %
          QmatNMR.SeriesVarName = strrep(QmatNMR.namelast, QTEMP62, num2str(QmatNMR.SeriesRangeOut(QTEMP3), 10));


          %
          %read the file
          %
          eval([QmatNMR.SeriesVarName ' = SIMPSONread(QmatNMR.SeriesName);']);
          %
          %read the spectrum into the workspace
          %
          eval(['[' QmatNMR.SeriesVarName ', QTEMP] = readUCSF(QmatNMR.SeriesName);']);


          %
          %display status output
          %
          if (length(QTEMP) == 1)
            disp(['Finished loading Sparky UCSF data ', QmatNMR.SeriesName, '. (', num2str(QTEMP(1)) ' points).']);
          elseif (length(QTEMP) == 2)
            disp(['Finished loading Sparky UCSF data ', QmatNMR.SeriesName, '. (', num2str(QTEMP(1)), ' x ', num2str(QTEMP(2)), ' points).']);
          elseif (length(QTEMP) == 3)
            disp(['Finished loading Sparky UCSF data ', QmatNMR.SeriesName, '. (', num2str(QTEMP(1)), ' x ', num2str(QTEMP(2)), ' x ', num2str(QTEMP(3)), ' points).']);
          end
          disp(['The spectrum was saved in workspace as: ' QmatNMR.SeriesVarName]);


          %
          %Now we check whether the new variable is 1D or 2D and then put the name in the list
          %of last-read variables.
          %
          eval(['QTEMP9 = sort(size(' QmatNMR.SeriesVarName '.Spectrum));']);
          QmatNMR.newinlist.Spectrum = QmatNMR.SeriesVarName;
          if (QTEMP9(1) == 1)
            QmatNMR.newinlist.Axis = '';
            putinlist1d;

          else
            QmatNMR.newinlist.AxisTD2 = '';
            QmatNMR.newinlist.AxisTD1 = '';
            putinlist2d;
          end

          fprintf(1, 'The resulting SIMPSON FID/Spectrum was written in the workspace as %s.\n', QmatNMR.SeriesVarName);
        end
      end

      Arrowhead;


      %
      %This may be useful when wanting to operate on series afterwards;
      %
      QmatNMR.AddVariablesCommonString = QmatNMR.namelast;


      %
      %finish by loading the first dataset of the range into matNMR, if asked for
      %
      if (QmatNMR.LoadINTOmatNMRDirectly)
        disp(['Loading the first of the series FID into matNMR ...']);

        QmatNMR.uiInput1 = strrep(QmatNMR.namelast, QTEMP62, num2str(QmatNMR.SeriesRangeOut(1)));
        QmatNMR.uiInput2 = '';
        QmatNMR.uiInput3 = '';

        %
        %automatically load this variable as an FID into matNMR
        %
        QmatNMR.ask = 2;
        QmatNMR.buttonList = 1;
        regelnaam
      end
    end

  else
    disp('Reading of Bruker Spectrum cancelled ...');
  end

  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
