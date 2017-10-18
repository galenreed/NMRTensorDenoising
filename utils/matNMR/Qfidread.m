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
% Qfidread.m reads a binary file and extracts the FID/Spectrum
% 2-4-'97
% last updated 26-01-'06

%
% The data is expected to be saved in either the XWinNMR, UXNMR, Chemagnetics, WinNMR, 
% VNMR, MacNMR, NTNMR, JEOL, one of the Bruker Aspect formats, SMIS or CMXW
%

function [y, SizeTD2, SizeTD1] = Qfidread(fname, SizeTD2, SizeTD1, flag, ByteOrder);

%
%previously the Bruker buffer size was not taken into account. Hence this may not be needed anymore!
%
BufferSizeBruker = 256;
if (length(SizeTD2) == 2)
  SizeTD2inFile = SizeTD2(2);
  SizeTD2 = SizeTD2(1);

else
  SizeTD2inFile = ceil(SizeTD2/BufferSizeBruker)*BufferSizeBruker;
end


%
%Make sure of even domain size for TD2, except for certain data formats
%
if ((flag == 1) | (flag == 2) | (flag == 3) | (flag == 4) | (flag == 9) | (flag == 11))
  if (SizeTD2 ~= 2*round(SizeTD2/2))
    disp('matNMR WARNING: only even numbers allowed for size in TD2 (implicit assumption of complex data). Aborting ...');
    y = zeros(1, 2);
    SizeTD2 = 2;
    SizeTD1 = 1;

    return
  end
end

switch flag
  case 1		%Bruker XWinNMR and TopSpin formats
    if (ByteOrder == 2)
      id=fopen(fname, 'r', 'l');			%use little endian format if asked for
    else
      id=fopen(fname, 'r', 'b');			%use big endian format by default
    end
    a = zeros(SizeTD2*SizeTD1, 1);
    [a, count] = fread(id, SizeTD2inFile*SizeTD1, 'int32');
    RecombineFlag = 1;

  case 2
    id=fopen(fname, 'r', 'b');			%use big endian format and int32 for Chemagnetics
    a = zeros(SizeTD2*SizeTD1, 1);
    [a, count] = fread(id, SizeTD2*SizeTD1, 'int32');
    RecombineFlag = 2;

  case 3					%WinNMR format requires different byte swapping and machine format !!
    if (ByteOrder == 1)
      id=fopen(fname, 'r', 'b');		%use big endian format if asked for
    else
      id=fopen(fname, 'r', 'l');		%use little endian format by default
    end
    a = zeros(SizeTD2*SizeTD1, 1);
    [a, count] = fread(id, SizeTD2*SizeTD1, 'float');
    RecombineFlag = 1;
  
  case 4
    if (ByteOrder == 1)
      id=fopen(fname, 'r', 'b');		%use big endian format if asked for
    else
      id=fopen(fname, 'r', 'l');		%use little endian format by default
    end
    a = zeros(SizeTD2*SizeTD1, 1);
    [a, count] = fread(id, SizeTD2*SizeTD1, 'int32');
    RecombineFlag = 1;
  
  case 5
    RecombineFlag = 5;
    id=fopen(fname, 'r', 'b');			%use big endian format for VARIAN

						%read in the Varian header
    [a, count] = fread(id, 6, 'int32');
    nblocks = a(1);
    ntraces = a(2);
    np = a(3);
    ebytes = a(4);
    tbytes = a(5);
    bbytes = a(6);
    [a, count] = fread(id, 2, 'int16');
    vers_id = a(1);
    status = a(2);
    [a, count] = fread(id, 1, 'int32');
    nbheaders = a(1);
   
    SizeTD2 = np;
    SizeTD1 = nblocks*ntraces;
    a = zeros(nblocks*ntraces*np, 1);
  						%determine the actual binary format from the status bit
    BinaryStatus = fliplr(dec2bin(status));
    if ((BinaryStatus(3) == '0') & (BinaryStatus(4) == '0'))
      for QTEMP40=1:nblocks
        for QTEMP41=1:nbheaders
          fread(id, nbheaders*14, 'int16');			%read in the block headers (nbheaders*28 bytes)
        end 
        [b, count] = fread(id, ntraces*np, 'int16');  	%read in the actual data (ntraces*np)
        %
        %check whether data has the correct length, otherwise append zeros
        %
        if (length(b) ~= ntraces*np)
          b( (length(b)+1):ntraces*np ) = 0;
        end
       							%put the data in the vector
        a( ((QTEMP40-1)*np*ntraces+1) : QTEMP40*np*ntraces ) = b;
      end  
      
    elseif ((BinaryStatus(3) == '1') & (BinaryStatus(4) == '0'))
      for QTEMP40=1:nblocks
        for QTEMP41=1:nbheaders
          fread(id, nbheaders*14, 'int16');		%read in the block headers (nbheaders*28 bytes)
        end 
        [b, count] = fread(id, ntraces*np, 'int32');  	%read in the actual data (ntraces*np)
        %
        %check whether data has the correct length, otherwise append zeros
        %
        if (length(b) ~= ntraces*np)
          b( (length(b)+1):ntraces*np ) = 0;
        end
        							%put the data in the vector
        a( ((QTEMP40-1)*np*ntraces+1) : QTEMP40*np*ntraces ) = b;
      end  
      
    else  
      for QTEMP40=1:nblocks
        for QTEMP41=1:nbheaders
          fread(id, nbheaders*14, 'int16');		%read in the block headers (nbheaders*28 bytes)
        end 
        [b, count] = fread(id, ntraces*np, 'float');  	%read in the actual data (ntraces*np)
        %
        %check whether data has the correct length, otherwise append zeros
        %
        if (length(b) ~= ntraces*np)
          b( (length(b)+1):ntraces*np ) = 0;
        end
        							%put the data in the vector
        a( ((QTEMP40-1)*np*ntraces+1) : QTEMP40*np*ntraces ) = b;
      end  
    end  
  
  
  case 6
