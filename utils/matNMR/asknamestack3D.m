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
%asknamestack3D.m takes care of the input for the stack 3D plot
%03-01-'00

try
  %
  %switch figure if necessary only because this will cause an additional rendering step
  %
  if (gcf ~= QmatNMR.Fig2D3D)
    figure(QmatNMR.Fig2D3D);
  end
  drawnow
  QuiInput('Display 3D Stack Plot :', ' OK | CANCEL', 'regelstack3D', [], ...
           'Name of Spectrum : ', QmatNMR.SpecName2D3D, ...
           'Dimension along X-axis (1=TD2, 2=TD1) : ', QmatNMR.Stack3DDimension, ...
           'Azimuth (horizontal rotation) in degrees : ', QmatNMR.stackaz, ...
           'Elevation (vertical) in degrees : ', QmatNMR.stackel, ...
           'Vector for T2-axis (empty line gives current axis) :', QmatNMR.UserDefAxisT2Cont, ...
           'Vector for T1-axis (empty line gives current axis) :', QmatNMR.UserDefAxisT1Cont, ...
           'Plotting Macro (optional) :', QmatNMR.Q2D3DMacro);
           

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
