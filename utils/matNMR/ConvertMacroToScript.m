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
%ConvertMacroToScript.m analyses the processing macro for the stepwise processing routine and converts
%it into an offline processing script.
%
%17-09-'07
%

function ConvertMacroToScript

global QmatNMR QmatNMRsettings

%
%
%The following codes are used for the various matNMR functions:
%
%1D functions:
%
% code                  function
%
%    0			undo in 1D and 2D
%    1			shift data points 1D
%    2 			swap whole echo 1D
%    3			extract from 1D
%    4			set size 1D
%    5			FT 1D
%    6			FFTshift 1D
%    7 			flip l/r 1D
%    8			baseline correction peak list 1D/2D
%    9 			baseline correction finish 1D
%   10 			linear prediction 1D
%   11			apodization 1D
%   12			phase correction 1D
%   13			convert Bruker qseq data 1D
%   14			user defined axis 1D/2D
%   15                  DC offset correction 1D
%   16 			remove Bruker digital filter
%   17        		solvent suppression 1D
%   18  		concatenate 1D
%   19 			define external reference
%   20 			set integral
%   21 			regrid spectrum 1D
%   22			noise filling 1D
%   23			Cadzow filtering 1D
%   24			Cadzow filtering + LPSVD estimation 1D
%
%
%
%
%2D functions:
%
% code                  function
%
%    0			undo in 1D and 2D
%  101			FT 2D
%  102			set size 2D
%  103			shift data points
%  104 			swap whole echo
%  105			FFTshift
%  106 			flip l/r
%  107			apodization
%  108			zero part of 2D
%  109			convert Bruker qseq data 2D
%  110			convert Bruker States
%  111			convert Varian States
%  127			convert Echo / Anti-Echo
%  112			start States processing
%  113			phase correction 2D
%  114			extract from 2D
%  115			symmetrize 2D
%  116			shearing transformation
%  117			linear prediction 2D
%    8			baseline correction peak list 1D/2D
%  118 			baseline correction finish 2D
%  119			set integral 2D
%  120			transpose 2D
%  121    		DC offset correction 2D
%   14			user defined axis 1D/2D
%  122 			remove Bruker digital filter
%  123  		solvent suppression 2D
%  124 			concatenate 2D
%  125 			define external reference
%  126 			linear prediction peaklist 2D
%  128 			solvent deconvolution peaklist 2D
%  129			noise filling 2D
%  130			regrid spectrum 2D
%
%
%
%
%2D to 1D functions:
%
% code                  function
%
%  201        		diagonal
%  202       		anti-diagonal
%  203        		sum TD1
%  204      		sum TD2
%  205       		skyline projection
%
%
%
%
%3D functions:
%
% code                  function
%
%  301			define axis in 3rd dimension
%
%
%
%
%set dimension-specific parameters
%  400 			Set dimension-specific parameters
%  401 			Force update current slice in 2D
%
%
%
%User-defined functions:
%
%  666			Any function that the user wants. The command string is
%			transformed into a numeric code and can thus be saved in
%			the HistoryMacro
%  667			When reprocessing a code 666 the numbers in the history macro 
%   			are transformed to the original characters. After all 666's have 
%   			been processed a code 667 initiates the evaluation of the string.
%
%
%
%Plotting functions:
%
%  700 			horizontal stack plot
%  701 			vertical stack plot
%  702 			1D bar plot
%  703 			errorbar plot
%  704 			show sidebands
%
%  710			Used for storing selected axes
%  711 			Used for storing strings
%  712 			Evalulates stored strings
%
%  721			Axis On/Off/Etc
%  722			Clear Axis
%  723			Axis Colors
%  724			Axis Directions
%  725			Axis Labels
%  726			Axis Locations
%  727			Axis Position
%  728			Title
%  729			Box
%  730			Font Properties
%  731			Grid
%  732			Hold
%  733			Line Style
%  734			Line Width
%  735			Marker Style
%  736			Marker Size
%  737			Scaling Limits
%  738			Scaling Types
%  739			Shading
%  740			Tick Direction
%  741			Tick Labels
%  742			Tick Lengths
%  743			Tick Positions
%  744			Axis View
%  745 			Super Title
%  746 			Light
%
%  750 			Color axis
%  751 			Colour bars
%  752 			Colour map
%

%
%open the script file on disk
%
File = QmatNMR.MacroConversionVariable;
fp = fopen([File '.m'], 'w');
if (fp == -1)
  beep
  disp('matNMR WARNING: could not open the requested file. Aborting ...');
  return
end


%
%create the start of the script
%
VersionString = QmatNMR.VersionVar;
VersionString = VersionString(1:(findstr(VersionString, '(')-2));
fprintf(fp, '%% \n%% This script processes the input data DataIn and outputs a variable to the Matlab workspace.\n%% \n%% Syntax:  DataOut = %s(DataIn);\n%% \n%% Created by %s on %s\n%% \n', File, VersionString, date);
fprintf(fp, 'function DataOut = %s(DataIn)\n', File);

fprintf(fp, '  \n%% \n%%Define the output variable and axes in points.\n%% \n');
fprintf(fp, '  DataOut = GenerateMatNMRStructure;\n');
fprintf(fp, '  DataOut.Spectrum = DataIn;\n');
fprintf(fp, '  DataOut.AxisTD2 = 1:size(DataIn, 2);\n');
fprintf(fp, '  DataOut.AxisTD1 = 1:size(DataIn, 1);\n');

%
%some variables that need resetting
%
QmatNMR.BaslcorPeakList = [];
ChangeVectorOld = rand(1, 9);

