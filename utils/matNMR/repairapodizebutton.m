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
%repairapodizebutton.m resets the apoding button in the main window accordig to the
%QmatNMR.lbstatus variable
%01-12-'98

try
  if (QmatNMR.lbstatus == 0)			%none
    set(QmatNMR.h75, 'value', 1);
    
  elseif (QmatNMR.lbstatus == 50)		%exponential
    set(QmatNMR.h75, 'value', 2);
  
  elseif (QmatNMR.lbstatus == -99)		%cos^2
    set(QmatNMR.h75, 'value', 3);
  
  elseif (QmatNMR.lbstatus == 10)		%gaussian
    set(QmatNMR.h75, 'value', 4);
  
  elseif (QmatNMR.lbstatus == -30)		%Hamming
    set(QmatNMR.h75, 'value', 5);
  
  elseif (QmatNMR.lbstatus == 100)  		%shifting gauss
    set(QmatNMR.h75, 'value', 6);
  
  elseif (QmatNMR.lbstatus == 501)		%exponential (echo)
    set(QmatNMR.h75, 'value', 7);
  
  elseif (QmatNMR.lbstatus == 101)		%gauss (echo)
    set(QmatNMR.h75, 'value', 8);
  
  elseif (QmatNMR.lbstatus == 1001)		%shifting gauss (echo)
    set(QmatNMR.h75, 'value', 9);
  
  end
  
    

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
