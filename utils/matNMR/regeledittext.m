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
%regeledittext.m is the buttondownfcn for text labels in a peak list (contour window).
%19-08-'98

try
  if (QmatNMR.buttonList == 1) 			%OK
    QTEMP1 = deblank(QmatNMR.FontList(QmatNMR.uiInput2, :));
    
    QTEMP = ['6 ';'7 ';'8 ';'9 ';'10';'11';'12';'14';'16';'18';'20';'22';'24';'30';'36';'48';'72'];
    QTEMP2 = eval(QTEMP(QmatNMR.uiInput3, :));
  
    QTEMP = ['light ';'normal';'demi  ';'bold  '];
    QTEMP3 = deblank(QTEMP(QmatNMR.uiInput4, :));
    
    QTEMP = ['normal ';'italic ';'oblique'];
    QTEMP4 = deblank(QTEMP(QmatNMR.uiInput5, :));
  
    QTEMP5 = eval(QmatNMR.uiInput6);
  
    set(str2num(QmatNMR.uiInput8), 'string', QmatNMR.uiInput1, 'fontname', QTEMP1, 'fontsize', QTEMP2, 'fontweight', QTEMP3, 'fontangle', QTEMP4, 'rotation', QTEMP5);
  
    if (QmatNMR.uiInput7)	%should we put the text in the center of the current axis?
      QTEMP4 = get(str2num(QmatNMR.uiInput8), 'extent');
      QTEMP5 = get(str2num(QmatNMR.uiInput8), 'position');
      set(str2num(QmatNMR.uiInput8), 'position', [((1-QTEMP4(3))/2) QTEMP5(2:3)]);
    end
  
    disp('Text label changed.');
  
  elseif (QmatNMR.buttonList == 2) 		%delete object
    delete(str2num(QmatNMR.uiInput8));
    disp('text object was deleted.'); 
  
  else 						%CANCEL
    disp('Text label was not changed.');
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
