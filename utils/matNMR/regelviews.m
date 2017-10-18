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
%regelviews.m takes care of the choices possible for various views on the 2D spectrum ...
%
%renamed to regelviews (used to be views.m) on 28-10-'03

try
  QTEMP9 = get(QmatNMR.h64, 'value');
  set(QmatNMR.h64, 'Value', 1);
  
  switch (QTEMP9)
    case 2	%diagonal
      getdiag;
  
    case 3	%anti diagonal
      getantidiag;
  
    case 4	%sum TD 1
      askprojTD1;
  
    case 5	%sum TD2
      askprojTD2;
  
    case 6	%skyline projection
      askskyline;
  
    case 7	%1D stack plot
      stack1dhorizontal;
  
    case 8	%vertical stack plot
      askstack1dvertical;
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
