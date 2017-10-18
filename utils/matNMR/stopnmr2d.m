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
%stopnmr2d.m clears all variables that are needed by the 2D display/plotting routine
%03-01-'00

try
  if QmatNMR.buttonList == 1
    QmatNMR.Ph = findobj(allchild(0),'tag','2D/3D Viewer');
    try
      delete(QmatNMR.Ph);
    end
    try
      delete(QmatNMR.Q2DButtonPanel);
    end
    QmatNMR.Fig2D3D = [];
  
    QmatNMR.Ph = findobj(allchild(0),'tag','CLabels');
    try
      delete(QmatNMR.Ph);
    end;  
  
    QmatNMR.Spec2D3D = [];
    if (~(QmatNMR.Fig > 0))		%there is no main window open right now
      try
        delete(findobj(get(0, 'children'), 'tag', 'QmatNMR.uiInputWindow'));
      end
    
      try
        delete(QmatNMR.statfig2d);
      end
      
      QmatNMR.Ph = findobj(allchild(0),'tag','mathelpprint'); %mathelpprint window
      try
        delete(QmatNMR.Ph);
      end;  
  
      %Close the matprint window
      try
        delete(findobj(allchild(0),'tag','matprint'));
      end
  
      eval(QmatNMR.RestoreUserDefaultValues);		%restore all user-defined default values that have been changed by matNMR
  
      disp([QmatNMR.VersionVar ' stopped ...']);
  
      clear global Q* 					%All matNMR variables have to go !
      clear Q*						%All matNMR variables have to go !
      clear functions;
  
    else 				%the main window is still open so everything can be left as it is,
      QmatNMR.Q2D3DWindowNumbering = []; 	%we only reset the counter for the number of 2D/3D viewer windows
      disp('2D/3D Viewer stopped ...');
    end
  end

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