%
% A script for reading the file format for MacNMR was initially provided by 
% Amir Goldbourt from Israel (golda@wisemail.weizmann.ac.il). Afterwards I got the
% MacNMR file format from TecMag. Thanks!
%
% Jacco van Beek
% 12-06-2001
%
    y = GenerateMatNMRStructure;
    id=fopen(fname, 'r', 'b');                       %use big endian format for MacNMR
  
  
    %
    %The first 2048 bytes form the TecMag header. This does not contain much information
    %for matNMR so we skip most of it
    %
    Length = fread(id, 1, 'int32');
    fseek(id, 46, 0);                %the first 50 bytes are not important for matNMR
    SizeTD2 = 2*fread(id, 1, 'int32');
    fseek(id, 108, 0);               %the next 108 bytes are not important for matNMR
    y.SpectralFrequencyTD2 = fread(id, 1, 'float64');
    y.SweepWidthTD2 = fread(id, 1, 'float64')/1000;
    fseek(id, 1870, 0);              %the next 1870 bytes are not important for matNMR

    %
    %Now comes the data
    %
    [a, count] = fread(id, SizeTD2*Length, 'float32');
    
    
    %
    %Then we can extract the TD and dwell in TD1
    %
    fseek(id, 558, 0);
    SizeTD1 = fread(id, 1, 'int32');
    
    if (Length ~= SizeTD1)
      error('MacNMR FID has more than 2 dimensions! Aborting ...');
      return
    end
    
    y.SweepWidthTD1 = 1/fread(id, 1, 'float64')/1000;
    fseek(id, 464, 0);
    y.SpectralFrequencyTD1 = fread(id, 1, 'float64')/1000;
  
    y.FIDstatusTD2 = 2;                              %set it to be an FID by default
    y.FIDstatusTD1 = 2;                              %set it to be an FID by default
    
    %
    %The rest we don't need for matNMR
    %
    RecombineFlag = 6;


  case 7
