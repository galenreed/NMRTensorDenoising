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
%
% matNMRReadBinaryFID
%
% syntax: MatrixOut = matNMRReadBinaryFID(FileName, SizeTD2, SizeTD1, DataFormat, StandardParameterFilesFLAG, ByteOrder)
%
% Reads a binary FID from disk. Various format are recognized and for some formats the
% standard parameter files may be read in as well so then only the file name is needed
% as input. If the standard parameter files must be read then the sizes are ignored but must
% still be given as input (e.g. use [])! <DataFormat> is an integer that specifies the
% following formats:
% 1 = Bruker XWinNMR / TopSpin
% 2 = Chemagnetics
% 3 = Bruker WinNMR
% 4 = Bruker UXNMR
% 5 = VNMR
% 6 = TecMag MacNMR
% 7 = TecMag NTNMR
% 8 = Aspect 2000/3000
% 9 = JEOL Generic
% 10= SMIS mrd
% 11= CMXW fid?d
%
% ByteOrder is needed if the standard parameter files are not used and specifies either 
% (1) big endian or (2) little endian byte ordering.
%
% MatrixOut is a matNMR structure if standard parameter files are read, or if the format itself
% provides parameter in the binary FID. If <StandardParameterFilesFLAG> is 0 then no parameter
% files are read, otherwise the routine looks in the same path as the file name specifies.
%
% Jacco van Beek
% 25-07-2004
%

