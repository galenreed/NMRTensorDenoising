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
%stopfasemenu.m makes all buttons of the phasing panel invisible
%21-12-'96

try
  if QmatNMR.phasing > 0
    QmatNMR.phasing = 0;
  
    set(QmatNMR.p0  , 'visible', 'off');
    set(QmatNMR.p1  , 'visible', 'off');
    set(QmatNMR.p2  , 'visible', 'off');
    set(QmatNMR.p3  , 'visible', 'off');
    set(QmatNMR.p4  , 'visible', 'off');
    set(QmatNMR.p6  , 'visible', 'off');
    set(QmatNMR.p11 , 'visible', 'off');
    set(QmatNMR.p12 , 'visible', 'off');
    set(QmatNMR.p13 , 'visible', 'off');
    set(QmatNMR.p14 , 'visible', 'off');
    set(QmatNMR.p21 , 'visible', 'off');
    set(QmatNMR.p22 , 'visible', 'off');
    set(QmatNMR.p23 , 'visible', 'off');
    set(QmatNMR.p24 , 'visible', 'off');
    set(QmatNMR.p25 , 'visible', 'off');
    set(QmatNMR.p26 , 'visible', 'off');
    set(QmatNMR.p27 , 'visible', 'off');
    set(QmatNMR.p28 , 'visible', 'off');
    set(QmatNMR.p29 , 'visible', 'off');
    set(QmatNMR.p30 , 'visible', 'off');
    set(QmatNMR.p31 , 'visible', 'off');
    set(QmatNMR.p32 , 'visible', 'off');
    set(QmatNMR.p33 , 'visible', 'off');
    set(QmatNMR.p34 , 'visible', 'off');
    set(QmatNMR.p35 , 'visible', 'off');
    set(QmatNMR.p36 , 'visible', 'off');
    set(QmatNMR.p37 , 'visible', 'off');
    set(QmatNMR.p38 , 'visible', 'off');
    set(QmatNMR.fr4 , 'visible', 'off');
    set(QmatNMR.p5  , 'visible', 'off');
    set(QmatNMR.p51 , 'visible', 'off');
    set(QmatNMR.p52 , 'visible', 'off');
    set(QmatNMR.p15 , 'visible', 'off');
    set(QmatNMR.p151, 'visible', 'off');
    set(QmatNMR.p152, 'visible', 'off');
    set(QmatNMR.p281, 'visible', 'off');
    set(QmatNMR.p282, 'visible', 'off');
  end

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
