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
%regelBrukerSpectraread.m reads a binary Bruker spectrum file from disk.
%2-4-'97

try
  if (QmatNMR.buttonList == 1)				%OK-button
    watch;
    disp('Please wait while matNMR is reading the spectrum ...');

    QmatNMR.Fname = QmatNMR.uiInput1;
    QmatNMR.namelast = QmatNMR.uiInput8;
    QmatNMR.ReadImaginaryFlag = QmatNMR.uiInput9;
    QmatNMR.ReadParameterFilesFlag = QmatNMR.uiInput10;
    QmatNMR.LoadINTOmatNMRDirectly = QmatNMR.uiInput11;       %load into matNMR directly?

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
        QTEMP1 = DetermineBrukerSpectraRead(QmatNMR.Xpath);
        QmatNMR.size1last = QTEMP1(1);
        QmatNMR.size2last = QTEMP1(2);
        QmatNMR.BlockingTD2 = QTEMP1(3);
        %
        %If no blocking is specified then the full size will be taken
        %
        if (QmatNMR.BlockingTD2 == 0)
          QTEMP3 = QmatNMR.size1last;
        else
          QTEMP3 = QmatNMR.BlockingTD2;
        end

        QmatNMR.BlockingTD1 = QTEMP1(4);
        %
        %If no blocking is specified then the full size will be taken
        %
        if (QmatNMR.BlockingTD1 == 0)
          QTEMP4 = QmatNMR.size2last;
        else
          QTEMP4 = QmatNMR.BlockingTD1;
        end
        QmatNMR.BrukerByteOrdering = QTEMP1(5);

      else		%manual input of the parameters
        QTEMP1 = zeros(1, 6); 	%reset the vector used for automatically-read parameters
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

        if ((QmatNMR.uiInput4(length(QmatNMR.uiInput4)) == 'k') | (QmatNMR.uiInput4(length(QmatNMR.uiInput4)) == 'K'))
          QmatNMR.BlockingTD2 = round( str2num(QmatNMR.uiInput4(1:(length(QmatNMR.uiInput4)-1))) * 1024 );
        else
          QmatNMR.BlockingTD2 = round(str2num(QmatNMR.uiInput4));
        end

        %
        %If no blocking is specified then the full size will be taken
        %
        if (QmatNMR.BlockingTD2 == 0)
          QTEMP3 = QmatNMR.size1last;

        else
          QTEMP3 = QmatNMR.BlockingTD2;
        end

        if ((QmatNMR.uiInput5(length(QmatNMR.uiInput5)) == 'k') | (QmatNMR.uiInput5(length(QmatNMR.uiInput5)) == 'K'))
          QmatNMR.BlockingTD1 = round( str2num(QmatNMR.uiInput5(1:(length(QmatNMR.uiInput5)-1))) * 1024 );
        else
          QmatNMR.BlockingTD1 = round(str2num(QmatNMR.uiInput5));
        end

        %
        %If no blocking is specified then the full size will be taken
        %
        if (QmatNMR.BlockingTD1 == 0)
          QTEMP4 = QmatNMR.size2last;

        else
          QTEMP4 = QmatNMR.BlockingTD1;
        end


        %
        %The byte ordering
        %
        QmatNMR.BrukerByteOrdering = QmatNMR.uiInput6;


        %
        %The FID status in the indirect dimension
        %
        QmatNMR.BrukerFIDstatus = QmatNMR.uiInput7;
        if (QmatNMR.BrukerFIDstatus == 2)	%FID
          QTEMP1(6) = 2;
        end
      end


      %
      %next we see whether we need to read in the imaginary parts as well
      %
      if (QmatNMR.ReadImaginaryFlag) 	%try to read the imaginary parts as well?
        if strcmp(QmatNMR.Xfilename, '1r')
          %check whether the imaginary parts exist on disk
          QTEMP21 = QmatNMR.Fname;
          QTEMP21(end-1:end) = '1i';
          if exist(QTEMP21, 'file')
            QTEMP20 = 1;
          else
            %
            %imaginary parts cannot be found on disk
            %
            QmatNMR.ReadImaginaryFlag = 0;
            disp('matNMR NOTICE: imaginary parts could not be found on disk and will be ignored!');
          end

        elseif strcmp(QmatNMR.Xfilename, '2rr')
          %check whether the imaginary parts exist on disk
          %In principal there are the 2ri, 2ir and 2ii files to look for in case of hypercomplex spectra
          %If only 2ii is found then a non-hypercomplex matrix is assumed
          QTEMP21 = QmatNMR.Fname;
          QTEMP21(end-2:end) = '2ir';
          QTEMP22 = QmatNMR.Fname;
          QTEMP22(end-2:end) = '2ri';
          QTEMP23 = QmatNMR.Fname;
          QTEMP23(end-2:end) = '2ii';
          if (exist(QTEMP21, 'file') & exist(QTEMP22, 'file') & exist(QTEMP23, 'file'))
            QTEMP20 = 2; 		%hypercomplex part is present
            disp('matNMR NOTICE: hypercomplex parts will be loaded for the selected Bruker 2D spectrum');

          elseif (exist(QTEMP23, 'file'))
            QTEMP20 = 3; 		%no hypercomplex part
            disp('matNMR NOTICE: no hypercomplex parts were found, only loading the imaginary part');

          else
            %
            %imaginary parts cannot be found on disk
            %
            QmatNMR.ReadImaginaryFlag = 0;
            disp('matNMR NOTICE: imaginary/hypercomplex parts could not be found on disk and will be ignored!');
          end
        else
          %
          %filename is not 1r or 2rr and so we will neglect this option
          %
          QmatNMR.ReadImaginaryFlag = 0;
          disp('matNMR NOTICE: filename is not 1r or 2rr and therefore matNMR will NOT read the imaginary parts!');
        end
      end


      %
      %read the spectrum into the workspace
      %
      if (length(QTEMP1) == 6)	%no spectral parameters found -> result is a simple matrix (except for a hypercomplex 2D matrix)
        eval([QmatNMR.namelast ' = readBrukerProcessedData(QmatNMR.Fname, QmatNMR.size1last, QmatNMR.size2last, QTEMP3, QTEMP4, QmatNMR.BrukerByteOrdering);']);

        if (QmatNMR.ReadImaginaryFlag) 	%try to read the imaginary parts as well
          if (QTEMP20 == 1)		%1D spectrum
            QTEMP21 = QmatNMR.Fname;
              QTEMP21(end-1:end) = '1i';
            eval(['QTEMP21 = readBrukerProcessedData(QTEMP21, QmatNMR.size1last, QmatNMR.size2last, QTEMP3, QTEMP4, QmatNMR.BrukerByteOrdering);']);
            %add the imaginary part to the matrix
            eval([QmatNMR.namelast ' = ' QmatNMR.namelast ' + sqrt(-1)*QTEMP21;']);

            if (QTEMP1(6))		%if asked for reverse the spectrum
              eval([QmatNMR.namelast ' = flipud(' QmatNMR.namelast ');']);
            end

          elseif (QTEMP20 == 2) 	%2D spectrum with hypercomplex parts
            %first create a matNMR structure to accomodate the hypercomplex part
            eval(['QTEMP21 = ' QmatNMR.namelast ';']);
            eval([QmatNMR.namelast ' = GenerateMatNMRStructure;']);
            %then define the imaginary part and add that to the already-loaded real part
            QTEMP22 = QmatNMR.Fname;
              QTEMP22(end-2:end) = '2ir';
            eval([QmatNMR.namelast '.Spectrum = QTEMP21 + sqrt(-1)*readBrukerProcessedData(QTEMP22, QmatNMR.size1last, QmatNMR.size2last, QTEMP3, QTEMP4, QmatNMR.BrukerByteOrdering);']);

            %finally define the hypercomplex parts
            QTEMP21 = QmatNMR.Fname;
              QTEMP21(end-2:end) = '2ri';
            QTEMP22 = QmatNMR.Fname;
              QTEMP22(end-2:end) = '2ii';
            eval([QmatNMR.namelast '.Hypercomplex = readBrukerProcessedData(QTEMP21, QmatNMR.size1last, QmatNMR.size2last, QTEMP3, QTEMP4, QmatNMR.BrukerByteOrdering) + sqrt(-1)*readBrukerProcessedData(QTEMP22, QmatNMR.size1last, QmatNMR.size2last, QTEMP3, QTEMP4, QmatNMR.BrukerByteOrdering);']);

            %set the FID status to spectrum for TD2 and TD1
            eval([QmatNMR.namelast '.FIDstatusTD2 = 1;']);
            eval([QmatNMR.namelast '.FIDstatusTD1 = 1;']);

            %set the carrier index for the default axis
            eval([QmatNMR.namelast '.DefaultAxisCarrierIndexTD2 = floor(QmatNMR.size1last/2)+1;']);
            eval([QmatNMR.namelast '.DefaultAxisCarrierIndexTD1 = floor(QmatNMR.size2last/2)+1;']);

            %store the file name in the structure
            eval([QmatNMR.namelast '.DataPath = QmatNMR.Xpath;']);
            eval([QmatNMR.namelast '.DataFile = QmatNMR.Xfilename;']);

            %reverse spectrum is asked for
            if (QTEMP1(6) == 1)		%if asked for reverse the spectrum
              eval([QmatNMR.namelast '.Spectrum = flipud(' QmatNMR.namelast '.Spectrum);']);
              eval([QmatNMR.namelast '.Hypercomplex = flipud(' QmatNMR.namelast '.Hypercomplex);']);

            elseif (QTEMP1(6) == 2) 	%set status to FID
              eval([QmatNMR.namelast '.Spectrum = flipud(' QmatNMR.namelast '.Spectrum);']);
              eval([QmatNMR.namelast '.Hypercomplex = flipud(' QmatNMR.namelast '.Hypercomplex);']);
              eval([QmatNMR.namelast '.FIDstatusTD1 = 2;']);
            end

          elseif (QTEMP20 == 3) 	%2D spectrum without hypercomplex parts
            %first create a matNMR structure to accomodate the hypercomplex part
            eval(['QTEMP21 = ' QmatNMR.namelast ';']);
            eval([QmatNMR.namelast ' = GenerateMatNMRStructure;']);
            %then define the imaginary part and add that to the already-loaded real part
            QTEMP22 = QmatNMR.Fname;
              QTEMP22(end-2:end) = '2ii';
            eval([QmatNMR.namelast '.Spectrum = QTEMP21 + sqrt(-1)*readBrukerProcessedData(QTEMP22, QmatNMR.size1last, QmatNMR.size2last, QTEMP3, QTEMP4, QmatNMR.BrukerByteOrdering);']);

            %set the FID status to spectrum for TD2 and TD1
            eval([QmatNMR.namelast '.FIDstatusTD2 = 1;']);
            eval([QmatNMR.namelast '.FIDstatusTD1 = 1;']);

            %store the file name in the structure
            eval([QmatNMR.namelast '.DataPath = QmatNMR.Xpath;']);
            eval([QmatNMR.namelast '.DataFile = QmatNMR.Xfilename;']);

            %set the carrier index for the default axis
            eval([QmatNMR.namelast '.DefaultAxisCarrierIndexTD2 = floor(QmatNMR.size1last/2)+1;']);
            eval([QmatNMR.namelast '.DefaultAxisCarrierIndexTD1 = floor(QmatNMR.size2last/2)+1;']);

            %reverse spectrum is asked for
            if (QTEMP1(6) == 1)		%if asked for reverse the spectrum
              eval([QmatNMR.namelast '.Spectrum = flipud(' QmatNMR.namelast '.Spectrum);']);

            elseif (QTEMP1(6) == 2) 	%set status to FID
              eval([QmatNMR.namelast '.Spectrum = flipud(' QmatNMR.namelast '.Spectrum);']);
              eval([QmatNMR.namelast '.FIDstatusTD1 = 2;']);
            end
          end

        else	%no imaginart part

          if (QTEMP1(6))		%if asked for reverse the spectrum
            eval([QmatNMR.namelast ' = flipud(' QmatNMR.namelast ');']);
          end
        end


      else				%spectral parameters found -> result is a matNMR structure
        eval([QmatNMR.namelast ' = GenerateMatNMRStructure;']);
        eval([QmatNMR.namelast '.SpectralFrequencyTD2 = QTEMP1(7);']);
        eval([QmatNMR.namelast '.SweepWidthTD2 = QTEMP1(8);']);
        if (length(QTEMP1) > 8)
          eval([QmatNMR.namelast '.SpectralFrequencyTD1 = QTEMP1(9);']);
          eval([QmatNMR.namelast '.SweepWidthTD1 = QTEMP1(10);']);
        end
        eval([QmatNMR.namelast '.DefaultAxisCarrierIndexTD2 = floor(QmatNMR.size1last/2)+1;']);
        eval([QmatNMR.namelast '.DefaultAxisCarrierIndexTD1 = floor(QmatNMR.size2last/2)+1;']);
        eval([QmatNMR.namelast '.Spectrum = readBrukerProcessedData(QmatNMR.Fname, QmatNMR.size1last, QmatNMR.size2last, QTEMP3, QTEMP4, QmatNMR.BrukerByteOrdering);']);

        %set the FID status to spectrum for TD2 and TD1
        eval([QmatNMR.namelast '.FIDstatusTD2 = 1;']);
        eval([QmatNMR.namelast '.FIDstatusTD1 = 1;']);

        %store the file name in the structure
        eval([QmatNMR.namelast '.DataPath = QmatNMR.Xpath;']);
        eval([QmatNMR.namelast '.DataFile = QmatNMR.Xfilename;']);

        if (QmatNMR.ReadImaginaryFlag) 	%try to read the imaginary parts as well
          if (QTEMP20 == 1)		%1D spectrum
            QTEMP21 = QmatNMR.Fname;
              QTEMP21(end-1:end) = '1i';
            eval([QmatNMR.namelast '.Spectrum = ' QmatNMR.namelast '.Spectrum + sqrt(-1)*readBrukerProcessedData(QTEMP21, QmatNMR.size1last, QmatNMR.size2last, QTEMP3, QTEMP4, QmatNMR.BrukerByteOrdering);']);

            if (QTEMP1(6) == 1)		%if asked for reverse the spectrum
              eval([QmatNMR.namelast '.Spectrum = flipud(' QmatNMR.namelast '.Spectrum);']);

            elseif (QTEMP1(6) == 2) 	%set status to FID
              eval([QmatNMR.namelast '.Spectrum = flipud(' QmatNMR.namelast '.Spectrum);']);
              eval([QmatNMR.namelast '.FIDstatusTD1 = 2;']);
            end

          elseif (QTEMP20 == 2) 	%2D spectrum with hypercomplex parts
            %then define the imaginary part and add that to the already-loaded real part
            QTEMP22 = QmatNMR.Fname;
              QTEMP22(end-2:end) = '2ir';
            eval([QmatNMR.namelast '.Spectrum = ' QmatNMR.namelast '.Spectrum + sqrt(-1)*readBrukerProcessedData(QTEMP22, QmatNMR.size1last, QmatNMR.size2last, QTEMP3, QTEMP4, QmatNMR.BrukerByteOrdering);']);

            %finally define the hypercomplex parts
            QTEMP21 = QmatNMR.Fname;
              QTEMP21(end-2:end) = '2ri';
            QTEMP22 = QmatNMR.Fname;
              QTEMP22(end-2:end) = '2ii';
            eval([QmatNMR.namelast '.Hypercomplex = readBrukerProcessedData(QTEMP21, QmatNMR.size1last, QmatNMR.size2last, QTEMP3, QTEMP4, QmatNMR.BrukerByteOrdering) + sqrt(-1)*readBrukerProcessedData(QTEMP22, QmatNMR.size1last, QmatNMR.size2last, QTEMP3, QTEMP4, QmatNMR.BrukerByteOrdering);']);

            %reverse spectrum is asked for
            if (QTEMP1(6) == 1)		%if asked for reverse the spectrum
              eval([QmatNMR.namelast '.Spectrum = flipud(' QmatNMR.namelast '.Spectrum);']);
              eval([QmatNMR.namelast '.Hypercomplex = flipud(' QmatNMR.namelast '.Hypercomplex);']);

            elseif (QTEMP1(6) == 2) 	%set status to FID
              eval([QmatNMR.namelast '.Spectrum = flipud(' QmatNMR.namelast '.Spectrum);']);
              eval([QmatNMR.namelast '.Hypercomplex = flipud(' QmatNMR.namelast '.Hypercomplex);']);
              eval([QmatNMR.namelast '.FIDstatusTD1 = 2;']);
            end

          elseif (QTEMP20 == 3) 	%2D spectrum without hypercomplex parts
            %then define the imaginary part and add that to the already-loaded real part
            QTEMP22 = QmatNMR.Fname;
              QTEMP22(end-2:end) = '2ii';
            eval([QmatNMR.namelast '.Spectrum = ' QmatNMR.namelast '.Spectrum + sqrt(-1)*readBrukerProcessedData(QTEMP22, QmatNMR.size1last, QmatNMR.size2last, QTEMP3, QTEMP4, QmatNMR.BrukerByteOrdering);']);

            %reverse spectrum is asked for
            if (QTEMP1(6) == 1)		%if asked for reverse the spectrum
              eval([QmatNMR.namelast '.Spectrum = flipud(' QmatNMR.namelast '.Spectrum);']);

            elseif (QTEMP1(6) == 2) 	%set status to FID
              eval([QmatNMR.namelast '.Spectrum = flipud(' QmatNMR.namelast '.Spectrum);']);
              eval([QmatNMR.namelast '.FIDstatusTD1 = 2;']);
            end
          end

        else	%no imaginary part

          if (QTEMP1(6) == 1)		%if asked for reverse the spectrum
            eval([QmatNMR.namelast '.Spectrum = flipud(' QmatNMR.namelast '.Spectrum);']);

          elseif (QTEMP1(6) == 2) 	%set status to FID
            eval([QmatNMR.namelast '.Spectrum = flipud(' QmatNMR.namelast '.Spectrum);']);
            eval([QmatNMR.namelast '.FIDstatusTD1 = 2;']);
          end
        end
      end


      %
      %display status output
      %
      disp(['Finished loading Bruker spectrum ', QmatNMR.Fname, '. (', num2str(QmatNMR.size1last), ' x ', num2str(QmatNMR.size2last), ' points).']);
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
            QTEMP1 = DetermineBrukerSpectraRead(QmatNMR.Xpath);
            QmatNMR.size1last = QTEMP1(1);
            QmatNMR.size2last = QTEMP1(2);
            QmatNMR.BlockingTD2 = QTEMP1(3);
            %
            %If no blocking is specified then the full size will be taken
            %
            if (QmatNMR.BlockingTD2 == 0)
              QTEMP8 = QmatNMR.size1last;
            else
              QTEMP8 = QmatNMR.BlockingTD2;
            end

            QmatNMR.BlockingTD1 = QTEMP1(4);
            %
            %If no blocking is specified then the full size will be taken
            %
            if (QmatNMR.BlockingTD1 == 0)
              QTEMP9 = QmatNMR.size2last;
            else
              QTEMP9 = QmatNMR.BlockingTD1;
            end
            QmatNMR.BrukerByteOrdering = QTEMP1(5);

          else		%manual input of the parameters
            QTEMP1 = zeros(1, 6); 	%reset the vector used for automatically-read parameters

          %
          %
          %
            if ((QmatNMR.uiInput2(length(QmatNMR.uiInput2)) == 'k') | (QmatNMR.uiInput2(length(QmatNMR.uiInput2)) == 'K'))
              QmatNMR.size1last = round( str2num(QmatNMR.uiInput2(1:(length(QmatNMR.uiInput2)-1))) * 1024 );
            else
              QmatNMR.size1last = round(str2num(QmatNMR.uiInput2));
            end


          %
          %
          %
            if ((QmatNMR.uiInput3(length(QmatNMR.uiInput3)) == 'k') | (QmatNMR.uiInput3(length(QmatNMR.uiInput3)) == 'K'))
              QmatNMR.size2last = round( str2num(QmatNMR.uiInput3(1:(length(QmatNMR.uiInput3)-1))) * 1024 );
            else
              QmatNMR.size2last = round(str2num(QmatNMR.uiInput3));
            end


          %
          %
          %
            if ((QmatNMR.uiInput4(length(QmatNMR.uiInput4)) == 'k') | (QmatNMR.uiInput4(length(QmatNMR.uiInput4)) == 'K'))
              QmatNMR.BlockingTD2 = round( str2num(QmatNMR.uiInput4(1:(length(QmatNMR.uiInput4)-1))) * 1024 );
            else
              QmatNMR.BlockingTD2 = round(str2num(QmatNMR.uiInput4));
            end

            %
            %If no blocking is specified then the full size will be taken
            %
            if (QmatNMR.BlockingTD2 == 0)
              QTEMP8 = QmatNMR.size1last;

            else
              QTEMP8 = QmatNMR.BlockingTD2;
            end


          %
          %
          %
            if ((QmatNMR.uiInput5(length(QmatNMR.uiInput5)) == 'k') | (QmatNMR.uiInput5(length(QmatNMR.uiInput5)) == 'K'))
              QmatNMR.BlockingTD1 = round( str2num(QmatNMR.uiInput5(1:(length(QmatNMR.uiInput5)-1))) * 1024 );
            else
              QmatNMR.BlockingTD1 = round(str2num(QmatNMR.uiInput5));
            end

            %
            %If no blocking is specified then the full size will be taken
            %
            if (QmatNMR.BlockingTD1 == 0)
              QTEMP9 = QmatNMR.size2last;

            else
              QTEMP9 = QmatNMR.BlockingTD1;
            end


            %
            %The byte ordering
            %
            QmatNMR.BrukerByteOrdering = QmatNMR.uiInput6;


            %
            %The FID status in the indirect dimension
            %
            QmatNMR.BrukerFIDstatus = QmatNMR.uiInput7;
            if (QmatNMR.BrukerFIDstatus == 2)	%FID
              QTEMP1(6) = 2;
            end
          end


          %
          %next we see whether we need to read in the imaginary parts as well
          %
          if (QmatNMR.ReadImaginaryFlag) 	%try to read the imaginary parts as well?
            if strcmp(QmatNMR.Xfilename, '1r')
              %check whether the imaginary parts exist on disk
              QTEMP21 = QmatNMR.SeriesName;
              QTEMP21(end-1:end) = '1i';
              if exist(QTEMP21, 'file')
                QTEMP20 = 1;
              else
                %
                %imaginary parts cannot be found on disk
                %
                QTEMP20 = 0; 		%this code will ignore the imaginary parts for this iteration
                disp('matNMR NOTICE: imaginary parts could not be found on disk and will be ignored!');
              end

            elseif strcmp(QmatNMR.Xfilename, '2rr')
              %check whether the imaginary parts exist on disk
              %In principal there are the 2ri, 2ir and 2ii files to look for in case of hypercomplex spectra
              %If only 2ii is found then a non-hypercomplex matrix is assumed
              QTEMP21 = QmatNMR.SeriesName;
              QTEMP21(end-2:end) = '2ir';
              QTEMP22 = QmatNMR.SeriesName;
              QTEMP22(end-2:end) = '2ri';
              QTEMP23 = QmatNMR.SeriesName;
              QTEMP23(end-2:end) = '2ii';
              if (exist(QTEMP21, 'file') & exist(QTEMP22, 'file') & exist(QTEMP23, 'file'))
                QTEMP20 = 2; 		%hypercomplex part is present
                disp('matNMR NOTICE: hypercomplex parts will be loaded for the selected Bruker 2D spectrum');

              elseif (exist(QTEMP23, 'file'))
                QTEMP20 = 3; 		%no hypercomplex part
                disp('matNMR NOTICE: no hypercomplex parts were found, only loading the imaginary part');

              else
                %
                %imaginary parts cannot be found on disk
                %
                QTEMP20 = 0; 		%this code will ignore the imaginary parts for this iteration
                disp('matNMR NOTICE: imaginary/hypercomplex parts could not be found on disk and will be ignored!');
              end
            else
              %
              %filename is not 1r or 2rr and so we will neglect this option
              %
              QTEMP20 = 0; 		%this code will ignore the imaginary parts for this iteration
            end
          end


          %
          %Next we read in the FID
          %
          if (length(QTEMP1) == 6)	%no spectral parameters found -> result is a simple matrix (except for a hypercomplex 2D matrix)
            eval([QmatNMR.SeriesVarName ' = readBrukerProcessedData(''' QmatNMR.SeriesName ''', QmatNMR.size1last, QmatNMR.size2last, QTEMP8, QTEMP9, QmatNMR.BrukerByteOrdering);']);

            if (QTEMP20 == 0)		%ignore all imaginary parts
              if (QTEMP1(6))		%if asked for reverse the spectrum
                eval([QmatNMR.SeriesVarName ' = flipud(' QmatNMR.SeriesVarName ');']);
              end

            elseif (QTEMP20 == 1)		%1D spectrum
              QTEMP21 = QmatNMR.SeriesName;
              QTEMP21(end-1:end) = '1i';
              eval(['QTEMP21 = readBrukerProcessedData(QTEMP21, QmatNMR.size1last, QmatNMR.size2last, QTEMP8, QTEMP9, QmatNMR.BrukerByteOrdering);']);
              %add the imaginary part to the matrix
              eval([QmatNMR.SeriesVarName ' = ' QmatNMR.SeriesVarName ' + sqrt(-1)*QTEMP21;']);

              if (QTEMP1(6))		%if asked for reverse the spectrum
                eval([QmatNMR.SeriesVarName ' = flipud(' QmatNMR.SeriesVarName ');']);
              end

            elseif (QTEMP20 == 2) 	%2D spectrum with hypercomplex parts
              %first create a matNMR structure to accomodate the hypercomplex part
              eval(['QTEMP21 = ' QmatNMR.SeriesVarName ';']);
              eval([QmatNMR.SeriesVarName ' = GenerateMatNMRStructure;']);
              %then define the imaginary part and add that to the already-loaded real part
              QTEMP22 = QmatNMR.SeriesName;
              QTEMP22(end-2:end) = '2ir';
              eval([QmatNMR.SeriesVarName '.Spectrum = QTEMP21 + sqrt(-1)*readBrukerProcessedData(QTEMP22, QmatNMR.size1last, QmatNMR.size2last, QTEMP8, QTEMP9, QmatNMR.BrukerByteOrdering);']);

              %finally define the hypercomplex parts
              QTEMP21 = QmatNMR.SeriesName;
              QTEMP21(end-2:end) = '2ri';
              QTEMP22 = QmatNMR.SeriesName;
              QTEMP22(end-2:end) = '2ii';
              eval([QmatNMR.SeriesVarName '.Hypercomplex = readBrukerProcessedData(QTEMP21, QmatNMR.size1last, QmatNMR.size2last, QTEMP8, QTEMP9, QmatNMR.BrukerByteOrdering) + sqrt(-1)*readBrukerProcessedData(QTEMP22, QmatNMR.size1last, QmatNMR.size2last, QTEMP8, QTEMP9, QmatNMR.BrukerByteOrdering);']);

              %set the carrier index for the default axis
              eval([QmatNMR.SeriesVarName '.DefaultAxisCarrierIndexTD2 = floor(QmatNMR.size1last/2)+1;']);
              eval([QmatNMR.SeriesVarName '.DefaultAxisCarrierIndexTD1 = floor(QmatNMR.size2last/2)+1;']);

              %store the file name in the structure
              eval([QmatNMR.SeriesVarName '.DataPath = QmatNMR.Xpath;']);
              eval([QmatNMR.SeriesVarName '.DataFile = QmatNMR.SeriesName;']);

              %set the FID status in TD2
              eval([QmatNMR.SeriesVarName '.FIDstatusTD2 = 1;']);
              eval([QmatNMR.SeriesVarName '.FIDstatusTD1 = 1;']);

              %reverse spectrum is asked for
              if (QTEMP1(6) == 1)		%if asked for reverse the spectrum
                eval([QmatNMR.SeriesVarName '.Spectrum = flipud(' QmatNMR.SeriesVarName '.Spectrum);']);
                eval([QmatNMR.SeriesVarName '.Hypercomplex = flipud(' QmatNMR.SeriesVarName '.Hypercomplex);']);

              elseif (QTEMP1(6) == 2) 	%set status to FID
                eval([QmatNMR.SeriesVarName '.Spectrum = flipud(' QmatNMR.SeriesVarName '.Spectrum);']);
                eval([QmatNMR.SeriesVarName '.Hypercomplex = flipud(' QmatNMR.SeriesVarName '.Hypercomplex);']);
                eval([QmatNMR.SeriesVarName '.FIDstatusTD1 = 2;']);
              end

            elseif (QTEMP20 == 3) 	%2D spectrum without hypercomplex parts
              %first create a matNMR structure to accomodate the hypercomplex part
              eval(['QTEMP21 = ' QmatNMR.SeriesVarName ';']);
              eval([QmatNMR.SeriesVarName ' = GenerateMatNMRStructure;']);
              %then define the imaginary part and add that to the already-loaded real part
              QTEMP22 = QmatNMR.SeriesName;
              QTEMP22(end-2:end) = '2ii';
              eval([QmatNMR.SeriesVarName '.Spectrum = QTEMP21 + sqrt(-1)*readBrukerProcessedData(QTEMP22, QmatNMR.size1last, QmatNMR.size2last, QTEMP8, QTEMP9, QmatNMR.BrukerByteOrdering);']);

              %set the carrier index for the default axis
              eval([QmatNMR.SeriesVarName '.DefaultAxisCarrierIndexTD2 = floor(QmatNMR.size1last/2)+1;']);
              eval([QmatNMR.SeriesVarName '.DefaultAxisCarrierIndexTD1 = floor(QmatNMR.size2last/2)+1;']);

              %store the file name in the structure
              eval([QmatNMR.SeriesVarName '.DataPath = QmatNMR.Xpath;']);
              eval([QmatNMR.SeriesVarName '.DataFile = QmatNMR.SeriesName;']);

              %set the FID status in TD2 and TD1
              eval([QmatNMR.SeriesVarName '.FIDstatusTD2 = 1;']);
              eval([QmatNMR.SeriesVarName '.FIDstatusTD1 = 1;']);

              %reverse spectrum is asked for
              if (QTEMP1(6) == 1)		%if asked for reverse the spectrum
                eval([QmatNMR.SeriesVarName '.Spectrum = flipud(' QmatNMR.SeriesVarName '.Spectrum);']);

              elseif (QTEMP1(6) == 2) 	%set status to FID
                eval([QmatNMR.SeriesVarName '.Spectrum = flipud(' QmatNMR.SeriesVarName '.Spectrum);']);
                eval([QmatNMR.SeriesVarName '.FIDstatusTD1 = 2;']);
              end
            end

          else				%spectral parameters found -> result is a matNMR structure
            eval([QmatNMR.SeriesVarName ' = GenerateMatNMRStructure;']);
            eval([QmatNMR.SeriesVarName '.SpectralFrequencyTD2 = QTEMP1(7);']);
            eval([QmatNMR.SeriesVarName '.SweepWidthTD2 = QTEMP1(8);']);
            if (length(QTEMP1) > 8)
              eval([QmatNMR.SeriesVarName '.SpectralFrequencyTD1 = QTEMP1(9);']);
              eval([QmatNMR.SeriesVarName '.SweepWidthTD1 = QTEMP1(10);']);
            end
            eval([QmatNMR.SeriesVarName '.Spectrum = readBrukerProcessedData(''' QmatNMR.SeriesName ''', QmatNMR.size1last, QmatNMR.size2last, QTEMP8, QTEMP9, QmatNMR.BrukerByteOrdering);']);

            %set the carrier index for the default axis
            eval([QmatNMR.SeriesVarName '.DefaultAxisCarrierIndexTD2 = floor(QmatNMR.size1last/2)+1;']);
            eval([QmatNMR.SeriesVarName '.DefaultAxisCarrierIndexTD1 = floor(QmatNMR.size2last/2)+1;']);

            %store the file name in the structure
            eval([QmatNMR.SeriesVarName '.DataPath = QmatNMR.Xpath;']);
            eval([QmatNMR.SeriesVarName '.DataFile = QmatNMR.SeriesName;']);

            %set the FID status in TD2 and TD1
            eval([QmatNMR.SeriesVarName '.FIDstatusTD2 = 1;']);
            eval([QmatNMR.SeriesVarName '.FIDstatusTD1 = 1;']);

            if (QTEMP20 == 0)		%ignore all imaginary parts
              if (QTEMP1(6) == 1)		%if asked for reverse the spectrum
                eval([QmatNMR.SeriesVarName '.Spectrum = flipud(' QmatNMR.SeriesVarName '.Spectrum);']);

              elseif (QTEMP1(6) == 2) 		%reverse and set status to FID
                eval([QmatNMR.SeriesVarName '.Spectrum = flipud(' QmatNMR.SeriesVarName '.Spectrum);']);
                eval([QmatNMR.SeriesVarName '.FIDstatusTD1 = 2;']);
              end

            elseif (QTEMP20 == 1)		%1D spectrum
              QTEMP21 = QmatNMR.SeriesName;
              QTEMP21(end-1:end) = '1i';
              eval([QmatNMR.SeriesVarName '.Spectrum = ' QmatNMR.SeriesVarName '.Spectrum + sqrt(-1)*readBrukerProcessedData(QTEMP21, QmatNMR.size1last, QmatNMR.size2last, QTEMP8, QTEMP9, QmatNMR.BrukerByteOrdering);']);

              if (QTEMP1(6) == 1)		%if asked for reverse the spectrum
                eval([QmatNMR.SeriesVarName '.Spectrum = flipud(' QmatNMR.SeriesVarName '.Spectrum);']);

              elseif (QTEMP1(6) == 2) 	%set status to FID
                eval([QmatNMR.SeriesVarName '.Spectrum = flipud(' QmatNMR.SeriesVarName '.Spectrum);']);
                eval([QmatNMR.SeriesVarName '.FIDstatusTD1 = 2;']);
              end

            elseif (QTEMP20 == 2) 	%2D spectrum with hypercomplex parts
              %then define the imaginary part and add that to the already-loaded real part
              QTEMP22 = QmatNMR.SeriesName;
              QTEMP22(end-2:end) = '2ir';
              eval([QmatNMR.SeriesVarName '.Spectrum = ' QmatNMR.SeriesVarName '.Spectrum + sqrt(-1)*readBrukerProcessedData(QTEMP22, QmatNMR.size1last, QmatNMR.size2last, QTEMP8, QTEMP9, QmatNMR.BrukerByteOrdering);']);

              %finally define the hypercomplex parts
              QTEMP21 = QmatNMR.SeriesName;
              QTEMP21(end-2:end) = '2ri';
              QTEMP22 = QmatNMR.SeriesName;
              QTEMP22(end-2:end) = '2ii';
              eval([QmatNMR.SeriesVarName '.Hypercomplex = readBrukerProcessedData(QTEMP21, QmatNMR.size1last, QmatNMR.size2last, QTEMP8, QTEMP9, QmatNMR.BrukerByteOrdering) + sqrt(-1)*readBrukerProcessedData(QTEMP22, QmatNMR.size1last, QmatNMR.size2last, QTEMP8, QTEMP9, QmatNMR.BrukerByteOrdering);']);

              %reverse spectrum is asked for
              if (QTEMP1(6) == 1)		%if asked for reverse the spectrum
                eval([QmatNMR.SeriesVarName '.Spectrum = flipud(' QmatNMR.SeriesVarName '.Spectrum);']);
                eval([QmatNMR.SeriesVarName '.Hypercomplex = flipud(' QmatNMR.SeriesVarName '.Hypercomplex);']);

              elseif (QTEMP1(6) == 2) 	%set status to FID
                eval([QmatNMR.SeriesVarName '.Spectrum = flipud(' QmatNMR.SeriesVarName '.Spectrum);']);
                eval([QmatNMR.SeriesVarName '.Hypercomplex = flipud(' QmatNMR.SeriesVarName '.Hypercomplex);']);
                eval([QmatNMR.SeriesVarName '.FIDstatusTD1 = 2;']);
              end

            elseif (QTEMP20 == 3) 	%2D spectrum without hypercomplex parts
              %then define the imaginary part and add that to the already-loaded real part
              QTEMP22 = QmatNMR.SeriesName;
              QTEMP22(end-2:end) = '2ii';
              eval([QmatNMR.SeriesVarName '.Spectrum = ' QmatNMR.SeriesVarName '.Spectrum + sqrt(-1)*readBrukerProcessedData(QTEMP22, QmatNMR.size1last, QmatNMR.size2last, QTEMP8, QTEMP9, QmatNMR.BrukerByteOrdering);']);

              %reverse spectrum is asked for
              if (QTEMP1(6) == 1)		%if asked for reverse the spectrum
                eval([QmatNMR.SeriesVarName '.Spectrum = flipud(' QmatNMR.SeriesVarName '.Spectrum);']);

              elseif (QTEMP1(6) == 2) 	%set status to FID
                eval([QmatNMR.SeriesVarName '.Spectrum = flipud(' QmatNMR.SeriesVarName '.Spectrum);']);
                eval([QmatNMR.SeriesVarName '.FIDstatusTD1 = 2;']);
              end
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


          disp(['Finished loading Bruker spectrum ', QmatNMR.SeriesName, '. (', num2str(QmatNMR.size1last), ' x ', num2str(QmatNMR.size2last), ' points).']);
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
    disp('Reading of Bruker Spectrum cancelled ...');
  end

  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
