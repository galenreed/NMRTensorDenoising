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
%
%regelQfidreadSeries.m reads a series of binary FID files from disk.
%06-11-'01

try
  if (QmatNMR.buttonList == 1)				%OK-button 
    watch;
    disp('Please wait while matNMR is reading the binary FID files ...');
  
  %
  %retrieve common part of the filename and the range
  %
    QmatNMR.Fname = QmatNMR.uiInput1;
    QmatNMR.FIDRangeIn = QmatNMR.uiInput2;			%range of the series
  
    
  %
  %retrieve the common part of the output variable names and the corresponding range
  %
    QmatNMR.namelast = QmatNMR.uiInput3;
    QmatNMR.FIDRangeOut = QmatNMR.uiInput4;
    
      
  %
  %check out the domain sizes
  %
    QTEMP9 = length(QmatNMR.uiInput5);
    if ((QmatNMR.uiInput5(QTEMP9) == 'k') | (QmatNMR.uiInput5(QTEMP9) == 'K'))
      QmatNMR.T2 = round(str2num(QmatNMR.uiInput5(1:(QTEMP9-1))) * 1024 );
    else
      QmatNMR.T2 = round(str2num(QmatNMR.uiInput5));
    end
  
    QTEMP9 = length(QmatNMR.uiInput6);
    if ((QmatNMR.uiInput6(QTEMP9) == 'k') | (QmatNMR.uiInput6(QTEMP9) == 'K'))
      QmatNMR.T1 = round(str2num(QmatNMR.uiInput6(1:(QTEMP9-1))) * 1024 );
    else
      QmatNMR.T1 = round(str2num(QmatNMR.uiInput6));
    end
  
  
    QmatNMR.DataFormat = QmatNMR.uiInput7;		%what format to read in
    QmatNMR.ReadParameterFilesFlag = QmatNMR.uiInput8;	%do we read in the original parameter files?
    QmatNMR.LoadINTOmatNMRDirectly = QmatNMR.uiInput9; 	%load into matNMR directly?
  
    
    
  
  %
  %Now that all input parameters have been read we need to check whether the range for 
  %the variable names is equal or longer than for the file names
  %
    eval(['QmatNMR.SeriesRangeIn = (length([' QmatNMR.FIDRangeIn ']) > length([' QmatNMR.FIDRangeOut ']));']);
    if (QmatNMR.SeriesRangeIn)
      error('matNMR ERROR: range for variable names is too short!');
    end
  
  
  
  
  
  
  
  %
  %Now we perform a loop over the range of the file names and execute the lot
  %
    eval(['QmatNMR.SeriesRangeIn = [' QmatNMR.FIDRangeIn '];']);
    eval(['QmatNMR.SeriesRangeOut = [' QmatNMR.FIDRangeOut '];']);
    for QTEMP3 = 1:length(QmatNMR.SeriesRangeIn)
      %
      %create the file name for the current element of the series
      %
      QmatNMR.SeriesName = strrep(QmatNMR.Fname, '$#$', num2str(QmatNMR.SeriesRangeIn(QTEMP3), 10));
  
      %
      %separate the path and file names
      %
      QTEMP = findstr(QmatNMR.SeriesName, filesep);		%extract the filename and path depending on the platform
  
      %
      %the path and file name
      %
      QmatNMR.Xpath = deblank(QmatNMR.SeriesName(1:QTEMP(length(QTEMP))));
      QmatNMR.Xfilename = deblank(QmatNMR.SeriesName((QTEMP(length(QTEMP))+1):length(QmatNMR.SeriesName)));
      %check whether the file really exists. If not then skip this one and go to the next
      QmatNMR.SeriesFileName = dir([QmatNMR.Xpath QmatNMR.Xfilename]);
      if isempty(QmatNMR.SeriesFileName)
        disp('');
        disp(['matNMR NOTICE: file doesn''t exist. Aborting reading of binary FID "' QmatNMR.Xpath QmatNMR.Xfilename '" ...']);
        disp('');
        beep
  
      else
        %
        %create the variable name for the current element of the series
        %
        QmatNMR.SeriesFileName = strrep(QmatNMR.namelast, '$#$', num2str(QmatNMR.SeriesRangeOut(QTEMP3), 10));
    
        %
        %this reads in the parameter files for each entry in the series.
        %
        QmatNMR.SeriesFlag1 = [];	%this will contain the parameters if the user has asked for them to be read
        QmatNMR.SeriesFlag2 = 1; 	%status flag which denotes whether all is fine
        switch QmatNMR.DataFormat		%define the output slightly different for each data format
        				%and if needed read in the parameter files
          case 1
            QmatNMR.SeriesDataFormat = 'XWinNMR / TopSpin';
      
            if QmatNMR.ReadParameterFilesFlag
              [QmatNMR.SeriesFlag1, QmatNMR.T2, QmatNMR.T1, QmatNMR.ByteOrder] = QReadParameterFiles(QmatNMR.DataFormat, QmatNMR.Xpath, QmatNMR.Xfilename);
      	
              if ~isempty(QmatNMR.SeriesFlag1)	%parameters have been found
                eval([QmatNMR.SeriesFileName '= QmatNMR.SeriesFlag1;']);
      
              else
                disp('matNMR WARNING: no or incorrect parameter files found. Reading of FID aborted.');
                QmatNMR.SeriesFlag2 = 0;
              end
            end
        
          case 2
            QmatNMR.SeriesDataFormat = 'Chemagnetics';
      
            if QmatNMR.ReadParameterFilesFlag
              [QmatNMR.SeriesFlag1, QmatNMR.T2, QmatNMR.T1, QmatNMR.ByteOrder] = QReadParameterFiles(QmatNMR.DataFormat, QmatNMR.Xpath, QmatNMR.Xfilename);
      	
              if ~isempty(QmatNMR.SeriesFlag1)	%parameters have been found
                eval([QmatNMR.SeriesFileName '= QmatNMR.SeriesFlag1;']);
      
              else
                disp('matNMR WARNING: no or incorrect parameter files found. Reading of FID aborted.');
                QmatNMR.SeriesFlag2 = 0;
              end
            end
      
          case 3
            QmatNMR.SeriesDataFormat = 'winNMR';
      
            if QmatNMR.ReadParameterFilesFlag
              [QmatNMR.SeriesFlag1, QmatNMR.T2, QmatNMR.T1, QmatNMR.ByteOrder] = QReadParameterFiles(1, QmatNMR.Xpath, QmatNMR.Xfilename);
      	
              if ~isempty(QmatNMR.SeriesFlag1)	%parameters have been found
                eval([QmatNMR.SeriesFileName '= QmatNMR.SeriesFlag1;']);
      
              else
                disp('matNMR WARNING: no or incorrect parameter files found. Reading of FID aborted.');
                QmatNMR.SeriesFlag2 = 0;
              end
            end
      
          case 4
            QmatNMR.SeriesDataFormat = 'UXNMR';
      
            if QmatNMR.ReadParameterFilesFlag
              [QmatNMR.SeriesFlag1, QmatNMR.T2, QmatNMR.T1, QmatNMR.ByteOrder] = QReadParameterFiles(1, QmatNMR.Xpath, QmatNMR.Xfilename);
      	
              if ~isempty(QmatNMR.SeriesFlag1)	%parameters have been found
                eval([QmatNMR.SeriesFileName '= QmatNMR.SeriesFlag1;']);
      
              else
                disp('matNMR WARNING: no or incorrect parameter files found. Reading of FID aborted.');
                QmatNMR.SeriesFlag2 = 0;
              end
            end
      
          case 5
            QmatNMR.SeriesDataFormat = 'VNMR';
      
            if QmatNMR.ReadParameterFilesFlag
              [QmatNMR.SeriesFlag1, QmatNMR.T2, QmatNMR.T1, QmatNMR.ByteOrder] = QReadParameterFiles(QmatNMR.DataFormat, QmatNMR.Xpath, QmatNMR.Xfilename);
      	
              if ~isempty(QmatNMR.SeriesFlag1)	%parameters have been found
                eval([QmatNMR.SeriesFileName '= QmatNMR.SeriesFlag1;']);
      
              else
                disp('matNMR WARNING: no or incorrect parameter files found. Reading of FID aborted.');
                QmatNMR.SeriesFlag2 = 0;
              end
            end
      
          case 6
            QmatNMR.SeriesDataFormat = 'MacNMR';
      
          case 7
            QmatNMR.SeriesDataFormat = 'NTNMR';
      
          case 8
            QmatNMR.SeriesDataFormat = 'Aspect 2000/3000';
      
          case 9
            QmatNMR.SeriesDataFormat = 'JEOL Generic';
      
            if QmatNMR.ReadParameterFilesFlag
              [QmatNMR.SeriesFlag1, QmatNMR.T2, QmatNMR.T1, QmatNMR.ByteOrder] = QReadParameterFiles(QmatNMR.DataFormat, QmatNMR.Xpath, QmatNMR.Xfilename);
      	
              if ~isempty(QmatNMR.SeriesFlag1)	%parameters have been found
                eval([QmatNMR.SeriesFileName '= QmatNMR.SeriesFlag1;']);
      
              else
                disp('matNMR WARNING: no or incorrect parameter files found. Reading of FID aborted.');
                QmatNMR.SeriesFlag2 = 0;
              end
            end
    
      
          case 10
            QmatNMR.SeriesDataFormat = 'SMIS';
    
          case 11
            QmatNMR.SeriesRangeOut = 'CMXW';
      
            if QmatNMR.ReadParameterFilesFlag
              [QmatNMR.SeriesFlag1, QmatNMR.T2, QmatNMR.T1, QmatNMR.ByteOrder] = QReadParameterFiles(QmatNMR.DataFormat, QmatNMR.Xpath, QmatNMR.Xfilename);
      	
              if ~isempty(QmatNMR.SeriesFlag1)	%parameters have been found
                eval([QmatNMR.SeriesFileName '= QmatNMR.SeriesFlag1;']);
    
              else
                disp('matNMR WARNING: no or incorrect parameter files found. Reading of FID aborted.');
                QmatNMR.SeriesFlag2 = 0;
              end
            end
    
          otherwise
            QmatNMR.SeriesDataFormat = 'unknown file format';
        end
    
    
        %
        %Make sure of even domain size for TD2
        %
        if ((QmatNMR.DataFormat == 1) | (QmatNMR.DataFormat == 2) | (QmatNMR.DataFormat == 3) | (QmatNMR.DataFormat == 4) | (QmatNMR.DataFormat == 9))
          if (QmatNMR.T2 ~= 2*round(QmatNMR.T2/2))
            beep
            disp('matNMR WARNING: only even numbers allowed for size in TD2 (implicit assumption of complex data). Aborting ...');
            QmatNMR.SeriesFlag2 = 0;
          end
        end
    
    
        %
        %check whether all is fine so far
        %
        if (QmatNMR.SeriesFlag2)
          %
          %based on user input, or the parameter files, define these variables for askfidlaad
          %
          QmatNMR.size1last = QmatNMR.T2;
          QmatNMR.size2last = QmatNMR.T1;
      
      
          %
          %first make the variable global and then read in the FID
          %
          eval(['global ' QmatNMR.SeriesFileName]);
          if isempty(QmatNMR.SeriesFlag1)		%the user has not asked for the parameter files to be read in, hence the output
          				%variable is not a structure, unless created by Qfidread
            eval(['[' QmatNMR.SeriesFileName ', QmatNMR.T2, QmatNMR.T1] = Qfidread(''' QmatNMR.SeriesName ''', QmatNMR.T2, QmatNMR.T1, QmatNMR.DataFormat, QmatNMR.ByteOrder);']);
      
          else				%parameter files have been read are seem to be in order
            eval(['[QTEMP8, QmatNMR.T2, QmatNMR.T1] = Qfidread(''' QmatNMR.SeriesName ''', QmatNMR.T2, QmatNMR.T1, QmatNMR.DataFormat, QmatNMR.ByteOrder);']);
            eval([QmatNMR.SeriesFileName '.Spectrum = QTEMP8;']);
  
            eval([QmatNMR.SeriesFileName '.DataPath = QmatNMR.Xpath;']);
            eval([QmatNMR.SeriesFileName '.DataFile = QmatNMR.SeriesName;']);
          end
      
      
          %
          %put the variable name in the list of last variables
          %
          QmatNMR.newinlist.Spectrum = QmatNMR.SeriesFileName;
          if (QmatNMR.T1 == 1)		%1D variable
            QmatNMR.newinlist.Axis = '';
            putinlist1d;
        
          else			%2D variable
            QmatNMR.newinlist.AxisTD2 = '';
            QmatNMR.newinlist.AxisTD1 = '';
            putinlist2d;
          end    
          
          disp(['Finished loading binary ' QmatNMR.SeriesDataFormat ' FID file "', QmatNMR.SeriesName , '". (', num2str(QmatNMR.T2/2), ' x ', num2str(QmatNMR.T1), ' points).']);
          disp(['The FID was saved in workspace as: ' QmatNMR.SeriesFileName]);
        end
        Arrowhead;
      
      
        %
        %remember the file name as it was given by the user for the next time a binary FID needs to be read
        %
        QTEMP = findstr(QmatNMR.Fname, filesep);		%extract the filename and path depending on the platform
        QTEMP9 = length(QTEMP);
        QmatNMR.Xpath = deblank(QmatNMR.Fname(1:QTEMP(QTEMP9))); 			      	%the path
        QmatNMR.Xfilename = deblank(QmatNMR.Fname((QTEMP(QTEMP9)+1):length(QmatNMR.Fname)));       %the file name
      end
    end
  
  
  
  
  
    %
    %finish by loading the spectrum into matNMR, if asked for
    %
    if (QmatNMR.LoadINTOmatNMRDirectly)
      %
      %load the new FID into matNMR
      %
      disp(['Loading the FID into matNMR ...']);
  
      QmatNMR.uiInput1 = strrep(QmatNMR.namelast, '$#$', num2str(QmatNMR.SeriesRangeOut(1)));
      QmatNMR.uiInput2 = '';
      QmatNMR.uiInput3 = '';
        
      %
      %automatically load this variable as an FID into matNMR
      %
      QmatNMR.ask = 2;
      QmatNMR.buttonList = 1;
      regelnaam
    end
  
  
  else
    disp('Reading of series of binary FIDs cancelled ...');
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
