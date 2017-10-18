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
%AnalyseMacro.m analyses the processing macro for the stepwise processing routine. It basically
%determines of how many processing steps the macro consists and how many lines in the original
%macro each step occupies
%11-09-2000
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
%   23			Cadzow filtering 1D in time domain
%   24			Cadzow filtering + LPSVD estimation 1D in time domain
%   25			Cadzow filtering 1D in frequency domain
%   26			Cadzow filtering + LPSVD estimation 1D in frequency domain
%   27			shift spectrum by phase modulating the FID
%   28			maximum entropy (MEM) reconstruction
%   29        		running average 1D
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
%  113			phase correction 2d
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
%  131 			shift spectrum by phase modulating the FID 2D
%  132 			delete current row/column from 2D matrix
%  133			maximum entropy (MEM) reconstruction 2D
%  134  		running average 2D
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
%Set dimension-specific parameters
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


try
  for QTEMP40=2:size(QmatNMR.ExecutingMacro, 1)
    switch (QmatNMR.ExecutingMacro(QTEMP40, 1))
      case 0		%do the undo ... or undo the do that was
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, 'Undo the previous action');
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
      case 1		%shift data points 1D
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Shift data points 1D, ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 2)) ' points']);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 2		%swap whole echo 1D
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Swap whole echo 1D, swap around point ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 2))]);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 3		%extract from 1D
        if (QmatNMR.ExecutingMacro(QTEMP40, 4) == 0) 	%no increment specified in macro
          QTEMP = [num2str(QmatNMR.ExecutingMacro(QTEMP40, 2)) ':' num2str(QmatNMR.ExecutingMacro(QTEMP40, 3))];
  
        else
          QTEMP = [num2str(QmatNMR.ExecutingMacro(QTEMP40, 2)) ':' num2str(QmatNMR.ExecutingMacro(QTEMP40, 4)) ':' num2str(QmatNMR.ExecutingMacro(QTEMP40, 3))];
        end
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Extract from 1D, range = ' QTEMP]);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 4		%set size 1D
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Set size 1D, size = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 2))]);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 5		%FT 1D
        QTEMP = str2mat('Complex FT', 'Real FT', 'States', 'TPPI', 'Whole Echo', 'States-TPPI', 'Bruker qseq', 'Sine FT');
        QTEMP1 = [];
        if (QmatNMR.ExecutingMacro(QTEMP40, 4)) 	%inverse FT?
          QTEMP1 = ['Inverse'];
        end
  
        QTEMP1 = [QTEMP1 ' FT 1D, type = ' deblank(QTEMP(QmatNMR.ExecutingMacro(QTEMP40, 2), :))];
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, QTEMP1);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 6		%FFT shift 1D
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['FFT shift 1D ']);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 7		%flip l/r 1D
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Flip left/right 1D ']);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 8		%baseline correction peak list
        QmatNMR.StepWiseTempNumber = QmatNMR.StepWiseTempNumber + 1;
  
  
      case 9		%baseline correction finish
        QTEMP = str2mat('Polynomial', 'Sine', 'Exponential', 'Bernstein Polynomial', 'Cosine Series');
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Automatic 1D baseline correction, ' deblank(QTEMP(QmatNMR.ExecutingMacro(QTEMP40, 3), :)) ', order ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 4))]);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering QmatNMR.StepWiseTempNumber+1];
        QmatNMR.StepWiseTempNumber = 0;
  
  
      case 10		%linear prediction 1D
        QTEMP1 = QmatNMR.ExecutingMacro(QTEMP40, 2);	%determine type of linear prediction
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
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Linear prediction 1D, ' deblank(QTEMP2) ', ' deblank(QTEMP3) ', ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 3)) ' points']);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 11		%apodization 1D
        QmatNMR.lbTempstatus = QmatNMR.ExecutingMacro(QTEMP40, 2);
        switch QmatNMR.lbTempstatus
          case -99		%cos^2
  	  QTEMP1 = ['cos^2, phase = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 3))];
  
  	case -60		%block and exponential
  	  QTEMP1 = ['block and exponential, block = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 3)) ' points, LB = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 4)) ' Hz, SWH = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 5)) ' Hz'];
  
          case -50		%block and cos^2
  	  QTEMP1 = ['block and cos^2, block = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 3)) ' points'];
  
          case -40		%Hanning
  	  QTEMP1 = ['Hanning, phase = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 3))];
  
          case -30		%Hamming
  	  QTEMP1 = ['Hamming, phase = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 3))];
  
  	case 10			%gaussian
  	  QTEMP1 = ['gaussian, LB = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 3)) ' Hz, GB = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 4)) ' Hz, SWH = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 5)) ' Hz'];
  
  	case 50			%exponential
  	  QTEMP1 = ['exponential, LB = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 3)) ' Hz, SWH = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 4)) ' Hz'];
  
  	case 101		%gaussian for whole echo FID
  	  QTEMP1 = ['gaussian for whole echo, LB = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 3)) ' Hz, GB = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 4)) ' Hz, SWH = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 5)) ' Hz'];
  
  	case 501		%exponential for whole echo FID
  	  QTEMP1 = ['exponential for whole echo, LB = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 3)) ' Hz, SWH = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 4)) ' Hz'];
  
  	otherwise
  	  error('matNMR ERROR: Unknown code for apodization function!');
        end
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Apodization 1D, ' deblank(QTEMP1)]);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 12		%phase correction
        if QmatNMR.ExecutingMacro(QTEMP40, 5)	%there is a second order phase correction
          QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Phase correction 1D, 0th order =' num2str(QmatNMR.ExecutingMacro(QTEMP40, 2)) ' degrees, 1st order = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 3)) ' degrees, 2nd order = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 5)) ' degrees']);
  
        else
          QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Phase correction 1D, 0th order =' num2str(QmatNMR.ExecutingMacro(QTEMP40, 2)) ' degrees, 1st order = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 3)) ' degrees']);
        end
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 13		%convert Bruker qseq data
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Convert Bruker qseq data']);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 14		%user defined axis 1D/2D
        if (QmatNMR.ExecutingMacro(QTEMP40, 4) == 0) 	%num2str(QmatNMR.ExecutingMacro(QTEMP40, 4)) = QmatNMR.Dim
          QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['User defined axis 1D']);
        elseif (QmatNMR.ExecutingMacro(QTEMP40, 4)==1)
  
          QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['User defined axis TD2']);
        else
  
          QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['User defined axis TD1']);
        end
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering QmatNMR.StepWiseTempNumber+1];
        QmatNMR.StepWiseTempNumber = 0;
  
      case 15 		%1D DC offset correction
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['DC offset correction 1D, noise range = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 2)) ':' num2str(QmatNMR.ExecutingMacro(QTEMP40, 3))]);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 16		%remove Bruker digital filter 1D
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Remove Bruker digital filter, ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 2)) ' points']);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 17		%solvent suppression 1D
        QTEMP1 = str2mat('Gaussian', 'Sine-Bell', 'Rectangle');
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Solvent Suppression, ' deblank(QTEMP1(QmatNMR.ExecutingMacro(QTEMP40, 2), :)) ', width=' num2str(num2str(QmatNMR.ExecutingMacro(QTEMP40, 3))) ', extrapolate=' num2str(num2str(QmatNMR.ExecutingMacro(QTEMP40, 4)))]);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 18		%concatenate 1D
        QTEMP1 = str2mat('along TD2', 'along TD1');
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Concatenate 1D, ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 2)) ' times ' deblank(QTEMP1(QmatNMR.ExecutingMacro(QTEMP40, 3), :))]);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 19		%define external reference 1D
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, 'Define external reference');
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 20		%set integral from 1D
        if (QmatNMR.ExecutingMacro(QTEMP40, 4) == 0) 	%no increment specified in macro
          QTEMP = [num2str(QmatNMR.ExecutingMacro(QTEMP40, 2)) ':' num2str(QmatNMR.ExecutingMacro(QTEMP40, 3))];
  
        else
          QTEMP = [num2str(QmatNMR.ExecutingMacro(QTEMP40, 2)) ':' num2str(QmatNMR.ExecutingMacro(QTEMP40, 4)) ':' num2str(QmatNMR.ExecutingMacro(QTEMP40, 3))];
        end
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Set integral from 1D, value = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 5)) ', range = ' QTEMP]);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 21		%regrid spectrum 1D
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Regrid current 1D to new axis']);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 22		%noise filling 1D
        %
        %specify the range with noise
        %
        if (QmatNMR.ExecutingMacro(QTEMP40, 5) == 0) 	%no increment specified in macro
          QTEMP3 = [num2str(QmatNMR.ExecutingMacro(QTEMP40, 3)) ':' num2str(QmatNMR.ExecutingMacro(QTEMP40, 4))];
  
        else
          QTEMP3 = [num2str(QmatNMR.ExecutingMacro(QTEMP40, 3)) ':' num2str(QmatNMR.ExecutingMacro(QTEMP40, 5)) ':' num2str(QmatNMR.ExecutingMacro(QTEMP40, 4))];
        end
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Noise filling 1D, new size = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 2)) ', noise range = ' QTEMP3]);
  
  
      case 23		%Cadzow filtering 1D in time domain
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Cadzow filtering 1D in time domain']);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 24		%Cadzow filtering + LPSVD estimation 1D in time domain
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Cadzow filtering + LPSVD estimation 1D in time domain']);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 25		%Cadzow filtering 1D in frequency domain
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Cadzow filtering 1D in frequency domain']);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 26		%Cadzow filtering + LPSVD estimation 1D in frequency domain
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Cadzow filtering + LPSVD estimation 1D in frequency domain']);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 27		%shift spectrum by phase modulating the FID 1D
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Shift spectrum by phase modulating the FID, shifted by num2str(QmatNMR.ExecutingMacro(QTEMP40, 2)) times the spectral width']);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 28		%maximum entropy reconstruction 1D
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Maximum Entropy reconstruction 1D, ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 2)) ' points for new FID, order = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 4))]);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 29		%running average 1D
        QTEMP1 = str2mat('Gaussian', 'Sine-Bell', 'Rectangle');
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Running average, ' deblank(QTEMP1(QmatNMR.ExecutingMacro(QTEMP40, 2), :)) ', width=' num2str(num2str(QmatNMR.ExecutingMacro(QTEMP40, 3))) ', extrapolate=' num2str(num2str(QmatNMR.ExecutingMacro(QTEMP40, 4)))]);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
  
  
  %
  %2D functions
  %
      case 101		%FT 2D
        QTEMP = str2mat('Complex FT', 'Real FT', 'States', 'TPPI', 'Whole Echo', 'States-TPPI', 'Bruker qseq', 'Sine FT');
        QTEMP1 = [];
        if (QmatNMR.ExecutingMacro(QTEMP40, 5)) 	%inverse FT?
          QTEMP1 = ['Inverse'];
        end
        QTEMP1 = [QTEMP1 ' FT TD' num2str(~(QmatNMR.ExecutingMacro(QTEMP40, 4)-1)+1) ', type = ' deblank(QTEMP(QmatNMR.ExecutingMacro(QTEMP40, 2), :))];
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, QTEMP1);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 102		%set size 2D
        %
        %check which dimensions have changed size
        %
        if (QmatNMR.ExecutingMacro(QTEMP40, 2) == -99)
        	QTEMP1 = 'unaltered';	%no change
        else
          QTEMP1 = num2str(QmatNMR.ExecutingMacro(QTEMP40, 2));
        end
        if (QmatNMR.ExecutingMacro(QTEMP40, 3) == -99)
        	QTEMP2 = 'unaltered'; 	%no change
        else
          QTEMP2 = num2str(QmatNMR.ExecutingMacro(QTEMP40, 3));
        end
  
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Set size 2D, size TD2 = ' QTEMP1 ', size TD1 = ' QTEMP2]);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 103		%shift data points
        if QmatNMR.ExecutingMacro(QTEMP40, 5) 	%action operated on a single slice
          QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Shift data points single slice of 2D, TD' num2str(~(QmatNMR.ExecutingMacro(QTEMP40, 4)-1)+1) ', ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 2)) ' points, slice ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 6))]);
  
        else				%action operated on the entire dimension
          QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Shift data points 2D, TD' num2str(~(QmatNMR.ExecutingMacro(QTEMP40, 4)-1)+1) ', ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 2)) ' points']);
        end
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 104		%swap whole echo
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Swap whole echo 2D, TD' num2str(~(QmatNMR.ExecutingMacro(QTEMP40, 3)-1)+1) ', swap around point ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 2))]);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 105		%FFTshift
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['FFT shift 2D, TD' num2str(~(QmatNMR.ExecutingMacro(QTEMP40, 2)-1)+1)]);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 106		%flip l/r
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Flip left/right 2D, TD' num2str(~(QmatNMR.ExecutingMacro(QTEMP40, 2)-1)+1)]);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 107		%apodize 2D
        QmatNMR.lbTempstatus = QmatNMR.ExecutingMacro(QTEMP40, 2);
        switch QmatNMR.lbTempstatus
          case -99		%cos^2
  	  QTEMP1 = ['cos^2, phase = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 5))];
  
  	case -60		%block and exponential
  	  QTEMP1 = ['block and exponential, block length = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 5)) ' points, LB = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 6)) ' Hz, SWH = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 7)) ' Hz'];
  
          case -50		%block and cos^2
  	  QTEMP1 = ['block and cos^2, block = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 5)) ' points'];
  
          case -40		%Hanning
  	  QTEMP1 = ['Hanning, phase = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 5))];
  
          case -30		%Hamming
  	  QTEMP1 = ['Hamming, phase = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 5))];
  
  	case 10			%gaussian
  	  QTEMP1 = ['gaussian, LB = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 5)) ' Hz, GB = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 6)) ' Hz, SWH = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 7)) ' Hz'];
  
  	case 50			%exponential
  	  QTEMP1 = ['exponential, LB = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 5)) ' Hz, SWH = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 6)) ' Hz'];
  
  	case 100		%shifting gaussian
  	  QTEMP = str2mat('positive', 'negative');
  	  QTEMP1 = ['shifting gaussian, LB = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 5)) ' Hz, SWH TD 2 = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 6)) ' Hz, SWH TD 1 = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 7)) ' Hz, Shearing Factor = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 8)) ', pos. echo max. = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 9)) ', shift = ' deblank(QTEMP(QmatNMR.ExecutingMacro(QTEMP40, 10)))];
  
  	case 101		%gaussian for whole echo FID
  	  QTEMP1 = ['gaussian (echo), LB = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 5)) ' Hz, GB = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 6)) ' Hz, SWH = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 7)) ' Hz'];
  
  	case 501		%exponential for whole echo FID
  	  QTEMP1 = ['exponential (echo), LB = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 5)) ' Hz, SWH = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 6)) ' Hz'];
  
  	case 1001
  	  QTEMP1 = ['shifting gaussian (echo), LB = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 5)) ' Hz, SWH TD 2 = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 6)) ' Hz, SWH TD 1 = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 7)) ' Hz, Shearing = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 8)) ', pos. echo max. = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 9))];
  
  	otherwise
  	  error('matNMR ERROR: Unknown code for apodization function!');
        end
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Apodization 2D, TD' num2str(~(QmatNMR.ExecutingMacro(QTEMP40, 3)-1)+1) ', ' deblank(QTEMP1)]);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 108		%zero part of 2D
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Zero part of 2D, rows ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 2)) ':' num2str(QmatNMR.ExecutingMacro(QTEMP40, 4)) ':' num2str(QmatNMR.ExecutingMacro(QTEMP40, 3)) ', columns ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 5)) ':' num2str(QmatNMR.ExecutingMacro(QTEMP40, 7)) ':' num2str(QmatNMR.ExecutingMacro(QTEMP40, 6))]);
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
        if QmatNMR.ExecutingMacro(QTEMP40, 8) 	%action operated on a single slice
          if QmatNMR.ExecutingMacro(QTEMP40, 5)	%there is a second order phase correction
            QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Phase correction of single slice of 2D, TD' num2str(~(QmatNMR.ExecutingMacro(QTEMP40, 6)-1)+1) ', Slice = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 9)) ', 0th order = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 2)) ' degrees, 1st order = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 3)) ' degrees, 2nd order = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 5)) ' degrees']);
  
          else
            QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Phase correction of single slice of 2D, TD' num2str(~(QmatNMR.ExecutingMacro(QTEMP40, 6)-1)+1) ', Slice = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 9)) ', 0th order = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 2)) ' degrees, 1st order = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 3)) ' degrees']);
          end
  
        else				%action operated on the entire matrix
          if QmatNMR.ExecutingMacro(QTEMP40, 5)	%there is a second order phase correction
            QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Phase correction 2D, TD' num2str(~(QmatNMR.ExecutingMacro(QTEMP40, 6)-1)+1) ', 0th order = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 2)) ' degrees, 1st order = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 3)) ' degrees, 2nd order = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 5)) ' degrees']);
  
          else
            QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Phase correction 2D, TD' num2str(~(QmatNMR.ExecutingMacro(QTEMP40, 6)-1)+1) ', 0th order = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 2)) ' degrees, 1st order = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 3)) ' degrees']);
          end
        end
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 114		%extract from 2D
        if (QmatNMR.ExecutingMacro(QTEMP40, 6) == 0) 	%no increment specified in macro for TD2
          QTEMP1 = [num2str(QmatNMR.ExecutingMacro(QTEMP40, 2)) ':' num2str(QmatNMR.ExecutingMacro(QTEMP40, 3))];
  
        else
          QTEMP1 = [num2str(QmatNMR.ExecutingMacro(QTEMP40, 2)) ':' num2str(QmatNMR.ExecutingMacro(QTEMP40, 6)) ':' num2str(QmatNMR.ExecutingMacro(QTEMP40, 3))];
        end
        if (QmatNMR.ExecutingMacro(QTEMP40, 7) == 0) 	%no increment specified in macro for TD1
          QTEMP2 = [num2str(QmatNMR.ExecutingMacro(QTEMP40, 4)) ':' num2str(QmatNMR.ExecutingMacro(QTEMP40, 5))];
  
        else
          QTEMP2 = [num2str(QmatNMR.ExecutingMacro(QTEMP40, 4)) ':' num2str(QmatNMR.ExecutingMacro(QTEMP40, 7)) ':' num2str(QmatNMR.ExecutingMacro(QTEMP40, 5))];
        end
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Extract from 2D, range TD2 = ' QTEMP1 ', range TD1 = ' QTEMP2]);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 115		%symmetrize 2D
        QTEMP = QmatNMR.ExecutingMacro(QTEMP40, 2);
        if (QTEMP==1)
          QTEMP = 'average intensities';
        else
          QTEMP = 'highest intensities';
        end
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Symmetrize 2D, ' deblank(QTEMP)]);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 116		%shearing transformation
        QTEMP = QmatNMR.ExecutingMacro(QTEMP40, 2);
        if (QTEMP == 0)	%in frequency domain
          QTEMP1 = 'frequency domain';
  	QTEMP2 = num2str(QmatNMR.ExecutingMacro(QTEMP40, 3));	%shearing factor
  	if (QmatNMR.ExecutingMacro(QTEMP40, 6))
    	  QTEMP3 = ', vertical';
  	else
  	  QTEMP3 = ', horizontal';
  	end
  
        else		%in time domain
          QTEMP1 = 'time domain';
  	QTEMP2 = num2str(QmatNMR.ExecutingMacro(QTEMP40, 3));	%shearing factor
          QTEMP3 = '';
        end
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Shearing transformation, ' deblank(QTEMP1) ', shearing factor = ' deblank(QTEMP2) deblank(QTEMP3)]);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 117		%linear prediction 2D
        QTEMP1 = QmatNMR.ExecutingMacro(QTEMP40, 2);	%determine type of linear prediction
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
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Linear prediction 2D, TD' num2str(~(QmatNMR.ExecutingMacro(QTEMP40, 7)-1)+1) ', ' deblank(QTEMP2) ', ' deblank(QTEMP3) ', ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 3)) ' points']);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering QmatNMR.StepWiseTempNumber+1];
  
  
      case 118		%baseline correction 2D
        %
        %check whether the entire range must be baseline corrected
        %
        if (QmatNMR.ExecutingMacro(QTEMP40, 5) == -99)
        	QTEMP1 = '1';	%no change
        else
          QTEMP1 = num2str(QmatNMR.ExecutingMacro(QTEMP40, 5));
        end
        if (QmatNMR.ExecutingMacro(QTEMP40, 6) == -99)
          QTEMP2 = 'end';
  %        if (QmatNMR.Dim == 1)
  %          QTEMP2 = num2str(QmatNMR.SizeTD1);				%ending row/column
  %        else
  %          QTEMP2 = num2str(QmatNMR.SizeTD2);				%ending row/column
  %        end
        else
          QTEMP2 = num2str(QmatNMR.ExecutingMacro(QTEMP40, 6));
        end
  
        QTEMP = str2mat('Polynomial', 'Sine', 'Exponential', 'Bernstein Polynomial', 'Cosine Series');
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Baseline correction 2D, TD' num2str(~(QmatNMR.ExecutingMacro(QTEMP40, 2)-1)+1) ', ' deblank(QTEMP(QmatNMR.ExecutingMacro(QTEMP40, 3), :)) ', order  = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 4)) ', selected range = ' QTEMP1 ':' QTEMP2]);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering QmatNMR.StepWiseTempNumber+1];
        QmatNMR.StepWiseTempNumber = 0;
  
  
      case 119		%set integral 2D
        if (QmatNMR.ExecutingMacro(QTEMP40, 6) == 0) 	%no increment specified in macro for TD2
          QTEMP1 = [num2str(QmatNMR.ExecutingMacro(QTEMP40, 2)) ':' num2str(QmatNMR.ExecutingMacro(QTEMP40, 3))];
  
        else
          QTEMP1 = [num2str(QmatNMR.ExecutingMacro(QTEMP40, 2)) ':' num2str(QmatNMR.ExecutingMacro(QTEMP40, 6)) ':' num2str(QmatNMR.ExecutingMacro(QTEMP40, 3))];
        end
        if (QmatNMR.ExecutingMacro(QTEMP40, 7) == 0) 	%no increment specified in macro for TD1
          QTEMP2 = [num2str(QmatNMR.ExecutingMacro(QTEMP40, 4)) ':' num2str(QmatNMR.ExecutingMacro(QTEMP40, 5))];
  
        else
          QTEMP2 = [num2str(QmatNMR.ExecutingMacro(QTEMP40, 4)) ':' num2str(QmatNMR.ExecutingMacro(QTEMP40, 7)) ':' num2str(QmatNMR.ExecutingMacro(QTEMP40, 5))];
        end
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Set Integral 2D, range TD2 = ' QTEMP1 ', range TD1 = ' QTEMP2 ', integration value = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 8))]);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 120 		%Transpose 2D
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Transpose 2D']);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 121 		%2D DC offset correction
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['DC offset correction 2D, TD' num2str(~(QmatNMR.ExecutingMacro(QTEMP40, 2)-1)+1) ', noise range = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 3)) ':' num2str(QmatNMR.ExecutingMacro(QTEMP40, 4))]);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 122		%remove Bruker digital filter 2D
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Remove Bruker digital filter, ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 2)) ' points']);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 123		%solvent suppression 2D
        QTEMP1 = str2mat('Gaussian', 'Sine-Bell', 'Rectangle');
        QTEMP2 = str2mat('TD2', 'TD1');
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Solvent Suppression' deblank(QTEMP1(QmatNMR.ExecutingMacro(QTEMP40, 5), :)) ', ' deblank(QTEMP1(QmatNMR.ExecutingMacro(QTEMP40, 2), :)) ', width=' num2str(num2str(QmatNMR.ExecutingMacro(QTEMP40, 3))) ', extrapolate=' num2str(num2str(QmatNMR.ExecutingMacro(QTEMP40, 4)))]);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering QmatNMR.StepWiseTempNumber+1];
        QmatNMR.StepWiseTempNumber = 0;
  
  
      case 124		%concatenate 2D
        QTEMP1 = str2mat('along TD2', 'along TD1');
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Concatenate 2D, ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 2)) ' times ' deblank(QTEMP1(QmatNMR.ExecutingMacro(QTEMP40, 3), :))]);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 125		%define external reference 2D
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, 'Define external reference');
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 126		%LP 2D peak list
        QmatNMR.StepWiseTempNumber = QmatNMR.StepWiseTempNumber + 1;
  
  
      case 128		%SD 2D peak list
        QmatNMR.StepWiseTempNumber = QmatNMR.StepWiseTempNumber + 1;
  
      case 129		%noise filling 2D
        %
        %check which dimensions have changed size
        %
        if (QmatNMR.ExecutingMacro(QTEMP40, 2) == -99)
        	QTEMP1 = 'unaltered';	%no change
        else
          QTEMP1 = num2str(QmatNMR.ExecutingMacro(QTEMP40, 2));
        end
        if (QmatNMR.ExecutingMacro(QTEMP40, 3) == -99)
        	QTEMP2 = 'unaltered'; 	%no change
        else
          QTEMP2 = num2str(QmatNMR.ExecutingMacro(QTEMP40, 3));
        end
        %
        %specify the range with noise
        %
        if (QmatNMR.ExecutingMacro(QTEMP40, 8) == 0) 	%no increment specified in macro for TD2
          QTEMP3 = [num2str(QmatNMR.ExecutingMacro(QTEMP40, 4)) ':' num2str(QmatNMR.ExecutingMacro(QTEMP40, 5))];
  
        else
          QTEMP3 = [num2str(QmatNMR.ExecutingMacro(QTEMP40, 4)) ':' num2str(QmatNMR.ExecutingMacro(QTEMP40, 8)) ':' num2str(QmatNMR.ExecutingMacro(QTEMP40, 5))];
        end
        if (QmatNMR.ExecutingMacro(QTEMP40, 9) == 0) 	%no increment specified in macro for TD1
          QTEMP4 = [num2str(QmatNMR.ExecutingMacro(QTEMP40, 6)) ':' num2str(QmatNMR.ExecutingMacro(QTEMP40, 7))];
  
        else
          QTEMP4 = [num2str(QmatNMR.ExecutingMacro(QTEMP40, 6)) ':' num2str(QmatNMR.ExecutingMacro(QTEMP40, 9)) ':' num2str(QmatNMR.ExecutingMacro(QTEMP40, 7))];
        end
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Noise filling 2D, new size TD2 = ' QTEMP1 ', new size TD1 = ' QTEMP2 ', noise range TD2 = ' QTEMP3 ', noise range TD1 = ' QTEMP4]);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
      case 130		%regrid spectrum 2D
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Regrid current 2D to new axes']);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 131		%shift spectrum by phase modulating the FID 2D
        QTEMP1 = str2mat('along TD2', 'along TD1');
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Shift spectrum by phase modulating the FID' deblank(QTEMP1(QmatNMR.ExecutingMacro(QTEMP40, 3), :)) ', shifted by ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 2)) ' times the spectral width']);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 132		%Delete current row/column from the 2D matrix
        QTEMP1 = str2mat('row', 'column');
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Deleting ' deblank(QTEMP1(QmatNMR.ExecutingMacro(QTEMP40, 2), :)) ' ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 3)) ' from current 2D matrix']);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 133		%maximum entropy reconstruction 1D
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Maximum Entropy reconstruction 2D, TD'  num2str(~(QmatNMR.ExecutingMacro(QTEMP40, 5)-1)+1) ', ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 2)) ' points for new FID, order = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 4))]);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering QmatNMR.StepWiseTempNumber+1];
  
  
      case 134		%running average 2D
        QTEMP1 = str2mat('Gaussian', 'Sine-Bell', 'Rectangle');
        QTEMP2 = str2mat('TD2', 'TD1');
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Running average' deblank(QTEMP1(QmatNMR.ExecutingMacro(QTEMP40, 5), :)) ', ' deblank(QTEMP1(QmatNMR.ExecutingMacro(QTEMP40, 2), :)) ', width=' num2str(num2str(QmatNMR.ExecutingMacro(QTEMP40, 3))) ', extrapolate=' num2str(num2str(QmatNMR.ExecutingMacro(QTEMP40, 4)))]);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering QmatNMR.StepWiseTempNumber+1];
        QmatNMR.StepWiseTempNumber = 0;
  
  
  
  %
  %2D to 1D functions
  %
      case 201    	%diagonal
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Calculate Diagonal']);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 202   		%anti-diagonal
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Calculate Anti-Diagonal']);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 203 		%Sum TD1
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Calculate Sum TD1, range TD2 = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 2)) ':' num2str(QmatNMR.ExecutingMacro(QTEMP40, 3))]);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 204 		%Sum TD2
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Calculate Sum TD2, range TD1 = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 2)) ':' num2str(QmatNMR.ExecutingMacro(QTEMP40, 3))]);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 205 		%Skyline projection
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Calculate Skyline Projection, angle = ' num2str(QmatNMR.ExecutingMacro(QTEMP40, 2))]);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
  
  %
  %3D functions
  %
      case 301    	%define axis for 3rd dimension
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Axis for third dimension defined']);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
  
  
  %
  %set dimension-specific parameters
  %
      case 400		%
                          %set dimension-specific parameters and create default axis
       			%we don't want to see that in the stepwise window so we don't create a text entry
  			%The QmatNMR.StepWiseNumbering counter isn't incremented because this is not considered
  			%a separate processing step by the stepwise-processing routine
  			%
  
      case 401		%
                          %Force update of current slice in 2D
       			%we don't want to see that in the stepwise window so we don't create a text entry
  			%The QmatNMR.StepWiseNumbering counter isn't incremented because this is not considered
  			%a separate processing step by the stepwise-processing routine
  			%
  
  
  
  
  %
  %User-defined functions
  %
      case 666
        QmatNMR.TEMPUserCommandString = [QmatNMR.TEMPUserCommandString char(QmatNMR.ExecutingMacro(QTEMP40, 2:QmatNMR.MacroLength))];
        QmatNMR.StepWiseTempNumber = QmatNMR.StepWiseTempNumber + 1;
  
  
      case 667
        QTEMP1 = QmatNMR.TEMPUserCommandString;
        QmatNMR.TEMPUserCommandString = '';
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['User-defined fcn: "' deblank(QTEMP1) '"']);
  
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering QmatNMR.StepWiseTempNumber+1];
        QmatNMR.StepWiseTempNumber = 0;
  
  
  
  
  %
  %Plotting functions
  %
      case 700 		%Horizontal Stack plot
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Horizontal stack plot for TD' num2str(~(QmatNMR.ExecutingMacro(QTEMP40, 2)-1)+1)]);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
      case 701 		%Vertical Stack plot
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Vertical stack plot for TD' num2str(~(QmatNMR.ExecutingMacro(QTEMP40, 2)-1)+1)]);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
      case 702 		%1D bar plot
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['1D bar plot from current view']);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
      case 703 		%errorbar plot
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Errorbar plot from current view']);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
      case 704 		%show sidebands
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, ['Show sidebands in current view']);
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering 1];
  
  
      case 710 		%Used for storing selected axes
        QmatNMR.StepWiseTempNumber = QmatNMR.StepWiseTempNumber + 1;
  
      case 711 		%Used for storing strings
        QmatNMR.StepWiseTempNumber = QmatNMR.StepWiseTempNumber + 1;
  
      case 712 		%Evalulates stored strings
        QmatNMR.StepWiseTempNumber = QmatNMR.StepWiseTempNumber + 1;
  
      case 721 		%Axis On/Off/Etc
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, 'PLOTTING: AXES command');
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering QmatNMR.StepWiseTempNumber+1];
        QmatNMR.StepWiseTempNumber = 0;
  
      case 722 		%Clear Axis
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, 'PLOTTING: CLA (clear axis) command');
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering QmatNMR.StepWiseTempNumber+1];
        QmatNMR.StepWiseTempNumber = 0;
  
      case 723 		%Axis Colors
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, 'PLOTTING: change of axis colours');
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering QmatNMR.StepWiseTempNumber+1];
        QmatNMR.StepWiseTempNumber = 0;
  
      case 724 		%Axis Directions
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, 'PLOTTING: change of axis directions');
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering QmatNMR.StepWiseTempNumber+1];
        QmatNMR.StepWiseTempNumber = 0;
  
      case 725 		%Axis Labels
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, 'PLOTTING: change of axis labels');
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering QmatNMR.StepWiseTempNumber+1];
        QmatNMR.StepWiseTempNumber = 0;
  
      case 726 		%Axis Locations
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, 'PLOTTING: change of axis locations');
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering QmatNMR.StepWiseTempNumber+1];
        QmatNMR.StepWiseTempNumber = 0;
  
      case 727 		%Axis Position
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, 'PLOTTING: change of axis position');
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering QmatNMR.StepWiseTempNumber+1];
        QmatNMR.StepWiseTempNumber = 0;
  
      case 728 		%Title
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, 'PLOTTING: change of title');
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering QmatNMR.StepWiseTempNumber+1];
        QmatNMR.StepWiseTempNumber = 0;
  
      case 729 		%Box
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, 'PLOTTING: change box status');
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering QmatNMR.StepWiseTempNumber+1];
        QmatNMR.StepWiseTempNumber = 0;
  
      case 730 		%Font Properties
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, 'PLOTTING: change font properties');
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering QmatNMR.StepWiseTempNumber+1];
        QmatNMR.StepWiseTempNumber = 0;
  
      case 731 		%Grid
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, 'PLOTTING: change grid status');
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering QmatNMR.StepWiseTempNumber+1];
        QmatNMR.StepWiseTempNumber = 0;
  
      case 732 		%Hold
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, 'PLOTTING: change hold status');
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering QmatNMR.StepWiseTempNumber+1];
        QmatNMR.StepWiseTempNumber = 0;
  
      case 733 		%Line Style
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, 'PLOTTING: change line style');
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering QmatNMR.StepWiseTempNumber+1];
        QmatNMR.StepWiseTempNumber = 0;
  
      case 734 		%Line Width
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, 'PLOTTING: change line width');
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering QmatNMR.StepWiseTempNumber+1];
        QmatNMR.StepWiseTempNumber = 0;
  
      case 735 		%Marker Style
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, 'PLOTTING: change marker style');
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering QmatNMR.StepWiseTempNumber+1];
        QmatNMR.StepWiseTempNumber = 0;
  
      case 736 		%Marker Size
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, 'PLOTTING: change marker size');
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering QmatNMR.StepWiseTempNumber+1];
        QmatNMR.StepWiseTempNumber = 0;
  
      case 737 		%Scaling Limits
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, 'PLOTTING: change scaling limits');
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering QmatNMR.StepWiseTempNumber+1];
        QmatNMR.StepWiseTempNumber = 0;
  
      case 738 		%Scaling Types
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, 'PLOTTING: change scaling types');
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering QmatNMR.StepWiseTempNumber+1];
        QmatNMR.StepWiseTempNumber = 0;
  
      case 739 		%Shading
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, 'PLOTTING: change shading type');
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering QmatNMR.StepWiseTempNumber+1];
        QmatNMR.StepWiseTempNumber = 0;
  
      case 740 		%Tick Direction
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, 'PLOTTING: change tick directions');
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering QmatNMR.StepWiseTempNumber+1];
        QmatNMR.StepWiseTempNumber = 0;
  
      case 741 		%Tick Labels
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, 'PLOTTING: change tick labels');
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering QmatNMR.StepWiseTempNumber+1];
        QmatNMR.StepWiseTempNumber = 0;
  
      case 742 		%Tick Lengths
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, 'PLOTTING: change tick lengths');
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering QmatNMR.StepWiseTempNumber+1];
        QmatNMR.StepWiseTempNumber = 0;
  
      case 743 		%Tick Positions
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, 'PLOTTING: change tick positions');
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering QmatNMR.StepWiseTempNumber+1];
        QmatNMR.StepWiseTempNumber = 0;
  
      case 744 		%Axis View
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, 'PLOTTING: change of axis view settings');
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering QmatNMR.StepWiseTempNumber+1];
        QmatNMR.StepWiseTempNumber = 0;
  
      case 745 		%Super Title
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, 'PLOTTING: supertitle added to plot');
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering QmatNMR.StepWiseTempNumber+1];
        QmatNMR.StepWiseTempNumber = 0;
  
      case 746 		%Light
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, 'PLOTTING: light added to/removed from plot');
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering QmatNMR.StepWiseTempNumber+1];
        QmatNMR.StepWiseTempNumber = 0;
  
      case 750 		%Color axis
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, 'PLOTTING: CAXIS command');
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering QmatNMR.StepWiseTempNumber+1];
        QmatNMR.StepWiseTempNumber = 0;
  
      case 751 		%Colour bars
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, 'PLOTTING: change colour bar status');
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering QmatNMR.StepWiseTempNumber+1];
        QmatNMR.StepWiseTempNumber = 0;
  
      case 752 		%Colour map
        QmatNMR.StepWiseText = str2mat(QmatNMR.StepWiseText, 'PLOTTING: change colour map');
        QmatNMR.StepWiseNumbering = [QmatNMR.StepWiseNumbering QmatNMR.StepWiseTempNumber+1];
        QmatNMR.StepWiseTempNumber = 0;
  
  
      otherwise
        error('matNMR ERROR:  Unknown code encountered while processing macro!');
    end
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
