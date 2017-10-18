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
% SIMPSONread.m
%
% syntax: variable = SIMPSONread('filename');
%
% uploads an fid file from disk in the SIMPSON ASCII format
% and stores it as a 2D matrix in the MATLAB workspace.
% The variable is a matNMR structure!
%
%
% Jacco van Beek
% 22-06-2000
%
%


function ret=SIMPSONread(FileName)

  fp = fopen(FileName, 'r', 'n');

  ReadLine = '';
  FID = 'FID';
  SPE = 'SPE';
  ASCII = 'ASCII';
  BINARY = 'BINARY';
  SINGLE = 'SINGLE';
  DOUBLE = 'DOUBLE';
  
  %
  %Set default format to ASCII as SIMPSON forgets to write this into its output files
  %for the ASCII format. For binary format this is written properly.
  %28-09-2001
  %
  FORMAT = ASCII;
  
  while ~strcmp(ReadLine, 'DATA')
    ReadLine = fscanf(fp, '%s', 1);
    
    if ~(strcmp(ReadLine, 'SIMP') | strcmp(ReadLine, 'DATA'))
      eval([ReadLine ';'])
    end  
  end  
  
  %
  %Up to now all parameters have been read and now we only need to read in the data
  %
  if ~exist('NI')
    NI = 1;
  end
  if ~exist('PREC')
    PREC = SINGLE;
  end
  if ~exist('FORMAT')
    FORMAT = ASCII;
  end

  if strcmp(FORMAT, ASCII)
    Array = fscanf(fp, '%f', NP*NI*2);

  else
    if strcmp(PREC, SINGLE)
      %Array = fread(fp, NP*NI*2, 'single');
      error('I don''t want to support this format. Please save in ASCII format from SIMPSON !');
      
    else
      %Array = fread(fp, NP*NI*2, 'double');
      error('This format doesn''t even exist yet (25-06-2000)!!! Please save in ASCII format from SIMPSON!');
    end  
  end
  fclose(fp);

  %
  %Now reorganize the data into a matrix that is recognized by matNMR
  %
  Array = reshape(Array, 2, length(Array)/2)';
  Spectrum = zeros(NI, NP);
  for tel1=1:NI
    tel2=1:NP;
    Spectrum(tel1, tel2) = (Array((tel1-1)*NP+tel2, 1) + sqrt(-1)*Array((tel1-1)*NP+tel2, 2))';
  end

  %
  %Now put everything in a matNMR structure
  %
  ret = GenerateMatNMRStructure;
  
  QTEMP1 = findstr(FileName, filesep)
  ret.DataPath = FileName(1:(QTEMP1(end)-1));
  ret.DataFile = FileName((QTEMP1(end)+1):end);
  
  ret.Spectrum = Spectrum;
  if exist('SW')
    ret.SweepWidthTD2 = SW/1000;
  end
  if exist('SW1')
    ret.SweepWidthTD1 = SW1/1000;
  end
  if exist('REF')
    ret.SpectralFrequencyTD2 = REF/1e6;
  end
  if exist('REF1')
    ret.SpectralFrequencyTD1 = REF1/1e6;
  end
  %set the carrier index for the default axis
  ret.DefaultAxisCarrierIndexTD2 = floor(NP/2)+1;
  ret.DefaultAxisCarrierIndexTD1 = floor(NI/2)+1;

  %
  %determine whether the data is an FID or a spectrum. FID is default!
  %
  if exist('TYPE')
    if strcmp(TYPE, SPE)
      ret.FIDstatusTD2 	= 1;	%spectrum
      ret.FIDstatusTD1 	= 1;
    else
      ret.FIDstatusTD2 	= 2;	%FID
      ret.FIDstatusTD1 	= 2;
    end
  end

  
  %
  %Produce some output comments and finish
  %
  if ~exist('SW1')
    SW1 = 0;
  end
  fprintf(['\nUploading of SIMPSON file "' FileName '" finished.\n']);
  fprintf(1, 'TD2=%d (complex) points, SW=%d kHz, TD1=%d (real) points, SW=%d kHz\n', NP, SW/1000, NI, SW1/1000);
