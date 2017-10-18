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
%askstack1dvertical handles the input for a vertical stack plot
%
%12-05-'04

try
  if (QmatNMR.Dim == 0)
    disp('matNMR NOTICE: 2D processing functions are not allowed in 1D mode!')
  
  else  
    if QmatNMR.lbstatus | QmatNMR.bezigmetfase
      disp('matNMR WARNING:  not possible while apodizing or phasing!     askstack1dvertical cancelled');
    
    else
      if (QmatNMR.Dim == 1) 	%current dimension = TD2
        QmatNMR.VerticalStackRange = ['1:' num2str(QmatNMR.SizeTD1)];
        QuiInput('Vertical stack plot :', ' OK | CANCEL', 'stack1dvertical', [], ...
                 'Range in TD1 :', QmatNMR.VerticalStackRange, ...
  	       'Vertical displacement factor', QmatNMR.VerticalStackDisplacement);
  
      else 			%current dimension = TD1
        QmatNMR.VerticalStackRange = ['1:' num2str(QmatNMR.SizeTD2)];
        QuiInput('Vertical stack plot :', ' OK | CANCEL', 'stack1dvertical', [], ...
                 'Range in TD2 :', QmatNMR.VerticalStackRange, ...
  	       'Vertical displacement factor', QmatNMR.VerticalStackDisplacement);
      end
    end
  end

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
