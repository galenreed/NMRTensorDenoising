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
%updatebuttons updates the values of several UI controls in the main window simultaneously
%
%29-07-'04

try
  set(QmatNMR.DIM, 'value', QmatNMR.Dim+1)
  set(QmatNMR.FID, 'value', QmatNMR.FIDstatus);
  set(QmatNMR.gammabutton, 'value', QmatNMR.gamma1d);
  
  if isnan(QmatNMR.fase1start)
    QmatNMR.fase1startIndex = floor(QmatNMR.Size1D/2)+1;
    QmatNMR.fase1start = interp1((1:QmatNMR.Size1D).', QmatNMR.Axis1D, QmatNMR.fase1startIndex);
  end
  set(QmatNMR.p23, 'String', QmatNMR.fase1start);
  
  set(QmatNMR.h75, 'value', 1);
  set(QmatNMR.h72, 'string', num2str(QmatNMR.kolomnr, 10));
  set(QmatNMR.h74, 'string', num2str(QmatNMR.rijnr, 10));
  if (QmatNMR.Dim == 0)
    set(QmatNMR.Four, 'value', QmatNMR.four2);		    %set FT-mode back to standard for 1D
  elseif (QmatNMR.Dim == 1)
    set(QmatNMR.Four, 'value', QmatNMR.four2);		    %set FT-mode back to standard for TD2
  else
    set(QmatNMR.Four, 'value', QmatNMR.four1);		    %set FT-mode back to standard for TD1
  end
  set(QmatNMR.hsweep, 'String', num2str(QmatNMR.SW1D, 10));    
  set(QmatNMR.hspecfreq, 'string', num2str(QmatNMR.SF1D, 10));
  
  set(QmatNMR.p1, 'value', QmatNMR.fase0);				  %resetting the sliders buttons in the figure window
  set(QmatNMR.p5, 'value', QmatNMR.fase0, 'string', QmatNMR.fase0);
  set(QmatNMR.p11, 'value', QmatNMR.fase1);
  set(QmatNMR.p15, 'value', QmatNMR.fase1, 'string', QmatNMR.fase1);
  set(QmatNMR.p24, 'value', QmatNMR.fase2);
  set(QmatNMR.p28, 'value', QmatNMR.fase2, 'string', QmatNMR.fase2);
  
  
  
  %default-axis mode buttons
  if (QmatNMR.RulerXAxis == 0)	%use default axis for plotting of spectra
    set(QmatNMR.h670, 'checked', 'off'); 	%switch off the check flag in the menubar
  
  else
    set(QmatNMR.h670, 'checked', 'off'); 	%switch off the check flag in the menubar
    set(QmatNMR.defaultaxisbutton, 'value', 8);
  end

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
