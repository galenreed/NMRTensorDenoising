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
% matNMRReadBrukerSpectra
%
% syntax: MatrixOut = matNMRReadBrukerSpectra(FileName)
%
% OR
%
% syntax: MatrixOut = matNMRReadBrukerSpectra(FileName, SizeTD2, SizeTD1, BlockingFactorTD2, BlockingFactorTD1, ByteOrdering)
%
%
% Reads a Bruker processed spectrum from disk. If standard parameter files are available then
% only the file name is needed. All other parameters will be read from the parameter files.
%
% Jacco van Beek
% 25-07-2004
%

function MatrixOut = matNMRReadBrukerSpectra(FileName, SizeTD2, SizeTD1, BlockingFactorTD2, BlockingFactorTD1, ByteOrdering)

  %
  %First we separate the path name and the file name
  %
  QTEMP = findstr(FileName, filesep);		%extract the filename and path depending on the platform
  if (isempty(QTEMP))
    QmatNMR.Xpath = '.';			%use current directory if no filesep is found
    QmatNMR.Xfilename = deblank(FileName);	%the file name
  else
    QmatNMR.Xpath = deblank(FileName(1:QTEMP(end)));		%the path
    QmatNMR.Xfilename = deblank(FileName((QTEMP(end)+1):end));	%the file name
  end

  if (nargin == 1)
    QTEMP1 = DetermineBrukerSpectraRead(QmatNMR.Xpath);
    SizeTD2 = QTEMP1(1);
    SizeTD1 = QTEMP1(2);
    BlockingFactorTD2 = QTEMP1(3);
    %
    %If no blocking is specified then the full size will be taken
    %
    if (BlockingFactorTD2 == 0)
      BlockingFactorTD2 = SizeTD2;
    end

    BlockingFactorTD1 = QTEMP1(4);
    %
    %If no blocking is specified then the full size will be taken
    %
    if (BlockingFactorTD1 == 0)
      BlockingFactorTD1 = SizeTD1;
    end
    ByteOrdering = QTEMP1(5);

  else
    %
    %Size TD2
    %
    if isa(SizeTD2, 'char')
      if ((SizeTD2(end) == 'k') | (SizeTD2(end) == 'K'))
        SizeTD2 = round( str2num(SizeTD2(1:(end-1))) * 1024 );
      else
        SizeTD2 = round(str2num(SizeTD2));
      end
    end


    %
    %Size TD1
    %
    if isa(SizeTD1, 'char')
      if ((SizeTD1(end) == 'k') | (SizeTD1(end) == 'K'))
        SizeTD1 = round( str2num(SizeTD1(1:(end-1))) * 1024 );
      else
        SizeTD1 = round(str2num(SizeTD1));
      end
    end  


    %
    %Blocking Factor TD2
    %
    if isa(BlockingFactorTD2, 'char')
      if ((BlockingFactorTD2(end) == 'k') | (BlockingFactorTD2(end) == 'K'))
        BlockingFactorTD2 = round( str2num(BlockingFactorTD2(1:(end-1))) * 1024 );
      else
        BlockingFactorTD2 = round(str2num(BlockingFactorTD2));
      end
    end
    %
    %If no blocking is specified then the full size will be taken
    %
    if (BlockingFactorTD2 == 0)
      BlockingFactorTD2 = SizeTD2;
    end
    

    %
    %Blocking Factor TD1
    %
    if isa(BlockingFactorTD1, 'char')
      if ((BlockingFactorTD1(end) == 'k') | (BlockingFactorTD1(end) == 'K'))
        BlockingFactorTD1 = round( str2num(BlockingFactorTD1(1:(end-1))) * 1024 );
      else
        BlockingFactorTD1 = round(str2num(BlockingFactorTD1));
      end
    end  
    %
    %If no blocking is specified then the full size will be taken
    %
    if (BlockingFactorTD1 == 0)
      BlockingFactorTD1 = SizeTD1;
    end
  end


  %
  %Read the processed spectrum
  %
  MatrixOut = readBrukerProcessedData(FileName, SizeTD2, SizeTD1, BlockingFactorTD2, BlockingFactorTD1, ByteOrdering);








