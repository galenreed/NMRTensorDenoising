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
%askshowsidebands handles the input for adding sideband markers to the current plot
%29-10-'03


try
  QuiInput('Indicate Sidebands :', ' OK | CANCEL', 'regelshowsidebands', [], ...
  	   'MAS speed (kHz)', QmatNMR.spinningspeed, ...
  	   'Spectral Width (kHz)', QmatNMR.SW1D, ...
  	   '&POLine Style | - | -- | : | -. | none', QmatNMR.sidebandLineStyle, ...
  	   '&POLine Width | 0.5 | 1.0 | 2.0 | 3.0 | 4.0 | 5.0 | 6.0 | 7.0 | 8.0 | 9.0 | 10.0 | 15.0 | 20.0 | 30.0', QmatNMR.sidebandLinewidth, ...
  	   '&POMarker|none | . | + | o | * | x | square | diamond | ^ | v | > | < | pentagram | hexagram', QmatNMR.sidebandMarker, ...
  	   '&POMarker Size |0.5 | 1.0 | 2.0 | 3.0 | 4.0 | 5.0 | 6.0 | 7.0 | 8.0 | 9.0 | 10.0 | 15.0 | 20.0 | 30.0', QmatNMR.sidebandMarkerSize, ...
  	   '&POLine Colour | Red | Green | Blue | Yellow | Magenta | Cyan | Black | White', QmatNMR.sidebandColour);

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
