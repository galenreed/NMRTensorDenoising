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
%asknamedual.m takes care of the choices possible for loading a 1D FID or spectrum for dual display...
%
%23-07-'97

try
  QTEMP1 = get(QmatNMR.e9, 'value');	%this is the UI control from which the dual display may be started. If the value is 1
  				%then the dual display was started from the menubar OR the user hasn't selected an entry
  				%from the list of 10 last variables.
  set(QmatNMR.e9, 'Value', 1);
  
  if QTEMP1 == 1		%This is only a marginal difference of course ...
  
    switch (QmatNMR.PlotType)
      case 1			%default plot type
        QuiInput('Load a 1D spectrum for dual display :', ' OK | CANCEL', 'dualdisp', [], 'Name :', QmatNMR.Spec1DName, 'Axis variable (OPTIONAL!) :', QmatNMR.LastDualAxis, '&POScaling :| Same Integral | Same Maximum | Original intensity', QmatNMR.LastDualType);
      
      case 2			%horizontal stack plot  
        QuiInput('Dual display of horizontal stack plot :', ' OK | CANCEL', 'dualdisp', [], 'Name :', QmatNMR.Spec1DName, '&POScaling :| Same Integral | Same Maximum | Original intensity', QmatNMR.LastDualType);
      
      case 3			%vertical stack plot  
        QuiInput('Dual display of vertical stack plot :', ' OK | CANCEL', 'dualdisp', [], 'Name :', QmatNMR.Spec1DName);
      
      case 4			%1D bar plot  
        QuiInput('Dual display of 1D bar plot :', ' OK | CANCEL', 'dualdisp', [], ...
                 'Name :', QmatNMR.Spec1DName, ...
  	         'Axis variable (OPTIONAL!) :', QmatNMR.LastDualAxis, ...
  	         '&POScaling :| Same Integral | Same Maximum | Original intensity', QmatNMR.LastDualType, ...
                 'Width', QmatNMR.Q1DBarWidthDual, ...
                 '&POColour|Default|Red|Green|Blue|Yellow|Magenta|Cyan|Black|White', QmatNMR.Q1DBarColourDual, ...
                 '&CKSame colour for edges', QmatNMR.Q1DBarEdges);
      
      case 5			%error bar plot
        QuiInput('Dual display of error bar plot :', ' OK | CANCEL', 'dualdisp', [], 'Name :', QmatNMR.Spec1DName, 'Axis variable (OPTIONAL!) :', QmatNMR.LastDualAxis, 'Vector with error limits :', QmatNMR.Q1DErrorBarsDual, '&POScaling :| Same Integral | Same Maximum | Original intensity', QmatNMR.LastDualType);
  
      otherwise
        error('matNMR ERROR: unknown value for QPlotType! Aborting ...')
        return
    end
  
  else
    switch (QmatNMR.PlotType)
      case 1			%default plot type
        QTEMP2 = ['QuiInput(''Load a 1D spectrum for dual display :'', '' OK | CANCEL'', ''dualdisp'', [], ''Name :'', QmatNMR.LastVariableNames1D(' num2str(QTEMP1-1) ').Spectrum, ''Axis variable (OPTIONAL!) :'',  QmatNMR.LastVariableNames1D(' num2str(QTEMP1-1) ').Axis, ''&POScaling :| Same Integral | Same Maximum | Original intensity'', QmatNMR.LastDualType);'];
        eval(QTEMP2);
      
      case 2			%horizontal stack plot  
        QTEMP2 = ['QuiInput(''Dual display of horizontal stack plot :'', '' OK | CANCEL'', ''dualdisp'', [], ''Name :'', QmatNMR.LastVariableNames1D(' num2str(QTEMP1-1) ').Spectrum, ''&POScaling :| Same Integral | Same Maximum | Original intensity'', QmatNMR.LastDualType);'];
        eval(QTEMP2);
      
      case 3			%vertical stack plot  
        QTEMP2 = ['QuiInput(''Dual display of vertical stack plot :'', '' OK | CANCEL'', ''dualdisp'', [], ''Name :'', QmatNMR.LastVariableNames1D(' num2str(QTEMP1-1) ').Spectrum);'];
        eval(QTEMP2);
      
      case 4			%1D bar plot  
        QuiInput('Dual display of 1D bar plot :', ' OK | CANCEL', 'dualdisp', [], ...
                 'Name :', QmatNMR.LastVariableNames1D(QTEMP1-1).Spectrum, ...
  	         'Axis variable (OPTIONAL!) :', QmatNMR.LastVariableNames1D(QTEMP1-1).Axis, ...
  	         '&POScaling :| Same Integral | Same Maximum | Original intensity', QmatNMR.LastDualType, ...
                 'Width', QmatNMR.Q1DBarWidthDual, ...
                 '&POColour|Default|Red|Green|Blue|Yellow|Magenta|Cyan|Black|White', QmatNMR.Q1DBarColourDual, ...
                 '&CKSame colour for edges', QmatNMR.Q1DBarEdges);
      
      case 5			%error bar plot
        QTEMP2 = ['QuiInput(''Dual display of error bar plot :'', '' OK | CANCEL'', ''dualdisp'', [], ''Name :'', QmatNMR.LastVariableNames1D(' num2str(QTEMP1-1) ').Spectrum, ''Axis variable (OPTIONAL!) :'',  QmatNMR.LastVariableNames1D(' num2str(QTEMP1-1) ').Axis, ''Vector with error limits :'', QmatNMR.Q1DErrorBarsDual, ''&POScaling :| Same Integral | Same Maximum | Original intensity'', QmatNMR.LastDualType);'];
        eval(QTEMP2);
  
      otherwise
        error('matNMR ERROR: unknown value for QPlotType! Aborting ...')
        return
    end
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
