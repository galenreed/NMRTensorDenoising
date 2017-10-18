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
%regelCMXSpectrareadSeries.m reads a series of binary Chemagnetics spectra files from disk.
%23-05-'05

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
    QmatNMR.ReadParameterFilesFlag = QmatNMR.uiInput7;
  
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
  
      %the variable names, which we make global
      QTEMP5 = strrep(QmatNMR.namelast, '$#$', num2str(QTEMP7(QTEMP3), 10));
      eval(['global ' QTEMP5]);
  
  
      %
      %First we check out the parameter files for this iteration
      %
      if (QmatNMR.ReadParameterFilesFlag)	%use standard parameter files for sizes etc
        QTEMP1 = DetermineCMXSpectraRead(QTEMP11);
        QmatNMR.size1last = QTEMP1(1);
        QmatNMR.size2last = QTEMP1(2);
        QmatNMR.FTinTD1 = QTEMP1(3);
  
      else		%manual input of the parameters
        QTEMP1 = zeros(1, 3); 	%reset the vector used for automatically-read parameters
        if ((QmatNMR.uiInput2(length(QmatNMR.uiInput2)) == 'k') | (QmatNMR.uiInput2(length(QmatNMR.uiInput2)) == 'K'))
          QmatNMR.size1last = round( str2num(QmatNMR.uiInput2(1:(length(QmatNMR.uiInput2)-1))) * 1024 );
        else
          QmatNMR.size1last = round(str2num(QmatNMR.uiInput2));
        end
  
        if ((QmatNMR.uiInput3(length(QmatNMR.uiInput3)) == 'k') | (QmatNMR.uiInput3(length(QmatNMR.uiInput3)) == 'K'))
          QmatNMR.size2last = round( str2num(QmatNMR.uiInput3(1:(length(QmatNMR.uiInput3)-1))) * 1024 );
        else
          QmatNMR.size2last = round(str2num(QmatNMR.uiInput3));
        end
  
        QmatNMR.FTinTD1 = 0;
      end
  
  
      %
      %Next we read in the FID
      %
      if (length(QTEMP1) == 3)	%no spectral parameters found -> result is a simple matrix (except for a hypercomplex 2D matrix)
        eval([QTEMP5 ' = readCMXProcessedData(''' QTEMP4 ''', QmatNMR.size1last, QmatNMR.size2last, QmatNMR.FTinTD1);']);
  
      else				%spectral parameters found -> result is a matNMR structure
        eval([QTEMP5 ' = GenerateMatNMRStructure;']);
        eval([QTEMP5 '.SpectralFrequencyTD2 = QTEMP1(4);']);
        eval([QTEMP5 '.SweepWidthTD2 = QTEMP1(5);']);
        if (length(QTEMP1) > 5)
          eval([QTEMP5 '.SpectralFrequencyTD1 = QTEMP1(6);']);
          eval([QTEMP5 '.SweepWidthTD1 = QTEMP1(7);']);
        end
        eval([QTEMP5 '.Spectrum = readCMXProcessedData(''' QTEMP4 ''', QmatNMR.size1last, QmatNMR.size2last, QmatNMR.FTinTD1);']);
  
        %set the carrier index for the default axis
        eval([QTEMP5 '.DefaultAxisCarrierIndexTD2 = floor(QmatNMR.size1last/2)+1;']);
        eval([QTEMP5 '.DefaultAxisCarrierIndexTD1 = floor(QmatNMR.size2last/2)+1;']);
  
        %store the file name in the structure
        eval([QTEMP5 '.DataPath = QmatNMR.Xpath;']);
        eval([QTEMP5 '.DataFile = QTEMP4;']);
  
        %set the FID status in TD2 and TD1
        eval([QTEMP5 '.FIDstatusTD2 = 1;']);
        eval([QTEMP5 '.FIDstatusTD1 = 1;']);
        if (~QmatNMR.FTinTD1)
          eval([QTEMP5 '.FIDstatusTD1 = 2;']);
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
  
      disp(['Finished loading Chemagnetics spectrum ', QTEMP4, '. (', num2str(QmatNMR.size1last), ' x ', num2str(QmatNMR.size2last), ' points).']);
      disp(['The spectrum was saved in workspace as: ' QTEMP5]);
    end
  
    Arrowhead;
  
  else
    disp('Reading of Series of Chemagnetics Spectra cancelled ...');
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
