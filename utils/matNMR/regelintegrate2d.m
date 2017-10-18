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
%regelintegrate2d.m allows the user to integrate peaks in a 2D spectrum, slice by
%slice. This means that the integral of a peak can be observed as a function of
%the other dimension.
%
%04-06-2004

try
  if (QmatNMR.buttonList == 1)
    watch;
  
    QTEMP4 = eval(['[' QmatNMR.uiInput1 ']']);
    QTEMP5 = sort(round((QTEMP4-QmatNMR.Rnull) ./ QmatNMR.Rincr));
    QTEMP6 = eval(QmatNMR.uiInput2);
  
    %
    %make output variable global and calculate integrals
    %
    eval(['global ' QmatNMR.uiInput3]);
    if (QmatNMR.Dim == 1) 		%current dimension = TD2
      [QTEMP20, QTEMP21] = max(real(QmatNMR.Spec2D(QTEMP6, QTEMP5(1):QTEMP5(2))), [], 2);
      QTEMP21 = QTEMP21 + QTEMP5(1) - 1;		%position of the maximum in the interval defined by QTEMP5, translated back to the full length of the axis
      eval([QmatNMR.uiInput3 ' = [QmatNMR.AxisTD1(QTEMP6).'' sum(real(QmatNMR.Spec2D(QTEMP6, QTEMP5(1):QTEMP5(2))), 2) QmatNMR.AxisTD2(QTEMP21).''];']);
  
    else				%current dimension is TD1
      [QTEMP20, QTEMP21] = max(real(QmatNMR.Spec2D(QTEMP5(1):QTEMP5(2), QTEMP6)), [], 1);
      QTEMP21 = QTEMP21 + QTEMP5(1) - 1;		%position of the maximum in the interval defined by QTEMP5, translated back to the full length of the axis
      eval([QmatNMR.uiInput3 ' = [QmatNMR.AxisTD2(QTEMP6).'' sum(real(QmatNMR.Spec2D(QTEMP5(1):QTEMP5(2), QTEMP6)), 1)].''  QmatNMR.AxisTD1(QTEMP21).''];']);
    end
  
    disp(['Range in 2D integrated and saved in the workspace as "' QmatNMR.uiInput3 '" (frequency:intensity:position_maximum)']);
    Arrowhead
  
  else
    disp('Integration of peaks in the current 2D spectrum cancelled');
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
