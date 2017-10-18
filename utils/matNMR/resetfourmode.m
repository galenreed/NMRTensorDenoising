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
%resetfourmode.m sets the Fourier Mode to the value selected in the main window button
%
%12-11-'98

try
  QmatNMR.howFT = get(QmatNMR.Four, 'value');	%Read current fourier mode
  if (QmatNMR.Dim == 0)			%1D
    QmatNMR.four2 = QmatNMR.howFT;					%Read current fourier mode
  
  elseif (QmatNMR.Dim == 1)			%TD2
    QmatNMR.four2 = QmatNMR.howFT;					%Read current fourier mode
    
  else					%TD1
    QmatNMR.four1 = QmatNMR.howFT;					%Read current fourier mode
  end;      
  
  				%determines whether this the hypercomplex complex ...
  if ((QmatNMR.howFT == 3) | (QmatNMR.howFT == 4) | (QmatNMR.howFT == 6))
    QmatNMR.HyperComplex = 1;
  else
    QmatNMR.HyperComplex = 0;
  end
  
  
  %
  %for 2D's reread the slice as the new fourier mode may require a change
  %
  if (QmatNMR.Dim > 0)
    getcurrentspectrum
  end
  
  
  %
  %redraw the plot
  %
  detaxisprops
  Qspcrel
  CheckAxis                             %Check whether the new axis is descending or ascending
  simpelplot

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
