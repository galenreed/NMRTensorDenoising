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
% QimportMRI.m reads MRI data files and extracts the FID/Spectrum
% 27-01-'10

%
% The data is expected to be saved in SMIS, Siemens RDA or Siemens RAW format
%

function [y, SizeTD2, SizeTD1] = QimportMRI(fname, SizeTD2, SizeTD1, flag, ByteOrder);


%some default value
id = 0;

y = zeros(SizeTD1, SizeTD2/2);
switch flag
  case 1
%
% The SMIS file format was found in the SMIS manual
%
% Jacco van Beek
% 29-06-2005
%
    y = GenerateMatNMRStructure;
    id=fopen(fname, 'r', 'l');			%use little endian format for SMIS

  %
  %Now that we know the size of the TecMag structure we can extract the information we need
  %
    %extract the nr. of points for each dimension
    SizeTD2 = fread(id, 1, 'int32');
    SizeTD1 = fread(id, 1, 'int32');
    SizeTD3 = fread(id, 1, 'int32');
    SizeTD4 = fread(id, 1, 'int32');
    if ((SizeTD3 > 1) | (SizeTD4 > 1))
      error('matNMR NOTICE: binary FID with more than two dimensions encountered in SMIS data file. Aborting ...');
    end

    %extract the data type code
    fseek(id, 2, 0);
    Datatype = str2num(dec2hex(fread(id, 1, 'int16')));
    if (Datatype > 10)		%is this a complex dataset?
      ComplexFlag = 1;
      SizeTD2 = SizeTD2*2;
      Datatype = Datatype - 10;

    else			%real dataset

      ComplexFlag = 0;
    end
    RecombineFlag = 1;

    %determine datatype
    switch Datatype
      case 0
        DataFormat = 'uchar';

      case 1
        DataFormat = 'schar';

      case 2
        DataFormat = 'int16';

      case 3
        DataFormat = 'int16';

      case 4
        DataFormat = 'int32';

      case 5
        DataFormat = 'float32';

      case 6
        DataFormat = 'double';

      otherwise
        error('matNMR ERROR: unknown dataformat encountered in SMIS binary FID. Aborting ...');
    end

    %skip to the data part
    fseek(id, 492, 0);

    y.FIDstatusTD2 = 2;				%set it to be an FID by default
    y.FIDstatusTD1 = 2;				%set it to be an FID by default

    %
    %Now comes the data
    %
    a = zeros(SizeTD2*SizeTD1, 1);
    [a, count] = fread(id, SizeTD2*SizeTD1, DataFormat);


  case 2
    %
    % Read spectroscopy data from Siemens machine
    %
    % Read a .rda file
    %
    %
    id = fopen(fname, 'r', 'ieee-le');
    RecombineFlag = 2;

    head_start_text = '>>> Begin of header <<<';
    head_end_text   = '>>> End of header <<<';

    tline = fgets(id);

    while (isempty(strfind(tline , head_end_text)))
      tline = fgets(id);

      if ( isempty(strfind (tline , head_start_text)) + isempty(strfind (tline , head_end_text )) == 2)
        % Store this data in the appropriate format
        occurence_of_colon = findstr(':',tline);
        variable = tline(1:occurence_of_colon-1) ;
        value    = tline(occurence_of_colon+1 : length(tline)) ;

        switch variable
        case { 'PatientID' , 'PatientName' , 'StudyDescription' , 'PatientBirthDate' , 'StudyDate' , 'StudyTime' , 'PatientAge' , 'SeriesDate' , ...
                    'SeriesTime' , 'SeriesDescription' , 'ProtocolName' , 'PatientPosition' , 'ModelName' , 'StationName' , 'InstitutionName' , ...
                    'DeviceSerialNumber', 'InstanceDate' , 'InstanceTime' , 'InstanceComments' , 'SequenceName' , 'SequenceDescription' , 'Nucleus' ,...
                    'TransmitCoil' }
            eval(['rda.' , variable , ' = value; ']);
        case { 'PatientSex' }
            % Sex converter! (int to M,F,U)
            switch value
            case 0
                rda.sex = 'Unknown';
            case 1
                rda.sex = 'Male';
            case 2

                rda.sex = 'Female';
            end

        case {  'SeriesNumber' , 'InstanceNumber' , 'AcquisitionNumber' , 'NumOfPhaseEncodingSteps' , 'NumberOfRows' , 'NumberOfColumns' , 'VectorSize' }
            %Integers
            eval(['rda.' , variable , ' = str2num(value); ']);
        case { 'PatientWeight' , 'TR' , 'TE' , 'TM' , 'DwellTime' , 'NumberOfAverages' , 'MRFrequency' , 'MagneticFieldStrength' , 'FlipAngle' , ...
                     'SliceThickness' ,  'FoVHeight' , 'FoVWidth' , 'PercentOfRectFoV' , 'PixelSpacingRow' , 'PixelSpacingCol'}
            %Floats
            eval(['rda.' , variable , ' = str2num(value); ']);
        case {'SoftwareVersion[0]' }
            rda.software_version = value;
        case {'CSIMatrixSize[0]' }
            rda.CSIMatrix_Size(1) = str2num(value);
        case {'CSIMatrixSize[1]' }
            rda.CSIMatrix_Size(2) = str2num(value);
        case {'CSIMatrixSize[2]' }
            rda.CSIMatrix_Size(3) = str2num(value);
        case {'PositionVector[0]' }
            rda.PositionVector(1) = str2num(value);
        case {'PositionVector[1]' }
            rda.PositionVector(2) = str2num(value);
        case {'PositionVector[2]' }
            rda.PositionVector(3) = str2num(value);
        case {'RowVector[0]' }
            rda.RowVector(1) = str2num(value);
        case {'RowVector[1]' }
            rda.RowVector(2) = str2num(value);
        case {'RowVector[2]' }
            rda.RowVector(3) = str2num(value);
        case {'ColumnVector[0]' }
            rda.ColumnVector(1) = str2num(value);
        case {'ColumnVector[1]' }
            rda.ColumnVector(2) = str2num(value);
        case {'ColumnVector[2]' }
            rda.ColumnVector(3) = str2num(value);

        otherwise
            % We don't know what this variable is.  Report this just to keep things clear
            disp(['matNMR WARNING: ignoring variable ' , variable ]);
        end
      else
          % Don't bother storing this bit of the output
      end
    end

    %
    % So now we should have got to the point after the header text
    %
    % Siemens documentation suggests that the data should be in a double complex format (8bytes for real, and 8 for imaginary?)
    %
    a = fread(id, rda.CSIMatrix_Size(1) * rda.CSIMatrix_Size(1) *rda.CSIMatrix_Size(1) *rda.VectorSize * 2 , 'double');


  case 3
    %
    % Read spectroscopy data from Siemens machine
    %
    % Read a .raw file
    %
    %
    id = fopen(fname, 'r', 'ieee-le');
    RecombineFlag = 3;

    a = fread(id, SizeTD2 * SizeTD1 * 2 , 'single');


  case 4
    %
    % Read DICOM data using the Matlab routines from the image processing routines
    %
    % Read a .dcm file
    %
    %
    if (exist('dicominfo') == 2)
      info = dicominfo(fname);
      RecombineFlag = 4;

    else
      beep
      disp('matNMR NOTICE: cannot find the dicominfo routine (Matlab image processing toolbox). Aborting ...');
      return
    end
  end

