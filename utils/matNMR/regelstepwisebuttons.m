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
%regelstepwisebuttons.m writes the appropriate steps of a processing macro into the
%buttons figure window.
%11-02-2000

try
  %
  %Now fill the edit buttons with the appropriate steps ...
  %
  figure(QmatNMR.FigureStepwise);
  for QTEMP40=1:5
    if (QmatNMR.StepWiseProcessNumber+QTEMP40-1 <= QmatNMR.StepWiseNRSteps)
      eval(['set(QmatNMR.SW' num2str(QTEMP40) ', ''string'', sprintf(''%d) %s'', ' num2str(QmatNMR.StepWiseProcessNumber+QTEMP40-2) ', ''' QmatNMR.StepWiseText(QmatNMR.StepWiseProcessNumber+QTEMP40-1, :) '''));']);
  
    else
      eval(['set(QmatNMR.SW' num2str(QTEMP40) ', ''string'', '''');']);
    end
  end    
  
  %
  %Check whether there are any processing steps left to do. If not close the figure window
  %
  if (QmatNMR.StepWiseProcessNumber > QmatNMR.StepWiseNRSteps)
    try
      delete(QmatNMR.FigureStepwise);
    end
    QmatNMR.FigureStepwise = [];
    disp('Finished stepwise processing of macro ...');
  end  

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
