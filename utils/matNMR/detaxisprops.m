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
%detaxisprops.m determines the axes offsets and increments
%20-11-'98

try
  %
  %for TD2
  %
  if LinearAxis(QmatNMR.AxisTD2)
    if (length(QmatNMR.AxisTD2) > 1)      		%Determine the actual width of the spectrum that needs to be displayed
      QmatNMR.Rincr1 = (QmatNMR.AxisTD2(2) - QmatNMR.AxisTD2(1));	%the following are some variables to be able to get the coordinates
      QmatNMR.Rnull1 = QmatNMR.AxisTD2(1) - QmatNMR.Rincr1;		%to use in the stack plot, even when an axis is defined
    						%in something else than points ! This only works for
    						%linear increments of course !!
    else 
      QmatNMR.Rincr1  = 1;
      QmatNMR.Rnull1 = 0;
    end
  
  else
    %
    %for non-linear axes we determine sign of the increment only by looking at the first and
    %last values
    %
    QmatNMR.Rnull1 = 0;
    QmatNMR.Rincr1 = (QmatNMR.AxisTD2(end)-QmatNMR.AxisTD2(1))/QmatNMR.SizeTD2;
  end
  
  
  %
  %for TD1
  %
  if LinearAxis(QmatNMR.AxisTD1)
    if (length(QmatNMR.AxisTD1) > 1)
      QmatNMR.Rincr2 = (QmatNMR.AxisTD1(2) - QmatNMR.AxisTD1(1));	%in something else than points ! This only works for
      QmatNMR.Rnull2 = QmatNMR.AxisTD1(1) - QmatNMR.Rincr2;		%linear increments of course !!
    else 
      QmatNMR.Rincr2 = 1;
      QmatNMR.Rnull2 = 0;
    end
  
  else
    %
    %for non-linear axes we determine sign of the increment only by looking at the first and
    %last values
    %
    QmatNMR.Rnull2 = 0;
    QmatNMR.Rincr2 = (QmatNMR.AxisTD1(end)-QmatNMR.AxisTD1(1))/QmatNMR.SizeTD1;
  end
  
  
  %
  %for 1D
  %
  if LinearAxis(QmatNMR.Axis1D)
    if (length(QmatNMR.Axis1D) > 1)
      QmatNMR.Rincr = (QmatNMR.Axis1D(2) - QmatNMR.Axis1D(1));
      QmatNMR.Rnull = QmatNMR.Axis1D(1) - QmatNMR.Rincr;
    else
      QmatNMR.Rincr = 1;
      QmatNMR.Rnull = 0;
    end
  
  else
    %
    %for non-linear axes we determine sign of the increment only by looking at the first and
    %last values
    %
    QmatNMR.Rnull = 0;
    QmatNMR.Rincr = (QmatNMR.Axis1D(end)-QmatNMR.Axis1D(1))/QmatNMR.Size1D;
  end

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
