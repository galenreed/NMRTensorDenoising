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
%piekfit1d.m is the interface between matNMR and the peak fitting routine by Sean M. Brennan
%22-4-'97

try
  % Find the indices for the part of the data arrays to overload into the peakfit routine
  if (QmatNMR.DisplayMode == 3)
    disp('matNMR NOTICE: when working in display mode "both" zoom limits are not taken into account!');
    QmatNMR.lowerbound = min(QmatNMR.Axis1D);
    QmatNMR.upperbound = max(QmatNMR.Axis1D);
  
  else
    QmatNMR.lowerbound = min([QmatNMR.xmin (QmatNMR.xmin+QmatNMR.totaalX)]);
    QmatNMR.upperbound = max([QmatNMR.xmin (QmatNMR.xmin+QmatNMR.totaalX)]);
  end
  
  %
  %Now we want to see which part of the spectrum is zoomed in to right now. Only this
  %region will be overloaded into the peak fitting routine. We have to make a distinction
  %between a linear axis vector and a non-linear one.
  if (LinearAxis(QmatNMR.Axis1D))
    QmatNMR.resolution = abs( QmatNMR.Axis1D(1) - QmatNMR.Axis1D(2) );
    QTEMP3 = find(QmatNMR.Axis1D>(QmatNMR.lowerbound-0.5*(QmatNMR.resolution)) & QmatNMR.Axis1D<=(QmatNMR.lowerbound+0.5*(QmatNMR.resolution)));
    QTEMP4 = find(QmatNMR.Axis1D<=(QmatNMR.upperbound+0.5*(QmatNMR.resolution)) & QmatNMR.Axis1D>(QmatNMR.upperbound-0.5*(QmatNMR.resolution)));
  
  else
  			%non-linear axis -> use the one with the lowest distance to the next point in the axis vector
    [QTEMP1, QTEMP3] = min(abs(QmatNMR.Axis1D - QmatNMR.lowerbound));
    [QTEMP1, QTEMP4] = min(abs(QmatNMR.Axis1D - QmatNMR.upperbound));
  end
  
  QTEMP = sort([QTEMP3 QTEMP4]);
  QTEMP3 = QTEMP(1);
  QTEMP4 = QTEMP(2);
  
  if ((isempty(QTEMP3)) | (QTEMP3 < 1))
   QTEMP3 = 1;
  end
  
  if ((isempty(QTEMP4)) | (QTEMP4 > QmatNMR.Size1D))
   QTEMP4 = QmatNMR.Size1D;
  end
  
  lsq(QmatNMR.Axis1D(QTEMP3:QTEMP4).',real(QmatNMR.Spec1D(QTEMP3:QTEMP4).'));    %take the 1D spectrum
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
