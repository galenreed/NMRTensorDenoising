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
%
% CheckNumeric
%
% checks whether the string of an edit button evaluates to a numeric result. If not the string is deleted
%
% 02-08-2005

function CheckNumeric(Object, LowerLim, UpperLim, ChangeValue)

  %
  %does the object exist
  %
  try
    %
    %get the string
    %
    QTEMP = get(Object, 'string');
    
  catch
    disp('matNMR ERROR: a call was made to CheckNumeric using a non-existing object!')
    return
  end

  %
  %check whether the result is numeric
  %
  try
    %
    %evaluate the string
    %
    QTEMP2 = eval(QTEMP);
    
    %
    %check whether the result is a number, otherwise delete the string
    %
    if ~isnumeric(QTEMP2)
      set(Object, 'string', ''); 
      return     
    end

  catch
    set(Object, 'string', '');
    return
  end

  %
  %check whether the result is within the specified limits
  %
  if (nargin > 1)
    if (QTEMP2 < LowerLim) | (QTEMP2 > UpperLim)
      if (nargin == 4)	%a replacement value was specified, so we use it
        set(Object, 'string', num2str(ChangeValue, 10));

      else 		%no replacement value was specified so we clear the string
        set(Object, 'string', '');
      end
    end
  end
    
