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
%checkforcolourscheme.m checks whether the colour scheme has been stored already in the matNMR
%options file. If not then a notice window is opened explaining that the new scheme has been stored
%as default scheme in the options file and that changes may be made in the appropriate options menu.
%
%07-01-2005

try
  QTEMP1 = load(QmatNMR.matnmrpath);
  if (~isfield(QTEMP1.QmatNMRsettings, 'DefaultColorScheme'))
    %
    %colour scheme hadn't been stored before!
    %
    
    %store the new colour scheme
    saveoptions
    
    %open window and display notice
    QmatNMR.ColorSchemeNotice = str2mat('MatNMR has detected that the colour scheme has not yet been stored in your options file.', ...
                                 'Most likely this is due to the fact that you have upgraded your matNMR code. MatNMR will', ...
  			       'now select a new colour scheme and store this as the default in the options file. Should', ...
  			       'you wish to use the old colour scheme, or make changes to the new one, please go to the ', ...
  			       '"colour scheme" options menu.', ...
  			       ' ', ...
  			       'This message will self-destruct in 10 seconds ...');
    matnmrhelp(QmatNMR.ColorSchemeNotice, 'QmatNMR.ColorSchemeNotice');
  
    QTEMP2 = 0;
    while (~isempty(findobj(allchild(0),'tag','MatNMRHelpFigure')) & (QTEMP2 < 10))
      pause(0.5)
      QTEMP2 = QTEMP2 + 0.5;
    end
    delete(findobj(allchild(0),'tag','MatNMRHelpFigure'));
  end
  QTEMP1 = 0;
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
