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
%whataxis2d.m is used for the changing of an axis of a 2D contour plot
%03-07-'97

try
  QmatNMR.val = get(QmatNMR.s11, 'Value');
  QmatNMR.statuspar2d = QmatNMR.val;
  
  if (QmatNMR.statuspar2d == 4)		%time axis
    try
      delete(QmatNMR.statfig2d);
    end
    QmatNMR.statfig2d = [];
  
    %
    %switch figure if necessary only because this will cause an additional rendering step
    %
    if (gcf ~= QmatNMR.Fig2D3D)
      figure(QmatNMR.Fig2D3D);
    end
  
      				%check whether the current axis variable is a proper variable name
    if ~CheckVariableName(QmatNMR.UserDefAxisT1Cont)
      QmatNMR.UserDefAxisT1Cont = '';
    end
    if ~CheckVariableName(QmatNMR.UserDefAxisT2Cont)
      QmatNMR.UserDefAxisT2Cont = '';
    end
    QuiInput('Time Axis :', ' OK | CANCEL', 'regeltimeaxis2d', [], ...
           'Starting point TD 2 : ', QmatNMR.TimeAxisStartTD2, ...
           'Dwell per point TD 2 : ', QmatNMR.TimeAxisDwellTD2, ...
  	 'Save vector TD 2 as (optional) :', QmatNMR.UserDefAxisT2Cont, ...
           'Starting point TD 1 : ', QmatNMR.TimeAxisStartTD1, ...
           'Dwell per point TD 1 : ', QmatNMR.TimeAxisDwellTD1, ...
  	 'Save vector TD 1 as (optional) :', QmatNMR.UserDefAxisT1Cont);
  
  elseif (QmatNMR.statuspar2d == 5) 	%points axis
    try
      delete(QmatNMR.statfig2d);
    end
    QmatNMR.statfig2d = [];
  
    %
    %switch figure if necessary only because this will cause an additional rendering step
    %
    if (gcf ~= QmatNMR.Fig2D3D)
      figure(QmatNMR.Fig2D3D);
    end
  
    scale2d
  
  elseif (QmatNMR.statuspar2d == 6)	%user-defined axis
    try
      delete(QmatNMR.statfig2d);
    end
    QmatNMR.statfig2d = [];
  
    %
    %switch figure if necessary only because this will cause an additional rendering step
    %
    if (gcf ~= QmatNMR.Fig2D3D)
      figure(QmatNMR.Fig2D3D);
    end
    
      				%check whether the current axis variable is a proper variable name
    if ~CheckVariableName(QmatNMR.UserDefAxisT1Cont)
      QmatNMR.UserDefAxisT1Cont = '';
    end
    if ~CheckVariableName(QmatNMR.UserDefAxisT2Cont)
      QmatNMR.UserDefAxisT2Cont = '';
    end
    QuiInput('User defined Axis :', ' OK | CANCEL', 'regelaxis2d', [], ...
           'Vector for TD 2 : ', QmatNMR.UserDefAxisT2Cont, ...
           'Vector for TD 1 : ', QmatNMR.UserDefAxisT1Cont);
  end

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
