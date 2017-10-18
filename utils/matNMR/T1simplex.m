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
%T1simplex.m is a function that is used to do a Simplex prefit in a T1 fit. It will calculate
%the fitted function by using T1pk_qvt.m which is the function that is also used by T1fit (the
%main routine) itself. However now the error will be returned to the Simplex routine.
%
%written for matNMR by Jacco van Beek
%23-07-'97
%
%
% the inipars and constraints are not used in this function but are still needed to be able to
% pass them to the simplex_restrict
%

function ret = T1simplex(params, xvalues, yvalues, inipars, constraints);

  fit = T1pk_qvt(xvalues, params);
  ret = sum( ((fit-yvalues).^2)  );