%
%convert each statement to a command line in the script
%
disp('Converting macro to an independent script ... ');
for QTEMP40=2:size(QmatNMR.HistoryMacro, 1)
  switch (QmatNMR.HistoryMacro(QTEMP40, 1))
    case 0		%do the undo ... or undo the do that was
      error('matNMR NOTICE: current processing macro contains undo steps, which interferes with the conversion to a script. Aborting ...');
    
    case 1		%shift data points 1D
      fprintf(fp, '\n%% \n%% Shift data points 1D\n%% syntax: MatrixOut = matNMRLeftShift1D(MatrixIn, NrPointsToShift)\n%%');
      fprintf(fp, '\n  DataOut.Spectrum = matNMRLeftShift1D(DataOut.Spectrum, %d);\n\n', QmatNMR.HistoryMacro(QTEMP40, 2));

      
    case 2		%swap whole echo 1D  
      fprintf(fp, '\n%% \n%% Swap whole echo 1D\n%% syntax: MatrixOut = matNMRSwapEcho1D(MatrixIn, PositionEchoMaximum)\n%%');
      fprintf(fp, '\n  DataOut.Spectrum = matNMRSwapEcho1D(DataOut.Spectrum, %d);\n\n', QmatNMR.HistoryMacro(QTEMP40, 2));


    case 3		%extract from 1D
      if (QmatNMR.HistoryMacro(QTEMP40, 4) == 0) 	%no increment specified in macro
        QTEMP = [num2str(QmatNMR.HistoryMacro(QTEMP40, 2)) ':' num2str(QmatNMR.HistoryMacro(QTEMP40, 3))];

      else
        QTEMP = [num2str(QmatNMR.HistoryMacro(QTEMP40, 2)) ':' num2str(QmatNMR.HistoryMacro(QTEMP40, 4)) ':' num2str(QmatNMR.HistoryMacro(QTEMP40, 3))];
      end
      fprintf(fp, '\n%% \n%% Extract from 1D\n%% syntax: [MatrixOut, AxisOut] = matNMRExtract1D(MatrixIn, AxisIn, Range)\n%%');
      fprintf(fp, '\n  [DataOut.Spectrum, DataOut.AxisTD2] = matNMRExtract1D(DataOut.Spectrum, DataOut.AxisTD2, %s);\n\n', QTEMP);
    

    case 4		%set size 1D
      fprintf(fp, '\n%% \n%% Set size 1D\n%% syntax: MatrixOut = matNMRSetSize1D(MatrixIn, NewSize1D)\n%%');
      fprintf(fp, '\n  Size = %d;', QmatNMR.HistoryMacro(QTEMP40, 2));
      if (QmatNMR.HistoryMacro(QTEMP40, 3) ~= 5) 	%default
        fprintf(fp, '\n  DataOut.Spectrum = matNMRSetSize1D(DataOut.Spectrum, Size);\n\n');
      else 						%whole-echo processing
        fprintf(fp, '\n  DataOut.Spectrum = matNMRSetSize1D(DataOut.Spectrum, Size, 1);\n\n');
      end

      
    case 5		%FT 1D
      fprintf(fp, '\n%% \n%% Fourier Transform 1D\n%% syntax: MatrixOut = matNMRFT1D(MatrixIn, FTtype, MultiplyByHalf, InverseFT)\n%%');
      QTEMP = str2mat('Complex FT', 'Real FT', 'States', 'TPPI', 'Whole Echo', 'States-TPPI', 'Bruker qseq', 'Sine FT');
      fprintf(fp, '\n  %% Type = %s', deblank(QTEMP(QmatNMR.HistoryMacro(QTEMP40, 2), :)));
      if ((QmatNMR.HistoryMacro(QTEMP40, 2) == 1) | (QmatNMR.HistoryMacro(QTEMP40, 2) == 3) | (QmatNMR.HistoryMacro(QTEMP40, 2) == 5) | (QmatNMR.HistoryMacro(QTEMP40, 2) == 6))
        QTEMP = 1;	%use complex FT for complex, States, whole-echo and States-TPPI
      end
      if (QmatNMR.HistoryMacro(QTEMP40, 2) == 2)
        QTEMP = 2;	%use real FT for real
      end
      if (QmatNMR.HistoryMacro(QTEMP40, 2) == 4)
        QTEMP = 3;	%use TPPI FT for TPPI
      end
      if (QmatNMR.HistoryMacro(QTEMP40, 2) == 7)
        QTEMP = 4;	%use qseq FT for qseq
      end
      if (QmatNMR.HistoryMacro(QTEMP40, 2) == 8)
        QTEMP = 5;	%use sine FT for sine
      end
      fprintf(fp, '\n  DataOut.Spectrum = matNMRFT1D(DataOut.Spectrum, %d, %d, %d);', QTEMP, QmatNMR.HistoryMacro(QTEMP40, 3), QmatNMR.HistoryMacro(QTEMP40, 4));

      fprintf(fp, '\n%%\n%% Reset of the default axis: by default we assume the carrier to be in the center of the spectrum\n%% This way the size of the spectrum can be changed without the default axis turning bad.\n%%');
      fprintf(fp, '\n  DataOut.DefaultAxisCarrierIndexTD2 = floor(length(DataOut.Spectrum)/2)+1;\n\n');

      
    case 6		%FT shift 1D
      fprintf(fp, '\n%% \n%% FFT shift 1D (shift of zero frequency point)\n%% syntax: MatrixOut = fftshift(MatrixIn)\n%%');
      fprintf(fp, '\n  DataOut.Spectrum = fftshift(DataOut.Spectrum);\n\n');

      
    case 7		%flip l/r 1D
      fprintf(fp, '\n%% \n%% Flip left/Right 1D (invert spectrum)\n%% syntax: MatrixOut = fliplr(MatrixIn)\n%%');
      fprintf(fp, '\n  DataOut.Spectrum = fliplr(DataOut.Spectrum);\n\n');

    
    case 8		%baseline correction peak list. This is only added to the processing script when it is complete (case 9)
      QmatNMR.BaslcorPeakList = [QmatNMR.BaslcorPeakList QmatNMR.HistoryMacro(QTEMP40, 1+find(QmatNMR.HistoryMacro(QTEMP40, 2:end)))];
      
      
    case 9		%baseline correction finish
      fprintf(fp, '\n%% \n%% Baseline correction 1D\n%% syntax: MatrixOut = matNMRBaselineCorrection1D(MatrixIn, AxisIn, NoisePositions, Type, Order);\n%%');
      fprintf(fp, '\n  %% \n  %% First we write out the positions in the spectrum that contain noise (in the unit of the axis!)\n  %% NOTE: each noise block requires a start and an end coordinate, i.e. [start1 end1 start2 end start3 end3 ...]\n  %% ');
      fprintf(fp, '\n  BaslcorNoiseList = [');
      fprintf(fp, '%f ', QmatNMR.Axis1D(QmatNMR.BaslcorPeakList));
      fprintf(fp, '];');
      
      QTEMP1 = str2mat('Polynomial', 'Bernstein polynomial', 'cosine series');
      QTEMP2 = deblank(QTEMP1(QmatNMR.HistoryMacro(QTEMP40, 3), :));
      fprintf(fp, '\n  %% \n  %%Now we perform the baseline correction, Type = %s, Order = %d\n  %%', QTEMP2, QmatNMR.HistoryMacro(QTEMP40, 4));
      fprintf(fp, '\n  Type   = %d;      \t%% 1=Polynomial, 2=Bernstein polynomial, 3=cosine series', QmatNMR.HistoryMacro(QTEMP40, 3));
      fprintf(fp, '\n  Order  = %d;', QmatNMR.HistoryMacro(QTEMP40, 4));
      fprintf(fp, '\n  if ~exist(''Zeroth''); Zeroth = 0; end');
      fprintf(fp, '\n  DataOut.Spectrum = matNMRBaselineCorrection1D(DataOut.Spectrum, DataOut.AxisTD2, BaslcorNoiseList, Type, Order, Zeroth);\n\n');
      
      QmatNMR.BaslcorPeakList = [];
      %%
      %% Dit brengt allerlei problemen en vragen met zich mee. Hoe implementeer je dit? Op zich zou er een frequentieas meegegeven moeten
      %% worden ipv een set indices. Anders krijg je problemen als de user een andere grootte voor het spectrum kiest. Dus moet er een
      %% baseline correction routine gemaakt worden die dat alles doet. Ook moet je je afvragen of het niet goed zou zijn ook een volautomatische
      %% baseline correction te implementeren. Macro's zijn voor standaard spectra en dan wil je waarschijnlijk ook standaard processing
      %% hebben ...
      %%
      %% Dit is dus lastig.
      %%

    
    case 10		%linear prediction 1D
      QTEMP1 = QmatNMR.HistoryMacro(QTEMP40, 2);	%%determine type of linear prediction
      if (QTEMP1 == 1)
        QTEMP2 = 1; 	%%'LPSVD'
	QTEMP3 = 0; 	%%backward

      elseif (QTEMP1 == 2)
        QTEMP2 = 2; 	%%'ITMPM'
	QTEMP3 = 0; 	%%backward

      elseif (QTEMP1 == 3)
        QTEMP2 = 1; 	%%'LPSVD'
	QTEMP3 = 1; 	%forward

      else
        QTEMP2 = 2; 	%%'ITMPM'
	QTEMP3 = 1; 	%forward
      end

      fprintf(fp, '\n%% \n%% Linear prediction 1D\n%% syntax: MatrixOut = matNMRLP1D(MatrixIn, LPalgorithm, LPdirection, NumberOfPointsToPredict, NumberOfPointsToUse, NrOfFreqs, SN)\n%%');
      fprintf(fp, '\n  DataOut.Spectrum = matNMRLP1D(DataOut.Spectrum, %d, %d, %d, %d, %d, %d);\n\n', QTEMP2, QTEMP3, QmatNMR.HistoryMacro(QTEMP40, 3), QmatNMR.HistoryMacro(QTEMP40, 4), QmatNMR.HistoryMacro(QTEMP40, 5), QmatNMR.HistoryMacro(QTEMP40, 6));


    case 11		%apodization 1D
      fprintf(fp, '\n%% \n%% Apodization 1D\n%% syntax: MatrixOut = matNMRApodize1D(MatrixIn, ApodizationType, Extra1, Extra2, Extra3)\n%%');

      QmatNMR.lbTempstatus = QmatNMR.HistoryMacro(QTEMP40, 2);
      switch QmatNMR.lbTempstatus
        case -99		%%cos^2
          fprintf(fp, '\n%% Cosine^2 apodization:  ApodizationType=1, Extra1=phase in degrees (0-90)\n%%');
          fprintf(fp, '\n  DataOut.Spectrum = matNMRApodize1D(DataOut.Spectrum, 1, %f);\n\n', QmatNMR.HistoryMacro(QTEMP40, 3));
	  
	case -60		%%block and exponential
          fprintf(fp, '\n%% block and exponential apodization:  ApodizationType=2, Extra1=size of block in points, Extra2=LB in Hz, Extra4=spectral width in kHz\n%%');
          fprintf(fp, '\n  DataOut.Spectrum = matNMRApodize1D(DataOut.Spectrum, 2, %d, %f, DataOut.SweepWidthTD2);\n\n', QmatNMR.HistoryMacro(QTEMP40, 3), QmatNMR.HistoryMacro(QTEMP40, 4));
      
        case -50		%%block and cos^2
          fprintf(fp, '\n%% Block and Cosine^2 apodization:  ApodizationType=3, Extra1=size of block in points\n%%');
          fprintf(fp, '\n  DataOut.Spectrum = matNMRApodize1D(DataOut.Spectrum, 3, %d);\n\n', QmatNMR.HistoryMacro(QTEMP40, 3));
	  
        case -40		%%Hanning
          fprintf(fp, '\n%% Hanning apodization:  ApodizationType=8, Extra1=phase in degrees (0-90)\n%%');
          fprintf(fp, '\n  DataOut.Spectrum = matNMRApodize1D(DataOut.Spectrum, 8, %f);\n\n', QmatNMR.HistoryMacro(QTEMP40, 3));
	  
        case -30		%%Hamming
          fprintf(fp, '\n%% Hamming apodization:  ApodizationType=9, Extra1=phase in degrees (0-90)\n%%');
          fprintf(fp, '\n  DataOut.Spectrum = matNMRApodize1D(DataOut.Spectrum, 9, %f);\n\n', QmatNMR.HistoryMacro(QTEMP40, 3));
	  
	case 10			%%gaussian
          fprintf(fp, '\n%% Gaussian apodization:  ApodizationType=4, Extra1=Gaussian broadening in Hz, Extra2=Lorentzian broadening in Hz, Extra3=spectral width in kHz\n%%');
          fprintf(fp, '\n  DataOut.Spectrum = matNMRApodize1D(DataOut.Spectrum, 4, %f, %f, DataOut.SweepWidthTD2);\n\n', QmatNMR.HistoryMacro(QTEMP40, 4), QmatNMR.HistoryMacro(QTEMP40, 3));
	  
	case 50			%%exponential
          fprintf(fp, '\n%% exponential apodization:  ApodizationType=5, Extra1=Lorentzian broadening in Hz, Extra2=spectral width in kHz\n%%');
          fprintf(fp, '\n  DataOut.Spectrum = matNMRApodize1D(DataOut.Spectrum, 5, %f, DataOut.SweepWidthTD2);\n\n', QmatNMR.HistoryMacro(QTEMP40, 3));
	
	case 101		%%gaussian for whole echo FID  
          fprintf(fp, '\n%% Gaussian apodization for whole-echo FID:  ApodizationType=6, Extra1=Gaussian broadening in Hz, Extra2=Lorentzian broadening in Hz, Extra3=spectral width in kHz\n%%');
          fprintf(fp, '\n  DataOut.Spectrum = matNMRApodize1D(DataOut.Spectrum, 6, %f, %f, DataOut.SweepWidthTD2);\n\n', QmatNMR.HistoryMacro(QTEMP40, 4), QmatNMR.HistoryMacro(QTEMP40, 3));

	case 501		%%exponential for whole echo FID
          fprintf(fp, '\n%% exponential apodization for whole-echo FID:  ApodizationType=7, Extra1=Lorentzian broadening in Hz, Extra2=spectral width in kHz\n%%');
          fprintf(fp, '\n  DataOut.Spectrum = matNMRApodize1D(DataOut.Spectrum, 7, %f, DataOut.SweepWidthTD2);\n\n', QmatNMR.HistoryMacro(QTEMP40, 3));
	  
	otherwise
	  error('matNMR ERROR: Unknown code for apodization function!');
      end

    
    case 12		%phase correction
      fprintf(fp, '\n%% \n%% Set phase 1D\n%% syntax: MatrixOut = matNMRSetPhase1D(MatrixIn, AxisIn, Zeroth, First, ReferenceFirst, Second)\n%%');
      fprintf(fp, '\n%% \n%% or for automatic setting\n%% syntax: MatrixOut = matNMRSetPhase1D(MatrixIn)\n%%');
      fprintf(fp, '\n  Zeroth = %f;    \t%% phase in degrees', QmatNMR.HistoryMacro(QTEMP40, 2));
      fprintf(fp, '\n  First  = %f;    \t%% phase in degrees', QmatNMR.HistoryMacro(QTEMP40, 3));
      fprintf(fp, '\n  Ref1st = %f;    \t%% position of reference in unit of the axis', QmatNMR.HistoryMacro(QTEMP40, 4));
      fprintf(fp, '\n  Second = %f;    \t%% phase in degrees', QmatNMR.HistoryMacro(QTEMP40, 5));
      fprintf(fp, '\n  DataOut.Spectrum = matNMRSetPhase1D(DataOut.Spectrum, DataOut.AxisTD2, Zeroth, First, Ref1st, Second);\n\n');
      
    case 13		%convert Bruker qseq data
      fprintf(fp, '\n%% \n%% Convert Bruker qseq data 1D\n%% syntax: MatrixOut = matNMRConvertBrukerqseq1D(MatrixIn)\n%%');
      fprintf(fp, '\n  DataOut.Spectrum = matNMRConvertBrukerqseq1D(DataOut.Spectrum);\n\n');

      
    case 14		%user defined axis 1D/2D
      %%
      %non-linear axes are stored entirely in macros as a user-defined command (codes 666 and 667), which produces a variable
      %%QmatNMR.uiInput1. This contains the values as used for the axis. 
      %%
      if (QmatNMR.HistoryMacro(QTEMP40, 4) == 0) 	%num2str(QmatNMR.HistoryMacro(QTEMP40, 4)) = QmatNMR.Dim
        fprintf(fp, '\n%% \n%% User-defined axis 1D\n%% syntax: DataOut.AxisTD2 = <variable>\n%%');

        if (QmatNMR.HistoryMacro(QTEMP40, 7) == 0) 	%%linear axis is defined by an offset and a slope
          fprintf(fp, '\n  DataOut.AxisTD2 = [%s:%s:%s];\n\n', num2str(QmatNMR.HistoryMacro(QTEMP40, 3) + QmatNMR.HistoryMacro(QTEMP40, 2), 13), num2str(QmatNMR.HistoryMacro(QTEMP40, 2), 13), num2str(QmatNMR.HistoryMacro(QTEMP40, 3) + QmatNMR.Size1D*QmatNMR.HistoryMacro(QTEMP40, 2), 13));
        else

          fprintf(fp, '\n  DataOut.AxisTD2 = QmatNMR.uiInput1;\n\n');
        end

      elseif (QmatNMR.HistoryMacro(QTEMP40, 4)==1) 	%TD2

      else 						%TD1
      end

      
    case 15 		%1D DC offset correction
      fprintf(fp, '\n%% \n%% DC offset correction 1D\n%% syntax: MatrixOut = matNMRDCcorr1D(MatrixIn, NoiseRange)\n%%');
      fprintf(fp, '\n  DataOut.Spectrum = matNMRDCcorr1D(DataOut.Spectrum, %s);\n\n', [num2str(QmatNMR.HistoryMacro(QTEMP40, 2)) ':' num2str(QmatNMR.HistoryMacro(QTEMP40, 3))]);


    case 16		%remove Bruker digital filter 1D
      fprintf(fp, '\n%% \n%% Remove Bruker digital filter 1D\n%% syntax: MatrixOut = matNMRRemoveBrukerDigitalFilter1D(MatrixIn, ACQUSFileName)\n%% syntax: MatrixOut = matNMRRemoveBrukerDigitalFilter1D(MatrixIn, NrOfPointsToShift)\n%%');
      fprintf(fp, '\n  DataOut.Spectrum = matNMRRemoveBrukerDigitalFilter1D(DataOut.Spectrum, %f);\n\n', QmatNMR.HistoryMacro(QTEMP40, 2));


    case 17		%solvent suppression 1D
      QTEMP1 = str2mat('Gaussian', 'Sine-Bell', 'Rectangle');
      fprintf(fp, '\n%% \n%% Solvent suppression 1D\n%% syntax: MatrixOut = matNMRSolventSuppression1D(MatrixIn, WindowFunction, WindowWidth, JumpSize)\n%%');
      fprintf(fp, '\n%% WindowFunction = %s\n%%', deblank(QTEMP1(QmatNMR.HistoryMacro(QTEMP40, 2), :)));
      fprintf(fp, '\n  DataOut.Spectrum = matNMRSolventSuppression1D(DataOut.Spectrum, %d, %d, %d);\n\n', QmatNMR.HistoryMacro(QTEMP40, 2:4));


    case 18		%concatenate 1D
      QTEMP1 = str2mat('along TD2', 'along TD1');
      fprintf(fp, '\n%% \n%% Concatenate 1D\n%% syntax: MatrixOut = matNMRConcatenate1D(MatrixIn, NrOfTimes, Direction)\n%%');
      fprintf(fp, '\n%% Direction = %s\n%%', deblank(QTEMP1(QmatNMR.HistoryMacro(QTEMP40, 3), :)));
      fprintf(fp, '\n  DataOut.Spectrum = matNMRConcatenate1D(DataOut.Spectrum, %d, %d);\n\n', QmatNMR.HistoryMacro(QTEMP40, 2:3));


    case 19		%define external reference 1D
      fprintf(fp, '\n%% \n%% Define external reference 1D\n%%');
      fprintf(fp, '\n  %%\n  %%Define and store the external reference values in the output variable\n  %%');
      fprintf(fp, '\n  DataOut.DefaultAxisReference.ReferenceFrequency = %f;', QmatNMR.HistoryMacro(QTEMP40, 2));
      fprintf(fp, '\n  DataOut.DefaultAxisReference.ReferenceValue = %f;', QmatNMR.HistoryMacro(QTEMP40, 3));
      fprintf(fp, '\n  DataOut.DefaultAxisReference.ReferenceUnit = %f;\n', QmatNMR.HistoryMacro(QTEMP40, 4));

      fprintf(fp, '\n  %%\n  %% Recalculate the frequency at the carrier using external reference data');
      fprintf(fp, '\n  %% Syntax: [DefaultAxisRefkHz, DefaultAxisRefPPM] = matNMRApplyExternalReference(ReferenceFrequency, ReferenceValue, ReferenceUnit, SpectralFrequency, Gamma);\n  %%');
      fprintf(fp, '\n  [DataOut.DefaultAxisRefkHzTD2, DataOut.DefaultAxisRefPPMTD2] = matNMRApplyExternalReference(DataOut.DefaultAxisReference.ReferenceFrequency, DataOut.DefaultAxisReference.ReferenceValue, DataOut.DefaultAxisReference.ReferenceUnit, DataOut.SpectralFrequencyTD2, DataOut.GammaTD2);');
      fprintf(fp, '\n\n');
      ChangeVectorOld(6:7) = rand(1,2);	%this ensures the dimension-specific data is updated and the default axis is recalculated if needed




    case 20		%set integral from 1D
      disp('matNMR NOTICE: setting of the integral of a 1D spectrum is not yet implemented in the conversion to script.');

    case 21		%do the undo ... or undo the do that was
      QmatNMR.buttonList = 1;
      %
      %for a linear axis we define a string that codes for the axis vector
      %non-linear axes are stored entirely in the macro
      %
      fprintf(fp, '\n%% \n%% Regrid spectrum 1D\n%% syntax: MatrixOut = matNMRRegridSpectrum1D(MatrixIn, AxisOld, AxisNew, Algorithm)\n%%         Algorithm can be 1=spline, 2=cubic, 3=linear, 4=nearest\n%%');

      fprintf(fp, '\n  AxisOld = DataOut.AxisTD2;');
      if (QmatNMR.HistoryMacro(QTEMP40, 7) == 0)      %%linear axis is defined by an offset and a slope
        fprintf(fp, '\n  AxisNew = [%s:%s:%s];', num2str(QmatNMR.HistoryMacro(QTEMP40, 3) + QmatNMR.HistoryMacro(QTEMP40, 2), 13), num2str(QmatNMR.HistoryMacro(QTEMP40, 2), 13), num2str(QmatNMR.HistoryMacro(QTEMP40, 3) + QmatNMR.Size1D*QmatNMR.HistoryMacro(QTEMP40, 2), 13));
      else

        fprintf(fp, '\n  AxisNew = QmatNMR.uiInput1;');
      end
      fprintf(fp, '\n  DataOut.Spectrum = matNMRRegridSpectrum1D(DataOut.Spectrum, AxisOld, AxisNew, %d);', QmatNMR.ExecutingMacro(QTEMP40, 6));
      fprintf(fp, '\n  DataOut.AxisTD2 = AxisNew;');
    
    case 22		%do the undo ... or undo the do that was
      disp('matNMR NOTICE: noise filling of a 1D spectrum is not yet implemented in the conversion to script.');


    case 23		%Cadzow filtering 1D in time domain
      fprintf(fp, '\n%% \n%% Cadzow filtering 1D\n%% syntax: MatrixOut = matNMRCadzow1D(MatrixIn, WindowSize, NrFreqs, CadzowRepeat)\n%%');
      fprintf(fp, '\n  [DataOut.Spectrum, SV] = matNMRCadzow1DTD(DataOut.Spectrum, %f, %d, %d);\n\n', QmatNMR.HistoryMacro(QTEMP40, 2:4));


    case 24		%Cadzow filtering + LPSVD 1D in time domain
      fprintf(fp, '\n%% \n%% Concatenate 1D\n%% syntax: MatrixOut = matNMRConcatenate1D(MatrixIn, WindowSize, NrFreqs, CadzowRepeat, NrPointsLPSVD)\n%%');
      fprintf(fp, '\n  [DataOut.Spectrum, SV] = matNMRCadzowLPSVD1DTD(DataOut.Spectrum, %f, %d, %d, %d);\n\n', QmatNMR.HistoryMacro(QTEMP40, 2:5));




      
