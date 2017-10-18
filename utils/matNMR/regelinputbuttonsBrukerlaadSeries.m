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
%
%
% matNMR v. 3.9.0 - A processing toolbox for NMR/EPR under MATLAB
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
% regelinputbuttonsBrukerlaadSeries
%
% allows switching of the 'enable' parameter of the uicontrols in the input window
% when loading a series of Bruker spectra. This is useful since for certain file formats 
% the user does not need to give the time domain sizes as these are read from the file 
% itself.
%
% 02-09-'04


try
  %
  %first find the check button and check out its value
  %
  QTEMP1 = get(findobj(QmatNMR.uiInputFig, 'tag', '12'), 'value');
  
  %
  %The popups with the domain sizes and blocking factors and byte ordering
  %
  QTEMP2 = [findobj(QmatNMR.uiInputFig, 'tag', '5') findobj(QmatNMR.uiInputFig, 'tag', '6') findobj(QmatNMR.uiInputFig, 'tag', '7') findobj(QmatNMR.uiInputFig, 'tag', '8') findobj(QmatNMR.uiInputFig, 'tag', '9') findobj(QmatNMR.uiInputFig, 'tag', '10')];
  QTEMP3 = [findobj(QmatNMR.uiInputFig, 'tag', '5t') findobj(QmatNMR.uiInputFig, 'tag', '6t') findobj(QmatNMR.uiInputFig, 'tag', '7t') findobj(QmatNMR.uiInputFig, 'tag', '8t') findobj(QmatNMR.uiInputFig, 'tag', '9t') findobj(QmatNMR.uiInputFig, 'tag', '10t')];
  
  
  %
  %switch the texts and buttons depending on whether the standard parameter files must be read
  %
  if QTEMP1
    set(QTEMP2, 'enable' , 'off');
    set(QTEMP3, 'visible', 'off');
  
  else
    set(QTEMP2, 'enable' , 'on');
    set(QTEMP3, 'visible', 'on');
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
