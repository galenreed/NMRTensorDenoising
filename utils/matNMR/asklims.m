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
%asklims.m takes care of the input for the xlim, ylim and zlim of a plot
%15-12-'98

try
  QTEMP1 = get(gca, 'xlim');
  QTEMP1 = [num2str(QTEMP1(1),8) ' ' num2str(QTEMP1(2),8)];
  
  QTEMP2 = get(gca, 'ylim');
  QTEMP2 = [num2str(QTEMP2(1),8) ' ' num2str(QTEMP2(2),8)];
  
  QTEMP3 = get(gca, 'zlim');
  QTEMP3 = [num2str(QTEMP3(1),8) ' ' num2str(QTEMP3(2),8)];
  
  QuiInput('Set XLIM, YLIM and ZLIM :', ' OK | CANCEL', 'regellims', [], ...
           'XLIM :&CB1', QTEMP1, ...
           'ylim :&CB1', QTEMP2, ...
           'zlim :&CB1', QTEMP3, ...
           '&POWhich subplots need to be changed?| Selected subplots OR current axis | All subplots | Current row | Current Column', 1);
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
