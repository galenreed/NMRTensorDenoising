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
%clearradios.m turns off all radio buttons in the peakfit window. For some strange reason when
%clicking a radio button did not turn the others off...
%
%16-10-'98

try
  [QmatNMR.TTed, QmatNMR.TTck, QmatNMR.TTrb, QmatNMR.TTfitbut, QmatNMR.TTcurbut, QmatNMR.TTTolBut, QmatNMR.TTNrIterBut, QmatNMR.TTnoibut, QmatNMR.TTzombut, ...
   QmatNMR.TTredisbut, QmatNMR.TTlijstbut, QmatNMR.TTMinSlice, QmatNMR.TTMaxSlice, QmatNMR.TTViewSlice, QmatNMR.TTparambut, QmatNMR.TTmorebut, QmatNMR.TTrefreshbut, ...
   QmatNMR.TTprintbut, QmatNMR.TTstopbut, QmatNMR.TTtxt1, QmatNMR.TTtxt2, QmatNMR.TTtxt3, QmatNMR.TTtxt4, QmatNMR.TTtxt5, QmatNMR.TTtxt6, QmatNMR.TTtxt7, QmatNMR.TTtxt8, ...
   QmatNMR.TTtxt9, QmatNMR.TTViewText, QmatNMR.TTMaxText, QmatNMR.TTMinText, QmatNMR.TTViewButs, QmatNMR.TTMaxButs, QmatNMR.TTMinButs] = pk_udata;
  
  set(QmatNMR.TTrb, 'value', 0)
  set(gco, 'value', 1)

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
