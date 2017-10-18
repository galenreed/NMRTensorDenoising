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
% QReadParameterFiles
%
% read in the standard spectrometer-format-specific parameter files and
% if all is well it outputs a matNMR structure, with an empty spectrum
% variable. The spectrum is produced by Qfidread.
%
% 25-03-'03
%

function [ret, QSizeTD2, QSizeTD1, QByteOrder] = QReadParameterFiles(QDataFormat, QXpath, QXfilename)

ret = [];
QSizeTD2 = 1;
QSizeTD1 = 1;
QByteOrder = 0;
BufferSizeBruker = 256;

switch QDataFormat 	%define the output slightly different for each data format
  case 1			%all Bruker formats
    %
    %For the Bruker formats we look for the acqu and acqu2 files
    %
    if ~exist([QXpath filesep 'acqus'], 'file')
      disp(['matNMR WARNING: in directory "' QXpath '":']);
      disp('      files "acqus" not found in current path. No parameters were read.');
      return

    else
      ret = GenerateMatNMRStructure;
      QTEMP1 = ReadParameterFile([QXpath filesep 'acqus']);

				%locate size of TD2
      eval([QTEMP1(strmatch('TD='  , QTEMP1), :) ';']);
      QSizeTD2 = TD;
      
      				%locate spectrometer frequency of TD2
      eval([QTEMP1(strmatch('SFO1='  , QTEMP1), :) ';']);
      ret.SpectralFrequencyTD2 = SFO1;

      				%locate sweepwidth in TD2
      eval([QTEMP1(strmatch('SW_h='  , QTEMP1), :) ';']);
      ret.SweepWidthTD2 = SW_h/1000;

				%set the flag for FID in TD2
      ret.FIDstatusTD2 = 2;

      %
      %read the byte ordering from the status file
      %
