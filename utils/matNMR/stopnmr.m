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
%stopnmr.m stops the main window and all it's components but leaves any 2D/3D viewer
%window untouched.
%9-8-'96

try
  if (QmatNMR.buttonList == 1)
    disp('Please wait while matNMR is closing the main window ...');
  
  	%close input windows
    try
      delete(findobj(get(0, 'children'), 'tag', 'QmatNMR.uiInputWindow'));
    end
  
    %stepwise processing
    try
      delete(QmatNMR.FigureStepwise);
      QmatNMR.FigureStepwise = [];
    end
  
    %Ruler x-axis menu
    try
      delete(QmatNMR.statfig);
      QmatNMR.statfig = [];
    end
  
    %general options menu
    try
      delete(QmatNMR.ofig);
      QmatNMR.ofig = [];
    end
  
    %1D baseline correction menu
    try
      delete(QmatNMR.Basl1Dfig)
      QmatNMR.Basl1Dfig = [];
    end
  
    %2D baseline correction menu
    try
      delete(QmatNMR.Basl2Dfig)
      QmatNMR.Basl2Dfig = [];
    end
  
    %title/axis menu main window
    QmatNMR.Ph = findobj(allchild(0),'tag','KLabels');
    try
      delete(QmatNMR.Ph);
    end;
  
    %Legend menu main window
    QmatNMR.Ph = findobj(allchild(0),'tag','LegendWindow');
    try
      delete(QmatNMR.Ph);
    end;
  
    %3D panel for main window
    try
      delete(QmatNMR.fig3D)
      QmatNMR.fig3D = [];
    end
  
    %line options menu
    try
      delete(QmatNMR.leginp);
      QmatNMR.leginp = [];
    end
  
    %text options menu
    try
      delete(QmatNMR.leginp2);
      QmatNMR.leginp2 = [];
    end
  
    %screen settings menu
    try
      delete(QmatNMR.leginp3);
      QmatNMR.leginp3 = [];
    end
  
    %font list menu
    try
      delete(QmatNMR.leginp4);
      QmatNMR.leginp4 = [];
    end
  
    %colour scheme menu
    try
      delete(QmatNMR.leginp5);
      QmatNMR.leginp5 = [];
    end
  
    %file options menu
    try
      delete(QmatNMR.leginp6);
      QmatNMR.leginp6 = [];
    end
  
  
  	%Close the peakfit window(s)
    try
      delete(findobj(allchild(0), 'tag', 'Peakfit'));
    end
    try
      delete(findobj(allchild(0), 'tag', 'Peakfit2'));
    end
  
  
  	%Close the T1 fit window
    try
      delete(findobj(allchild(0), 'tag', 'T1fit'));
    end
  
  
  	%Close the Diffusion fit window
    try
      delete(findobj(allchild(0), 'tag', 'Difffit'));
    end
  
  
		%Close the Quadrupolar-tensor fit window
    try
      delete(findobj(allchild(0), 'tag', 'QuadFit'));
    end
  
    %Close the CSA-tensor fit window
    try
      delete(findobj(allchild(0), 'tag', 'CSAFit'));
    end
  
		%Close the SSA fit window
    try
      delete(findobj(allchild(0), 'tag', 'SSAFit'));
    end
  
    try
      delete(QmatNMR.Fig);
      QmatNMR.Fig = [];
    end
  
    QmatNMR.Ph = findobj(allchild(0),'tag','2D/3D Viewer');
    if isempty(QmatNMR.Ph)	%if there is no 2D Viewer window open then we close off everything
			%Close the matNMR Help Desk window
      try
        delete(findobj(allchild(0),'tag','MatNMRHelpFigure'));
      end
  
      %mathelpprint window
      try
        delete(findobj(allchild(0),'tag','mathelpprint'));
      end
  
			%Close the matprint window
      try
        delete(findobj(allchild(0),'tag','matprint'));
      end
  
      eval(QmatNMR.RestoreUserDefaultValues);		%restore all user-defined default values that have been changed by matNMR
  
      disp([QmatNMR.VersionVar ' stopped ...']);
  
      clear global Q* 					%All matNMR variables have to go !
      clear Q*						%All matNMR variables have to go !
  
    else
      QmatNMR.Fig = [];					%the figure number is also a flag for whether it's open.
      disp('matNMR Main Window stopped ...');
    end
  
    clear functions;
  end

catch
  %
  %call the generic error handler routine if anything goes wrong
  %
  errorhandler
end
