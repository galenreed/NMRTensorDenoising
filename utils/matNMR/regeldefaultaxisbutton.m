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
% regeldefaultaxisbutton deals with changing of the default axis setting in the current dimension
%
% 31-03-'08

try
  QTEMP1 = get(QmatNMR.defaultaxisbutton, 'value');
  switch QTEMP1
    case 1
      regelsetdefaultaxis
    
    case 2
      QmatNMR.DefaultAxisSwitch = 0;
      QmatNMR.DefaultAxisType = 1;
      regelchangedefaultaxis
      
      if (QmatNMR.RulerXAxis == 1)
        regelsetdefaultaxis
      end
    
    case 3
      QmatNMR.DefaultAxisSwitch = 0; 
      QmatNMR.DefaultAxisType = 2;
      regelchangedefaultaxis
      
      if (QmatNMR.RulerXAxis == 1)
        regelsetdefaultaxis
      end
    
    case 4
      QmatNMR.DefaultAxisSwitch = 1; 
      QmatNMR.DefaultAxisType = 1;
      regelchangedefaultaxis
      
      if (QmatNMR.RulerXAxis == 1)
        regelsetdefaultaxis
      end
    
    case 5
      QmatNMR.DefaultAxisSwitch = 1; 
      QmatNMR.DefaultAxisType = 2;
      regelchangedefaultaxis
      
      if (QmatNMR.RulerXAxis == 1)
        regelsetdefaultaxis
      end
    
    case 6
      QmatNMR.DefaultAxisSwitch = 1; 
      QmatNMR.DefaultAxisType = 3;
      regelchangedefaultaxis
      
      if (QmatNMR.RulerXAxis == 1)
        regelsetdefaultaxis
      end
    
    case 7
      QmatNMR.DefaultAxisSwitch = 1; 
      QmatNMR.DefaultAxisType = 4;
      regelchangedefaultaxis
      
      if (QmatNMR.RulerXAxis == 1)
        regelsetdefaultaxis
      end
  end
  
  

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
