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
%regelimportMRI.m reads MRI data files from disk.
%27-01-'10

try
  if (QmatNMR.buttonList == 1)				%OK-button
    watch;
    disp('Please wait while matNMR is reading the MRI data file(s) ...');

    QmatNMR.Fname = QmatNMR.uiInput1;

    QTEMP9 = length(QmatNMR.uiInput2);
    if ((QmatNMR.uiInput2(QTEMP9) == 'k') | (QmatNMR.uiInput2(QTEMP9) == 'K'))
      QmatNMR.T2 = round(str2num(QmatNMR.uiInput2(1:(QTEMP9-1))) * 1024 );
    else
      QmatNMR.T2 = round(str2num(QmatNMR.uiInput2));
    end

    QTEMP9 = length(QmatNMR.uiInput3);
    if ((QmatNMR.uiInput3(QTEMP9) == 'k') | (QmatNMR.uiInput3(QTEMP9) == 'K'))
      QmatNMR.T1 = round(str2num(QmatNMR.uiInput3(1:(QTEMP9-1))) * 1024 );
    else
      QmatNMR.T1 = round(str2num(QmatNMR.uiInput3));
    end

    QmatNMR.namelast = QmatNMR.uiInput4;		%the variable name
    QmatNMR.DataFormatMRI = QmatNMR.uiInput5;		%what format to read in
    QmatNMR.ReadParameterFilesFlag = QmatNMR.uiInput6;	%do we read in the original parameter files?
    QmatNMR.LoadINTOmatNMRDirectly = QmatNMR.uiInput7; 	%load into matNMR directly?


  %
  %Detect whether a series of files must be loaded
  %
    if (isempty(findstr(QmatNMR.Fname, '$')))
      %
      %load single file
      %

      QTEMP = findstr(QmatNMR.Fname, filesep);		%extract the filename and path depending on the platform
      QTEMP9 = length(QTEMP);
      QmatNMR.Xpath = deblank(QmatNMR.uiInput1(1:QTEMP(QTEMP9)));				%the path
      QmatNMR.Xfilename = deblank(QmatNMR.uiInput1((QTEMP(QTEMP9)+1):length(QmatNMR.uiInput1)));	%the file name

      QTEMP2 = dir([QmatNMR.Xpath QmatNMR.Xfilename]);
      if isempty(QTEMP2)
        disp('');
        disp(['matNMR NOTICE: file doesn''t exist. Aborting reading of MRI data file "' QmatNMR.Xpath QmatNMR.Xfilename '" ...']);
        disp('');
        beep
        return
      end


      QTEMP1 = [];	%this will contain the parameters if the user has asked for them to be read
      switch QmatNMR.DataFormatMRI		%define the output slightly different for each data format
      				%and if needed read in the parameter files
        case 1
          QTEMP2 = 'SMIS';


        case 2
          QTEMP2 = 'Siemens RDA';


        case 3
          QTEMP2 = 'Siemens RAW';


        case 4
          QTEMP2 = 'DICOM';


        otherwise
          QTEMP2 = 'unknown file format';
      end


      %
      %based on user input, or the parameter files, define these variables for askfidlaad
      %
      QmatNMR.size1last = QmatNMR.T2;
      QmatNMR.size2last = QmatNMR.T1;


      %
      %first make the variable global and then read in the FID
      %
      eval(['global ' QmatNMR.namelast]);
      if isempty(QTEMP1)		%the user has not asked for the parameter files to be read in, hence the output
      				%variable is not a structure, unless created by QimportMRI
        eval(['[' QmatNMR.namelast ', QmatNMR.T2, QmatNMR.T1] = QimportMRI(QmatNMR.Fname, QmatNMR.T2, QmatNMR.T1, QmatNMR.DataFormatMRI, QmatNMR.ByteOrder);']);

      else				%parameter files have been read and seem to be in order
        eval(['[QTEMP1, QmatNMR.T2, QmatNMR.T1] = QimportMRI(QmatNMR.Fname, QmatNMR.T2, QmatNMR.T1, QmatNMR.DataFormatMRI, QmatNMR.ByteOrder);']);
        if isstruct(QTEMP1)
          eval([QmatNMR.namelast ' = QTEMP1;']);

        else
          eval([QmatNMR.namelast '.Spectrum = QTEMP1;']);
        end

        eval([QmatNMR.namelast '.DataPath = QmatNMR.Xpath;']);
        eval([QmatNMR.namelast '.DataFile = QmatNMR.Xfilename;']);
      end


      %
      %display status output
      %
      disp(['Finished loading ' QTEMP2 ' MRI data "', QmatNMR.Fname, '". (', num2str(QmatNMR.T2/2), ' x ', num2str(QmatNMR.T1), ' points).']);
      disp(['The data was saved in workspace as: ' QmatNMR.uiInput4]);
      Arrowhead;

      %
      %finish by either loading the spectrum into matNMR or by only adding the name of the list
      %
      if (QmatNMR.LoadINTOmatNMRDirectly)
        %
        %load the new FID into matNMR
        %
        disp(['Loading the FID into matNMR ...']);

        QmatNMR.uiInput1 = QmatNMR.uiInput4;
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
        QmatNMR.newinlist.Spectrum = QmatNMR.uiInput4;
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
          %this reads in the parameter files for each entry in the series.
          %
          QmatNMR.SeriesFlag1 = [];	%this will contain the parameters if the user has asked for them to be read
          QmatNMR.SeriesFlag2 = 1; 	%status flag which denotes whether all is fine
          switch QmatNMR.DataFormatMRI		%define the output slightly different for each data format
          				%and if needed read in the parameter files
            case 1
              QmatNMR.SeriesDataFormat = 'SMIS';

            case 2
              QmatNMR.SeriesDataFormat = 'Siemens RDA';

            case 3
              QmatNMR.SeriesDataFormat = 'Siemens RAW';

            case 4
              QmatNMR.SeriesDataFormat = 'DICOM';

            otherwise
              QmatNMR.SeriesDataFormat = 'unknown file format';
          end


          %
          %check whether all is fine so far
          %
          if (QmatNMR.SeriesFlag2)
            %
            %based on user input, or the parameter files, define these variables for askfidlaad
            %
            QmatNMR.size1last = QmatNMR.T2;
            QmatNMR.size2last = QmatNMR.T1;


            %
            %first make the variable global and then read in the FID
            %
            eval(['global ' QmatNMR.SeriesVarName]);
            if isempty(QmatNMR.SeriesFlag1)		%the user has not asked for the parameter files to be read in, hence the output
            						%variable is not a structure, unless created by QimportMRI
              eval(['[' QmatNMR.SeriesVarName ', QmatNMR.T2, QmatNMR.T1] = QimportMRI(''' QmatNMR.SeriesName ''', QmatNMR.T2, QmatNMR.T1, QmatNMR.DataFormatMRI, QmatNMR.ByteOrder);']);

              %
              %check whether the output is a structure
              %
              eval(['QTEMP22 = isstruct(' QmatNMR.SeriesVarName ');']);
              if (QTEMP22 == 1)
                eval([QmatNMR.SeriesVarName '.DataPath = QmatNMR.Xpath;']);
                eval([QmatNMR.SeriesVarName '.DataFile = QmatNMR.SeriesName;']);
              end

            else				%parameter files have been read are seem to be in order
              eval(['[QTEMP8, QmatNMR.T2, QmatNMR.T1] = QimportMRI(''' QmatNMR.SeriesName ''', QmatNMR.T2, QmatNMR.T1, QmatNMR.DataFormatMRI, QmatNMR.ByteOrder);']);
              eval([QmatNMR.SeriesVarName '.Spectrum = QTEMP8;']);

              eval([QmatNMR.SeriesVarName '.DataPath = QmatNMR.Xpath;']);
              eval([QmatNMR.SeriesVarName '.DataFile = QmatNMR.SeriesName;']);
            end


            %
            %put the variable name in the list of last variables
            %
            QmatNMR.newinlist.Spectrum = QmatNMR.SeriesVarName;
            if (QmatNMR.T1 == 1)		%1D variable
              QmatNMR.newinlist.Axis = '';
              putinlist1d;

            else			%2D variable
              QmatNMR.newinlist.AxisTD2 = '';
              QmatNMR.newinlist.AxisTD1 = '';
              putinlist2d;
            end

            disp(['Finished loading ' QmatNMR.SeriesDataFormat ' MRI data "', QmatNMR.SeriesName, '". (', num2str(QmatNMR.T2/2), ' x ', num2str(QmatNMR.T1), ' points).']);
            disp(['The data was saved in workspace as: ' QmatNMR.SeriesVarName]);
          end
          Arrowhead;


          %
          %remember the file name as it was given by the user for the next time MRI data needs to be read
          %
          QTEMP = findstr(QmatNMR.Fname, filesep);		%extract the filename and path depending on the platform
          QTEMP9 = length(QTEMP);
          QmatNMR.Xpath = deblank(QmatNMR.Fname(1:QTEMP(QTEMP9))); 			      	%the path
          QmatNMR.Xfilename = deblank(QmatNMR.Fname((QTEMP(QTEMP9)+1):length(QmatNMR.Fname)));       %the file name
        end
      end


      %
      %This may be useful when wanting to operate on series afterwards;
      %
      QmatNMR.AddVariablesCommonString = QmatNMR.namelast;


      %
      %finish by loading the spectrum into matNMR, if asked for
      %
      if (QmatNMR.LoadINTOmatNMRDirectly)
        %
        %load the new FID into matNMR
        %
        disp(['Loading the MRI data into matNMR ...']);

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
    disp('Reading of MRI data cancelled ...');
  end

  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