%
%2D functions
%
    case 101		%FT 2D
      QTEMP = str2mat('Complex FT', 'Real FT', 'States', 'TPPI', 'Whole Echo', 'States-TPPI', 'Bruker qseq', 'Sine FT');
      QTEMP1 = [];
      if (QmatNMR.HistoryMacro(QTEMP40, 5)) 	%inverse FT?
        QTEMP1 = ['Inverse'];
      end
      QTEMP1 = [QTEMP1 ' FT TD' num2str(~(QmatNMR.HistoryMacro(QTEMP40, 4)-1)+1) ', type = ' deblank(QTEMP(QmatNMR.HistoryMacro(QTEMP40, 2), :))];
      QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, QTEMP1);
      QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];

      
    case 102		%set size 2D
      %
      %check which dimensions have changed size
      %
      if (QmatNMR.HistoryMacro(QTEMP40, 2) == -99)
      	QTEMP1 = 'unaltered';	%no change
      else
        QTEMP1 = num2str(QmatNMR.HistoryMacro(QTEMP40, 2));
      end
      if (QmatNMR.HistoryMacro(QTEMP40, 3) == -99)
      	QTEMP2 = 'unaltered'; 	%no change
      else
        QTEMP2 = num2str(QmatNMR.HistoryMacro(QTEMP40, 3));
      end

      QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Set size 2D, size TD2 = ' QTEMP1 ', size TD1 = ' QTEMP2]);
      QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
      
      
    case 103		%shift data points
      if QmatNMR.HistoryMacro(QTEMP40, 5) 	%action operated on a single slice
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Shift data points single slice of 2D, TD' num2str(~(QmatNMR.HistoryMacro(QTEMP40, 4)-1)+1) ', ' num2str(QmatNMR.HistoryMacro(QTEMP40, 2)) ' points, slice ' num2str(QmatNMR.HistoryMacro(QTEMP40, 6))]);

      else				%action operated on the entire dimension
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Shift data points 2D, TD' num2str(~(QmatNMR.HistoryMacro(QTEMP40, 4)-1)+1) ', ' num2str(QmatNMR.HistoryMacro(QTEMP40, 2)) ' points']);
      end
      QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];

      
    case 104		%swap whole echo
      QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Swap whole echo 2D, TD' num2str(~(QmatNMR.HistoryMacro(QTEMP40, 3)-1)+1) ', swap around point ' num2str(QmatNMR.HistoryMacro(QTEMP40, 2))]);
      QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];

    
    case 105		%fFTshift
      QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['FFT shift 2D, TD' num2str(~(QmatNMR.HistoryMacro(QTEMP40, 2)-1)+1)]);
      QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];

      
    case 106		%flip l/r  
      QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Flip left/right 2D, TD' num2str(~(QmatNMR.HistoryMacro(QTEMP40, 2)-1)+1)]);
      QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];

      
    case 107		%apodize 2D
      QmatNMR.lbTempstatus = QmatNMR.HistoryMacro(QTEMP40, 2);
      switch QmatNMR.lbTempstatus
        case -99		%cos^2
	  QTEMP1 = ['cos^2, phase = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 5))];
	  
	case -60		%block and exponential
	  QTEMP1 = ['block and exponential, block length = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 5)) ' points, LB = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 6)) ' Hz, SWH = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 7)) ' Hz'];
      
        case -50		%block and cos^2
	  QTEMP1 = ['block and cos^2, block = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 5)) ' points'];
	  
        case -40		%Hanning
	  QTEMP1 = ['Hanning, phase = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 5))];
	  
        case -30		%Hamming
	  QTEMP1 = ['Hamming, phase = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 5))];
	  
	case 10			%gaussian
	  QTEMP1 = ['gaussian, LB = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 5)) ' Hz, GB = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 6)) ' Hz, SWH = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 7)) ' Hz'];
	  
	case 50			%exponential
	  QTEMP1 = ['exponential, LB = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 5)) ' Hz, SWH = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 6)) ' Hz'];
	
	case 100		%shifting gaussian
	  QTEMP = str2mat('positive', 'negative');
	  QTEMP1 = ['shifting gaussian, LB = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 5)) ' Hz, SWH TD 2 = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 6)) ' Hz, SWH TD 1 = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 7)) ' Hz, Shearing Factor = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 8)) ', pos. echo max. = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 9)) ', shift = ' deblank(QTEMP(QmatNMR.HistoryMacro(QTEMP40, 10)))];

	case 101		%gaussian for whole echo FID  
	  QTEMP1 = ['gaussian (echo), LB = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 5)) ' Hz, GB = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 6)) ' Hz, SWH = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 7)) ' Hz'];

	case 501		%exponential for whole echo FID
	  QTEMP1 = ['exponential (echo), LB = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 5)) ' Hz, SWH = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 6)) ' Hz'];

	case 1001
	  QTEMP1 = ['shifting gaussian (echo), LB = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 5)) ' Hz, SWH TD 2 = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 6)) ' Hz, SWH TD 1 = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 7)) ' Hz, Shearing = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 8)) ', pos. echo max. = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 9))];
	
	otherwise
	  error('matNMR ERROR: Unknown code for apodization function!');
      end
      QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Apodization 2D, TD' num2str(~(QmatNMR.HistoryMacro(QTEMP40, 3)-1)+1) ', ' deblank(QTEMP1)]);
      QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];


    case 108		%zero part of 2D
      QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Zero part of 2D, rows ' num2str(QmatNMR.HistoryMacro(QTEMP40, 2)) ':' num2str(QmatNMR.HistoryMacro(QTEMP40, 4)) ':' num2str(QmatNMR.HistoryMacro(QTEMP40, 3)) ', columns ' num2str(QmatNMR.HistoryMacro(QTEMP40, 5)) ':' num2str(QmatNMR.HistoryMacro(QTEMP40, 7)) ':' num2str(QmatNMR.HistoryMacro(QTEMP40, 6))]);
      QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];


    case 109		%convert Bruker qseq to TPPI/TPPI data
      QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, 'Convert Bruker qseq to TPPI/TPPI data');
      QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];


    case 110		%convert Bruker States to matNMR
      QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, 'Convert Bruker States to matNMR format');
      QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];


    case 111		%convert Varian States to matNMR
      QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, 'Convert Varian States to matNMR format');
      QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];


    case 127		%convert Echo / Anti-Echo to Hypercomplex
      QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, 'Convert Echo / Anti-Echo FID to Hypercomplex');
      QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];


    case 112		%start States processing
      QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, 'Start States processing');
      QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];


    case 113		%phase correction 2D
      if QmatNMR.HistoryMacro(QTEMP40, 8) 	%action operated on a single slice
        if QmatNMR.HistoryMacro(QTEMP40, 5)	%there is a second order phase correction
          QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Phase correction of single slice of 2D, TD' num2str(~(QmatNMR.HistoryMacro(QTEMP40, 6)-1)+1) ', Slice = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 9)) ', 0th order = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 2)) ' degrees, 1st order = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 3)) ' degrees, 2nd order = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 5)) ' degrees']);
  
        else
          QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Phase correction of single slice of 2D, TD' num2str(~(QmatNMR.HistoryMacro(QTEMP40, 6)-1)+1) ', Slice = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 9)) ', 0th order = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 2)) ' degrees, 1st order = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 3)) ' degrees']);
        end

      else				%action operated on the entire matrix
        if QmatNMR.HistoryMacro(QTEMP40, 5)	%there is a second order phase correction
          QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Phase correction 2D, TD' num2str(~(QmatNMR.HistoryMacro(QTEMP40, 6)-1)+1) ', 0th order = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 2)) ' degrees, 1st order = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 3)) ' degrees, 2nd order = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 5)) ' degrees']);
  
        else
          QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Phase correction 2D, TD' num2str(~(QmatNMR.HistoryMacro(QTEMP40, 6)-1)+1) ', 0th order = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 2)) ' degrees, 1st order = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 3)) ' degrees']);
        end
      end
      QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];


    case 114		%extract from 2D
      if (QmatNMR.HistoryMacro(QTEMP40, 6) == 0) 	%no increment specified in macro for TD2
        QTEMP1 = [num2str(QmatNMR.HistoryMacro(QTEMP40, 2)) ':' num2str(QmatNMR.HistoryMacro(QTEMP40, 3))];

      else
        QTEMP1 = [num2str(QmatNMR.HistoryMacro(QTEMP40, 2)) ':' num2str(QmatNMR.HistoryMacro(QTEMP40, 6)) ':' num2str(QmatNMR.HistoryMacro(QTEMP40, 3))];
      end
      if (QmatNMR.HistoryMacro(QTEMP40, 7) == 0) 	%no increment specified in macro for TD1
        QTEMP2 = [num2str(QmatNMR.HistoryMacro(QTEMP40, 4)) ':' num2str(QmatNMR.HistoryMacro(QTEMP40, 5))];

      else
        QTEMP2 = [num2str(QmatNMR.HistoryMacro(QTEMP40, 4)) ':' num2str(QmatNMR.HistoryMacro(QTEMP40, 7)) ':' num2str(QmatNMR.HistoryMacro(QTEMP40, 5))];
      end
      QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Extract from 2D, range TD2 = ' QTEMP1 ', range TD1 = ' QTEMP2]);
      QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];


    case 115		%symmetrize 2D
      QTEMP = QmatNMR.HistoryMacro(QTEMP40, 2);
      if (QTEMP==1)
        QTEMP = 'average intensities';
      else
        QTEMP = 'highest intensities';
      end	
      QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Symmetrize 2D, ' deblank(QTEMP)]);
      QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];


    case 116		%shearing transformation
      QTEMP = QmatNMR.HistoryMacro(QTEMP40, 2);
      if (QTEMP == 0)	%in frequency domain
        QTEMP1 = 'frequency domain';
	QTEMP2 = num2str(QmatNMR.HistoryMacro(QTEMP40, 3));	%shearing factor
	if (QmatNMR.HistoryMacro(QTEMP40, 6))
  	  QTEMP3 = ', vertical';
	else
	  QTEMP3 = ', horizontal';
	end
	
      else		%in time domain
        QTEMP1 = 'time domain';
	QTEMP2 = num2str(QmatNMR.HistoryMacro(QTEMP40, 3));	%shearing factor
        QTEMP3 = '';
      end
      QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Shearing transformation, ' deblank(QTEMP1) ', shearing factor = ' deblank(QTEMP2) deblank(QTEMP3)]);
      QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];


    case 117		%linear prediction 2D
      QTEMP1 = QmatNMR.HistoryMacro(QTEMP40, 2);	%determine type of linear prediction
      if (QTEMP1 == 1)
        QTEMP2 = 'LPSVD';
	QTEMP3 = 'backward';

      elseif (QTEMP1 == 2)
        QTEMP2 = 'ITMPM';
	QTEMP3 = 'backward';

      elseif (QTEMP1 == 3)
        QTEMP2 = 'LPSVD';
	QTEMP3 = 'forward';

      else
        QTEMP2 = 'ITMPM';
	QTEMP3 = 'forward';
      end
      QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Linear prediction 2D, TD' num2str(~(QmatNMR.HistoryMacro(QTEMP40, 7)-1)+1) ', ' deblank(QTEMP2) ', ' deblank(QTEMP3) ', ' num2str(QmatNMR.HistoryMacro(QTEMP40, 3)) ' points']);
      QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering QmatNMR.StepWiseTempNumber+1];


    case 118		%baseline correction 2D  
      %
      %check whether the entire range must be baseline corrected
      %
      if (QmatNMR.HistoryMacro(QTEMP40, 5) == -99)
      	QTEMP1 = '1';	%no change
      else
        QTEMP1 = num2str(QmatNMR.HistoryMacro(QTEMP40, 5));
      end
      if (QmatNMR.HistoryMacro(QTEMP40, 6) == -99)
        if (QmatNMR.Dim == 1)
          QTEMP2 = num2str(QmatNMR.SizeTD1);				%ending row/column
        else
          QTEMP2 = num2str(QmatNMR.SizeTD2);				%ending row/column
        end
      else
        QTEMP2 = num2str(QmatNMR.HistoryMacro(QTEMP40, 6));
      end

      QTEMP = str2mat('Polynomial', 'Sine', 'Exponential', 'Bernstein Polynomial', 'Cosine Series');
      QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Baseline correction 2D, TD' num2str(~(QmatNMR.HistoryMacro(QTEMP40, 2)-1)+1) ', ' deblank(QTEMP(QmatNMR.HistoryMacro(QTEMP40, 3), :)) ', order  = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 4)) ', selected range = ' QTEMP1 ':' QTEMP2]);
      QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering QmatNMR.StepWiseTempNumber+1];
      QmatNMR.StepWiseTempNumber = 0;


    case 119		%set integral 2D
      if (QmatNMR.HistoryMacro(QTEMP40, 6) == 0) 	%no increment specified in macro for TD2
        QTEMP1 = [num2str(QmatNMR.HistoryMacro(QTEMP40, 2)) ':' num2str(QmatNMR.HistoryMacro(QTEMP40, 3))];

      else
        QTEMP1 = [num2str(QmatNMR.HistoryMacro(QTEMP40, 2)) ':' num2str(QmatNMR.HistoryMacro(QTEMP40, 6)) ':' num2str(QmatNMR.HistoryMacro(QTEMP40, 3))];
      end
      if (QmatNMR.HistoryMacro(QTEMP40, 7) == 0) 	%no increment specified in macro for TD1
        QTEMP2 = [num2str(QmatNMR.HistoryMacro(QTEMP40, 4)) ':' num2str(QmatNMR.HistoryMacro(QTEMP40, 5))];

      else
        QTEMP2 = [num2str(QmatNMR.HistoryMacro(QTEMP40, 4)) ':' num2str(QmatNMR.HistoryMacro(QTEMP40, 7)) ':' num2str(QmatNMR.HistoryMacro(QTEMP40, 5))];
      end
      QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Set Integral 2D, range TD2 = ' QTEMP1 ', range TD1 = ' QTEMP2 ', integration value = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 8))]);
      QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];


    case 120 		%Transpose 2D
      QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Transpose 2D']);
      QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];


    case 121 		%2D DC offset correction
      QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['DC offset correction 2D, TD' num2str(~(QmatNMR.HistoryMacro(QTEMP40, 2)-1)+1) ', noise range = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 3)) ':' num2str(QmatNMR.HistoryMacro(QTEMP40, 4))]);
      QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];


    case 122		%remove Bruker digital filter 2D
      QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Remove Bruker digital filter, ' num2str(QmatNMR.HistoryMacro(QTEMP40, 2)) ' points']);
      QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];


    case 123		%solvent suppression 2D
      QTEMP1 = str2mat('Gaussian', 'Sine-Bell', 'Rectangle');
      QTEMP2 = str2mat('TD2', 'TD1');
      QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Solvent Suppression' deblank(QTEMP1(QmatNMR.HistoryMacro(QTEMP40, 5), :)) ', ' deblank(QTEMP1(QmatNMR.HistoryMacro(QTEMP40, 2), :)) ', width=' num2str(num2str(QmatNMR.HistoryMacro(QTEMP40, 3))) ', extrapolate=' num2str(num2str(QmatNMR.HistoryMacro(QTEMP40, 4)))]);
      QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering QmatNMR.StepWiseTempNumber+1];
      QmatNMR.StepWiseTempNumber = 0;


    case 124		%concatenate 2D
      QTEMP1 = str2mat('along TD2', 'along TD1');
      QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Concatenate 2D, ' num2str(QmatNMR.HistoryMacro(QTEMP40, 2)) ' times ' deblank(QTEMP1(QmatNMR.HistoryMacro(QTEMP40, 3), :))]);
      QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];


    case 125		%define external reference 2D
      QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, 'Define external reference');
      QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];

    
    case 126		%LP 2D peak list
      QmatNMR.StepWiseTempNumber = QmatNMR.StepWiseTempNumber + 1;

    
    case 128		%sD 2D peak list
      QmatNMR.StepWiseTempNumber = QmatNMR.StepWiseTempNumber + 1;



