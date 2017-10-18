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
%transferacquisitiondata.m transfers the variable QacqFID (that should be in the workspace at
%the time of pressing the UIcontrol!) is made the current 1D or 2D spectrum in matNMR.
%15-09-2000

try
  if ~exist('QacqFID')
    disp('matNMR WARNING: variable ''QacqFID'' was not found in the workspace');
    disp('matNMR WARNING: transfer of acquisition data cancelled ...');
  
  elseif isempty(QacqFID)
    disp('matNMR WARNING: variable ''QacqFID'' is empty');
    disp('matNMR WARNING: transfer of acquisition data cancelled ...');
  
  else
    if (any(size(QacqFID)==1))		%check whether it is a 1D or a 2D FID
      QmatNMR.Spec1DName = 'QacqFID';			%it's a 1D ...
      [QmatNMR.Spec1DName, QmatNMR.CheckInput] = checkinput(QmatNMR.Spec1DName);%adjust the format of the input expression for later use
   
      QmatNMR.FIDstatus = 2;			%It's an FID
      QmatNMR.FIDstatusLast = QmatNMR.FIDstatus;	%to remember that it was an FID
      set(QmatNMR.FID, 'value', QmatNMR.FIDstatus);     %set the display in the main window correctly
      
      makenew1D				%create a new 1D dataset
      
    else					%It's a 2D ...  
      QmatNMR.Spec1DName = 'QacqFID';
      [QmatNMR.Spec1DName, QmatNMR.CheckInput] = checkinput(QmatNMR.Spec1DName);%adjust the format of the input expression for later use
  
      QmatNMR.FIDstatus2D1 = 2;			%It's an FID in both dimensions
      QmatNMR.FIDstatus2D2 = 2;
      QmatNMR.FIDstatus = QmatNMR.FIDstatus2D1;
      QmatNMR.FIDstatusLast = QmatNMR.FIDstatus;	%to remember that it was an FID
      set(QmatNMR.FID, 'value', QmatNMR.FIDstatus);	%set the display in the main window correctly
      
      makenew2D				%create a new 2D dataset
    end
  end    

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
