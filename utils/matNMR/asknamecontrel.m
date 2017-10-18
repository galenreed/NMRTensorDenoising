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
%asknamecontrel.m takes care of getting the required input for relative contours with cont.m
%28-12-'96

try
  %
  %It is possible to specify different numbers of contours for plots with both
  %positive and negative contours. To do this one must specify a vector of 2
  %values instead a single number. In the case that QmatNMR.numbcont is a vector we
  %need to create a proper string for QuiInput.m.
  %
  if (length(QmatNMR.numbcont) > 1)
    QTEMP = ['[' num2str(QmatNMR.numbcont(1)) ' ' num2str(QmatNMR.numbcont(2)) ']'];
  else
    QTEMP = QmatNMR.numbcont;
  end
      
  %
  %switch figure if necessary only because this will cause an additional rendering step
  %
  if (gcf ~= QmatNMR.Fig2D3D)
    figure(QmatNMR.Fig2D3D);
  end
  drawnow
  QuiInput('Display Relative Contours of :', ' OK | CANCEL', 'regelcont', [], ...
           'Name Spectrum :', QmatNMR.SpecName2D3D, ...
           'Lower countour limit in % of the maximum : ', QmatNMR.under, ...
           'Upper countour limit in % of the maximum : ', QmatNMR.over, ...
  	 'Multiplier (1 = linear)', QmatNMR.multcont, ...
           'Number of contours :', QTEMP, ...
           '&POType of contours|Only Positive|Only Negative|Abs. Pos. and Abs. Neg.|Positive and Negative rel. to Positive Maximum|Positive and Negative rel. to Negative Maximum', QmatNMR.negcont, ...
           'Vector for TD2-axis (empty line gives current axis) :', QmatNMR.UserDefAxisT2Cont, ...
           'Vector for TD1-axis (empty line gives current axis) :', QmatNMR.UserDefAxisT1Cont, ...
  	 'Linespec (optional) :', QmatNMR.ContourLineSpec, ...
  	 'Plotting Macro (optional) :', QmatNMR.Q2D3DMacro);

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
