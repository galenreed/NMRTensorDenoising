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
%askintegratewidth2d.m allows the user to integrate peaks in a 2D spectrum, slice by
%slice. This means that the integral of a peak can be observed as a function of
%the other dimension. This routine distinguishes itself from the askintegrate2d
%version by the fact that it will determine the maximum signal intensity for each
%slice in the specified range and will then integrate by a fixed width around that
%maximum.
%
%12-01-2005

try
  if (QmatNMR.Dim == 0)
    disp('matNMR NOTICE: 2D processing functions are not allowed in 1D mode!')
  
  else
    if (QmatNMR.DisplayMode == 3)
      disp('matNMR NOTICE: integrating not allowed in display mode "both"! Please switch mode');
  
    else
      disp('To integrate first please select two points that define the range in which the peaks of all slices can be found');
      [QmatNMR.x, QmatNMR.y] = ginput(2);
      
      QTEMP4 = sort(QmatNMR.x);
      QTEMP5 = sort(round((QTEMP4-QmatNMR.Rnull) ./ QmatNMR.Rincr));
      if (QmatNMR.Dim == 1)
        QTEMP6 = ['1:' num2str(QmatNMR.SizeTD1)];
      else
        QTEMP6 = ['1:' num2str(QmatNMR.SizeTD2)];
      end
    
      disp('Now please select two points in the current slice to define the width of integration for each slice');
      [QmatNMR.x, QmatNMR.y] = ginput(2);
      
      QTEMP7 = sort(QmatNMR.x);
      QTEMP8 = sort(round((QTEMP7-QmatNMR.Rnull) ./ QmatNMR.Rincr));
    
      QuiInput('Integrate area around the maximum :', ' OK | CANCEL', 'regelintegratewidth2d', [], ...
               'Range for the peaks (units of axis) :', [num2str(QTEMP4(1)) ' ' num2str(QTEMP4(end))], ...
               'Integration width around maximum (units of axis) :', [num2str(QTEMP7(1)) ' ' num2str(QTEMP7(end))], ...
               ['Range in TD ' num2str(~(QmatNMR.Dim-1)+1) ' :'], QTEMP6, ...
               'Variable name to store results in workspace :', QmatNMR.IntegrateVar);
      
      disp(['Integrated area = ' num2str(sum(real(QmatNMR.Spec1D(QTEMP5(1):QTEMP5(2)))))]);
    end
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