function MatrixOut = matNMRReadBinaryFID(FileName, SizeTD2, SizeTD1, DataFormat, StandardParameterFilesFLAG, ByteOrder)

  %
  %First we separate the path name and the file name
  %
  QTEMP = findstr(FileName, filesep);		%extract the filename and path depending on the platform
  if (isempty(QTEMP))
    FileName = ['.' filesep FileName];
    QTEMP = findstr(FileName, filesep);		%extract the filename and path depending on the platform
  end
  QTEMP9 = length(QTEMP);
  QmatNMR.Xpath = deblank(FileName(1:QTEMP(QTEMP9)));				%the path
  QmatNMR.Xfilename = deblank(FileName((QTEMP(QTEMP9)+1):length(FileName)));	%the file name


  %
  %Then we look at the size in TD2
  %
  if isa(SizeTD2, 'char')
    QTEMP9 = length(SizeTD2);
    if ((SizeTD2(QTEMP9) == 'k') | (SizeTD2(QTEMP9) == 'K'))
      SizeTD2 = round(str2num(SizeTD2(1:(QTEMP9-1))) * 1024 );
    else
      SizeTD2 = round(str2num(SizeTD2));
    end
  end 

  
  %
  %Then we look at the size in TD1
  %
  if isa(SizeTD1, 'char')
    QTEMP9 = length(SizeTD1);
    if ((SizeTD1(QTEMP9) == 'k') | (SizeTD1(QTEMP9) == 'K'))
      SizeTD1 = round(str2num(SizeTD1(1:(QTEMP9-1))) * 1024 );
    else
      SizeTD1 = round(str2num(SizeTD1));
    end
  end
  

  %
  %Then we read in the standard parameter files, if asked for
  %
  QTEMP1 = [];	%this will contain the parameters if the user has asked for them to be read
  if StandardParameterFilesFLAG
    switch DataFormat		%define the output slightly different for each data format
    				%and if needed read in the parameter files
      case 1
        QTEMP2 = 'XWinNMR / TopSpin';
  
        if StandardParameterFilesFLAG
          [QTEMP1, SizeTD2, SizeTD1, ByteOrder] = QReadParameterFiles(DataFormat, QmatNMR.Xpath, QmatNMR.Xfilename);
  	
          if ~isempty(QTEMP1)	%parameters have been found
            MatrixOut = QTEMP1;
  
          else
            disp('matNMRReadBinaryFID ERROR: no or incorrect parameter files found. Reading of FID aborted.');
            return
          end
        end
    
      case 2
        QTEMP2 = 'Chemagnetics';
  
        if StandardParameterFilesFLAG
          [QTEMP1, SizeTD2, SizeTD1, ByteOrder] = QReadParameterFiles(DataFormat, QmatNMR.Xpath, QmatNMR.Xfilename);
  	
          if ~isempty(QTEMP1)	  %parameters have been found
            MatrixOut = QTEMP1;
  
          else
            disp('matNMRReadBinaryFID ERROR: no or incorrect parameter files found. Reading of FID aborted.');
            return
          end
        end
  
      case 3
        QTEMP2 = 'winNMR';
  
        if StandardParameterFilesFLAG
          [QTEMP1, SizeTD2, SizeTD1, ByteOrder] = QReadParameterFiles(1, QmatNMR.Xpath, QmatNMR.Xfilename);
  	
          if ~isempty(QTEMP1)	  %parameters have been found
            MatrixOut = QTEMP1;
  
          else
            disp('matNMRReadBinaryFID ERROR: no or incorrect parameter files found. Reading of FID aborted.');
            return
          end
        end
  
      case 4
        QTEMP2 = 'UXNMR';
  
        if StandardParameterFilesFLAG
          [QTEMP1, SizeTD2, SizeTD1, ByteOrder] = QReadParameterFiles(1, QmatNMR.Xpath, QmatNMR.Xfilename);
  	
          if ~isempty(QTEMP1)	  %parameters have been found
            MatrixOut = QTEMP1;
  
          else
            disp('matNMRReadBinaryFID ERROR: no or incorrect parameter files found. Reading of FID aborted.');
            return
          end
        end
  
      case 5
        QTEMP2 = 'VNMR';
  
        if StandardParameterFilesFLAG
          [QTEMP1, SizeTD2, SizeTD1, ByteOrder] = QReadParameterFiles(DataFormat, QmatNMR.Xpath, QmatNMR.Xfilename);
  	
          if ~isempty(QTEMP1)	  %parameters have been found
            MatrixOut = QTEMP1;
  
          else
            disp('matNMRReadBinaryFID ERROR: no or incorrect parameter files found. Reading of FID aborted.');
            return
          end
        end
  
      case 6
        QTEMP2 = 'MacNMR';
        MatrixOut = GenerateMatNMRStructure;
  
      case 7
        QTEMP2 = 'NTNMR';
  
      case 8
        QTEMP2 = 'Aspect 2000/3000';
  
  
      case 9
        QTEMP2 = 'JEOL Generic';
  
        if StandardParameterFilesFLAG
          [QTEMP1, SizeTD2, SizeTD1, ByteOrder] = QReadParameterFiles(DataFormat, QmatNMR.Xpath, QmatNMR.Xfilename);
  	
          if ~isempty(QTEMP1)	  %parameters have been found
            MatrixOut = QTEMP1;
  
          else
            disp('matNMRReadBinaryFID ERROR: no or incorrect parameter files found. Reading of FID aborted.');
            return
          end
        end

      case 10
        QTEMP2 = 'SMIS';


      case 11
        QTEMP2 = 'CMXW';

        if QmatNMR.ReadParameterFilesFlag
          [QTEMP1, SizeTD2, SizeTD1, ByteOrder] = QReadParameterFiles(QmatNMR.DataFormat, QmatNMR.Xpath, QmatNMR.Xfilename);
	
	  if ~isempty(QTEMP1)	%parameters have been found
	    MatrixOut = QTEMP1;

          else
	    disp('matNMR WARNING: no or incorrect parameter files found. Reading of FID aborted.');
	    return
          end
        end
  
  
      otherwise
        QTEMP2 = 'unknown file format';
    end
  else

    if (nargin ~= 6)
      beep
      disp('matNMR WARNING: Byte order parameter was not specified. Aborting ...');
      return
    end
    
    ByteOrder = round(ByteOrder);
    if ((ByteOrder  < 1) | (ByteOrder > 2))
      beep
      disp('matNMR WARNING: incorrect value for byte ordering. Must be 1 for big endian or 2 for little endian.');
      return
    end
  end


  %
  %Make sure of even domain size for TD2
  %
  if ((DataFormat == 1) | (DataFormat == 2) | (DataFormat == 3) | (DataFormat == 4) | (DataFormat == 9))
    if (SizeTD2 ~= 2*round(SizeTD2/2))
      beep
      disp('matNMR WARNING: only even numbers allowed for size in TD2 (implicit assumption of complex data). Aborting ...');
      return;
    end
  end


  %
  %Read the FID
  %
  if isempty(QTEMP1)		%the user has not asked for the parameter files to be read in, hence the output
  				%variable is not a structure, unless created by Qfidread
    [MatrixOut, SizeTD2, SizeTD1] = Qfidread(FileName, SizeTD2, SizeTD1, DataFormat, ByteOrder);

  else				%parameter files have been read and seem to be in order
    [QTEMP1, SizeTD2, SizeTD1] = Qfidread(FileName, SizeTD2, SizeTD1, DataFormat, ByteOrder);
    MatrixOut.Spectrum = QTEMP1;
  end
