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
%
%CheckConversionOptionsFile checks to see if conversion to the new format for the matnmroptions.mat file is needed
%if so, the file is converted and stored on disk
%
%11-10-'06
%

try
  %
  %load the options file into a variable
  %
  QTEMP1 = load(QmatNMR.matnmrpath);
  
  %
  %first check to see if the options file follows the new format
  %
  if ~isfield(QTEMP1, 'QmatNMRsettings')
    %
    %old options file, which needs updating
    %
    disp('matNMR NOTICE: old options file detected. Please wait while matNMR updates the file ...')
    
    %first generate a correct settings variable QmatNMRsettings
    SetOptions
    
    %then put existing settings into the variable QmatNMRsettings
    load(QmatNMR.matnmrpath);
    QTEMP2 = fieldnames(QTEMP1);
    for QTEMP3 = 1:length(QTEMP2)
      QTEMP4 = QTEMP2(QTEMP3);	%cell array
      QTEMP4 = QTEMP4{1}; 	%char array
      if strcmp(QTEMP4(1:2), 'Q1') | strcmp(QTEMP4(1:2), 'Q2')
        eval(['QmatNMRsettings.' QTEMP4 ' = ' QTEMP4 ';'])
      else
        eval(['QmatNMRsettings.' QTEMP4(2:end) ' = ' QTEMP4 ';'])
      end
      eval(['clear ' QTEMP4]);
    end
    
    %store the new options file
    saveoptions
  end
  
  
  %
  %then check to see if the options variable has the right size, if not then merge 
  %all useful parameters from disk with a correct set and resave the options
  %
  QTEMP1 = load(QmatNMR.matnmrpath);
  if (length(fieldnames(QmatNMRsettings)) ~= length(fieldnames(QTEMP1.QmatNMRsettings)))
    disp('matNMR NOTICE: incorrect options file detected. Please wait while matNMR tries to correct the file ...')
    QTEMP2 = fieldnames(QmatNMRsettings);
    for QTEMP3 = 1:length(fieldnames(QmatNMRsettings))
      QTEMP4 = QTEMP2(QTEMP3);
      QTEMP4 = QTEMP4{1};		%convert from cell to char
      
      if isfield(QmatNMRsettings, QTEMP4) & isfield(QTEMP1.QmatNMRsettings, QTEMP4)
        eval(['QmatNMRsettings.' QTEMP4 ' = QTEMP1.QmatNMRsettings.' QTEMP4 ';']);
      end
    end
    
    %store the new options file
    saveoptions
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