%%%%%%QTEMP1 = ReadParameterFile([QXpath filesep 'acqus']);
      eval([QTEMP1(strmatch('BYTORDA='  , QTEMP1), :) ';']);
      QByteOrder = ~BYTORDA + 1;	%construction ensures that little endian = 2 and big endian = 1
    end
    
    if ((exist([QXpath filesep 'acqu2'], 'file')) & (exist([QXpath filesep 'acqu2s'], 'file')))	%it's probably a 2D FID then ...
      disp(['matNMR NOTICE: in directory "' QXpath QXfilename '":']);
      disp('      beware that the values for the spectral width and spectrometer frequency in TD1 may be wrong (see manual)');
      QTEMP1 = ReadParameterFile([QXpath filesep 'acqu2s']);

      				%locate spectrometer frequency of TD1
      eval([QTEMP1(strmatch('SFO1='  , QTEMP1), :) ';']);
      ret.SpectralFrequencyTD1 = SFO1;

      				%locate sweepwidth in TD1
      eval([QTEMP1(strmatch('SW_h='  , QTEMP1), :) ';']);
      ret.SweepWidthTD1 = SW_h/1000;

				%set the flag for FID in TD1
      ret.FIDstatusTD1 = 2;

				%locate size of TD1 (of acqu2s file)
      eval([QTEMP1(strmatch('TD='  , QTEMP1), :) ';']);
      QSizeTD1 = TD;

      %
      %NOTE in older versions of the Bruker software an unfinished experiment would still be the full size as
      %specified by the TD values in the acqu and acqu2 files. In newer versions the size is specified by the
      %value of TD in acqu2s. Hence we check whether the size defined in the acqu2 file makes more sense
      %
      ByteFactor = 4;
      QTEMP2 = dir([QXpath filesep QXfilename]);
      if (ceil(QSizeTD2/BufferSizeBruker)*BufferSizeBruker*QSizeTD1*ByteFactor ~= QTEMP2.bytes)
				%locate size of TD1 (of acqu2 file)
        QTEMP1 = ReadParameterFile([QXpath filesep 'acqu2']);
        eval([QTEMP1(strmatch('TD='  , QTEMP1), :) ';']);
        QSizeTD1acqu2 = TD;
        
        if (ceil(QSizeTD2/BufferSizeBruker)*BufferSizeBruker*QSizeTD1acqu2*ByteFactor == QTEMP2.bytes)
          %
          %The TD value given in the acqu2 file makes more sense. We use this without notifying the user!
          %
          QSizeTD1 = QSizeTD1acqu2;
        end
      end
      
    else
      disp(['matNMR NOTICE: in directory "' QXpath '":']);
      disp('      acqu2 and/or acqu2s file not found. Assuming it is a 1D FID.');
    end


  case 2
    %
    %For the Chemagnetics format we look for the acq file
    %
    if ~exist([QXpath filesep 'acq'], 'file')
      disp(['matNMR WARNING: in directory "' QXpath '":']);
      disp(['      file "acq" not found in current path (' QXpath '). No parameters were read.']);
      return			%abort

    else
      ret = GenerateMatNMRStructure;
      QTEMP1 = ReadParameterFile([QXpath filesep 'acq']);

				%locate size of TD2
      eval([QTEMP1(strmatch('al='  , QTEMP1), :) ';']);
      QSizeTD2 = al*2;
      
      				%locate spectrometer frequency of TD2
      eval([QTEMP1(strmatch('ch1='  , QTEMP1), :) ';']);

      eval([QTEMP1(strmatch(['sf' num2str(ch1) '=']  , QTEMP1), :) ';']);
      %
      %check for the situation that the frequency was arrayed because otherwise an error message will occur
      %
      if (eval(['exist(''sf' num2str(ch1) ''')']) ~= 1) 		%not a normal variable -> assume array
        disp('matNMR NOTICE: spectral frequency was arrayed. Using first value only!');
        beep
        eval([strrep(QTEMP1(strmatch(['sf' num2str(ch1) '[0]='], QTEMP1), :), '[0]', '') ';']);
      end
      %
      %Finally, set the spectral frequency
      %
      eval(['ret.SpectralFrequencyTD2 = sf' num2str(ch1) ';']);

      				%locate dw in TD2 and calculate SWH=1/dw. This avoids any unit confusions for sw.
      QTEMP2 = strmatch('dw='  , QTEMP1);
      QTEMP2 = QTEMP1(QTEMP2, :);
      QTEMP2(findstr(QTEMP2, 's')) = '';	%remove the time unit to avoid an error
      eval([QTEMP2 ';']);
      ret.SweepWidthTD2 = 1/dw/1000;

				%set the flag for FID in TD2
      ret.FIDstatusTD2 = 2;


      %
      %Now we check whether the file is a 2D experiment OR contains an array of 1D
      %experiments
      %
      if ~isempty(strmatch('array_num_values_'  , QTEMP1))	%array of 1D experiments
        %
	%first we need to check whether the array that is written in the acq was actually used
	%during the experiment. This is denoted by the variable use_array in the acq_2
	%file.
	%
	QTEMP9 = ReadParameterFile([QXpath filesep 'acq_2']);

				%locate size of TD2
        eval([QTEMP9(strmatch('use_array='  , QTEMP9), :) ';']);
        if (use_array == 1)	%the array flag was on
          %
          %then we need to check how many arrays there are and in how many dimensions they run
          %
          QTEMP2 = strmatch('array_num_values_'  , QTEMP1);
          QTEMP2 = QTEMP1(QTEMP2, :);
  
          QTEMP3 = strmatch('array_dim_'  , QTEMP1);
          QTEMP3 = QTEMP1(QTEMP3, :);
          QTEMP4 = [];		%array with all the dimension sizes
          QTEMP5 = [];		%array with all the dimension indexes
          for QTEMP9 = 1:size(QTEMP3, 1);
            QTEMP4 = [QTEMP4 eval(QTEMP2(QTEMP9, findstr('=', QTEMP2(QTEMP9, :))+1:end))];
            QTEMP5 = [QTEMP5 eval(QTEMP3(QTEMP9, findstr('=', QTEMP3(QTEMP9, :))+1:end))];
          end

          [QTEMP5, QTEMP9] = sort(QTEMP5);
          QTEMP4 = QTEMP4(QTEMP9);
          QTEMP2 = QTEMP2(QTEMP9, :);
          QTEMP3 = QTEMP3(QTEMP9, :);
          
  
          %
          %so now QTEMP5 contains all the dimension indexes and all we have to do now
          %is to select the size for each dimension and multiply these.
          %
          QTEMP8 = QTEMP5(1);
          QSizeTD1 = QSizeTD1 * QTEMP4(1);
          for QTEMP9 = 2:length(QTEMP5)
            if (QTEMP8 ~= QTEMP5(QTEMP9))
              QTEMP8 = QTEMP5(QTEMP9);
              QSizeTD1 = QSizeTD1 * QTEMP4(QTEMP9);
            end
          end
          

          %
          %As an extra service to the user we show the arrays on the screen in the console window
          %
          %first we add +1 to all array indices because Spinsight starts at 0 whereas Matlab starts arrays at 1
          %and we change the square brackets into round ones because Matlab uses those too
          %and we remove any unit that may be attached to the variables
          QTEMP8 = size(QTEMP1, 1);
          for QTEMP9 = 1:QTEMP8
            QTEMP10 = strrep(QTEMP1(QTEMP9, :), ']', '+1)');
            QTEMP10 = deblank(strrep(QTEMP10, '[', '('));
            %the next stuff is for the removal of all units, i.e. of all non-numeric characters at the end of the string
            QTEMP13 = length(QTEMP10);
            for QTEMP12=QTEMP13:-1:1
              if ~isempty(str2num(QTEMP10(QTEMP12)))
                break
              else
                QTEMP13 = QTEMP12-1; 	%this is the cutoff
              end
            end
            QTEMP10=QTEMP10(1:QTEMP13);
            
            %the corrected line is reinserted into the string array
            QTEMP1 = str2mat(QTEMP1(1:QTEMP9-1, :), QTEMP10, QTEMP1(QTEMP9+1:QTEMP8, :));
          end

          %then we determine all variable names that were arrayed
          QTEMP10 = QTEMP3(1, 11:(findstr('=', QTEMP3(1, :))-1));
          for QTEMP9=2:length(QTEMP5)
            QTEMP10 = str2mat(QTEMP10, QTEMP3(QTEMP9, 11:(findstr('=', QTEMP3(QTEMP9, :))-1)));
          end

          %then we evaluate all array entries
          for QTEMP9=1:length(QTEMP5)
            QTEMP11 = strmatch([deblank(QTEMP10(QTEMP9, :)) '('], QTEMP1); 	%where are the array entries
            for QTEMP12 = 1:length(QTEMP11)
              eval([QTEMP1(QTEMP11(QTEMP12), :) ';']);
            end
            
            %
            %show output
            %
            disp(['Array found in Chemagnetics file: "' deblank(QTEMP10(QTEMP9, :)) '", dimension = ' num2str(QTEMP5(QTEMP9))]);
            QTEMP20  = sprintf('      %s = [', deblank(QTEMP10(QTEMP9, :)));
            eval(['QTEMP21 = sprintf(''%0.13g '', ' deblank(QTEMP10(QTEMP9, :)) ');']);
            QTEMP22 = sprintf('];\n');
            disp([QTEMP20 QTEMP21 QTEMP22])
            
            %
            %store the arrayed parameter in the matNMR structure as a userdef_par_dim parameter
            %
            eval(['ret.UserDef_SpinSightArray_' deblank(QTEMP10(QTEMP9, :)) '_dim_' num2str(QTEMP5(QTEMP9)) ' = [' QTEMP21 QTEMP22])
          end



        				%set spectrometer frequency of TD1 equal to TD2, taking the first value only
          eval(['ret.SpectralFrequencyTD1 = sf' num2str(ch1) '(1);']);
  
  				%set the sweepwidth to 1k to prevent unexpected errors if setting to 0
          ret.SweepWidthTD1 = 1;
  
  				%set the flag for FID in TD1
          ret.FIDstatusTD1 = 2;

	else		%the array(s) weren't used in the experiment
	  %
	  %It could still be that arrays were defined in a 2D experiment, without them being run.
	  %And so we check for that as well
	  %
	  if ~isempty(strmatch('al2='  , QTEMP1))	%2D FID
    				%locate size of TD1
            eval([QTEMP1(strmatch('al2='  , QTEMP1), :) ';']);
            QSizeTD1 = al2;
          
          				%set spectrometer frequency of TD1 equal to TD2
            eval(['ret.SpectralFrequencyTD1 = sf' num2str(ch1) ';']);
    
          				%locate dwell in TD1 and calculate SWH from that whilst
    				%assuming a states experiment: SWH=1/DW
            QTEMP2 = strmatch('dw2='  , QTEMP1);
            if isempty(QTEMP2)
              disp(['matNMR WARNING: in file "' QXpath QXfilename '":']);
              disp('      parameter dw2 was not found in acq file but is expected for a 2D Chemagnetics FID (see manual).');
              ret.SweepWidthTD1 = 1;
    	
            else
              QTEMP2 = QTEMP1(QTEMP2, :);
              QTEMP2(findstr(QTEMP2, 's')) = '';	%remove the time unit to avoid an error
              eval([QTEMP2 ';']);
              ret.SweepWidthTD1 = 1/dw2/1000;
            end
    
    				%set the flag for FID in TD1
            ret.FIDstatusTD1 = 2;
    
	  else
	    %
	    %we give up trying and set the size in TD1 to 1, even if that may be wrong
	    %
            QSizeTD1 = 1;
  
          				%set spectrometer frequency of TD1 equal to TD2
            eval(['ret.SpectralFrequencyTD1 = sf' num2str(ch1) ';']);

    				%set the sweepwidth to 1k to prevent unexpected errors if setting to 0
            ret.SweepWidthTD1 = 1;
    
    				%set the flag for FID in TD1
            ret.FIDstatusTD1 = 2;
	  end
	end

      elseif ~isempty(strmatch('al2='  , QTEMP1))	%2D FID
				%locate size of TD1
        eval([QTEMP1(strmatch('al2='  , QTEMP1), :) ';']);
        QSizeTD1 = al2;
      
      				%set spectrometer frequency of TD1 equal to TD2
        eval(['ret.SpectralFrequencyTD1 = sf' num2str(ch1) ';']);

      				%locate dwell in TD1 and calculate SWH from that whilst
				%assuming a states experiment: SWH=1/DW
        QTEMP2 = strmatch('dw2='  , QTEMP1);
	if isempty(QTEMP2)
          disp(['matNMR WARNING: in file "' QXpath QXfilename '":']);
	  disp('      parameter dw2 was not found in acq file but is expected for a 2D Chemagnetics FID (see manual).');
	  ret.SweepWidthTD1 = 1;
	
	else
	  QTEMP2 = QTEMP1(QTEMP2, :);
	  QTEMP2(findstr(QTEMP2, 's')) = '';	%remove the time unit to avoid an error
          eval([QTEMP2 ';']);
          ret.SweepWidthTD1 = 1/dw2/1000;
        end

				%set the flag for FID in TD1
        ret.FIDstatusTD1 = 2;
      end
    end

  case 5
    %
    %For the VNMR format we look for the procpar file
    %
    if ~exist([QXpath filesep 'procpar'], 'file')
      disp(['matNMR WARNING: in directory "' QXpath '":']);
      disp('      files "procpar" not found in current path. No parameters were read.');
      return			%abort

    else
      ret = GenerateMatNMRStructure;
      QTEMP1 = ReadParameterFile([QXpath filesep 'procpar']);

      				%locate spectrometer frequency of TD2
      QTEMP2 = strmatch('sfrq '  , QTEMP1);	%the exact line in the character array
      QTEMP3 = deblank(QTEMP1(QTEMP2+1, :));	%deblank the next line
      QTEMP4 = findstr(QTEMP3, ' ');		%sfrq is found after the first empty space
      ret.SpectralFrequencyTD2 = str2num(QTEMP3(QTEMP4(1):length(QTEMP3)));

      				%locate sweepwidth in TD2
      QTEMP2 = strmatch('sw '  , QTEMP1);	%the exact line in the character array
      QTEMP3 = deblank(QTEMP1(QTEMP2+1, :));	%deblank the next line
      QTEMP4 = findstr(QTEMP3, ' ');		%sw is found after the first empty space
      ret.SweepWidthTD2 = str2num(QTEMP3(QTEMP4(1):length(QTEMP3)))/1000;

				%set the flag for FID in TD2
      ret.FIDstatusTD2 = 2;

      if ~isempty(strmatch('sw1 '  , QTEMP1))	%assume it is a 2D FID --> I AM NOT SURE THIS IS CORRECT!
      				%set spectrometer frequency of TD1 equal to TD2
        ret.SpectralFrequencyTD1 = ret.SpectralFrequencyTD2;
 

      				%locate sweepwidth in TD1
        QTEMP2 = strmatch('sw1 '  , QTEMP1);	%the exact line in the character array
        QTEMP3 = deblank(QTEMP1(QTEMP2+1, :));	%deblank the next line
        QTEMP4 = findstr(QTEMP3, ' ');		%sw1 is found after the first empty space
        ret.SweepWidthTD1 = str2num(QTEMP3(QTEMP4(1):length(QTEMP3)))/1000;
 
				%set the flag for FID in TD1
        ret.FIDstatusTD1 = 2;
      end
    end

  case 9			%JEOL Generic format
    %
    %For the JEOL Generic format we look for the .hdr file
    %
    QTEMP1 = findstr(QXfilename, '.bin');	%see if the file contains a ".bin" part. Then we'll replace that by
    						%a ".hdr" and this should be the parameter file. If does not exist then
						%an error message will be given
    if isempty(QTEMP1)
      disp(['matNMR WARNING: in directory "' QXpath '":']);
      disp('      ".bin" file not found in current path. No parameters were read.');
      return			%abort
    end

    QTEMP1 = strrep(QXfilename, '.bin', '.hdr');
    if ~exist([QXpath filesep QTEMP1], 'file')
      disp(['matNMR WARNING: in directory "' QXpath '":']);
      disp('      ".hdr" file not found in current path. No parameters were read.');
      return			%abort

    else
      ret = GenerateMatNMRStructure;
      QTEMP1 = ReadParameterFile([QXpath filesep QTEMP1]);

      %
      %see whether there is non-linear sampling involved
      %
      QTEMP2 = [strmatch('x_list ', QTEMP1) strmatch('y_list ', QTEMP1)];	%the exact line in the character array
      if QTEMP2
        disp(['matNMR WARNING: in file "' QXpath QXfilename '":']);
        disp('      non-linear sampling is not supported by the input filter!');
        ret = [];		%abort
        return			%abort
      end

      				%locate spectrometer frequency of TD2
      QTEMP2 = strmatch('x_freq ', QTEMP1);	%the exact line in the character array
      QTEMP3 = deblank(QTEMP1(QTEMP2, :));	%deblank the line
      QTEMP4 = findstr(QTEMP3, ' ');		%the value is found after the last empty space
      QTEMP5 = findstr(QTEMP3, '[');		%and before the '['
      QTEMP6 = QTEMP3(QTEMP5+1:findstr(QTEMP3, ']')-1);	%this is to determine the unit of the value
      if strcmp(QTEMP6, 'MHz')			%These factors correspond to the SF in MHz that is
        Factor = 1;				%used by matNMR
      elseif strcmp(QTEMP6, 'kHz');
        Factor = 1e-3;
      elseif strcmp(QTEMP6, 'Hz');
        Factor = 1e-6;
      end
      ret.SpectralFrequencyTD2 = str2num(QTEMP3(QTEMP4(length(QTEMP4)):QTEMP5-1))*Factor;


      				%locate sweepwidth in TD2
      QTEMP2 = strmatch('x_sweep ', QTEMP1);	%the exact line in the character array
      QTEMP3 = deblank(QTEMP1(QTEMP2, :));	%deblank the line
      QTEMP4 = findstr(QTEMP3, ' ');		%the value is found after the last empty space
      QTEMP5 = findstr(QTEMP3, '[');		%and before the '['
      QTEMP6 = QTEMP3(QTEMP5+1:findstr(QTEMP3, ']')-1);	%this is to determine the unit of the value
      if strcmp(QTEMP6, 'MHz')			%These factors correspond to the SWH in kHz that is
        Factor = 1e3;				%used by matNMR
      elseif strcmp(QTEMP6, 'kHz');
        Factor = 1;
      elseif strcmp(QTEMP6, 'Hz');
        Factor = 1e-3;
      end
      ret.SweepWidthTD2 = str2num(QTEMP3(QTEMP4(length(QTEMP4)):QTEMP5-1))*Factor;


				%locate size of TD2
      QTEMP2 = strmatch('x_curr_points ', QTEMP1);	%the exact line in the character array
      QTEMP3 = deblank(QTEMP1(QTEMP2, :));	%deblank the line
      QTEMP4 = findstr(QTEMP3, ' ');		%the value is found after the last empty space
      QSizeTD2 = str2num(QTEMP3(QTEMP4(length(QTEMP4))+1:length(QTEMP3)));
      
				%locate whether it is real or complex data
      QTEMP2 = strmatch('format ', QTEMP1);	%the exact line in the character array
      if findstr(QTEMP1(QTEMP2, :), 'COMPLEX')
        QSizeTD2 = QSizeTD2 * 2;

      else
        disp(['matNMR NOTICE: in file "' QXpath QXfilename '":']);
        disp('      Real data are not supported by the filter. Please reshuffle the data manually!')
      end

				%set the flag for FID in TD2
      ret.FIDstatusTD2 = 2;


      %
      %Now check whether it is a 2D
      %
      if ~isempty(strmatch('y_curr_points '  , QTEMP1))	%assume it is a 2D FID
 
        				%locate spectrometer frequency of TD1
        QTEMP2 = strmatch('y_freq ', QTEMP1);	%the exact line in the character array
        QTEMP3 = deblank(QTEMP1(QTEMP2, :));	%deblank the line
        QTEMP4 = findstr(QTEMP3, ' ');		%the value is found after the last empty space
        QTEMP5 = findstr(QTEMP3, '[');		%and before the '['
        QTEMP6 = QTEMP3(QTEMP5+1:findstr(QTEMP3, ']')-1);	%this is to determine the unit of the value
        if strcmp(QTEMP6, 'MHz')		%These factors correspond to the SF in MHz that is
          Factor = 1;				%used by matNMR
        elseif strcmp(QTEMP6, 'kHz');
          Factor = 1e-3;
        elseif strcmp(QTEMP6, 'Hz');
          Factor = 1e-6;
        end
        ret.SpectralFrequencyTD1 = str2num(QTEMP3(QTEMP4(length(QTEMP4)):QTEMP5-1))*Factor;
  
  
        				%locate sweepwidth in TD1
        QTEMP2 = strmatch('y_sweep ', QTEMP1);	%the exact line in the character array
        QTEMP3 = deblank(QTEMP1(QTEMP2, :));	%deblank the line
        QTEMP4 = findstr(QTEMP3, ' ');		%the value is found after the last empty space
        QTEMP5 = findstr(QTEMP3, '[');		%and before the '['
        QTEMP6 = QTEMP3(QTEMP5+1:findstr(QTEMP3, ']')-1);	%this is to determine the unit of the value
        if strcmp(QTEMP6, 'MHz')		%These factors correspond to the SWH in kHz that is
          Factor = 1e3;				%used by matNMR
        elseif strcmp(QTEMP6, 'kHz');
          Factor = 1;
        elseif strcmp(QTEMP6, 'Hz');
          Factor = 1e-3;
        end
        ret.SweepWidthTD1 = str2num(QTEMP3(QTEMP4(length(QTEMP4)):QTEMP5-1))*Factor;
  
  
  				%locate size of TD1
        QTEMP2 = strmatch('y_curr_points ', QTEMP1);	%the exact line in the character array
        QTEMP3 = deblank(QTEMP1(QTEMP2, :));	%deblank the line
        QTEMP4 = findstr(QTEMP3, ' ');		%the value is found after the last empty space
        QSizeTD1 = str2num(QTEMP3(QTEMP4(length(QTEMP4))+1:length(QTEMP3)));
        
  				%locate whether it is real or complex data
        QTEMP2 = strmatch('y_format ', QTEMP1);	%the exact line in the character array
        if findstr(QTEMP1(QTEMP2, :), 'COMPLEX')
          QSizeTD2 = QSizeTD2 * 2;		%this ensures that States data are read in as is
        end					%required (Chemagnetics-like organization)

				%set the flag for FID in TD1
        ret.FIDstatusTD1 = 2;
      end
    end


  case 11
    %
    %For the CMXW format we look for the pb file
    %
    if ~exist([QXpath filesep 'pb'], 'file')
      disp(['matNMR WARNING: in directory "' QXpath '":']);
      disp(['      file "pb" not found in current path (' QXpath '). No parameters were read.']);
      return			%abort

    else
      ret = GenerateMatNMRStructure;
      QTEMP1 = ReadParameterFile([QXpath filesep 'pb']);

				%locate size of TD2
      QTEMP2 = strmatch('al='  , QTEMP1);
      QTEMP2 = QTEMP1(QTEMP2(1), :);
      QTEMP3 = findstr(QTEMP2, 'k');
      if ~isempty(QTEMP3)
        QTEMP2 = [QTEMP2(1:QTEMP3-1) '*1024'];
      end
      eval([QTEMP2 ';']);
      QSizeTD2 = al*2;
      
      				%locate spectrometer frequency of TD2
      eval([QTEMP1(strmatch('ch1='  , QTEMP1), :) ';']);

      eval([QTEMP1(strmatch(['sf' num2str(ch1) '=']  , QTEMP1), :) ';']);
      eval(['ret.SpectralFrequencyTD2 = sf' num2str(ch1) ';']);

      				%locate dw in TD2 and calculate SWH=1/dw. This avoids any unit confusions for sw.
      QTEMP2 = strmatch('dw='  , QTEMP1);
      QTEMP2 = QTEMP1(QTEMP2(1), :);

      QTEMP3 = findstr(QTEMP2, 'u')-1;	%remove the time unit to avoid an error
      QTEMP2 = [QTEMP2(1:QTEMP3) '*1e-6'];
      eval([QTEMP2 ';']);
      ret.SweepWidthTD2 = 1/dw/1000;

				%set the flag for FID in TD2
      ret.FIDstatusTD2 = 2;
    end


    %
    %Now we check whether the dataset is a 2D experiment
    %
    if ~exist([QXpath filesep 'p2'], 'file')
      disp(['matNMR NOTICE: in directory "' QXpath '":']);
      disp('      p2 file not found. Assuming it is a 1D FID.');
      return			%abort

    else
      ret = GenerateMatNMRStructure;
      QTEMP1 = ReadParameterFile([QXpath filesep 'p2']);

				%locate size of TD2
      QTEMP2 = strmatch('al2='  , QTEMP1);
      QTEMP2 = QTEMP1(QTEMP2(1), :);
      QTEMP3 = findstr(QTEMP2, 'k');
      if ~isempty(QTEMP3)
        QTEMP2 = [QTEMP2(1:QTEMP3-1) '*1024'];
      end
      eval([QTEMP2 ';']);
      QSizeTD1 = al2;
      
     				%set spectrometer frequency of TD1 equal to TD2
      eval(['ret.SpectralFrequencyTD1 = sf' num2str(ch1) ';']);

      				%locate dw in TD2 and calculate SWH=1/dw. This avoids any unit confusions for sw.
      QTEMP2 = strmatch('dw2='  , QTEMP1);
      QTEMP2 = QTEMP1(QTEMP2, :);
      if isempty(QTEMP2)
        disp(['matNMR WARNING: in file "' QXpath QXfilename '":']);
        disp('      parameter dw2 was not found in acq file but is expected for a 2D Chemagnetics FID (see manual).');
        ret.SweepWidthTD1 = 1;
    
      else
        QTEMP3 = findstr(QTEMP2, 'u')-1;	%remove the time unit to avoid an error
        QTEMP2 = [QTEMP2(1:QTEMP3) '*1e-6'];
        eval([QTEMP2 ';']);
        ret.SweepWidthTD1 = 1/dw2/1000;
      end

				%set the flag for FID in TD2
      ret.FIDstatusTD1 = 2;
    end
end

    
%
%Perform a size check to see if all is fine. If not then the action will be aborted
%
%exception: VNMR since I cannot read the domain sizes from the parameter file.
%
if (QDataFormat ~= 5)		%don't do this for the VNMR format
  if (QDataFormat == 9)		%the JEOL Generic format uses 64-bit floats
    ByteFactor = 8;

  else				%whereas all other formats use 32-bit floats or integers
    ByteFactor = 4;
  end

  if (QSizeTD1 > 1)           %only do this for 2D's
    %
    %The following piece SHOULD not be needed to properly read 2D binary FID's, but
    %it IS in principal possible that the user has programmed a 2D in a non-standard
    %way. And then the size check can be wrong even though there is nothing wrong in
    %principal. So I decided to put this in. It doesn't harm.
    %
    %Given the fact that we cannot see from most parameter files whether a 2D experiment 
    %was done using States or TPPI or whatever, we can use the size of the file. If the
    %size we have determined is half the size of what the total number of points in the
    %FID file is, then we change the domain sizes such that Qfidread and QfidreadSeries
    %still function properly. 
    %For all Bruker formats QSizeTD1 is multiplied by 2.
    %For the Chemagnetics format QSizeTD2 is multiplied by 2.
    %
    %NOTE: this is not needed for the JEOL Generic format since there we should be able
    %      to get this information from the parameter file
    %
    QTEMP2 = dir([QXpath filesep QXfilename]);
    if isempty(QTEMP2)
      error(['matNMR WARNING: file "' QXpath filesep QXfilename '" could not be found! Aborting ...'])

    else
     if (((QTEMP2.bytes) / (QSizeTD2*QSizeTD1*ByteFactor)) == 2)
        switch QDataFormat
          case 1                      %XWINNMR format
            QSizeTD1 = QSizeTD1 * 2;
  
          case 2                      %Chemagnetics format
            QSizeTD2 = QSizeTD2 * 2;
  
          case 3                      %WINNMR format
            QSizeTD1 = QSizeTD1 * 2;
  
          case 4                      %UXNMR format
            QSizeTD1 = QSizeTD1 * 2;
        end
      end
    end
  end


  %
  %perform the size check --> only report problem if file size is smaller than the requested number of points
  %
  QTEMP2 = dir([QXpath filesep QXfilename]);
  if ~isempty(QTEMP2)
    if (QSizeTD2*QSizeTD1*ByteFactor > QTEMP2.bytes)
     disp(['matNMR WARNING: in file "' QXpath QXfilename '":']);
      disp('      TD sizes in parameter files do not match the file size');
      ret = [];

    elseif ((QDataFormat == 1) & (ceil(QSizeTD2/BufferSizeBruker)*BufferSizeBruker*QSizeTD1*ByteFactor ~= QTEMP2.bytes))
      %
      %previously the buffer size for Bruker was not taken into account. Hence this may not be needed anymore!
      %
      QSizeTD2(2) = QTEMP2.bytes / (QSizeTD1*ByteFactor)
    end
  
  else
    disp('matNMR NOTICE: file doesn''t exist. Aborting ...');
    ret = [];
  end
end
