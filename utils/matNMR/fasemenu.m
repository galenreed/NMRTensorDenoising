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
%fasemenu.m makes all buttons of the phasing panel visible again
%21-12-'96

try
  if QmatNMR.phasing == 0
    QmatNMR.phasing = 1;
  
    set(QmatNMR.p0  , 'visible', 'on');
    set(QmatNMR.p1  , 'visible', 'on');
    set(QmatNMR.p2  , 'visible', 'on');
    set(QmatNMR.p3  , 'visible', 'on');
    set(QmatNMR.p4  , 'visible', 'on');
    set(QmatNMR.p6  , 'visible', 'on');
    set(QmatNMR.p11 , 'visible', 'on');
    set(QmatNMR.p12 , 'visible', 'on');
    set(QmatNMR.p13 , 'visible', 'on');
    set(QmatNMR.p14 , 'visible', 'on');
    set(QmatNMR.p21 , 'visible', 'on');
    set(QmatNMR.p22 , 'visible', 'on');
    set(QmatNMR.p23 , 'visible', 'on');
    set(QmatNMR.p29 , 'visible', 'on');
    set(QmatNMR.p31 , 'visible', 'on');
    set(QmatNMR.fr4 , 'visible', 'on');
    set(QmatNMR.p5  , 'visible', 'on');
    set(QmatNMR.p51 , 'visible', 'on');
    set(QmatNMR.p52 , 'visible', 'on');
    set(QmatNMR.p15 , 'visible', 'on');
    set(QmatNMR.p151, 'visible', 'on');
    set(QmatNMR.p152, 'visible', 'on');
  
  
    %
    %switch on the 2nd order phase correction buttons only when the appropriate
    %check button is on
    if get(QmatNMR.p29, 'value')
      set(QmatNMR.p24 , 'visible', 'on');
      set(QmatNMR.p25 , 'visible', 'on');
      set(QmatNMR.p26 , 'visible', 'on');
      set(QmatNMR.p27 , 'visible', 'on');
      set(QmatNMR.p28 , 'visible', 'on');
      set(QmatNMR.p30 , 'visible', 'on');
      set(QmatNMR.p281, 'visible', 'on');
      set(QmatNMR.p282, 'visible', 'on');
    end
  
  
    %
    %switch on the 2D phasing aid buttons only when the appropriate
    %check button is on
    if get(QmatNMR.p31, 'value')
      set(QmatNMR.p32 , 'visible', 'on');
      set(QmatNMR.p33 , 'visible', 'on');
      set(QmatNMR.p34 , 'visible', 'on');
      set(QmatNMR.p35 , 'visible', 'on');
      set(QmatNMR.p36 , 'visible', 'on');
      set(QmatNMR.p37 , 'visible', 'on');
      set(QmatNMR.p38 , 'visible', 'on');
    end
  end

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
