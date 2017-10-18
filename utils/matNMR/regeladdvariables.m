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
%regeladdvariables.m adds a series of FID/spectra and saves the total in a new
%variable in the workspace
%
%23-03-'99

try
  if QmatNMR.buttonList == 1
    %
    %process input
    %
    QmatNMR.AddVariablesCommonString = QmatNMR.uiInput1;
    QmatNMR.AddVariablesNewName = QmatNMR.uiInput2;
    QmatNMR.AddVariablesRetain = QmatNMR.uiInput3;
    QmatNMR.AddVariablesNormalize = QmatNMR.uiInput4;
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

    try
      QmatNMR.AddVariablesRange = eval(QmatNMR.AddVariablesCommonString( (QTEMP2(1)+1):(QTEMP2(2)-1) ));
    end


    %
    %add series of variables, after making all variables global
    %
    eval(['global ' QmatNMR.AddVariablesNewName]);
    for QTEMP = 1:length(QmatNMR.AddVariablesRange)
      eval(['global ' strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(QTEMP), 10))]);
    end
    eval([QmatNMR.AddVariablesNewName ' = addvariables2(''' QmatNMR.AddVariablesCommonString ''',' num2str(QmatNMR.AddVariablesRetain) ',' num2str(QmatNMR.AddVariablesNormalize) ');']);
  
    %
    %test whether the variable is not empty, if so produce warning message
    %
    QTEMP9 = eval(QmatNMR.AddVariablesNewName);
    if isempty(QTEMP9)
      disp('matNMR WARNING: empty variable resulted from adding operation. Aborted ...');
      return
    end
    
    %
    %Put the name in the list of last 10 spectra if it is new.
    %
    %first determine whether the new variable is a 1D or a 2D, by looking at its domain sizes
    if isstruct(QTEMP9)
      [QTEMP10, QTEMP11] = size(QTEMP9.Spectrum);
    else
      [QTEMP10, QTEMP11] = size(QTEMP9);
    end
    
    %now add to the corresponding list
    if ((QTEMP10 == 1) | (QTEMP11 == 1))
      %1D
      QmatNMR.newinlist.Spectrum = QmatNMR.AddVariablesNewName;	%define the name of the variable and axis vector
      QmatNMR.newinlist.Axis = '';			%for putinlist1d.m
      putinlist1d;				%put name in list of last 10 variables if it is new
  
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
        QmatNMR.ask = 1;
        QmatNMR.buttonList = 1;
        regelnaam
      end
  
    else
      %2D
      QmatNMR.newinlist.Spectrum = QmatNMR.AddVariablesNewName;	%define the name of the variable and axis vector
      QmatNMR.newinlist.AxisTD2 = '';			%for putinlist2d.m
      QmatNMR.newinlist.AxisTD1 = '';
      putinlist2d;				%put name in list of last 10 variables if it is new
  
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
    end
    
    disp(['Series of variables has been added and saved in the workspace as ' QmatNMR.AddVariablesNewName '.']);
  
  else
    disp('Adding series of variables was cancelled ...');
  end  
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