%
%2D to 1D functions
%	
    case 201    	%%diagonal
      QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Calculate Diagonal']);
      QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];


    case 202   		%%anti-diagonal
      QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Calculate Anti-Diagonal']);
      QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];


    case 203 		%sum TD1
      QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Calculate Sum TD1, range TD2 = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 2)) ':' num2str(QmatNMR.HistoryMacro(QTEMP40, 3))]);
      QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];


    case 204 		%sum TD2
      QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Calculate Sum TD2, range TD1 = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 2)) ':' num2str(QmatNMR.HistoryMacro(QTEMP40, 3))]);
      QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];


    case 205 		%skyline projection
      QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Calculate Skyline Projection, angle = ' num2str(QmatNMR.HistoryMacro(QTEMP40, 2))]);
      QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];



%
%3D functions
%	
    case 301    	%%define axis for 3rd dimension
      QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Axis for third dimension defined']);
      QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];




%
%set dimension-specific parameters
%	
    case 400
    %
    %Set dimension-specific parameters. 
    %This has been added because of the default axes that are now available. 
    %These make it necessary to update the variables and the default axes,
    %if necessary, before each step of a macro is executed. Previously, before
    %the default axes, it was less critical since no axes-dependent processing
    %actions were available without having defined the axis manually.
    %
    %NOTE: only changes are written to the script to make it less cluttered
    %
    %NOTE: part of the information needed for making the default axis is not written
    %in the processing macro. The external reference data are in fact stored in the 
    %QmatNMR.Settings variable.
    %
    ChangeVectorNew = [QmatNMR.HistoryMacro(QTEMP40, 2:7) QmatNMRsettings.DefaultAxisReferencekHz QmatNMRsettings.DefaultAxisReferencePPM QmatNMRsettings.DefaultAxisCarrierIndex];
    if ~isequal(ChangeVectorOld, ChangeVectorNew)
      fprintf(fp, '\n\n\n      %% \n      %% Set dimension-specific information, like spectral parameters and the default axis\n      %% \n');
      if (QmatNMR.HistoryMacro(QTEMP40, 2) == 0) 		%%1D mode
        if (ChangeVectorOld(2) ~= ChangeVectorNew(2))
          fprintf(fp, '        DataOut.SweepWidthTD2 = %f;               %% in kHz\n', QmatNMR.HistoryMacro(QTEMP40, 3));
        end
        if (ChangeVectorOld(3) ~= ChangeVectorNew(3))
          fprintf(fp, '        DataOut.SpectralFrequencyTD2 = %f;        %% in MHz\n', QmatNMR.HistoryMacro(QTEMP40, 4));
        end
        if (ChangeVectorOld(4) ~= ChangeVectorNew(4))
          fprintf(fp, '        DataOut.GammaTD2 = %d;                    %% 1 means gyromagnetic ratio is positive, otherwise it''s negative\n', QmatNMR.HistoryMacro(QTEMP40, 5));
        end
        if (ChangeVectorOld(5) ~= ChangeVectorNew(5))
          fprintf(fp, '        DataOut.FIDstatusTD2 = %d;                %% 1 means it''s a spectrum, otherwise it''s an FID\n', QmatNMR.HistoryMacro(QTEMP40, 6));
        end
        
        %%apply default axis?
        if (QmatNMR.HistoryMacro(QTEMP40, 7) == 0)
          if (ChangeVectorOld(6) ~= ChangeVectorNew(6))
            fprintf(fp, '        DataOut.DefaultAxisRefkHzTD2 = %f;        %% value in Hz at the specified reference carrier frequency\n', QmatNMRsettings.DefaultAxisReferencekHz);
          end
          if (ChangeVectorOld(7) ~= ChangeVectorNew(7))
            fprintf(fp, '        DataOut.DefaultAxisRefPPMTD2 = %f;        %% value in ppm at the specified reference carrier frequency\n', QmatNMRsettings.DefaultAxisReferencePPM);
          end
          if (ChangeVectorOld(8) ~= ChangeVectorNew(8))
            fprintf(fp, '        DataOut.DefaultAxisCarrierIndexTD2 = %f;  %% Index in points at which the carrier frequency of the reference is found in the current spectrum\n', QmatNMRsettings.DefaultAxisCarrierIndex);
          end
  
          if (QmatNMR.HistoryMacro(QTEMP40, 6) == 1) 	%%make a frequency-domain axis
            switch (QmatNMR.HistoryMacro(QTEMP40, 9))	%%denotes the preferred type of unit in the frequency domain
              case 1		%%kHz
                fprintf(fp, '      %%\n      %% Create a default axis based on the current parameters: FREQUENCY DOMAIN, unit=kHZ\n');
                fprintf(fp, '      %% syntax: AxisOut = matNMRCreateDefaultAxis(SizeTD2, SpectralWidth, SpectralFrequency, Gamma, Domain, RefkHz, RefPPM, CarrierIndex, UnitType)\n      %%\n');
                fprintf(fp, '        DataOut.AxisTD2 = matNMRCreateDefaultAxis(size(DataOut.Spectrum, 2), DataOut.SweepWidthTD2, DataOut.SpectralFrequencyTD2, DataOut.GammaTD2, 1, DataOut.DefaultAxisRefkHzTD2, DataOut.DefaultAxisRefPPMTD2, DataOut.DefaultAxisCarrierIndexTD2, 1);');
          
              case 2 		%%Hz
                fprintf(fp, '      %%\n      %% Create a default axis based on the current parameters: FREQUENCY DOMAIN, unit=HZ\n');
                fprintf(fp, '      %% syntax: AxisOut = matNMRCreateDefaultAxis(SizeTD2, SpectralWidth, SpectralFrequency, Gamma, Domain, RefkHz, RefPPM, CarrierIndex, UnitType)\n      %%\n');
                fprintf(fp, '        DataOut.AxisTD2 = matNMRCreateDefaultAxis(size(DataOut.Spectrum, 2), DataOut.SweepWidthTD2, DataOut.SpectralFrequencyTD2, DataOut.GammaTD2, 1, DataOut.DefaultAxisRefkHzTD2, DataOut.DefaultAxisRefPPMTD2, DataOut.DefaultAxisCarrierIndexTD2, 2);');
          
              case 3 		%%PPM
                fprintf(fp, '      %%\n      %% Create a default axis based on the current parameters: FREQUENCY DOMAIN, unit=ppm\n');
                fprintf(fp, '      %% syntax: AxisOut = matNMRCreateDefaultAxis(SizeTD2, SpectralWidth, SpectralFrequency, Gamma, Domain, RefkHz, RefPPM, CarrierIndex, UnitType)\n      %%\n');
                fprintf(fp, '        DataOut.AxisTD2 = matNMRCreateDefaultAxis(size(DataOut.Spectrum, 2), DataOut.SweepWidthTD2, DataOut.SpectralFrequencyTD2, DataOut.GammaTD2, 1, DataOut.DefaultAxisRefkHzTD2, DataOut.DefaultAxisRefPPMTD2, DataOut.DefaultAxisCarrierIndexTD2, 3);');
          
              case 4 		%%Points
                fprintf(fp, '      %%\n      %% Create a default axis based on the current parameters: FREQUENCY DOMAIN, unit=points\n');
                fprintf(fp, '      %% syntax: AxisOut = matNMRCreateDefaultAxis(SizeTD2, SpectralWidth, SpectralFrequency, Gamma, Domain, RefkHz, RefPPM, CarrierIndex, UnitType)\n      %%\n');
                fprintf(fp, '        DataOut.AxisTD2 = matNMRCreateDefaultAxis(size(DataOut.Spectrum, 2), DataOut.SweepWidthTD2, DataOut.SpectralFrequencyTD2, DataOut.GammaTD2, 1, DataOut.DefaultAxisRefkHzTD2, DataOut.DefaultAxisRefPPMTD2, DataOut.DefaultAxisCarrierIndexTD2, 4);');
          
              otherwise
                disp('matNMR ERROR: unknown code for default axis unit in the processing macro! Aborting conversion to script ...')
            end
  
          else 						%%make a time-domain axis
            switch (QmatNMR.HistoryMacro(QTEMP40, 8))	%%denotes the preferred type of unit in the time domain
              case 1		%%kHz
                fprintf(fp, '      %%\n      %% Create a default axis based on the current parameters: TIME DOMAIN, unit=Time (us)\n');
                fprintf(fp, '      %% syntax: AxisOut = matNMRCreateDefaultAxis(SizeTD2, SpectralWidth, SpectralFrequency, Gamma, Domain, RefkHz, RefPPM, CarrierIndex, UnitType)\n      %%\n');
                fprintf(fp, '        DataOut.AxisTD2 = matNMRCreateDefaultAxis(size(DataOut.Spectrum, 2), DataOut.SweepWidthTD2, DataOut.SpectralFrequencyTD2, DataOut.GammaTD2, 0, DataOut.DefaultAxisRefkHzTD2, DataOut.DefaultAxisRefPPMTD2, DataOut.DefaultAxisCarrierIndexTD2, 1);');
          
              case 2 		%%Hz
                fprintf(fp, '      %%\n      %% Create a default axis based on the current parameters: TIME DOMAIN, unit=points\n');
                fprintf(fp, '      %% syntax: AxisOut = matNMRCreateDefaultAxis(SizeTD2, SpectralWidth, SpectralFrequency, Gamma, Domain, RefkHz, RefPPM, CarrierIndex, UnitType)\n      %%\n');
                fprintf(fp, '        DataOut.AxisTD2 = matNMRCreateDefaultAxis(size(DataOut.Spectrum, 2), DataOut.SweepWidthTD2, DataOut.SpectralFrequencyTD2, DataOut.GammaTD2, 0, DataOut.DefaultAxisRefkHzTD2, DataOut.DefaultAxisRefPPMTD2, DataOut.DefaultAxisCarrierIndexTD2, 2);');
          
              otherwise
                disp('matNMR ERROR: unknown code for default axis unit in the processing macro! Aborting conversion to script ...')
            end
          end
        end
        
        fprintf(fp, '\n\n\n\n');
      end
      
      ChangeVectorOld = ChangeVectorNew;
    end




