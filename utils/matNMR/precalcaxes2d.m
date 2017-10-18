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
%precalcaxes2d.m calculates the offset and increment values for the current axes in either
%the contour or mesh window.

try
  QTEMP = get(gca, 'currentpoint');
  QTEMP2 = QTEMP(1,1);
  QTEMP1 = QTEMP(1,2);
  
  QTEMP3 = QmatNMR.Axis2D3DTD2;
  QTEMP4 = QmatNMR.Axis2D3DTD1;
      
    	%Determine the denoted position in the spectrum in terms of points
  	%first for QTEMP3 (TD2)
  QmatNMR.incr = QTEMP3(2)-QTEMP3(1);		%the following are some variables to be able to get the coordinates
  QmatNMR.null = QTEMP3(1) - QmatNMR.incr;		%to use in the stack plot, even when an axis is defined
  						%in something else than points ! This only works for
  						%linear increments of course !!
  QmatNMR.offset2 = (QTEMP2 - QmatNMR.null) / QmatNMR.incr;
    
  	%then for QTEMP4 (TD1)
  QmatNMR.incr = QTEMP4(2)-QTEMP4(1);		%the following are some variables to be able to get the coordinates
  QmatNMR.null = QTEMP4(1) - QmatNMR.incr;		%to use in the stack plot, even when an axis is defined
  						%in something else than points ! This only works for
  						%linear increments of course !!
  QmatNMR.offset1 = (QTEMP1 - QmatNMR.null) / QmatNMR.incr;
  
  scale2d  
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
