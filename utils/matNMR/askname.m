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
%askname.m takes care of the input for loading the spectra in the main window.

try
  if QmatNMR.ask == 1				%load new 1D FID/spectrum
    QuiInput('Load a new 1D FID/spectrum :', ' FID | Spectrum | CANCEL', 'regelnaam', [], ...
             'Name :', QmatNMR.Spec1DName, ...
             'Vector for axis (empty line gives current axis) :', QmatNMR.UserDefAxisT2Main);
  	 
  elseif QmatNMR.ask == 2			%load new 2D FID/spectrum
    QuiInput('Load a new 2D FID/spectrum :', ' FID | Spectrum | Spec/FID | CANCEL', 'regelnaam', [], 'Name :', QmatNMR.Spec2DName, ...
             'Vector for TD2-axis (empty line gives current axis) :', QmatNMR.UserDefAxisT2Main, ...
             'Vector for TD1-axis (empty line gives current axis) :', QmatNMR.UserDefAxisT1Main);
  	 
  elseif QmatNMR.ask == 3			%load new 3D as series of 2D FID/spectrum
    QuiInput('Load a new 3D (series of 2D) :', ' FID | Spectrum | Spec/FID | CANCEL', 'regelnaam', [], 'Name :', QmatNMR.Spec3DName, ...
             'Vector for TD2-axis (empty line gives current axis) :', QmatNMR.UserDefAxisT2Main, ...
             'Vector for TD1-axis (empty line gives current axis) :', QmatNMR.UserDefAxisT1Main);
  end

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