%
% The NTNMR file format was supplied by TecMag. Thanks!
%
% Jacco van Beek
% 12-06-2001
%
    y = GenerateMatNMRStructure;
    id=fopen(fname, 'r', 'l');			%use little endian format for NTNMR
  
    %
    %then there is information about the FID/Spectrum that we can use
    %
    fseek(id, 16, 0);				%jump to the size of the TecMag structure
    TecMagStructureSize = fread(id, 1, 'int32');	%this is usually 1024!
    
  %
  %Now that we know the size of the TecMag structure we can extract the information we need
  %
    %extract the nr. of points for each dimension
    SizeTD2 = 2*fread(id, 1, 'int32');
    SizeTD1 = fread(id, 1, 'int32');
  
    %extract the frequencies for each dimension
    fseek(id, 76, 0);
    y.SpectralFrequencyTD2 = fread(id, 1, 'float64');
    y.SpectralFrequencyTD1 = fread(id, 1, 'float64');
  
    
    %extract the sweepwidths for each dimension
    fseek(id, 140, 0);
    y.SweepWidthTD2 = fread(id, 1, 'float64')/1e3;
    y.SweepWidthTD1 = fread(id, 1, 'float64')/1e3;
    fseek(id, 780, 0);
  
    y.FIDstatusTD2 = 2;				%set it to be an FID by default
    y.FIDstatusTD1 = 2;				%set it to be an FID by default
  
    %
    %Now comes the data
    %
    a = zeros(SizeTD2*SizeTD1, 1);
    [a, count] = fread(id, SizeTD2*SizeTD1, 'float32');
    
    
    %
    %As we don't need anything from the TecMag2 structure we skip it
    %
    RecombineFlag = 6;


  case 8				%Bruker Aspect 2000/3000 format
