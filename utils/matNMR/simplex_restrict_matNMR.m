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
%simplex_restrict_matNMR is a function that is used in the T1 fit whenever a Simplex Prefit is asked for.
%Normally a Simplex can't take constrictions in its parameters but I have changed this. At each
%point in the Simplex routine where parameters are changed this function is called upon. Therefore
%the limits can never be passed. 
%
% In this case (For the T1 fit) some parameters need to remain constant (is given in constraints)
%
% Jacco van Beek
% 23-07-'97

function ret = simplex_restrict_matNMR(params, xvalues, yvalues, inipars, constraints);

ret = params;

for teller=1:length(inipars)
  if constraints(teller) == 0		%code for making sure that this parameter isn't fitted
    ret(teller) = inipars(teller);

  elseif constraints(teller) == 2 	%code for making sure that the parameter is kept positive
    ret(teller) = abs(ret(teller));
  end
end    
