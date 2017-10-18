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
%askcutspectrum.m performs the input for regelcutspectrum.m which in turn cuts the current
%2D spectrum into slices and glues them together again.
%lightly based on a routine by Edme Hardy
%04-10-'00


try
          	      %first transform the ticks into a suitable form for QuiInput.m
  QTEMP1 = sprintf('%d ', QmatNMR.CutRangeTD2);
  QTEMP2 = sprintf('%d ', QmatNMR.CutRangeTD1);
  QTEMP3 = sprintf('%d ', QmatNMR.CutTicksTD2);
  QTEMP4 = sprintf('%d ', QmatNMR.CutTicksTD1);
  
  QuiInput('Cut spectrum in slices :', ' OK | CANCEL', 'regelcutspectrum', [], ...
           'Range in TD 2, format=[x1 x2 x3 x4 etc] :', QTEMP1, ...
           'Range in TD 1, format=[y1 y2 y3 y4 etc] :', QTEMP2, ...
           'Tickmarks in TD 2 :', QTEMP3, ...
           'Tickmarks in TD 1 :', QTEMP4, ...
           'Save variable as (optional)', QmatNMR.CutSaveVariable);
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
