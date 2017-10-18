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
%view2d deals with changes of the 3D index in the main window. It stores the current 2D
%in the assigned 3D matrix (if any) and loads the next 2D into the main window.
%07-07-'04

try
  %
  %check if the current 2D needs to be stored in the 3D
  %
  QmatNMR.Q3DNoStore = 0;
  if ~(isempty(QmatNMR.Q3DOutput))
    %
    %check if the size of the output variable has been defined already
    %
    if (isstruct(eval(QmatNMR.Q3DOutput)))	%do we store the 3D as a matNMR structure?
      eval(['QTEMP2 = ndims(' QmatNMR.Q3DOutput '.Spectrum);']);
      if (QTEMP2 ~= 3)	%not yet defined
        if (QmatNMR.Dim == 0) 	%current mode is 1D
          eval([QmatNMR.Q3DOutput '.Spectrum = zeros(QmatNMR.Size3D, 1, QmatNMR.Size1D);']);
          QmatNMR.Q3DSizeOut1 = QmatNMR.Size1D;
          QmatNMR.Q3DSizeOut2 = 1;
          QmatNMR.Q3DSizeOut3 = QmatNMR.Size3D;
          disp(['Defining size of 3D output matrix as (' num2str(QmatNMR.Size3D) ' x 1 x ' num2str(QmatNMR.SizeTD2) ')'])
  
        else
          %
  	%in case of a 2D mode we must make sure that the current 2D is not equal to the
  	%original FID/spectrum before processing
  	%
          if isequal(QmatNMR.Spec2D, squeeze(eval(QmatNMR.SpecNameProc)))
  	  disp('matNMR NOTICE: Not storing data in 3D as no processing seems to have been done!')
            QmatNMR.Q3DNoStore = 1;
  
  	else
            eval([QmatNMR.Q3DOutput '.Spectrum = zeros(QmatNMR.Size3D, QmatNMR.SizeTD1, QmatNMR.SizeTD2);']);
            QmatNMR.Q3DSizeOut1 = QmatNMR.SizeTD2;
            QmatNMR.Q3DSizeOut2 = QmatNMR.SizeTD1;
            QmatNMR.Q3DSizeOut3 = QmatNMR.Size3D;
            disp(['Defining size of 3D output matrix as (' num2str(QmatNMR.Size3D) ' x ' num2str(QmatNMR.SizeTD1) ' x ' num2str(QmatNMR.SizeTD2) ')'])
  	end
        end
      
      else	%the output matrix has been defined but now we need to check whether
      		%its size is the same as that of the spectrum we might want to put into
  		%it just afterwards
        if ((QmatNMR.Dim == 0) & (~isequal([QmatNMR.Size3D, 1, QmatNMR.Size1D], [QmatNMR.Q3DSizeOut3, 1, QmatNMR.Q3DSizeOut1]))) | ((QmatNMR.Dim ~= 0) & (~isequal([QmatNMR.Size3D, QmatNMR.SizeTD1, QmatNMR.SizeTD2], [QmatNMR.Q3DSizeOut3, QmatNMR.Q3DSizeOut2, QmatNMR.Q3DSizeOut1])))
          %
  	%sizes are not the same so we don't store the data.
  	%
          disp('matNMR NOTICE: Not storing data in 3D as matrix sizes are not equal!')
  	QmatNMR.Q3DNoStore = 1;
  
        else	
  	%
  	%So the sizes are the same.
  	%to avoid the implicit assumption that the spectrum after processing must be different
  	%from the one before processing, we make sure the current spectrum isn't equal to the
  	%original FID/spectrum
  	%
  	%in case we're in 1D mode then this must always be true as the 3D must be a 
  	%series of 2D's or else it will be loaded as a 2D!
  	%
  	if (QmatNMR.Dim)
  	  if isequal(QmatNMR.Spec2D, squeeze(eval(QmatNMR.SpecNameProc)))
  	    disp('matNMR NOTICE: Not storing data in 3D as no processing seems to have been done!')
  	    QmatNMR.Q3DNoStore = 1;
  	  end
  	end
        end
      end
  
    else		%NO matNMR structure for output
      eval(['QTEMP2 = ndims(' QmatNMR.Q3DOutput ');']);
      if (QTEMP2 ~= 3)	%not yet defined
        if (QmatNMR.Dim == 0) 	%current mode is 1D
          eval([QmatNMR.Q3DOutput ' = zeros(QmatNMR.Size3D, 1, QmatNMR.Size1D);']);
          QmatNMR.Q3DSizeOut1 = QmatNMR.Size1D;
          QmatNMR.Q3DSizeOut2 = 1;
          QmatNMR.Q3DSizeOut3 = QmatNMR.Size3D;
          disp(['Defining size of 3D output matrix as (' num2str(QmatNMR.Size3D) ' x 1 x ' num2str(QmatNMR.SizeTD2) ')'])
  
        else
          %
  	%in case of a 2D mode we must make sure that the current 2D is not equal to the
  	%original FID/spectrum before processing
  	%
          if isequal(QmatNMR.Spec2D, squeeze(eval(QmatNMR.SpecNameProc)))
  	  disp('matNMR NOTICE: Not storing data in 3D as no processing seems to have been done!')
            QmatNMR.Q3DNoStore = 1;
  
  	else
            eval([QmatNMR.Q3DOutput ' = zeros(QmatNMR.Size3D, QmatNMR.SizeTD1, QmatNMR.SizeTD2);']);
            QmatNMR.Q3DSizeOut1 = QmatNMR.SizeTD2;
            QmatNMR.Q3DSizeOut2 = QmatNMR.SizeTD1;
            QmatNMR.Q3DSizeOut3 = QmatNMR.Size3D;
            disp(['Defining size of 3D output matrix as (' num2str(QmatNMR.Size3D) ' x ' num2str(QmatNMR.SizeTD1) ' x ' num2str(QmatNMR.SizeTD2) ')'])
  	end
        end
      
      else	%the output matrix has been defined but now we need to check whether
      		%its size is the same as that of the spectrum we might want to put into
  		%it just afterwards
        if ((QmatNMR.Dim == 0) & (~isequal([QmatNMR.Size3D, 1, QmatNMR.Size1D], [QmatNMR.Q3DSizeOut3, 1, QmatNMR.Q3DSizeOut1]))) | ((QmatNMR.Dim ~= 0) & (~isequal([QmatNMR.Size3D, QmatNMR.SizeTD1, QmatNMR.SizeTD2], [QmatNMR.Q3DSizeOut3, QmatNMR.Q3DSizeOut2, QmatNMR.Q3DSizeOut1])))
          %
  	%sizes are not the same so we don't store the data.
  	%
          disp('matNMR NOTICE: Not storing data in 3D as matrix sizes are not equal!')
  	QmatNMR.Q3DNoStore = 1;
  
        else	
  	%
  	%So the sizes are the same.
  	%to avoid the implicit assumption that the spectrum after processing must be different
  	%from the one before processing, we make sure the current spectrum isn't equal to the
  	%original FID/spectrum
  	%
  	%in case we're in 1D mode then this must always be true as the 3D must be a 
  	%series of 2D's or else it will be loaded as a 2D!
  	%
  	if (QmatNMR.Dim)
  	  if isequal(QmatNMR.Spec2D, squeeze(eval(QmatNMR.SpecNameProc)))
  	    disp('matNMR NOTICE: Not storing data in 3D as no processing seems to have been done!')
  	    QmatNMR.Q3DNoStore = 1;
  	  end
  	end
        end
      end
    end
  
  
    %
    %Store the current 2D in the 3D, unless the corresponding flag says otherwise
    %
    if ~QmatNMR.Q3DNoStore
      if (isstruct(eval(QmatNMR.Q3DOutput)))	%do we store the 3D as a matNMR structure?
        if (QmatNMR.Dim == 0) 		%1D mode
          eval([QmatNMR.Q3DOutput '.Spectrum(QmatNMR.Q3DIndex, :, :) = QmatNMR.Spec1D;']);
          eval([QmatNMR.Q3DOutput '.AxisTD2 = QmatNMR.Axis1D;']);
          eval([QmatNMR.Q3DOutput '.SweepWidthTD2 = QmatNMR.SW1D;']);
          eval([QmatNMR.Q3DOutput '.SpectralFrequencyTD2 = QmatNMR.SF1D;']);
          eval([QmatNMR.Q3DOutput '.FIDstatusTD2 = QmatNMR.FIDstatus;']);
          eval([QmatNMR.Q3DOutput '.GammaTD2 = QmatNMR.gamma1d;']);
          eval([QmatNMR.Q3DOutput '.History = QmatNMR.History;']);
          eval([QmatNMR.Q3DOutput '.HistoryMacro = QmatNMR.HistoryMacro;']);
    
        else
          eval([QmatNMR.Q3DOutput '.Spectrum(QmatNMR.Q3DIndex, :, :) = QmatNMR.Spec2D;']);
          eval([QmatNMR.Q3DOutput '.AxisTD2 = QmatNMR.AxisTD2;']);
          eval([QmatNMR.Q3DOutput '.AxisTD1 = QmatNMR.AxisTD1;']);
          eval([QmatNMR.Q3DOutput '.SweepWidthTD2 = QmatNMR.SWTD2;']);
          eval([QmatNMR.Q3DOutput '.SweepWidthTD1 = QmatNMR.SWTD1;']);
          eval([QmatNMR.Q3DOutput '.SpectralFrequencyTD2 = QmatNMR.SFTD2;']);
          eval([QmatNMR.Q3DOutput '.SpectralFrequencyTD1 = QmatNMR.SFTD1;']);
          eval([QmatNMR.Q3DOutput '.FIDstatusTD2 = QmatNMR.FIDstatus2D1;']);
          eval([QmatNMR.Q3DOutput '.FIDstatusTD1 = QmatNMR.FIDstatus2D2;']);
          eval([QmatNMR.Q3DOutput '.GammaTD2 = QmatNMR.gamma1;']);
          eval([QmatNMR.Q3DOutput '.GammaTD1 = QmatNMR.gamma2;']);
          eval([QmatNMR.Q3DOutput '.History = QmatNMR.History;']);
          eval([QmatNMR.Q3DOutput '.HistoryMacro = QmatNMR.HistoryMacro;']);
        end
    
      else		%do NOT store as matNMR structure
        if (QmatNMR.Dim == 0) 		%1D mode
          eval([QmatNMR.Q3DOutput '(QmatNMR.Q3DIndex, :, :) = QmatNMR.Spec1D;']);
    
        else
          eval([QmatNMR.Q3DOutput '(QmatNMR.Q3DIndex, :, :) = QmatNMR.Spec2D;']);
        end
      end
  
      disp(['Storing data in 3D for spectrum number ' num2str(QmatNMR.Q3DIndex)])
    end
  end
  
  
  %
  %now increment or decrement the index counter
  %
  if ((QmatNMR.Q3DNewIndex > 0) & (QmatNMR.Q3DNewIndex <= QmatNMR.Size3D))
    QmatNMR.Q3DIndex = QmatNMR.Q3DNewIndex;
    set(QmatNMR.but3D7, 'string', QmatNMR.Q3DIndex);
  
  
    %
    %make the main window the current one by pulling it forward
    %
    Arrowhead
    if (~QmatNMR.BusyWithMacro3D)
      figure(QmatNMR.Fig)
    end
    
    
    %
    %now read in the current 2D by using the index for the 3D
    %
    if (QmatNMR.Q3DLastType == 1) 	%we should read from the output variable
      if ~isempty(QmatNMR.Q3DOutput)
        QmatNMR.Spec1DName = [QmatNMR.Q3DOutput '(' num2str(QmatNMR.Q3DIndex) ', :, :)'];
      else
  
        QmatNMR.Spec1DName = [QmatNMR.Q3DInput '(' num2str(QmatNMR.Q3DIndex) ', :, :)'];
      end
    else
  
      QmatNMR.Spec1DName = [QmatNMR.Q3DInput '(' num2str(QmatNMR.Q3DIndex) ', :, :)'];
    end
    [QmatNMR.Spec1DName, QmatNMR.CheckInput] = checkinput(QmatNMR.Spec1DName);%adjust the format of the input expression for later use
    
    try
      QmatNMR.FIDstatus2D1 = 2;		%new spectrum is an FID
      QmatNMR.FIDstatus2D2 = 2;		%new spectrum is an FID
      makenew2D
  
    catch
    end
  
  else
    %
    %in case the index number is out of bounds we update the UI control
    %
    set(QmatNMR.but3D7, 'string', QmatNMR.Q3DIndex);
  
  
    %
    %make the main window the current one by pulling it forward
    %
    Arrowhead
    if (~QmatNMR.BusyWithMacro3D)
      figure(QmatNMR.Fig)
    end
    
    
    %
    %now read in the current 2D by using the index for the 3D
    %
    if (QmatNMR.Q3DLastType == 1) 	%we should read from the output variable
      if ~isempty(QmatNMR.Q3DOutput)
        QmatNMR.Spec1DName = [QmatNMR.Q3DOutput '(' num2str(QmatNMR.Q3DIndex) ', :, :)'];
      else
  
        QmatNMR.Spec1DName = [QmatNMR.Q3DInput '(' num2str(QmatNMR.Q3DIndex) ', :, :)'];
      end
    else
      QmatNMR.Spec1DName = [QmatNMR.Q3DInput '(' num2str(QmatNMR.Q3DIndex) ', :, :)'];
    end
    [QmatNMR.Spec1DName, QmatNMR.CheckInput] = checkinput(QmatNMR.Spec1DName);%adjust the format of the input expression for later use
    QmatNMR.FIDstatus2D1 = 2;		%new spectrum is an FID
    QmatNMR.FIDstatus2D2 = 2;		%new spectrum is an FID
    makenew2D
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
