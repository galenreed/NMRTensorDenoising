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
%matNMR1DButtons.m defines all uicontroles for the main window (1D)
%09-08-'96
%03-01-'00

try
  %=====================================================================================================
  %
  % First the uimenus that go into the menubar at the top of the window
  %
  %=====================================================================================================
  
  QmatNMR.stopper= uimenu(QmatNMR.Fig, 'Label', 'Stop matNMR', 'Position', [1]);
  	uimenu(QmatNMR.stopper, 'Label', 'Close Window', 'callback', 'askstopnmr', 'accelerator', 'w');
  	uimenu(QmatNMR.stopper, 'Label', 'Stop matNMR', 'callback', 'askstopmatnmr');
  	uimenu(QmatNMR.stopper, 'Label', 'Quit MATLAB', 'callback', 'asktoquit');
  
  QmatNMR.files 	= uimenu(QmatNMR.Fig, 'Label', 'Files', 'Position', [2]);
  	uimenu(QmatNMR.files, 'Label', 'External MATLAB File', 'callback', 'matlaad', 'accelerator', 'm');
  	uimenu(QmatNMR.files, 'Label', 'Last External MATLAB Files', 'callback', 'askmatlaad');
  
  	QmatNMR.filesImport = uimenu(QmatNMR.files, 'Label', 'Import NMR', 'separator', 'on');
  		uimenu(QmatNMR.filesImport, 'Label', 'Binary FID', 'callback', 'fidlaad', 'accelerator', 'f', 'separator', 'on');
  		uimenu(QmatNMR.filesImport, 'Label', 'Last Binary FID', 'callback', 'askfidlaad', 'accelerator', 'r');
  
  		uimenu(QmatNMR.filesImport, 'Label', 'Bruker Spectrum', 'callback', 'Brukerlaad', 'separator', 'on');
  		uimenu(QmatNMR.filesImport, 'Label', 'Last Bruker Spectrum', 'callback', 'askBrukerlaad');
  
  		uimenu(QmatNMR.filesImport, 'Label', 'Chemagnetics Spectrum', 'callback', 'CMXlaad', 'separator', 'on');
  		uimenu(QmatNMR.filesImport, 'Label', 'Last Chemagnetics Spectrum', 'callback', 'askCMXlaad');
  
  		uimenu(QmatNMR.filesImport, 'Label', 'SIMPSON ASCII', 'callback', 'simpsonasciilaad', 'separator', 'on');
  		uimenu(QmatNMR.filesImport, 'Label', 'Last SIMPSON ASCII', 'callback', 'asksimpsonasciilaad');
  
  		uimenu(QmatNMR.filesImport, 'Label', 'Sparky UCSF (version 2)', 'callback', 'UCSFlaad', 'separator', 'on');
  		uimenu(QmatNMR.filesImport, 'Label', 'Last Sparky UCSF', 'callback', 'askUCSFlaad');
  
  %		uimenu(QmatNMR.filesImport, 'Label', 'NMRpipe', 'callback', 'nmrpipelaad', 'separator', 'on');
  %		uimenu(QmatNMR.filesImport, 'Label', 'Last NMRpipe', 'callback', 'asknmrpipelaad');
  
  	QmatNMR.filesExport = uimenu(QmatNMR.files, 'Label', 'Export NMR');
  		uimenu(QmatNMR.filesExport, 'Label', 'Save as Bruker spectrum', 'callback', 'asksavetoBrukerSpectrum');
  		uimenu(QmatNMR.filesExport, 'Label', 'Save as CSV ASCII (1D only)', 'callback', 'asksavetoCSVASCII');
  		uimenu(QmatNMR.filesExport, 'Label', 'Save as SIMPSON ASCII', 'callback', 'asksavetoSimpsonASCII');
  
  	QmatNMR.filesImport = uimenu(QmatNMR.files, 'Label', 'Import EPR', 'callback', 'askimportEPR');

  	QmatNMR.filesImport = uimenu(QmatNMR.files, 'Label', 'Import MRI');
  		uimenu(QmatNMR.filesImport, 'Label', 'MRI data', 'callback', 'importMRI');
  		uimenu(QmatNMR.filesImport, 'Label', 'Last MRI data', 'callback', 'askimportMRI');
  
  	QmatNMR.filesImport = uimenu(QmatNMR.files, 'Label', 'Import GENERIC');
  	        uimenu(QmatNMR.filesImport, 'Label', 'Import GENERIC', 'callback', 'importGENERIC');
  	        uimenu(QmatNMR.filesImport, 'Label', 'Import last GENERIC', 'callback', 'askimportGENERIC');

  	uimenu(QmatNMR.files, 'label', 'Save 1D to Disk', 'Callback', 'asksavedisk1d');
  	uimenu(QmatNMR.files, 'label', 'Save 2D to Disk', 'Callback', 'asksavedisk2d');
  
          QmatNMR.SeriesTrickery = uimenu(QmatNMR.files, 'Label', 'Series Trickery', 'separator', 'on');
  		uimenu(QmatNMR.SeriesTrickery, 'Label', 'Add series of variables', 'callback', 'askaddvariables');
  		uimenu(QmatNMR.SeriesTrickery, 'Label', 'Concatenate series of variables', 'callback', 'askconcatenatevariables');
  		uimenu(QmatNMR.SeriesTrickery, 'Label', 'Normalize series of variables', 'callback', 'asknormalizevariables');
  
  	uimenu(QmatNMR.files, 'Label', 'Change Directory', 'callback', 'ChangeDir', 'separator', 'on');
  	uimenu(QmatNMR.files, 'Label', 'Set Search Profile', 'callback', 'SearchProfile');
  	uimenu(QmatNMR.files, 'label', 'Edit MATLAB Path', 'callback', 'editpath', 'separator', 'on');
  	uimenu(QmatNMR.files, 'label', 'Edit Workspace', 'callback', 'workspace');
  	uimenu(QmatNMR.files, 'label', 'Editor/Debugger', 'callback', 'edit');
  	
  
  QmatNMR.b1	= uimenu(QmatNMR.Fig, 'Label', '1D Processing', 'position', [3]);
  	uimenu(QmatNMR.b1, 'label', 'Load 1D', 'Callback', 'QmatNMR.ask = 1; askname;', 'accelerator', '1');
  	uimenu(QmatNMR.b1, 'label', 'Add Spectrum to Workspace', 'Callback', 'QmatNMR.SwitchTo1D = 1; asksave1d');
  	uimenu(QmatNMR.b1, 'label', 'Save Spectrum to Disk', 'Callback', 'QmatNMR.SwitchTo1D = 1; asksavedisk1d');
  	uimenu(QmatNMR.b1, 'label', 'Dual Display', 'Callback', 'set(QmatNMR.e9, ''value'', 1); asknamedual');
  	uimenu(QmatNMR.b1, 'Label', 'Convert Bruker qseq', 'callback', 'QmatNMR.SwitchTo1D = 1; convertBrukerqseq1d', 'separator', 'on');
  
  	QmatNMR.b1Std = uimenu(QmatNMR.b1, 'label', 'Standard processing', 'separator', 'on');
  		uimenu(QmatNMR.b1Std, 'label', 'Remove Bruker digital filter', 'Callback', 'QmatNMR.SwitchTo1D = 1; askBrukerdig', 'separator', 'on');
  		uimenu(QmatNMR.b1Std, 'label', 'Shift Data Points', 'Callback', 'QmatNMR.SwitchTo1D = 1; askleftshift');
  		uimenu(QmatNMR.b1Std, 'Label', 'Swap Whole Echo', 'callback', 'QmatNMR.SwitchTo1D = 1; askswapecho');
  		uimenu(QmatNMR.b1Std, 'label', 'DC offset correction', 'callback', 'QmatNMR.SwitchTo1D = 1; askDCcorr1d');
  		uimenu(QmatNMR.b1Std, 'label', 'Solvent Deconvolution', 'callback', 'QmatNMR.SwitchTo1D = 1; asksolventsuppression1d');
  		QmatNMR.b1Apod = uimenu(QmatNMR.b1Std, 'label', 'Apodization');
  			uimenu(QmatNMR.b1Apod, 'label', 'None', 'callback', 'set(QmatNMR.h75, ''value'', 1); regellb');
  			uimenu(QmatNMR.b1Apod, 'label', 'Exponential', 'callback', 'set(QmatNMR.h75, ''value'', 2); regellb');
  			uimenu(QmatNMR.b1Apod, 'label', 'Cos^2', 'callback', 'set(QmatNMR.h75, ''value'', 3); regellb');
  			uimenu(QmatNMR.b1Apod, 'label', 'Gaussian', 'callback', 'set(QmatNMR.h75, ''value'', 4); regellb');
  			uimenu(QmatNMR.b1Apod, 'label', 'Hamming', 'callback', 'set(QmatNMR.h75, ''value'', 5); regellb');
  			uimenu(QmatNMR.b1Apod, 'label', 'Shifting Gauss', 'callback', 'set(QmatNMR.h75, ''value'', 6); regellb');
  			uimenu(QmatNMR.b1Apod, 'label', 'Exponential (echo)', 'callback', 'set(QmatNMR.h75, ''value'', 7); regellb');
  			uimenu(QmatNMR.b1Apod, 'label', 'Gaussian (echo)', 'callback', 'set(QmatNMR.h75, ''value'', 8); regellb');
  			uimenu(QmatNMR.b1Apod, 'label', 'Shifting Gauss (echo)', 'callback', 'set(QmatNMR.h75, ''value'', 9); regellb');
  		uimenu(QmatNMR.b1Std, 'label', 'Set Size', 'callback', 'QmatNMR.SwitchTo1D = 1; setsize1d');
  		uimenu(QmatNMR.b1Std, 'label', 'FT', 'callback', 'QmatNMR.SwitchTo1D = 1; QmatNMR.InverseFTflag = 0; four1d');
  		uimenu(QmatNMR.b1Std, 'label', 'FFTshift', 'callback', 'QmatNMR.SwitchTo1D = 1; shiftFFT1d');
  		uimenu(QmatNMR.b1Std, 'label', 'Flip L/R', 'callback', 'QmatNMR.SwitchTo1D = 1; flipspec');
  		uimenu(QmatNMR.b1Std, 'label', 'Baseline Correction', 'callback', 'QmatNMR.SwitchTo1D = 1; basl1dmenu');
  
  	QmatNMR.b1Add = uimenu(QmatNMR.b1, 'label', 'Additional features');
  		uimenu(QmatNMR.b1Add, 'Label', 'Cadzow filtering', 'callback', 'QmatNMR.SwitchTo1D = 1; askcadzow1d');
  		uimenu(QmatNMR.b1Add, 'Label', 'Cadzow  + LPSVD', 'callback', 'QmatNMR.SwitchTo1D = 1; askcadzowlpsvd1d');
  		uimenu(QmatNMR.b1Add, 'Label', 'Concatenate Matrix', 'callback', 'QmatNMR.SwitchTo1D = 1; askconcatenate');
      uimenu(QmatNMR.b1Add, 'label', 'Extract from 1D', 'callback', 'QmatNMR.SwitchTo1D = 1; askextract1d');
      uimenu(QmatNMR.b1Add, 'label', 'Get FWHH', 'callback', 'QmatNMR.SwitchTo1D = 1; regelgetFWHH1d');
  		uimenu(QmatNMR.b1Add, 'label', 'Integrate', 'callback', 'integrate1d');	
  		uimenu(QmatNMR.b1Add, 'label', 'Inverse FT', 'callback', 'QmatNMR.SwitchTo1D = 1; QmatNMR.InverseFTflag = 1; four1d');	
  		QmatNMR.b18= uimenu(QmatNMR.b1Add, 'label', 'Linear Prediction');
  			QmatNMR.b19 = uimenu(QmatNMR.b18, 'label', 'Backward');
  				uimenu(QmatNMR.b19, 'label', 'LPSVD', 'callback', 'QmatNMR.SwitchTo1D = 1; QmatNMR.LPtype = 1; asklp1d');
  				uimenu(QmatNMR.b19, 'label', 'ITMPM', 'callback', 'QmatNMR.SwitchTo1D = 1; QmatNMR.LPtype = 2; asklp1d');
  			QmatNMR.b20 = uimenu(QmatNMR.b18, 'label', 'Forward');
  				uimenu(QmatNMR.b20, 'label', 'LPSVD', 'callback', 'QmatNMR.SwitchTo1D = 1; QmatNMR.LPtype = 3; asklp1d');
  				uimenu(QmatNMR.b20, 'label', 'ITMPM', 'callback', 'QmatNMR.SwitchTo1D = 1; QmatNMR.LPtype = 4; asklp1d');
  		uimenu(QmatNMR.b1Add, 'label', 'MEM Reconstruction', 'callback', 'QmatNMR.SwitchTo1D = 1; askmem1d');
  		uimenu(QmatNMR.b1Add, 'label', 'Noise Filling', 'callback', 'QmatNMR.SwitchTo1D = 1; asknoisefilling1d');
  		uimenu(QmatNMR.b1Add, 'label', 'Regrid spectrum', 'callback', 'QmatNMR.SwitchTo1D = 1; askregrid1d');
  		uimenu(QmatNMR.b1Add, 'label', 'Running average', 'callback', 'QmatNMR.SwitchTo1D = 1; askrunningav1d');
  		uimenu(QmatNMR.b1Add, 'label', 'Set integral', 'callback', 'QmatNMR.SwitchTo1D = 1; asksetintegral1d');
  		uimenu(QmatNMR.b1Add, 'label', 'Shift spectrum (applied to FID)', 'callback', 'QmatNMR.SwitchTo1D = 1; askshiftspectrum1d');
  		uimenu(QmatNMR.b1Add, 'label', 'S / N', 'callback', 'detsovern');
  
  	QmatNMR.b21 = uimenu(QmatNMR.b1, 'label', 'Fitting');	
  		uimenu(QmatNMR.b21, 'label', 'CSA Tensors MAS', 'callback', 'ssafit1d');
  		uimenu(QmatNMR.b21, 'label', 'CSA Tensors Static', 'callback', 'csatensorfit1d');
    		uimenu(QmatNMR.b21, 'label', 'Diffusion Curves', 'callback', 'Difffit1d');
  		uimenu(QmatNMR.b21, 'label', 'Peak Deconvolution', 'callback', 'piekfit1d');
  		uimenu(QmatNMR.b21, 'label', 'Quadrupole Tensors MAS', 'callback', 'quadtensorfit1d');
  		uimenu(QmatNMR.b21, 'label', 'Relaxation curves', 'callback', 't1fit1d');
  
  QmatNMR.bl1	= uimenu(QmatNMR.Fig, 'Label', '2D Processing', 'position', [4]);
  	uimenu(QmatNMR.bl1, 'Label', 'Load 2D', 'callback', 'QmatNMR.ask = 2; askname;', 'accelerator', '2');
  	uimenu(QmatNMR.bl1, 'Label', 'Load 3D', 'callback', 'QmatNMR.ask = 3; askname;', 'accelerator', '3');
  	uimenu(QmatNMR.bl1, 'Label', 'Transpose', 'callback', 'transponeer;');
  	uimenu(QmatNMR.bl1, 'Label', 'Add spectrum to workspace', 'callback', 'asksave2d');
  	uimenu(QmatNMR.bl1, 'Label', 'Save spectrum to disk', 'callback', 'asksavedisk2d');
  	uimenu(QmatNMR.bl1, 'Label', 'Convert Bruker qseq', 'callback', 'QmatNMR.SwitchTo1D = 0; convertBrukerqseq2d', 'separator', 'on');
  	uimenu(QmatNMR.bl1, 'Label', 'Convert Bruker States and start', 'callback', 'QmatNMR.SwitchTo1D = 0; regelconvertBruker');
  	uimenu(QmatNMR.bl1, 'Label', 'Convert Varian States and start', 'callback', 'QmatNMR.SwitchTo1D = 0; regelconvertVarian');
  	uimenu(QmatNMR.bl1, 'Label', 'Echo-AntiEcho to States', 'callback', 'QmatNMR.SwitchTo1D = 0; regelconvertEAE');
  	uimenu(QmatNMR.bl1, 'Label', 'Start States processing', 'callback', 'QmatNMR.SwitchTo1D = 0; defstates');
  
  	QmatNMR.bl1Full = uimenu(QmatNMR.bl1, 'label', 'Full matrix Manipulations', 'separator', 'on');
  		uimenu(QmatNMR.bl1Full, 'label', 'Remove Bruker digital filter', 'Callback', 'QmatNMR.SwitchTo1D = 0; askBrukerdig', 'separator', 'on');
  		uimenu(QmatNMR.bl1Full, 'Label', 'Shift data points', 'callback', 'QmatNMR.SwitchTo1D = 0; askleftshift');
  		uimenu(QmatNMR.bl1Full, 'Label', 'Swap whole echo', 'callback', 'QmatNMR.SwitchTo1D = 0; askswapecho');
  		uimenu(QmatNMR.bl1Full, 'label', 'DC correction', 'callback', 'QmatNMR.SwitchTo1D = 0; askDCcorr2d');
  		uimenu(QmatNMR.bl1Full, 'label', 'Solvent Deconvolution', 'callback', 'QmatNMR.SwitchTo1D = 0; asksolventsuppression2d');
  		QmatNMR.bl1Apod = uimenu(QmatNMR.bl1Full, 'label', 'Choose Apodization');
  			uimenu(QmatNMR.bl1Apod, 'label', 'None', 'callback', 'set(QmatNMR.h75, ''value'', 1); regellb');
  			uimenu(QmatNMR.bl1Apod, 'label', 'Exponential', 'callback', 'set(QmatNMR.h75, ''value'', 2); regellb');
  			uimenu(QmatNMR.bl1Apod, 'label', 'Cos^2', 'callback', 'set(QmatNMR.h75, ''value'', 3); regellb');
  			uimenu(QmatNMR.bl1Apod, 'label', 'Gaussian', 'callback', 'set(QmatNMR.h75, ''value'', 4); regellb');
  			uimenu(QmatNMR.bl1Apod, 'label', 'Hamming', 'callback', 'set(QmatNMR.h75, ''value'', 5); regellb');
  			uimenu(QmatNMR.bl1Apod, 'label', 'Shifting Gauss', 'callback', 'set(QmatNMR.h75, ''value'', 6); regellb');
  			uimenu(QmatNMR.bl1Apod, 'label', 'Exponential (echo)', 'callback', 'set(QmatNMR.h75, ''value'', 7); regellb');
  			uimenu(QmatNMR.bl1Apod, 'label', 'Gaussian (echo)', 'callback', 'set(QmatNMR.h75, ''value'', 8); regellb');
  			uimenu(QmatNMR.bl1Apod, 'label', 'Shifting Gauss (echo)', 'callback', 'set(QmatNMR.h75, ''value'', 9); regellb');
  		uimenu(QmatNMR.bl1Full, 'label', 'Apodize 2D', 'callback', 'QmatNMR.SwitchTo1D = 0; apodize2d');
  		uimenu(QmatNMR.bl1Full, 'label', 'Set sizes', 'callback', 'QmatNMR.SwitchTo1D = 0; setsize');
  		uimenu(QmatNMR.bl1Full, 'label', 'Zero part of 2D', 'callback', 'QmatNMR.SwitchTo1D = 0; askzero2d');
  		uimenu(QmatNMR.bl1Full, 'label', 'FT', 'callback', 'QmatNMR.SwitchTo1D = 0; QmatNMR.InverseFTflag = 0; four2d');
  		uimenu(QmatNMR.bl1Full, 'label', 'FFTshift', 'callback', 'QmatNMR.SwitchTo1D = 0; shiftFFT2d');
  		uimenu(QmatNMR.bl1Full, 'label', 'Flip L/R', 'callback', 'QmatNMR.SwitchTo1D = 0; flipspec');
  		uimenu(QmatNMR.bl1Full, 'label', 'Set phase', 'callback', 'QmatNMR.SwitchTo1D = 0; setphase2d');
  		uimenu(QmatNMR.bl1Full, 'label', 'Baseline correction', 'callback', 'QmatNMR.SwitchTo1D = 0; basl2dmenu', 'separator', 'on');
  
  	QmatNMR.bl41 = uimenu(QmatNMR.bl1, 'label', 'Single Slice Manipulations');
  		uimenu(QmatNMR.bl41, 'label', 'Delete from matrix', 'callback', 'QmatNMR.SwitchTo1D = 0; QmatNMR.SingleSlice = 1; regeldelete');
  		uimenu(QmatNMR.bl41, 'label', 'Set Phase', 'callback', 'QmatNMR.SwitchTo1D = 0; QmatNMR.SingleSlice = 1; setphase2d');
  		uimenu(QmatNMR.bl41, 'label', 'Shift Data Points', 'callback', 'QmatNMR.SwitchTo1D = 0; QmatNMR.SingleSlice = 1; askleftshift');
  
  	QmatNMR.bl1Add = uimenu(QmatNMR.bl1, 'label', 'Additional features');
  		uimenu(QmatNMR.bl1Add, 'Label', 'Concatenate Matrix', 'callback', 'QmatNMR.SwitchTo1D = 0; askconcatenate');
  		uimenu(QmatNMR.bl1Add, 'label', 'Extract from 2D', 'callback', 'askextract2d');
  		uimenu(QmatNMR.bl1Add, 'label', 'Integrate Fixed Range', 'callback', 'QmatNMR.SwitchTo1D = 0; askintegrate2d');
  		uimenu(QmatNMR.bl1Add, 'label', 'Integrate around Max', 'callback', 'QmatNMR.SwitchTo1D = 0; askintegratewidth2d');
  		uimenu(QmatNMR.bl1Add, 'label', 'Inverse FT', 'callback', 'QmatNMR.SwitchTo1D = 0; QmatNMR.InverseFTflag = 1; four2d');
  		QmatNMR.bl31= uimenu(QmatNMR.bl1Add, 'label', 'Linear prediction');
  			QmatNMR.bl32 = uimenu(QmatNMR.bl31, 'label', 'Backward');
  				uimenu(QmatNMR.bl32, 'label', 'LPSVD', 'callback', 'QmatNMR.SwitchTo1D = 0; QmatNMR.LPtype = 1; asklp2d');
  				uimenu(QmatNMR.bl32, 'label', 'ITMPM', 'callback', 'QmatNMR.SwitchTo1D = 0; QmatNMR.LPtype = 2; asklp2d');
  			QmatNMR.bl35 = uimenu(QmatNMR.bl31, 'label', 'Forward');
  				uimenu(QmatNMR.bl35, 'label', 'LPSVD', 'callback', 'QmatNMR.SwitchTo1D = 0; QmatNMR.LPtype = 3; asklp2d');
  				uimenu(QmatNMR.bl35, 'label', 'ITMPM', 'callback', 'QmatNMR.SwitchTo1D = 0; QmatNMR.LPtype = 4; asklp2d');
  		uimenu(QmatNMR.bl1Add, 'label', 'MEM Reconstruction', 'callback', 'QmatNMR.SwitchTo1D = 0; askmem2d');
  		uimenu(QmatNMR.bl1Add, 'label', 'Noise Filling', 'callback', 'asknoisefilling2d');
  		uimenu(QmatNMR.bl1Add, 'label', 'Regrid spectrum', 'callback', 'askregrid2d');
  		uimenu(QmatNMR.bl1Add, 'label', 'Running average', 'callback', 'askrunningav2d');
  		uimenu(QmatNMR.bl1Add, 'label', 'Set integral', 'callback', 'asksetintegral2d');
  		QmatNMR.bl40 = uimenu(QmatNMR.bl1Add, 'label', 'Shearing transformation');
  			uimenu(QmatNMR.bl40, 'label', 'In time domain', 'callback', 'QmatNMR.SwitchTo1D = 0; askshearingTD');
  			uimenu(QmatNMR.bl40, 'label', 'In frequency domain', 'callback', 'QmatNMR.SwitchTo1D = 0; askshearingFD');
  		uimenu(QmatNMR.bl1Add, 'label', 'Shift spectrum (applied to FID)', 'callback', 'askshiftspectrum2d');
  		QmatNMR.bl27= uimenu(QmatNMR.bl1Add, 'label', 'Symmetrize');
  			uimenu(QmatNMR.bl27, 'label', 'Average Intensities', 'callback', 'QmatNMR.SwitchTo1D = 0; QmatNMR.SYMMtype = 1; symmetrize2d');
  			uimenu(QmatNMR.bl27, 'label', 'Highest Intensities', 'callback', 'QmatNMR.SwitchTo1D = 0; QmatNMR.SYMMtype = 2; symmetrize2d');
                  uimenu(QmatNMR.bl1Add, 'Label', 'Transpose', 'callback', 'transponeer;');
  
  	QmatNMR.b28 = uimenu(QmatNMR.bl1, 'label', 'Fitting');	
  		uimenu(QmatNMR.b28, 'label', 'Peak deconvolution', 'callback', 'piekfit2d');
  
  	QmatNMR.bl9 = uimenu(QmatNMR.bl1, 'label', 'Various views');
  		uimenu(QmatNMR.bl9, 'label', 'Diagonal', 'callback', 'getdiag');
  		uimenu(QmatNMR.bl9, 'label', 'Anti-diagonal', 'callback', 'getantidiag');
  		uimenu(QmatNMR.bl9, 'label', 'Sum projection TD1', 'callback', 'askprojTD1');
  		uimenu(QmatNMR.bl9, 'label', 'Sum Projection TD2', 'callback', 'askprojTD2');
  		uimenu(QmatNMR.bl9, 'label', 'Skyline projection', 'callback', 'askskyline');
  		uimenu(QmatNMR.bl9, 'label', 'Horizontal Stack plot', 'callback', 'stack1dhorizontal');
  		uimenu(QmatNMR.bl9, 'label', 'Vertical Stack plot', 'callback', 'askstack1dvertical');
  	uimenu(QmatNMR.bl1, 'label', '2D/3D Viewer', 'callback', 'QmatNMR.SpecName2D3D = ''QmatNMR.Spec2D''; QmatNMR.UserDefAxisT2Cont = ''QmatNMR.AxisTD2''; QmatNMR.UserDefAxisT1Cont = ''QmatNMR.AxisTD1''; nmr2d');
  
  
  QmatNMR.h666 = uimenu(QmatNMR.Fig, 'Label', 'Plot Manipulations', 'Position', [5]);
  	uimenu(QmatNMR.h666, 'label', 'Legend', 'callback', 'QezLegend', 'separator', 'on');
  	QmatNMR.h667 = uimenu(QmatNMR.h666, 'label', 'Ruler X-axis');
  		QmatNMR.h670 = uimenu(QmatNMR.h667, 'label', 'Use Default Axis', 'callback', 'regelsetdefaultaxis');
  		uimenu(QmatNMR.h667, 'label', 'Reset Default Axis', 'callback', 'resetdefaultaxis');
  		QmatNMR.h669 = uimenu(QmatNMR.h667, 'label', 'Change Default');
  			uimenu(QmatNMR.h669, 'label', 'TD: Time',   'callback', 'QmatNMR.DefaultAxisSwitch = 0; QmatNMR.DefaultAxisType = 1; regelchangedefaultaxis');
  			uimenu(QmatNMR.h669, 'label', 'TD: Points', 'callback', 'QmatNMR.DefaultAxisSwitch = 0; QmatNMR.DefaultAxisType = 2; regelchangedefaultaxis');
  			uimenu(QmatNMR.h669, 'label', 'FD: kHz',    'callback', 'QmatNMR.DefaultAxisSwitch = 1; QmatNMR.DefaultAxisType = 1; regelchangedefaultaxis', 'separator', 'on');
  			uimenu(QmatNMR.h669, 'label', 'FD: Hz',     'callback', 'QmatNMR.DefaultAxisSwitch = 1; QmatNMR.DefaultAxisType = 2; regelchangedefaultaxis');
  			uimenu(QmatNMR.h669, 'label', 'FD: ppm',    'callback', 'QmatNMR.DefaultAxisSwitch = 1; QmatNMR.DefaultAxisType = 3; regelchangedefaultaxis');
  			uimenu(QmatNMR.h669, 'label', 'FD: Points', 'callback', 'QmatNMR.DefaultAxisSwitch = 1; QmatNMR.DefaultAxisType = 4; regelchangedefaultaxis');
  
  		QmatNMR.h669 = uimenu(QmatNMR.h667, 'label', 'External Reference');
  			uimenu(QmatNMR.h669, 'label', 'Apply External Reference', 'callback', 'askeditreference');
  			uimenu(QmatNMR.h669, 'label', 'Define External Reference', 'callback', 'askdefinereference');
  			uimenu(QmatNMR.h669, 'label', 'Import External Reference from disk', 'callback', 'askimportreference');
  
  		uimenu(QmatNMR.h667, 'label', 'Save Current Axis', 'callback', 'asksaveaxis', 'separator', 'on');
  		uimenu(QmatNMR.h667, 'label', 'ppm / Hz / kHz', 'callback', 'stats1d', 'separator', 'on');
  		uimenu(QmatNMR.h667, 'label', 'Time', 'callback', 'asktimeaxis1d');
  		uimenu(QmatNMR.h667, 'label', 'Gradient', 'callback', 'askgradientaxis1d');
  		uimenu(QmatNMR.h667, 'label', 'Points', 'callback', 'regelpointsaxis1d');
  		uimenu(QmatNMR.h667, 'label', 'User defined', 'callback', 'askuserdef');
  	uimenu(QmatNMR.h666, 'label', 'Title / Axes labels', 'callback', 'QmatNMR.command = 0; klabels');
  
          QmatNMR.h668 = uimenu(QmatNMR.h666, 'label', 'Plotting Functions', 'separator', 'on');
  	  	uimenu(QmatNMR.h668, 'label', '1D Bar plot', 'callback', 'askmake1dbar');
  	  	uimenu(QmatNMR.h668, 'label', 'Error Bar plot', 'callback', 'askmake1derrorbar');
  		uimenu(QmatNMR.h668, 'label', 'Show Sidebands', 'callback', 'askshowsidebands');
  
  	QmatNMR.opt17= uimenu(QmatNMR.h666, 'label', 'Mouse Pointer', 'separator', 'on');
  		uimenu(QmatNMR.opt17, 'label', 'Arrow', 'callback', 'set(gcf, ''pointer'', ''arrow'')');
  		uimenu(QmatNMR.opt17, 'label', 'Crosshair', 'callback', 'set(gcf, ''pointer'', ''crosshair'')');
  		uimenu(QmatNMR.opt17, 'label', 'crosshair', 'callback', 'set(gcf, ''pointer'', ''crosshair'')');
  		uimenu(QmatNMR.opt17, 'label', 'Ibeam', 'callback', 'set(gcf, ''pointer'', ''Ibeam'')');
  		uimenu(QmatNMR.opt17, 'label', 'Circle', 'callback', 'set(gcf, ''pointer'', ''circle'')');
  		uimenu(QmatNMR.opt17, 'label', 'Cross', 'callback', 'set(gcf, ''pointer'', ''cross'')');
  		uimenu(QmatNMR.opt17, 'label', 'Fleur', 'callback', 'set(gcf, ''pointer'', ''fleur'')');
  		uimenu(QmatNMR.opt17, 'label', 'Top', 'callback', 'set(gcf, ''pointer'', ''top'')');
  		uimenu(QmatNMR.opt17, 'label', 'Topl', 'callback', 'set(gcf, ''pointer'', ''topl'')');
  		uimenu(QmatNMR.opt17, 'label', 'Topr', 'callback', 'set(gcf, ''pointer'', ''topr'')');
  		uimenu(QmatNMR.opt17, 'label', 'Left', 'callback', 'set(gcf, ''pointer'', ''left'')');
  		uimenu(QmatNMR.opt17, 'label', 'Right', 'callback', 'set(gcf, ''pointer'', ''right'')');
  		uimenu(QmatNMR.opt17, 'label', 'Bottom', 'callback', 'set(gcf, ''pointer'', ''bottom'')');
  		uimenu(QmatNMR.opt17, 'label', 'Botl', 'callback', 'set(gcf, ''pointer'', ''botl'')');
  		uimenu(QmatNMR.opt17, 'label', 'Botr', 'callback', 'set(gcf, ''pointer'', ''botr'')');
  		uimenu(QmatNMR.opt17, 'label', 'Watch', 'callback', 'set(gcf, ''pointer'', ''watch'')');
  	QmatNMR.h666Axis = uimenu(QmatNMR.h666, 'label', 'Axis properties');
  		uimenu(QmatNMR.h666Axis, 'label', 'Axis On/Off/Etc', 'callback', 'askaxis');
  		uimenu(QmatNMR.h666Axis, 'label', 'Clear Axis', 'callback', 'askclearaxis');	
  		uimenu(QmatNMR.h666Axis, 'label', 'Axis Colors', 'callback', 'askaxiscolors');	
  		uimenu(QmatNMR.h666Axis, 'label', 'Axis Directions', 'callback', 'askdirs');	
  		uimenu(QmatNMR.h666Axis, 'label', 'Axis Labels', 'callback', 'askaxislabels');	
  		uimenu(QmatNMR.h666Axis, 'label', 'Axis Locations', 'callback', 'askaxislocation');	
  		uimenu(QmatNMR.h666Axis, 'label', 'Axis Position', 'callback', 'askaxisposition');
  		uimenu(QmatNMR.h666Axis, 'label', 'Axis View', 'callback', 'findcurrentfigure; askaxisview');
  		uimenu(QmatNMR.h666Axis, 'label', 'Title', 'callback', 'asktitle');
  	uimenu(QmatNMR.h666, 'label', 'Box', 'callback', 'askbox');
  	uimenu(QmatNMR.h666, 'label', 'Font properties', 'callback', 'askfont');
  	uimenu(QmatNMR.h666, 'label', 'Grid', 'callback', 'askgrid');
  	uimenu(QmatNMR.h666, 'label', 'Hold', 'callback', 'askhold');
  	QmatNMR.h666Line = uimenu(QmatNMR.h666, 'label', 'Line properties');
  		uimenu(QmatNMR.h666Line, 'label', 'Line Color', 'callback', 'asklinecolor');
  		QmatNMR.opt109= uimenu(QmatNMR.h666Line, 'label', 'Line Style');
  			uimenu(QmatNMR.opt109,'label', '-', 'callback', 'Linestyle(''-''); disp(''Linestyle set to solid'');');
  			uimenu(QmatNMR.opt109,'label', '--', 'callback', 'Linestyle(''--''); disp(''Linestyle set to dashed'');');
  			uimenu(QmatNMR.opt109,'label', ':', 'callback', 'Linestyle('':''); disp(''Linestyle set to dotted'');');
  			uimenu(QmatNMR.opt109,'label', '-.', 'callback', 'Linestyle(''-.''); disp(''Linestyle set to dash-dot'');');
  			uimenu(QmatNMR.opt109,'label', 'None', 'callback', 'Linestyle(''none''); disp(''Linestyle set to none'');');
  		QmatNMR.opt93 = uimenu(QmatNMR.h666Line, 'label', 'Line Width');
  			uimenu(QmatNMR.opt93, 'label', '0.05', 'callback', 'Linewidth(0.05); disp(''Linewidth set to 0.05'');');	
  			uimenu(QmatNMR.opt93, 'label', '0.10', 'callback', 'Linewidth(0.1); disp(''Linewidth set to 0.10'');');	
  			uimenu(QmatNMR.opt93, 'label', '0.15', 'callback', 'Linewidth(0.15); disp(''Linewidth set to 0.15'');');	
  			uimenu(QmatNMR.opt93, 'label', '0.25', 'callback', 'Linewidth(0.25); disp(''Linewidth set to 0.25'');');	
  			uimenu(QmatNMR.opt93, 'label', '0.5', 'callback', 'Linewidth(0.5); disp(''Linewidth set to 0.5'');');	
  			uimenu(QmatNMR.opt93, 'label', '1.0', 'callback', 'Linewidth(1.0); disp(''Linewidth set to 1.0'');');	
  			uimenu(QmatNMR.opt93, 'label', '1.5', 'callback', 'Linewidth(1.5); disp(''Linewidth set to 1.5'');');	
  			uimenu(QmatNMR.opt93, 'label', '2.0', 'callback', 'Linewidth(2.0); disp(''Linewidth set to 2.0'');');	
  			uimenu(QmatNMR.opt93, 'label', '3.0', 'callback', 'Linewidth(3.0); disp(''Linewidth set to 3.0'');');	
  			uimenu(QmatNMR.opt93, 'label', '4.0', 'callback', 'Linewidth(4.0); disp(''Linewidth set to 4.0'');');	
  			uimenu(QmatNMR.opt93, 'label', '5.0', 'callback', 'Linewidth(5.0); disp(''Linewidth set to 5.0'');');	
  			uimenu(QmatNMR.opt93, 'label', '6.0', 'callback', 'Linewidth(6.0); disp(''Linewidth set to 6.0'');');	
  			uimenu(QmatNMR.opt93, 'label', '7.0', 'callback', 'Linewidth(7.0); disp(''Linewidth set to 7.0'');');	
  			uimenu(QmatNMR.opt93, 'label', '8.0', 'callback', 'Linewidth(8.0); disp(''Linewidth set to 8.0'');');	
  			uimenu(QmatNMR.opt93, 'label', '9.0', 'callback', 'Linewidth(9.0); disp(''Linewidth set to 9.0'');');	
  			uimenu(QmatNMR.opt93, 'label', '10.0', 'callback', 'Linewidth(10.0); disp(''Linewidth set to 10.0'');');	
  		QmatNMR.opt110= uimenu(QmatNMR.h666Line, 'label', 'Marker');
  			uimenu(QmatNMR.opt110,'label', 'None', 'callback', 'Marker(''none''); disp(''Marker set to none'');');
  			uimenu(QmatNMR.opt110,'label', 'Point', 'callback', 'Marker(''.''); disp(''Marker set to point'');');
  			uimenu(QmatNMR.opt110,'label', 'Plus', 'callback', 'Marker(''+''); disp(''Marker set to plus'');');
  			uimenu(QmatNMR.opt110,'label', 'Circle', 'callback', 'Marker(''o''); disp(''Marker set to circle'');');
  			uimenu(QmatNMR.opt110,'label', 'Asterisk', 'callback', 'Marker(''*''); disp(''Marker set to asterisk'');');
  			uimenu(QmatNMR.opt110,'label', 'Cross', 'callback', 'Marker(''x''); disp(''Marker set to cross'');');
  			uimenu(QmatNMR.opt110,'label', 'Square', 'callback', 'Marker(''s''); disp(''Marker set to square'');');
  			uimenu(QmatNMR.opt110,'label', 'Diamond', 'callback', 'Marker(''d''); disp(''Marker set to triangle diamond'');');
  			uimenu(QmatNMR.opt110,'label', 'Triangle up', 'callback', 'Marker(''^''); disp(''Marker set to triangle up'');');
  			uimenu(QmatNMR.opt110,'label', 'Triangle down', 'callback', 'Marker(''v''); disp(''Marker set to triangle down'');');
  			uimenu(QmatNMR.opt110,'label', 'Triangle right', 'callback', 'Marker(''>''); disp(''Marker set to triangle right'');');
  			uimenu(QmatNMR.opt110,'label', 'Triangle left', 'callback', 'Marker(''<''); disp(''Marker set to triangle left'');');
  			uimenu(QmatNMR.opt110,'label', 'Pentagram', 'callback', 'Marker(''p''); disp(''Marker set to pentagram'');');
  			uimenu(QmatNMR.opt110,'label', 'Hexagram', 'callback', 'Marker(''h''); disp(''Marker set to hexagram'');');
  		QmatNMR.opt111= uimenu(QmatNMR.h666Line, 'label', 'Marker Size');
  			uimenu(QmatNMR.opt111, 'label', '0.5', 'callback', 'Markersize(0.5); disp(''Marker Size set to 0.5'');');	
  			uimenu(QmatNMR.opt111, 'label', '1.0', 'callback', 'Markersize(1.0); disp(''Marker Size set to 1.0'');');	
  			uimenu(QmatNMR.opt111, 'label', '1.5', 'callback', 'Markersize(1.5); disp(''Marker Size set to 1.5'');');	
  			uimenu(QmatNMR.opt111, 'label', '2.0', 'callback', 'Markersize(2.0); disp(''Marker Size set to 2.0'');');	
  			uimenu(QmatNMR.opt111, 'label', '3.0', 'callback', 'Markersize(3.0); disp(''Marker Size set to 3.0'');');	
  			uimenu(QmatNMR.opt111, 'label', '4.0', 'callback', 'Markersize(4.0); disp(''Marker Size set to 4.0'');');	
  			uimenu(QmatNMR.opt111, 'label', '5.0', 'callback', 'Markersize(5.0); disp(''Marker Size set to 5.0'');');	
  			uimenu(QmatNMR.opt111, 'label', '6.0', 'callback', 'Markersize(6.0); disp(''Marker Size set to 6.0'');');	
  			uimenu(QmatNMR.opt111, 'label', '7.0', 'callback', 'Markersize(7.0); disp(''Marker Size set to 7.0'');');	
  			uimenu(QmatNMR.opt111, 'label', '8.0', 'callback', 'Markersize(8.0); disp(''Marker Size set to 8.0'');');	
  			uimenu(QmatNMR.opt111, 'label', '9.0', 'callback', 'Markersize(9.0); disp(''Marker Size set to 9.0'');');	
  			uimenu(QmatNMR.opt111, 'label', '10.0', 'callback', 'Markersize(10.0); disp(''Marker Size set to 10.0'');');	
  	uimenu(QmatNMR.h666, 'label', 'Scaling Limits', 'callback', 'asklims');
  	uimenu(QmatNMR.h666, 'label', 'Scaling Types', 'callback', 'askscales');
  	uimenu(QmatNMR.h666, 'label', 'Shading', 'callback', 'askshading');
  	QmatNMR.h666Tick = uimenu(QmatNMR.h666, 'label', 'Tick properties');
  		uimenu(QmatNMR.h666Tick, 'label', 'Tick direction', 'callback', 'asktickdir');
  		uimenu(QmatNMR.h666Tick, 'label', 'Tick Labels', 'callback', 'askticklabel');
  		uimenu(QmatNMR.h666Tick, 'label', 'Tick Lengths', 'callback', 'askticklengths');
  		uimenu(QmatNMR.h666Tick, 'label', 'Tick Positions', 'callback', 'asktick');
  			
  
  QmatNMR.h83 = uimenu(QmatNMR.Fig, 'Label', 'History / Macro', 'Position', [6]);
  	uimenu(QmatNMR.h83, 'label', 'Show History', 'callback', 'matnmrhelp(QmatNMR.History, ''QmatNMR.History'');');
  	uimenu(QmatNMR.h83, 'label', 'Connect History to FID', 'callback', 'askconnecttoFID');
  	uimenu(QmatNMR.h83, 'label', 'Save History macro in workspace', 'callback', 'asksaveasmacro');
  	uimenu(QmatNMR.h83, 'label', 'Convert History macro to script', 'callback', 'askconvertmacro');
  	uimenu(QmatNMR.h83, 'label', 'Reprocess from History', 'callback', 'QmatNMR.StepWise = 0; reprocessHistory');
  	uimenu(QmatNMR.h83, 'label', 'Reprocess stepwise from History', 'callback', 'QmatNMR.StepWise = 1; reprocessHistory');
  	uimenu(QmatNMR.h83, 'label', 'Clear History', 'callback', 'clearHistory');
  	uimenu(QmatNMR.h83, 'label', 'Start Recording Macro', 'callback', 'askstartrecordingmacro', 'separator', 'on');
  	uimenu(QmatNMR.h83, 'label', 'Stop Recording Macro', 'callback', 'askstoprecordingmacro');
  	uimenu(QmatNMR.h83, 'label', 'Execute User Command', 'callback', 'askusercommand', 'accelerator', 'u');
  	uimenu(QmatNMR.h83, 'label', 'Execute Macro', 'callback', 'QmatNMR.StepWise = 0; askexecutemacro', 'accelerator', 'e');
  	uimenu(QmatNMR.h83, 'label', 'Execute Macro Stepwise', 'callback', 'QmatNMR.StepWise = 1; askexecutemacro', 'accelerator', 's');
  
  QmatNMR.prt = uimenu(QmatNMR.Fig, 'Label', 'Create Output', 'Position', [7]);
  	uimenu(QmatNMR.prt, 'Label', 'Printing Menu', 'callback', 'figure(QmatNMR.Fig); matprint;', 'accelerator', 'p');
  	uimenu(QmatNMR.prt, 'label', 'Save plot on disk', 'callback', 'asksavefitdisk');
  	uimenu(QmatNMR.prt, 'Label', 'Copy Figure', 'callback', 'figure(QmatNMR.Fig); copyfignmr');
  
  QmatNMR.h67 	= uimenu(QmatNMR.Fig, 'Label', 'Options', 'Position', [8]);
  	uimenu(QmatNMR.h67, 'label', 'General Options', 'callback', 'Qoptions');
  	uimenu(QmatNMR.h67, 'label', 'Colour Scheme', 'callback', 'Qsetcolorscheme');
  	uimenu(QmatNMR.h67, 'label', 'Screen Settings', 'callback', 'Qscreenops');
  	uimenu(QmatNMR.h67, 'label', 'File options', 'callback', 'Qfileops');
  	uimenu(QmatNMR.h67, 'label', 'Font list', 'callback', 'Qfontops');
  	uimenu(QmatNMR.h67, 'label', 'Line Properties', 'callback', 'Qlinedata');
  	uimenu(QmatNMR.h67, 'label', 'Text Properties', 'callback', 'Qtextdata');
  	uimenu(QmatNMR.h67, 'label', 'Restore Defaults', 'callback', 'Qdefault');
  
  QTEMP = uimenu(QmatNMR.Fig, 'Label', 'HELP ?', 'position', [9]);
  	uimenu(QTEMP, 'label', 'Copyright', 'callback', 'matnmrhelp(''Copyright.hlp'', ''Copyright'')');
  	uimenu(QTEMP, 'label', 'Help desk', 'callback', ['web file://' QmatNMR.HelpPath filesep 'manual' filesep 'index.html;']);
  
  QmatNMR.clear = uimenu(QmatNMR.Fig, 'Label', 'Goodies', 'position', [10]);
  	uimenu(QmatNMR.clear, 'Label', 'Undo', 'callback', 'doUnDo', 'accelerator', 'z');
  	uimenu(QmatNMR.clear, 'Label', 'Clear Functions', 'callback', 'QmatNMR.SwitchTo1D = 0; QmatNMR.SingleSlice = 0; QmatNMR = orderfields(QmatNMR); clear functions; rehash path; disp(''Clear Functions performed ...''); Arrowhead');
  	uimenu(QmatNMR.clear, 'Label', 'Reset after error', 'callback', 'ResetAfterError');
  	uimenu(QmatNMR.clear, 'Label', 'Select matNMR distribution', 'callback', 'selectdistribution');
  
  %
  %set the foreground colour of the uimenu according to the colour scheme
  %
  set(findobj(QmatNMR.Fig, 'type', 'uimenu'), 'foregroundcolor', QmatNMR.ColorScheme.UImenuFore);
  
  
  %=====================================================================================================
  %
  % Then the uicontrols that are visible in the window itself.
  %
  %=====================================================================================================
  
  
  %=====================================================================================================
  %non-removable buttons
  %=====================================================================================================
  
  QmatNMR.fr1 = uicontrol('parent', QmatNMR.Fig, 'Style', 'frame',      'Position', [  2 515 125 172], 'backgroundcolor', QmatNMR.ColorScheme.Frame1);
  QmatNMR.h22 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [ 10 650 110  30], 'Callback', 'askstopnmr', 'String', 'Close Window', 'backgroundcolor', QmatNMR.ColorScheme.Button5Back, 'foregroundcolor', QmatNMR.ColorScheme.Button5Fore);
  
  QmatNMR.h4  = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [ 10 550 110  30], 'String', '2D menu', 'Callback', 'v2dmenu', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  
  QmatNMR.h82 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [ 10 580 110  30], 'String', '1D menu', 'Callback', 'v1dmenu', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  QmatNMR.h3  = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [ 10 616 110  24], 'String', 'Print', 'callback', 'watch; print -noui; Arrowhead; disp(''Current 1D spectrum printed ...'')', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  QmatNMR.h1  = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [ 10 520 110  30], 'String', 'Phase menu', 'Callback', 'fasemenu', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  
  
  
  %=====================================================================================================
  %zoom balkjes
  QmatNMR.fr6 = uicontrol('parent', QmatNMR.Fig, 'Style', 'frame', 'Position', [415 1 343 109], 'backgroundcolor', QmatNMR.ColorScheme.Frame1);
  QmatNMR.h32 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [425 36 80 30], 'Callback', 'inzoomx', 'String', 'Zoom in X', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  QmatNMR.h33 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [505 36 80 30], 'Callback', 'expansiex', 'String', 'Zoom out X', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  QmatNMR.h34 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [425  6 80 30], 'Callback', 'movespecleft', 'String', 'Left', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  QmatNMR.h35 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [505  6 80 30], 'Callback', 'movespecright', 'String', 'Right', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  
  QmatNMR.h36 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [590 36 80 30], 'Callback', 'inzoomy', 'String', 'Zoom in Y', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  QmatNMR.h37 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [670 36 80 30], 'Callback', 'expansiey', 'String', 'Zoom out Y', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  QmatNMR.h38 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [590  6 80 30], 'Callback', 'movespecup', 'String', 'Up', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  QmatNMR.h39 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [670  6 80 30], 'Callback', 'movespecdown', 'String', 'Down', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  QmatNMR.h40 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [425 70 120 30], 'callback', 'asaanpas', 'String', 'Reset figure', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  QmatNMR.h41 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Check', 'Position', [670 70 80 30], 'callback', 'ZoomMatNMR MainWindow', 'String', 'Zoom', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  QmatNMR.h42 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [560 70 95 30], 'callback', 'pos1d', 'String', 'Get Position', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  
  
  
  %=====================================================================================================
  %1d balken
    QmatNMR.fr3 = uicontrol('parent', QmatNMR.Fig, 'Style', 'frame', 'Position', [2 290 125 207]  , 'backgroundcolor', QmatNMR.ColorScheme.Frame1);
    QmatNMR.e5 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [10 459 110 30], 'String', '1D menu :', 'callback', 'stopmenu1d', 'backgroundcolor', QmatNMR.ColorScheme.Button5Back, 'foregroundcolor', QmatNMR.ColorScheme.Button5Fore);
  
    QTEMP8 = sprintf('| %s', QmatNMR.LastVariableNames1D(:).Spectrum);
    QmatNMR.textstring = ['Load 1D ' QTEMP8];
    QmatNMR.e1 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Popup', 'Position', [10 415 110 30], 'String', QmatNMR.textstring, 'Callback', 'regel1d', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
    QmatNMR.e2 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [10 385 110 30], 'String', 'Set Size 1D', 'Callback', 'QmatNMR.SwitchTo1D = 1; setsize1d', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
    QmatNMR.e3 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [10 355 110 30], 'String', 'FT 1D', 'Callback', 'QmatNMR.SwitchTo1D = 1; four1d', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
    QmatNMR.e4 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [10 325 110 30], 'String', 'Add to workspace', 'Callback', 'QmatNMR.SwitchTo1D = 1; asksave1d', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  
    QmatNMR.textstring = ['Dual Display ' QTEMP8];
    QmatNMR.e9 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Popup', 'Position', [10 295 110 30], 'String', QmatNMR.textstring, 'callback', 'asknamedual', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  
    if (QmatNMR.Q1DMenu == 0)
      stopmenu1d;			%don't show it at startup if chosen by the user
    end
  
  
  
  %=====================================================================================================
  %undo buttons
  uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'position', [1050 653 90 50], 'String', 'UNDO', 'callback', 'doUnDo', 'backgroundcolor', QmatNMR.ColorScheme.Button3Back, 'foregroundcolor', QmatNMR.ColorScheme.Button3Fore);
  uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'position', [1050 628 45 27], 'String', '# 1D', 'callback', 'doUnDo', 'backgroundcolor', QmatNMR.ColorScheme.Button7Back, 'foregroundcolor', QmatNMR.ColorScheme.Button7Fore);
  QmatNMR.u1 = uicontrol('parent', QmatNMR.Fig, 'Style', 'edit', 'position', [1050 603 45 27], 'String', num2str(QmatNMR.UnDo1D), 'callback', 'QmatNMR.UnDo1D = eval(get(QmatNMR.u1, ''string'')); regelUNDO', 'backgroundcolor', QmatNMR.ColorScheme.Button2Back, 'foregroundcolor', QmatNMR.ColorScheme.Button2Fore);
  uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'position', [1095 628 45 27], 'String', '# 2D', 'callback', 'doUnDo', 'backgroundcolor', QmatNMR.ColorScheme.Button7Back, 'foregroundcolor', QmatNMR.ColorScheme.Button7Fore);
  QmatNMR.u2 = uicontrol('parent', QmatNMR.Fig, 'Style', 'edit', 'position', [1095 603 45 27], 'String', num2str(QmatNMR.UnDo2D), 'callback', 'QmatNMR.UnDo2D = eval(get(QmatNMR.u2, ''string'')); regelUNDO', 'backgroundcolor', QmatNMR.ColorScheme.Button2Back, 'foregroundcolor', QmatNMR.ColorScheme.Button2Fore);
  
  
  
  %=====================================================================================================
  %reload last 1D or 2D FID or spectrum button
  QmatNMR.rl  = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'position', [1050 300 90 30], 'String', 'Reload Last', 'callback', 'reload', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  
  
  %=====================================================================================================
  %Acquisition related UI's
  QmatNMR.acq1  = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'position', [1050 330 90 30], 'String', 'Transfer Acq.', 'callback', 'transferacquisitiondata', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  
  %=====================================================================================================
  %set status of current spectrum in the matNMR window to FID --> then the xdir is set to normal !
  %(so then the time scale is properly printed)
  QmatNMR.DIM = uicontrol('parent', QmatNMR.Fig, 'Style', 'Popup', 'position', [1050 440 90 30], 'String', '1D | 2D, TD2 | 2D, TD1', 'callback', 'DIMstatus', 'value', 1, 'backgroundcolor', QmatNMR.ColorScheme.Button4Back, 'foregroundcolor', QmatNMR.ColorScheme.Button4Fore, 'fontweight', 'bold');
  %=====================================================================================================
  %set status of current spectrum in the matNMR window to FID --> then the xdir is set to normal !
  %(so then the time scale is properly printed)
  QmatNMR.FID = uicontrol('parent', QmatNMR.Fig, 'Style', 'Popup', 'position', [1050 410 90 30], 'String', 'Spectrum | FID', 'callback', 'FIDstatus', 'value', 2, 'backgroundcolor', QmatNMR.ColorScheme.Button4Back, 'foregroundcolor', QmatNMR.ColorScheme.Button4Fore, 'fontweight', 'bold');
  
  
  %=====================================================================================================
  %Popup button that allows changing the default axis
  QmatNMR.defaultaxisbutton = uicontrol('parent', QmatNMR.Fig, 'Style', 'Popup', 'Position', [1050 380 90 30], 'String', 'Toggle ON/OFF | TD: Time | TD: Points | FD: kHz | FD: Hz | FD: ppm | FD: Points | Default Axis OFF', 'callback', 'regeldefaultaxisbutton', 'backgroundcolor', QmatNMR.ColorScheme.Button4Back, 'foregroundcolor', QmatNMR.ColorScheme.Button4Fore, 'fontweight', 'bold');
  
  
  %=====================================================================================================
  %Fourier mode
  QmatNMR.fourtxt = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [420 165 100 27], 'String', 'Fourier mode :', 'backgroundcolor', QmatNMR.ColorScheme.Button7Back, 'foregroundcolor', QmatNMR.ColorScheme.Button7Fore);
  QmatNMR.Four = uicontrol('parent', QmatNMR.Fig, 'Style', 'popup', 'Position', [520 165  150  27], 'String', 'Complex FT | Real FT | States | TPPI | Whole Echo | States-TPPI | Bruker qseq | Sine FT', 'callback','resetfourmode', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  set(QmatNMR.Four, 'value', QmatNMR.four2);			%Set standard FT mode for 1D and td2 of 2D FID's
  
  
  %=====================================================================================================
  %Check button to deal with multiplication of first point by 0.5, or not. Default is yes.
  QmatNMR.fftstatusbutton = uicontrol('parent', QmatNMR.Fig, 'Style', 'Check', 'Position', [675 165 105 27], 'String', 'Multiply by 0.5', 'callback', 'QmatNMR.fftstatus = get(QmatNMR.fftstatusbutton, ''value'');', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  set(QmatNMR.fftstatusbutton, 'value', QmatNMR.fftstatus);			%Set standard FT mode for 1D and td2 of 2D FID's
  
  
  %=====================================================================================================
  %Popup button to select the sign of the gyromagnetic ratio, which defines the frequency axis. Default is positive.
  QmatNMR.gammabutton = uicontrol('parent', QmatNMR.Fig, 'Style', 'Popup', 'Position', [675 138 105 27], 'String', 'g > 0 | g < 0', 'FontName','Symbol', 'callback', 'whatgamma1d_2; asaanpas', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  set(QmatNMR.gammabutton, 'value', QmatNMR.gamma1d);			%Set default value for gyromagnetic ratio
  
  
  %=====================================================================================================
  %lijnverbreding
  QmatNMR.h75 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Popup', 'Position', [520 138  150  27], 'String', 'None | Exponential | Cos^2 | Gaussian | Hamming| Shifting Gauss | Exponential (echo) | Gaussian (echo) | Shifting Gauss (echo)', 'callback', 'regellb', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  QmatNMR.lbtxt = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [420 138 100 27], 'String', 'Apodization :', 'backgroundcolor', QmatNMR.ColorScheme.Button7Back, 'foregroundcolor', QmatNMR.ColorScheme.Button7Fore);
  
  
  %=====================================================================================================
  %Real / Imaginair ...
  QmatNMR.h76 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Popup', 'Position', [520 193  150  27], 'String', 'Real | Imaginary | Both | Absolute | Power', 'callback', 'regelRI', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  QmatNMR.disptxt = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [420 193 100 27], 'String', 'Display mode :', 'backgroundcolor', QmatNMR.ColorScheme.Button7Back, 'foregroundcolor', QmatNMR.ColorScheme.Button7Fore);
  
  
  %=====================================================================================================
  %Spectral width ...
  QmatNMR.hsweep = uicontrol('parent', QmatNMR.Fig, 'Style', 'Edit', 'Position', [513 110  70  27], 'String', num2str(QmatNMR.SW1D, 10), 'callback', 'regelsweepwidth', 'backgroundcolor', QmatNMR.ColorScheme.Button2Back, 'foregroundcolor', QmatNMR.ColorScheme.Button2Fore, 'horizontalalignment', 'left');
  QmatNMR.sweeptxt = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [398 110 115 27], 'String', 'Spectr. Width (kHz) :', 'backgroundcolor', QmatNMR.ColorScheme.Button7Back, 'foregroundcolor', QmatNMR.ColorScheme.Button7Fore);
  
  
  %=====================================================================================================
  %Spectrometer frequency ...
  QmatNMR.hspecfreq = uicontrol('parent', QmatNMR.Fig, 'Style', 'Edit', 'Position', [710 110  70  27], 'String', num2str(QmatNMR.SF1D, 10), 'callback', 'regelspectrometerfrequency', 'backgroundcolor', QmatNMR.ColorScheme.Button2Back, 'foregroundcolor', QmatNMR.ColorScheme.Button2Fore, 'horizontalalignment', 'left');
  QmatNMR.freqtxt = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [585 110 125 27], 'String', 'Spectr. Freq. (MHz) :', 'backgroundcolor', QmatNMR.ColorScheme.Button7Back, 'foregroundcolor', QmatNMR.ColorScheme.Button7Fore);
  
  
  
  %=====================================================================================================
  %2D balken
  QmatNMR.fr5 = uicontrol('parent', QmatNMR.Fig, 'Style', 'frame', 'Position', [783 1 357 223]', 'backgroundcolor', QmatNMR.ColorScheme.Frame1);  
  QmatNMR.h50 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [793 185 100  30], 'String', '2D menu :', 'callback', 'stopmenu2d', 'backgroundcolor', QmatNMR.ColorScheme.Button5Back, 'foregroundcolor', QmatNMR.ColorScheme.Button5Fore);
  
  QmatNMR.h71 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [793 131 100  30], 'callback', 'QmatNMR.SwitchTo1D = 0; apodize2d', 'String', 'Apodize 2D', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  QmatNMR.h59 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [793 101 100  30], 'callback', 'QmatNMR.SwitchTo1D = 0; setsize', 'String', 'Set Sizes', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  QmatNMR.h52 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [793  71 100  30], 'callback', 'QmatNMR.SwitchTo1D = 0; four2d', 'String', 'FT', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  QmatNMR.h54 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [793  41 100  30], 'callback', 'QmatNMR.SwitchTo1D = 0; setphase2d', 'String', 'Set Phase 2D', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  QmatNMR.h55 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [793  11 100  30], 'callback', 'QmatNMR.SwitchTo1D = 0; askDCcorr2d', 'String', 'DC Correction', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  
  QTEMP8 = sprintf('| %s', QmatNMR.LastVariableNames2D(:).Spectrum);
  QmatNMR.textstring = ['Load 2D ' QTEMP8];
  QmatNMR.h51 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Popup',      'Position', [893 131 100  30], 'String', QmatNMR.textstring, 'Callback', 'regel2d', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  QmatNMR.h43 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'position', [893 101 100  30], 'String', 'Add to workspace', 'callback', 'asksave2d', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  QTEMP8 = sprintf('| %s', QmatNMR.LastVariableNames3D(:).Spectrum);
  QmatNMR.textstring = ['Load 3D ' QTEMP8];
  QmatNMR.h53 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Popup',      'Position', [893  71 100  30], 'String', QmatNMR.textstring, 'Callback', 'regel3d', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  
  QmatNMR.h56 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [1075 153  60  30], 'String', 'Column :', 'Callback', 'QmatNMR.uiInput1 = get(QmatNMR.h72, ''String''); QmatNMR.buttonList=1; regelgetcolumn', 'backgroundcolor', QmatNMR.ColorScheme.Button7Back, 'foregroundcolor', QmatNMR.ColorScheme.Button7Fore);
  QmatNMR.h72 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Edit', 'Position', [1075 128  60  25], 'Callback', 'QmatNMR.uiInput1 = get(QmatNMR.h72, ''String''); QmatNMR.buttonList=1; regelgetcolumn', 'String', '1', 'backgroundcolor', QmatNMR.ColorScheme.Button2Back, 'foregroundcolor', QmatNMR.ColorScheme.Button2Fore);
  QmatNMR.h57 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [1013 153  60  30], 'String', 'Row :', 'Callback', 'QmatNMR.uiInput1 = get(QmatNMR.h74, ''String''); QmatNMR.buttonList=1; regelgetslice', 'backgroundcolor', QmatNMR.ColorScheme.Button7Back, 'foregroundcolor', QmatNMR.ColorScheme.Button7Fore);
  QmatNMR.h74 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Edit', 'Position', [1013 128  60  25], 'Callback', 'QmatNMR.uiInput1 = get(QmatNMR.h74, ''String''); QmatNMR.buttonList=1; regelgetslice', 'String', '1', 'backgroundcolor', QmatNMR.ColorScheme.Button2Back, 'foregroundcolor', QmatNMR.ColorScheme.Button2Fore);
  
  QmatNMR.h60 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [1075  68  60  30], 'callback', 'QmatNMR.kolomnr = QmatNMR.kolomnr + 1; viewcolumn', 'String', '+ Col', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  QmatNMR.h61 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [1013  68  60  30], 'callback', 'QmatNMR.kolomnr = QmatNMR.kolomnr - 1; viewcolumn', 'String', '- Col', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  QmatNMR.h62 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [1075  98  60  30], 'callback', 'QmatNMR.rijnr = QmatNMR.rijnr + 1; viewrow', 'String', '+ Row', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  QmatNMR.h63 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [1013  98  60  30], 'callback', 'QmatNMR.rijnr = QmatNMR.rijnr - 1; viewrow', 'String', '- Row', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  QmatNMR.h64 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Popup', 'Position', [ 982  34 152  30], 'Callback', 'regelviews', 'String', 'Various Views | Diagonal | Anti-Diagonal | Project onto TD1 | Project onto TD2 | Skyline | Horizontal Stack plot | Vertical Stack plot', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  
  QmatNMR.h73 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [ 982   6 152  26], 'callback', 'QmatNMR.SpecName2D3D = ''QmatNMR.Spec2D''; QmatNMR.UserDefAxisT2Cont = ''QmatNMR.AxisTD2''; QmatNMR.UserDefAxisT1Cont = ''QmatNMR.AxisTD1''; nmr2d', 'String', '2D/3D Viewer', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  
  if (QmatNMR.Q2DMenu == 0)
    stopmenu2d; 		%don't show it if chosen by the user in the options
  end
  
  
  %=====================================================================================================
  %Phasing menu
  %
  %=====================================================================================================
  QmatNMR.fr4 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Frame', 'Position', [2 1 393 223], 'backgroundcolor', QmatNMR.ColorScheme.Frame1);
  QmatNMR.p0 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [10 185 100 30], 'String', 'Phasing :', 'callback', 'stopfasemenu', 'backgroundcolor', QmatNMR.ColorScheme.Button5Back, 'foregroundcolor', QmatNMR.ColorScheme.Button5Fore);
  
  
  %button for ACME automatic phase correction
  QmatNMR.p6 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [147 95 100  25], 'Callback', 'QmatNMR.ACMEphasing = 1; setphase1d', 'String', 'Automatic', 'backgroundcolor', QmatNMR.ColorScheme.Button4Back, 'foregroundcolor', QmatNMR.ColorScheme.Button4Fore);
  
  
  % 0th order correction buttons
  QmatNMR.p1 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Slider',     'Position', [ 10  50 180  40], 'Min', -180, 'Max', 180, 'Callback', 'QmatNMR.dph0 =get(QmatNMR.p1,''Value'')-QmatNMR.fase0; QmatNMR.dph1 = 0; QmatNMR.dph2 = 0;  setphase1d', 'String', '+ Ph0', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  QmatNMR.p2 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [ 78   5  50  40], 'Callback', 'QmatNMR.dph0 = -0.5; QmatNMR.dph1 = 0; QmatNMR.dph2 = 0;  setphase1d', 'String', '- 0.5', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  QmatNMR.p3 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [139   5  50  40], 'Callback', 'QmatNMR.dph0 = +0.5; QmatNMR.dph1 = 0; QmatNMR.dph2 = 0;  setphase1d', 'String', '+ 0.5', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  QmatNMR.p4 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [ 10  95  70  25], 'String', '0th order', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  [QmatNMR.p5, QmatNMR.buts] = Qeditnum(gcf, -180, 180, 5, 'FLOAT_BT_BB', 'Position', [10, 5, 65, 40], 'string', '0', 'callback', 'QmatNMR.dph0 = get(QmatNMR.p5,''Value'')-QmatNMR.fase0; QmatNMR.dph1 = 0; QmatNMR.dph2 = 0;  setphase1d');
  set(QmatNMR.p5  , 'backgroundcolor', QmatNMR.ColorScheme.Button2Back, 'foregroundcolor', QmatNMR.ColorScheme.Button2Fore);
  set(QmatNMR.buts, 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  QmatNMR.p51 = QmatNMR.buts(1);
  QmatNMR.p52 = QmatNMR.buts(2);
  
  
  % 1st order correction buttons
  QmatNMR.p11 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Slider',     'Position', [210  50 180  40], 'Min', -540, 'Max', 540, 'Callback', 'QmatNMR.dph1 =get(QmatNMR.p11,''Value'')-QmatNMR.fase1;  QmatNMR.dph0 = 0; QmatNMR.dph2 = 0;  setphase1d', 'String', '+ Ph1', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  QmatNMR.p12 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [278   5  50  40], 'Callback', 'QmatNMR.dph0 = 0; QmatNMR.dph2 = 0; QmatNMR.dph1 = -1;  setphase1d', 'String', '- 1', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  QmatNMR.p13 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [339   5  50  40], 'Callback', 'QmatNMR.dph0 = 0; QmatNMR.dph2 = 0; QmatNMR.dph1 = 1;  setphase1d', 'String', '+ 1', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  QmatNMR.p14 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [315  95  70  25], 'String', '1st order', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  [QmatNMR.p15, QmatNMR.buts] = Qeditnum(gcf, -3000000, 3000000, 20, 'FLOAT_BT_BB', 'Position', [210 5 65 40], 'string', '0', 'callback', 'QmatNMR.dph1 = get(QmatNMR.p15,''Value'')-QmatNMR.fase1;QmatNMR.dph0 = 0; QmatNMR.dph2 = 0;  setphase1d');
  set(QmatNMR.p15 , 'backgroundcolor', QmatNMR.ColorScheme.Button2Back, 'foregroundcolor', QmatNMR.ColorScheme.Button2Fore);
  set(QmatNMR.buts, 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  QmatNMR.p151 = QmatNMR.buts(1);
  QmatNMR.p152 = QmatNMR.buts(2);
  
  
  % 2nd order correction buttons
  QmatNMR.p30 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Frame',      'Position', [395   1 215 125], 'backgroundcolor', QmatNMR.ColorScheme.Frame1);
  QmatNMR.p24 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Slider',     'Position', [410  50 180  40], 'Min', -360, 'Max', 360, 'Callback', 'QmatNMR.dph2 =get(QmatNMR.p24,''Value'')-QmatNMR.fase2;  QmatNMR.dph0 = 0; QmatNMR.dph1 = 0;  setphase1d', 'String', '+ Ph1', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  QmatNMR.p25 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [478   5  50  40], 'Callback', 'QmatNMR.dph0 = 0; QmatNMR.dph1 = 0; QmatNMR.dph2 = -1;  setphase1d', 'String', '- 1', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  QmatNMR.p26 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [539   5  50  40], 'Callback', 'QmatNMR.dph0 = 0; QmatNMR.dph1 = 0; QmatNMR.dph2 = 1;  setphase1d', 'String', '+ 1', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  QmatNMR.p27 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [505  95  80  25], 'String', '2nd order', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  [QmatNMR.p28, QmatNMR.buts] = Qeditnum(gcf, -3000000, 3000000, 20, 'FLOAT_BT_BB', 'Position', [410 5 65 40], 'string', '0', 'callback', 'QmatNMR.dph2 = get(QmatNMR.p28,''Value'')-QmatNMR.fase2; QmatNMR.dph0 = 0; QmatNMR.dph1 = 0;  setphase1d');
  set(QmatNMR.p28, 'backgroundcolor', QmatNMR.ColorScheme.Button2Back, 'foregroundcolor', QmatNMR.ColorScheme.Button2Fore);
  set(QmatNMR.buts, 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  QmatNMR.p281 = QmatNMR.buts(1);
  QmatNMR.p282 = QmatNMR.buts(2);
  
  
  %=====================================================================================================
  %extra buttons
  QmatNMR.p21 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [310 185  80 30], 'callback', 'QmatNMR.dph0 = - (get(QmatNMR.p5,''Value''));  QmatNMR.dph1 = - (get(QmatNMR.p15,''Value''));  QmatNMR.dph2 = - (get(QmatNMR.p28,''Value''));  setphase1d; repair;', 'String', 'zero phases', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  QmatNMR.p22 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [225 150 100 30], 'Callback', 'muisinput', 'String', 'Reference Ph1 :', 'backgroundcolor', QmatNMR.ColorScheme.Button7Back, 'foregroundcolor', QmatNMR.ColorScheme.Button7Fore);
  QmatNMR.p23 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Edit',       'Position', [325 150  60 30], 'Callback', 'setrefphase1', 'String', '1', ...
                   'backgroundcolor', QmatNMR.ColorScheme.Button2Back, 'foregroundcolor', QmatNMR.ColorScheme.Button2Fore, 'horizontalalignment', 'left');
  QmatNMR.p29 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Check', 'Position', [229 185  80 25], 'callback', 'switch2ndorder', 'String', '2nd order', 'value', 0, 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  QmatNMR.p31 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Check', 'Position', [148 185  80 25], 'callback', 'switch2Daid', 'String', '2D tool', 'value', 0, 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  
  QmatNMR.p32 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [ 90 155  65 25], 'String', 'Index TD2', 'backgroundcolor', QmatNMR.ColorScheme.Button7Back, 'foregroundcolor', QmatNMR.ColorScheme.Button7Fore);
  QmatNMR.p33 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Edit',       'Position', [ 90 130  65 25], 'String', '', 'callback', 'CheckNumeric(QmatNMR.p33, 1, QmatNMR.SizeTD1); update2Daid', 'backgroundcolor', QmatNMR.ColorScheme.Button2Back, 'foregroundcolor', QmatNMR.ColorScheme.Button2Fore);
  QmatNMR.p34 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Edit',       'Position', [ 90 105  65 25], 'String', '', 'callback', 'CheckNumeric(QmatNMR.p34, 1, QmatNMR.SizeTD1); update2Daid', 'backgroundcolor', QmatNMR.ColorScheme.Button2Back, 'foregroundcolor', QmatNMR.ColorScheme.Button2Fore);
  
  QmatNMR.p35 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [155 155  65 25], 'String', 'Index TD1', 'backgroundcolor', QmatNMR.ColorScheme.Button7Back, 'foregroundcolor', QmatNMR.ColorScheme.Button7Fore);
  QmatNMR.p36 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Edit',       'Position', [155 130  65 25], 'String', '', 'callback', 'CheckNumeric(QmatNMR.p36, 1, QmatNMR.SizeTD2); update2Daid', 'backgroundcolor', QmatNMR.ColorScheme.Button2Back, 'foregroundcolor', QmatNMR.ColorScheme.Button2Fore);
  QmatNMR.p37 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Edit',       'Position', [155 105  65 25], 'String', '', 'callback', 'CheckNumeric(QmatNMR.p37, 1, QmatNMR.SizeTD2); update2Daid', 'backgroundcolor', QmatNMR.ColorScheme.Button2Back, 'foregroundcolor', QmatNMR.ColorScheme.Button2Fore);
  
  QmatNMR.p38 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Pushbutton', 'Position', [ 10 130  80 25], 'String', 'Pick slices', 'callback', 'pickslices2Daid', 'backgroundcolor', QmatNMR.ColorScheme.Button1Back, 'foregroundcolor', QmatNMR.ColorScheme.Button1Fore);
  
  
  switch2Daid		%by default the panel for the 2D phasing aid is switched off, unless the user asks for it
  
  switch2ndorder		%by default the panel for the 2nd phase correction is switched off, unless the user asks for it
  
  if (QmatNMR.PhaseMenu == 0)
    stopfasemenu;		%don't show phase menu at startup if chosen by the user in the options
  end
  
  
  
  %=====================================================================================================
  %
  % Finally the uimenus that go into the uicontextmenus that are coupled to the figure window and all uicontrols
  %
  %=====================================================================================================
  
  
  %
  %we first define the context menu and connect it to the figure window, all uicontrols 
  %and the axis (but only if zoom is off! -> see ZoomMatNMR)
  %
  QmatNMR.ContextMain = uicontextmenu;
  set(QmatNMR.ContextMain, 'tag', 'MainContextMenu');
  set(QmatNMR.Fig, 'uicontextmenu', QmatNMR.ContextMain);
  set(findobj(QmatNMR.Fig, 'tag', 'MainAxis'), 'uicontextmenu', QmatNMR.ContextMain)
  set(findobj(allchild(QmatNMR.Fig), 'type', 'uicontrol'), 'uicontextmenu', QmatNMR.ContextMain);
  
  %
  %Some items for 1D processing
  %
  QmatNMR.h666 = uimenu(QmatNMR.ContextMain, 'label', '  1D Processing    ');
  	QmatNMR.b1Std = uimenu(QmatNMR.h666, 'label', 'Standard processing', 'separator', 'on');
  		uimenu(QmatNMR.b1Std, 'label', 'Remove Bruker digital filter', 'Callback', 'QmatNMR.SwitchTo1D = 1; askBrukerdig', 'separator', 'on');
  		uimenu(QmatNMR.b1Std, 'label', 'Shift Data Points', 'Callback', 'QmatNMR.SwitchTo1D = 1; askleftshift');
  		uimenu(QmatNMR.b1Std, 'Label', 'Swap Whole Echo', 'callback', 'QmatNMR.SwitchTo1D = 1; askswapecho');
  		uimenu(QmatNMR.b1Std, 'label', 'DC offset correction', 'callback', 'QmatNMR.SwitchTo1D = 1; askDCcorr1d');
  		uimenu(QmatNMR.b1Std, 'label', 'Solvent Deconvolution', 'callback', 'QmatNMR.SwitchTo1D = 1; asksolventsuppression1d');
  		QmatNMR.b1Apod = uimenu(QmatNMR.b1Std, 'label', 'Apodization');
  			uimenu(QmatNMR.b1Apod, 'label', 'None', 'callback', 'set(QmatNMR.h75, ''value'', 1); regellb');
  			uimenu(QmatNMR.b1Apod, 'label', 'Exponential', 'callback', 'set(QmatNMR.h75, ''value'', 2); regellb');
  			uimenu(QmatNMR.b1Apod, 'label', 'Cos^2', 'callback', 'set(QmatNMR.h75, ''value'', 3); regellb');
  			uimenu(QmatNMR.b1Apod, 'label', 'Gaussian', 'callback', 'set(QmatNMR.h75, ''value'', 4); regellb');
  			uimenu(QmatNMR.b1Apod, 'label', 'Hamming', 'callback', 'set(QmatNMR.h75, ''value'', 5); regellb');
  			uimenu(QmatNMR.b1Apod, 'label', 'Shifting Gauss', 'callback', 'set(QmatNMR.h75, ''value'', 6); regellb');
  			uimenu(QmatNMR.b1Apod, 'label', 'Exponential (echo)', 'callback', 'set(QmatNMR.h75, ''value'', 7); regellb');
  			uimenu(QmatNMR.b1Apod, 'label', 'Gaussian (echo)', 'callback', 'set(QmatNMR.h75, ''value'', 8); regellb');
  			uimenu(QmatNMR.b1Apod, 'label', 'Shifting Gauss (echo)', 'callback', 'set(QmatNMR.h75, ''value'', 9); regellb');
  		uimenu(QmatNMR.b1Std, 'label', 'Set Size', 'callback', 'QmatNMR.SwitchTo1D = 1; setsize1d');
  		uimenu(QmatNMR.b1Std, 'label', 'FT', 'callback', 'QmatNMR.SwitchTo1D = 1; QmatNMR.InverseFTflag = 0; four1d');
  		uimenu(QmatNMR.b1Std, 'label', 'FFTshift', 'callback', 'QmatNMR.SwitchTo1D = 1; shiftFFT1d');
  		uimenu(QmatNMR.b1Std, 'label', 'Flip L/R', 'callback', 'QmatNMR.SwitchTo1D = 1; flipspec');
  		uimenu(QmatNMR.b1Std, 'label', 'Baseline Correction', 'callback', 'QmatNMR.SwitchTo1D = 1; basl1dmenu');
  
  	QmatNMR.b1Add = uimenu(QmatNMR.h666, 'label', 'Additional features');
  		uimenu(QmatNMR.b1Add, 'Label', 'Concatenate Matrix', 'callback', 'QmatNMR.SwitchTo1D = 1; askconcatenate');
  		uimenu(QmatNMR.b1Add, 'label', 'Extract from 1D', 'callback', 'QmatNMR.SwitchTo1D = 1; askextract1d');
      uimenu(QmatNMR.b1Add, 'label', 'Get FWHH', 'callback', 'QmatNMR.SwitchTo1D = 1; regelgetFWHH1d');
  		uimenu(QmatNMR.b1Add, 'label', 'Integrate', 'callback', 'integrate1d');	
  		uimenu(QmatNMR.b1Add, 'label', 'Inverse FT', 'callback', 'QmatNMR.SwitchTo1D = 1; QmatNMR.InverseFTflag = 1; four1d');	
  		QmatNMR.b18= uimenu(QmatNMR.b1Add, 'label', 'Linear Prediction');
  			QmatNMR.b19 = uimenu(QmatNMR.b18, 'label', 'Backward');
  				uimenu(QmatNMR.b19, 'label', 'LPSVD', 'callback', 'QmatNMR.SwitchTo1D = 1; QmatNMR.LPtype = 1; asklp1d');
  				uimenu(QmatNMR.b19, 'label', 'ITMPM', 'callback', 'QmatNMR.SwitchTo1D = 1; QmatNMR.LPtype = 2; asklp1d');
  			QmatNMR.b20 = uimenu(QmatNMR.b18, 'label', 'Forward');
  				uimenu(QmatNMR.b20, 'label', 'LPSVD', 'callback', 'QmatNMR.SwitchTo1D = 1; QmatNMR.LPtype = 3; asklp1d');
  				uimenu(QmatNMR.b20, 'label', 'ITMPM', 'callback', 'QmatNMR.SwitchTo1D = 1; QmatNMR.LPtype = 4; asklp1d');
  		uimenu(QmatNMR.b1Add, 'label', 'MEM Reconstruction', 'callback', 'QmatNMR.SwitchTo1D = 1; askmem1d');
  		uimenu(QmatNMR.b1Add, 'label', 'Shift spectrum (applied to FID)', 'callback', 'QmatNMR.SwitchTo1D = 1; askshiftspectrum1d');
  		uimenu(QmatNMR.b1Add, 'label', 'S / N', 'callback', 'detsovern');
  
  	QmatNMR.b21 = uimenu(QmatNMR.h666, 'label', 'Fitting');	
  		uimenu(QmatNMR.b21, 'label', 'CSA Tensors MAS', 'callback', 'ssafit1d');
  		uimenu(QmatNMR.b21, 'label', 'CSA Tensors Static', 'callback', 'csatensorfit1d');
    		uimenu(QmatNMR.b21, 'label', 'Diffusion Curves', 'callback', 'Difffit1d');
  		uimenu(QmatNMR.b21, 'label', 'Peak Deconvolution', 'callback', 'piekfit1d');
  		uimenu(QmatNMR.b21, 'label', 'Quadrupole Tensors MAS', 'callback', 'quadtensorfit1d');
  		uimenu(QmatNMR.b21, 'label', 'Relaxation curves', 'callback', 't1fit1d');
  
  %
  %Some items for 2D processing
  %
  QmatNMR.h666 = uimenu(QmatNMR.ContextMain, 'label', '  2D Processing    ');
  	QmatNMR.bl1Full = uimenu(QmatNMR.h666, 'label', 'Full matrix Manipulations', 'separator', 'on');
  		uimenu(QmatNMR.bl1Full, 'label', 'Remove Bruker digital filter', 'Callback', 'QmatNMR.SwitchTo1D = 0; askBrukerdig', 'separator', 'on');
  		uimenu(QmatNMR.bl1Full, 'Label', 'Shift data points', 'callback', 'QmatNMR.SwitchTo1D = 0; askleftshift');
  		uimenu(QmatNMR.bl1Full, 'Label', 'Swap whole echo', 'callback', 'QmatNMR.SwitchTo1D = 0; askswapecho');
  		uimenu(QmatNMR.bl1Full, 'label', 'DC correction', 'callback', 'QmatNMR.SwitchTo1D = 0; askDCcorr2d');
  		uimenu(QmatNMR.bl1Full, 'label', 'Solvent Deconvolution', 'callback', 'QmatNMR.SwitchTo1D = 0; asksolventsuppression2d');
  		QmatNMR.bl1Apod = uimenu(QmatNMR.bl1Full, 'label', 'Choose Apodization');
  			uimenu(QmatNMR.bl1Apod, 'label', 'None', 'callback', 'set(QmatNMR.h75, ''value'', 1); regellb');
  			uimenu(QmatNMR.bl1Apod, 'label', 'Exponential', 'callback', 'set(QmatNMR.h75, ''value'', 2); regellb');
  			uimenu(QmatNMR.bl1Apod, 'label', 'Cos^2', 'callback', 'set(QmatNMR.h75, ''value'', 3); regellb');
  			uimenu(QmatNMR.bl1Apod, 'label', 'Gaussian', 'callback', 'set(QmatNMR.h75, ''value'', 4); regellb');
  			uimenu(QmatNMR.bl1Apod, 'label', 'Hamming', 'callback', 'set(QmatNMR.h75, ''value'', 5); regellb');
  			uimenu(QmatNMR.bl1Apod, 'label', 'Shifting Gauss', 'callback', 'set(QmatNMR.h75, ''value'', 6); regellb');
  			uimenu(QmatNMR.bl1Apod, 'label', 'Exponential (echo)', 'callback', 'set(QmatNMR.h75, ''value'', 7); regellb');
  			uimenu(QmatNMR.bl1Apod, 'label', 'Gaussian (echo)', 'callback', 'set(QmatNMR.h75, ''value'', 8); regellb');
  			uimenu(QmatNMR.bl1Apod, 'label', 'Shifting Gauss (echo)', 'callback', 'set(QmatNMR.h75, ''value'', 9); regellb');
  		uimenu(QmatNMR.bl1Full, 'label', 'Apodize 2D', 'callback', 'QmatNMR.SwitchTo1D = 0; apodize2d');
  		uimenu(QmatNMR.bl1Full, 'label', 'Set sizes', 'callback', 'QmatNMR.SwitchTo1D = 0; setsize');
  		uimenu(QmatNMR.bl1Full, 'label', 'Zero part of 2D', 'callback', 'QmatNMR.SwitchTo1D = 0; askzero2d');
  		uimenu(QmatNMR.bl1Full, 'label', 'FT', 'callback', 'QmatNMR.SwitchTo1D = 0; QmatNMR.InverseFTflag = 0; four2d');
  		uimenu(QmatNMR.bl1Full, 'label', 'FFTshift', 'callback', 'QmatNMR.SwitchTo1D = 0; shiftFFT2d');
  		uimenu(QmatNMR.bl1Full, 'label', 'Flip L/R', 'callback', 'QmatNMR.SwitchTo1D = 0; flipspec');
  		uimenu(QmatNMR.bl1Full, 'label', 'Set phase', 'callback', 'QmatNMR.SwitchTo1D = 0; setphase2d');
  		uimenu(QmatNMR.bl1Full, 'label', 'Baseline correction', 'callback', 'QmatNMR.SwitchTo1D = 0; basl2dmenu', 'separator', 'on');
  
  	QmatNMR.bl41 = uimenu(QmatNMR.h666, 'label', 'Single Slice Manipulations');
  		uimenu(QmatNMR.bl41, 'label', 'Shift Data Points', 'callback', 'QmatNMR.SwitchTo1D = 0; QmatNMR.SingleSlice = 1; askleftshift');
  		uimenu(QmatNMR.bl41, 'label', 'Set Phase', 'callback', 'QmatNMR.SwitchTo1D = 0; QmatNMR.SingleSlice = 1; setphase2d');
  
  	QmatNMR.bl1Add = uimenu(QmatNMR.h666, 'label', 'Additional features');
  		uimenu(QmatNMR.bl1Add, 'Label', 'Concatenate Matrix', 'callback', 'QmatNMR.SwitchTo1D = 0; askconcatenate');
  		uimenu(QmatNMR.bl1Add, 'label', 'Extract from 2D', 'callback', 'askextract2d');
  		uimenu(QmatNMR.bl1Add, 'label', 'Integrate', 'callback', 'QmatNMR.SwitchTo1D = 0; askintegrate2d');	
  		QmatNMR.bl31= uimenu(QmatNMR.bl1Add, 'label', 'Linear prediction');
  			QmatNMR.bl32 = uimenu(QmatNMR.bl31, 'label', 'Backward');
  				uimenu(QmatNMR.bl32, 'label', 'LPSVD', 'callback', 'QmatNMR.SwitchTo1D = 0; QmatNMR.LPtype = 1; asklp2d');
  				uimenu(QmatNMR.bl32, 'label', 'ITMPM', 'callback', 'QmatNMR.SwitchTo1D = 0; QmatNMR.LPtype = 2; asklp2d');
  			QmatNMR.bl35 = uimenu(QmatNMR.bl31, 'label', 'Forward');
  				uimenu(QmatNMR.bl35, 'label', 'LPSVD', 'callback', 'QmatNMR.SwitchTo1D = 0; QmatNMR.LPtype = 3; asklp2d');
  				uimenu(QmatNMR.bl35, 'label', 'ITMPM', 'callback', 'QmatNMR.SwitchTo1D = 0; QmatNMR.LPtype = 4; asklp2d');
  		uimenu(QmatNMR.bl1Add, 'label', 'MEM Reconstruction', 'callback', 'QmatNMR.SwitchTo1D = 0; askmem2d');
  		uimenu(QmatNMR.bl1Add, 'label', 'Set integral', 'callback', 'asksetintegral2d');
  		QmatNMR.bl40 = uimenu(QmatNMR.bl1Add, 'label', 'Shearing transformation');
  			uimenu(QmatNMR.bl40, 'label', 'In time domain', 'callback', 'QmatNMR.SwitchTo1D = 0; askshearingTD');
  			uimenu(QmatNMR.bl40, 'label', 'In frequency domain', 'callback', 'QmatNMR.SwitchTo1D = 0; askshearingFD');
  		uimenu(QmatNMR.bl1Add, 'label', 'Shift spectrum (applied to FID)', 'callback', 'askshiftspectrum2d');
  		QmatNMR.bl27= uimenu(QmatNMR.bl1Add, 'label', 'Symmetrize');
  			uimenu(QmatNMR.bl27, 'label', 'Average Intensities', 'callback', 'QmatNMR.SwitchTo1D = 0; QmatNMR.SYMMtype = 1; symmetrize2d');
  			uimenu(QmatNMR.bl27, 'label', 'Highest Intensities', 'callback', 'QmatNMR.SwitchTo1D = 0; QmatNMR.SYMMtype = 2; symmetrize2d');
                  uimenu(QmatNMR.bl1Add, 'Label', 'Transpose', 'callback', 'transponeer;');
  
  	QmatNMR.b28 = uimenu(QmatNMR.h666, 'label', 'Fitting');
  		uimenu(QmatNMR.b28, 'label', 'Peak Deconvolution', 'callback', 'piekfit2d');
  
  	QmatNMR.bl9 = uimenu(QmatNMR.h666, 'label', 'Various views');
  		uimenu(QmatNMR.bl9, 'label', 'Diagonal', 'callback', 'getdiag');
  		uimenu(QmatNMR.bl9, 'label', 'Anti-diagonal', 'callback', 'getantidiag');
  		uimenu(QmatNMR.bl9, 'label', 'Sum projection TD1', 'callback', 'askprojTD1');
  		uimenu(QmatNMR.bl9, 'label', 'Sum Projection TD2', 'callback', 'askprojTD2');
  		uimenu(QmatNMR.bl9, 'label', 'Skyline projection', 'callback', 'askskyline');
  		uimenu(QmatNMR.bl9, 'label', 'Horizontal Stack plot', 'callback', 'stack1dhorizontal');
  		uimenu(QmatNMR.bl9, 'label', 'Vertical Stack plot', 'callback', 'askstack1dvertical');
  
  
  %
  %A separate item to allow adjusting the axis ruler
  %
  QmatNMR.h667 	= uimenu(QmatNMR.ContextMain, 'Label', '  Ruler X-axis    ', 'separator', 'on');
  	uimenu(QmatNMR.h667, 'label', 'Use Default Axis', 'callback', 'regelsetdefaultaxis');
  	QmatNMR.h669 = uimenu(QmatNMR.h667, 'label', 'Change Default');
  		uimenu(QmatNMR.h669, 'label', 'TD: Time',   'callback', 'QmatNMR.DefaultAxisSwitch = 0; QmatNMR.DefaultAxisType = 1; regelchangedefaultaxis');
  		uimenu(QmatNMR.h669, 'label', 'TD: Points', 'callback', 'QmatNMR.DefaultAxisSwitch = 0; QmatNMR.DefaultAxisType = 2; regelchangedefaultaxis');
  		uimenu(QmatNMR.h669, 'label', 'FD: kHz',    'callback', 'QmatNMR.DefaultAxisSwitch = 1; QmatNMR.DefaultAxisType = 1; regelchangedefaultaxis', 'separator', 'on');
  		uimenu(QmatNMR.h669, 'label', 'FD: Hz',     'callback', 'QmatNMR.DefaultAxisSwitch = 1; QmatNMR.DefaultAxisType = 2; regelchangedefaultaxis');
  		uimenu(QmatNMR.h669, 'label', 'FD: ppm',    'callback', 'QmatNMR.DefaultAxisSwitch = 1; QmatNMR.DefaultAxisType = 3; regelchangedefaultaxis');
  		uimenu(QmatNMR.h669, 'label', 'FD: Points', 'callback', 'QmatNMR.DefaultAxisSwitch = 1; QmatNMR.DefaultAxisType = 4; regelchangedefaultaxis');
  
  	QmatNMR.h669 = uimenu(QmatNMR.h667, 'label', 'External Reference');
  		uimenu(QmatNMR.h669, 'label', 'Apply External Reference', 'callback', 'askeditreference');
  		uimenu(QmatNMR.h669, 'label', 'Define External Reference', 'callback', 'askdefinereference');
  		uimenu(QmatNMR.h669, 'label', 'Import External Reference from disk', 'callback', 'askimportreference');
  	uimenu(QmatNMR.h667, 'label', 'ppm / Hz / kHz', 'callback', 'stats1d', 'separator', 'on');
  	uimenu(QmatNMR.h667, 'label', 'Time', 'callback', 'asktimeaxis1d');
  	uimenu(QmatNMR.h667, 'label', 'Gradient', 'callback', 'askgradientaxis1d');
  	uimenu(QmatNMR.h667, 'label', 'Points', 'callback', 'regelpointsaxis1d');
  	uimenu(QmatNMR.h667, 'label', 'User defined', 'callback', 'askuserdef');
  	uimenu(QmatNMR.h667, 'label', 'Save Current Axis', 'callback', 'asksaveaxis', 'separator', 'on');
  
  %
  %separate items for legend and labels settings
  %
  uimenu(QmatNMR.ContextMain, 'label', '  Title / Axes labels    ', 'callback', 'QmatNMR.command = 0; klabels');
  uimenu(QmatNMR.ContextMain, 'label', '  Legend    ', 'callback', 'QezLegend');
  
  %%%%%
  %%%%%The files menu
  %%%%%
  %%%%QmatNMR.files 	= uimenu(QmatNMR.ContextMain, 'Label', '  Files    ', 'separator', 'on');
  %%%%	QmatNMR.filesImport = uimenu(QmatNMR.files, 'Label', 'Import');
  %%%%		uimenu(QmatNMR.filesImport, 'Label', 'External MATLAB Files', 'callback', 'matlaad', 'accelerator', 'm');
  %%%%		uimenu(QmatNMR.filesImport, 'Label', 'Series of External MATLAB Files', 'callback', 'matlaadSeries');
  %%%%
  %%%%		uimenu(QmatNMR.filesImport, 'Label', 'Binary FID', 'callback', 'fidlaad', 'accelerator', 'f', 'separator', 'on');
  %%%%		uimenu(QmatNMR.filesImport, 'Label', 'Last Binary FID', 'callback', 'askfidlaad', 'accelerator', 'r');
  %%%%		uimenu(QmatNMR.filesImport, 'Label', 'Series of Binary FID''s', 'callback', 'fidlaadSeries');
  %%%%		uimenu(QmatNMR.filesImport, 'Label', 'Last Series of Binary FID''s', 'callback', 'askfidlaadSeries');
  %%%%
  %%%%		uimenu(QmatNMR.filesImport, 'Label', 'Bruker Spectrum', 'callback', 'Brukerlaad', 'separator', 'on');
  %%%%		uimenu(QmatNMR.filesImport, 'Label', 'Last Bruker Spectrum', 'callback', 'askBrukerlaad');
  %%%%		uimenu(QmatNMR.filesImport, 'Label', 'Series of Bruker Spectra', 'callback', 'BrukerlaadSeries');
  %%%%		uimenu(QmatNMR.filesImport, 'Label', 'Last Series of Bruker Spectra', 'callback', 'askBrukerlaadSeries');
  %%%%
  %%%%		uimenu(QmatNMR.filesImport, 'Label', 'SIMPSON ASCII', 'callback', 'simpsonasciilaad', 'separator', 'on');
  %%%%		uimenu(QmatNMR.filesImport, 'Label', 'Last SIMPSON ASCII', 'callback', 'asksimpsonasciilaad');
  %%%%		uimenu(QmatNMR.filesImport, 'Label', 'Series of SIMPSON ASCII', 'callback', 'simpsonasciilaadSeries');
  %%%%		uimenu(QmatNMR.filesImport, 'Label', 'Last Series of SIMPSON ASCII', 'callback', 'asksimpsonasciilaadSeries');
  %%%%
  %%%%	QmatNMR.filesExport = uimenu(QmatNMR.files, 'Label', 'Export');
  %%%%		uimenu(QmatNMR.filesExport, 'Label', 'Save as SIMPSON ASCII', 'callback', 'asksavetoSimpsonASCII');
  %%%%
  %%%%        QmatNMR.SeriesTrickery = uimenu(QmatNMR.files, 'Label', 'Series Trickery', 'separator', 'on');
  %%%%		uimenu(QmatNMR.SeriesTrickery, 'Label', 'Add series of variables', 'callback', 'askaddvariables');
  %%%%		uimenu(QmatNMR.SeriesTrickery, 'Label', 'Concatenate series of variables', 'callback', 'askconcatenatevariables');
  %%%%		uimenu(QmatNMR.SeriesTrickery, 'Label', 'Normalize series of variables', 'callback', 'asknormalizevariables');
  %%%%
  %%%%	uimenu(QmatNMR.files, 'Label', 'Change Directory', 'callback', 'ChangeDir', 'separator', 'on');
  %%%%	uimenu(QmatNMR.files, 'Label', 'Set Search Profile', 'callback', 'SearchProfile');
  %%%%	uimenu(QmatNMR.files, 'label', 'Edit MATLAB Path', 'callback', 'editpath', 'separator', 'on');
  %%%%	uimenu(QmatNMR.files, 'label', 'Edit Workspace', 'callback', 'workspace');
  %%%%	uimenu(QmatNMR.files, 'label', 'Editor/Debugger', 'callback', 'edit');
  %%%%
  %%%%
  %%%%
  %%%%%
  %%%%%Some items for plot manipulations
  %%%%%
  %%%%QmatNMR.h666 = uimenu(QmatNMR.ContextMain, 'label', '  Plot Manipulations    ');
  %%%%	uimenu(QmatNMR.h666, 'label', 'Legend', 'callback', 'QezLegend', 'separator', 'on');
  %%%%	QmatNMR.h667 = uimenu(QmatNMR.h666, 'label', 'Ruler X-axis');
  %%%%		uimenu(QmatNMR.h667, 'label', 'Default', 'callback', 'regelsetdefaultaxis');
  %%%%		QmatNMR.h669 = uimenu(QmatNMR.h667, 'label', 'Change Default');
  %%%%			uimenu(QmatNMR.h669, 'label', 'TD: Time',   'callback', 'QmatNMR.DefaultAxisSwitch = 0; QmatNMR.DefaultAxisType = 1; regelchangedefaultaxis');
  %%%%			uimenu(QmatNMR.h669, 'label', 'TD: Points', 'callback', 'QmatNMR.DefaultAxisSwitch = 0; QmatNMR.DefaultAxisType = 2; regelchangedefaultaxis');
  %%%%			uimenu(QmatNMR.h669, 'label', 'FD: kHz',    'callback', 'QmatNMR.DefaultAxisSwitch = 1; QmatNMR.DefaultAxisType = 1; regelchangedefaultaxis', 'separator', 'on');
  %%%%			uimenu(QmatNMR.h669, 'label', 'FD: Hz',     'callback', 'QmatNMR.DefaultAxisSwitch = 1; QmatNMR.DefaultAxisType = 2; regelchangedefaultaxis');
  %%%%			uimenu(QmatNMR.h669, 'label', 'FD: ppm',    'callback', 'QmatNMR.DefaultAxisSwitch = 1; QmatNMR.DefaultAxisType = 3; regelchangedefaultaxis');
  %%%%			uimenu(QmatNMR.h669, 'label', 'FD: Points', 'callback', 'QmatNMR.DefaultAxisSwitch = 1; QmatNMR.DefaultAxisType = 4; regelchangedefaultaxis');
  %%%%		uimenu(QmatNMR.h667, 'label', 'Import External Reference', 'callback', 'askimportreference');
  %%%%		uimenu(QmatNMR.h667, 'label', 'ppm / Hz / kHz', 'callback', 'stats1d', 'separator', 'on');
  %%%%		uimenu(QmatNMR.h667, 'label', 'Time', 'callback', 'asktimeaxis1d');
  %%%%		uimenu(QmatNMR.h667, 'label', 'Gradient', 'callback', 'askgradientaxis1d');
  %%%%		uimenu(QmatNMR.h667, 'label', 'Points', 'callback', 'regelpointsaxis1d');
  %%%%		uimenu(QmatNMR.h667, 'label', 'User defined', 'callback', 'askuserdef');
  %%%%	uimenu(QmatNMR.h666, 'label', 'Title / Axes labels', 'callback', 'QmatNMR.command = 0; klabels');
  %%%%
  %%%%	QmatNMR.h666Axis = uimenu(QmatNMR.h666, 'label', 'Axis properties');
  %%%%		uimenu(QmatNMR.h666Axis, 'label', 'Axis On/Off/Etc', 'callback', 'askaxis');
  %%%%		uimenu(QmatNMR.h666Axis, 'label', 'Clear Axis', 'callback', 'askclearaxis');	
  %%%%		uimenu(QmatNMR.h666Axis, 'label', 'Axis Colors', 'callback', 'askaxiscolors');	
  %%%%		uimenu(QmatNMR.h666Axis, 'label', 'Axis Directions', 'callback', 'askdirs');	
  %%%%		uimenu(QmatNMR.h666Axis, 'label', 'Axis Labels', 'callback', 'askaxislabels');	
  %%%%		uimenu(QmatNMR.h666Axis, 'label', 'Axis Locations', 'callback', 'askaxislocation');
  %%%%		uimenu(QmatNMR.h666Axis, 'label', 'Axis Position', 'callback', 'askaxisposition');
  %%%% 		uimenu(QmatNMR.h666Axis, 'label', 'Axis View', 'callback', 'findcurrentfigure; askaxisview');
  %%%%		uimenu(QmatNMR.h666Axis, 'label', 'Title', 'callback', 'asktitle');
  %%%%	uimenu(QmatNMR.h666, 'label', 'Box', 'callback', 'askbox');
  %%%%	uimenu(QmatNMR.h666, 'label', 'Font properties', 'callback', 'askfont');
  %%%%	uimenu(QmatNMR.h666, 'label', 'Grid', 'callback', 'askgrid');
  %%%%	uimenu(QmatNMR.h666, 'label', 'Hold', 'callback', 'askhold');
  %%%%	QmatNMR.h666Line = uimenu(QmatNMR.h666, 'label', 'Line properties');
  %%%%		QmatNMR.opt109= uimenu(QmatNMR.h666Line, 'label', 'LineStyle');
  %%%%			uimenu(QmatNMR.opt109,'label', '-', 'callback', 'Linestyle(''-''); disp(''Linestyle set to solid'');');
  %%%%			uimenu(QmatNMR.opt109,'label', '--', 'callback', 'Linestyle(''--''); disp(''Linestyle set to dashed'');');
  %%%%			uimenu(QmatNMR.opt109,'label', ':', 'callback', 'Linestyle('':''); disp(''Linestyle set to dotted'');');
  %%%%			uimenu(QmatNMR.opt109,'label', '-.', 'callback', 'Linestyle(''-.''); disp(''Linestyle set to dash-dot'');');
  %%%%			uimenu(QmatNMR.opt109,'label', 'None', 'callback', 'Linestyle(''none''); disp(''Linestyle set to none'');');
  %%%%		QmatNMR.opt93 = uimenu(QmatNMR.h666Line, 'label', 'LineWidth');
  %%%%			uimenu(QmatNMR.opt93, 'label', '0.05', 'callback', 'Linewidth(0.05); disp(''Linewidth set to 0.05'');');	
  %%%%			uimenu(QmatNMR.opt93, 'label', '0.10', 'callback', 'Linewidth(0.1); disp(''Linewidth set to 0.10'');');	
  %%%%			uimenu(QmatNMR.opt93, 'label', '0.15', 'callback', 'Linewidth(0.15); disp(''Linewidth set to 0.15'');');	
  %%%%			uimenu(QmatNMR.opt93, 'label', '0.25', 'callback', 'Linewidth(0.25); disp(''Linewidth set to 0.25'');');	
  %%%%			uimenu(QmatNMR.opt93, 'label', '0.5', 'callback', 'Linewidth(0.5); disp(''Linewidth set to 0.5'');');	
  %%%%			uimenu(QmatNMR.opt93, 'label', '1.0', 'callback', 'Linewidth(1.0); disp(''Linewidth set to 1.0'');');	
  %%%%			uimenu(QmatNMR.opt93, 'label', '1.5', 'callback', 'Linewidth(1.5); disp(''Linewidth set to 1.5'');');	
  %%%%			uimenu(QmatNMR.opt93, 'label', '2.0', 'callback', 'Linewidth(2.0); disp(''Linewidth set to 2.0'');');	
  %%%%			uimenu(QmatNMR.opt93, 'label', '3.0', 'callback', 'Linewidth(3.0); disp(''Linewidth set to 3.0'');');	
  %%%%			uimenu(QmatNMR.opt93, 'label', '4.0', 'callback', 'Linewidth(4.0); disp(''Linewidth set to 4.0'');');	
  %%%%			uimenu(QmatNMR.opt93, 'label', '5.0', 'callback', 'Linewidth(5.0); disp(''Linewidth set to 5.0'');');	
  %%%%			uimenu(QmatNMR.opt93, 'label', '6.0', 'callback', 'Linewidth(6.0); disp(''Linewidth set to 6.0'');');	
  %%%%			uimenu(QmatNMR.opt93, 'label', '7.0', 'callback', 'Linewidth(7.0); disp(''Linewidth set to 7.0'');');	
  %%%%			uimenu(QmatNMR.opt93, 'label', '8.0', 'callback', 'Linewidth(8.0); disp(''Linewidth set to 8.0'');');	
  %%%%			uimenu(QmatNMR.opt93, 'label', '9.0', 'callback', 'Linewidth(9.0); disp(''Linewidth set to 9.0'');');	
  %%%%			uimenu(QmatNMR.opt93, 'label', '10.0', 'callback', 'Linewidth(10.0); disp(''Linewidth set to 10.0'');');	
  %%%%		QmatNMR.opt110= uimenu(QmatNMR.h666Line, 'label', 'Marker');
  %%%%			uimenu(QmatNMR.opt110,'label', 'None', 'callback', 'Marker(''none''); disp(''Marker set to none'');');
  %%%%			uimenu(QmatNMR.opt110,'label', 'Point', 'callback', 'Marker(''.''); disp(''Marker set to point'');');
  %%%%			uimenu(QmatNMR.opt110,'label', 'Plus', 'callback', 'Marker(''+''); disp(''Marker set to plus'');');
  %%%%			uimenu(QmatNMR.opt110,'label', 'Circle', 'callback', 'Marker(''o''); disp(''Marker set to circle'');');
  %%%%			uimenu(QmatNMR.opt110,'label', 'Asterisk', 'callback', 'Marker(''*''); disp(''Marker set to asterisk'');');
  %%%%			uimenu(QmatNMR.opt110,'label', 'Cross', 'callback', 'Marker(''x''); disp(''Marker set to cross'');');
  %%%%			uimenu(QmatNMR.opt110,'label', 'Square', 'callback', 'Marker(''s''); disp(''Marker set to square'');');
  %%%%			uimenu(QmatNMR.opt110,'label', 'Diamond', 'callback', 'Marker(''d''); disp(''Marker set to triangle diamond'');');
  %%%%			uimenu(QmatNMR.opt110,'label', 'Triangle up', 'callback', 'Marker(''^''); disp(''Marker set to triangle up'');');
  %%%%			uimenu(QmatNMR.opt110,'label', 'Triangle down', 'callback', 'Marker(''v''); disp(''Marker set to triangle down'');');
  %%%%			uimenu(QmatNMR.opt110,'label', 'Triangle right', 'callback', 'Marker(''>''); disp(''Marker set to triangle right'');');
  %%%%			uimenu(QmatNMR.opt110,'label', 'Triangle left', 'callback', 'Marker(''<''); disp(''Marker set to triangle left'');');
  %%%%			uimenu(QmatNMR.opt110,'label', 'Pentagram', 'callback', 'Marker(''p''); disp(''Marker set to pentagram'');');
  %%%%			uimenu(QmatNMR.opt110,'label', 'Hexagram', 'callback', 'Marker(''h''); disp(''Marker set to hexagram'');');
  %%%%		QmatNMR.opt111= uimenu(QmatNMR.h666Line, 'label', 'Marker Size');
  %%%%			uimenu(QmatNMR.opt111, 'label', '0.5', 'callback', 'Markersize(0.5); disp(''Marker Size set to 0.5'');');	
  %%%%			uimenu(QmatNMR.opt111, 'label', '1.0', 'callback', 'Markersize(1.0); disp(''Marker Size set to 1.0'');');	
  %%%%			uimenu(QmatNMR.opt111, 'label', '1.5', 'callback', 'Markersize(1.5); disp(''Marker Size set to 1.5'');');	
  %%%%			uimenu(QmatNMR.opt111, 'label', '2.0', 'callback', 'Markersize(2.0); disp(''Marker Size set to 2.0'');');	
  %%%%			uimenu(QmatNMR.opt111, 'label', '3.0', 'callback', 'Markersize(3.0); disp(''Marker Size set to 3.0'');');	
  %%%%			uimenu(QmatNMR.opt111, 'label', '4.0', 'callback', 'Markersize(4.0); disp(''Marker Size set to 4.0'');');	
  %%%%			uimenu(QmatNMR.opt111, 'label', '5.0', 'callback', 'Markersize(5.0); disp(''Marker Size set to 5.0'');');	
  %%%%			uimenu(QmatNMR.opt111, 'label', '6.0', 'callback', 'Markersize(6.0); disp(''Marker Size set to 6.0'');');	
  %%%%			uimenu(QmatNMR.opt111, 'label', '7.0', 'callback', 'Markersize(7.0); disp(''Marker Size set to 7.0'');');	
  %%%%			uimenu(QmatNMR.opt111, 'label', '8.0', 'callback', 'Markersize(8.0); disp(''Marker Size set to 8.0'');');	
  %%%%			uimenu(QmatNMR.opt111, 'label', '9.0', 'callback', 'Markersize(9.0); disp(''Marker Size set to 9.0'');');	
  %%%%			uimenu(QmatNMR.opt111, 'label', '10.0', 'callback', 'Markersize(10.0); disp(''Marker Size set to 10.0'');');	
  %%%%	uimenu(QmatNMR.h666, 'label', 'Scaling Limits', 'callback', 'asklims');
  %%%%	uimenu(QmatNMR.h666, 'label', 'Scaling Types', 'callback', 'askscales');
  %%%%	uimenu(QmatNMR.h666, 'label', 'Shading', 'callback', 'askshading');
  %%%%	QmatNMR.h666Tick = uimenu(QmatNMR.h666, 'label', 'Tick properties');
  %%%%		uimenu(QmatNMR.h666Tick, 'label', 'Tick direction', 'callback', 'asktickdir');
  %%%%		uimenu(QmatNMR.h666Tick, 'label', 'Tick Labels', 'callback', 'askticklabel');
  %%%%		uimenu(QmatNMR.h666Tick, 'label', 'Tick Lengths', 'callback', 'askticklengths');
  %%%%		uimenu(QmatNMR.h666Tick, 'label', 'Tick Positions', 'callback', 'asktick');
  %%%%
  %%%%
  %%%%%
  %%%%%Some items for history and macro-related stuff
  %%%%%
  %%%%QmatNMR.h83 = uimenu(QmatNMR.ContextMain, 'Label', '  History / Macro    ');
  %%%%	uimenu(QmatNMR.h83, 'label', 'Show History', 'callback', 'matnmrhelp(QmatNMR.History, ''QmatNMR.History'');');
  %%%%	uimenu(QmatNMR.h83, 'label', 'Connect History to FID', 'callback', 'askconnecttoFID');
  %%%%	uimenu(QmatNMR.h83, 'label', 'Save History macro in workspace', 'callback', 'asksaveasmacro');
  %%%%	uimenu(QmatNMR.h83, 'label', 'Reprocess from History', 'callback', 'QmatNMR.StepWise = 0; reprocessHistory');
  %%%%	uimenu(QmatNMR.h83, 'label', 'Reprocess stepwise from History', 'callback', 'QmatNMR.StepWise = 1; reprocessHistory');
  %%%%	uimenu(QmatNMR.h83, 'label', 'Clear History', 'callback', 'clearHistory');
  %%%%	uimenu(QmatNMR.h83, 'label', 'Start Recording Macro', 'callback', 'askstartrecordingmacro', 'separator', 'on');
  %%%%	uimenu(QmatNMR.h83, 'label', 'Stop Recording Macro', 'callback', 'askstoprecordingmacro');
  %%%%	uimenu(QmatNMR.h83, 'label', 'Execute User Command', 'callback', 'askusercommand', 'accelerator', 'u');
  %%%%	uimenu(QmatNMR.h83, 'label', 'Execute Macro', 'callback', 'QmatNMR.StepWise = 0; askexecutemacro', 'accelerator', 'e');
  %%%%	uimenu(QmatNMR.h83, 'label', 'Execute Macro Stepwise', 'callback', 'QmatNMR.StepWise = 1; askexecutemacro');
  %%%%
  %%%%%
  %%%%%The printing menu
  %%%%%
  %%%%QmatNMR.prt = uimenu(QmatNMR.ContextMain, 'Label', '  Printing Menu    ', 'callback', 'figure(QmatNMR.Fig); matprint;');
  %%%%	
  %%%%
  %%%%%
  %%%%%The goodies menu
  %%%%%
  %%%%QmatNMR.clear = uimenu(QmatNMR.ContextMain, 'Label', '  Goodies    ');
  %%%%	uimenu(QmatNMR.clear, 'Label', 'Undo', 'callback', 'doUnDo', 'accelerator', 'z');
  %%%%	uimenu(QmatNMR.clear, 'Label', 'Clear Functions', 'callback', 'QmatNMR.SwitchTo1D = 0; QmatNMR.SingleSlice = 0; clear functions; disp(''Clear Functions performed ...''); Arrowhead');
  %%%%	uimenu(QmatNMR.clear, 'Label', 'Reset after error', 'callback', 'ResetAfterError');
  %%%%	uimenu(QmatNMR.clear, 'Label', 'Select matNMR distribution', 'callback', 'selectdistribution');
  
  
  
  
  %=====================================================================================================
  %=====================================================================================================
  %=====================================================================================================
  
  
  
  %
  %Correct the window if the screensize is too small for the original size of the window and buttons
  %
  if ((QmatNMR.ComputerScreenSize(3) < QmatNMRsettings.figDefaultWidth) | (QmatNMR.ComputerScreenSize(4) < QmatNMRsettings.figDefaultHeight))
    QmatNMR.ChangeFrom = [1 1 QmatNMRsettings.figDefaultWidth QmatNMRsettings.figDefaultHeight];
    QTEMP1 = QmatNMR.Fig;		%define the window handle
    CorrectWindow
  end  
  
  %
  %make all items normalized
  %
  QmatNMR.unittext      = 'normalized';
  QmatNMR.figLeft       = QmatNMR.figLeftNorm;
  QmatNMR.figBottom     = QmatNMR.figBottomNorm;
  QmatNMR.figWidth      = QmatNMR.figWidthNorm;
  QmatNMR.figHeight     = QmatNMR.figHeightNorm;
  
  %
  %First QmatNMR.SET all uicontrols to the right units
  %
  QmatNMR.SETbuttons = findobj(allchild(QmatNMR.Fig), 'type', 'uicontrol');
  set(QmatNMR.SETbuttons, 'units', QmatNMR.unittext);
  
  set(QmatNMR.Fig, 'units', QmatNMR.unittext);
  
  %
  %if window must be resizeable
  %
  if (QmatNMR.unittype == 1)
    set(QmatNMR.Fig, 'resize', 'on');
  else
    set(QmatNMR.Fig, 'resize', 'off');
  end
  
  set(QmatNMR.Fig, 'Position', [QmatNMR.figLeft QmatNMR.figBottom QmatNMR.figWidth QmatNMR.figHeight], 'visible', 'on');
  drawnow
  set(QmatNMR.Fig, 'Position', [QmatNMR.figLeft QmatNMR.figBottom QmatNMR.figWidth QmatNMR.figHeight]);
  drawnow
  
  PutScreenRight
  
  
  %switch on zoom by default
  set(QmatNMR.h41, 'Value', 1);
  ZoomMatNMR MainWindow on
  
  
  
  disp([QmatNMR.VersionVar ' succesfully initiated ...']);
  
  clear QTEMP* QSETteller

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
