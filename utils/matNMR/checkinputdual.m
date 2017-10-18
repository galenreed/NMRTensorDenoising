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
%checkinputdual.m is used to check user input. Any expression which should result in a valid matrix
%can be checked with this script such that matNMR handles them properly ...
%--> the expression is checked for its variables: if they are structures the var.Spectrum will be
%evaluated
%
%02-06-'98
%16-04-'03

try
  try
    QmatNMR.numbvars = 0;
    QmatNMR.numbstructs = 0;
    QmatNMR.StructureVar = '';
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
          end
        end
      
      elseif (exist(QTEMP2, 'file') == 2)
        QmatNMR.numbvars = QmatNMR.numbvars + 1;
      end
    end
  end
  
  
  %
  %Now we define the new spectrum for the dual plot
  %
  try
    QmatNMR.dual = squeeze(eval(QmatNMR.SpecNameProc));
    
  catch
    beep
    disp('matNMR WARNING: specified input did not produce correct output. Please recheck ...');
    QmatNMR.BREAK = 1;
    return
  end
  
  [QmatNMR.dualSizeTD1, QmatNMR.dualSizeTD2] = size(QmatNMR.dual);
  
  
  %
  %check that the norm of the spectrum is not very small as this is problematic in Matlab
  %
  if ~sum(sum(isnan(QmatNMR.dual)))
    try
      %we only test the norm if the matrix is finite, because otherwise the norm routine complains
      if (norm(QmatNMR.dual) < eps^2)
        beep
        disp('matNMR WARNING');
        disp('matNMR WARNING: the spectrum appears to have a very small norm, which may be a cause of problems in Matlab!');
        disp('matNMR WARNING');
      end
    catch
    end
  end
  
  
  %
  %if the new variable is not a structure and it turns out to be a 2 or higher-
  %dimensional matrix then we set the flag QTEMP7. Else we don't.
  %
  if (QTEMP7==0) & ((QmatNMR.dualSizeTD1 > 1) & (QmatNMR.dualSizeTD2 > 1))
    QTEMP7 = 1;
  end
  
  
  %
  %Next we make a distinction between actions for various plot types. We start with the
  %special types and then go to the default type for which much more flexibility is allowed.
  %For special plot types only the matrix is taken, not the axes, and it should be exactly
  %the same size as the original 2D matrix from which the special plot was made
  %
  if ((QmatNMR.PlotType == 1) | (QmatNMR.PlotType == 4) | (QmatNMR.PlotType == 5)) 	%the default plot type, 1D bar and error bar plots
      %if the flag QTEMP7 was set then we must check whether QmatNMR.dual really is a 1D vector.
      if (QTEMP7)
        if ((QmatNMR.dualSizeTD1 > 1) & (QmatNMR.dualSizeTD2 > 1))
          %
          %we have a 2D or higher matrix! Now what do we do? If it is a 2D matrix then we load
          %it as a 2D. If it is a higher-dimensional thingy then we give an error message
          %
          QTEMP8 = ndims(QmatNMR.dual);
          if (QTEMP8 == 2)	%2D variable
            disp('matNMR WARNING: cannot make dual plot from a 2D matrix!');
            return
            
          else
            disp('matNMR WARNING: cannot make dual plot from a nD matrix!');
            return
          end
          
        else
          %
          %so we have an array which was not a 1D variable originally but by selecting
          %	coordinates from the array it has become one-dimensional. If the variable
          %	was a structure then it could be that a column was selected, though, and
          %	then we must take the sweepwidths etc from T1 and not from T2!!!
          %
          if (QmatNMR.dualSizeTD2 == 1)		%to make sure the spectrum is a row!
            QmatNMR.dual = QmatNMR.dual.';
      
            QTEMP8 = 1;		%flag to take TD1 variables and not TD2
      
          else
            QTEMP8 = 0;		%flag to take TD2 variables and not TD1
          end
        end  
      
      else
        QTEMP8 = 0;	%flag to take TD2 variables and not TD1
      end  
      
      
      
      %
      %to make sure the spectrum is a row!
      %
      QmatNMR.dual = QmatNMR.dual(:).';
      
      
      %
      %get the sizes right again now that we are sure that it's a vector and not a column
      %
      [QmatNMR.dualSizeTD1, QmatNMR.dualSizeTD2] = size(QmatNMR.dual);    
  
      					%read in the axis and the sweepwidth and frequency from the structure if possible
      					%and only if the user hasn't supplied his/her own axis.
      if ((QmatNMR.numbvars == 1) & (QmatNMR.numbstructs == 1) & isempty(QmatNMR.LastDualAxis))
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
  
        if (QTEMP8 == 0)	%use variables for TD2
          QTEMP7 = eval([QmatNMR.StructureVar '.AxisTD2']);
          %first check the length of the axis vector to be sure no errors occur.
          if isempty(QTEMP19)	      %no indexing into matrix
            QTEMP9 = QTEMP7;
          elseif ~isempty(QTEMP7)
            QTEMP9 = eval(['QTEMP7(' QmatNMR.SpecNameProc( (QTEMP19(end-1)+1):(QTEMP19(end)-1) ) ');']);
          end
  
          if (length(QTEMP9) == QmatNMR.dualSizeTD2)
            QmatNMR.dualaxis = QTEMP9;
      
          else
            if ~ isempty(QTEMP9)
              disp('matNMR WARNING: Length of 1D axis vector in the structure not correct. Trying to use the default axis.');
            end  
          			%
      				%okay, so the axis vector in the structure was not correct or there was no axis
      				%vector in the structure. We can now either try and apply a default axis if the
      				%current mode is to plot default axes. This will need the existence of the sweepwidth
      				%and possibly the spectrometer frequency. Or, we can try and use the same axis as is
      				%used by the current plot.
      				%
      				%First we try the default axis option ...
      				%
            				%Now we try and see if the necessary information is stored in the structure.
            if ExistField(eval(QmatNMR.StructureVar), 'SweepWidthTD2')
  	    QTEMP10 = eval([QmatNMR.StructureVar '.SweepWidthTD2']);
  	  else
  	    QTEMP10 = 0;
  	  end
            if ExistField(eval(QmatNMR.StructureVar), 'SpectralFrequencyTD2')
  	    QTEMP11 = eval([QmatNMR.StructureVar '.SpectralFrequencyTD2']);
  	  else
  	    QTEMP11 = 0;
  	  end
            if ExistField(eval(QmatNMR.StructureVar), 'GammaTD2')
  	    QTEMP12 = eval([QmatNMR.StructureVar '.GammaTD2']);
  	  else
  	    QTEMP12 = 0;
  	  end
            if ExistField(eval(QmatNMR.StructureVar), 'FIDstatusTD2')
  	    QTEMP13 = eval([QmatNMR.StructureVar '.FIDstatusTD2']);
  	  else
  	    QTEMP13 = 0;
  	  end
            if ExistField(eval(QmatNMR.StructureVar), 'DefaultAxisRefkHzTD2')
  	    QTEMP14 = eval([QmatNMR.StructureVar '.DefaultAxisRefkHzTD2']);
  	  else
  	    QTEMP14 = 0;
  	  end
            if ExistField(eval(QmatNMR.StructureVar), 'DefaultAxisRefPPMTD2')
  	    QTEMP15 = eval([QmatNMR.StructureVar '.DefaultAxisRefPPMTD2']);
  	  else
  	    QTEMP15 = 0;
  	  end
            if ExistField(eval(QmatNMR.StructureVar), 'DefaultAxisCarrierIndexTD2')
  	    QTEMP16 = eval([QmatNMR.StructureVar '.DefaultAxisCarrierIndexTD2']);
  	  else
  	    QTEMP16 = floor(QmatNMR.dualSizeTD2/2)+1;
  	  end
  
            if isempty(QTEMP14)
              QTEMP14 = 0;
            end
            if isempty(QTEMP15)
              QTEMP15 = 0;
            end
            if isempty(QTEMP16)
              QTEMP16 = floor(QmatNMR.dualSizeTD2/2)+1;
            end
  
  	  disp('matNMR NOTICE: aplying default axis to the dual plot vector!')
  	  QmatNMR.dualaxis = GetDefaultAxisDual(QmatNMR.dualSizeTD2, QTEMP10, QTEMP11, QTEMP12, QTEMP13, QTEMP14, QTEMP15, QTEMP16);        %recreate a default axis for the current spectrum
            if ~isempty(QTEMP19)		%coordinates specified?
              QmatNMR.dualaxis = eval(['QmatNMR.dualaxis(' QmatNMR.SpecNameProc( (QTEMP19(end-1)+1):(QTEMP19(end)-1) ) ');']);
            end
          end
      
        else
          %first check the length of the axis vector to be sure no errors occur.
          QTEMP7 = eval([QmatNMR.StructureVar '.AxisTD1']);
          %first check the length of the axis vector to be sure no errors occur.
          if isempty(QTEMP19)	      %no indexing into matrix
            QTEMP9 = QTEMP7;
          elseif ~isempty(QTEMP7)
            QTEMP9 = eval(['QTEMP7(' QmatNMR.SpecNameProc( (QTEMP19(end-1)+1):(QTEMP19(end)-1) ) ');']);
          end
  
          if (length(QTEMP9) == QmatNMR.dualSizeTD2)
            QmatNMR.dualaxis = QTEMP9;
        
          else
            if ~ isempty(QTEMP9)
              disp('matNMR WARNING: Length of 1D axis vector in the structure not correct. Trying to use the default axis.');
            end  
          				%
      				%okay, so the axis vector in the structure was not correct or there was no axis
      				%vector in the structure. We can now either try and apply a default axis if the
      				%current mode is to plot default axes. This will need the existence of the sweepwidth
      				%and possibly the spectrometer frequency. Or, we can try and use the same axis as is
      				%used by the current plot.
      				%
      				%First we try the default axis option ...
      				%
            				%Now we try and see if the necessary information is stored in the structure.
            if ExistField(eval(QmatNMR.StructureVar), 'SweepWidthTD1')
  	    QTEMP10 = eval([QmatNMR.StructureVar '.SweepWidthTD1']);
  	  else
  	    QTEMP10 = 0;
  	  end
            if ExistField(eval(QmatNMR.StructureVar), 'SpectralFrequencyTD1')
  	    QTEMP11 = eval([QmatNMR.StructureVar '.SpectralFrequencyTD1']);
  	  else
  	    QTEMP11 = 0;
  	  end
            if ExistField(eval(QmatNMR.StructureVar), 'GammaTD1')
  	    QTEMP12 = eval([QmatNMR.StructureVar '.GammaTD1']);
  	  else
  	    QTEMP12 = 0;
  	  end
            if ExistField(eval(QmatNMR.StructureVar), 'FIDstatusTD1')
  	    QTEMP13 = eval([QmatNMR.StructureVar '.FIDstatusTD1']);
  	  else
  	    QTEMP13 = 0;
  	  end
            if ExistField(eval(QmatNMR.StructureVar), 'DefaultAxisRefkHzTD1')
  	    QTEMP14 = eval([QmatNMR.StructureVar '.DefaultAxisRefkHzTD1']);
  	  else
  	    QTEMP14 = 0;
  	  end
            if ExistField(eval(QmatNMR.StructureVar), 'DefaultAxisRefPPMTD1')
  	    QTEMP15 = eval([QmatNMR.StructureVar '.DefaultAxisRefPPMTD1']);
  	  else
  	    QTEMP15 = 0;
  	  end
            if ExistField(eval(QmatNMR.StructureVar), 'DefaultAxisCarrierIndexTD1')
  	    QTEMP16 = eval([QmatNMR.StructureVar '.DefaultAxisCarrierIndexTD1']);
  	  else
  	    QTEMP16 = floor(QmatNMR.dualSizeTD1/2)+1;
  	  end
  
            if isempty(QTEMP14)
              QTEMP14 = 0;
            end
            if isempty(QTEMP15)
              QTEMP15 = 0;
            end
            if isempty(QTEMP16)
              QTEMP16 = floor(QmatNMR.dualSizeTD1/2)+1;
            end
  
  	  disp('matNMR NOTICE: aplying default axis to the dual plot vector!')
  	  QmatNMR.dualaxis = GetDefaultAxisDual(QmatNMR.dualSizeTD2, QTEMP10, QTEMP11, QTEMP12, QTEMP13, QTEMP14, QTEMP15, QTEMP16);        %recreate a default axis for the current spectrum
            if ~isempty(QTEMP19)		%coordinates specified?
              QmatNMR.dualaxis = eval(['QmatNMR.dualaxis(' QmatNMR.SpecNameProc( (QTEMP19(end-1)+1):(QTEMP19(end)-1) ) ');']);
            end
          end
        end
      
      else			%the variable is not a single structure so we use the same axis as for
        			%the original spectrum. Note that we cannot use a default axis now because we
      			%haven't got the necessary data for this new spectrum.
        QmatNMR.dualaxis = QmatNMR.Axis1D;
      end
      
      
      %
      %Oops! An axis variable has been supplied in the inpuw window. If this is a correct vector than 
      %this has priority over the axis in the structure!
      %
      
      %now check the axis that is supplied optionally
      if (~ isempty(QmatNMR.LastDualAxis)) %check whether the given axis isn't empty
        QmatNMR.dualaxis = eval(QmatNMR.LastDualAxis);
        QmatNMR.dualaxis = QmatNMR.dualaxis(:).';		      %to make sure the axis vector is a row!
      end  
  
  
      %
      %In case of an errorbar plot we need to check the input for the vector with the errorbars
      %as this may contain matNMR stuctures as well
      %
      [QmatNMR.Q1DErrorBarsDual, QmatNMR.CheckInput] = checkinput(QmatNMR.Q1DErrorBarsDual); %adjust the format of the input expression for later use
      QmatNMR.Q1DErrorBarsDual2 = QmatNMR.Q1DErrorBarsDual;
      for QTEMP40 = length(QmatNMR.CheckInput):-1:2
        QTEMP2 = deblank(fliplr(deblank(fliplr(QmatNMR.Q1DErrorBarsDual2((QmatNMR.CheckInput(QTEMP40-1)+1):(QmatNMR.CheckInput(QTEMP40)-1))))));
        				%check the expression for existing variables
        if exist(QTEMP2, 'var')
          if ~ strcmp(QTEMP2, ':')
      
        				%check whether the variable is a structure
            if (isa(eval(QTEMP2), 'struct'))
              QmatNMR.Q1DErrorBarsDual2 = [QmatNMR.Q1DErrorBarsDual2(1:(QmatNMR.CheckInput(QTEMP40)-1)) '.Spectrum' QmatNMR.Q1DErrorBarsDual2((QmatNMR.CheckInput(QTEMP40)):length(QmatNMR.Q1DErrorBarsDual2))];
            end
          end
        end
      end    
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
