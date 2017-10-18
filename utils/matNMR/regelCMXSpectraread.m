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
%regelCMXSpectraread.m reads a binary CMX spectrum file from disk.
%2-4-'97

try
  if (QmatNMR.buttonList == 1)				%OK-button
    watch;
    disp('Please wait while matNMR is reading the spectrum ...');

    QmatNMR.Fname = QmatNMR.uiInput1;
    QmatNMR.namelast = QmatNMR.uiInput4;
    QmatNMR.ReadParameterFilesFlag = QmatNMR.uiInput5;
    QmatNMR.LoadINTOmatNMRDirectly = QmatNMR.uiInput6; 	%load into matNMR directly?

  %
  %Detect whether a series of files must be loaded
  %
    if (isempty(findstr(QmatNMR.Fname, '$')))
      %
      %load single file
      %

      QTEMP = findstr(QmatNMR.Fname, filesep);		%extract the filename and path depending on the platform
      QmatNMR.Xpath = deblank(QmatNMR.uiInput1(1:QTEMP(length(QTEMP))));
      QmatNMR.Xfilename = deblank(QmatNMR.uiInput1((QTEMP(length(QTEMP))+1):length(QmatNMR.uiInput1)));

      if (QmatNMR.ReadParameterFilesFlag)	%use standard parameter files for sizes etc
        QTEMP1 = DetermineCMXSpectraRead(QmatNMR.Xpath);
        QmatNMR.size1last = QTEMP1(1);
        QmatNMR.size2last = QTEMP1(2);
        QmatNMR.FTinTD1 = QTEMP1(3);

      else		%manual input of the parameters
        QTEMP1 = zeros(1, 3); 	%reset the vector used for automatically-read parameters
        if ((QmatNMR.uiInput2(length(QmatNMR.uiInput2)) == 'k') | (QmatNMR.uiInput2(length(QmatNMR.uiInput2)) == 'K'))
          QmatNMR.size1last = round( str2num(QmatNMR.uiInput2(1:(length(QmatNMR.uiInput2)-1))) * 1024 );
        else
          QmatNMR.size1last = round(str2num(QmatNMR.uiInput2));
        end

        if ((QmatNMR.uiInput3(length(QmatNMR.uiInput3)) == 'k') | (QmatNMR.uiInput3(length(QmatNMR.uiInput3)) == 'K'))
          QmatNMR.size2last = round( str2num(QmatNMR.uiInput3(1:(length(QmatNMR.uiInput3)-1))) * 1024 );
        else
          QmatNMR.size2last = round(str2num(QmatNMR.uiInput3));
        end

        QmatNMR.FTinTD1 = 0;
      end


      %
      %read the spectrum into the workspace
      %
      if (length(QTEMP1) == 3)	%no spectral parameters found -> result is a simple matrix (except for a hypercomplex 2D matrix)
        eval([QmatNMR.namelast ' = readCMXProcessedData(QmatNMR.Fname, QmatNMR.size1last, QmatNMR.size2last, QmatNMR.FTinTD1);']);

      else				%spectral parameters found -> result is a matNMR structure
        eval([QmatNMR.namelast ' = GenerateMatNMRStructure;']);
        eval([QmatNMR.namelast '.SpectralFrequencyTD2 = QTEMP1(4);']);
        eval([QmatNMR.namelast '.SweepWidthTD2 = QTEMP1(5);']);
        if (length(QTEMP1) > 5)
          eval([QmatNMR.namelast '.SpectralFrequencyTD1 = QTEMP1(6);']);
          eval([QmatNMR.namelast '.SweepWidthTD1 = QTEMP1(7);']);
        end
        eval([QmatNMR.namelast '.Spectrum = readCMXProcessedData(QmatNMR.Fname, QmatNMR.size1last, QmatNMR.size2last, QmatNMR.FTinTD1);']);

        %store the file name in the structure
        eval([QmatNMR.namelast '.DataPath = QmatNMR.Xpath;']);
        eval([QmatNMR.namelast '.DataFile = QmatNMR.Xfilename;']);

        %set the FID status to spectrum for TD2 and TD1
        eval([QmatNMR.namelast '.FIDstatusTD2 = 1;']);
        eval([QmatNMR.namelast '.FIDstatusTD1 = 1;']);
        if (~QmatNMR.FTinTD1)
          eval([QmatNMR.namelast '.FIDstatusTD1 = 2;']);
        end

        %set the carrier index for the default axis
        eval([QmatNMR.namelast '.DefaultAxisCarrierIndexTD2 = floor(QmatNMR.size1last/2)+1;']);
        eval([QmatNMR.namelast '.DefaultAxisCarrierIndexTD1 = floor(QmatNMR.size2last/2)+1;']);
      end

      %
      %display status output
      %
      disp(['Finished loading Chemagnetics spectrum ', QmatNMR.Fname, '. (', num2str(QmatNMR.size1last), ' x ', num2str(QmatNMR.size2last), ' points).']);
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
        if (QmatNMR.size2last == 1)
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
          if (QTEMP1(6) == 2)
            QmatNMR.buttonList = 3;		%FID in TD1
          else
            QmatNMR.buttonList = 2;
          end
          regelnaam
        end

      else
        %
        %Only store the variable in the workspace
        %
        QmatNMR.newinlist.Spectrum = QmatNMR.namelast;
        if (QmatNMR.size2last == 1)
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
          %First we check out the parameter files for this iteration
          %
          if (QmatNMR.ReadParameterFilesFlag)	%use standard parameter files for sizes etc
            QTEMP1 = DetermineCMXSpectraRead(QmatNMR.Xpath);
            QmatNMR.size1last = QTEMP1(1);
            QmatNMR.size2last = QTEMP1(2);
            QmatNMR.FTinTD1 = QTEMP1(3);

          else		%manual input of the parameters
            QTEMP1 = zeros(1, 3); 	%reset the vector used for automatically-read parameters
            if ((QmatNMR.uiInput2(length(QmatNMR.uiInput2)) == 'k') | (QmatNMR.uiInput2(length(QmatNMR.uiInput2)) == 'K'))
              QmatNMR.size1last = round( str2num(QmatNMR.uiInput2(1:(length(QmatNMR.uiInput2)-1))) * 1024 );
            else
              QmatNMR.size1last = round(str2num(QmatNMR.uiInput2));
            end

            if ((QmatNMR.uiInput3(length(QmatNMR.uiInput3)) == 'k') | (QmatNMR.uiInput3(length(QmatNMR.uiInput3)) == 'K'))
              QmatNMR.size2last = round( str2num(QmatNMR.uiInput3(1:(length(QmatNMR.uiInput3)-1))) * 1024 );
            else
              QmatNMR.size2last = round(str2num(QmatNMR.uiInput3));
            end

            QmatNMR.FTinTD1 = 0;
          end


          %
          %Next we read in the FID
          %
          if (length(QTEMP1) == 3)	%no spectral parameters found -> result is a simple matrix (except for a hypercomplex 2D matrix)
            eval([QmatNMR.SeriesVarName ' = readCMXProcessedData(''' QmatNMR.SeriesName ''', QmatNMR.size1last, QmatNMR.size2last, QmatNMR.FTinTD1);']);

          else				%spectral parameters found -> result is a matNMR structure
            eval([QmatNMR.SeriesVarName ' = GenerateMatNMRStructure;']);
            eval([QmatNMR.SeriesVarName '.SpectralFrequencyTD2 = QTEMP1(4);']);
            eval([QmatNMR.SeriesVarName '.SweepWidthTD2 = QTEMP1(5);']);
            if (length(QTEMP1) > 5)
              eval([QmatNMR.SeriesVarName '.SpectralFrequencyTD1 = QTEMP1(6);']);
              eval([QmatNMR.SeriesVarName '.SweepWidthTD1 = QTEMP1(7);']);
            end
            eval([QmatNMR.SeriesVarName '.Spectrum = readCMXProcessedData(''' QmatNMR.SeriesName ''', QmatNMR.size1last, QmatNMR.size2last, QmatNMR.FTinTD1);']);

            %set the carrier index for the default axis
            eval([QmatNMR.SeriesVarName '.DefaultAxisCarrierIndexTD2 = floor(QmatNMR.size1last/2)+1;']);
            eval([QmatNMR.SeriesVarName '.DefaultAxisCarrierIndexTD1 = floor(QmatNMR.size2last/2)+1;']);

            %store the file name in the structure
            eval([QmatNMR.SeriesVarName '.DataPath = QmatNMR.Xpath;']);
            eval([QmatNMR.SeriesVarName '.DataFile = QmatNMR.SeriesName;']);

            %set the FID status in TD2 and TD1
            eval([QmatNMR.SeriesVarName '.FIDstatusTD2 = 1;']);
            eval([QmatNMR.SeriesVarName '.FIDstatusTD1 = 1;']);
            if (~QmatNMR.FTinTD1)
              eval([QmatNMR.SeriesVarName '.FIDstatusTD1 = 2;']);
            end
          end


          %
          %Store in list of last spectra
          %
          QmatNMR.newinlist.Spectrum = QmatNMR.SeriesVarName;
          if (QmatNMR.size2last == 1)
            QmatNMR.newinlist.Axis = '';
            putinlist1d;

          else
            QmatNMR.newinlist.AxisTD2 = '';
            QmatNMR.newinlist.AxisTD1 = '';
            putinlist2d;
          end

          disp(['Finished loading Chemagnetics spectrum ', QmatNMR.SeriesName, '. (', num2str(QmatNMR.size1last), ' x ', num2str(QmatNMR.size2last), ' points).']);
          disp(['The spectrum was saved in workspace as: ' QmatNMR.SeriesVarName]);


          %
          %remember the file name as it was given by the user for the next time a binary FID needs to be read
          %
          QTEMP = findstr(QmatNMR.Fname, filesep);		%extract the filename and path depending on the platform
          QTEMP9 = length(QTEMP);
          QmatNMR.Xpath = deblank(QmatNMR.Fname(1:QTEMP(QTEMP9))); 			      	%the path
          QmatNMR.Xfilename = deblank(QmatNMR.Fname((QTEMP(QTEMP9)+1):length(QmatNMR.Fname)));       %the file name
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
    disp('Reading of Chemagnetics Spectrum cancelled ...');
  end

  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
