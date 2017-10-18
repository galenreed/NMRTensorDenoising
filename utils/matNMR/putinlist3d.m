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
%putinlist3d.m remembers the names of the last 10 3d spectra.
%03-07-'04
%
%
%NOTE: this routine doesn't delete the QTEMP* variables because this clashes with some routines that run for loops
%in which this routine is called. This does assume that routines that call this one, do clear the variables.
%

try
  QmatNMR.AlreadyInList = 0;
  
  %
  %We first check whether the new name equals one of the names on 10 last 1D spectra
  %
  for QTEMP40=1:10
    if (strcmp(QmatNMR.newinlist.Spectrum, QmatNMR.LastVariableNames3D(QTEMP40).Spectrum)) & ...
       (strcmp(QmatNMR.newinlist.AxisTD2, QmatNMR.LastVariableNames3D(QTEMP40).AxisTD2)) & ...
       (strcmp(QmatNMR.newinlist.AxisTD1, QmatNMR.LastVariableNames3D(QTEMP40).AxisTD1))
      QmatNMR.AlreadyInList = 1;
      QTEMP12 = QTEMP40;
    end
  end
  
  
  if (QmatNMR.AlreadyInList)
  %
  %Name already exists and so we set the name to the first entry in the list
  %
    QmatNMR.LastVariableNames3D(1:10) = QmatNMR.LastVariableNames3D([QTEMP12 1:(QTEMP12-1) (QTEMP12+1):10]);
  
  else
  %
  %If not then we shift all current names in the list one place up.
  %
    %here we shift places
    for QTEMP40=10:-1:2
      QmatNMR.LastVariableNames3D(QTEMP40).Spectrum = QmatNMR.LastVariableNames3D(QTEMP40-1).Spectrum;
      QmatNMR.LastVariableNames3D(QTEMP40).AxisTD2  = QmatNMR.LastVariableNames3D(QTEMP40-1).AxisTD2;
      QmatNMR.LastVariableNames3D(QTEMP40).AxisTD1  = QmatNMR.LastVariableNames3D(QTEMP40-1).AxisTD1;
    end  
    %and now we insert the new entry
    QmatNMR.LastVariableNames3D(1).Spectrum = QmatNMR.newinlist.Spectrum;
    QmatNMR.LastVariableNames3D(1).AxisTD2 = QmatNMR.newinlist.AxisTD2;
    QmatNMR.LastVariableNames3D(1).AxisTD1 = QmatNMR.newinlist.AxisTD1;
  end
  
  %
  %this is to update the UIcontrols in the 3D window with the new names, IF the window is open.
  %
  QTEMP8 = sprintf('| %s', QmatNMR.LastVariableNames3D(:).Spectrum);
  QmatNMR.textstring = ['Load 3D ' QTEMP8];
  set(QmatNMR.h53, 'String', QmatNMR.textstring, 'value', 1);
  if (QmatNMR.fig3D)
    set(QmatNMR.but3D1, 'String', QmatNMR.textstring, 'value', 1);
  end
  
  %
  %NOTE: this routine doesn't delete the QTEMP* variables because this clashes with some routines that run for loops
  %in which this routine is called. This does assume that routines that call this one, do clear the variables.
  %

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
