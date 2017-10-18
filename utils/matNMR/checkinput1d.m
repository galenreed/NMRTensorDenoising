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
%checkinput1d.m is used to check user input. Any expression which should result in a valid matrix
%can be checked with this script such that matNMR handles them properly ...
%--> the expression is checked for its variables: if they are structures the var.Spectrum will be
%evaluated
%
%02-06-'98

try
  QmatNMR.numbvars = 0;
  QmatNMR.numbstructs = 0;
  QmatNMR.StructureVar = '';
  
  %
  %We try to manipulate the user input to check for matNMR structures, that require special care
  %The try-catch loop ensures that if these actions don't work, then we still try to apply the
  %original input by the user.
  %
  try
    QTEMP7 = 0;
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
    
          QTEMP44 = QTEMP2( (QTEMP42(1)+1):(QTEMP42(2)-1) );		%this should be the name of the structure in the workspace
          QTEMP46 = eval(QTEMP44);
    
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
              QTEMP46 = eval(QTEMP44);
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
    
        if ~ strcmp(QTEMP2, ':')
    
      				%check whether the variable is a structure
          if (isa(eval(QTEMP2), 'struct'))
            QmatNMR.numbstructs = QmatNMR.numbstructs + 1;
    
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
    
    
    	%check whether it is really a 1D variable and not 2D or 3D
            eval(['QTEMP7 = ' QTEMP2 '.Spectrum;']);
            QTEMP7 = size(QTEMP7);
    	if ( (length(QTEMP7) > 2) | ( (QTEMP7(1) > 1) & (QTEMP7(2) > 1) ) )
    	  %this is not a standard 1D variable so we now need to check whether
    	  %the QmatNMR.SpecNameProc variable produces a 1D variable. This is done some lines below
    	  %but we set a flag now to ensure execution of this second check.
    	  QTEMP7 = 1;
    	else
    	  QTEMP7 = 0;
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
          end
        end
    
      elseif (exist(QTEMP2, 'file') == 2)
        QmatNMR.numbvars = QmatNMR.numbvars + 1;
      end
    end
  end
  
  
  try
    QmatNMR.Spec1D = squeeze(eval(QmatNMR.SpecNameProc));
  catch
    beep
    disp('matNMR WARNING: specified input did not produce correct output. Please recheck ...');
    QmatNMR.BREAK = 1;
    return
  end
  
  [QTEMP11, QmatNMR.Size1D] = size(QmatNMR.Spec1D);
  QmatNMR.fase1startIndex = floor(QmatNMR.Size1D/2)+1;
  QmatNMR.nrspc = 1;
  
  
  %
  %if the new variable is not a structure and it turns out to be a 2 or higher-
  %dimensional matrix then we set the flag QTEMP7. Else we don't.
  %
  if (QTEMP7==0) & ((QTEMP11 > 1) & (QmatNMR.Size1D > 1))
    QTEMP7 = 1;
  end
  
  
  %if the flag QTEMP7 was set then we must check whether QmatNMR.Spec1D really is a 1D vector.
  QTEMP8 = 0;
  if (QTEMP7)
    if ((QTEMP11 > 1) & (QmatNMR.Size1D > 1))
      QTEMP8 = ndims(QmatNMR.Spec1D);
      %
      %we have a 2D or higher matrix! Now what do we do? If it is a 2D matrix then we load
      %it as a 2D. If it is a higher-dimensional thingy then we give an error message
      %
      if (QTEMP8 == 2)	%2D variable
        disp('matNMR NOTICE: variable is a 2D matrix and will be loaded as such!');
  
        %prepare input variables such that the regelnaam.m routine can be called
        QmatNMR.LastVar = 2;  	%reset the variable that denotes what type the last-read variable is
        QmatNMR.ask = 2;		%2D variable
        QmatNMR.uiInput3 = '';	%input for axis variable TD1
        regelnaam
        QmatNMR.BREAK = 1;
        return
  
      else
        if (QTEMP8 == 3)		%opening 3D dataset
          disp('matNMR NOTICE: variable is a 3D matrix and will be loaded as such!');
  
          %prepare input variables such that the regelnaam.m routine can be called
          QmatNMR.ask = 3;		%3D variable
          QmatNMR.uiInput3 = '';	%input for axis variable TD1
          regelnaam
          QmatNMR.BREAK = 1;
  	return
  
        else
          disp('matNMR WARNING: input matrix has more than 2 dimensions!');
          disp('matNMR WARNING: loading of 1D FID/spectrum aborted.');
          return
        end
      end
  
    else
      %
      %so we have an array which was not a 1D variable originally but by selecting
      %	coordinates from the array it has become one-dimensional. If the variable
      %	was a structure then it could be that a column was selected, though, and
      %	then we must take the sweepwidths etc from T1 and not from T2!!!
      %
      if (QmatNMR.Size1D == 1)		%to make sure the spectrum is a row!
        QmatNMR.Size1D = QTEMP11;
        QmatNMR.Spec1D = QmatNMR.Spec1D.';
  
        QTEMP8 = 1;	%flag to take TD1 variables and not TD2
      end
    end
  
  else
    if (QmatNMR.Size1D == 1)		%to make sure the spectrum is a row!
      QmatNMR.Size1D = QTEMP11;
      QmatNMR.Spec1D = QmatNMR.Spec1D.';
    end
  
    QTEMP8 = 0;	%flag to take TD2 variables and not TD1
  end
  
  
  %
  %check that the norm of the spectrum is not very small as this is problematic in Matlab
  %
  if ~sum(sum(isnan(QmatNMR.Spec1D)))
    try
      %we only test the norm if the matrix is finite, because otherwise the norm routine complains
      if (norm(QmatNMR.Spec1D) < eps^2)
        beep
        disp('matNMR WARNING');
        disp('matNMR WARNING: the spectrum appears to have a very small norm, which may be a cause of problems in Matlab!');
        disp('matNMR WARNING');
      end
    catch
    end
  end
  
  
  					%read in the axis and the sweepwidth and frequency from the structure if possible
  if ((QmatNMR.numbvars == 1) & (QmatNMR.numbstructs == 1))
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
      if ~isempty(findstr(QmatNMR.SpecNameProc( (QTEMP19(1)+1):(QTEMP19(2)-1) ), ','))
        QTEMP19 = [];		%for a 1D there can be no comma-separated indexes!
      end
    end
  
    %read in the data path from the structure
    if ExistField(eval(QmatNMR.StructureVar), 'DataPath')
      QmatNMR.DataPath1D = eval([QmatNMR.StructureVar '.DataPath']);
  
    else
      QmatNMR.DataPath1D = '';
    end
  
  
    if (QTEMP8 == 0)	%use variables for TD2
      %
      %always read the values for the default axis, but only apply them if no correct fixed axis is present!
      %
      if ExistField(eval(QmatNMR.StructureVar), 'DefaultAxisReference')
        QTEMP9 = eval([QmatNMR.StructureVar '.DefaultAxisReference']);
  
        if ~isempty(QTEMP9)
          QmatNMRsettings.DefaultAxisReference1D = QTEMP9;
        end
      end
  
      if ExistField(eval(QmatNMR.StructureVar), 'DefaultAxisCarrierIndexTD2')
        QTEMP9 = eval([QmatNMR.StructureVar '.DefaultAxisCarrierIndexTD2']);
  
        if ~isempty(QTEMP9)
          QmatNMRsettings.DefaultAxisCarrierIndex = QTEMP9;
        end
      end
  
      if ExistField(eval(QmatNMR.StructureVar), 'DefaultAxisRefkHzTD2')
        QTEMP9 = eval([QmatNMR.StructureVar '.DefaultAxisRefkHzTD2']);
  
        if ~isempty(QTEMP9)
          QmatNMRsettings.DefaultAxisReferencekHz = QTEMP9;
        end
      end
  
      if ExistField(eval(QmatNMR.StructureVar), 'DefaultAxisRefPPMTD2')
        QTEMP9 = eval([QmatNMR.StructureVar '.DefaultAxisRefPPMTD2']);
  
        if ~isempty(QTEMP9)
          QmatNMRsettings.DefaultAxisReferencePPM = QTEMP9;
        end
      end
  
  
      %
      %Check for a fixed axis
      %
      QTEMP7 = eval([QmatNMR.StructureVar '.AxisTD2']);
      %first check the length of the axis vector to be sure no errors occur.
      if isempty(QTEMP19) | isempty(QTEMP7)	   %no indexing into matrix OR empty axis variable
        QTEMP9 = QTEMP7;
      else
        QTEMP9 = eval(['QTEMP7(' QmatNMR.SpecNameProc( (QTEMP19(end-1)+1):(QTEMP19(end)-1) ) ');']);
      end
  
      if (length(QTEMP9) == QmatNMR.Size1D)
        QmatNMR.RulerXAxis = 1;		%Flag for user-defined axis
        QmatNMR.Axis1D = QTEMP9;
        QmatNMR.texie = 'User-Defined';
  
      else
        if ~ isempty(QTEMP9)
          disp('matNMR WARNING: Length of 1D axis vector in the structure not correct. Now using the default axis!');
        end
      				%set the axes variables
        GetDefaultAxis
      end
  
      %set the sweepwidth according to the value saved in the structure
      if ExistField(eval(QmatNMR.StructureVar), 'SweepWidthTD2')
        QTEMP9 = eval([QmatNMR.StructureVar '.SweepWidthTD2']);
  
        if ~isempty(QTEMP9)
          QmatNMR.SW1D = QTEMP9;
        end
      end
  
      %set the spectrometer frequency according to the value saved in the structure
      if ExistField(eval(QmatNMR.StructureVar), 'SpectralFrequencyTD2')
        QTEMP9 = eval([QmatNMR.StructureVar '.SpectralFrequencyTD2']);
  
        if ~isempty(QTEMP9)
          QmatNMR.SF1D = QTEMP9;
        end
      end
  
      %set the FIDstatus according to the value saved in the structure
      if ExistField(eval(QmatNMR.StructureVar), 'FIDstatusTD2')
        QTEMP9 = eval([QmatNMR.StructureVar '.FIDstatusTD2']);
  
        if ~isempty(QTEMP9)
          QmatNMR.FIDstatus = QTEMP9;
        end
      end
  
      %set the sign of the gyromagnetic ratio (TD2) according to the value saved in the structure
      if ExistField(eval(QmatNMR.StructureVar), 'GammaTD2')
        QTEMP9 = eval([QmatNMR.StructureVar '.GammaTD2']);
  
        if ~isempty(QTEMP9)
          QmatNMR.gamma1d = QTEMP9;
        end
      end
  
    else
      QTEMP7 = eval([QmatNMR.StructureVar '.AxisTD1']);
      %first check the length of the axis vector to be sure no errors occur.
      if isempty(QTEMP19) | isempty(QTEMP7)	   %no indexing into matrix OR empty axis variable
        QTEMP9 = QTEMP7;
      else
        QTEMP9 = eval(['QTEMP7(' QmatNMR.SpecNameProc( (QTEMP19(end-1)+1):(QTEMP19(end)-1) ) ');']);
      end
  
      %
      %always read the values for the default axis, but only apply them if no correct fixed axis is present!
      %
      if ExistField(eval(QmatNMR.StructureVar), 'DefaultAxisReference')
        QTEMP9 = eval([QmatNMR.StructureVar '.DefaultAxisReference']);
  
        if ~isempty(QTEMP9)
          DefaultAxisReference = QTEMP9;
        end
      end
  
      if ExistField(eval(QmatNMR.StructureVar), 'DefaultAxisCarrierIndexTD1')
        QTEMP9 = eval([QmatNMR.StructureVar '.DefaultAxisCarrierIndexTD1']);
  
        if ~isempty(QTEMP9)
          QmatNMRsettings.DefaultAxisCarrierIndex = QTEMP9;
        end
      end
  
      if ExistField(eval(QmatNMR.StructureVar), 'DefaultAxisRefkHzTD1')
        QTEMP9 = eval([QmatNMR.StructureVar '.DefaultAxisRefkHzTD1']);
  
        if ~isempty(QTEMP9)
          QmatNMRsettings.DefaultAxisReferencekHz = QTEMP9;
        end
      end
  
      if ExistField(eval(QmatNMR.StructureVar), 'DefaultAxisRefPPMTD1')
        QTEMP9 = eval([QmatNMR.StructureVar '.DefaultAxisRefPPMTD1']);
  
        if ~isempty(QTEMP9)
          QmatNMRsettings.DefaultAxisReferencePPM = QTEMP9;
        end
      end
  
      %
      %Check for a fixed axis
      %
      if (length(QTEMP9) == QmatNMR.Size1D)
        QmatNMR.RulerXAxis = 1;		%Flag for user-defined axis
        QmatNMR.Axis1D = QTEMP9;
        QmatNMR.texie = 'User-Defined';
  
      else
        if ~ isempty(QTEMP9)
          disp('matNMR WARNING: Length of 1D axis vector in the structure not correct. Now using the default axis!');
        end
      				%set the axes variables
        GetDefaultAxis
      end
  
      %set the sweepwidth according to the value saved in the structure
      if ExistField(eval(QmatNMR.StructureVar), 'SweepWidthTD1')
        QTEMP9 = eval([QmatNMR.StructureVar '.SweepWidthTD1']);
  
        if ~isempty(QTEMP9)
          QmatNMR.SW1D = QTEMP9;
        end
      end
  
      %set the spectrometer frequency according to the value saved in the structure
      if ExistField(eval(QmatNMR.StructureVar), 'SpectralFrequencyTD1')
        QTEMP9 = eval([QmatNMR.StructureVar '.SpectralFrequencyTD1']);
  
        if ~isempty(QTEMP9)
          QmatNMR.SF1D = QTEMP9;
        end
      end
  
      %set the FIDstatus according to the value saved in the structure
      if ExistField(eval(QmatNMR.StructureVar), 'FIDstatusTD1')
        QTEMP9 = eval([QmatNMR.StructureVar '.FIDstatusTD1']);
  
        if ~isempty(QTEMP9)
          QmatNMR.FIDstatus = QTEMP9;
        end
      end
  
      %set the sign of the gyromagnetic ratio according to the value saved in the structure
      if ExistField(eval(QmatNMR.StructureVar), 'GammaTD1')
        QTEMP9 = eval([QmatNMR.StructureVar '.GammaTD1']);
  
        if ~isempty(QTEMP9)
          QmatNMR.gamma1d = QTEMP9;
        end
      end
    end
  
  else			%the variable is not a single structure so we make a default axis
    			%and set the axes variables correspondigly
    QmatNMRsettings.DefaultAxisCarrierIndex = floor(QmatNMR.Size1D/2)+1;
    QmatNMRsettings.DefaultAxisReferencekHz = 0;
    QmatNMRsettings.DefaultAxisReferencePPM = 0;
  
    GetDefaultAxis
  end
  
  
  %
  %Oops! An axis variable has been supplied. If this is a correct vector than this has
  %priority over the axis in the structure!
  %
  if (~ isempty(QmatNMR.UserDefAxisT2Main))
    QTEMP9 = eval(QmatNMR.UserDefAxisT2Main);
    if (length(QTEMP9)==QmatNMR.Size1D)
      QmatNMR.RulerXAxis = 1;		%Flag for user-defined axis
      QmatNMR.Axis1D = QTEMP9;
      QmatNMR.texie = 'User-Defined';
  
    else
      disp('matNMR WARNING: Length of 1D axis vector not correct. Now using original axis!');
    end
  end
  
  
  %
  %Now we want to make it absolutely sure that the axis vector is a row vector!
  %(just like the FID/spectrum itself)
  %
  QmatNMR.Axis1D = QmatNMR.Axis1D(:).';
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
