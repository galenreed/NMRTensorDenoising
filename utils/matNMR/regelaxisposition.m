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
%regelaxisposition.m sets the position variable for the current axis
%05-02-'04

try
  if QmatNMR.buttonList == 1			%OK-button
    QTEMP20 = gca;	%the current axis
    QTEMP21 = gcf; 	%the current figure window
  
    QTEMP = eval(['[' QmatNMR.uiInput1 ' ' QmatNMR.uiInput2 ' ' QmatNMR.uiInput3 ' ' QmatNMR.uiInput4 ']']);
  
    QmatNMR.AllAxes = findobj(findobj(QTEMP21, 'type', 'axes'), 'selected', 'on');
    if (length(QmatNMR.AllAxes) > 1)
      disp('matNMR WARNING: multiple axes selected. Refusing to act ...');
      return
  
    else
      %
      %Add an entry to the plotting macro if we're recording one
      %
      if (QmatNMR.RecordingPlottingMacro)
        %
        %first store the list of selected regular axes unless none were selected
        %
        QTEMP11 = 0;
        if ~isempty(QmatNMR.AllAxes) & strcmp(get(QmatNMR.AllAxes, 'tag'), 'RegularAxis')  %only store if at least 1 regular axis is selected
  	QTEMP11 = length(QmatNMR.AllAxes);
  	QTEMP12 = ceil(QTEMP11/(QmatNMR.MacroLength-1));
          QTEMP13 = zeros(1, QTEMP12*(QmatNMR.MacroLength-1));
  	QTEMP14 = get(QmatNMR.AllAxes, 'userdata');
  	if iscell(QTEMP14)
  	  QTEMP14 = cell2mat(QTEMP14);
  	end
  	QTEMP13(1:QTEMP11) = QTEMP14;
  	for QTEMP40=1:QTEMP12
            QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 710, QTEMP13((QTEMP40-1)*(QmatNMR.MacroLength-1)+ (1:(QmatNMR.MacroLength-1))));
          end
        end
  
  
        %
        %Finally we store the processing action
        %
        QTEMP10 = get(get(QTEMP20, 'parent'), 'userdata');	%to allow extraction of the subplot code
        QTEMP11 = eval(QmatNMR.uiInput1);
        QTEMP12 = eval(QmatNMR.uiInput2);
        QTEMP13 = eval(QmatNMR.uiInput3);
        QTEMP14 = eval(QmatNMR.uiInput4);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 727, QTEMP10.SubPlots, QTEMP11, QTEMP12, QTEMP13, QTEMP14);
      end
    
    
      %
      %Perform the action
      %
      if isempty(QmatNMR.AllAxes)
        QmatNMR.AllAxes = QTEMP20;
      end
  
      set(QmatNMR.AllAxes, 'position', QTEMP);
      disp('Axis position changed for the current axis ...');
  
      %
      %make sure only the current axis is selected, if there are more than one axes in the list
      %
      QmatNMR.AllAxes = findobj(findobj(QTEMP21, 'type', 'axes'), 'selected', 'on');
      if (length(QmatNMR.AllAxes) > 0)
        set(QmatNMR.AllAxes, 'selected', 'off');
        set(QmatNMR.AxisHandle2D3D, 'selected', 'on');
        %axes(QmatNMR.AxisHandle2D3D);
        set(QTEMP21, 'currentaxes', QmatNMR.AxisHandle2D3D);
      end
  
      if (~QmatNMR.BusyWithMacro)
        drawnow
      end
    end
  
  else
    disp('Changing of axis position was cancelled ...');
  end  
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
