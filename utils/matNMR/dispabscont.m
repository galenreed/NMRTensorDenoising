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
%dispabscont.m handles the plotting for the absolute contour part of cont.m
%4-12-'97

try
  watch;
  QmatNMR.ContType = 1;	%set the flag for absolute contour levels
  QmatNMR.RestorePeaklist = 0; 	%flag to make sure that plotcont executes the restorepeaklist routine
  QmatNMR.negcont = 1;	%prevent using QmatNMR.PosNeg colour map
  
  QmatNMR.titelstring2 = (['Absolute contour levels used.']);
  plotcont
  
  
  %
  %Execute a plotting macro if that was asked for
  %
    if ~isempty(QmatNMR.Q2D3DMacro)
      QmatNMR.LastMacroVariable = QmatNMR.Q2D3DMacro;
      QmatNMR.ExecutingMacro = eval(QmatNMR.Q2D3DMacro);
      tic
      RunMacro
      QmatNMR.Timing = toc;
      disp(['Finished executing macro "' QmatNMR.Q2D3DMacro '". Execution time (including rendering) was ' num2str(QmatNMR.Timing, 6) ' seconds']);
    end
  
    
  disp('finished making Contour plot');
  Arrowhead;  

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