%close if something has been opened
if (id)
  fclose(id);
end






%
%
% Now recombine the data into complex vectors or matrices
%
%
switch RecombineFlag
  case 1					%SMIS format
%
% SMIS format (data_2_: = FID for 2nd experiment in TD1, stored as RIRIRIRIRIRI)
%
%  data_1_:
%  data_2_:
%  data_3_:
%  data_4_:
%
    if (ComplexFlag == 1) 			%complex dataset
      for tel=1:SizeTD1
        y.Spectrum(tel, 1:(SizeTD2/2)) = (a((tel-1)*SizeTD2 + 1 : 2 : tel*SizeTD2-1) + sqrt(-1)*a((tel-1)*SizeTD2 + 2 : 2 : tel*SizeTD2)).';
      end
    else 					%real dataset
      for tel=1:SizeTD1
        y.Spectrum(tel, 1:(SizeTD2)) = a((tel-1)*SizeTD2+1:tel*SizeTD2);
      end
      SizeTD2 = SizeTD2*2; 			%fake size as it would be for a complex dataset, for correct display in regelQfidread
    end

  case 2 					%Siemens RDA format
    y = GenerateMatNMRStructure;

    %Reshape so that we can get the real and imaginary separated
    a = reshape(a,  2, rda.VectorSize, rda.CSIMatrix_Size(1),  rda.CSIMatrix_Size(2),  rda.CSIMatrix_Size(3) );

    %Combine the real and imaginary into the complex matrix
    y.Spectrum = squeeze(complex(a(1,:,:,:,:), a(2,:,:,:,:)));

    %Shift the FID to the last dimension in the matrix
    if (ndims(y.Spectrum) > 2)
      y.Spectrum = shiftdim(y.Spectrum, 1);
    end

    y.SizeTD2 = rda.VectorSize;
    SizeTD2 = rda.VectorSize*2;

    y.SizeTD1 = rda.CSIMatrix_Size(1);
    SizeTD1 = rda.CSIMatrix_Size(1);

    y.MRIparameters = rda;
    y.SpectralFrequencyTD2 = y.MRIparameters.MRFrequency;
    y.SweepWidthTD2 = 1000 / y.MRIparameters.DwellTime;

  case 3 					%Siemens RAW format
    %Reshape so that we can get the real and imaginary separated
    y = reshape(a,  2, rda.VectorSize, rda.CSIMatrix_Size(1),  rda.CSIMatrix_Size(2),  rda.CSIMatrix_Size(3) );

    %Combine the real and imaginary into the complex matrix
    y = squeeze(complex(y(1,:,:,:,:), y(2,:,:,:,:)));

    %Shift the FID to the last dimension in the matrix
    y = shiftdim(y, 1);

  case 4 					%DICOM format
    y = GenerateMatNMRStructure;

    %Reshape so that we can get the real and imaginary separated
    y.Spectrum = reshape(info.SpectroscopyData, 2, info.DataPointColumns, info.DataPointRows); 

    %Combine the real and imaginary into the complex matrix
    y.Spectrum = squeeze(complex(y.Spectrum(1,:,:,:,:), -y.Spectrum(2,:,:,:,:)));

    y.SizeTD2 = info.DataPointColumns;
    SizeTD2 = info.DataPointColumns*2;

    y.SizeTD1 = info.DataPointRows;
    SizeTD1 = info.DataPointRows;

    y.MRIparameters = info;
    y.SpectralFrequencyTD2 = info.TransmitterFrequency;
    y.SweepWidthTD2 = info.SpectralWidth/1000;


  otherwise
    disp('matNMR ERROR: wrong format flag set in Qfidread.m');

end
