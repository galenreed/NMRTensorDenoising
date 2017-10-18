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
%regelnormalizevariables.m normalizes a series of variables and saves each
%variable in the workspace under its original name
%
%02-07-'04

%try
  if QmatNMR.buttonList == 1
    %
    %process input
    %
    QmatNMR.AddVariablesCommonString = QmatNMR.uiInput1;
    QmatNMR.NormalizeVariablesFlag = QmatNMR.uiInput2;

  
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

  
    if (QmatNMR.NormalizeVariablesFlag == 1) 	%normalize to same maximum -> use first variable in range
      %
      %first determine the maximum of the first variable
      %
      if isa(eval(strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(1), 10))), 'struct')  %yes it is a structure
        eval(['QTEMP10 = max(max(real(' strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(1), 10)) '.Spectrum)));']);
      else  			       %no it isn't
        eval(['QTEMP10 = max(max(real(' strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(1), 10)) ')));']);
      end
    
      %
      %Then change all other variables
      %
      for QTEMP = 2:length(QmatNMR.AddVariablesRange)
        if isa(eval(strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(QTEMP), 10))), 'struct')  %yes it is a structure
          eval(['QTEMP11 = max(max(real(' strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(QTEMP), 10)) '.Spectrum)));']);
          eval([strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(QTEMP), 10)) '.Spectrum = ' strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(QTEMP), 10)) '.Spectrum * (QTEMP10/QTEMP11);']);
        else  			       %no it isn't
          eval(['QTEMP11 = max(max(real(' strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(QTEMP), 10)) ')));']);
          eval([strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(QTEMP), 10)) ' = ' strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(QTEMP), 10)) ' * (QTEMP10/QTEMP11);']);
        end
      end
      
      disp(['Series of variables has been renormalized to equal maximum.']);
  
  
    elseif (QmatNMR.NormalizeVariablesFlag == 2) 	%normalize to same integral -> use first variable in range
      %
      %first determine the maximum of the first variable
      %
      if isa(eval(strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(1), 10))), 'struct')  %yes it is a structure
        eval(['QTEMP10 = sum(sum(real(' strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(1), 10)) '.Spectrum)));']);
      else  			       %no it isn't
        eval(['QTEMP10 = sum(sum(real(' strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(1), 10)) ')));']);
      end
    
      %
      %Then change all other variables
      %
      for QTEMP = 2:length(QmatNMR.AddVariablesRange)
        if isa(eval(strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(QTEMP), 10))), 'struct')  %yes it is a structure
          eval(['QTEMP11 = sum(sum(real(' strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(QTEMP), 10)) '.Spectrum)));']);
          eval([strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(QTEMP), 10)) '.Spectrum = ' strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(QTEMP), 10)) '.Spectrum * (QTEMP10/QTEMP11);']);
        else  			       %no it isn't
          eval(['QTEMP11 = sum(sum(real(' strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(QTEMP), 10)) ')));']);
          eval([strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(QTEMP), 10)) ' = ' strrep(QmatNMR.AddVariablesCommonString, QTEMP61, num2str(QmatNMR.AddVariablesRange(QTEMP), 10)) ' * (QTEMP10/QTEMP11);']);
        end
      end
      
      disp(['Series of variables has been renormalized to equal integral.']);
    end
  
  else
    disp('Renormalizing series of variables was cancelled ...');
  end  
  
  clear QTEMP*

%catch
%
%call the generic error handler routine if anything goes wrong
%
%  errorhandler
%end
