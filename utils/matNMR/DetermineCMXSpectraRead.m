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
%DetermineCMXSpectraRead reads in a Bruker procs and proc2s file and tries to determine
%how many points are in the processed spectrum, 
%    
%23-05-'05

function Output = DetermineCMXSpectraRead(DirectoryName)

  NrPointsToShift  = [];
  
  %read in the procs file
  QTEMP1 = ReadParameterFile([DirectoryName filesep 'proc']);
  
  %extract the size for TD2
  eval([QTEMP1(strmatch('current_size1=', QTEMP1), :) ';']);
  Output(1) = current_size1*2;

  %extract the size for TD1
  eval([QTEMP1(strmatch('current_size2=', QTEMP1), :) ';']);
  if exist('current_size2')	%in case of a 1D dataset
    Output(2) = current_size2;

    %has TD1 been FT'd yet?
    eval([QTEMP1(strmatch('domain2=', QTEMP1), :) ';']);
    Output(3) = domain2;

  else
    Output(2) = 1;
    Output(3) = 0;
  end

  %finally we check to see if we can find the acq and acq_2 files two directories below
  %to extract the spectral frequency and spectral width
  if exist([DirectoryName filesep 'acq'], 'file')
    QTEMP1 = ReadParameterFile([DirectoryName filesep 'acq']);

                             %locate spectrometer frequency of TD2
    eval([QTEMP1(strmatch('ch1='  , QTEMP1), :) ';']);
    eval([QTEMP1(strmatch(['sf' num2str(ch1) '=']  , QTEMP1), :) ';']);
    eval(['Output(4) = sf' num2str(ch1) ';']);

                             %locate sweepwidth in TD2
    QTEMP2 = strmatch('dw='  , QTEMP1);
    QTEMP2 = QTEMP1(QTEMP2, :);
    QTEMP2(findstr(QTEMP2, 's')) = '';	%remove the time unit to avoid an error
    eval([QTEMP2 ';']);
    Output(5) = 1e-3/dw;

    if (Output(2) > 1)
      %use same frequency in TD1 as for TD2
      Output(6) = Output(4);
    
      %locate dwell in TD1 and calculate SWH from that whilst
      %assuming a states experiment: SWH=1/DW
      QTEMP2 = strmatch('dw2='  , QTEMP1);
      if isempty(QTEMP2)
        disp(['matNMR WARNING: in file "' DirectoryName filesep 'acq":']);
        disp('      parameter dw2 was not found in acq file and therefore SWH was set to 1 kHz.');
        Output(7) = 1;
     
      else
        QTEMP2 = QTEMP1(QTEMP2, :);
        QTEMP2(findstr(QTEMP2, 's')) = '';        %remove the time unit to avoid an error
        eval([QTEMP2 ';']);
        Output(7) = 1/dw2/1000;
  
        disp(['matNMR NOTICE: SWH in TD1 was set assuming STATES processing. Please adjust manually if incorrect!']);
      end
    end
  end
