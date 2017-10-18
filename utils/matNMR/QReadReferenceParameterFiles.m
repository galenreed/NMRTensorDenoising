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
% QReadReferenceParameterFiles
%
% read in the standard spectrometer-format-specific parameter files and
% if all is well it outputs the stored values for the spectral reference
%
% NOTE: the spectral frequencies and signs of the gyromagnetic ratios
% MUST already be defined correctly for this to work properly!!
%
% 26-07-'04
%

function [RefkHz, RefPPM, RefFreq, RefValue, RefUnit] = QReadReferenceParameterFiles(QDataFormat, QXpath)

global QmatNMR

RefkHz = [0 0];
RefPPM = [0 0];
RefFreq = [];
RefValue = [];
RefUnit = [];
switch QDataFormat 	%define the output slightly different for each data format
  case {1, 3, 4}		%all Bruker formats
    %
    %For the Bruker formats we look for the procs and proc2s files
    %
    if ~exist([QXpath filesep 'procs'], 'file')
      disp(['matNMR WARNING: in directory "' QXpath '":']);
      disp(['      file "procs" not found in current path (' QXpath '). No parameters were read.']);
      return			%abort

    else
      QTEMP1 = ReadParameterFile([QXpath filesep 'procs']);
      if (QmatNMR.Dim==0) 	%is this a 2D mode? If so then read in both dimensions
        %1D mode
        			%locate absolute value in MHz TD2
        eval([QTEMP1(strmatch('SF='  , QTEMP1), :) ';']);

        if (QmatNMR.gamma1d == 1) 	%y > 0
          RefkHz(1) = -(QmatNMR.SF1D - SF)*1000;
          RefPPM(1) = -(RefkHz(1) * 1000 / QmatNMR.SF1D);

	else
          RefkHz(1) = (QmatNMR.SF1D - SF)*1000;
          RefPPM(1) = (RefkHz(1) * 1000 / QmatNMR.SF1D);
	end
	
	%values for TD2
	RefFreq = SF;
	RefValue = 0;
	RefUnit = 2;	%kHz
        disp('Importing a reference in kHz for current 1D');

      else 	%2D mode so we try to read in values for both dimensions
        			%locate absolute value in MHz TD2
        eval([QTEMP1(strmatch('SF='  , QTEMP1), :) ';']);
	if (QmatNMR.gamma1 == 1) 	%y > 0
          RefkHz(1) = -(QmatNMR.SFTD2 - SF)*1000;
          RefPPM(1) = -(RefkHz(1) * 1000 / QmatNMR.SFTD2);

	else
          RefkHz(1) = (QmatNMR.SFTD2 - SF)*1000;
          RefPPM(1) = (RefkHz(1) * 1000 / QmatNMR.SFTD2);
	end
        disp('Importing a reference in kHz for TD2');


        %values for TD2
	RefFreq = SF;
	RefValue = 0;
	RefUnit = 2;	%kHz


        			%locate absolute value in MHz TD1
        QTEMP1 = ReadParameterFile([QXpath filesep 'proc2s']);
        if ~exist([QXpath filesep 'proc2s'], 'file')
          disp(['matNMR WARNING: in directory "' QXpath '":']);
          disp(['      file "procs2" not found in current path (' QXpath '). No parameters were read for TD1.']);
          return			%abort

	else
          eval([QTEMP1(strmatch('SF='  , QTEMP1), :) ';']);
	  if (QmatNMR.gamma2 == 1) 	%y > 0
            RefkHz(2) = -(QmatNMR.SFTD1 - SF)*1000;
            RefPPM(2) = -(RefkHz(2) * 1000 / QmatNMR.SFTD1);

	  else
            RefkHz(2) = (QmatNMR.SFTD1 - SF)*1000;
            RefPPM(2) = (RefkHz(2) * 1000 / QmatNMR.SFTD1);
	  end
          disp('Importing a reference in kHz for TD2');
        end


        %values for TD1
	RefFreq(2) = SF;
	RefValue(2) = 0;
	RefUnit(2) = 2;	%kHz
      end
    end



  case 2
    %
    %For the Chemagnetics format we look for the proc file
    %
    if ~exist([QXpath filesep 'proc'], 'file')
      disp(['matNMR WARNING: in directory "' QXpath '":']);
      disp(['      file "proc" not found in current path (' QXpath '). No parameters were read.']);
      return			%abort

    else
      QTEMP1 = ReadParameterFile([QXpath filesep 'proc']);

      if (QmatNMR.Dim==0) 	%is this a 2D mode? If so then read in both dimensions
        %1D mode
        			%locate absolute value in MHz TD2
        eval([QTEMP1(strmatch('rmp1='  , QTEMP1), :) ';']);
        			%locate reference units TD2
        eval([QTEMP1(strmatch('rmv1='  , QTEMP1), :) ';']);
        			%locate reference value TD2
        eval([QTEMP1(strmatch('rmvunits1='  , QTEMP1), :) ';']);
	
	switch (rmvunits1)	%only accept the reference value if the units are in PPM, kHz or Hz!
	  case 1 	%PPM
	    RefPPM(1) = rmv1 + (QmatNMR.SF1D - rmp1)*1e6/rmp1;
	    if (QmatNMR.gamma1d == 1) 	%y > 0
              RefkHz(1) = -(RefPPM(1) * QmatNMR.SF1D)/1000;
	    else
              RefkHz(1) =  (RefPPM(1) * QmatNMR.SF1D)/1000;
	    end

	    %values for TD2
	    RefFreq = rmp1;
	    RefValue = rmv1;
	    RefUnit = 1;	%PPM
	    disp('Importing a reference in PPM for current 1D');

	  case 2 	%kHz
	    if (QmatNMR.gamma1d == 1) 	%y > 0
              RefkHz(1) = (rmv1 - (QmatNMR.SF1D - rmp1)*1000);
              RefPPM(1) = -(RefkHz(1) * 1000 / QmatNMR.SF1D);
	    else
              RefkHz(1) = rmv1 + (QmatNMR.SF1D - rmp1)*1000;
              RefPPM(1) = (RefkHz(1) * 1000 / QmatNMR.SF1D);
	    end

	    %values for TD2
	    RefFreq = rmp1;
	    RefValue = rmv1;
	    RefUnit = 2;	%kHz
	    disp('Importing a reference in kHz for current 1D');

	  case 5 	%Hz
	    if (QmatNMR.gamma1d == 1) 	%y > 0
              RefkHz(1) = (rmv1/1000 - (QmatNMR.SF1D - rmp1)*1000);
              RefPPM(1) = -(RefkHz(1) * 1000 / QmatNMR.SF1D);
	    else
              RefkHz(1) = rmv1/1000 + (QmatNMR.SF1D - rmp1)*1000;
              RefPPM(1) = (RefkHz(1) * 1000 / QmatNMR.SF1D);
	    end

	    %values for TD2
	    RefFreq = rmp1;
	    RefValue = rmv1/1000;
	    RefUnit = 2;	%kHz
	    disp('Importing a reference in Hz for current 1D');
	    
	  otherwise 	%unknown code for the reference value
	    disp('matNMR ERROR: encountered unknown code for the unit of the external reference. Aborting ...');
	    return
	end

      else 	%2D mode so we try to read in values for both dimensions
        			%locate absolute value in MHz TD2
        eval([QTEMP1(strmatch('rmp1='  , QTEMP1), :) ';']);
        			%locate reference units TD2
        eval([QTEMP1(strmatch('rmv1='  , QTEMP1), :) ';']);
        			%locate reference value TD2
        eval([QTEMP1(strmatch('rmvunits1='  , QTEMP1), :) ';']);
	
	switch (rmvunits1)	%only accept the reference value if the units are in PPM, kHz or Hz!
	  case 1 	%PPM
	    RefPPM(1) = rmv1 + (QmatNMR.SFTD2 - rmp1)*1e6/rmp1;
	    if (QmatNMR.gamma1 == 1) 	%y > 0
              RefkHz(1) = -(RefPPM(1) * QmatNMR.SFTD2)/1000;
	    else
              RefkHz(1) =  (RefPPM(1) * QmatNMR.SFTD2)/1000;
	    end

	    %values for TD2
	    RefFreq = rmp1;
	    RefValue = rmv1;
	    RefUnit = 1;	%PPM
	    disp('Importing a reference in ppm for TD2');

	  case 2 	%kHz
	    if (QmatNMR.gamma1 == 1) 	%y > 0
              RefkHz(1) = (rmv1 - (QmatNMR.SFTD2 - rmp1)*1000);
              RefPPM(1) = -(RefkHz(1) * 1000 / QmatNMR.SFTD2);
	    else
              RefkHz(1) = rmv1 + (QmatNMR.SFTD2 - rmp1)*1000;
              RefPPM(1) = (RefkHz(1) * 1000 / QmatNMR.SFTD2);
	    end

	    %values for TD2
	    RefFreq = rmp1;
	    RefValue = rmv1;
	    RefUnit = 2;	%kHz
	    disp('Importing a reference in kHz for TD2');

	  case 5 	%Hz
	    if (QmatNMR.gamma1 == 1) 	%y > 0
              RefkHz(1) = (rmv1/1000 - (QmatNMR.SFTD2 - rmp1)*1000);
              RefPPM(1) = -(RefkHz(1) * 1000 / QmatNMR.SFTD2);
	    else
              RefkHz(1) = rmv1/1000 + (QmatNMR.SFTD2 - rmp1)*1000;
              RefPPM(1) = (RefkHz(1) * 1000 / QmatNMR.SFTD2);
	    end

	    %values for TD2
	    RefFreq = rmp1;
	    RefValue = rmv1/1000;
	    RefUnit = 2;	%kHz
	    disp('Importing a reference in Hz for TD2');
	    
	  otherwise 	%unknown code for the reference value
	    disp('matNMR ERROR: encountered unknown code for the unit of the external reference. Aborting ...');
	    return
	end


        			%locate absolute value in MHz TD1
        eval([QTEMP1(strmatch('rmp2='  , QTEMP1), :) ';']);
        			%locate reference units TD1
        eval([QTEMP1(strmatch('rmv2='  , QTEMP1), :) ';']);
        			%locate reference value TD1
        eval([QTEMP1(strmatch('rmvunits2='  , QTEMP1), :) ';']);
	
	switch (rmvunits2)	%only accept the reference value if the units are in PPM, kHz or Hz!
	  case 1 	%PPM
	    RefPPM(2) = rmv2 + (QmatNMR.SFTD1 - rmp2)*1e6/rmp2;
	    if (QmatNMR.gamma2 == 1) 	%y > 0
              RefkHz(2) = -(RefPPM(2) * QmatNMR.SFTD1)/1000;
	    else
              RefkHz(2) =  (RefPPM(2) * QmatNMR.SFTD1)/1000;
	    end

	    %values for TD1
	    RefFreq(2) = rmp2;
	    RefValue(2) = rmv2;
	    RefUnit(2) = 1;	%PPM
	    disp('Importing a reference in ppm for TD1');

	  case 2 	%kHz
	    if (QmatNMR.gamma2 == 1) 	%y > 0
              RefkHz(2) = (rmv2 - (QmatNMR.SFTD1 - rmp2)*1000);
              RefPPM(2) = -(RefkHz(2) * 1000 / QmatNMR.SFTD1);
	    else
              RefkHz(2) = rmv2 + (QmatNMR.SFTD1 - rmp2)*1000;
              RefPPM(2) = (RefkHz(2) * 1000 / QmatNMR.SFTD1);
	    end

	    %values for TD1
	    RefFreq(2) = rmp2;
	    RefValue(2) = rmv2;
	    RefUnit(2) = 2;	%kHz
	    disp('Importing a reference in kHz for TD1');

	  case 5 	%Hz
	    if (QmatNMR.gamma2 == 1) 	%y > 0
              RefkHz(2) = (rmv2/1000 - (QmatNMR.SFTD1 - rmp2)*1000);
              RefPPM(2) = -(RefkHz(2) * 1000 / QmatNMR.SFTD1);
	    else
              RefkHz(2) = rmv2/1000 + (QmatNMR.SFTD1 - rmp2)*1000;
              RefPPM(2) = (RefkHz(2) * 1000 / QmatNMR.SFTD1);
	    end

	    %values for TD1
	    RefFreq(2) = rmp2;
	    RefValue(2) = rmv2/1000;
	    RefUnit(2) = 2;	%kHz
	    disp('Importing a reference in Hz for TD1');
	    
	  otherwise 	%unknown code for the reference value
	    disp('matNMR ERROR: encountered unknown code for the unit of the external reference. Aborting ...');
	    return
	end

      end
    end

  case 5
    %
    %For the VNMR format we look for the procpar file
    %
    if ~exist([QXpath filesep 'procpar'], 'file')
      disp(['matNMR WARNING: in directory "' QXpath '":']);
      disp(['      file "procpar" not found in current path (' QXpath '). No parameters were read.']);
      return			%abort

    else
      QTEMP1 = ReadParameterFile([QXpath filesep 'procpar']);
      if (QmatNMR.Dim==0) 	%is this a 2D mode? If so then read in both dimensions
        %1D mode

      				%locate frequency of 1D
        QTEMP2 = strmatch('reffrq '  , QTEMP1);	%the exact line in the character array
        QTEMP3 = deblank(QTEMP1(QTEMP2+1, :));	%deblank the next line
        QTEMP4 = findstr(QTEMP3, ' ');		%refpos is found after the first empty space
        reffrq = str2num(QTEMP3(QTEMP4(1):length(QTEMP3)));

      				%locate ppm value of 1D
        QTEMP2 = strmatch('refpos '  , QTEMP1);	%the exact line in the character array
        if ~isempty(QTEMP2)
          QTEMP3 = deblank(QTEMP1(QTEMP2+1, :));	%deblank the next line
          QTEMP4 = findstr(QTEMP3, ' ');		%refpos is found after the first empty space
          refpos = str2num(QTEMP3(QTEMP4(1):length(QTEMP3)));
        else
          refpos = 0;
        end

	RefPPM(1) = refpos + (QmatNMR.SF1D - reffrq)*1e6/reffrq;
	if (QmatNMR.gamma1 == 1)   %y > 0
          RefkHz(1) = -(RefPPM(1) * QmatNMR.SF1D)/1000;
	else
          RefkHz(1) =  (RefPPM(1) * QmatNMR.SF1D)/1000;
	end

	%values for TD2
	RefFreq = reffrq;
	RefValue = refpos;
	RefUnit = 1;        %PPM
	disp('Importing a reference in ppm for current 1D');

      else 	%2D mode so we try to read in values for both dimensions
      				%locate frequency for TD2
        QTEMP2 = strmatch('reffrq '  , QTEMP1);	%the exact line in the character array
        QTEMP3 = deblank(QTEMP1(QTEMP2+1, :));	%deblank the next line
        QTEMP4 = findstr(QTEMP3, ' ');		%refpos is found after the first empty space
        reffrq = str2num(QTEMP3(QTEMP4(1):length(QTEMP3)));

      				%locate ppm value for TD2
        QTEMP2 = strmatch('refpos '  , QTEMP1);	%the exact line in the character array
        if ~isempty(QTEMP2)
          QTEMP3 = deblank(QTEMP1(QTEMP2+1, :));	%deblank the next line
          QTEMP4 = findstr(QTEMP3, ' ');		%refpos is found after the first empty space
          refpos = str2num(QTEMP3(QTEMP4(1):length(QTEMP3)));
        else
          refpos = 0;
        end

	RefPPM(1) = refpos + (QmatNMR.SFTD2 - reffrq)*1e6/reffrq;
	if (QmatNMR.gamma1 == 1)   %y > 0
          RefkHz(1) = -(RefPPM(1) * QmatNMR.SFTD2)/1000;
	else
          RefkHz(1) =  (RefPPM(1) * QmatNMR.SFTD2)/1000;
	end

	%values for TD2
	RefFreq(1) = reffrq;
	RefValue(1) = refpos;
	RefUnit(1) = 1;        %PPM
	disp('Importing a reference in ppm for TD2');


      				%locate frequency for TD1
        QTEMP2 = strmatch('reffrq1 '  , QTEMP1);	%the exact line in the character array
        QTEMP3 = deblank(QTEMP1(QTEMP2+1, :));	%deblank the next line
        QTEMP4 = findstr(QTEMP3, ' ');		%refpos is found after the first empty space
        reffrq1 = str2num(QTEMP3(QTEMP4(1):length(QTEMP3)));

      				%locate ppm value for TD1
        QTEMP2 = strmatch('refpos1 '  , QTEMP1);	%the exact line in the character array
        if ~isempty(QTEMP2)
          QTEMP3 = deblank(QTEMP1(QTEMP2+1, :));	%deblank the next line
          QTEMP4 = findstr(QTEMP3, ' ');		%refpos is found after the first empty space
          refpos1 = str2num(QTEMP3(QTEMP4(1):length(QTEMP3)));
        else
          refpos1 = 0;
        end

	RefPPM(2) = refpos1 + (QmatNMR.SFTD1 - reffrq1)*1e6/reffrq1;
	if (QmatNMR.gamma2 == 1)   %y > 0
          RefkHz(2) = -(RefPPM(2) * QmatNMR.SFTD1)/1000;
	else
          RefkHz(2) =  (RefPPM(2) * QmatNMR.SFTD1)/1000;
	end

	%values for TD2
	RefFreq(2) = reffrq1;
	RefValue(2) = refpos1;
	RefUnit(2) = 1;        %PPM
	disp('Importing a reference in ppm for TD1');
      end
    end

  case 6
    %
    %For the MacNMR format this is not yet implemented
    %
    disp('matNMR NOTICE: unfortunately this hasn''t been implemented yet for this format. Please contact me!');
    return    

  case 7
    %
    %For the NTNMR format this is not yet implemented
    %
    disp('matNMR NOTICE: unfortunately this hasn''t been implemented yet for this format. Please contact me!');
    return    

  case 8
    %
    %For the Bruker Aspect 2000/3000 format this is not yet implemented
    %
    disp('matNMR NOTICE: unfortunately this hasn''t been implemented yet for this format. Please contact me!');
    return    

  case 9			%JEOL Generic format
    %
    %For the JEOL Generic format this is not yet implemented
    %
    disp('matNMR NOTICE: unfortunately this hasn''t been implemented yet for this format. Please contact me!');
    return    

end
