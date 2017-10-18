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
%regelconcatenatevariables.m concatenates a series of variables and saves each
%variable in the workspace under a new name
%
%02-07-'04

try
  if QmatNMR.buttonList == 1
    %
    %process input
    %
    QmatNMR.AddVariablesCommonString = QmatNMR.uiInput1;
    QmatNMR.ConcatenateDirection = QmatNMR.uiInput2;
    QmatNMR.AddVariablesNewName = QmatNMR.uiInput3;
    QmatNMR.AddVariablesRetain = QmatNMR.uiInput4;
    QmatNMR.LoadINTOmatNMRDirectly = QmatNMR.uiInput5;

  
    %
    %Extract and check the ranges first
    %
    QTEMP2 = findstr(QmatNMR.AddVariablesCommonString, '$');
    QTEMP61 = QmatNMR.AddVariablesCommonString( (QTEMP2(1)):(QTEMP2(2)) );

    if (length(QTEMP2) ~= 2)
      beep
      disp('matNMR WARNING: incorrect $range$ syntax for manipulating series. Aborting ...');
      return
    end

    %
    %Define the entire range of variables
    %
    try
      QmatNMR.AddVariablesRange = eval(QmatNMR.AddVariablesCommonString( (QTEMP2(1)+1):(QTEMP2(2)-1) ));
    end
  
  
    %
    %Determine the sizes for all variables
    %
    QTEMP11 = zeros(length(QmatNMR.AddVariablesRange), 2);
    for QTEMP = 1:length(QmatNMR.AddVariablesRange)
      if isa(eval(strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(QTEMP), 10))), 'struct')  %yes it is a structure
        eval(['QTEMP11(QTEMP, :) = size(' strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(QTEMP), 10)) '.Spectrum);']);
      else
        eval(['QTEMP11(QTEMP, :) = size(' strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(QTEMP), 10)) ');']);
      end
    end
    
  
    %
    %act depending on the direction of concatenation
    %
    if (QmatNMR.ConcatenateDirection == 1)	%concatenate along TD2
      %
      %first set the new variable equal to the first variable in the range
      %
      if isa(eval(strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(1), 10))), 'struct')  %yes it is a structure
        if (QmatNMR.AddVariablesRetain)
          QTEMP10 = 1; 	%flag for whether the new variable is a structure or not
          eval([QmatNMR.AddVariablesNewName ' = ' strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(1), 10)) ';']);
        else
          QTEMP10 = 0; 	%flag for whether the new variable is a structure or not
          eval([QmatNMR.AddVariablesNewName ' = ' strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(1), 10)) '.Spectrum;']);
        end
      else  			       %no it isn't
        QTEMP10 = 0; 	%flag for whether the new variable is a structure or not
        eval([QmatNMR.AddVariablesNewName ' = ' strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(1), 10)) ';']);
      end
  %
  %NOTE: The first variable determine whether the output is a structure or not! This is reflected by the flag QTEMP10
  %
  
      %
      %Then resize the matrix size
      %
      if (sum(abs(diff(QTEMP11(:,1)))) > 1e-10)
        beep
        disp('matNMR WARNING: spectra of unequal length in TD1 cannot be concatenated along TD2! Aborting ...')
        return
      end
      
      QTEMP12 = QTEMP11(:, 2);    %size TD2
      QTEMP11 = QTEMP11(1, 1);    %size TD1
      
      if (QTEMP10 == 1)	%new variable is a structure
        eval(['QTEMP = ' QmatNMR.AddVariablesNewName '.Spectrum;']);
        eval([QmatNMR.AddVariablesNewName '.Spectrum = zeros(QTEMP11, sum(QTEMP12));']);
        eval([QmatNMR.AddVariablesNewName '.Spectrum(:, 1:QTEMP12(1)) = QTEMP;']);

        eval([QmatNMR.AddVariablesNewName '.History = str2mat('''', ''Processing History :'', '''', [''Name of the variable          :  ' QmatNMR.uiInput4 ''']);']);
        eval([QmatNMR.AddVariablesNewName '.History = str2mat(' QmatNMR.AddVariablesNewName '.History, [''Dataset was generated by concatenating along TD2 of datasets "' QmatNMR.AddVariablesCommonString '" with Range ' QmatNMR.uiInput2 ''']);']);
        QTEMP = clock;
        QTEMP1 = sprintf('%.0f',QTEMP(4)+100);
        QTEMP2 = sprintf('%.0f',QTEMP(5)+100);
        eval([QmatNMR.AddVariablesNewName '.History = str2mat(' QmatNMR.AddVariablesNewName '.History, [''Processed on ' date ' at ' QTEMP1(2:3) ':' QTEMP2(2:3) ''']);']);
        eval([QmatNMR.AddVariablesNewName '.History = str2mat(' QmatNMR.AddVariablesNewName '.History, [''size of the new 2D ' deblank(QmatNMR.Temp(QmatNMR.FIDstatus, :)) ' is     :  ', num2str(QTEMP11), ' x ', num2str(sum(QTEMP12)), ' points (td1 x td2).'']);']);
  
      else
        eval(['QTEMP = ' QmatNMR.AddVariablesNewName ';']);
        eval([QmatNMR.AddVariablesNewName ' = zeros(QTEMP11, sum(QTEMP12));']);
        eval([QmatNMR.AddVariablesNewName '(:, 1:QTEMP12(1)) = QTEMP;']);
      end
        
  
      %
      %Then change all other variables
      %
      for QTEMP = 2:length(QmatNMR.AddVariablesRange)
        %is this variable in the range a structure?
        if isa(eval(strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(QTEMP), 10))), 'struct')  %yes it is a structure
          if (QTEMP10) 	%new variable is a structure
            eval([QmatNMR.AddVariablesNewName '.Spectrum(:, sum(QTEMP12(1:(QTEMP-1))) + (1:QTEMP12(QTEMP))) = ' strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(QTEMP), 10)) '.Spectrum;']);
          else  			       %no it isn't
            eval([QmatNMR.AddVariablesNewName '(:, sum(QTEMP12(1:(QTEMP-1))) + (1:QTEMP12(QTEMP))) = ' strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(QTEMP), 10)) '.Spectrum;']);
          end
    
        else
          if (QTEMP10) 	%new variable is a structure
            eval([QmatNMR.AddVariablesNewName '.Spectrum(:, sum(QTEMP12(1:(QTEMP-1))) + (1:QTEMP12(QTEMP))) = ' strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(QTEMP), 10)) ';']);
          else  			       %no it isn't
            eval([QmatNMR.AddVariablesNewName '(:, sum(QTEMP12(1:(QTEMP-1))) + (1:QTEMP12(QTEMP))) = ' strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(QTEMP), 10)) ';']);
          end
        end
      end
  
  
      %
      %add variable name to list of last-used 2D variables
      %
      QmatNMR.newinlist.Spectrum = QmatNMR.AddVariablesNewName;	%define the name of the variable and axis vector
      QmatNMR.newinlist.AxisTD2 = '';	%for putinlist2d.m
      QmatNMR.newinlist.AxisTD1 = '';
      putinlist2d;			%put name in list of last 10 variables if it is new
      
      
      %
      %if asked for load the variable directly into matNMR
      %
      if (QmatNMR.LoadINTOmatNMRDirectly)
        %
        %load the new FID into matNMR
        %
        disp(['Loading the FID into matNMR ...']);
    
        QmatNMR.uiInput1 = QmatNMR.AddVariablesNewName;
        QmatNMR.uiInput2 = '';
        QmatNMR.uiInput3 = '';
          
        %
        %automatically load this variable as an FID into matNMR
        %
        QmatNMR.ask = 2;
        QmatNMR.buttonList = 1;
        regelnaam
      end
      
  
      disp(['Series of variables has been concatenated and saved in the workspace as ' QmatNMR.AddVariablesNewName]);
  
    elseif (QmatNMR.ConcatenateDirection == 2)	%concatenate along TD1
      %
      %first set the new variable equal to the first variable in the range
      %
      if isa(eval(strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(1), 10))), 'struct')  %yes it is a structure
        if (QmatNMR.AddVariablesRetain)
          QTEMP10 = 1; 	%flag for whether the new variable is a structure or not
          eval([QmatNMR.AddVariablesNewName ' = ' strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(1), 10)) ';']);
        else
          QTEMP10 = 0; 	%flag for whether the new variable is a structure or not
          eval([QmatNMR.AddVariablesNewName ' = ' strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(1), 10)) '.Spectrum;']);
        end
      else  			       %no it isn't
        QTEMP10 = 0; 	%flag for whether the new variable is a structure or not
        eval([QmatNMR.AddVariablesNewName ' = ' strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(1), 10)) ';']);
      end
  
  
      %
      %Then resize the matrix size and perform safety check
      %
      if (sum(abs(diff(QTEMP11(:,2)))) > 1e-10)
        beep
        disp('matNMR WARNING: spectra of unequal length in TD2 cannot be concatenated along TD1! Aborting ...')
        return
      end
      
      QTEMP12 = QTEMP11(1, 2);    %size TD2
      QTEMP11 = QTEMP11(:, 1);    %size TD1
      
      if (QTEMP10 == 1)	%new variable is a structure
        eval(['QTEMP = ' QmatNMR.AddVariablesNewName '.Spectrum;']);
        eval([QmatNMR.AddVariablesNewName '.Spectrum = zeros(sum(QTEMP11), QTEMP12);']);
        eval([QmatNMR.AddVariablesNewName '.Spectrum(1:QTEMP11(1), :) = QTEMP;']);

        eval([QmatNMR.AddVariablesNewName '.History = str2mat('''', ''Processing History :'', '''', [''Name of the variable          :  ' QmatNMR.uiInput4 ''']);']);
        eval([QmatNMR.AddVariablesNewName '.History = str2mat(' QmatNMR.AddVariablesNewName '.History, [''Dataset was generated by concatenating along TD1 of datasets "' QmatNMR.AddVariablesCommonString '" with Range ' QmatNMR.uiInput2 ''']);']);
        QTEMP = clock;
        QTEMP1 = sprintf('%.0f',QTEMP(4)+100);
        QTEMP2 = sprintf('%.0f',QTEMP(5)+100);
        eval([QmatNMR.AddVariablesNewName '.History = str2mat(' QmatNMR.AddVariablesNewName '.History, [''Processed on ' date ' at ' QTEMP1(2:3) ':' QTEMP2(2:3) ''']);']);
        eval([QmatNMR.AddVariablesNewName '.History = str2mat(' QmatNMR.AddVariablesNewName '.History, [''size of the new 2D ' deblank(QmatNMR.Temp(QmatNMR.FIDstatus, :)) ' is     :  ', num2str(sum(QTEMP11)), ' x ', num2str(QTEMP12), ' points (td1 x td2).'']);']);

      else
        eval(['QTEMP = ' QmatNMR.AddVariablesNewName ';']);
        eval([QmatNMR.AddVariablesNewName ' = zeros(sum(QTEMP11), QTEMP12);']);
        eval([QmatNMR.AddVariablesNewName '(1:QTEMP11(1), :) = QTEMP;']);
      end
        
  
      %
      %Then change all other variables
      %
      for QTEMP = 2:length(QmatNMR.AddVariablesRange)
        %is this variable in the range a structure?
        if isa(eval(strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(QTEMP), 10))), 'struct')  %yes it is a structure
          if (QTEMP10) 	%new variable is a structure
            eval([QmatNMR.AddVariablesNewName '.Spectrum( sum(QTEMP11(1:(QTEMP-1))) + (1:QTEMP11(QTEMP)), :) = ' strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(QTEMP), 10)) '.Spectrum;']);
          else  			       %no it isn't
            eval([QmatNMR.AddVariablesNewName '( sum(QTEMP11(1:(QTEMP-1))) + (1:QTEMP11(QTEMP)), :) = ' strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(QTEMP), 10)) '.Spectrum;']);
          end
    
        else
          if (QTEMP10) 	%new variable is a structure
            eval([QmatNMR.AddVariablesNewName '.Spectrum( sum(QTEMP11(1:(QTEMP-1))) + (1:QTEMP11(QTEMP)), :) = ' strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(QTEMP), 10)) ';']);
          else  			       %no it isn't
            eval([QmatNMR.AddVariablesNewName '( sum(QTEMP11(1:(QTEMP-1))) + (1:QTEMP11(QTEMP)), :) = ' strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(QTEMP), 10)) ';']);
          end
        end
      end
  
  
      %
      %add variable name to list of last-used 2D variables
      %
      QmatNMR.newinlist.Spectrum = QmatNMR.AddVariablesNewName;	%define the name of the variable and axis vector
      QmatNMR.newinlist.AxisTD2 = '';	%for putinlist2d.m
      QmatNMR.newinlist.AxisTD1 = '';
      putinlist2d;			%put name in list of last 10 variables if it is new
      
      
      %
      %if asked for load the variable directly into matNMR
      %
      if (QmatNMR.LoadINTOmatNMRDirectly)
        %
        %load the new FID into matNMR
        %
        disp(['Loading the FID into matNMR ...']);
    
        QmatNMR.uiInput1 = QmatNMR.AddVariablesNewName;
        QmatNMR.uiInput2 = '';
        QmatNMR.uiInput3 = '';
          
        %
        %automatically load this variable as an FID into matNMR
        %
        QmatNMR.ask = 2;
        QmatNMR.buttonList = 1;
        regelnaam
      end
      
  
      disp(['Series of variables has been concatenated and saved in the workspace as ' QmatNMR.AddVariablesNewName]);
  
    else		%concatenate along 3rd dimension
      %
      %first create a new 3D matrix of the correct size
      %
      if (sum(abs(diff(QTEMP11(:,1)))) > 1e-10) | (sum(abs(diff(QTEMP11(:,2)))) > 1e-10)
        beep
        disp('matNMR WARNING: spectra of unequal length cannot be concatenated along a third dimension! Aborting ...')
        return
      end
      
      QTEMP12 = QTEMP11(1, 2); 	%size TD2
      QTEMP11 = QTEMP11(1, 1); 	%size TD1
  
  
      QTEMP10 = length(QmatNMR.AddVariablesRange);	%size in 3rd dimension
      if isa(eval(strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(1), 10))), 'struct')  %yes it is a structure
        if (QmatNMR.AddVariablesRetain)
          eval([QmatNMR.AddVariablesNewName ' = ' strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(1), 10)) ';']);
  	  eval([QmatNMR.AddVariablesNewName '.Spectrum = zeros(QTEMP10, QTEMP11, QTEMP12);']);
          eval([QmatNMR.AddVariablesNewName '.History = [''Dataset was generated by concatenating along the 3rd dimension of datasets "' QmatNMR.AddVariablesCommonString '" with Range ' QmatNMR.uiInput2 '''];']);

          eval([QmatNMR.AddVariablesNewName '.History = str2mat('''', ''Processing History :'', '''', [''Name of the variable          :  ' QmatNMR.uiInput4 ''']);']);
          eval([QmatNMR.AddVariablesNewName '.History = str2mat(' QmatNMR.AddVariablesNewName '.History, [''Dataset was generated by concatenating along the 3rd dimension of datasets "' QmatNMR.AddVariablesCommonString '" with Range ' QmatNMR.uiInput2 ''']);']);
          QTEMP = clock;
          QTEMP1 = sprintf('%.0f',QTEMP(4)+100);
          QTEMP2 = sprintf('%.0f',QTEMP(5)+100);
          eval([QmatNMR.AddVariablesNewName '.History = str2mat(' QmatNMR.AddVariablesNewName '.History, [''Processed on ' date ' at ' QTEMP1(2:3) ':' QTEMP2(2:3) ''']);']);
          eval([QmatNMR.AddVariablesNewName '.History = str2mat(' QmatNMR.AddVariablesNewName '.History, [''size of the new 2D ' deblank(QmatNMR.Temp(QmatNMR.FIDstatus, :)) ' is     :  ', num2str(QTEMP10), ' x ', num2str(QTEMP11), ' x ', num2str(QTEMP12), ' points (td3 x td1 x td2).'']);']);

          QTEMP10 = 1;	%set flag for new variable as structure
        else
          eval([QmatNMR.AddVariablesNewName ' = zeros(QTEMP10, QTEMP11, QTEMP12);']);
  	QTEMP10 = 0;	%set flag for new variable not being a structure
        end  
  
      else  			       %no it isn't
        eval(['[QTEMP11, QTEMP12] = size(' strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(1), 10)) ');']);
        eval([QmatNMR.AddVariablesNewName ' = zeros(QTEMP10, QTEMP11, QTEMP12);']);
        QTEMP10 = 0;	%set flag for new variable not being a structure
      end
  
      %
      %Then change all other variables
      %
      for QTEMP = 1:length(QmatNMR.AddVariablesRange)
        %is this variable in the range a structure?
        if isa(eval(strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(QTEMP), 10))), 'struct')  %yes it is a structure
          if (QTEMP10)	%is new variable a structure?
            eval([QmatNMR.AddVariablesNewName '.Spectrum(QTEMP, :, :) = ' strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(QTEMP), 10)) '.Spectrum;']);
          else
            eval([QmatNMR.AddVariablesNewName '(QTEMP, :, :) = ' strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(QTEMP), 10)) '.Spectrum;']);
          end  
  
        else
          if (QTEMP10)	%is new variable a structure?
            eval([QmatNMR.AddVariablesNewName '.Spectrum(QTEMP, :, :) = ' strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(QTEMP), 10)) ';']);
          else
            eval([QmatNMR.AddVariablesNewName '(QTEMP, :, :) = ' strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(QTEMP), 10)) ';']);
          end  
        end
      end
  
  
      %
      %add variable name to list of last-used 3D variables
      %
      QmatNMR.newinlist.Spectrum = QmatNMR.AddVariablesNewName;	%define the name of the variable and axis vector
      QmatNMR.newinlist.AxisTD2 = '';	%for putinlist3d.m
      QmatNMR.newinlist.AxisTD1 = '';
      putinlist3d;			%put name in list of last 10 variables if it is new
      
      
      %
      %if asked for load the variable directly into matNMR
      %
      if (QmatNMR.LoadINTOmatNMRDirectly)
        %
        %load the new FID into matNMR
        %
        disp(['Loading the FID into matNMR ...']);
    
        QmatNMR.uiInput1 = QmatNMR.AddVariablesNewName;
        QmatNMR.uiInput2 = '';
        QmatNMR.uiInput3 = '';
          
        %
        %automatically load this variable as an FID into matNMR
        %
        QmatNMR.ask = 3;
        QmatNMR.buttonList = 1;
        regelnaam
      end
      
  
      disp(['Series of variables has been concatenated into a 3D and saved in the workspace as ' QmatNMR.AddVariablesNewName]);
    end
  
  else
    disp('Concatenating series of variables was cancelled ...');
  end  
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
