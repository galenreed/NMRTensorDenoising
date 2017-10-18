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
%checkinput2d.m is used to check user input. Any expression which should result in a valid matrix
%can be checked with this script such that matNMR handles them properly ...
%--> the expression is checked for its variables: if they are structures the var.Spectrum will be
%evaluated
%
%02-06-'98

try
  QmatNMR.numbvars = 0;
  QmatNMR.numbstructs = 0;
  QmatNMR.ReadHypercomplex = 1;
  QmatNMR.StructureVar = '';
  
  for QTEMP40 = length(QmatNMR.CheckInput):-1:2
    QTEMP2 = deblank(fliplr(deblank(fliplr(QmatNMR.SpecNameProc((QmatNMR.CheckInput(QTEMP40-1)+1):(QmatNMR.CheckInput(QTEMP40)-1))))));
  
    %
    %check the expression for existing variables
    %
    %This piece checks whether the string QTEMP2 is a variable in the workspace. If this is not so then it performs a second
    %check to see whether the string is in fact an element of a structure (or series of structures). The result is stored in the
    %flag variable QTEMP41
    %
    QTEMP41 = 0;
    if (exist(QTEMP2, 'var'))
      QTEMP41 = 1;
  
    else
      QTEMP42 = findstr(QTEMP2, '.');	%if this is an element of a structure then a '.' must be present at least once
      if isempty(QTEMP42) 						%the string QTEMP2 does not point to a field into a structure
        QTEMP41 = 0;
  
      else
        QTEMP42 = sort([0 QTEMP42 length(QTEMP2)+1]); 			%the positions of '.' in the string QTEMP2
  
        QTEMP44 = QTEMP2( (QTEMP42(1)+1):(QTEMP42(2)-1) ); 		%this should be the name of the structure in the workspace
        try
          QTEMP46 = eval(QTEMP44);
        catch
          beep
          disp('matNMR WARNING: specified input did not produce correct output. Please recheck ...');
          QmatNMR.BREAK = 1;
          return
        end
  
        if (isa(QTEMP46, 'struct'))
          for QTEMP43 = 2:(length(QTEMP42)-1)
            QTEMP45 = QTEMP2( (QTEMP42(QTEMP43)+1):(QTEMP42(QTEMP43+1)-1) );
            if ~isfield(QTEMP46, QTEMP45) 				%there is no field in the structure by this name (error follows later)
              QTEMP41 = 0;
              break
            else 								%so far so good, this field exists in the structure
  
              QTEMP41 = 1;
            end
  
            QTEMP44 = [QTEMP44 '.' QTEMP45]; 				%this should be the name of the structure embedded in a structure
            try
              QTEMP46 = eval(QTEMP44);
            catch
              beep
              disp('matNMR WARNING: specified input did not produce correct output. Please recheck ...');
              QmatNMR.BREAK = 1;
              return
            end
          end
        else 								%there is no structure in the workspace by this name (error follows later)
  
          QTEMP41 = 0;
        end
      end
    end
  
  
    %
    %if the string is a variable then we check it out
    %
    if (QTEMP41)
      QmatNMR.numbvars = QmatNMR.numbvars + 1;
    				%check whether the variable is a structure
      if (isa(eval(QTEMP2), 'struct'))
        QmatNMR.numbstructs = QmatNMR.numbstructs + 1;
  
    
  				%alter the string such that the spectrum is read from the structure
        QmatNMR.SpecNameProc = [QmatNMR.SpecNameProc(1:(QmatNMR.CheckInput(QTEMP40)-1)) '.Spectrum' QmatNMR.SpecNameProc((QmatNMR.CheckInput(QTEMP40)):length(QmatNMR.SpecNameProc))];
  
  	
        %
        %This variable holds the last real variable, that was also a structure.
        %Previously QTEMP2 was used directly whenever there was only one variable
        %in the name of the spectrum, and this was also a structure.
        %Then the axis and other parameters could be read from there.
        %The problem with this is that it is possible to have only one variable
        %and only one structure, whilst still changing QTEMP2: if you multiply
        %a number with a variable, e.g. "1.36*fidvar". Then QTEMP2 will change
        %because of the number.
        %QmatNMR.StructureVar will only be set if QTEMP2 points to a variable structure
        %
        QmatNMR.StructureVar = QTEMP2;
  
        if (ndims(eval([QTEMP2 '.Spectrum'])) == ndims(eval([QTEMP2 '.Hypercomplex'])))
          if ~ (size(eval([QTEMP2 '.Spectrum'])) == size(eval([QTEMP2 '.Hypercomplex'])))
            QmatNMR.ReadHypercomplex = 0;
          end
  
        else		%the dimensions of the matrices are not the same. This should only be
        			%because the spectrum is a 3D. In which case there is no hypercomplex part.
          QmatNMR.ReadHypercomplex = 0;
        end
  
  				%read in the History only for the first structure found in the name
        if strcmp(QmatNMR.History, '')
          QmatNMR.History = eval([QTEMP2 '.History']);
  	
  	if ExistField(eval(QTEMP2), 'HistoryMacro')
  	  QmatNMR.ExecutingMacro = eval([QTEMP2 '.HistoryMacro']);
  	  QmatNMR.ExecutingMacro = CorrectMacro(QmatNMR.ExecutingMacro, QmatNMR.MacroLength);
  	  
  	  QTEMP9 = size(QmatNMR.History);	%A structure that contains a variable without any processing is of length 5
  	  if (QTEMP9(1) > 5)
  	    QmatNMR.HistoryMacro = QmatNMR.ExecutingMacro;
  	  end  
  	end
        end
  
  				%read in the peak list only for the first structure (with peak list) found in the name
        if ~isempty(QmatNMR.PeakListNums)
          QmatNMR.PeakListNums = eval([QTEMP2 '.PeakListNums']);
          QmatNMR.PeakListText = eval([QTEMP2 '.PeakListText']);
        end
      end
    
    				%in case a m-file is called, make sure it is counted as a variable 
    elseif (exist(QTEMP2, 'file') == 2)
      QmatNMR.numbvars = QmatNMR.numbvars + 1;
    end
  end    
  
  
  %
  %this is the spectrum that is obtained from the input string
  %
  try
    QmatNMR.NewSpec = squeeze(eval(QmatNMR.SpecNameProc));
  catch
    beep
    disp('matNMR WARNING: specified input did not produce correct output. Please recheck ...');
    QmatNMR.BREAK = 1;
    return
  end
  
  
  
  %
  %check the size of the spectrum (no 1D and nD (n>2) allowed!!!)
  %
  QTEMP24 = 0;	%flag needed in case a 3D matrix is read that evaluates into a 2D after the squeeze
  if (ndims(QmatNMR.NewSpec) > 2)
    if (ndims(QmatNMR.NewSpec) == 3) 	%opening 3D dataset
      disp('matNMR NOTICE: variable is a 3D matrix and will be loaded as such!');
      
      QmatNMR.NewSpec = 0;
  
      %prepare input variables such that the regelnaam.m routine can be called
      QmatNMR.ask = 3;		    %3D variable
      regelnaam
      QmatNMR.BREAK = 1;
      return
  
    else
      disp('matNMR WARNING: input matrix has more than 3 dimensions!');
      disp('matNMR WARNING: loading of 2D FID/spectrum aborted.');
      QmatNMR.BREAK = 1;
      return
    end
  
  else
    [QmatNMR.NewSizeTD1 QmatNMR.NewSizeTD2] = size(QmatNMR.NewSpec);
    if (QmatNMR.NewSizeTD1 == 1) | (QmatNMR.NewSizeTD2 == 1)	%detect 1D data
      disp('matNMR NOTICE: variable is a 1D matrix and will be loaded as such!');
      
      QmatNMR.NewSpec = 0;
      %prepare input variables such that the regelnaam.m routine can be called
      QmatNMR.LastVar = 1;  	%reset the variable that denotes what type the last-read variable is
      QmatNMR.ask = 1;	      	%1D variable
      regelnaam
      QmatNMR.BREAK = 1;
      return
      
    else 				%normal 2D
      QmatNMR.Spec2D = QmatNMR.NewSpec;
      QmatNMR.SizeTD2 = QmatNMR.NewSizeTD2;
      QmatNMR.SizeTD1 = QmatNMR.NewSizeTD1;
      QmatNMR.NewSpec = 0;
    end
    
    if ((QmatNMR.numbvars == 1) & (QmatNMR.numbstructs == 1) & (ndims(eval([QTEMP2 '.Spectrum'])) == 3))	%is this a 3D matrix with indices to make it a 2D after the squeeze?
      %
      %Then we must take care of which axes we read in from the structure
      %First we set a flag to denote this particular issue
      QTEMP24 = 1;
      
      %
      %Then we must find out which dimensions are indexed into
      %
      QTEMP25 = size(eval(QmatNMR.SpecNameProc));
      
      if (QTEMP25(1) == 1)
      %case 1: TD2 and TD1          		Solution: read normal axes and clear the flag
        QTEMP24 = 0;
      
      else
      %case 2: TD2 and 3rd dimension 		Solution: for now we don't implement this scenario and all information in the structure is lost
      %case 3: TD1 and 3rd dimension 		Solution: for now we don't implement this scenario and all information in the structure is lost
        disp('matNMR NOTICE: Indexing into a 3rd dimension is not really implemented and hence all spectral information is lost.');
        disp('matNMR NOTICE: This feature has deliberately not been implemented. Please ask for support if you really need it!');
      end    
    end
  end
  
  
  %
  %check that the norm of the spectrum is not very small as this is problematic in Matlab
  %
  if ~sum(sum(isnan(QmatNMR.Spec2D)))
    try
      %we only test the norm if the matrix is finite, because otherwise the norm routine complains
      if (norm(QmatNMR.Spec2D(1:ceil(QmatNMR.SizeTD1/128):QmatNMR.SizeTD1, 1:ceil(QmatNMR.SizeTD2/128):QmatNMR.SizeTD2)) < eps^2)
        beep
        disp('matNMR WARNING');
        disp('matNMR WARNING: the spectrum appears to have a very small norm, which may be a cause of problems in Matlab!');
        disp('matNMR WARNING');
      end
    catch
    end
  end
  
  
  %
  %Create the hypercomplex data matrices if needed ....
  %
  if (QmatNMR.numbstructs == 0)  			      %no matNMR structures found
    QmatNMR.Spec2Dhc = zeros(QmatNMR.SizeTD1, QmatNMR.SizeTD2);			      	%always clear previous hypercomplex part
    
  elseif ~ (QmatNMR.numbstructs == QmatNMR.numbvars)	      				%variable consists of structures and non-structures
    disp('matNMR WARNING: some variables are matNMR structures and some not:  hypercomplex part of the new FID/Spectrum is set to 0 !!');
    QmatNMR.ReadHypercomplex = 0;
    QmatNMR.Spec2Dhc = zeros(QmatNMR.SizeTD1, QmatNMR.SizeTD2);			      	%always clear previous hypercomplex part
  
  else					      %only matNMR structures found
    if QmatNMR.ReadHypercomplex  				      %the size of the hypercomplex parts have been checked above!
      QmatNMR.Spec2Dhc = eval(strrep(QmatNMR.SpecNameProc, '.Spectrum', '.Hypercomplex'));
    else  						      %always clear previous hypercomplex part
      QmatNMR.Spec2Dhc = zeros(QmatNMR.SizeTD1, QmatNMR.SizeTD2); 		      
    end  
  end
  
  
  %
  %read in the axes and the sweepwidths and frequencies and gamma from the structure if possible
  %
  if ((QmatNMR.numbvars == 1) & (QmatNMR.numbstructs == 1) & (QTEMP24 == 0))
    %
    %Check whether coordinates have been given in the variable name in the input window
    %
    %this case (1 variable, 1 structure) is the easiest as the characteristic string that
    %starts the indexing into the structure is easy to spot
    %
    QTEMP19 = findstr(QmatNMR.SpecNameProc, '.Spectrum(') + 9;
    if ~isempty(QTEMP19)
      QTEMP20 = findstr(QmatNMR.SpecNameProc, ')');
      QTEMP20 = QTEMP20(find(QTEMP20 > QTEMP19));
      QTEMP19 = [QTEMP19 QTEMP20(1)];
      QTEMP20 = findstr(QmatNMR.SpecNameProc( (QTEMP19(1)+1):(QTEMP19(2)-1) ), ',');
      if isempty(QTEMP20)
        QTEMP19 = [];
      else
        QTEMP19 = sort([ (QTEMP20+QTEMP19(1)) QTEMP19]);
      end
    end  
  
    %read in the data path from the structure
    if ExistField(eval(QmatNMR.StructureVar), 'DataPath')
      QmatNMR.DataPath2D = eval([QmatNMR.StructureVar '.DataPath']);
  
    else
      QmatNMR.DataPath2D = '';
    end
  
    %
    %always read the values for the default axis, but only apply them if no correct fixed axis is present!
    %
    if ExistField(eval(QmatNMR.StructureVar), 'DefaultAxisReference')
      QTEMP9 = eval([QmatNMR.StructureVar '.DefaultAxisReference']);
  
      if ~isempty(QTEMP9)
        QmatNMRsettings.DefaultAxisReference2D = QTEMP9;
      end  
    end
      
    if ExistField(eval(QmatNMR.StructureVar), 'DefaultAxisCarrierIndexTD2')
      QTEMP9 = eval([QmatNMR.StructureVar '.DefaultAxisCarrierIndexTD2']);
  
      if ~isempty(QTEMP9)
        QmatNMRsettings.DefaultAxisCarrierIndex1 = QTEMP9;
      end  
    end
    
    if ExistField(eval(QmatNMR.StructureVar), 'DefaultAxisRefkHzTD2')
      QTEMP9 = eval([QmatNMR.StructureVar '.DefaultAxisRefkHzTD2']);
  
      if ~isempty(QTEMP9)
        QmatNMRsettings.DefaultAxisReferencekHz1 = QTEMP9;
      end  
    end
      
    if ExistField(eval(QmatNMR.StructureVar), 'DefaultAxisRefPPMTD2')
      QTEMP9 = eval([QmatNMR.StructureVar '.DefaultAxisRefPPMTD2']);
  
      if ~isempty(QTEMP9)
        QmatNMRsettings.DefaultAxisReferencePPM1 = QTEMP9;
      end  
    end
  
  
    %
    %Check for a fixed axis
    %
    %extract the axis for TD2 if it is saved in the structure
    QTEMP7 = eval([QmatNMR.StructureVar '.AxisTD2']);
    %first check the length of the axis vector to be sure no errors occur.
    if isempty(QTEMP19) | isempty(QTEMP7)	   %no indexing into matrix OR empty axis variable
      QTEMP9 = QTEMP7;
    else
      QTEMP9 = eval(['QTEMP7(' QmatNMR.SpecNameProc( (QTEMP19(end-1)+1):(QTEMP19(end)-1) ) ');']);
    end
  
  
    if (length(QTEMP9) == QmatNMR.SizeTD2)
      QmatNMR.RulerXAxis1 = 1;	      %Flag for user-defined axis for TD2
      QmatNMR.AxisTD2 = QTEMP9;
  
    else
      if ~(isempty(QTEMP9))
        disp('matNMR WARNING: Length of axis vector for TD2 in the structure not correct. Now using default axis!');
      end  
  			      %we set the axis variables to points until the GetDefaultAxis
  			      %routine is called, after which the default axis will be
  			      %correctly plotted. A default axis will however NEVER to saved
  
      QmatNMR.RulerXAxis1 = 0;	      %Flag for default axis for TD2
        
      QmatNMR.AxisTD2 = zeros(1, QmatNMR.SizeTD2);
      QmatNMR.AxisTD2(1:QmatNMR.SizeTD2) = 1:QmatNMR.SizeTD2;
    end
  
  
    %
    %TD1
    %
    %
    %always read the values for the default axis, but only apply them if no correct fixed axis is present!
    %
    if ExistField(eval(QmatNMR.StructureVar), 'DefaultAxisRefkHzTD1')
      QTEMP9 = eval([QmatNMR.StructureVar '.DefaultAxisRefkHzTD1']);
  
      if ~isempty(QTEMP9)
        QmatNMRsettings.DefaultAxisReferencekHz2 = QTEMP9;
      end  
    end
      
    if ExistField(eval(QmatNMR.StructureVar), 'DefaultAxisCarrierIndexTD1')
      QTEMP9 = eval([QmatNMR.StructureVar '.DefaultAxisCarrierIndexTD1']);
  
      if ~isempty(QTEMP9)
        QmatNMRsettings.DefaultAxisCarrierIndex2 = QTEMP9;
      end  
    end
      
    if ExistField(eval(QmatNMR.StructureVar), 'DefaultAxisRefPPMTD1')
      QTEMP9 = eval([QmatNMR.StructureVar '.DefaultAxisRefPPMTD1']);
  
      if ~isempty(QTEMP9)
        QmatNMRsettings.DefaultAxisReferencePPM2 = QTEMP9;
      end  
    end
  
  
    %
    %Check for a fixed axis
    %
    %extract the axis for TD1 if it is saved in the structure
    QTEMP7 = eval([QmatNMR.StructureVar '.AxisTD1']);
    %first check the length of the axis vector to be sure no errors occur.
    if isempty(QTEMP19) | isempty(QTEMP7)	   %no indexing into matrix OR empty axis variable
      QTEMP8 = QTEMP7;
    else
      QTEMP8 = eval(['QTEMP7(' QmatNMR.SpecNameProc( (QTEMP19(end-1)+1):(QTEMP19(end)-1) ) ');']);
    end
  
  
    if (length(QTEMP8) == QmatNMR.SizeTD1)
      QmatNMR.RulerXAxis2 = 1;	      %Flag for user-defined axis for TD1
      QmatNMR.AxisTD1 = QTEMP8;
  
    else
      if ~(isempty(QTEMP8))
        disp('matNMR WARNING: Length of axis vector for TD1 in the structure not correct. Now using default axis!');
      end  
  			      %we set the axis variables to points until the GetDefaultAxis
  			      %routine is called, after which the default axis will be
  			      %correctly plotted. A default axis will however NEVER to saved
  
      QmatNMR.RulerXAxis2 = 0;	      %Flag for default axis for TD1
  
      QmatNMR.AxisTD1 = zeros(1, QmatNMR.SizeTD1);
      QmatNMR.AxisTD1(1:QmatNMR.SizeTD1) = 1:QmatNMR.SizeTD1;
    end
  
  
    %set the sweepwidth (TD2) according to the value saved in the structure
    if ExistField(eval(QmatNMR.StructureVar), 'SweepWidthTD2')
      QTEMP9 = eval([QmatNMR.StructureVar '.SweepWidthTD2']);
  
      if ~isempty(QTEMP9)
        QmatNMR.SWTD2 = QTEMP9;
      end  
    end
  
  
    %set the sweepwidth (TD1) according to the value saved in the structure
    if ExistField(eval(QmatNMR.StructureVar), 'SweepWidthTD1')
      QTEMP9 = eval([QmatNMR.StructureVar '.SweepWidthTD1']);
  
      if ~isempty(QTEMP9)
        QmatNMR.SWTD1 = QTEMP9;
      end  
    end
  
  
  
  	
    %set the spectrometer frequency (TD2) according to the value saved in the structure
    if ExistField(eval(QmatNMR.StructureVar), 'SpectralFrequencyTD2')
      QTEMP9 = eval([QmatNMR.StructureVar '.SpectralFrequencyTD2']);
  
      if ~isempty(QTEMP9)
        QmatNMR.SFTD2 = QTEMP9;
      end  
    end
  	
    %set the spectrometer frequency (TD1) according to the value saved in the structure
    if ExistField(eval(QmatNMR.StructureVar), 'SpectralFrequencyTD1')
      QTEMP9 = eval([QmatNMR.StructureVar '.SpectralFrequencyTD1']);
  
      if ~isempty(QTEMP9)
        QmatNMR.SFTD1 = QTEMP9;
      end  
    end
  
  
  
  
    %set the FIDstatus (TD2) according to the value saved in the structure
    if ExistField(eval(QmatNMR.StructureVar), 'FIDstatusTD2')
      QTEMP9 = eval([QmatNMR.StructureVar '.FIDstatusTD2']);
  
      if ~isempty(QTEMP9)
        QmatNMR.FIDstatus2D1 = QTEMP9;
      end  
    end
  	
    %set the FIDstatus (TD1) according to the value saved in the structure
    if ExistField(eval(QmatNMR.StructureVar), 'FIDstatusTD1')
      QTEMP9 = eval([QmatNMR.StructureVar '.FIDstatusTD1']);
  
      if ~isempty(QTEMP9)
        QmatNMR.FIDstatus2D2 = QTEMP9;
      end  
    end
  
  
  
  
    %set the sign of the gyromagnetic ratio (TD2) according to the value saved in the structure
    if ExistField(eval(QmatNMR.StructureVar), 'GammaTD2')
      QTEMP9 = eval([QmatNMR.StructureVar '.GammaTD2']);
  
      if ~isempty(QTEMP9)
        QmatNMR.gamma1 = QTEMP9;
      end  
    end
  	
    %set the sign of the gyromagnetic ratio (TD1) according to the value saved in the structure
    if ExistField(eval(QmatNMR.StructureVar), 'GammaTD1')
      QTEMP9 = eval([QmatNMR.StructureVar '.GammaTD1']);
  
      if ~isempty(QTEMP9)
        QmatNMR.gamma2 = QTEMP9;
      end  
    end
  
  else		      %the variable is not a structure so we make an axis in points
  		      %we set the axis variables to points until the GetDefaultAxis
  		      %routine is called, after which the default axis will be
  		      %correctly plotted. A default axis will however NEVER to saved
    QmatNMR.AxisTD2 = 1:QmatNMR.SizeTD2;
    QmatNMR.AxisTD1 = 1:QmatNMR.SizeTD1;
    
    if (QTEMP24 == 0)
      QmatNMR.RulerXAxis1 = 0;	      %Flag for default axis for TD2
      QmatNMR.RulerXAxis2 = 0;	      %Flag for default axis for TD1
  
    else			%funny 3D matrix issue (see above)
      QmatNMR.RulerXAxis1 = 1;	      %Flag for user-defined axis for TD2
      QmatNMR.RulerXAxis2 = 1;	      %Flag for user-defined axis for TD1
    end
    
    QmatNMRsettings.DefaultAxisCarrierIndex  = floor(QmatNMR.SizeTD2/2)+1;
    QmatNMRsettings.DefaultAxisCarrierIndex1 = floor(QmatNMR.SizeTD2/2)+1;
    QmatNMRsettings.DefaultAxisCarrierIndex2 = floor(QmatNMR.SizeTD1/2)+1;
  
    QmatNMRsettings.DefaultAxisReferencekHz    = 0;
    QmatNMRsettings.DefaultAxisReferencekHzTD2 = 0;
    QmatNMRsettings.DefaultAxisReferencekHzTD1 = 0;
  
    QmatNMRsettings.DefaultAxisReferencePPM    = 0;
    QmatNMRsettings.DefaultAxisReferencePPMTD2 = 0;
    QmatNMRsettings.DefaultAxisReferencePPMTD1 = 0;
  end
  
  
  
  %
  %Oops! One or two axis variables have been supplied. If these are correct vectors than these
  %have priority over the axes in the structure!
  %
  %First TD2
  if (~ isempty(QmatNMR.UserDefAxisT2Main))
    QTEMP9 = eval(QmatNMR.UserDefAxisT2Main);
    if (length(QTEMP9)==QmatNMR.SizeTD2)
      QmatNMR.RulerXAxis1 = 1;	      %Flag for user-defined axis for TD2
      QmatNMR.AxisTD2 = QTEMP9;
      
    else
      disp('matNMR WARNING: Length of TD2 axis vector not correct. Now using original axis!');
    end  
  end
  %Then TD1
  if (~ isempty(QmatNMR.UserDefAxisT1Main))
    QTEMP9 = eval(QmatNMR.UserDefAxisT1Main);
    if (length(QTEMP9)==QmatNMR.SizeTD1)
      QmatNMR.RulerXAxis2 = 1;	      %Flag for user-defined axis for TD1
      QmatNMR.AxisTD1 = QTEMP9;
      
    else
      disp('matNMR WARNING: Length of TD1 axis vector not correct. Now using original axis!');
    end  
  end
  
  
  
  %
  %In case one or both of the axes are default axes, we first define them once
  %
  if (QmatNMR.RulerXAxis1 == 0)
    QmatNMR.Dim = 1;
    QmatNMR.Size1D = QmatNMR.SizeTD2;
    QmatNMR.gamma1d = QmatNMR.gamma1;
    QmatNMR.SW1D = QmatNMR.SWTD2;
    QmatNMR.SF1D = QmatNMR.SFTD2;
    QmatNMR.FIDstatus = QmatNMR.FIDstatus2D1;
    QmatNMR.fase1startIndex = floor(QmatNMR.Size1D/2)+1;
  
    GetDefaultAxis
  end
  if (QmatNMR.RulerXAxis2 == 0)
    QmatNMR.Dim = 2;
    QmatNMR.Size1D = QmatNMR.SizeTD1;
    QmatNMR.gamma1d = QmatNMR.gamma2;
    QmatNMR.SW1D = QmatNMR.SWTD1;
    QmatNMR.SF1D = QmatNMR.SFTD1;
    QmatNMR.FIDstatus = QmatNMR.FIDstatus2D2;
    QmatNMR.fase1startIndex = floor(QmatNMR.Size1D/2)+1;
  
    GetDefaultAxis
  end
    
  
  %
  %Now we want to be absolutely sure that the axis vectors are a row vectors!
  %
  QmatNMR.AxisTD2 = QmatNMR.AxisTD2(:)';
  QmatNMR.AxisTD1 = QmatNMR.AxisTD1(:)';
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
