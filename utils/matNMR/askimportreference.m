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
%askimportreference allows importing reference settings from external datasets into matNMR.
%This means the default axis does not have a value of 0 for PPM or hZ anymore.
%This routine asks for the directory in which the dataset is written which contains the
%reference values, after which an input window will appear that asks for the spectrometer
%format.
%
%26-07-2004

try
  if (((QmatNMR.Dim == 0) & (QmatNMR.RulerXAxis == 1)) | ((QmatNMR.Dim) & (QmatNMR.RulerXAxis1) & (QmatNMR.RulerXAxis2)))
    disp('matNMR NOTICE: spectral references can only be imported when using the default axis! Aborting ...');
    return  
  
  elseif ((QmatNMR.Dim) & (QmatNMR.RulerXAxis1 | QmatNMR.RulerXAxis2))
    disp('matNMR NOTICE: the spectral reference will only apply to dimensions which are in default axis mode!');
  end
  
  QmatNMR.Xpath = uigetdirBackup(pwd, 'Choose new directory');
  
  
  %
  %open the input window
  %
  if (QmatNMR.Xpath)
    QuiInput('Read external reference from disk :', 'OK | CANCEL', 'regelimportreference', [], ...
             'Directory : ', QmatNMR.Xpath, ...
             '&POFile Format : | XWinNMR/TopSpin (Bruker) | Spinsight (Chemagnetics) | winNMR (Bruker) | UXNMR (Bruker) ', QmatNMR.DataFormat, ...
             'Save external reference in workspace (optional)', QmatNMR.ExternalReferenceVar);
  
  else
    disp('Importing of external reference values cancelled ...');
  end

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
