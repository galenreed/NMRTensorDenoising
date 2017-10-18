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
%Marker.m sets the Marker in the current axis to a certain value ...
%
%11-06-'98

function ret = Marker(Var);

  global QmatNMR

  QTEMP20 = gca;	%the current axis
  QTEMP21 = gcf; 	%the current figure window


  %
  %Add an entry to the plotting macro if we're recording one
  %
  if (QmatNMR.RecordingPlottingMacro)
    %
    %first store the list of selected regular axes unless none were selected
    %
    QTEMP11 = 0;
    QmatNMR.AllAxes = findobj(findobj(QTEMP21, 'type', 'axes', 'tag', 'RegularAxis'), 'selected', 'on');
    if ~isempty(QmatNMR.AllAxes)     %only store if at least 1 axis is selected
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
    %then store the input strings
    %
    QTEMP11 = double(['QmatNMR.uiInput1 = ''' Var '''']);
    QTEMP12 = ceil(length(QTEMP11)/(QmatNMR.MacroLength-1));
    QTEMP13 = zeros(1, QTEMP12*(QmatNMR.MacroLength-1));
    QTEMP13(1:length(QTEMP11)) = QTEMP11;
    for QTEMP40=1:QTEMP12
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 711, QTEMP13((QTEMP40-1)*(QmatNMR.MacroLength-1)+ (1:(QmatNMR.MacroLength-1))));
    end
    QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 712);


    %
    %Finally we store the processing action
    %
    QTEMP12 = get(get(QTEMP20, 'parent'), 'userdata');	%to allow extraction of the subplot code
    QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 735, QTEMP12.SubPlots, get(QTEMP20, 'userdata'));
  end


  %
  %Perform the action
  %
  %
  %check whether multiple axes are selected. If so apply change to all of them.
  %If no axis is selected the the current axis will be used
  QmatNMR.AllAxes = findobj(findobj(QTEMP21, 'type', 'axes'), 'selected', 'on');
  if isempty(QmatNMR.AllAxes)
    QmatNMR.AllAxes = QTEMP20;
  end

  QTEMP = get(QmatNMR.AllAxes, 'children');
  if iscell(QTEMP)
    QTEMP = cell2mat(QTEMP);
  end
  set(findobj(QTEMP, 'type', 'line'), 'Marker', Var);
  set(findobj(QTEMP, 'type', 'patch'), 'Marker', Var);
  set(findobj(QTEMP, 'type', 'Surface'), 'Marker', Var);

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
