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
%checkinputcont.m is used to check user input. Any expression which should result in a valid matrix
%can be checked with this script such that matNMR handles them properly ...
%--> the expression is checked for its variables: if they are structures the var.Spectrum will be
%evaluated
%
%02-06-'98

try
  QmatNMR.numbvars = 0;
  QmatNMR.numbstructs = 0;
  QmatNMR.History2D3D = '';
  QmatNMR.ContSpecHistoryMacro = AddToMacro;
  QmatNMR.FlagCutSpectrum = 0;
  
  QmatNMR.StructureVar = '';
  %
  %We try to manipulate the user input to check for matNMR structures, that require special care
  %
  try
    for QTEMP40 = length(QmatNMR.CheckInput):-1:2
      QTEMP2 = deblank(fliplr(deblank(fliplr(QmatNMR.SpecName2D3DProc((QmatNMR.CheckInput(QTEMP40-1)+1):(QmatNMR.CheckInput(QTEMP40)-1))))));
    
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
    				%check whether the variable is a structure
        if (isa(eval(QTEMP2), 'struct'))
          QmatNMR.numbstructs = QmatNMR.numbstructs + 1;
    
          QmatNMR.SpecName2D3DProc = [QmatNMR.SpecName2D3DProc(1:(QmatNMR.CheckInput(QTEMP40)-1)) '.Spectrum' QmatNMR.SpecName2D3DProc((QmatNMR.CheckInput(QTEMP40)):length(QmatNMR.SpecName2D3DProc))];
    
    
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
    
    
          if strcmp(QmatNMR.History2D3D, '')		%the processing history is only read in for the first structure
            QmatNMR.History2D3D = eval([QTEMP2, '.History']);
    	QmatNMR.ContSpecHistoryMacro = eval([QTEMP2, '.HistoryMacro']);
    	QmatNMR.ContSpecHistoryMacro = CorrectMacro(QmatNMR.ContSpecHistoryMacro, QmatNMR.MacroLength);
          end
    
        end
      end
    end
  end
  
  
  %
  %We already try and define the spectrum based on the analysed input string
  %
  try
    QmatNMR.Spec2D3D = squeeze(eval(QmatNMR.SpecName2D3DProc));
  
  catch
    QmatNMR.BREAK = 1;
    beep
    disp('matNMR WARNING: specified input did not produce correct output. Please recheck ...');
    return
  end
  
  
  %
  %The case where there is just 1 variable in the input string and it is a matNMR structure
  %
  if ((QmatNMR.numbvars == 1) & (QmatNMR.numbstructs == 1))
    %
    %Check whether coordinates have been given in the variable name in the input window
    %
    %this case (1 variable, 1 structure) is the easiest as the characteristic string that
    %starts the indexing into the structure is easy to spot
    %
    QTEMP19 = findstr(QmatNMR.SpecName2D3DProc, '.Spectrum(') + 9;
    if ~isempty(QTEMP19)
      QTEMP20 = findstr(QmatNMR.SpecName2D3DProc, ')');
      QTEMP20 = QTEMP20(find(QTEMP20 > QTEMP19));
      QTEMP19 = [QTEMP19 QTEMP20(1)];
      QTEMP20 = findstr(QmatNMR.SpecName2D3DProc( (QTEMP19(1)+1):(QTEMP19(2)-1) ), ',');
      if isempty(QTEMP20)
        QTEMP19 = [];
      else
        QTEMP19 = sort([ (QTEMP20+QTEMP19(1)) QTEMP19]);
      end
    end
  
  
    eval(['QTEMP2 = size(' QmatNMR.StructureVar '.Spectrum);']) 	%the size of the original variable
    QTEMP2a = size(squeeze(eval(QmatNMR.SpecName2D3DProc)));		%the size of the final spectrum
    if (length(QTEMP2) == 3)
      %
      %extract the axis vector of the 3D from the structure, or generate a generic one
      %
      if ExistField(eval(QmatNMR.StructureVar), 'AxisTD3')
        QmatNMR.TempAxis3Cont = eval([QmatNMR.StructureVar '.AxisTD3']);
  
        if ~isempty(QTEMP19) & ~isempty(QmatNMR.TempAxis3Cont)
          QmatNMR.TempAxis3Cont = eval(['QmatNMR.TempAxis3Cont(' QmatNMR.SpecName2D3DProc( (QTEMP19(end-3)+1):(QTEMP19(end-2)-1) ) ');']);
        end
  
        if isempty(QmatNMR.TempAxis3Cont)
          QmatNMR.TempAxis3Cont = 1:QTEMP2a(1);
        end
  
      else
        QmatNMR.TempAxis3Cont = 1:QTEMP2a(1);
      end
  
    else
      %always make a 3-element vector for the size, to avoid problems when indexing into the matrix is applied
      QTEMP2 = [1 QTEMP2];
    end
  
    %always make a 3-element vector for the size, to avoid problems when indexing into the matrix is applied
    if (length(QTEMP2a) ==2)
      QTEMP2a = [1 QTEMP2a];
    end
  
  
    %extract the axis for TD2 if it is saved in the structure
    QTEMP7 = eval([QmatNMR.StructureVar '.AxisTD2']);
    if isempty(QTEMP19) | isempty(QTEMP7)	   %no indexing into matrix OR empty axis variable
      QTEMP9 = QTEMP7;
    else
      QTEMP9 = eval(['QTEMP7(' QmatNMR.SpecName2D3DProc( (QTEMP19(end-1)+1):(QTEMP19(end)-1) ) ');']);
    end
  
  
    if (length(QTEMP9) == QTEMP2a(3))
      QmatNMR.TempAxis1Cont = QTEMP9;
      QmatNMR.TempAxis1Cont = QmatNMR.TempAxis1Cont(:).';		%make sure the axis is a row vector
      QmatNMR.UserDefAxisT2Cont = 'QmatNMR.TempAxis1Cont';
  
    else
      if ~(isempty(QTEMP9))
        disp('matNMR WARNING: Length of axis vector for TD2 in the structure not correct. Now using default axis!');
      end
  			      %we set the axis variables to points until the GetDefaultAxis
  			      %routine is called, after which the default axis will be
  			      %correctly plotted. A default axis will however NEVER to saved
  
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
        QTEMP16 = floor(QTEMP2(3)/2)+1;
      end
  
      if isempty(QTEMP14)
        QTEMP14 = 0;
      end
      if isempty(QTEMP15)
        QTEMP15 = 0;
      end
  
      QmatNMR.TempAxis1Cont = GetDefaultAxisDual(QTEMP2(3), QTEMP10, QTEMP11, QTEMP12, QTEMP13, QTEMP14, QTEMP15, QTEMP16);	%recreate a default axis for the current spectrum
      if ~isempty(QTEMP19)	  %coordinates specified?
        QmatNMR.TempAxis1Cont = eval(['QmatNMR.TempAxis1Cont(' QmatNMR.SpecName2D3DProc( (QTEMP19(end-1)+1):(QTEMP19(end)-1) ) ');']);
      end
      QmatNMR.TempAxis1Cont = QmatNMR.TempAxis1Cont(:).';		%make sure the axis is a row vector
      QmatNMR.UserDefAxisT2Cont = 'QmatNMR.TempAxis1Cont';
    end
  
  
    %extract the axis for TD1 if it is saved in the structure
    QTEMP7 = eval([QmatNMR.StructureVar '.AxisTD1']);
    if isempty(QTEMP19) | isempty(QTEMP7)	   %no indexing into matrix OR empty axis variable
      QTEMP9 = QTEMP7;
    else
      QTEMP9 = eval(['QTEMP7(' QmatNMR.SpecName2D3DProc( (QTEMP19(end-2)+1):(QTEMP19(end-1)-1) ) ');']);
    end
  
  
    if (length(QTEMP9) == QTEMP2a(2))
      QmatNMR.TempAxis2Cont = QTEMP9;
      QmatNMR.TempAxis2Cont = QmatNMR.TempAxis2Cont(:).';		%make sure the axis is a row vector
      QmatNMR.UserDefAxisT1Cont = 'QmatNMR.TempAxis2Cont';
  
    else
      if ~(isempty(QTEMP9))
        disp('matNMR WARNING: Length of axis vector for TD1 in the structure not correct. Now using default axis!');
      end
  			      %we set the axis variables to points until the GetDefaultAxis
  			      %routine is called, after which the default axis will be
  			      %correctly plotted. A default axis will however NEVER to saved
  
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
        QTEMP16 = floor(QTEMP2(2)/2)+1;
      end
  
      if isempty(QTEMP14)
        QTEMP14 = 0;
      end
      if isempty(QTEMP15)
        QTEMP15 = 0;
      end
  
      QmatNMR.TempAxis2Cont = GetDefaultAxisDual(QTEMP2(2), QTEMP10, QTEMP11, QTEMP12, QTEMP13, QTEMP14, QTEMP15, QTEMP16);	%recreate a default axis for the current spectrum
      if ~isempty(QTEMP19)	  %coordinates specified?
        QmatNMR.TempAxis2Cont = eval(['QmatNMR.TempAxis2Cont(' QmatNMR.SpecName2D3DProc( (QTEMP19(end-2)+1):(QTEMP19(end-1)-1) ) ');']);
      end
      QmatNMR.TempAxis2Cont = QmatNMR.TempAxis2Cont(:).';		%make sure the axis is a row vector
      QmatNMR.UserDefAxisT1Cont = 'QmatNMR.TempAxis2Cont';
    end
  
  
    %
    %Special cases:
    %
    %-cut spectra contain variables with tick marks and labels in the matNMR structure
    %
    if ExistField(eval(QmatNMR.StructureVar), 'CutSpectrumTicksTD2')
      %
      %set the appropriate flag and read the values of tick marks and labels
      %
      QmatNMR.FlagCutSpectrum = 1;
      QmatNMR.Axis2D3DTD2 = eval([QmatNMR.StructureVar '.AxisTD2;']);
      QmatNMR.Axis2D3DTD1 = eval([QmatNMR.StructureVar '.AxisTD1;']);
      QmatNMR.Spec2D3DCutData.CutSpectrumTicksTD2  = eval([QmatNMR.StructureVar '.CutSpectrumTicksTD2;']);
      QmatNMR.Spec2D3DCutData.CutSpectrumTicksTD1  = eval([QmatNMR.StructureVar '.CutSpectrumTicksTD1;']);
      QmatNMR.Spec2D3DCutData.CutSpectrumPosNaNTD2 = eval([QmatNMR.StructureVar '.CutSpectrumPosNaNTD2;']);
      QmatNMR.Spec2D3DCutData.CutSpectrumPosNaNTD1 = eval([QmatNMR.StructureVar '.CutSpectrumPosNaNTD1;']);
      QmatNMR.Spec2D3DCutData.CutSpectrumAxisTD2   = eval([QmatNMR.StructureVar '.CutSpectrumAxisTD2;']);
      QmatNMR.Spec2D3DCutData.CutSpectrumAxisTD1   = eval([QmatNMR.StructureVar '.CutSpectrumAxisTD1;']);
    end
  
  
  
  %
  %The case where the variable name is 'QmatNMR.Spec2D' (the variable for 2D spectra in the main routine)
  %
  elseif ((QmatNMR.numbvars == 1) & (QmatNMR.numbstructs == 0) & (strcmp(QmatNMR.StructureVar, 'QmatNMR.Spec2D')))			%add the current axes if the spectrum is 'QmatNMR.Spec2D' if the axis isn't in points ...
    QmatNMR.History2D3D = QmatNMR.History;
  
    eval(['QTEMP2 = size(' QmatNMR.StructureVar ');'])
  						%Check whether coordinates have been given
    QTEMP3 = findstr(QmatNMR.SpecName2D3DProc, '(');
    QTEMP20 = findstr(QmatNMR.SpecName2D3DProc, ')');
    QTEMP3 = [QTEMP3(end) QTEMP20(1)];
    if (~isempty(QTEMP3) & (mod(length(QTEMP3), 2) == 0))
      QTEMP20 = findstr(QmatNMR.SpecName2D3DProc( (QTEMP3(1)+1):(QTEMP3(2)-1) ), ',');
      if ~isempty(QTEMP20)
        QTEMP3 = sort([ (QTEMP20+QTEMP3(1)) QTEMP3]);
      else
        QTEMP3 = [];
      end
  
    else
      QTEMP3 = [];
    end
  
    if isempty(QTEMP3)
    		%No coordinates have been specified --> take the current axes of QmatNMR.Spec2D (if it isn't in points)
      if strcmp(QmatNMR.UserDefAxisT2Cont, '')
        QmatNMR.TempAxis1Cont = QmatNMR.AxisTD2;
        QmatNMR.TempAxis1Cont = QmatNMR.TempAxis1Cont(:).';		%make sure the axis is a row vector
        QmatNMR.UserDefAxisT2Cont = 'QmatNMR.TempAxis1Cont';
      end
  
      if strcmp(QmatNMR.UserDefAxisT1Cont, '')
        QmatNMR.TempAxis2Cont = QmatNMR.AxisTD1;
        QmatNMR.TempAxis2Cont = QmatNMR.TempAxis2Cont(:).';		%make sure the axis is a row vector
        QmatNMR.UserDefAxisT1Cont = 'QmatNMR.TempAxis2Cont';
      end
  
    else
      length(QTEMP2)+1
      length(QTEMP3)
      if ~(length(QTEMP3) == length(QTEMP2)+1)
        error('matNMR ERROR: error in coordinates of variable name');
  
      else
    		%Coordinates have been specified --> use them for the axes (if they're not in points)
        if strcmp(QmatNMR.UserDefAxisT2Cont, '')
          eval(['QmatNMR.TempAxis1Cont = QmatNMR.AxisTD2(' QmatNMR.SpecName2D3DProc( (QTEMP3(end-1)+1):(QTEMP3(end)-1) ) ');']);
  	QmatNMR.TempAxis1Cont = QmatNMR.TempAxis1Cont(:).';		%make sure the axis is a row vector
          QmatNMR.UserDefAxisT2Cont = 'QmatNMR.TempAxis1Cont';
        end
  
        if strcmp(QmatNMR.UserDefAxisT1Cont, '')
          eval(['QmatNMR.TempAxis2Cont = QmatNMR.AxisTD1(' QmatNMR.SpecName2D3DProc( (QTEMP3(end-2)+1):(QTEMP3(end-1)-1) ) ');']);
  	QmatNMR.TempAxis2Cont = QmatNMR.TempAxis2Cont(:).';		%make sure the axis is a row vector
          QmatNMR.UserDefAxisT1Cont = 'QmatNMR.TempAxis2Cont';
        end
      end
    end
  
  
  %
  %The case where there is a function as input that generates a matNMR structure
  %
  elseif (isstruct(QmatNMR.Spec2D3D))
    QmatNMR.StructureVar = 'QmatNMR.Spec2D3D';
  
    eval(['QTEMP2 = size(' QmatNMR.StructureVar '.Spectrum);']) 	%the size of the original variable
    if (length(QTEMP2) == 3)
      %
      %extract the axis vector of the 3D from the structure, or generate a generic one
      %
      if ExistField(eval(QmatNMR.StructureVar), 'AxisTD3')
        QmatNMR.TempAxis3Cont = eval([QmatNMR.StructureVar '.AxisTD3']);
  
        if isempty(QmatNMR.TempAxis3Cont)
          QmatNMR.TempAxis3Cont = 1:QTEMP2(1);
        end
  
      else
        QmatNMR.TempAxis3Cont = 1:QTEMP2(1);
      end
  
    else
      %always make a 3-element vector for the size, to avoid problems when indexing into the matrix is applied
      QTEMP2 = [1 QTEMP2];
    end
  
  
    %extract the axis for TD2 if it is saved in the structure
    QTEMP9 = eval([QmatNMR.StructureVar '.AxisTD2']);
    if (length(QTEMP9) == QTEMP2(3))
      QmatNMR.TempAxis1Cont = QTEMP9;
      QmatNMR.TempAxis1Cont = QmatNMR.TempAxis1Cont(:).';		%make sure the axis is a row vector
      QmatNMR.UserDefAxisT2Cont = 'QmatNMR.TempAxis1Cont';
  
    else
      if ~(isempty(QTEMP9))
        disp('matNMR WARNING: Length of axis vector for TD2 in the structure not correct. Now using default axis!');
      end
  			      %we set the axis variables to points until the GetDefaultAxis
  			      %routine is called, after which the default axis will be
  			      %correctly plotted. A default axis will however NEVER to saved
  
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
        QTEMP16 = floor(QTEMP2(3)/2)+1;
      end
  
      if isempty(QTEMP14)
        QTEMP14 = 0;
      end
      if isempty(QTEMP15)
        QTEMP15 = 0;
      end
  
      QmatNMR.TempAxis1Cont = GetDefaultAxisDual(QTEMP2(3), QTEMP10, QTEMP11, QTEMP12, QTEMP13, QTEMP14, QTEMP15, QTEMP16);	%recreate a default axis for the current spectrum
      if ~isempty(QTEMP19)	  %coordinates specified?
        QmatNMR.TempAxis1Cont = eval(['QmatNMR.TempAxis1Cont(' QmatNMR.SpecName2D3DProc( (QTEMP19(end-1)+1):(QTEMP19(end)-1) ) ');']);
      end
      QmatNMR.TempAxis1Cont = QmatNMR.TempAxis1Cont(:).';		%make sure the axis is a row vector
      QmatNMR.UserDefAxisT2Cont = 'QmatNMR.TempAxis1Cont';
    end
  
  
    %extract the axis for TD1 if it is saved in the structure
    QTEMP9 = eval([QmatNMR.StructureVar '.AxisTD1']);
    if (length(QTEMP9) == QTEMP2(2))
      QmatNMR.TempAxis2Cont = QTEMP9;
      QmatNMR.TempAxis2Cont = QmatNMR.TempAxis2Cont(:).';		%make sure the axis is a row vector
      QmatNMR.UserDefAxisT1Cont = 'QmatNMR.TempAxis2Cont';
  
    else
      if ~(isempty(QTEMP9))
        disp('matNMR WARNING: Length of axis vector for TD1 in the structure not correct. Now using default axis!');
      end
  			      %we set the axis variables to points until the GetDefaultAxis
  			      %routine is called, after which the default axis will be
  			      %correctly plotted. A default axis will however NEVER to saved
  
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
        QTEMP16 = floor(QTEMP2(2)/2)+1;
      end
  
      if isempty(QTEMP14)
        QTEMP14 = 0;
      end
      if isempty(QTEMP15)
        QTEMP15 = 0;
      end
  
      QmatNMR.TempAxis2Cont = GetDefaultAxisDual(QTEMP2(2), QTEMP10, QTEMP11, QTEMP12, QTEMP13, QTEMP14, QTEMP15, QTEMP16);	%recreate a default axis for the current spectrum
      if ~isempty(QTEMP19)	  %coordinates specified?
        QmatNMR.TempAxis2Cont = eval(['QmatNMR.TempAxis2Cont(' QmatNMR.SpecName2D3DProc( (QTEMP19(end-2)+1):(QTEMP19(end-1)-1) ) ');']);
      end
      QmatNMR.TempAxis2Cont = QmatNMR.TempAxis2Cont(:).';		%make sure the axis is a row vector
      QmatNMR.UserDefAxisT1Cont = 'QmatNMR.TempAxis2Cont';
    end
  
  
    %
    %Special cases:
    %
    %-cut spectra contain variables with tick marks and labels in the matNMR structure
    %
    if ExistField(eval(QmatNMR.StructureVar), 'CutSpectrumTicksTD2')
      %
      %set the appropriate flag and read the values of tick marks and labels
      %
      QmatNMR.FlagCutSpectrum = 1;
      QmatNMR.Spec2D3DCutData.CutSpectrumTicksTD2  = eval([QmatNMR.StructureVar '.CutSpectrumTicksTD2;']);
      QmatNMR.Spec2D3DCutData.CutSpectrumTicksTD1  = eval([QmatNMR.StructureVar '.CutSpectrumTicksTD1;']);
      QmatNMR.Spec2D3DCutData.CutSpectrumPosNaNTD2 = eval([QmatNMR.StructureVar '.CutSpectrumPosNaNTD2;']);
      QmatNMR.Spec2D3DCutData.CutSpectrumPosNaNTD1 = eval([QmatNMR.StructureVar '.CutSpectrumPosNaNTD1;']);
      QmatNMR.Spec2D3DCutData.CutSpectrumAxisTD2   = eval([QmatNMR.StructureVar '.CutSpectrumAxisTD2;']);
      QmatNMR.Spec2D3DCutData.CutSpectrumAxisTD1   = eval([QmatNMR.StructureVar '.CutSpectrumAxisTD1;']);
    end
    
    
    %
    %Finally, define the spectrum
    %
    QmatNMR.Spec2D3D = squeeze(QmatNMR.Spec2D3D.Spectrum);
  
  
  %
  %In all other cases
  %
  else
    QmatNMR.History2D3D = str2mat(['Name (in 2D/3D Viewer) : ' QmatNMR.SpecName2D3D], 'No processing history available!');
    QmatNMR.ContSpecHistoryMacro = AddToMacro;
  
    if isempty(QmatNMR.UserDefAxisT2Cont)
      QmatNMR.TempAxis1Cont = [];
    else
      QmatNMR.TempAxis1Cont = eval(QmatNMR.UserDefAxisT2Cont);
      QmatNMR.TempAxis1Cont = QmatNMR.TempAxis1Cont(:).';		%make sure the axis is a row vector
    end
  
    if isempty(QmatNMR.UserDefAxisT1Cont)
      QmatNMR.TempAxis2Cont = [];
    else
      QmatNMR.TempAxis2Cont = eval(QmatNMR.UserDefAxisT1Cont);
      QmatNMR.TempAxis2Cont = QmatNMR.TempAxis2Cont(:).';		%make sure the axis is a row vector
    end
  end
  
  
  %
  %finally, check that the norm of the spectrum is not very small as this is problematic in Matlab
  %
  if (ndims(QmatNMR.Spec2D3D) == 2)
    [QTEMP21, QTEMP22] = size(QmatNMR.Spec2D3D);
    if ~sum(sum(isnan(QmatNMR.Spec2D3D)))
      try
        %we only test the norm if the matrix is finite, because otherwise the norm routine complains
        if (norm(QmatNMR.Spec2D3D(1:ceil(QTEMP21/128):QTEMP21, 1:ceil(QTEMP22/128):QTEMP22)) < eps^2)
          beep
          disp('matNMR WARNING');
          disp('matNMR WARNING: the spectrum appears to have a very small norm, which may be a cause of problems in Matlab!');
          disp('matNMR WARNING');
        end
      catch
      end
    end
  end
  
  clear QTEMP*
  
  
  
    if isstruct(QmatNMR.Spec2D3D)
      try
        QmatNMR.Spec2D3D = QmatNMR.Spec2D3D.Spectrum;
  
        size( QmatNMR.Spec2D3D)
      catch
        disp('matNMR WARNING: specified input produced a structure that cannot be read by matNMR. Aborting ...');
      end
    end

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
