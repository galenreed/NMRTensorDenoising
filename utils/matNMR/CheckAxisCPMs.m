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
%CheckAxisCPMs.m checks whether the axis for the plot of conditional probability matrices (CPMs)
%is ascending or descending.
%
%if the axis is descending the the vector will be flipped from left to right together with
%the axis. That way the axis will become ascending again (the only way MATLAB can plot 
%unfortunately!). Also the 'xdir' property of the axis will be set to 'normal'.
%
%for an ascending axis the 'xdir' property of the axis will be set to 'reverse'
%
%13-11-'98

try
  QmatNMR.CPMTEMP1Plot = QmatNMR.CPMTEMP1;
  QmatNMR.CPM1Plot     = QmatNMR.CPM1;
  QmatNMR.CPM2Plot     = QmatNMR.CPM2;
  QmatNMR.CPM3Plot     = QmatNMR.CPM3;
  QmatNMR.sumTD2Plot   = QmatNMR.sumTD2;
  QmatNMR.sumTD1Plot   = QmatNMR.sumTD1;
  
  
  					%check the axis for td2
  if (QmatNMR.CPMvec1(1) < QmatNMR.CPMvec1(2))		%ascending axis
    QmatNMR.CPMvec1Plot = QmatNMR.CPMvec1;
    
  else					%descending axis
    QmatNMR.CPMTEMP1Plot = fliplr(CPMTEMP1Plot);
    QmatNMR.sumTD2Plot   = fliplr(sumTD2Plot);
    QmatNMR.CPM1Plot     = fliplr(QmatNMR.CPM1Plot);
    QmatNMR.CPM2Plot     = fliplr(QmatNMR.CPM2Plot);
    QmatNMR.CPM3Plot     = fliplr(QmatNMR.CPM3Plot);
    QmatNMR.CPMvec1Plot  = fliplr(QmatNMR.CPMvec1);
  end  
  
  
  
  					%check the axis for td1
  if (length(QmatNMR.CPMvec2) > 1)
    if (QmatNMR.CPMvec2(1) < QmatNMR.CPMvec2(2))	%ascending axis
      QmatNMR.CPMvec2Plot = QmatNMR.CPMvec2;
    
    else					%descending axis
      QmatNMR.CPMTEMP1Plot = flipud(CPMTEMP1Plot);
      QmatNMR.sumTD1Plot   = flipud(sumTD1Plot);
      QmatNMR.CPM1Plot     = flipud(QmatNMR.CPM1Plot);
      QmatNMR.CPM2Plot     = flipud(QmatNMR.CPM2Plot);
      QmatNMR.CPM3Plot     = flipud(QmatNMR.CPM3Plot);
      QmatNMR.CPMvec2Plot  = fliplr(QmatNMR.CPMvec2);
    end
  end  

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
