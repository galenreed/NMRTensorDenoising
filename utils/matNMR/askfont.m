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
%askfont.m takes care of the input for changing the font properties of the current axis
%31-03-'99

try
                                      %define the string of fonts for the input window
  QTEMP10 = gca;
  QTEMP1 = '&POText Font :';
  for QTEMP11=1:size(QmatNMR.FontList, 1)
    QTEMP1 = [QTEMP1 sprintf('|%s', deblank(QmatNMR.FontList(QTEMP11, :)))];
  end
                                      %determine current font name in the current axis
  for QTEMP11=1:size(QmatNMR.FontList, 1)
    if strcmp(deblank(QmatNMR.FontList(QTEMP11, :)), lower(get(QTEMP10, 'fontname')));
      break
    end
  end  

                                      %determine default font size
  QmatNMR.Ttmp=['6 ';'7 ';'8 ';'9 ';'10';'11';'12';'14';'16';'18';'20';'22';'24';'30';'36';'48';'72'];
  for QTEMP12=1:14
    if strcmp(deblank(QmatNMR.Ttmp(QTEMP12, :)), num2str(get(QTEMP10, 'fontsize')));
      break
    end
  end;    

                                      %determine default font weight
  QmatNMR.Ttmp = ['light ';'normal';'demi  ';'bold  '];
  for QTEMP13=1:4
    if strcmp(deblank(QmatNMR.Ttmp(QTEMP13, :)), lower(get(QTEMP10, 'fontweight')));
      break
    end
  end;    


                                      %determine default font angle
  QmatNMR.Ttmp = ['normal ';'italic ';'oblique'];
  for QTEMP14=1:3
    if strcmp(deblank(QmatNMR.Ttmp(QTEMP14, :)), lower(get(QTEMP10, 'fontangle')));
      break;
    end
  end;    


  QuiInput('Change font properties :', ' OK | CANCEL', 'regelfont', [], ...
           [QTEMP1 '&CB1'], QTEMP11, ...
           '&POText Size :|6|7|8|9|10|11|12|14|16|18|20|22|24|30|36|48|72&CB1', QTEMP12, ...
           '&POText Weight :|Light|Normal|Demi|Bold&CB1', QTEMP13, ...
           '&POText Angle :|Normal|Italic|Oblique&CB1', QTEMP14, ...
           '&CKChange Axis ?', 1, ...
           '&CKChange Axis Labels ?', 1, ...
           '&CKChange Title ?', 1, ...
           '&POWhich subplots need to be changed?| Selected subplots OR current axis | All subplots | Current row | Current Column', 1);

  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
