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
%RunMacro.m
%
%This script handles the execution of a macro in matNMR. Basically everything that needs to
%be done to execute a command before going into the normal matNMR code, is done by this
%routine.
%The following codes are used for the various matNMR functions:
%
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
%  750 			Colour axis
%  751 			Colour bars
%  752 			Colour map
%

try
  watch
  
  regelUNDO
  
  QTEMP1 = size(QmatNMR.ExecutingMacro);
  QmatNMR.BaslcorPeakList = [];	%this variable contains the peak list for the baseline correction in matNMR.
  			%It has to be cleared because else error can be created when more than one
  			%baseline corrections are done consecutively.
  QmatNMR.BusyWithMacro = 1;
  QmatNMR.TEMPUserCommandString = '';
  QmatNMR.TEMPCommandString = '';
  QmatNMR.SelectedAxes = [];	%contains the list of selected axes in a plotting macro
  
  for QMacroCount=2:QTEMP1(1)
    switch QmatNMR.ExecutingMacro(QMacroCount, 1)
      case 0		%do the undo ... or undo the do that was
        doUnDo
      
      case 1		%shift data points 1D
        QmatNMR.buttonList = 1;
        QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 2), 10);
        set(QmatNMR.Four, 'value', QmatNMR.ExecutingMacro(QMacroCount, 3));
        QmatNMR.Dim = 0;
        resetfourmode
        regelleftshift
  
        
      case 2		%swap whole echo 1D  
        QmatNMR.buttonList = 1;
        QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 2), 10);
        QmatNMR.Dim = 0;
        regelswapecho
  
  
      case 3		%extract from 1D
        QmatNMR.buttonList = 1;
        if (QmatNMR.ExecutingMacro(QMacroCount, 4) == 0) 	%no increment specified in macro
          QmatNMR.uiInput1 = [num2str(QmatNMR.ExecutingMacro(QMacroCount, 2), 10) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 3), 10)];
  
        else
          QmatNMR.uiInput1 = [num2str(QmatNMR.ExecutingMacro(QMacroCount, 2), 10) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 4), 10) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 3), 10)];
        end
        QmatNMR.Dim = 0;
        if (QmatNMR.RulerXAxis == 0)	%use default axis for plotting of spectra
          GetDefaultAxis
        end
        regelextract1d
      
  
      case 4		%set size 1D
        QmatNMR.buttonList = 1;
        QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 2), 10);
        set(QmatNMR.Four, 'value', QmatNMR.ExecutingMacro(QMacroCount, 3));
        QmatNMR.Dim = 0;
        resetfourmode
        regelsize1d

        
      case 5		%FT 1D
        QmatNMR.Dim = 0;
        set(QmatNMR.Four, 'value', QmatNMR.ExecutingMacro(QMacroCount, 2));
        resetfourmode
        QmatNMR.fftstatus = QmatNMR.ExecutingMacro(QMacroCount, 3);
        QmatNMR.InverseFTflag = QmatNMR.ExecutingMacro(QMacroCount, 4);
        set(QmatNMR.fftstatusbutton, 'value', QmatNMR.fftstatus); 	%set FFT status flag in main window
        four1d

        
      case 6		%FFT shift 1D
        QmatNMR.Dim = 0;
        shiftFFT1d
        
        
      case 7		%flip l/r 1D
        QmatNMR.Dim = 0;
        flipspec;
      
      
      case 8		%baseline correction peak list
        QmatNMR.BaslcorPeakList = [QmatNMR.BaslcorPeakList QmatNMR.ExecutingMacro(QMacroCount, 1+find(QmatNMR.ExecutingMacro(QMacroCount, 2:QmatNMR.MacroLength)))];
      
        
      case 9		%baseline correction finish
        QmatNMR.Dim = 0;
        asaanpas					%redraw spectrum before continueing (was easier than
        						%changing all the code such that no redrawing is necessary)
        basl1dmenu
        
        set(QmatNMR.bas3, 'value', QmatNMR.ExecutingMacro(QMacroCount, 3));                     %function
        set(QmatNMR.bas5, 'string', num2str(QmatNMR.ExecutingMacro(QMacroCount, 4)));   %order
  
        QmatNMR.NumPeaks = length(QmatNMR.BaslcorPeakList)/2 - 1;
        QmatNMR.baslcornoise = [];
        for QTEMP=1:QmatNMR.NumPeaks+1
          QmatNMR.baslcornoise = [QmatNMR.baslcornoise (QmatNMR.BaslcorPeakList((QTEMP-1)*2+1):QmatNMR.BaslcorPeakList(QTEMP*2))];
        end
        figure(QmatNMR.Basl1Dfig);
        doebasl1dcor
        QTEMP = 2;      %accept fit
        QmatNMR.FitPerformed = 1;       %automatic fit
        stopbasl1d
  
        QmatNMR.BaslcorPeakList = [];	%this variable contains the peak list for the baseline correction in matNMR.
  				%It has to be cleared because else error can be created when more than one
  				%baseline corrections are done consecutively.
  
  
      
      case 10		%linear prediction 1D
        QmatNMR.Dim = 0;
        QmatNMR.LPtype = QmatNMR.ExecutingMacro(QMacroCount, 2);
        QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 3));
        QmatNMR.uiInput2 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 4));
        QmatNMR.uiInput3 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 5));
        QmatNMR.uiInput4 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 6));
        regellp1d
        
      case 11		%apodization 1D
        QmatNMR.Dim = 0;
        QmatNMR.lbTempstatus = QmatNMR.ExecutingMacro(QMacroCount, 2);
        switch QmatNMR.lbTempstatus
          case -99		%cos^2
  	  QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 3));
  	  
  	case -60		%block and exponential
  	  QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 3));
  	  QmatNMR.uiInput2 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 4));
  	  QmatNMR.SW1D = QmatNMR.ExecutingMacro(QMacroCount, 5);
        
          case -50		%block and cos^2
  	  QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 3));
  	  
          case -40		%Hanning
  	  QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 3));
  	  
          case -30		%Hamming
  	  QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 3));
  	  
  	case 10			%gaussian
  	  QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 3));
  	  QmatNMR.uiInput2 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 4));
  	  QmatNMR.SW1D = QmatNMR.ExecutingMacro(QMacroCount, 5);
  	  
  	case 50			%exponential
  	  QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 3));
  	  QmatNMR.SW1D = QmatNMR.ExecutingMacro(QMacroCount, 4);
  	
  	case 101		%gaussian for whole echo FID  
  	  QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 3));
  	  QmatNMR.uiInput2 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 4));
  	  QmatNMR.SW1D = QmatNMR.ExecutingMacro(QMacroCount, 5);
  
  	case 501		%exponential for whole echo FID
  	  QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 3));
  	  QmatNMR.SW1D = QmatNMR.ExecutingMacro(QMacroCount, 4);
  	  
  	otherwise
  	  error('matNMR ERROR: Unknown code for apodization function!');
        end
        apodize1d		%calculate the apodization function
      
      case 12		%phase correction
        QmatNMR.Dim = 0;
        QmatNMR.fase0 = 0;
        QmatNMR.dph0 = QmatNMR.ExecutingMacro(QMacroCount, 2);
        QmatNMR.fase1 = 0;
        QmatNMR.dph1 = QmatNMR.ExecutingMacro(QMacroCount, 3);
  
        if (QmatNMR.ExecutingMacro(QMacroCount, 6) == 1)
        	%
          %Now, the reference for the first-order phase correction is stored in the history macro in the unit
          %of the axis. To ensure backward compatibility, a flag is added to the history macro. Old macros
          %will have a 0 in this entry.
          %
  
          QmatNMR.fase1start = QmatNMR.ExecutingMacro(QMacroCount, 4);
          %
          %determine the position of the reference for first-order phase correction from the current axis
          %
          QmatNMR.fase1startIndex = interp1(QmatNMR.Axis1D, (1:QmatNMR.Size1D).', QmatNMR.fase1start);
  
        else
          QmatNMR.fase1startIndex = QmatNMR.ExecutingMacro(QMacroCount, 4);
          QmatNMR.fase1start = QmatNMR.Axis1D(QmatNMR.fase1startIndex);
        end
        
        QmatNMR.fase2 = 0;
        QmatNMR.dph2 = QmatNMR.ExecutingMacro(QMacroCount, 5);
        setphase1d
        
      case 13		%convert Bruker qseq data
        QmatNMR.Dim = 0;
        convertBrukerqseq1d
        
      case 14		%user defined axis 1D/2D
        QmatNMR.buttonList = 1;
        QmatNMR.Dim = QmatNMR.ExecutingMacro(QMacroCount, 4);
        QmatNMR.SF1D = QmatNMR.ExecutingMacro(QMacroCount, 5);
        QmatNMR.SW1D = QmatNMR.ExecutingMacro(QMacroCount, 6);
        if (QmatNMR.Dim > 0)	
          getcurrentspectrum	%set the QmatNMR.Size1D variable
          Qspcrel			%set the QmatNMR.Size1D variable
  	
  	%in case of a 2D set the spectral frequency and the sweepwidth accordingly
  	if (QmatNMR.Dim==1)
  	  QmatNMR.SFTD2 = QmatNMR.SF1D;
  	  QmatNMR.SWTD2 = QmatNMR.SW1D;
  	else
  	  QmatNMR.SFTD1 = QmatNMR.SF1D;
  	  QmatNMR.SWTD1 = QmatNMR.SW1D;
  	end  
        end
        
        %
        %for a linear axis we define a string that codes for the axis vector
        %non-linear axes are stored entirely in the macro
        %
        if (QmatNMR.ExecutingMacro(QMacroCount, 7) == 0)
          QmatNMR.uiInput1 = [num2str(QmatNMR.ExecutingMacro(QMacroCount, 3) + QmatNMR.ExecutingMacro(QMacroCount, 2), 20) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 2), 20) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 3) + QmatNMR.Size1D*QmatNMR.ExecutingMacro(QMacroCount, 2), 20)];
        end
        regelaxis1d
        
      case 15 		%1D DC offset correction
        QmatNMR.buttonList = 1;
        QmatNMR.Dim = 0;
        QmatNMR.uiInput1 = [num2str(QmatNMR.ExecutingMacro(QMacroCount, 2)) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 3))];
        DCcorr1d
  
  
      case 16		%remove Bruker digital filter 1D
        QmatNMR.buttonList = 1;
        QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 2), 14);
        set(QmatNMR.Four, 'value', QmatNMR.ExecutingMacro(QMacroCount, 3));
        resetfourmode
        QmatNMR.Dim = 0;
        regelBrukerdig
  
  
      case 17		%solvent suppression 1D
        QmatNMR.buttonList = 1;
        QmatNMR.uiInput1 = QmatNMR.ExecutingMacro(QMacroCount, 2);
        QmatNMR.uiInput2 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 3));
        QmatNMR.uiInput3 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 4));
        QmatNMR.Dim = 0;
        regelsolventsuppression1d
  
  
      case 18		%concatenate 1D
        QmatNMR.buttonList = 1;
        QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 2));
        QmatNMR.uiInput2 = QmatNMR.ExecutingMacro(QMacroCount, 3);
        QmatNMR.Dim = 0;
        regelconcatenate
  
  
      case 19		%define external reference 1D
        QmatNMR.buttonList = 1;
        QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 2),10);
        QmatNMR.uiInput2 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 3),10);
        QmatNMR.uiInput3 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 4));
        QmatNMR.uiInput4 = '';
        QmatNMR.Dim = 0;
        regeldefinereference
  
  
      case 20		%set integral for 1D
        QmatNMR.buttonList = 1;
        if (QmatNMR.ExecutingMacro(QMacroCount, 4) == 0) 	%no increment specified in macro
          QmatNMR.uiInput1 = [num2str(QmatNMR.ExecutingMacro(QMacroCount, 2)) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 3))];
  
        else
          QmatNMR.uiInput1 = [num2str(QmatNMR.ExecutingMacro(QMacroCount, 2)) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 4)) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 3))];
        end
        QmatNMR.uiInput2 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 5));
        QmatNMR.Dim = 0;
        if (QmatNMR.RulerXAxis == 0)	%use default axis for plotting of spectra
          GetDefaultAxis
        end
        regelsetintegral1d
        
      case 21		%regrid spectrum 1D
        QmatNMR.buttonList = 1;
        %
        %for a linear axis we define a string that codes for the axis vector
        %non-linear axes are stored entirely in the macro
        %
        if (QmatNMR.ExecutingMacro(QMacroCount, 4) == 0)
          QmatNMR.uiInput1 = [num2str(QmatNMR.ExecutingMacro(QMacroCount, 3) + QmatNMR.ExecutingMacro(QMacroCount, 2), 20) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 2), 20) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 3) + QmatNMR.ExecutingMacro(QMacroCount, 5)*QmatNMR.ExecutingMacro(QMacroCount, 2), 20)];
        end
        
        QmatNMR.uiInput2 = QmatNMR.ExecutingMacro(QMacroCount, 6);
        regelregrid1d
        
      case 22		%noise filling 1D  
        QmatNMR.buttonList = 1;
        QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 2));
        %
        %define the range with noise
        %
        if (QmatNMR.ExecutingMacro(QMacroCount, 5) == 0) 	%no increment specified in macro for TD2
          QmatNMR.uiInput2 = [num2str(QmatNMR.ExecutingMacro(QMacroCount, 3)) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 4))];
  
        else
          QmatNMR.uiInput2 = [num2str(QmatNMR.ExecutingMacro(QMacroCount, 3)) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 5)) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 4))];
        end
        regelnoisefilling1d
  
      
      case 23		%Cadzow filtering 1D in time domain
        QmatNMR.Dim = 0;
        QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 2));
        QmatNMR.uiInput2 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 3));
        QmatNMR.uiInput3 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 4));
        regelcadzow1d
  
      
      case 24		%Cadzow filtering + LPSVD estimation 1D in time domain
        QmatNMR.Dim = 0;
        QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 2));
        QmatNMR.uiInput2 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 3));
        QmatNMR.uiInput3 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 4));
        QmatNMR.uiInput4 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 5));
        regelcadzowlpsvd1d
  
      
      case 25		%Cadzow filtering 1D frequency domain
        QmatNMR.Dim = 0;
        QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 2));
        
        QTEMP1 = QmatNMR.ExecutingMacro(QMacroCount, 4:end);
        QmatNMR.uiInput2 = '[]';
        QmatNMR.CadzowNumPeaks = 0;
        for QTEMP2 = 1:length(QTEMP1)
          if (QTEMP1(QTEMP2))
            QmatNMR.uiInput2 = [QmatNMR.uiInput2(1:end-1) ' ' num2str(QTEMP1(QTEMP2)) ']'];
            QmatNMR.CadzowNumPeaks = QmatNMR.CadzowNumPeaks + 1;
          end
        end
        QmatNMR.CadzowWindows = reshape(QmatNMR.CadzowWindows, 2, QmatNMR.CadzowNumPeaks).';
  
        QmatNMR.uiInput3 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 3));
  
        regelcadzow1d
  
      
      case 26		%Cadzow filtering + LPSVD estimation 1D in frequency domain
        QmatNMR.Dim = 0;
        QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 2));
        
        QTEMP1 = QmatNMR.ExecutingMacro(QMacroCount, 4:end);
        QmatNMR.uiInput2 = '[]';
        QmatNMR.CadzowNumPeaks = 0;
        for QTEMP2 = 1:length(QTEMP1)
          if (QTEMP1(QTEMP2))
            QmatNMR.uiInput2 = [QmatNMR.uiInput2(1:end-1) ' ' num2str(QTEMP1(QTEMP2)) ']'];
            QmatNMR.CadzowNumPeaks = QmatNMR.CadzowNumPeaks + 1;
          end
        end
        QmatNMR.CadzowWindows = reshape(QmatNMR.CadzowWindows, 2, QmatNMR.CadzowNumPeaks).';
  
        QmatNMR.uiInput3 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 4));
        regelcadzowlpsvd1d
      
      case 27		%shift spectrum by phase modulating the FID
        QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 2));
        regelshiftspectrum1d
  
      
      case 28		%maximum entropy reconstruction 1D
        QmatNMR.Dim = 0;
        QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 3));
        QmatNMR.uiInput2 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 4));
        QmatNMR.uiInput3 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 5));
        regelmem1d
  
  
      case 29		%running average 1D
        QmatNMR.buttonList = 1;
        QmatNMR.uiInput1 = QmatNMR.ExecutingMacro(QMacroCount, 2);
        QmatNMR.uiInput2 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 3));
        QmatNMR.uiInput3 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 4));
        QmatNMR.Dim = 0;
        regelrunningav1d
  
  
  
  
  
  
  %
  %2D functions
  %
      case 101		%FT 2D
        set(QmatNMR.Four, 'value', QmatNMR.ExecutingMacro(QMacroCount, 2));
        QmatNMR.fftstatus = QmatNMR.ExecutingMacro(QMacroCount, 3);
        set(QmatNMR.fftstatusbutton, 'value', QmatNMR.fftstatus); 	%set FFT status flag in main window
        QmatNMR.Dim = QmatNMR.ExecutingMacro(QMacroCount, 4);
        QmatNMR.InverseFTflag = QmatNMR.ExecutingMacro(QMacroCount, 5);
        resetfourmode
        setfourmode
        four2d
        
      case 102		%set size 2D  
        QmatNMR.buttonList = 1;
        %
        %check which dimensions have changed size
        %
        if (QmatNMR.ExecutingMacro(QMacroCount, 2) == -99)
        	QmatNMR.uiInput1 = num2str(QmatNMR.SizeTD2, 10);	%no change
        else
          QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 2), 10);
        end
        if (QmatNMR.ExecutingMacro(QMacroCount, 3) == -99)
        	QmatNMR.uiInput2 = num2str(QmatNMR.SizeTD1, 10);	%no change
        else
          QmatNMR.uiInput2 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 3), 10);
        end
        regelsize2d
        
      case 103		%shift data points  
        QmatNMR.buttonList = 1;
        QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 2));
        set(QmatNMR.Four, 'value', QmatNMR.ExecutingMacro(QMacroCount, 3));
        QmatNMR.Dim = QmatNMR.ExecutingMacro(QMacroCount, 4);
        QmatNMR.SingleSlice = QmatNMR.ExecutingMacro(QMacroCount, 5);
        if (QmatNMR.SingleSlice)
          if (QmatNMR.Dim == 1)
            QmatNMR.rijnr = QmatNMR.ExecutingMacro(QMacroCount, 6);
          else
            QmatNMR.kolomnr = QmatNMR.ExecutingMacro(QMacroCount, 6);
          end
        end
        resetfourmode
        setfourmode
        regelleftshift
        
      case 104		%swap whole echo
        QmatNMR.buttonList = 1;
        QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 2));
        QmatNMR.Dim = QmatNMR.ExecutingMacro(QMacroCount, 3);
        regelswapecho
      
      case 105		%FFTshift
        QmatNMR.Dim = QmatNMR.ExecutingMacro(QMacroCount, 2);
        shiftFFT2d
        
      case 106		%flip l/r  
        QmatNMR.Dim = QmatNMR.ExecutingMacro(QMacroCount, 2);
        flipspec;
        
      case 107		%apodize 2D
        QmatNMR.lbTempstatus = QmatNMR.ExecutingMacro(QMacroCount, 2);
        QmatNMR.Dim = QmatNMR.ExecutingMacro(QMacroCount, 3);
        set(QmatNMR.Four, 'value', QmatNMR.ExecutingMacro(QMacroCount, 4));
        resetfourmode
        setfourmode
        getcurrentspectrum		%this is necessary to set the QmatNMR.Size1D variable according to the dimension
        Qspcrel
        
        switch QmatNMR.lbTempstatus
          case -99		%cos^2
  	  QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 5));
  	  QmatNMR.uiInput2 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 6));
  	  
  	case -60		%block and exponential
  	  QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 5));
  	  QmatNMR.uiInput2 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 6));
  	  QmatNMR.SW1D = QmatNMR.ExecutingMacro(QMacroCount, 7);
        
          case -50		%block and cos^2
  	  QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 5));
  	  
          case -40		%Hanning
  	  QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 5));
  	  
          case -30		%Hamming
  	  QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 5));
  	  
  	case 10			%gaussian
  	  QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 5));
  	  QmatNMR.uiInput2 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 6));
  	  QmatNMR.SW1D = QmatNMR.ExecutingMacro(QMacroCount, 7);
  	  
  	case 50			%exponential
  	  QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 5));
  	  QmatNMR.SW1D = QmatNMR.ExecutingMacro(QMacroCount, 6);
  	
  	case 100		%shifting gaussian
  	  QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 5));
  	  QmatNMR.uiInput2 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 6));
  	  QmatNMR.uiInput3 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 7));
  	  QmatNMR.uiInput4 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 8));
  	  QmatNMR.uiInput5 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 9));
  	  QmatNMR.uiInput6 = num2str(QmatNMR.ExecutingMacro(QMacroCount,10));
  
  	case 101		%gaussian for whole echo FID  
  	  QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 5));
  	  QmatNMR.uiInput2 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 6));
  	  QmatNMR.SW1D = QmatNMR.ExecutingMacro(QMacroCount, 7);
  
  	case 501		%exponential for whole echo FID
  	  QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 5));
  	  QmatNMR.SW1D = QmatNMR.ExecutingMacro(QMacroCount, 6);
  	  
  	case 1001
  	  QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 5));
  	  QmatNMR.uiInput2 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 6));
  	  QmatNMR.uiInput3 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 7));
  	  QmatNMR.uiInput4 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 8));
  	  QmatNMR.uiInput5 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 9));
  	
  	otherwise
  	  error('matNMR ERROR: Unknown code for apodization function!');
        end
        apodize1d	    
        apodize2d
        
      case 108		%zero part of 2D
        if (QmatNMR.ExecutingMacro(QMacroCount, 2))
          QmatNMR.uiInput1 = [num2str(QmatNMR.ExecutingMacro(QMacroCount, 2)) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 4)) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 3))];
        else
          QmatNMR.uiInput1 = [];
        end
  
        if (QmatNMR.ExecutingMacro(QMacroCount, 5))
          QmatNMR.uiInput2 = [num2str(QmatNMR.ExecutingMacro(QMacroCount, 5)) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 7)) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 6))];
        else
          QmatNMR.uiInput2 = [];
        end
        regelzero2d
  
      case 109		%convert Bruker qseq to TPPI/TPPI data
        convertBrukerqseq2d
        
      case 110		%convert Bruker States to matNMR
        regelconvertBruker
        
      case 111		%convert Varian States to matNMR
        regelconvertVarian
        
      case 127		%convert Echo / Anti-Echo to Hypercomplex
        regelconvertEAE
        
      case 112		%start States processing
        defstates
      
      case 113		%phase correction 2D
        QmatNMR.bezigmetfase = 1;
        QmatNMR.fase0 = QmatNMR.ExecutingMacro(QMacroCount, 2);
        QmatNMR.fase1 = QmatNMR.ExecutingMacro(QMacroCount, 3);
  
        if (QmatNMR.ExecutingMacro(QMacroCount, 10) == 1)
        	%
          %Now, the reference for the first-order phase correction is stored in the history macro in the unit
          %of the axis. To ensure backward compatibility, a flag is added to the history macro. Old macros
          %will have a 0 in this entry.
          %
  
          QmatNMR.fase1start = QmatNMR.ExecutingMacro(QMacroCount, 4);
          %
          %determine the position of the reference for first-order phase correction from the current axis
          %
          QmatNMR.fase1startIndex = interp1(QmatNMR.Axis1D, (1:QmatNMR.Size1D).', QmatNMR.fase1start);
  
        else
          QmatNMR.fase1startIndex = QmatNMR.ExecutingMacro(QMacroCount, 4);
          QmatNMR.fase1start = QmatNMR.Axis1D(QmatNMR.fase1startIndex);
        end
  
        QmatNMR.fase2 = QmatNMR.ExecutingMacro(QMacroCount, 5);
        QmatNMR.Dim = QmatNMR.ExecutingMacro(QMacroCount, 6);
        set(QmatNMR.Four, 'value', QmatNMR.ExecutingMacro(QMacroCount, 7));
        QmatNMR.SingleSlice = QmatNMR.ExecutingMacro(QMacroCount, 8);
        if (QmatNMR.SingleSlice)
          if (QmatNMR.Dim == 1)
            QmatNMR.rijnr = QmatNMR.ExecutingMacro(QMacroCount, 9);
          else
            QmatNMR.kolomnr = QmatNMR.ExecutingMacro(QMacroCount, 9);
          end
        end
        resetfourmode
        setfourmode
        setphase2d
      
      case 114		%extract from 2D
        QmatNMR.buttonList = 1;
        if (QmatNMR.ExecutingMacro(QMacroCount, 6) == 0) 	%no increment specified in macro for TD2
          QmatNMR.uiInput1 = [num2str(QmatNMR.ExecutingMacro(QMacroCount, 2)) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 3))];
  
        else
          QmatNMR.uiInput1 = [num2str(QmatNMR.ExecutingMacro(QMacroCount, 2)) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 6)) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 3))];
        end
        if (QmatNMR.ExecutingMacro(QMacroCount, 7) == 0) 	%no increment specified in macro for TD1
          QmatNMR.uiInput2 = [num2str(QmatNMR.ExecutingMacro(QMacroCount, 4)) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 5))];
  
        else
          QmatNMR.uiInput2 = [num2str(QmatNMR.ExecutingMacro(QMacroCount, 4)) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 7)) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 5))];
        end
        regelextract2d
      
      case 115		%symmetrize 2D
        QTEMP1 = QmatNMR.ExecutingMacro(QMacroCount, 2);
        symmetrize2d
        
      case 116		%shearing transformation
        QTEMP = QmatNMR.ExecutingMacro(QMacroCount, 2);
        
        if (QTEMP == 0)	%in frequency domain
          QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 3));
          QmatNMR.uiInput2 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 4));
          QmatNMR.uiInput3 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 5));
          QmatNMR.uiInput4 = QmatNMR.ExecutingMacro(QMacroCount, 6);
  	regelshearingFD
  	
        else		%in time domain
          QmatNMR.Dim = 2;
          QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 3));
          QmatNMR.uiInput2 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 4));
          QmatNMR.uiInput3 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 5));
  	set(QmatNMR.Four, 'value', QmatNMR.ExecutingMacro(QMacroCount, 6));
  	resetfourmode
  	setfourmode
  	regelshearingTD
        end	
        
      case 117		%linear prediction 2D
        %
        %first reconstruct the peak list from the indices stored in the macro
        %
        QmatNMR.LPPeakList = [];
        for QTEMP1 = 1:length(QmatNMR.LPPeakListIndices)/2
          QmatNMR.LPPeakList = [QmatNMR.LPPeakList QmatNMR.LPPeakListIndices((QTEMP1-1)*2+1):QmatNMR.LPPeakListIndices(QTEMP1*2)];
        end
        QmatNMR.LPPeakList = unique(QmatNMR.LPPeakList);
  
        %
        %do the linear prediction
        %
        QmatNMR.LPtype = QmatNMR.ExecutingMacro(QMacroCount, 2);		%what type of prediction
        QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 3));
        QmatNMR.uiInput2 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 4));
        QmatNMR.uiInput3 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 5));
        QmatNMR.uiInput4 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 6));
        QmatNMR.Dim = QmatNMR.ExecutingMacro(QMacroCount, 7);
        set(QmatNMR.Four, 'value', QmatNMR.ExecutingMacro(QMacroCount, 8));
        resetfourmode
        setfourmode
        regellp2d
        
      case 118		%baseline correction 2D  
        QmatNMR.Dim = QmatNMR.ExecutingMacro(QMacroCount, 2);
        getcurrentspectrum
        Qspcrel
        basl2dmenu
        set(QmatNMR.Q2dbas3, 'value', QmatNMR.ExecutingMacro(QMacroCount, 3));			%function
        set(QmatNMR.Q2dbas5, 'string', num2str(QmatNMR.ExecutingMacro(QMacroCount, 4)));	%order
        if (QmatNMR.ExecutingMacro(QMacroCount, 5) == -99)
          set(QmatNMR.Q2dbas11,'String', '1');						%starting row/column
        else
          set(QmatNMR.Q2dbas11,'String', num2str(QmatNMR.ExecutingMacro(QMacroCount, 5)));	%starting row/column
        end
        if (QmatNMR.ExecutingMacro(QMacroCount, 6) == -99)
          if (QmatNMR.Dim == 1)
            set(QmatNMR.Q2dbas9, 'String', num2str(QmatNMR.SizeTD1));				%ending row/column
          else
            set(QmatNMR.Q2dbas9, 'String', num2str(QmatNMR.SizeTD2));				%ending row/column
          end
        else
          set(QmatNMR.Q2dbas9, 'String', num2str(QmatNMR.ExecutingMacro(QMacroCount, 6)));	%ending row/column
        end
        
        QmatNMR.NumPeaks = length(QmatNMR.BaslcorPeakList)/2 - 1;
        QmatNMR.baslcornoise = [];
        for QTEMP=1:QmatNMR.NumPeaks+1
          QmatNMR.baslcornoise = [QmatNMR.baslcornoise (QmatNMR.BaslcorPeakList((QTEMP-1)*2+1):QmatNMR.BaslcorPeakList(QTEMP*2))];
        end
        figure(QmatNMR.Basl2Dfig);
        doebasl2dcor	%perform fit
        QTEMP = 2;	%accept fit
        stopbasl2d	%finish off
        QmatNMR.BaslcorPeakList = [];	%this variable contains the peak list for the baseline correction in matNMR.
  				%It has to be cleared because else error can be created when more than one
  				%baseline corrections are done consecutively.
        
        
      case 119		%set integral 2D
        QmatNMR.buttonList = 1;
        if (QmatNMR.ExecutingMacro(QMacroCount, 6) == 0) 	%no increment specified in macro for TD2
          QmatNMR.uiInput1 = [num2str(QmatNMR.ExecutingMacro(QMacroCount, 2)) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 3))];
  
        else
          QmatNMR.uiInput1 = [num2str(QmatNMR.ExecutingMacro(QMacroCount, 2)) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 6)) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 3))];
        end
        if (QmatNMR.ExecutingMacro(QMacroCount, 7) == 0) 	%no increment specified in macro for TD1
          QmatNMR.uiInput2 = [num2str(QmatNMR.ExecutingMacro(QMacroCount, 4)) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 5))];
  
        else
          QmatNMR.uiInput2 = [num2str(QmatNMR.ExecutingMacro(QMacroCount, 4)) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 7)) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 5))];
        end
        QmatNMR.uiInput3 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 8));
        regelsetintegral2d
        
      case 120 		%Transpose 2D
        transponeer  
        
      case 121 		%2D DC offset correction
        QmatNMR.buttonList = 1;
        QmatNMR.Dim = QmatNMR.ExecutingMacro(QMacroCount, 2);
        QmatNMR.uiInput1 = [num2str(QmatNMR.ExecutingMacro(QMacroCount, 3)) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 4))];
        DCcorr2d
  
      case 122		%remove Bruker digital filter 2D
        QmatNMR.buttonList = 1;
        QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 2), 14);
        set(QmatNMR.Four, 'value', QmatNMR.ExecutingMacro(QMacroCount, 3));
        QmatNMR.Dim = QmatNMR.ExecutingMacro(QMacroCount, 4);
        resetfourmode
        regelBrukerdig
  
  
      case 123		%solvent suppression 2D
        %
        %first reconstruct the peak list from the indices stored in the macro
        %
        QmatNMR.SDPeakList = [];
        for QTEMP1 = 1:length(QmatNMR.SDPeakListIndices)/2
          QmatNMR.SDPeakList = [QmatNMR.SDPeakList QmatNMR.SDPeakListIndices((QTEMP1-1)*2+1):QmatNMR.SDPeakListIndices(QTEMP1*2)];
        end
        QmatNMR.SDPeakList = unique(QmatNMR.SDPeakList);
  
        QmatNMR.buttonList = 1;
        QmatNMR.uiInput1 = QmatNMR.ExecutingMacro(QMacroCount, 2);
        QmatNMR.uiInput2 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 3));
        QmatNMR.uiInput3 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 4));
        QmatNMR.Dim = QmatNMR.ExecutingMacro(QMacroCount, 5);
        set(QmatNMR.Four, 'value', QmatNMR.ExecutingMacro(QMacroCount, 6));
        resetfourmode
        regelsolventsuppression2d
  
  
      case 124		%concatenate 1D
        QmatNMR.buttonList = 1;
        QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 2));
        QmatNMR.uiInput2 = QmatNMR.ExecutingMacro(QMacroCount, 3);
        QmatNMR.Dim = QmatNMR.ExecutingMacro(QMacroCount, 3);
        regelconcatenate
  
  
      case 125		%define external reference 2D
        QmatNMR.buttonList = 1;
        QmatNMR.uiInput1 = ['[' num2str(QmatNMR.ExecutingMacro(QMacroCount, 2),10) ' ' num2str(QmatNMR.ExecutingMacro(QMacroCount, 3),10) ']'];
        QmatNMR.uiInput2 = ['[' num2str(QmatNMR.ExecutingMacro(QMacroCount, 4),10) ' ' num2str(QmatNMR.ExecutingMacro(QMacroCount, 5),10) ']'];
        QmatNMR.uiInput3 = ['[' num2str(QmatNMR.ExecutingMacro(QMacroCount, 6)) ' ' num2str(QmatNMR.ExecutingMacro(QMacroCount, 7)) ']'];
        QmatNMR.uiInput4 = '';
        regeldefinereference
      
      
      case 126		%LP 2D peak list
        QmatNMR.LPPeakListIndices = [QmatNMR.LPPeakListIndices QmatNMR.ExecutingMacro(QMacroCount, 1+find(QmatNMR.ExecutingMacro(QMacroCount, 2:QmatNMR.MacroLength)))];
      
      case 128		%Solvent-deconvolution 2D peak list
        QmatNMR.SDPeakListIndices = [QmatNMR.SDPeakListIndices QmatNMR.ExecutingMacro(QMacroCount, 1+find(QmatNMR.ExecutingMacro(QMacroCount, 2:QmatNMR.MacroLength)))];
        
      case 129		%noise filling 2D  
        QmatNMR.buttonList = 1;
        %
        %check which dimensions have changed size
        %
        if (QmatNMR.ExecutingMacro(QMacroCount, 2) == -99)
        	QmatNMR.uiInput1 = num2str(QmatNMR.SizeTD2);	%no change
        else
          QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 2));
        end
        if (QmatNMR.ExecutingMacro(QMacroCount, 3) == -99)
        	QmatNMR.uiInput2 = num2str(QmatNMR.SizeTD1);	%no change
        else
          QmatNMR.uiInput2 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 3));
        end
        %
        %define the range with noise
        %
        if (QmatNMR.ExecutingMacro(QMacroCount, 8) == 0) 	%no increment specified in macro for TD2
          QmatNMR.uiInput3 = [num2str(QmatNMR.ExecutingMacro(QMacroCount, 4)) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 5))];
  
        else
          QmatNMR.uiInput3 = [num2str(QmatNMR.ExecutingMacro(QMacroCount, 4)) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 8)) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 5))];
        end
        if (QmatNMR.ExecutingMacro(QMacroCount, 9) == 0) 	%no increment specified in macro for TD1
          QmatNMR.uiInput4 = [num2str(QmatNMR.ExecutingMacro(QMacroCount, 6)) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 7))];
  
        else
          QmatNMR.uiInput4 = [num2str(QmatNMR.ExecutingMacro(QMacroCount, 6)) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 9)) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 7))];
        end
        regelnoisefilling2d
        
      case 130		%regrid spectrum 2D
        QmatNMR.buttonList = 1;
        %
        %for a linear axis we define a string that codes for the axis vector
        %non-linear axes are stored entirely in the macro
        %
        if (QmatNMR.ExecutingMacro(QMacroCount, 4) == 0)
          QmatNMR.uiInput1 = [num2str(QmatNMR.ExecutingMacro(QMacroCount, 3) + QmatNMR.ExecutingMacro(QMacroCount, 2), 20) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 2), 20) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 3) + QmatNMR.ExecutingMacro(QMacroCount, 5)*QmatNMR.ExecutingMacro(QMacroCount, 2), 20)];
        end
        %
        %for a linear axis we define a string that codes for the axis vector
        %non-linear axes are stored entirely in the macro
        %
        if (QmatNMR.ExecutingMacro(QMacroCount, 8) == 0)
          QmatNMR.uiInput2 = [num2str(QmatNMR.ExecutingMacro(QMacroCount, 7) + QmatNMR.ExecutingMacro(QMacroCount, 6), 20) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 6), 20) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 7) + QmatNMR.ExecutingMacro(QMacroCount, 9)*QmatNMR.ExecutingMacro(QMacroCount, 6), 20)];
        end
        
        QmatNMR.uiInput3 = QmatNMR.ExecutingMacro(QMacroCount, 10);
        regelregrid2d
      
      case 131		%shift spectrum by phase modulating the FID
        QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 2));
        regelshiftspectrum2d
      
      case 132		%delete current row/column from the 2D matrix
        regeldelete
        
      case 133		%maximum entropy reconstruction 2D
        %
        %first reconstruct the peak list from the indices stored in the macro
        %
        QmatNMR.LPPeakList = [];
        for QTEMP1 = 1:length(QmatNMR.LPPeakListIndices)/2
          QmatNMR.LPPeakList = [QmatNMR.LPPeakList QmatNMR.LPPeakListIndices((QTEMP1-1)*2+1):QmatNMR.LPPeakListIndices(QTEMP1*2)];
        end
        QmatNMR.LPPeakList = unique(QmatNMR.LPPeakList);
  
        %
        %do the maximum entropy reconstruction
        %
        QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 2));
        QmatNMR.uiInput2 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 3));
        QmatNMR.uiInput3 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 4));
        QmatNMR.Dim = QmatNMR.ExecutingMacro(QMacroCount, 5);
        set(QmatNMR.Four, 'value', QmatNMR.ExecutingMacro(QMacroCount, 6));
        resetfourmode
        setfourmode
        regelmem2d
  
  
      case 134		%running average 2D
        %
        %first reconstruct the peak list from the indices stored in the macro
        %
        QmatNMR.SDPeakList = [];
        for QTEMP1 = 1:length(QmatNMR.SDPeakListIndices)/2
          QmatNMR.SDPeakList = [QmatNMR.SDPeakList QmatNMR.SDPeakListIndices((QTEMP1-1)*2+1):QmatNMR.SDPeakListIndices(QTEMP1*2)];
        end
        QmatNMR.SDPeakList = unique(QmatNMR.SDPeakList);
  
        QmatNMR.buttonList = 1;
        QmatNMR.uiInput1 = QmatNMR.ExecutingMacro(QMacroCount, 2);
        QmatNMR.uiInput2 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 3));
        QmatNMR.uiInput3 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 4));
        QmatNMR.Dim = QmatNMR.ExecutingMacro(QMacroCount, 5);
        set(QmatNMR.Four, 'value', QmatNMR.ExecutingMacro(QMacroCount, 6));
        resetfourmode
        regelrunningav2d
  
  
  
  
  %
  %2D to 1D functions
  %	
      case 201    	%diagonal
        getdiag
        
      case 202   		%anti-diagonal
        getantidiag  
      
      case 203 		%Sum TD1
        QmatNMR.buttonList = 1;
        QmatNMR.uiInput1 = [num2str(QmatNMR.ExecutingMacro(QMacroCount, 2)) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 3))];
        regelprojTD1
  
      case 204 		%Sum TD2
        QmatNMR.buttonList = 1;
        QmatNMR.uiInput1 = [num2str(QmatNMR.ExecutingMacro(QMacroCount, 2)) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 3))];
        regelprojTD2
  
      case 205 		%Skyline projection
        QmatNMR.buttonList = 1;
        QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 2));
        regelskyline
  
  
  
  
  %
  %3D functions
  %	
      case 301    	%set axis for 3rd dimension
        regelaxis3d
  
  
  
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
        QmatNMR.DimensionParams = QmatNMR.ExecutingMacro(QMacroCount, :); 	%contains all the information for the dimension
        							%that is specified by position 2
        SetDimensionSpecificParameters
  
  
  
      case 401
      %
      %Force update of current slice in 2D
      %
        getcurrentspectrum
        Qspcrel
        detaxisprops		%just to be sure that the axis vectors are judged correctly
  
  
  
  %
  %User-defined functions
  %	
      case 666
        %
        %the strrep is used to protect against corrected macros which contais zeros where they shouldn't
        %
        QmatNMR.TEMPUserCommandString = [QmatNMR.TEMPUserCommandString strrep(char(QmatNMR.ExecutingMacro(QMacroCount, 2:QmatNMR.MacroLength)), char(0), '')];
        
      case 667
        QmatNMR.buttonList = 1;
        QmatNMR.uiInput1 = QmatNMR.TEMPUserCommandString;
        QmatNMR.TEMPUserCommandString = '';
        regelusercommand;  
  
  
  
  %
  %Plotting functions
  %	
  
      case 700 		%Horizontal Stack
        QmatNMR.Dim   = QmatNMR.ExecutingMacro(QMacroCount, 2);
        QmatNMR.SF1D  = QmatNMR.ExecutingMacro(QMacroCount, 3); 
        QmatNMR.SW1D  = QmatNMR.ExecutingMacro(QMacroCount, 4); 
  
        QmatNMR.Size1D = length(QmatNMR.Axis1D);
        detaxisprops		%just to be sure that the axis vectors are judged correctly
        asaanpas			%rerender to be sure the plot limits are correct
  
        QmatNMR.xmin       = QmatNMR.ExecutingMacro(QMacroCount, 5); 
        QmatNMR.totaalX    = QmatNMR.ExecutingMacro(QMacroCount, 6); 
        QmatNMR.ymin       = QmatNMR.ExecutingMacro(QMacroCount, 7); 
        QmatNMR.totaalY    = QmatNMR.ExecutingMacro(QMacroCount, 8);
        axis([QmatNMR.xmin (QmatNMR.xmin+QmatNMR.totaalX) QmatNMR.ymin (QmatNMR.ymin+QmatNMR.totaalY)]);	%set the display width properly for stack1d.m
        stack1dhorizontal
  
      case 701 		%Vertical Stack
        QmatNMR.buttonList = 1;
        QmatNMR.Dim   = QmatNMR.ExecutingMacro(QMacroCount, 2);
        QmatNMR.uiInput1 = [num2str(QmatNMR.ExecutingMacro(QMacroCount, 3)) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 4)) ':' num2str(QmatNMR.ExecutingMacro(QMacroCount, 5))];
        QmatNMR.uiInput2 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 6));
        
        QmatNMR.Size1D = length(QmatNMR.Axis1D);
        getcurrentspectrum
        Qspcrel
        detaxisprops		%just to be sure that the axis vectors are judged correctly
        asaanpas			%rerender to be sure the plot limits are correct
  
        QmatNMR.xmin       = QmatNMR.ExecutingMacro(QMacroCount, 7); 
        QmatNMR.totaalX    = QmatNMR.ExecutingMacro(QMacroCount, 8); 
        QmatNMR.ymin       = QmatNMR.ExecutingMacro(QMacroCount, 9); 
        QmatNMR.totaalY    = QmatNMR.ExecutingMacro(QMacroCount,10);
        axis([QmatNMR.xmin (QmatNMR.xmin+QmatNMR.totaalX) QmatNMR.ymin (QmatNMR.ymin+QmatNMR.totaalY)]);	%set the display width properly for stack1d.m
  
        stack1dvertical
  
      case 702 		%1D bar plot
        QmatNMR.buttonList = 1;
        QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 2));
        QmatNMR.uiInput2 = QmatNMR.ExecutingMacro(QMacroCount, 3);
        
        regelmake1dbar
  
      case 703 		%errorbar plot
        QmatNMR.buttonList = 1;
        regelmake1derrorbar
  
      case 704 		%show sidebands
        QmatNMR.buttonList = 1;
        QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 2));
        QmatNMR.uiInput2 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 3));
        QTEMP92 = QmatNMR.ExecutingMacro(QMacroCount, 4);
        QTEMP91 = 0;
        
        regelshowsidebands
  
      case 710		%used for storing the list of selected axes (ONLY regular axes!!)
        QmatNMR.SelectedAxes = [QmatNMR.SelectedAxes QmatNMR.ExecutingMacro(QMacroCount, 1+find(QmatNMR.ExecutingMacro(QMacroCount, 2:QmatNMR.MacroLength)))];

      case 711		%used for storing strings in the macro (e.g. axis labels)
        QmatNMR.TEMPCommandString = [QmatNMR.TEMPCommandString char(QmatNMR.ExecutingMacro(QMacroCount, 2:QmatNMR.MacroLength))];
  
      case 712		%used for evaluating the temporary strings used in macros
        eval([deblank(strrep(QmatNMR.TEMPCommandString, 'QuiInput', 'QmatNMR.uiInput')) ';']);
        QmatNMR.TEMPCommandString = '';
  
  
      case 721		%Axis On/Off/Etc
        %
        %make sure that the subplot configuration in the current window is the same as that for which the macro was intended
        %
        QTEMP1 = get(gcf, 'userdata');
        if (QTEMP1.SubPlots ~= QmatNMR.ExecutingMacro(QMacroCount, 2))
          disp('RunMacro WARNING: plotting macro''s can only be run on windows with the same subplot configuration. Refusing current action ...');
  	Arrowhead
  	return
  
        else
          %
          %first set the selected flag on all regular axes, and deselected all other ones but only if at least
          %1 axis is selected right now
          %
          QmatNMR.AllAxes = findobj(findobj(gcf, 'type', 'axes'), 'selected', 'on');
          if (length(QmatNMR.AllAxes))
            set(QmatNMR.AllAxes, 'selected', 'off');
          end
          if ~isempty(QmatNMR.SelectedAxes)
            QmatNMR.SelectedAxes = QmatNMR.SelectedAxes(find(QmatNMR.SelectedAxes));
            for QTEMP40=1:length(QmatNMR.SelectedAxes)
              set(findobj(gcf, 'type', 'axes', 'userdata', QmatNMR.SelectedAxes(QTEMP40)), 'selected', 'on');
            end
          end
          
          %
          %Execute action
          %
          QmatNMR.uiInput1 = QmatNMR.ExecutingMacro(QMacroCount, 3);
          QmatNMR.uiInput2 = QmatNMR.ExecutingMacro(QMacroCount, 4);
          QmatNMR.buttonList = 1;
          regelaxis
    
          QmatNMR.SelectedAxes = [];
        end
  
      case 722		%Clear Axis
        %
        %make sure that the subplot configuration in the current window is the same as that for which the macro was intended
        %
        QTEMP1 = get(gcf, 'userdata');
        if (QTEMP1.SubPlots ~= QmatNMR.ExecutingMacro(QMacroCount, 2))
          disp('RunMacro WARNING: plotting macro''s can only be run on windows with the same subplot configuration. Refusing current action ...');
  	Arrowhead
  	return
  
        else
          %
          %first set the selected flag on all regular axes, and deselected all other ones but only if at least
          %1 axis is selected right now
          %
          QmatNMR.AllAxes = findobj(findobj(gcf, 'type', 'axes'), 'selected', 'on');
          if (length(QmatNMR.AllAxes))
            set(QmatNMR.AllAxes, 'selected', 'off');
          end
          if ~isempty(QmatNMR.SelectedAxes)
            QmatNMR.SelectedAxes = QmatNMR.SelectedAxes(find(QmatNMR.SelectedAxes));
            for QTEMP40=1:length(QmatNMR.SelectedAxes)
              set(findobj(gcf, 'type', 'axes', 'userdata', QmatNMR.SelectedAxes(QTEMP40)), 'selected', 'on');
            end
          end
          
          %
          %Execute action
          %
          QmatNMR.uiInput1 = QmatNMR.ExecutingMacro(QMacroCount, 3);
          QmatNMR.buttonList = 1;
          regelclearaxis
  
          QmatNMR.SelectedAxes = [];
        end
  
      case 723		%Axis Colors
        %
        %make sure that the subplot configuration in the current window is the same as that for which the macro was intended
        %
        QTEMP1 = get(gcf, 'userdata');
        if (QTEMP1.SubPlots ~= QmatNMR.ExecutingMacro(QMacroCount, 2))
          disp('RunMacro WARNING: plotting macro''s can only be run on windows with the same subplot configuration. Refusing current action ...');
  	Arrowhead
  	return
  
        else
          %
          %first set the selected flag on all regular axes, and deselected all other ones but only if at least
          %1 axis is selected right now
          %
          QmatNMR.AllAxes = findobj(findobj(gcf, 'type', 'axes'), 'selected', 'on');
          if (length(QmatNMR.AllAxes))
            set(QmatNMR.AllAxes, 'selected', 'off');
          end
          if ~isempty(QmatNMR.SelectedAxes)
            QmatNMR.SelectedAxes = QmatNMR.SelectedAxes(find(QmatNMR.SelectedAxes));
            for QTEMP40=1:length(QmatNMR.SelectedAxes)
              set(findobj(gcf, 'type', 'axes', 'userdata', QmatNMR.SelectedAxes(QTEMP40)), 'selected', 'on');
            end
          end
          
          %
          %Execute action
          %
          QmatNMR.uiInput1a = QmatNMR.ExecutingMacro(QMacroCount, 3);
          QmatNMR.uiInput2a = QmatNMR.ExecutingMacro(QMacroCount, 4);
          QmatNMR.uiInput3a = QmatNMR.ExecutingMacro(QMacroCount, 5);
          QmatNMR.uiInput4  = QmatNMR.ExecutingMacro(QMacroCount, 6);
          QmatNMR.buttonList = 1;
          regelaxiscolors
  
          QmatNMR.SelectedAxes = [];
        end
  
      case 724		%Axis Directions
        %
        %make sure that the subplot configuration in the current window is the same as that for which the macro was intended
        %
        QTEMP1 = get(gcf, 'userdata');
        if (QTEMP1.SubPlots ~= QmatNMR.ExecutingMacro(QMacroCount, 2))
          disp('RunMacro WARNING: plotting macro''s can only be run on windows with the same subplot configuration. Refusing current action ...');
  	Arrowhead
  	return
  
        else
          %
          %first set the selected flag on all regular axes, and deselected all other ones but only if at least
          %1 axis is selected right now
          %
          QmatNMR.AllAxes = findobj(findobj(gcf, 'type', 'axes'), 'selected', 'on');
          if (length(QmatNMR.AllAxes))
            set(QmatNMR.AllAxes, 'selected', 'off');
          end
          if ~isempty(QmatNMR.SelectedAxes)
            QmatNMR.SelectedAxes = QmatNMR.SelectedAxes(find(QmatNMR.SelectedAxes));
            for QTEMP40=1:length(QmatNMR.SelectedAxes)
              set(findobj(gcf, 'type', 'axes', 'userdata', QmatNMR.SelectedAxes(QTEMP40)), 'selected', 'on');
            end
          end
          
          %
          %Execute action
          %
          QmatNMR.uiInput1  = QmatNMR.ExecutingMacro(QMacroCount, 3);
          QmatNMR.uiInput1a = QmatNMR.ExecutingMacro(QMacroCount, 4);
          QmatNMR.uiInput2  = QmatNMR.ExecutingMacro(QMacroCount, 5);
          QmatNMR.uiInput2a = QmatNMR.ExecutingMacro(QMacroCount, 6);
          QmatNMR.uiInput3  = QmatNMR.ExecutingMacro(QMacroCount, 7);
          QmatNMR.uiInput3a = QmatNMR.ExecutingMacro(QMacroCount, 8);
          QmatNMR.uiInput4  = QmatNMR.ExecutingMacro(QMacroCount, 9);
          QmatNMR.buttonList = 1;
          regeldirs
    
          QmatNMR.SelectedAxes = [];
        end
  
      case 725		%Axis Labels
        %
        %make sure that the subplot configuration in the current window is the same as that for which the macro was intended
        %
        QTEMP1 = get(gcf, 'userdata');
        if (QTEMP1.SubPlots ~= QmatNMR.ExecutingMacro(QMacroCount, 2))
          disp('RunMacro WARNING: plotting macro''s can only be run on windows with the same subplot configuration. Refusing current action ...');
  	Arrowhead
  	return
  
        else
          %
          %first set the selected flag on all regular axes, and deselected all other ones but only if at least
          %1 axis is selected right now
          %
          QmatNMR.AllAxes = findobj(findobj(gcf, 'type', 'axes'), 'selected', 'on');
          if (length(QmatNMR.AllAxes))
            set(QmatNMR.AllAxes, 'selected', 'off');
          end
          if ~isempty(QmatNMR.SelectedAxes)
            QmatNMR.SelectedAxes = QmatNMR.SelectedAxes(find(QmatNMR.SelectedAxes));
            for QTEMP40=1:length(QmatNMR.SelectedAxes)
              set(findobj(gcf, 'type', 'axes', 'userdata', QmatNMR.SelectedAxes(QTEMP40)), 'selected', 'on');
            end
          end
          
          %
          %Execute action
          %
          QmatNMR.uiInput1a = QmatNMR.ExecutingMacro(QMacroCount, 3);
          QmatNMR.uiInput2a = QmatNMR.ExecutingMacro(QMacroCount, 4);
          QmatNMR.uiInput3a = QmatNMR.ExecutingMacro(QMacroCount, 5);
          QmatNMR.uiInput4  = QmatNMR.ExecutingMacro(QMacroCount, 6);
          QmatNMR.buttonList = 1;
          regelaxislabels
    
          QmatNMR.SelectedAxes = [];
        end
  
      case 726		%Axis Locations
        %
        %make sure that the subplot configuration in the current window is the same as that for which the macro was intended
        %
        QTEMP1 = get(gcf, 'userdata');
        if (QTEMP1.SubPlots ~= QmatNMR.ExecutingMacro(QMacroCount, 2))
          disp('RunMacro WARNING: plotting macro''s can only be run on windows with the same subplot configuration. Refusing current action ...');
  	Arrowhead
  	return
  
        else
          %
          %first set the selected flag on all regular axes, and deselected all other ones but only if at least
          %1 axis is selected right now
          %
          QmatNMR.AllAxes = findobj(findobj(gcf, 'type', 'axes'), 'selected', 'on');
          if (length(QmatNMR.AllAxes))
            set(QmatNMR.AllAxes, 'selected', 'off');
          end
          if ~isempty(QmatNMR.SelectedAxes)
            QmatNMR.SelectedAxes = QmatNMR.SelectedAxes(find(QmatNMR.SelectedAxes));
            for QTEMP40=1:length(QmatNMR.SelectedAxes)
              set(findobj(gcf, 'type', 'axes', 'userdata', QmatNMR.SelectedAxes(QTEMP40)), 'selected', 'on');
            end
          end
          
          %
          %Execute action
          %
          QmatNMR.uiInput1  = QmatNMR.ExecutingMacro(QMacroCount, 3);
          QmatNMR.uiInput1a = QmatNMR.ExecutingMacro(QMacroCount, 4);
          QmatNMR.uiInput2  = QmatNMR.ExecutingMacro(QMacroCount, 5);
          QmatNMR.uiInput2a = QmatNMR.ExecutingMacro(QMacroCount, 6);
          QmatNMR.uiInput3  = QmatNMR.ExecutingMacro(QMacroCount, 7);
          QmatNMR.buttonList = 1;
          regelaxislocation
    
          QmatNMR.SelectedAxes = [];
        end
  
      case 727		%Axis Position
        %
        %make sure that the subplot configuration in the current window is the same as that for which the macro was intended
        %
        QTEMP1 = get(gcf, 'userdata');
        if (QTEMP1.SubPlots ~= QmatNMR.ExecutingMacro(QMacroCount, 2))
          disp('RunMacro WARNING: plotting macro''s can only be run on windows with the same subplot configuration. Refusing current action ...');
  	Arrowhead
  	return
  
        else
          %
          %first set the selected flag on all regular axes, and deselected all other ones but only if at least
          %1 axis is selected right now
          %
          QmatNMR.AllAxes = findobj(findobj(gcf, 'type', 'axes'), 'selected', 'on');
          if (length(QmatNMR.AllAxes))
            set(QmatNMR.AllAxes, 'selected', 'off');
          end
          if ~isempty(QmatNMR.SelectedAxes)
            QmatNMR.SelectedAxes = QmatNMR.SelectedAxes(find(QmatNMR.SelectedAxes));
            for QTEMP40=1:length(QmatNMR.SelectedAxes)
              set(findobj(gcf, 'type', 'axes', 'userdata', QmatNMR.SelectedAxes(QTEMP40)), 'selected', 'on');
            end
          end
          
          %
          %Execute action
          %
          QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 3), 10);
          QmatNMR.uiInput2 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 4), 10);
          QmatNMR.uiInput3 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 5), 10);
          QmatNMR.uiInput4 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 6), 10);
          QmatNMR.buttonList = 1;
          regelaxisposition
    
          QmatNMR.SelectedAxes = [];
        end
  
      case 728		%Title
        %
        %make sure that the subplot configuration in the current window is the same as that for which the macro was intended
        %
        QTEMP1 = get(gcf, 'userdata');
        if (QTEMP1.SubPlots ~= QmatNMR.ExecutingMacro(QMacroCount, 2))
          disp('RunMacro WARNING: plotting macro''s can only be run on windows with the same subplot configuration. Refusing current action ...');
  	Arrowhead
  	return
  
        else
          %
          %first set the selected flag on all regular axes, and deselected all other ones but only if at least
          %1 axis is selected right now
          %
          QmatNMR.AllAxes = findobj(findobj(gcf, 'type', 'axes'), 'selected', 'on');
          if (length(QmatNMR.AllAxes))
            set(QmatNMR.AllAxes, 'selected', 'off');
          end
          if ~isempty(QmatNMR.SelectedAxes)
            QmatNMR.SelectedAxes = QmatNMR.SelectedAxes(find(QmatNMR.SelectedAxes));
            for QTEMP40=1:length(QmatNMR.SelectedAxes)
              set(findobj(gcf, 'type', 'axes', 'userdata', QmatNMR.SelectedAxes(QTEMP40)), 'selected', 'on');
            end
          end
          
          %
          %Execute action
          %
          QmatNMR.uiInput2 = QmatNMR.ExecutingMacro(QMacroCount, 3);
          QmatNMR.buttonList = 1;
          regeltitle
    
          QmatNMR.SelectedAxes = [];
        end
  
      case 729		%Box
        %
        %make sure that the subplot configuration in the current window is the same as that for which the macro was intended
        %
        QTEMP1 = get(gcf, 'userdata');
        if (QTEMP1.SubPlots ~= QmatNMR.ExecutingMacro(QMacroCount, 2))
          disp('RunMacro WARNING: plotting macro''s can only be run on windows with the same subplot configuration. Refusing current action ...');
  	Arrowhead
  	return
  
        else
          %
          %first set the selected flag on all regular axes, and deselected all other ones but only if at least
          %1 axis is selected right now
          %
          QmatNMR.AllAxes = findobj(findobj(gcf, 'type', 'axes'), 'selected', 'on');
          if (length(QmatNMR.AllAxes))
            set(QmatNMR.AllAxes, 'selected', 'off');
          end
          if ~isempty(QmatNMR.SelectedAxes)
            QmatNMR.SelectedAxes = QmatNMR.SelectedAxes(find(QmatNMR.SelectedAxes));
            for QTEMP40=1:length(QmatNMR.SelectedAxes)
              set(findobj(gcf, 'type', 'axes', 'userdata', QmatNMR.SelectedAxes(QTEMP40)), 'selected', 'on');
            end
          end
          
          %
          %Execute action
          %
          QmatNMR.uiInput1 = QmatNMR.ExecutingMacro(QMacroCount, 3);
          QmatNMR.uiInput2 = QmatNMR.ExecutingMacro(QMacroCount, 4);
          QmatNMR.buttonList = 1;
          regelbox
    
          QmatNMR.SelectedAxes = [];
        end
  
      case 730		%Font properties
        %
        %make sure that the subplot configuration in the current window is the same as that for which the macro was intended
        %
        QTEMP1 = get(gcf, 'userdata');
        if (QTEMP1.SubPlots ~= QmatNMR.ExecutingMacro(QMacroCount, 2))
          disp('RunMacro WARNING: plotting macro''s can only be run on windows with the same subplot configuration. Refusing current action ...');
  	Arrowhead
  	return
  
        else
          %
          %first set the selected flag on all regular axes, and deselected all other ones but only if at least
          %1 axis is selected right now
          %
          QmatNMR.AllAxes = findobj(findobj(gcf, 'type', 'axes'), 'selected', 'on');
          if (length(QmatNMR.AllAxes))
            set(QmatNMR.AllAxes, 'selected', 'off');
          end
          if ~isempty(QmatNMR.SelectedAxes)
            QmatNMR.SelectedAxes = QmatNMR.SelectedAxes(find(QmatNMR.SelectedAxes));
            for QTEMP40=1:length(QmatNMR.SelectedAxes)
              set(findobj(gcf, 'type', 'axes', 'userdata', QmatNMR.SelectedAxes(QTEMP40)), 'selected', 'on');
            end
          end
          
          %
          %Execute action
          %
          QmatNMR.uiInput1  = QmatNMR.ExecutingMacro(QMacroCount, 3);
          QmatNMR.uiInput1a = QmatNMR.ExecutingMacro(QMacroCount, 4);
          QmatNMR.uiInput2  = QmatNMR.ExecutingMacro(QMacroCount, 5);
          QmatNMR.uiInput2a = QmatNMR.ExecutingMacro(QMacroCount, 6);
          QmatNMR.uiInput3  = QmatNMR.ExecutingMacro(QMacroCount, 7);
          QmatNMR.uiInput3a = QmatNMR.ExecutingMacro(QMacroCount, 8);
          QmatNMR.uiInput4  = QmatNMR.ExecutingMacro(QMacroCount, 9);
          QmatNMR.uiInput4a = QmatNMR.ExecutingMacro(QMacroCount,10);
          QmatNMR.uiInput5  = QmatNMR.ExecutingMacro(QMacroCount,11);
          QmatNMR.uiInput6  = QmatNMR.ExecutingMacro(QMacroCount,12);
          QmatNMR.uiInput7  = QmatNMR.ExecutingMacro(QMacroCount,13);
          QmatNMR.uiInput8  = QmatNMR.ExecutingMacro(QMacroCount,14);
          QmatNMR.buttonList = 1;
          regelfont
    
          QmatNMR.SelectedAxes = [];
        end
  
      case 731		%Grid
        %
        %make sure that the subplot configuration in the current window is the same as that for which the macro was intended
        %
        QTEMP1 = get(gcf, 'userdata');
        if (QTEMP1.SubPlots ~= QmatNMR.ExecutingMacro(QMacroCount, 2))
          disp('RunMacro WARNING: plotting macro''s can only be run on windows with the same subplot configuration. Refusing current action ...');
  	Arrowhead
  	return
  
        else
          %
          %first set the selected flag on all regular axes, and deselected all other ones but only if at least
          %1 axis is selected right now
          %
          QmatNMR.AllAxes = findobj(findobj(gcf, 'type', 'axes'), 'selected', 'on');
          if (length(QmatNMR.AllAxes))
            set(QmatNMR.AllAxes, 'selected', 'off');
          end
          if ~isempty(QmatNMR.SelectedAxes)
            QmatNMR.SelectedAxes = QmatNMR.SelectedAxes(find(QmatNMR.SelectedAxes));
            for QTEMP40=1:length(QmatNMR.SelectedAxes)
              set(findobj(gcf, 'type', 'axes', 'userdata', QmatNMR.SelectedAxes(QTEMP40)), 'selected', 'on');
            end
          end
          
          %
          %Execute action
          %
          QmatNMR.uiInput1  = QmatNMR.ExecutingMacro(QMacroCount, 3);
          QmatNMR.uiInput1a = QmatNMR.ExecutingMacro(QMacroCount, 4);
          QmatNMR.uiInput2  = QmatNMR.ExecutingMacro(QMacroCount, 5);
          QmatNMR.uiInput2a = QmatNMR.ExecutingMacro(QMacroCount, 6);
          QmatNMR.uiInput3  = QmatNMR.ExecutingMacro(QMacroCount, 7);
          QmatNMR.uiInput3a = QmatNMR.ExecutingMacro(QMacroCount, 8);
          QmatNMR.uiInput4  = QmatNMR.ExecutingMacro(QMacroCount, 9);
          QmatNMR.buttonList = 1;
          regelgrid
    
          QmatNMR.SelectedAxes = [];
        end
  
      case 732		%Hold
        %
        %make sure that the subplot configuration in the current window is the same as that for which the macro was intended
        %
        QTEMP1 = get(gcf, 'userdata');
        if (QTEMP1.SubPlots ~= QmatNMR.ExecutingMacro(QMacroCount, 2))
          disp('RunMacro WARNING: plotting macro''s can only be run on windows with the same subplot configuration. Refusing current action ...');
  	Arrowhead
  	return
  
        else
          %
          %first set the selected flag on all regular axes, and deselected all other ones but only if at least
          %1 axis is selected right now
          %
          QmatNMR.AllAxes = findobj(findobj(gcf, 'type', 'axes'), 'selected', 'on');
          if (length(QmatNMR.AllAxes))
            set(QmatNMR.AllAxes, 'selected', 'off');
          end
          if ~isempty(QmatNMR.SelectedAxes)
            QmatNMR.SelectedAxes = QmatNMR.SelectedAxes(find(QmatNMR.SelectedAxes));
            for QTEMP40=1:length(QmatNMR.SelectedAxes)
              set(findobj(gcf, 'type', 'axes', 'userdata', QmatNMR.SelectedAxes(QTEMP40)), 'selected', 'on');
            end
          end
          
          %
          %Execute action
          %
          QmatNMR.uiInput1 = QmatNMR.ExecutingMacro(QMacroCount, 3);
          QmatNMR.uiInput2 = QmatNMR.ExecutingMacro(QMacroCount, 4);
          QmatNMR.buttonList = 1;
          regelhold
    
          QmatNMR.SelectedAxes = [];
        end
  
      case 733		%Line style
        %
        %make sure that the subplot configuration in the current window is the same as that for which the macro was intended
        %
        QTEMP1 = get(gcf, 'userdata');
        if (QTEMP1.SubPlots ~= QmatNMR.ExecutingMacro(QMacroCount, 2))
          disp('RunMacro WARNING: plotting macro''s can only be run on windows with the same subplot configuration. Refusing current action ...');
  	Arrowhead
  	return
  
        else
          %
          %first set the selected flag on all regular axes, and deselected all other ones but only if at least
          %1 axis is selected right now
          %
          QmatNMR.AllAxes = findobj(findobj(gcf, 'type', 'axes'), 'selected', 'on');
          if (length(QmatNMR.AllAxes))
            set(QmatNMR.AllAxes, 'selected', 'off');
          end
          if ~isempty(QmatNMR.SelectedAxes)
            QmatNMR.SelectedAxes = QmatNMR.SelectedAxes(find(QmatNMR.SelectedAxes));
            for QTEMP40=1:length(QmatNMR.SelectedAxes)
              set(findobj(gcf, 'type', 'axes', 'userdata', QmatNMR.SelectedAxes(QTEMP40)), 'selected', 'on');
            end
          end
          
          %
          %Execute action
          %
          Linestyle(QmatNMR.uiInput1);
    
          QmatNMR.SelectedAxes = [];
        end
  
      case 734		%Line width
        %
        %make sure that the subplot configuration in the current window is the same as that for which the macro was intended
        %
        QTEMP1 = get(gcf, 'userdata');
        if (QTEMP1.SubPlots ~= QmatNMR.ExecutingMacro(QMacroCount, 2))
          disp('RunMacro WARNING: plotting macro''s can only be run on windows with the same subplot configuration. Refusing current action ...');
  	Arrowhead
  	return
  
        else
          %
          %first set the selected flag on all regular axes, and deselected all other ones but only if at least
          %1 axis is selected right now
          %
          QmatNMR.AllAxes = findobj(findobj(gcf, 'type', 'axes'), 'selected', 'on');
          if (length(QmatNMR.AllAxes))
            set(QmatNMR.AllAxes, 'selected', 'off');
          end
          if ~isempty(QmatNMR.SelectedAxes)
            QmatNMR.SelectedAxes = QmatNMR.SelectedAxes(find(QmatNMR.SelectedAxes));
            for QTEMP40=1:length(QmatNMR.SelectedAxes)
              set(findobj(gcf, 'type', 'axes', 'userdata', QmatNMR.SelectedAxes(QTEMP40)), 'selected', 'on');
            end
          end
          
          %
          %Execute action
          %
          QmatNMR.uiInput1 = QmatNMR.ExecutingMacro(QMacroCount, 3);
          Linewidth(QmatNMR.uiInput1);
    
          QmatNMR.SelectedAxes = [];
        end
  
      case 735		%Marker style
        %
        %make sure that the subplot configuration in the current window is the same as that for which the macro was intended
        %
        QTEMP1 = get(gcf, 'userdata');
        if (QTEMP1.SubPlots ~= QmatNMR.ExecutingMacro(QMacroCount, 2))
          disp('RunMacro WARNING: plotting macro''s can only be run on windows with the same subplot configuration. Refusing current action ...');
  	Arrowhead
  	return
  
        else
          %
          %first set the selected flag on all regular axes, and deselected all other ones but only if at least
          %1 axis is selected right now
          %
          QmatNMR.AllAxes = findobj(findobj(gcf, 'type', 'axes'), 'selected', 'on');
          if (length(QmatNMR.AllAxes))
            set(QmatNMR.AllAxes, 'selected', 'off');
          end
          if ~isempty(QmatNMR.SelectedAxes)
            QmatNMR.SelectedAxes = QmatNMR.SelectedAxes(find(QmatNMR.SelectedAxes));
            for QTEMP40=1:length(QmatNMR.SelectedAxes)
              set(findobj(gcf, 'type', 'axes', 'userdata', QmatNMR.SelectedAxes(QTEMP40)), 'selected', 'on');
            end
          end
          
          %
          %Execute action
          %
          Marker(QmatNMR.uiInput1);
    
          QmatNMR.SelectedAxes = [];
        end
  
      case 736		%Marker size
        %
        %make sure that the subplot configuration in the current window is the same as that for which the macro was intended
        %
        QTEMP1 = get(gcf, 'userdata');
        if (QTEMP1.SubPlots ~= QmatNMR.ExecutingMacro(QMacroCount, 2))
          disp('RunMacro WARNING: plotting macro''s can only be run on windows with the same subplot configuration. Refusing current action ...');
  	Arrowhead
  	return
  
        else
          %
          %first set the selected flag on all regular axes, and deselected all other ones but only if at least
          %1 axis is selected right now
          %
          QmatNMR.AllAxes = findobj(findobj(gcf, 'type', 'axes'), 'selected', 'on');
          if (length(QmatNMR.AllAxes))
            set(QmatNMR.AllAxes, 'selected', 'off');
          end
          if ~isempty(QmatNMR.SelectedAxes)
            QmatNMR.SelectedAxes = QmatNMR.SelectedAxes(find(QmatNMR.SelectedAxes));
            for QTEMP40=1:length(QmatNMR.SelectedAxes)
              set(findobj(gcf, 'type', 'axes', 'userdata', QmatNMR.SelectedAxes(QTEMP40)), 'selected', 'on');
            end
          end
          
          %
          %Execute action
          %
          QmatNMR.uiInput1 = QmatNMR.ExecutingMacro(QMacroCount, 3);
          Markersize(QmatNMR.uiInput1);
    
          QmatNMR.SelectedAxes = [];
        end
  
      case 737		%Scaling limits
        %
        %make sure that the subplot configuration in the current window is the same as that for which the macro was intended
        %
        QTEMP1 = get(gcf, 'userdata');
        if (QTEMP1.SubPlots ~= QmatNMR.ExecutingMacro(QMacroCount, 2))
          disp('RunMacro WARNING: plotting macro''s can only be run on windows with the same subplot configuration. Refusing current action ...');
  	Arrowhead
  	return
  
        else
          %
          %first set the selected flag on all regular axes, and deselected all other ones but only if at least
          %1 axis is selected right now
          %
          QmatNMR.AllAxes = findobj(findobj(gcf, 'type', 'axes'), 'selected', 'on');
          if (length(QmatNMR.AllAxes))
            set(QmatNMR.AllAxes, 'selected', 'off');
          end
          if ~isempty(QmatNMR.SelectedAxes)
            QmatNMR.SelectedAxes = QmatNMR.SelectedAxes(find(QmatNMR.SelectedAxes));
            for QTEMP40=1:length(QmatNMR.SelectedAxes)
              set(findobj(gcf, 'type', 'axes', 'userdata', QmatNMR.SelectedAxes(QTEMP40)), 'selected', 'on');
            end
          end
          
          %
          %Execute action
          %
          QmatNMR.uiInput1a = QmatNMR.ExecutingMacro(QMacroCount, 3);
          QmatNMR.uiInput2a = QmatNMR.ExecutingMacro(QMacroCount, 4);
          QmatNMR.uiInput3a = QmatNMR.ExecutingMacro(QMacroCount, 5);
          QmatNMR.uiInput4  = QmatNMR.ExecutingMacro(QMacroCount, 6);
          QmatNMR.buttonList = 1;
          regellims
    
          QmatNMR.SelectedAxes = [];
        end
  
      case 738		%Scaling types
        %
        %make sure that the subplot configuration in the current window is the same as that for which the macro was intended
        %
        QTEMP1 = get(gcf, 'userdata');
        if (QTEMP1.SubPlots ~= QmatNMR.ExecutingMacro(QMacroCount, 2))
          disp('RunMacro WARNING: plotting macro''s can only be run on windows with the same subplot configuration. Refusing current action ...');
  	Arrowhead
  	return
  
        else
          %
          %first set the selected flag on all regular axes, and deselected all other ones but only if at least
          %1 axis is selected right now
          %
          QmatNMR.AllAxes = findobj(findobj(gcf, 'type', 'axes'), 'selected', 'on');
          if (length(QmatNMR.AllAxes))
            set(QmatNMR.AllAxes, 'selected', 'off');
          end
          if ~isempty(QmatNMR.SelectedAxes)
            QmatNMR.SelectedAxes = QmatNMR.SelectedAxes(find(QmatNMR.SelectedAxes));
            for QTEMP40=1:length(QmatNMR.SelectedAxes)
              set(findobj(gcf, 'type', 'axes', 'userdata', QmatNMR.SelectedAxes(QTEMP40)), 'selected', 'on');
            end
          end
          
          %
          %Execute action
          %
          QmatNMR.uiInput1  = QmatNMR.ExecutingMacro(QMacroCount, 3);
          QmatNMR.uiInput1a = QmatNMR.ExecutingMacro(QMacroCount, 4);
          QmatNMR.uiInput2  = QmatNMR.ExecutingMacro(QMacroCount, 5);
          QmatNMR.uiInput2a = QmatNMR.ExecutingMacro(QMacroCount, 6);
          QmatNMR.uiInput3  = QmatNMR.ExecutingMacro(QMacroCount, 7);
          QmatNMR.uiInput3a = QmatNMR.ExecutingMacro(QMacroCount, 8);
          QmatNMR.uiInput4  = QmatNMR.ExecutingMacro(QMacroCount, 9);
          QmatNMR.buttonList = 1;
          regelscales
    
         QmatNMR.SelectedAxes = [];
        end
  
      case 739		%Shading
        %
        %make sure that the subplot configuration in the current window is the same as that for which the macro was intended
        %
        QTEMP1 = get(gcf, 'userdata');
        if (QTEMP1.SubPlots ~= QmatNMR.ExecutingMacro(QMacroCount, 2))
          disp('RunMacro WARNING: plotting macro''s can only be run on windows with the same subplot configuration. Refusing current action ...');
  	Arrowhead
  	return
  
        else
          %
          %first set the selected flag on all regular axes, and deselected all other ones but only if at least
          %1 axis is selected right now
          %
          QmatNMR.AllAxes = findobj(findobj(gcf, 'type', 'axes'), 'selected', 'on');
          if (length(QmatNMR.AllAxes))
            set(QmatNMR.AllAxes, 'selected', 'off');
          end
          if ~isempty(QmatNMR.SelectedAxes)
            QmatNMR.SelectedAxes = QmatNMR.SelectedAxes(find(QmatNMR.SelectedAxes));
            for QTEMP40=1:length(QmatNMR.SelectedAxes)
              set(findobj(gcf, 'type', 'axes', 'userdata', QmatNMR.SelectedAxes(QTEMP40)), 'selected', 'on');
            end
          end
          
          %
          %Execute action
          %
          QmatNMR.uiInput1 = QmatNMR.ExecutingMacro(QMacroCount, 3);
          QmatNMR.uiInput2 = QmatNMR.ExecutingMacro(QMacroCount, 4);
          QmatNMR.buttonList = 1;
          regelshading
    
          QmatNMR.SelectedAxes = [];
        end
  
      case 740		%Tick directions
        %
        %make sure that the subplot configuration in the current window is the same as that for which the macro was intended
        %
        QTEMP1 = get(gcf, 'userdata');
        if (QTEMP1.SubPlots ~= QmatNMR.ExecutingMacro(QMacroCount, 2))
          disp('RunMacro WARNING: plotting macro''s can only be run on windows with the same subplot configuration. Refusing current action ...');
  	Arrowhead
  	return
  
        else
          %
          %first set the selected flag on all regular axes, and deselected all other ones but only if at least
          %1 axis is selected right now
          %
          QmatNMR.AllAxes = findobj(findobj(gcf, 'type', 'axes'), 'selected', 'on');
          if (length(QmatNMR.AllAxes))
            set(QmatNMR.AllAxes, 'selected', 'off');
          end
          if ~isempty(QmatNMR.SelectedAxes)
            QmatNMR.SelectedAxes = QmatNMR.SelectedAxes(find(QmatNMR.SelectedAxes));
            for QTEMP40=1:length(QmatNMR.SelectedAxes)
              set(findobj(gcf, 'type', 'axes', 'userdata', QmatNMR.SelectedAxes(QTEMP40)), 'selected', 'on');
            end
          end
          
          %
          %Execute action
          %
          QmatNMR.uiInput1 = QmatNMR.ExecutingMacro(QMacroCount, 3);
          QmatNMR.uiInput2 = QmatNMR.ExecutingMacro(QMacroCount, 4);
          QmatNMR.buttonList = 1;
          regeltickdir
    
          QmatNMR.SelectedAxes = [];
        end
  
      case 741		%Tick labels
        %
        %make sure that the subplot configuration in the current window is the same as that for which the macro was intended
        %
        QTEMP1 = get(gcf, 'userdata');
        if (QTEMP1.SubPlots ~= QmatNMR.ExecutingMacro(QMacroCount, 2))
          disp('RunMacro WARNING: plotting macro''s can only be run on windows with the same subplot configuration. Refusing current action ...');
  	Arrowhead
  	return
  
        else
          %
          %first set the selected flag on all regular axes, and deselected all other ones but only if at least
          %1 axis is selected right now
          %
          QmatNMR.AllAxes = findobj(findobj(gcf, 'type', 'axes'), 'selected', 'on');
          if (length(QmatNMR.AllAxes))
            set(QmatNMR.AllAxes, 'selected', 'off');
          end
          if ~isempty(QmatNMR.SelectedAxes)
            QmatNMR.SelectedAxes = QmatNMR.SelectedAxes(find(QmatNMR.SelectedAxes));
            for QTEMP40=1:length(QmatNMR.SelectedAxes)
              set(findobj(gcf, 'type', 'axes', 'userdata', QmatNMR.SelectedAxes(QTEMP40)), 'selected', 'on');
            end
          end
          
          %
          %Execute action
          %
          QmatNMR.uiInput1a = QmatNMR.ExecutingMacro(QMacroCount, 3);
          QmatNMR.uiInput2a = QmatNMR.ExecutingMacro(QMacroCount, 4);
          QmatNMR.uiInput3a = QmatNMR.ExecutingMacro(QMacroCount, 5);
          QmatNMR.uiInput4  = QmatNMR.ExecutingMacro(QMacroCount, 6);
          QmatNMR.buttonList = 1;
          regelticklabel
    
          QmatNMR.SelectedAxes = [];
        end
  
      case 742		%Tick lengths
        %
        %make sure that the subplot configuration in the current window is the same as that for which the macro was intended
        %
        QTEMP1 = get(gcf, 'userdata');
        if (QTEMP1.SubPlots ~= QmatNMR.ExecutingMacro(QMacroCount, 2))
          disp('RunMacro WARNING: plotting macro''s can only be run on windows with the same subplot configuration. Refusing current action ...');
  	Arrowhead
  	return
  
        else
          %
          %first set the selected flag on all regular axes, and deselected all other ones but only if at least
          %1 axis is selected right now
          %
          QmatNMR.AllAxes = findobj(findobj(gcf, 'type', 'axes'), 'selected', 'on');
          if (length(QmatNMR.AllAxes))
            set(QmatNMR.AllAxes, 'selected', 'off');
          end
          if ~isempty(QmatNMR.SelectedAxes)
            QmatNMR.SelectedAxes = QmatNMR.SelectedAxes(find(QmatNMR.SelectedAxes));
            for QTEMP40=1:length(QmatNMR.SelectedAxes)
              set(findobj(gcf, 'type', 'axes', 'userdata', QmatNMR.SelectedAxes(QTEMP40)), 'selected', 'on');
            end
          end
          
          %
          %Execute action
          %
          QmatNMR.uiInput1a = QmatNMR.ExecutingMacro(QMacroCount, 3);
          QmatNMR.uiInput2a = QmatNMR.ExecutingMacro(QMacroCount, 4);
          QmatNMR.uiInput3  = QmatNMR.ExecutingMacro(QMacroCount, 5);
          QmatNMR.buttonList = 1;
          regelticklengths
    
          QmatNMR.SelectedAxes = [];
        end
  
      case 743		%Tick positions
        %
        %make sure that the subplot configuration in the current window is the same as that for which the macro was intended
        %
        QTEMP1 = get(gcf, 'userdata');
        if (QTEMP1.SubPlots ~= QmatNMR.ExecutingMacro(QMacroCount, 2))
          disp('RunMacro WARNING: plotting macro''s can only be run on windows with the same subplot configuration. Refusing current action ...');
  	Arrowhead
  	return
  
        else
          %
          %first set the selected flag on all regular axes, and deselected all other ones but only if at least
          %1 axis is selected right now
          %
          QmatNMR.AllAxes = findobj(findobj(gcf, 'type', 'axes'), 'selected', 'on');
          if (length(QmatNMR.AllAxes))
            set(QmatNMR.AllAxes, 'selected', 'off');
          end
          if ~isempty(QmatNMR.SelectedAxes)
            QmatNMR.SelectedAxes = QmatNMR.SelectedAxes(find(QmatNMR.SelectedAxes));
            for QTEMP40=1:length(QmatNMR.SelectedAxes)
              set(findobj(gcf, 'type', 'axes', 'userdata', QmatNMR.SelectedAxes(QTEMP40)), 'selected', 'on');
            end
          end
          
          %
          %Execute action
          %
          QmatNMR.uiInput1a = QmatNMR.ExecutingMacro(QMacroCount, 3);
          QmatNMR.uiInput2a = QmatNMR.ExecutingMacro(QMacroCount, 4);
          QmatNMR.uiInput3a = QmatNMR.ExecutingMacro(QMacroCount, 5);
          QmatNMR.uiInput4  = QmatNMR.ExecutingMacro(QMacroCount, 6);
          QmatNMR.buttonList = 1;
          regeltick
    
          QmatNMR.SelectedAxes = [];
        end
  
      case 744		%Axis View
        %
        %make sure that the subplot configuration in the current window is the same as that for which the macro was intended
        %
        QTEMP1 = get(gcf, 'userdata');
        if (QTEMP1.SubPlots ~= QmatNMR.ExecutingMacro(QMacroCount, 2))
          disp('RunMacro WARNING: plotting macro''s can only be run on windows with the same subplot configuration. Refusing current action ...');
  	Arrowhead
  	return
  
        else
          %
          %first set the selected flag on all regular axes, and deselected all other ones but only if at least
          %1 axis is selected right now
          %
          QmatNMR.AllAxes = findobj(findobj(gcf, 'type', 'axes'), 'selected', 'on');
          if (length(QmatNMR.AllAxes))
            set(QmatNMR.AllAxes, 'selected', 'off');
          end
          if ~isempty(QmatNMR.SelectedAxes)
            QmatNMR.SelectedAxes = QmatNMR.SelectedAxes(find(QmatNMR.SelectedAxes));
            for QTEMP40=1:length(QmatNMR.SelectedAxes)
              set(findobj(gcf, 'type', 'axes', 'userdata', QmatNMR.SelectedAxes(QTEMP40)), 'selected', 'on');
            end
          end
          
          %
          %Execute action
          %
          QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 3));
          QmatNMR.uiInput2 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 4));
          QmatNMR.uiInput3 = QmatNMR.ExecutingMacro(QMacroCount, 5);
          QmatNMR.buttonList = 1;
          regelaxisview
  
          QmatNMR.SelectedAxes = [];
        end
  
      case 745		%Super Title
          %
          %Execute action
          %
          QmatNMR.uiInput2 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 2));
          QmatNMR.uiInput3 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 3));
          QmatNMR.buttonList = 1;
          regelsupertitle
  
      case 746		%Light
          %
          %Execute action
          %
          QmatNMR.uiInput1 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 1));
          QmatNMR.uiInput2 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 2));
          QmatNMR.uiInput4 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 4));
          QmatNMR.uiInput5 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 5));
          QmatNMR.uiInput6 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 6));
          QmatNMR.uiInput7 = num2str(QmatNMR.ExecutingMacro(QMacroCount, 7));
          QmatNMR.buttonList = 1;
          regellight
  
      case 750		%Colour axis
        %
        %make sure that the subplot configuration in the current window is the same as that for which the macro was intended
        %
        QTEMP1 = get(gcf, 'userdata');
        if (QTEMP1.SubPlots ~= QmatNMR.ExecutingMacro(QMacroCount, 2))
          disp('RunMacro WARNING: plotting macro''s can only be run on windows with the same subplot configuration. Refusing current action ...');
  	Arrowhead
  	return
  
        %
        %make sure that the current window is a 2D/3D viewer window!
        %
        elseif ~strcmp(get(gcf, 'tag'), '2D/3D Viewer')
          disp('RunMacro WARNING: changing the colour axis requires the current window to be a 2D/3D Viewer window. Refusing current action ...');
  
        else
          %
          %first set the selected flag on all regular axes, and deselected all other ones but only if at least
          %1 axis is selected right now
          %
          QmatNMR.AllAxes = findobj(findobj(gcf, 'type', 'axes'), 'selected', 'on');
          if (length(QmatNMR.AllAxes))
            set(QmatNMR.AllAxes, 'selected', 'off');
          end
          if ~isempty(QmatNMR.SelectedAxes)
            QmatNMR.SelectedAxes = QmatNMR.SelectedAxes(find(QmatNMR.SelectedAxes));
            for QTEMP40=1:length(QmatNMR.SelectedAxes)
              set(findobj(gcf, 'type', 'axes', 'userdata', QmatNMR.SelectedAxes(QTEMP40)), 'selected', 'on');
            end
          end
          	
          %
          %Execute action
          %
          QmatNMR.uiInput1a = QmatNMR.ExecutingMacro(QMacroCount, 3);
          QmatNMR.uiInput2a = QmatNMR.ExecutingMacro(QMacroCount, 4);
          QmatNMR.uiInput3  = QmatNMR.ExecutingMacro(QMacroCount, 5);
          QmatNMR.buttonList = 1;
          regelcaxis
    
          QmatNMR.SelectedAxes = [];
        end
  
      case 751		%Colour bars
        %
        %make sure that the subplot configuration in the current window is the same as that for which the macro was intended
        %
        QTEMP1 = get(gcf, 'userdata');
        if (QTEMP1.SubPlots ~= QmatNMR.ExecutingMacro(QMacroCount, 2))
          disp('RunMacro WARNING: plotting macro''s can only be run on windows with the same subplot configuration. Refusing current action ...');
  	Arrowhead
  	return
  
        %
        %make sure that the current window is a 2D/3D viewer window!
        %
        elseif ~strcmp(get(gcf, 'tag'), '2D/3D Viewer')
          disp('RunMacro WARNING: changing the colour axis requires the current window to be a 2D/3D Viewer window. Refusing current action ...');
  
        else
          %
          %first set the selected flag on all regular axes, and deselected all other ones but only if at least
          %1 axis is selected right now
          %
          QmatNMR.AllAxes = findobj(findobj(gcf, 'type', 'axes'), 'selected', 'on');
          if (length(QmatNMR.AllAxes))
            set(QmatNMR.AllAxes, 'selected', 'off');
          end
          if ~isempty(QmatNMR.SelectedAxes)
            QmatNMR.SelectedAxes = QmatNMR.SelectedAxes(find(QmatNMR.SelectedAxes));
            for QTEMP40=1:length(QmatNMR.SelectedAxes)
              set(findobj(gcf, 'type', 'axes', 'userdata', QmatNMR.SelectedAxes(QTEMP40)), 'selected', 'on');
            end
          end
          
          %
          %Execute action
          %
          QmatNMR.uiInput1 = QmatNMR.ExecutingMacro(QMacroCount, 3);
          QmatNMR.uiInput2 = QmatNMR.ExecutingMacro(QMacroCount, 4);
          QmatNMR.uiInput3 = QmatNMR.ExecutingMacro(QMacroCount, 5);
          QmatNMR.buttonList = 1;
          contcbar
    
          QmatNMR.SelectedAxes = [];
        end
  
      case 752		%Colour map
        %
        %make sure that the current window is a 2D/3D viewer window!
        %
        if ~strcmp(get(gcf, 'tag'), '2D/3D Viewer')
          disp('RunMacro WARNING: changing the colour map requires the current window to be a 2D/3D Viewer window. Refusing current action ...');
  	return
  
        else
          %
          %Execute action
          %
          set(QmatNMR.c8, 'Value', QmatNMR.ExecutingMacro(QMacroCount, 2));
          contcmap
        end
  
  
      otherwise
        error('matNMR ERROR:  Unknown code encountered while processing macro!');
    end    
  end
  
  
  %
  %Macro is finished, now update the screen ... unless we're processing a 3D spectrum OR
  % ANY plotting action:
  %-horizontal stack plot
  %-vertical stack plot
  %-any other plotting action
  %
    QmatNMR.BusyWithMacro = 0;
    if  (~QmatNMR.BusyWithMacro3D & ~QmatNMR.matNMRRunMacroFlag & (QmatNMR.ExecutingMacro(QMacroCount, 1) < 700))
      if (QmatNMR.Dim > 0)		%in case of a 2D get current row or column
        getcurrentspectrum
  
        %update the axis for the current plot according to the current slice/column of the 2D
        if (QmatNMR.Dim == 1)
          QmatNMR.Axis1D = QmatNMR.AxisTD2;
          
        elseif (QmatNMR.Dim == 2)
          QmatNMR.Axis1D = QmatNMR.AxisTD1;
        end
      end
      
      Qspcrel
      setfourmode
  
      asaanpas
    end
    Arrowhead
  
  
  clear QTEMP* QMacroCount

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
