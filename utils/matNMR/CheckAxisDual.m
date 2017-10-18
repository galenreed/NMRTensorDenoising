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
%CheckAxisDual.m checks whether the axis for the next Dual 1D plot is ascending or descending.
%
%if the axis is descending the the vector will be flipped from left to right together with
%the axis. That way the axis will become ascending again (the only way MATLAB can plot 
%unfortunately!). Also the 'xdir' property of the axis will be set to 'normal'.
%
%for an ascending axis the 'xdir' property of the axis will be set to 'reverse'
%
%10-11-'00

try
  if (length(QmatNMR.dualaxis) > 1)
    QmatNMR.dualaxisincr = QmatNMR.dualaxis(2) - QmatNMR.dualaxis(1); 	%increment value of the new axis
    QmatNMR.dualaxisnull = QmatNMR.dualaxis(1) - QmatNMR.dualaxisincr; %offset of new axis
  else
    QmatNMR.dualaxisnull = -QmatNMR.dualaxis(1);
    QmatNMR.dualaxisincr = QmatNMR.dualaxis(1);
  end


  %
  %check whether the increment has the same sign as the increment of the
  %original spectrum in the current plot. If not then output a warning message
  %saying that the dual plot may not be sensible and that the "get position"
  %routine may not work correctly.
  %
  if (sign(QmatNMR.Rincr) ~= sign(QmatNMR.dualaxisincr))
    disp('matNMR WARNING: the increment of the axis for the additional spectrum has a different sig, which');
    disp('matNMR WARNING: makes the "get position" routine function incorrectly (incorrect index shown).');
  end

  %
  %check the plotting direction for the new trace (like is done in CheckAxis.m)
  %
  if (QmatNMR.FIDstatus == 1)  		      	%means it's a spectrum
    if (QmatNMR.dualaxisincr > 0)		%ascending axis
      QmatNMR.dualaxisPlot = QmatNMR.dualaxis;

    else				      	%descending axis
      QmatNMR.dual = fliplr(QmatNMR.dual);
      QmatNMR.dualaxisPlot = fliplr(QmatNMR.dualaxis);
    end  

  else  				      	%it's an FID
    if (QmatNMR.dualaxisincr > 0) 		%ascending axis
      QmatNMR.dualaxisPlot = QmatNMR.dualaxis;

    else 					%descending axis
      QmatNMR.dual = fliplr(QmatNMR.dual);
      QmatNMR.dualaxisPlot = fliplr(QmatNMR.dualaxis);
    end  
  end  

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