%
%the format description was given to me by Juan Carlos Cobas from the Mest-Re team. Thanks!
%
    y = GenerateMatNMRStructure;		%output variable
    id=fopen(fname, 'r', 'b');			%use big endian format JEOL
  
    QTEMP1 = dir(fname);			%first we determine the total file size and from that
    QTEMP1 = QTEMP1.bytes;			%we obtain the total number of uchar bits.
  
    [a, count] = fread(id, QTEMP1, 'uchar');	%read in all the unsigned chars

    StrangeOffset=0;
    ByteSwap = DetermineByteSwap(a(StrangeOffset+(1:3)).');	%determine the byteswap
    %
    %It seems that in some Aspect files there is a 12-byte header on top of the normal
    %768 byte header. In case the first 3 bytes are NOT coding for a known byteswap then
    %I assume the next position for this information to be 12 bytes down.
    %
    if (ByteSwap == 99)
      StrangeOffset=12;
      ByteSwap = DetermineByteSwap(a(StrangeOffset+(1:3)).');	%determine the byteswap
    end
    if (ByteSwap == 99)
      error('matNMR ERROR: unsupported byte swap in the Bruker Aspect file. Please contact the author of matNMR!')
    end
    
    						%determine the few useful parameters in the file
    SizeTD2 = Aspect3BitTo4(a(StrangeOffset+(121:123)).', ByteSwap);%This is ASIZE, which may be different from TD
    HeaderSizeWords = 256;			%unfortunaStrangeOffsety there seem to be two different header sizes
    SizeTD1 = floor((QTEMP1-HeaderSizeWords)/3/SizeTD2);%going around (256 and 512 words). By first assuming a 256 word
    						%header and then deducing it afterwards from SizeTD2, SizeTD1 and
  						%the actual file size we avoid any problems.
    						%the few parameters that we extract are probably the same in all formats.
    
    SizeTD2 = Aspect3BitTo4(a(StrangeOffset+(130:132)).', ByteSwap);%This is TD, the real number of points I want to load per 1D spectrum
  
    y.SweepWidthTD2 = AspectFloat(a(StrangeOffset+(160:165)).');	%SWH
  
    SF = AspectFloat(a(StrangeOffset+(232:237)).');		%SF
    O1 = AspectFloat(a(StrangeOffset+(172:177)).');		%O1
    y.SpectralFrequencyTD2 = SF + O1/1e6;		%SFO1
  
    y.FIDstatusTD2 = 2;				%set it to be an FID by default
    y.FIDstatusTD1 = 2;				%set it to be an FID by default
    
  %
  % TrueHeaderSizeBytes = 768;			%determine the header size from the file size, SizeTD2 and SizeTD1
  % Even for a 512 byte header (DISNMR, DISMSL, etc) the data starts after
  % 256 words. The rest is appended at the end of the file
  %
    a = reshape(a(StrangeOffset+768+(1:3*SizeTD2*SizeTD1)), 3, SizeTD2*SizeTD1).';%reshape the data part and convert into signed integers
    a = Aspect3BitTo4(a, ByteSwap);
  
    RecombineFlag = 8;


  case 9
%
%JEOL Generic format
%
    id=fopen(fname, 'r', 'b');			%use big endian format and float for JEOL Generic format
    a = zeros(SizeTD2*SizeTD1, 1);
    [a, count] = fread(id, SizeTD2*SizeTD1, 'float64');
    RecombineFlag = 1;


  case 10
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
    RecombineFlag = 10;

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


  case 11
    id=fopen(fname, 'r', 'b');			%use big endian format and int32 for CMXW
    a = zeros(SizeTD2*SizeTD1, 1);
    [a, count] = fread(id, SizeTD2*SizeTD1, 'int32');
    RecombineFlag = 11;


  case 12
    id=fopen(fname, 'r', 'b');			%generic format: big endian, 241 bits header, double, RRII
    a = zeros(SizeTD2*SizeTD1, 1);
    fseek(id, 241, -1);
    [a, count] = fread(id, SizeTD2*SizeTD1, 'double');
    RecombineFlag = 12;

end;  
fclose(id);






%
%
% Now recombine the data into complex vectors or matrices
%
%
switch RecombineFlag
						%create a complexe fid from the real values in variable a.  
  case 1					%Bruker format / WinNMR / UXNMR format / JEOL
%
% Bruker format (data_2_: = FID for 2nd experiment in TD1, stored as RIRIRIRIRIRI)
%
%  data_1_:
%  data_2_:
%  data_3_:
%  data_4_:
%
    y = zeros(SizeTD1, SizeTD2/2);
    for tel=1:SizeTD1
      y(tel, 1:(SizeTD2/2)) = (a((tel-1)*SizeTD2inFile + (1 : 2 : SizeTD2-1)) + sqrt(-1)*a((tel-1)*SizeTD2inFile + (2 : 2 : SizeTD2))).';
    end

  case 2 					%Chemagnetics format
%
% Chemagnetics format (data_2_: = FID for 2nd experiment in TD1)
%
%  (real data_1_:)
%  (real data_2_:)
%  (real data_3_:)
%  (real data_4_:)
%
%  (imag data_1_:)
%  (imag data_2_:)
%  (imag data_3_:)
%  (imag data_4_:)
%
    y = zeros(SizeTD1, SizeTD2/2);
    for tel=1:SizeTD1
      y(tel, 1:(SizeTD2/2)) = (a( ((tel-1)*SizeTD2/2 + 1) : ((tel)*SizeTD2/2)) + sqrt(-1)*a( ((tel-1)*SizeTD2/2 + SizeTD1*SizeTD2/2 + 1) : ((tel)*SizeTD2/2 + SizeTD1*SizeTD2/2)) ).';
    end; 

  case 5					%Varian VNMR format
%
% VNMR format (data_2_: = FID for 2nd experiment in TD1, stored as RIRIRIRIRIRI)
%
%  data_1_:
%  data_2_:
%  data_3_:
%  data_4_:
%
    y = zeros(SizeTD1, SizeTD2/2);
    for tel=1:SizeTD1
      %note that for VNMR we perform a transpose AND complex conjugate to obtain the right direction for the spectra
      y(tel, 1:(SizeTD2/2)) = (a((tel-1)*SizeTD2 + 1 : 2 : tel*SizeTD2-1) + sqrt(-1)*a((tel-1)*SizeTD2 + 2 : 2 : tel*SizeTD2))';
    end; 

  case 6					%TecMag formats (NTNMR and MacNMR) --> output in a matNMR structure!!!
%
% TecMag format (data_2_: = FID for 2nd experiment in TD1, stored as RIRIRIRIRIRI)
%
%  data_1_:
%  data_2_:
%  data_3_:
%  data_4_:
%
    y.Spectrum = zeros(SizeTD1, SizeTD2/2);
    for tel=1:SizeTD1
      y.Spectrum(tel, 1:(SizeTD2/2)) = (a((tel-1)*SizeTD2 + 1 : 2 : tel*SizeTD2-1) + sqrt(-1)*a((tel-1)*SizeTD2 + 2 : 2 : tel*SizeTD2)).';
    end; 

  case 8					%Aspect format --> output in a matNMR structure!!!
%
% Bruker Aspect format (data_2_: = FID for 2nd experiment in TD1, stored as RIRIRIRIRIRI)
%
%  data_1_:
%  data_2_:
%  data_3_:
%  data_4_:
%
    y.Spectrum = zeros(SizeTD1, SizeTD2/2);
    for tel=1:SizeTD1
      y.Spectrum(tel, 1:(SizeTD2/2)) = (a((tel-1)*SizeTD2 + 1 : 2 : tel*SizeTD2-1) + sqrt(-1)*a((tel-1)*SizeTD2 + 2 : 2 : tel*SizeTD2)).';
    end

  case 10					%SMIS format
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

  case 11 					%CMXW format
%
% CMXW format (data_2_: = FID for 2nd experiment in TD1)
%
%  (real data_1_:) (imag data_1_:)
%  (real data_2_:) (imag data_2_:)
%  (real data_3_:) (imag data_3_:)
%  (real data_4_:) (imag data_4_:)
%
    y = zeros(SizeTD1, SizeTD2/2);
    for tel=1:SizeTD1
      y(tel, 1:(SizeTD2/2)) = (a( ((tel-1)*SizeTD2 + 1) : ((tel-1)*SizeTD2 + SizeTD2/2) ) + sqrt(-1)*a( ((tel-1)*SizeTD2 + SizeTD2/2 + 1) : (tel*SizeTD2) ) ).';
    end; 

  case 12 					%Generic 1 format
%
% Bruker format (data_2_: = FID for 2nd experiment in TD1, stored as RIRIRIRIRIRI)
%
%  data_1_:
%  data_2_:
%  data_3_:
%  data_4_:
%
    y = zeros(SizeTD1, SizeTD2/2);
    for tel=1:SizeTD1
      y(tel, 1:(SizeTD2/2)) = (a((tel-1)*SizeTD2inFile + (1 : 2 : SizeTD2-1)) + sqrt(-1)*a((tel-1)*SizeTD2inFile + (2 : 2 : SizeTD2))).';
    end

  otherwise
    disp('matNMR ERROR: wrong format flag set in Qfidread.m');

end




























































%
%
% Private functions used for the Bruker Aspect format
%
%

%
% AspectFloat(Variable)
%
% converts 6 uchar bits from the Bruker Aspect format into a float. Variable can be any
% array of size (x, 6).
%
% Jacco van Beek
% 19-03-'03
%

function ret = AspectFloat(Variable)

%
%constants needed for the conversion to real floats
%
c1 =         128;
c2 =       32768;
c3 =     8388608;
c5 =   268435456;
c6 = 68719476736;

expo = bitshift(Variable(:, 4), 3) + bitshift(Variable(:, 5), -5);
QTEMP = find(expo>1023);
expo(QTEMP) = expo(QTEMP) - 2048;

power = 2.^expo;

mantissa = Variable(:, 1)/c1 + Variable(:, 2)/c2 + Variable(:, 3)/c3 + bitand(Variable(:, 4), 63)/c5 + Variable(:, 6)/c6;
QTEMP = find(mantissa > 1);
mantissa(QTEMP) = mantissa(QTEMP) - 2;

ret = mantissa .* power;



%
% Aspect3BitTo4(Variable, ByteSwap)
%
% This function converts the (x, 3) sized variable to a 24-bit integer word
% for each row of the variable. Each row thus should contain 3 uchar bits
% from the Bruker Aspect file format.
%
% ByteSwap is a flag that corresponds to big endian if it is set to 0
% and to little endian if it set to 1
%
% Jacco van Beek
% 19-03-'03
%

function ret = Aspect3BitTo4(Variable, ByteSwap)

if (nargin == 1)
  ByteSwap = 0;
end

if (ByteSwap)		%little endian
  ret =  bitshift(Variable(:, 1), 8) + bitshift(Variable(:,2), 16) + bitshift(Variable(:,3), 24);
  QTEMP = find(ret >= 2^31);
  ret(QTEMP) = ret(QTEMP) - 2^32;

else			%big endian
  ret =  bitshift(Variable(:, 1), 16) + bitshift(Variable(:,2), 8) + Variable(:,3);
  QTEMP = find(ret >= 2^23);
  ret(QTEMP) = ret(QTEMP) - 2^24;
end


%
% DetermineByteSwap(Variable)
%
% This function determines the byte swap of the Aspect file by looking at the first
% three bytes of the binary file. By making them into a 32 bit integer and checking
% the value, the byte swap can be determined. The variable ret is then set to
% the appropriate flag:
% 
%    result          -->         ret
%
%   4687093                       0        = Normal unswapped mode (big endian)
%   -687033                       1        = byte-swapped mode (little endian)
%
% Jacco van Beek
% 19-03-'03
%

function ret = DetermineByteSwap(Variable)

result = Aspect3BitTo4(Variable);
if (result == 4687093)
  ret = 0;

elseif (result == -687033)
  ret = 1;
  
else
  ret = 99;
end
