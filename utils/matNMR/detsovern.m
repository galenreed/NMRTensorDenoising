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
%detsovern.m determines the S/N ratio by dividing the maximum of the spectrum by the average
%noise level
%9-8-'96

try
  disp(' ');
  disp('You have to define the area in which only noise is present');
  disp('Move the mouse pointer to the desired coordinates and click a button ...');
  disp(' ');
  QmatNMR.yvec = [QmatNMR.ymin (QmatNMR.ymin+QmatNMR.totaalY)];
  QmatNMR.spec = real(QmatNMR.Spec1D) / max(real(QmatNMR.Spec1D));
  
  hold on
  clear QTEMP3
  QTEMP3(1, :) = ginput(1);
  QTEMP1 = plot([QTEMP3(1,1) QTEMP3(1,1)], QmatNMR.yvec, 'r--');
  
  QTEMP3(2, :) = ginput(1);
  QTEMP2 = plot([QTEMP3(2,1) QTEMP3(2,1)], QmatNMR.yvec, 'r--');
  
  
  %
  %translate the positions into coordinates into the axis vector
  %
  QTEMP3 = sort(round((QTEMP3(:, 1)-QmatNMR.Rnull) ./ QmatNMR.Rincr));
  
  
  %
  %make sure the coordinates aren't out of bounds.
  %
  if (QTEMP3(1, 1) < 1)
    QTEMP3(1, 1) = 1;
  end
  if (QTEMP3(2) > QmatNMR.Size1D)
    QTEMP3(2) = QmatNMR.Size1D;
  end
  
  %
  %calculate the S/N as the maximum divided by the standard deviation of the noise
  %
  QTEMP4 = std(real(QmatNMR.spec(QTEMP3(1,1):QTEMP3(2,1))));
  if (abs(QTEMP4) < eps)
    QTEMP4 = 1;
    disp('matNMR WARNING: noise level too small to allow proper calculation of the S/N. Aborting ...');
    beep
  
  else
    QmatNMR.result = max(real(QmatNMR.spec)) / QTEMP4 / 2;
    fprintf(1, '\n\nThe signal to noise for this spectrum is : %3.2f\n\n\n', QmatNMR.result);
  end
  delete(QTEMP1);
  delete(QTEMP2);
  
  hold off
  Qspcrel
  CheckAxis
  simpelplot
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