%
%User-defined functions. These are not executed but the command string is written into the processing script directly
%	
    case 666
      %
      %the strrep is used to protect against corrected macros which contais zeros where they shouldn't
      %
      QmatNMR.TEMPUserCommandString = [QmatNMR.TEMPUserCommandString strrep(char(QmatNMR.HistoryMacro(QTEMP40, 2:QmatNMR.MacroLength)), char(0), '')];
      
    case 667
      fprintf(fp, '\n%% \n%% This was a user-defined command in the processing macro that is executed as is ...\n%%');
      fprintf(fp, '\n  %s;\n\n', QmatNMR.TEMPUserCommandString);
      QmatNMR.TEMPUserCommandString = '';




%
%Plotting functions (code > 700) are not converted into the script!
%	
    case 711		%used for storing strings in the macro (e.g. axis labels)
      QmatNMR.TEMPCommandString = [QmatNMR.TEMPCommandString char(QmatNMR.HistoryMacro(QTEMP40, 2:QmatNMR.MacroLength))];
      
    case 712		%used for evaluating the temporary strings used in macros
      fprintf(fp, '\n%% \n%% This was a user-defined command in the processing macro that is executed as is ...\n%%');
      fprintf(fp, '\n  %s;\n\n', QmatNMR.TEMPCommandString);
      QmatNMR.TEMPCommandString = '';



    otherwise
      error('matNMR ERROR:  Unknown code encountered while processing macro!');
  end
end


%
%finish off by closing the file pointer
%
fclose(fp);


clear QTEMP*
