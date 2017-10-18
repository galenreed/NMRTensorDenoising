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
%QuiInput_2.m handles the callback for QuiInput.m such that all global variables are still
%available
%8-12-'97

try
  global QmatNMR
  
  				%Now check whether any check buttons or popup buttons were in the last input window
  QmatNMR.Ph = [findobj(QmatNMR.uiInputEdits, 'style', 'checkbox'); findobj(QmatNMR.uiInputEdits, 'style', 'popupmenu')];
  for Qii = 1:length(QmatNMR.uiInputEdits)
    if (find(QmatNMR.Ph == QmatNMR.uiInputEdits(Qii)))	%Is the current button a checkbox or popup button ?? the get the value
      eval(['QmatNMR.uiInput' deblank(get(QmatNMR.uiInputEdits(Qii),'tag'))  ' = get(QmatNMR.uiInputEdits(Qii),''Value'');']);
      
      					%if not, get the string
    else
      eval(['QmatNMR.uiInput' deblank(get(QmatNMR.uiInputEdits(Qii),'tag'))  ' = deblank(get(QmatNMR.uiInputEdits(Qii),''String''));']);
    end  
  end
  
  
  %
  %close the input window and clear the variable
  %
  try
    delete(QmatNMR.uiInputFig);
  end
  drawnow
  QmatNMR.uiInputFig = [];
  
  
  %
  %execute the callback for the input window
  %
  eval(QmatNMR.uiInputCallback);
  
  clear Qii

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
