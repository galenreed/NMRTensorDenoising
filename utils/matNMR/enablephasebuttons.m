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
%enablephasebuttons.m makes all buttons of the phasing panel enabled again
%28-08-'98

try
  set(QmatNMR.p0  , 'enable', 'on');
  set(QmatNMR.p1  , 'enable', 'on');
  set(QmatNMR.p2  , 'enable', 'on');
  set(QmatNMR.p3  , 'enable', 'on');
  set(QmatNMR.p4  , 'enable', 'on');
  set(QmatNMR.p6  , 'enable', 'on');
  set(QmatNMR.p11 , 'enable', 'on');
  set(QmatNMR.p12 , 'enable', 'on');
  set(QmatNMR.p13 , 'enable', 'on');
  set(QmatNMR.p14 , 'enable', 'on');
  set(QmatNMR.p21 , 'enable', 'on');
  set(QmatNMR.p22 , 'enable', 'on');
  set(QmatNMR.p23 , 'enable', 'on');
  set(QmatNMR.p29 , 'enable', 'on');
  set(QmatNMR.p31 , 'enable', 'on');
  set(QmatNMR.p32 , 'enable', 'on');
  set(QmatNMR.p33 , 'enable', 'on');
  set(QmatNMR.p34 , 'enable', 'on');
  set(QmatNMR.p35 , 'enable', 'on');
  set(QmatNMR.p36 , 'enable', 'on');
  set(QmatNMR.p37 , 'enable', 'on');
  set(QmatNMR.p38 , 'enable', 'on');
  set(QmatNMR.fr4 , 'enable', 'on');
  set(QmatNMR.p5  , 'enable', 'on');
  set(QmatNMR.p51 , 'enable', 'on');
  set(QmatNMR.p52 , 'enable', 'on');
  set(QmatNMR.p15 , 'enable', 'on');
  set(QmatNMR.p151, 'enable', 'on');
  set(QmatNMR.p152, 'enable', 'on');

%
%2nd order phase correction buttons
%
  set(QmatNMR.p24 , 'enable', 'on');
  set(QmatNMR.p25 , 'enable', 'on');
  set(QmatNMR.p26 , 'enable', 'on');
  set(QmatNMR.p27 , 'enable', 'on');
  set(QmatNMR.p28 , 'enable', 'on');
  set(QmatNMR.p30 , 'enable', 'on');
  set(QmatNMR.p281, 'enable', 'on');
  set(QmatNMR.p282, 'enable', 'on');

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
