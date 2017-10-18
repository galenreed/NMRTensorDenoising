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
%regelconnecttoFID.m handles the connection of the current History to an FID variable in the
%workspace.
%
%22-03-'99

try
  if (QmatNMR.buttonList == 1)
    watch
  
    QTEMP1 = QmatNMR.uiInput1;
    QTEMP2 = eval(QTEMP1);
    if (exist(QTEMP1) == 1)	%variable exists in the workspace
      if ~isstruct(QTEMP2)
        %first generate a generic matNMR structure
        eval([QTEMP1 '= GenerateMatNMRStructure;']);
        eval([QTEMP1 '.Spectrum = QTEMP2;']);
      else  
        eval([QTEMP1 '.Spectrum = QTEMP2.Spectrum;']);
      end  
      eval([QTEMP1 '.History = [];']);
      eval([QTEMP1 '.HistoryMacro = QmatNMR.HistoryMacro;']);
      eval([QTEMP1 '.AxisTD2 = [];']);
      eval([QTEMP1 '.AxisTD1 = [];']);
      eval([QTEMP1 '.FIDstatusTD2 = 2;']);
      eval([QTEMP1 '.FIDstatusTD1 = 2;']);
      eval([QmatNMR.uiInput1 '.Hypercomplex = [];']);
      eval([QmatNMR.uiInput1 '.PeakListNums = [];']);
      eval([QmatNMR.uiInput1 '.PeakListText = [];']);
      
      %
      %Finally add the current 1D or 2D external reference values, just in case
      %
      if (QmatNMR.Dim == 0)		%1D
        eval([QmatNMR.uiInput1 '.DefaultAxisReference = QmatNMRsettings.DefaultAxisReference1D;']);
  
      else 			%2D
        eval([QmatNMR.uiInput1 '.DefaultAxisReference = QmatNMRsettings.DefaultAxisReference2D;']);
      end      
      
      disp(['Current processing history connected to the FID variable ' QTEMP1]);   
    else
      error('matNMR ERROR: variable name does not exists!');
    end
    
    Arrowhead
  else
    disp('Connection of the history to an FID variable cancelled ...');
  end  
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
