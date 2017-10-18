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
% regelcreateCPMs processes the threshold value for the creation of conditional probability
% matrices and creates CPMs until the user wants to stop.
%
% 23-09-'05


try
  if (QmatNMR.buttonList == 1)
    QmatNMR.CPMthreshold = eval(QmatNMR.uiInput1);
    QmatNMR.CPMnumbcont = eval(QmatNMR.uiInput2);
    QmatNMR.CPMmin = eval(QmatNMR.uiInput3);
    QmatNMR.CPMmax = eval(QmatNMR.uiInput4);
    QmatNMR.CPMmultiplier = eval(QmatNMR.uiInput5);
    QmatNMR.CPMfilledcontours = QmatNMR.uiInput6;
    QmatNMR.CPMfullprobability = QmatNMR.uiInput7;
    
    disp(['Threshold for creation of conditional probability matrices (CPMs) set to ' QmatNMR.CPMthreshold '% of the maximum'])
    disp('To generate CPMs select crosspeak regions by dragging and clicking the left mouse button.');
    disp('To stop press the right mouse button ...');
    
    contzoomOFF      %switch off the zoom and rotate3d functions
    set(gcf, 'Pointer', 'crosshair');
    CreateCPMs(1);
    
  else
    disp('Creating conditional probability matrices (CPMs) cancelled ...');
  end  

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
