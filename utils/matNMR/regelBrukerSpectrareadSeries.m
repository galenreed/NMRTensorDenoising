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
%
%
% matNMR v. 3.9.0 - A processing toolbox for NMR/EPR under MATLAB
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
%regelBrukerSpectrareadSeries.m reads a series of binary Bruker spectrum files from disk.
%2-4-'97

try
  if (QmatNMR.buttonList == 1)				%OK-button 
    watch;
    disp('Please wait while matNMR is reading the spectrum ...');
  
  %
  %retrieve common part of the filename and the range
  %
    QmatNMR.Fname = QmatNMR.uiInput1;
    QTEMP = findstr(QmatNMR.Fname, filesep);		%extract the filename and path depending on the platform
    QmatNMR.Xpath = deblank(QmatNMR.uiInput1(1:QTEMP(length(QTEMP))));
    QmatNMR.Xfilename = deblank(QmatNMR.uiInput1((QTEMP(length(QTEMP))+1):length(QmatNMR.uiInput1)));
    
  
    QmatNMR.FIDRangeIn = QmatNMR.uiInput2;
  
  
  %
  %retrieve the common part of the variable name and the range
  %
    QmatNMR.namelast = QmatNMR.uiInput3;
    QmatNMR.FIDRangeOut = QmatNMR.uiInput4;
  
    QmatNMR.ReadImaginaryFlag = QmatNMR.uiInput11;
    QmatNMR.ReadParameterFilesFlag = QmatNMR.uiInput12;
  
    %
    %Now that all input parameters have been read we need to check whether the range for 
    %the variable names is equal or longer than for the file names
    %
    eval(['QTEMP6 = (length([' QmatNMR.FIDRangeIn ']) > length([' QmatNMR.FIDRangeOut ']));']);
    if (QTEMP6)
      error('matNMR ERROR: range for variable names is too short!');
    end
  
  
  
    %
    %Now we perform a loop over the range of the file names and execute the lot
    %
    eval(['QTEMP6 = [' QmatNMR.FIDRangeIn '];']);
    eval(['QTEMP7 = [' QmatNMR.FIDRangeOut '];']);
    for QTEMP3 = 1:length(QTEMP6)
      %the file names and paths are determined here
      QTEMP4 = strrep(QmatNMR.Fname, '$#$', num2str(QTEMP6(QTEMP3), 10));
      QTEMP = findstr(QTEMP4, filesep);		%extract the filename and path depending on the platform
      QTEMP11 = deblank(QTEMP4(1:QTEMP(length(QTEMP))));
      QTEMP12 = deblank(QTEMP4((QTEMP(length(QTEMP))+1):length(QTEMP4)));
  
      %the variable names, which we make global
      QTEMP5 = strrep(QmatNMR.namelast, '$#$', num2str(QTEMP7(QTEMP3), 10));
      eval(['global ' QTEMP5]);
  
  
      %
      %First we check out the parameter files for this iteration
      %
      if (QmatNMR.ReadParameterFilesFlag)	%use standard parameter files for sizes etc
        QTEMP1 = DetermineBrukerSpectraRead(QTEMP11);
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
        if ((QmatNMR.uiInput5(length(QmatNMR.uiInput5)) == 'k') | (QmatNMR.uiInput5(length(QmatNMR.uiInput5)) == 'K'))
          QmatNMR.size1last = round( str2num(QmatNMR.uiInput5(1:(length(QmatNMR.uiInput5)-1))) * 1024 );
        else
          QmatNMR.size1last = round(str2num(QmatNMR.uiInput5));
        end
      
      
      %
      %
      %
        if ((QmatNMR.uiInput3(length(QmatNMR.uiInput6)) == 'k') | (QmatNMR.uiInput6(length(QmatNMR.uiInput6)) == 'K'))
          QmatNMR.size2last = round( str2num(QmatNMR.uiInput6(1:(length(QmatNMR.uiInput6)-1))) * 1024 );
        else
          QmatNMR.size2last = round(str2num(QmatNMR.uiInput6));
        end
      
      
      %
      %
      %
        if ((QmatNMR.uiInput7(length(QmatNMR.uiInput7)) == 'k') | (QmatNMR.uiInput7(length(QmatNMR.uiInput7)) == 'K'))
          QmatNMR.BlockingTD2 = round( str2num(QmatNMR.uiInput7(1:(length(QmatNMR.uiInput7)-1))) * 1024 );
        else
          QmatNMR.BlockingTD2 = round(str2num(QmatNMR.uiInput7));
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
        if ((QmatNMR.uiInput8(length(QmatNMR.uiInput8)) == 'k') | (QmatNMR.uiInput8(length(QmatNMR.uiInput8)) == 'K'))
          QmatNMR.BlockingTD1 = round( str2num(QmatNMR.uiInput8(1:(length(QmatNMR.uiInput8)-1))) * 1024 );
        else
          QmatNMR.BlockingTD1 = round(str2num(QmatNMR.uiInput8));
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
        QmatNMR.BrukerByteOrdering = QmatNMR.uiInput9;
      
      
        %
        %The FID status in the indirect dimension
        %
        QmatNMR.BrukerFIDstatus = QmatNMR.uiInput10;
        if (QmatNMR.BrukerFIDstatus == 2)	%FID
          QTEMP1(6) = 2;
        end
      end
  
  
      %
      %next we see whether we need to read in the imaginary parts as well
      %
      if (QmatNMR.ReadImaginaryFlag) 	%try to read the imaginary parts as well?
        if strcmp(QTEMP12, '1r')
          %check whether the imaginary parts exist on disk
          QTEMP21 = QTEMP4;
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
    
        elseif strcmp(QTEMP12, '2rr')
          %check whether the imaginary parts exist on disk
          %In principal there are the 2ri, 2ir and 2ii files to look for in case of hypercomplex spectra
          %If only 2ii is found then a non-hypercomplex matrix is assumed
          QTEMP21 = QTEMP4;
          QTEMP21(end-2:end) = '2ir';
          QTEMP22 = QTEMP4;
          QTEMP22(end-2:end) = '2ri';
          QTEMP23 = QTEMP4;
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
        eval([QTEMP5 ' = readBrukerProcessedData(''' QTEMP4 ''', QmatNMR.size1last, QmatNMR.size2last, QTEMP8, QTEMP9, QmatNMR.BrukerByteOrdering);']);
  
        if (QTEMP20 == 0)		%ignore all imaginary parts
          if (QTEMP1(6))		%if asked for reverse the spectrum
            eval([QTEMP5 ' = flipud(' QTEMP5 ');']);
          end
        
        elseif (QTEMP20 == 1)		%1D spectrum
          QTEMP21 = QTEMP4;
  	QTEMP21(end-1:end) = '1i';
          eval(['QTEMP21 = readBrukerProcessedData(QTEMP21, QmatNMR.size1last, QmatNMR.size2last, QTEMP8, QTEMP9, QmatNMR.BrukerByteOrdering);']);
          %add the imaginary part to the matrix
          eval([QTEMP5 ' = ' QTEMP5 ' + sqrt(-1)*QTEMP21;']);
  
          if (QTEMP1(6))		%if asked for reverse the spectrum
            eval([QTEMP5 ' = flipud(' QTEMP5 ');']);
          end
  
        elseif (QTEMP20 == 2) 	%2D spectrum with hypercomplex parts
          %first create a matNMR structure to accomodate the hypercomplex part
          eval(['QTEMP21 = ' QTEMP5 ';']);
          eval([QTEMP5 ' = GenerateMatNMRStructure;']);
          %then define the imaginary part and add that to the already-loaded real part
          QTEMP22 = QTEMP4;
  	QTEMP22(end-2:end) = '2ir';
          eval([QTEMP5 '.Spectrum = QTEMP21 + sqrt(-1)*readBrukerProcessedData(QTEMP22, QmatNMR.size1last, QmatNMR.size2last, QTEMP8, QTEMP9, QmatNMR.BrukerByteOrdering);']);
  
          %finally define the hypercomplex parts
          QTEMP21 = QTEMP4;
  	QTEMP21(end-2:end) = '2ri';
          QTEMP22 = QTEMP4;
  	QTEMP22(end-2:end) = '2ii';
          eval([QTEMP5 '.Hypercomplex = readBrukerProcessedData(QTEMP21, QmatNMR.size1last, QmatNMR.size2last, QTEMP8, QTEMP9, QmatNMR.BrukerByteOrdering) + sqrt(-1)*readBrukerProcessedData(QTEMP22, QmatNMR.size1last, QmatNMR.size2last, QTEMP8, QTEMP9, QmatNMR.BrukerByteOrdering);']);
  
          %set the carrier index for the default axis
          eval([QTEMP5 '.DefaultAxisCarrierIndexTD2 = floor(QmatNMR.size1last/2)+1;']);
          eval([QTEMP5 '.DefaultAxisCarrierIndexTD1 = floor(QmatNMR.size2last/2)+1;']);
  
          %store the file name in the structure
          eval([QTEMP5 '.DataPath = QmatNMR.Xpath;']);
          eval([QTEMP5 '.DataFile = QTEMP4;']);
  
          %set the FID status in TD2
          eval([QTEMP5 '.FIDstatusTD2 = 1;']);
          eval([QTEMP5 '.FIDstatusTD1 = 1;']);
  
          %reverse spectrum is asked for
          if (QTEMP1(6) == 1)		%if asked for reverse the spectrum
            eval([QTEMP5 '.Spectrum = flipud(' QTEMP5 '.Spectrum);']);
            eval([QTEMP5 '.Hypercomplex = flipud(' QTEMP5 '.Hypercomplex);']);
      	
          elseif (QTEMP1(6) == 2) 	%set status to FID
            eval([QTEMP5 '.Spectrum = flipud(' QTEMP5 '.Spectrum);']);
            eval([QTEMP5 '.Hypercomplex = flipud(' QTEMP5 '.Hypercomplex);']);
            eval([QTEMP5 '.FIDstatusTD1 = 2;']);
          end
  
        elseif (QTEMP20 == 3) 	%2D spectrum without hypercomplex parts
          %first create a matNMR structure to accomodate the hypercomplex part
          eval(['QTEMP21 = ' QTEMP5 ';']);
          eval([QTEMP5 ' = GenerateMatNMRStructure;']);
          %then define the imaginary part and add that to the already-loaded real part
          QTEMP22 = QTEMP4;
  	QTEMP22(end-2:end) = '2ii';
          eval([QTEMP5 '.Spectrum = QTEMP21 + sqrt(-1)*readBrukerProcessedData(QTEMP22, QmatNMR.size1last, QmatNMR.size2last, QTEMP8, QTEMP9, QmatNMR.BrukerByteOrdering);']);
  
          %set the carrier index for the default axis
          eval([QTEMP5 '.DefaultAxisCarrierIndexTD2 = floor(QmatNMR.size1last/2)+1;']);
          eval([QTEMP5 '.DefaultAxisCarrierIndexTD1 = floor(QmatNMR.size2last/2)+1;']);
  
          %store the file name in the structure
          eval([QTEMP5 '.DataPath = QmatNMR.Xpath;']);
          eval([QTEMP5 '.DataFile = QTEMP4;']);
  
          %set the FID status in TD2 and TD1
          eval([QTEMP5 '.FIDstatusTD2 = 1;']);
          eval([QTEMP5 '.FIDstatusTD1 = 1;']);
  
          %reverse spectrum is asked for
          if (QTEMP1(6) == 1)		%if asked for reverse the spectrum
            eval([QTEMP5 '.Spectrum = flipud(' QTEMP5 '.Spectrum);']);
      	
          elseif (QTEMP1(6) == 2) 	%set status to FID
            eval([QTEMP5 '.Spectrum = flipud(' QTEMP5 '.Spectrum);']);
            eval([QTEMP5 '.FIDstatusTD1 = 2;']);
          end
        end
      
      else				%spectral parameters found -> result is a matNMR structure
        eval([QTEMP5 ' = GenerateMatNMRStructure;']);
        eval([QTEMP5 '.SpectralFrequencyTD2 = QTEMP1(7);']);
        eval([QTEMP5 '.SweepWidthTD2 = QTEMP1(8);']);
        if (length(QTEMP1) > 8)
          eval([QTEMP5 '.SpectralFrequencyTD1 = QTEMP1(9);']);
          eval([QTEMP5 '.SweepWidthTD1 = QTEMP1(10);']);
        end
        eval([QTEMP5 '.Spectrum = readBrukerProcessedData(''' QTEMP4 ''', QmatNMR.size1last, QmatNMR.size2last, QTEMP8, QTEMP9, QmatNMR.BrukerByteOrdering);']);
  
        %set the carrier index for the default axis
        eval([QTEMP5 '.DefaultAxisCarrierIndexTD2 = floor(QmatNMR.size1last/2)+1;']);
        eval([QTEMP5 '.DefaultAxisCarrierIndexTD1 = floor(QmatNMR.size2last/2)+1;']);
  
        %store the file name in the structure
        eval([QTEMP5 '.DataPath = QmatNMR.Xpath;']);
        eval([QTEMP5 '.DataFile = QTEMP4;']);
  
        %set the FID status in TD2 and TD1
        eval([QTEMP5 '.FIDstatusTD2 = 1;']);
        eval([QTEMP5 '.FIDstatusTD1 = 1;']);
        
        if (QTEMP20 == 0)		%ignore all imaginary parts
          if (QTEMP1(6) == 1)		%if asked for reverse the spectrum
            eval([QTEMP5 '.Spectrum = flipud(' QTEMP5 '.Spectrum);']);
  	
          elseif (QTEMP1(6) == 2) 		%reverse and set status to FID
            eval([QTEMP5 '.Spectrum = flipud(' QTEMP5 '.Spectrum);']);
            eval([QTEMP5 '.FIDstatusTD1 = 2;']);
          end
  
        elseif (QTEMP20 == 1)		%1D spectrum
          QTEMP21 = QTEMP4;
  	QTEMP21(end-1:end) = '1i';
          eval([QTEMP5 '.Spectrum = ' QTEMP5 '.Spectrum + sqrt(-1)*readBrukerProcessedData(QTEMP21, QmatNMR.size1last, QmatNMR.size2last, QTEMP8, QTEMP9, QmatNMR.BrukerByteOrdering);']);
  
          if (QTEMP1(6) == 1)		%if asked for reverse the spectrum
            eval([QTEMP5 '.Spectrum = flipud(' QTEMP5 '.Spectrum);']);
      	
          elseif (QTEMP1(6) == 2) 	%set status to FID
            eval([QTEMP5 '.Spectrum = flipud(' QTEMP5 '.Spectrum);']);
            eval([QTEMP5 '.FIDstatusTD1 = 2;']);
          end
  
        elseif (QTEMP20 == 2) 	%2D spectrum with hypercomplex parts
          %then define the imaginary part and add that to the already-loaded real part
          QTEMP22 = QTEMP4;
  	QTEMP22(end-2:end) = '2ir';
          eval([QTEMP5 '.Spectrum = ' QTEMP5 '.Spectrum + sqrt(-1)*readBrukerProcessedData(QTEMP22, QmatNMR.size1last, QmatNMR.size2last, QTEMP8, QTEMP9, QmatNMR.BrukerByteOrdering);']);
  
          %finally define the hypercomplex parts
          QTEMP21 = QTEMP4;
  	QTEMP21(end-2:end) = '2ri';
          QTEMP22 = QTEMP4;
  	QTEMP22(end-2:end) = '2ii';
          eval([QTEMP5 '.Hypercomplex = readBrukerProcessedData(QTEMP21, QmatNMR.size1last, QmatNMR.size2last, QTEMP8, QTEMP9, QmatNMR.BrukerByteOrdering) + sqrt(-1)*readBrukerProcessedData(QTEMP22, QmatNMR.size1last, QmatNMR.size2last, QTEMP8, QTEMP9, QmatNMR.BrukerByteOrdering);']);
  
          %reverse spectrum is asked for
          if (QTEMP1(6) == 1)		%if asked for reverse the spectrum
            eval([QTEMP5 '.Spectrum = flipud(' QTEMP5 '.Spectrum);']);
            eval([QTEMP5 '.Hypercomplex = flipud(' QTEMP5 '.Hypercomplex);']);
      	
          elseif (QTEMP1(6) == 2) 	%set status to FID
            eval([QTEMP5 '.Spectrum = flipud(' QTEMP5 '.Spectrum);']);
            eval([QTEMP5 '.Hypercomplex = flipud(' QTEMP5 '.Hypercomplex);']);
            eval([QTEMP5 '.FIDstatusTD1 = 2;']);
          end
  
        elseif (QTEMP20 == 3) 	%2D spectrum without hypercomplex parts
          %then define the imaginary part and add that to the already-loaded real part
          QTEMP22 = QTEMP4;
  	QTEMP22(end-2:end) = '2ii';
          eval([QTEMP5 '.Spectrum = ' QTEMP5 '.Spectrum + sqrt(-1)*readBrukerProcessedData(QTEMP22, QmatNMR.size1last, QmatNMR.size2last, QTEMP8, QTEMP9, QmatNMR.BrukerByteOrdering);']);
  
          %reverse spectrum is asked for
          if (QTEMP1(6) == 1)		%if asked for reverse the spectrum
            eval([QTEMP5 '.Spectrum = flipud(' QTEMP5 '.Spectrum);']);
      	
          elseif (QTEMP1(6) == 2) 	%set status to FID
            eval([QTEMP5 '.Spectrum = flipud(' QTEMP5 '.Spectrum);']);
            eval([QTEMP5 '.FIDstatusTD1 = 2;']);
          end
        end
      end
    
      QmatNMR.newinlist.Spectrum = QTEMP5;
      if (QmatNMR.size2last == 1)
        QmatNMR.newinlist.Axis = '';
        putinlist1d;
  
      else
        QmatNMR.newinlist.AxisTD2 = '';
        QmatNMR.newinlist.AxisTD1 = '';
        putinlist2d;
      end    
    
      disp(['Finished loading Bruker spectrum ', QTEMP4, '. (', num2str(QmatNMR.size1last), ' x ', num2str(QmatNMR.size2last), ' points).']);
      disp(['The spectrum was saved in workspace as: ' QTEMP5]);
    end
      
    Arrowhead;
  
  else
    disp('Reading of Series of Bruker Spectra cancelled ...');
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
