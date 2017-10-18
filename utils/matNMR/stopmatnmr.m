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
%stopmatnmr.m clears all global memory and removes all variables shown below.
%9-8-'96

try
  if QmatNMR.buttonList == 1
    disp('Please wait while matNMR is closing windows ...');
  
    disp([QmatNMR.VersionVar ' stopped ...']);
  
		%close input windows
    try
      delete(findobj(get(0, 'children'), 'tag', 'QmatNMR.uiInputWindow'));
    end
  
    %axis labels window
    try
      delete(QmatNMR.Ttitlefig); 
    end
  
    %stepwise processing
    try
      delete(QmatNMR.FigureStepwise); 
    end
  
    %Ruler x-axis menu
    try
      delete(QmatNMR.statfig);
    end
  
    %general options menu
    try
      delete(QmatNMR.ofig);
    end
  
    %1D baseline correction menu
    try
      delete(QmatNMR.Basl1Dfig)
    end
  
    %2D baseline correction menu
    try
      delete(QmatNMR.Basl2Dfig)
    end
  
    %3D panel for main window
    try
      delete(QmatNMR.fig3D)
    end

    %title/axis menu main window
    try
      delete(findobj(allchild(0),'tag','KLabels'));
    end
  
    %Legend menu main window
    try
      delete(findobj(allchild(0),'tag','LegendWindow'));
    end
  
    %mathelpprint window
    try
      delete(findobj(allchild(0),'tag','mathelpprint'));
    end
  
    try
      delete(QmatNMR.statfig2d);
    end;  
  
    
    if QmatNMR.Fig2D3D > 0		%2D Viewer
      QmatNMR.Ph = findobj(allchild(0),'tag','2D/3D Viewer');
      try
        delete(QmatNMR.Ph);
      end
      try
        delete(QmatNMR.Q2DButtonPanel);
      end

      %title/axis menu contour window
      QmatNMR.Ph = findobj(allchild(0),'tag','CLabels');
      try
        delete(QmatNMR.Ph);
      end;  
    end
  
    %line options menu
    try
      delete(QmatNMR.leginp);
    end
  
    %text options menu
    try
      delete(QmatNMR.leginp2);
    end
  
    %screen settings menu
    try
      delete(QmatNMR.leginp3);
    end
  
    %font list menu
    try
      delete(QmatNMR.leginp4);
    end
  
    %colour scheme menu
    try
      delete(QmatNMR.leginp5);
    end
  
    %file options menu
    try
      delete(QmatNMR.leginp6);
    end
    
		%Close the matprint window
    try
      delete(findobj(allchild(0),'tag','matprint'));
    end

		%Close the peakfit window
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
  
		%Close the matNMR Help Desk window
    try
      delete(findobj(allchild(0),'tag','MatNMRHelpFigure'));
    end

    try
      delete(QmatNMR.Fig);
    end

    eval(QmatNMR.RestoreUserDefaultValues);		%restore all user-defined default values that have been changed by matNMR
  
  							%All matNMR variables have to go !
    clear global QmatNMR* 				%All matNMR variables have to go !
    clear QmatNMR* QTEMP* 				%All matNMR variables have to go !
    clear functions;
  end  

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
