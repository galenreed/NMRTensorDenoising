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
%regeleditreference.m deals with editing variables in the workspace which contain external 
%spectral references.
%29-09-'04

try
  if (QmatNMR.buttonList == 1)
    QmatNMR.ExternalReferenceVar = QmatNMR.uiInput1;
    
    if isempty(QmatNMR.ExternalReferenceVar)
      disp('Editing of external reference values cancelled ...');
  
    else
      QTEMP1 = eval(QmatNMR.ExternalReferenceVar);
  
      %
      %check whether the specified variable is a structure and if so, whether it is a matNMR structure
      %
      if ~isstruct(QTEMP1)
        disp('matNMR ERROR: variable does not have the proper structure for an external reference. Aborting ...');
        return
        
      elseif isfield(QTEMP1, 'DefaultAxisReference') 	%is the input a matNMR structure with a default-axis reference?
        QTEMP1 = QTEMP1.DefaultAxisReference;
      end
  
      %
      %Finally we check whether the specified variable contains the necessary fields
      %
      if (~isfield(QTEMP1, 'ReferenceFrequency') | ~isfield(QTEMP1, 'ReferenceValue') | ~isfield(QTEMP1, 'ReferenceUnit'))
        disp('matNMR ERROR: variable does not have the proper structure for an external reference. Aborting ...');
      
      else
        %define the values for the external reference
        QmatNMR.ExternalReferenceFreq  = QTEMP1.ReferenceFrequency;
        QmatNMR.ExternalReferenceValue = QTEMP1.ReferenceValue;
        QmatNMR.ExternalReferenceUnit  = QTEMP1.ReferenceUnit;
        QmatNMR.BusyWithExternalRef = 1; 		%this flag will be interpreted in askdefinereference such that no variable will be supplied to save in
        
        %feed these values into the routine for defining external references manually
        askdefinereference
      end
    end
  
  else
    disp('Editing of external reference values cancelled ...');
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
