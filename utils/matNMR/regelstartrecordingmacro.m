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
%regelstartrecordingmacro.m is run when starting to record a macro 
%only a flag is set and an empty Macro is created.
%24-03-'99

try
  if QmatNMR.lbstatus | QmatNMR.bezigmetfase
    disp('matNMR WARNING:  not possible while apodizing or phasing!     regelstartrecordingmacro cancelled');
    QmatNMR.RecordingMacro = 0;
    QmatNMR.RecordingPlottingMacro = 0;
  
  else
    if (QmatNMR.buttonList == 1)
      if (QmatNMR.uiInput1 == 1)
        QmatNMR.RecordingMacro = 1;
        QmatNMR.RecordingPlottingMacro = 0;
        disp('Recording all processing actions :');
      
      elseif (QmatNMR.uiInput1 == 2)
        QmatNMR.RecordingMacro = 0;
        QmatNMR.RecordingPlottingMacro = 1;
        disp('Recording all plotting actions :');
      
      elseif (QmatNMR.uiInput1 == 3)
        QmatNMR.RecordingMacro = 1;
        QmatNMR.RecordingPlottingMacro = 1;
        disp('Recording all processing and plotting actions :');
      end    
      QmatNMR.Macro = AddToMacro;	%clear macro and wait for new actions to be recorded
  
    else
      disp('Recording of macro was cancelled ...');
      QmatNMR.RecordingMacro = 0;
      QmatNMR.RecordingPlottingMacro = 0;
    end
  end

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
