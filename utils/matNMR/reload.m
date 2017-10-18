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
%Reload.m loads the last spectrum or FID, both 1D and 2D !!

try
  QmatNMR.Spec1DName = QmatNMR.last.Spectrum;
  [QmatNMR.Spec1DName, QmatNMR.CheckInput] = checkinput(QmatNMR.Spec1DName);
  QmatNMR.newinlist = QmatNMR.last;
  
  if ~strcmp(QmatNMR.Spec1DName, '')	%if empty then don't do reload last
    if (QmatNMR.LastVar == 1) 	%last was a 1D FID/spectrum
      disp(['Reloading variable "' QmatNMR.last.Spectrum '" (1D)']);
    
      QmatNMR.uiInput1 = QmatNMR.last.Spectrum;
      QmatNMR.uiInput2 = QmatNMR.last.Axis;
  
      QmatNMR.FIDstatus = QmatNMR.FIDstatusLast;
      set(QmatNMR.FID, 'value', QmatNMR.FIDstatus);
    
      makenew1D;
      
    else			%last was a 2D FID/spectrum
      disp(['Reloading variable "' QmatNMR.last.Spectrum '" (2D)']);
    
      QmatNMR.uiInput1 = QmatNMR.last.Spectrum;
      QmatNMR.uiInput2 = QmatNMR.last.AxisTD2;
      QmatNMR.uiInput3 = QmatNMR.last.AxisTD1;
      
      QmatNMR.FIDstatus2D1 = QmatNMR.FIDstatusLast;
      QmatNMR.FIDstatus2D2 = QmatNMR.FIDstatusLast;
      QmatNMR.FIDstatus = QmatNMR.FIDstatusLast;
      set(QmatNMR.FID, 'value', QmatNMR.FIDstatus);
      
      makenew2D
    end
  
  else
    disp('matNMR NOTICE: no spectrum to reload.')
  end

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
