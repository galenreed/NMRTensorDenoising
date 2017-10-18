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
%regelsweepwidth.m keeps track of the sweepwidth when the value in the matNMR main window is changed
%5-12-'97

try
  QTEMP1 = deblank(get(QmatNMR.hsweep, 'String'));
  
  if strcmp(QTEMP1, '')	%check whether the edit box is empty. If so return previous value
    set(QmatNMR.hsweep, 'string', num2str(QmatNMR.SW1D, 10));
    
  else
    QTEMP9 = length(QTEMP1);
    if ((QTEMP1(QTEMP9) == 'k') | (QTEMP1(QTEMP9) == 'K'))
      QmatNMR.SW1D = abs(eval(QTEMP1(1:(QTEMP9-1))) * 1000 );
    else
      QmatNMR.SW1D = abs(eval(QTEMP1));
    end
    set(QmatNMR.hsweep, 'string', num2str(QmatNMR.SW1D, 10));
  
    if (QmatNMR.Dim == 1)
      QmatNMR.SWTD2 = QmatNMR.SW1D;
    elseif (QmatNMR.Dim == 2)
      QmatNMR.SWTD1 = QmatNMR.SW1D;
    end;    
  end
  
  %
  %if the current axis is a default axis then we need to update it
  %
  if (QmatNMR.RulerXAxis == 0)
    asaanpas
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
