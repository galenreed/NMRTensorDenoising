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
% regelinputbuttonsfidlaadSeries
%
% allows switching of the 'enable' parameter of the uicontrols in the input window
% when loading a series of binary FIDs. This is useful since for certain file formats 
% the user does not need to give the time domain sizes as these are read from the file 
% itself.
%
% 21-03-'03


try
  %
  %first find the popup button and check out its value
  %
  QTEMP1 = get(findobj(QmatNMR.uiInputFig, 'tag', '7'), 'value');
  
  %
  %The popups with the domain sizes
  %
  QTEMP2 = [findobj(QmatNMR.uiInputFig, 'tag', '5') findobj(QmatNMR.uiInputFig, 'tag', '6')];
  QTEMP3 = [findobj(QmatNMR.uiInputFig, 'tag', '5t') findobj(QmatNMR.uiInputFig, 'tag', '6t')];
  
  
  %
  %the check button with the question whether the standard parameter files must be read instead
  %of supplying the domain sizes yourself
  %
  QTEMP4 = [findobj(QmatNMR.uiInputFig, 'tag', '8')];
  QTEMP5 = [findobj(QmatNMR.uiInputFig, 'tag', '8t')];
  
  
  %
  %for the VNMR, MacNMR, NTNMR and Aspect formats the user does not need to fill in
  %the domain sizes. Therefore they are disabled to make that clear.
  %
  switch QTEMP1
    case 1		%XWINNMR format
      %
      %for the XWINNMR format it the parameter files may be read and so the time domain size buttons
      %may or may not be enabled, depending on whether the parameter files must be read
      %
      if ~get(QTEMP4, 'value')
        set(QTEMP2, 'enable' , 'on');
        set(QTEMP3, 'visible', 'on');
  
      else
        set(QTEMP2, 'enable' , 'off');
        set(QTEMP3, 'visible', 'off');
      end
      set(QTEMP4, 'enable' , 'on');
      set(QTEMP5, 'visible', 'on');
  
    case 2		%Chemagnetics
      %
      %for the Chemagnetics format it the parameter files may be read and so the time domain size buttons
      %may or may not be enabled, depending on whether the parameter files must be read
      %
      if ~get(QTEMP4, 'value')
        set(QTEMP2, 'enable' , 'on');
        set(QTEMP3, 'visible', 'on');
  
      else
        set(QTEMP2, 'enable' , 'off');
        set(QTEMP3, 'visible', 'off');
      end
      set(QTEMP4, 'enable' , 'on');
      set(QTEMP5, 'visible', 'on');
  
    case 3		%winNMR
      %
      %for the WINNMR format it the parameter files may be read and so the time domain size buttons
      %may or may not be enabled, depending on whether the parameter files must be read
      %
      if ~get(QTEMP4, 'value')
        set(QTEMP2, 'enable' , 'on');
        set(QTEMP3, 'visible', 'on');
  
      else
        set(QTEMP2, 'enable' , 'off');
        set(QTEMP3, 'visible', 'off');
      end
      set(QTEMP4, 'enable' , 'on');
      set(QTEMP5, 'visible', 'on');
  
    case 4		%UXNMR
      %
      %for the UXNMR format it the parameter files may be read and so the time domain size buttons
      %may or may not be enabled, depending on whether the parameter files must be read
      %
      if ~get(QTEMP4, 'value')
        set(QTEMP2, 'enable' , 'on');
        set(QTEMP3, 'visible', 'on');
  
      else
        set(QTEMP2, 'enable' , 'off');
        set(QTEMP3, 'visible', 'off');
      end
      set(QTEMP4, 'enable' , 'on');
      set(QTEMP5, 'visible', 'on');
  
    case 5		%VNMR
    %
    %For the VNMR format the parameter files can be chosen but the domain sizes never need to be filled in
    %
      set(QTEMP2, 'enable' , 'off');
      set(QTEMP3, 'visible', 'off');
      set(QTEMP4, 'enable' , 'on');
      set(QTEMP5, 'visible', 'on');
  
    case 6		%MacNMR
    %
    %For the MACNMR format the parameter files are always read
    %
      set(QTEMP2, 'enable' , 'off');
      set(QTEMP3, 'visible', 'off');
      set(QTEMP4, 'enable' , 'off');
      set(QTEMP5, 'visible', 'off');
  
    case 7		%NTNMR
    %
    %For the NTNMR format the parameter files are always read
    %
      set(QTEMP2, 'enable' , 'off');
      set(QTEMP3, 'visible', 'off');
      set(QTEMP4, 'enable' , 'off');
      set(QTEMP5, 'visible', 'off');
  
    case 8		%Aspect
    %
    %For the Aspect formats the parameter files are always read
    %
      set(QTEMP2, 'enable' , 'off');
      set(QTEMP3, 'visible', 'off');
      set(QTEMP4, 'enable' , 'off');
      set(QTEMP5, 'visible', 'off');
  
  
    case 9		%JEOL
      %
      %for the JEOL Generic format it the parameter files may be read and so the time domain size buttons
      %may or may not be enabled, depending on whether the parameter files must be read
      %
      if ~get(QTEMP4, 'value')
        set(QTEMP2, 'enable' , 'on');
        set(QTEMP3, 'visible', 'on');
  
      else
        set(QTEMP2, 'enable' , 'off');
        set(QTEMP3, 'visible', 'off');
      end
      set(QTEMP4, 'enable' , 'on');
      set(QTEMP5, 'visible', 'on');
  
    case 10		%SMIS
    %
    %For the SMIS format the parameter files are always read
    %
      set(QTEMP2, 'enable' , 'off');
      set(QTEMP3, 'visible', 'off');
      set(QTEMP4, 'enable' , 'off');
      set(QTEMP5, 'visible', 'off');
  
    case 11		%CMXW
      %
      %for the Chemagnetics format it the parameter files may be read and so the time domain size buttons
      %may or may not be enabled, depending on whether the parameter files must be read
      %
      if ~get(QTEMP4, 'value')
        set(QTEMP2, 'enable' , 'on');
        set(QTEMP3, 'visible', 'on');
  
      else
        set(QTEMP2, 'enable' , 'off');
        set(QTEMP3, 'visible', 'off');
      end
      set(QTEMP4, 'enable' , 'on');
      set(QTEMP5, 'visible', 'on');
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
