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
%DetermineBrukerSpectraRead reads in a Bruker procs and proc2s file and tries to determine
%how many points are in the processed spectrum, 
%    
%02-09-'04

function Output = DetermineBrukerSpectraRead(DirectoryName)

  NrPointsToShift  = [];
  
  %read in the procs file
  QTEMP1 = ReadParameterFile([DirectoryName filesep 'procs']);
  
  %extract the size, xdim and byte ordering parameters
  eval([QTEMP1(strmatch('SI=', QTEMP1), :) ';']);
  Output(1) = SI;

  eval([QTEMP1(strmatch('XDIM=', QTEMP1), :) ';']);
  Output(3) = XDIM;

  eval([QTEMP1(strmatch('BYTORDP=', QTEMP1), :) ';']);
  Output(5) = ~BYTORDP + 1;	%construction ensures that little endian = 2 and big endian = 1
  				%which is used in the corresponding input windows
  
  %read in the proc2s file
  if exist([DirectoryName filesep 'proc2s'], 'file')
    QTEMP1 = ReadParameterFile([DirectoryName filesep 'proc2s']);
  
    %extract the size, xdim and byte ordering parameters
    eval([QTEMP1(strmatch('SI=', QTEMP1), :) ';']);
    Output(2) = SI;

    eval([QTEMP1(strmatch('XDIM=', QTEMP1), :) ';']);
    Output(4) = XDIM;

    no = 0;		%check whether we need to reverse the spectrum in TD1.
    yes = 1;		%if FT_mod=0 (no FT done) then we always reverse the spectrum
    			%else we check the REVERSE parameter
    eval([QTEMP1(strmatch('REVERSE=', QTEMP1), :) ';']);
    eval([QTEMP1(strmatch('FT_mod=', QTEMP1), :) ';']);
    if (FT_mod == 0)
      Output(6) = 2;
    else
      Output(6) = REVERSE;
    end

  else			%proc2s doesn't exist and so we assume we're dealing with a 1D spectrum
    Output(2) = 1;
    Output(4) = 1;
    Output(6) = 0;
  end

  
  %finally we check to see if we can find the acqus and acqu2s files two directories below
  %to extract the spectral frequency and spectral width
  if exist([DirectoryName filesep '..' filesep '..' filesep 'acqus'], 'file')
    QTEMP1 = ReadParameterFile([DirectoryName filesep '..' filesep '..' filesep 'acqus']);

			      %locate spectrometer frequency of TD2
    eval([QTEMP1(strmatch('SFO1='  , QTEMP1), :) ';']);
    Output(7) = SFO1;

			      %locate sweepwidth in TD2
    eval([QTEMP1(strmatch('SW='  , QTEMP1), :) ';']);
    Output(8) = SW*SFO1/1000;
    
    if exist([DirectoryName filesep '..' filesep '..' filesep 'acqu2s'], 'file')
      QTEMP1 = ReadParameterFile([DirectoryName filesep '..' filesep '..' filesep 'acqu2s']);
  
  			      %locate spectrometer frequency of TD2
      eval([QTEMP1(strmatch('SFO1='  , QTEMP1), :) ';']);
      Output(9) = SFO1;
  
  			      %locate sweepwidth in TD2
      eval([QTEMP1(strmatch('SW_h='  , QTEMP1), :) ';']);
      Output(10) = SW*SFO1/1000;
    end
  end
