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
% regelinputbuttonsimportMRISeries
%
% allows switching of the 'enable' parameter of the uicontrols in the input window
% when loading series of MRI data. This is useful since for certain file formats the user
% does not need to give the time domain sizes as these are read from the file itself.
%
% 22-02-'10


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
    case 1		%SMIS .mrd format
    %
    %For this format the parameters never need to be filled in
    %
      set(QTEMP2, 'enable' , 'off');
      set(QTEMP3, 'visible', 'off');
      set(QTEMP4, 'enable' , 'off');
      set(QTEMP5, 'visible', 'off');
  
    case 2		%Siemens.rda format
    %
    %For this format the parameters never need to be filled in
    %
      set(QTEMP2, 'enable' , 'off');
      set(QTEMP3, 'visible', 'off');
      set(QTEMP4, 'enable' , 'off');
      set(QTEMP5, 'visible', 'off');
  
    case 3		%Siemens .raw format
    %
    %For this format the parameters must always be filled in
    %
      set(QTEMP2, 'enable' , 'on');
      set(QTEMP3, 'visible', 'on');
      set(QTEMP4, 'enable' , 'off');
      set(QTEMP5, 'visible', 'off');
  
    case 4		%DICOM format
    %
    %For this format the parameters never need to be filled in
    %
      set(QTEMP2, 'enable' , 'off');
      set(QTEMP3, 'visible', 'off');
      set(QTEMP4, 'enable' , 'off');
      set(QTEMP5, 'visible', 'off');
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
