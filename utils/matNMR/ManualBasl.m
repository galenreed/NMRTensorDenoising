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
% ManualBasl.m does the manual baseline correction ...
%
% 11-2-'98
%
%

function ManualBasl(Command, FigHandle, Parameter, Increment)

if (nargin == 3)
  WindowButMotion = get(gcf, 'windowbuttonmotionfcn');
  
  if (length(WindowButMotion) > 4)		%pushing the button for a second time means: stop with this parameter
    set(gcf, 'WindowButtonMotionFcn', '', 'interruptible', 'on');      
  else						%pushing the button for the first time means: start optimizing this parameter
						%remember where the mouse was when the button was pushed
    drawnow;
    OrgPos = get(0, 'pointerlocation');
    OrgPosAxis = get(gca, 'currentpoint');

    QmatNMR.handles = get(gcf, 'userdata');
    A = QmatNMR.handles(4);
    B = QmatNMR.handles(5);
    C = QmatNMR.handles(6);
    D = QmatNMR.handles(7);
    E = QmatNMR.handles(8);
    F = QmatNMR.handles(9);
    set(gcf, 'userdata', [OrgPos OrgPosAxis(1,2) A B C D E F]);

    set(gcf, 'WindowButtonMotionFcn', ['ManualBasl(''move'', ' num2str(Command) ', ''' FigHandle ''', ''' Parameter ''');'], 'interruptible', 'off');
  end
  
elseif (strcmp(Command, 'move'))
  QmatNMR.handles = get(gcf, 'userdata');
  OrgPos = [QmatNMR.handles(1) QmatNMR.handles(2)];
  OrgPosAxis = QmatNMR.handles(3);
  A = QmatNMR.handles(4);
  B = QmatNMR.handles(5);
  C = QmatNMR.handles(6);
  D = QmatNMR.handles(7);
  E = QmatNMR.handles(8);
  F = QmatNMR.handles(9);
  
  CurPoint = get(gca, 'currentpoint');

  if (CurPoint(1,2) > OrgPosAxis)		%mouse moved down --> value goes down
    eval([Parameter ' = ' Parameter ' + ' Increment ';']);
    set(0, 'pointerlocation', OrgPos);
    
    set(gcf, 'userdata', [OrgPos OrgPosAxis A B C D E F]);

    ManualBasl('draw', FigHandle, 'dummy', 'dummy');
    
    
  elseif (CurPoint(1,2) < OrgPosAxis)		%mouse moved up   --> value goes up
    eval([Parameter ' = ' Parameter ' - ' Increment ';']);
    set(0, 'pointerlocation', OrgPos);
    
    set(gcf, 'userdata', [OrgPos OrgPosAxis A B C D E F]);
    
    ManualBasl('draw', FigHandle, 'dummy', 'dummy');
  end
  
  QTEMP1 = findobj(allchild(findobj(allchild(0), 'tag', 'baslcormenufig')), 'tag', [Parameter 'value']);
  set(QTEMP1, 'string', eval(Parameter));
  
elseif (strcmp(Command, 'setv'))
  OrgPos = get(0, 'pointerlocation');
  OrgPosAxis = get(gca, 'currentpoint');

  QmatNMR.handles = get(gcf, 'userdata');
  A = QmatNMR.handles(4);
  B = QmatNMR.handles(5);
  C = QmatNMR.handles(6);
  D = QmatNMR.handles(7);
  E = QmatNMR.handles(8);
  F = QmatNMR.handles(9);
  
  eval([Parameter ' = ' Increment ';']);
  
  set(gcf, 'userdata', [OrgPos OrgPosAxis(1,2) A B C D E F]);		%put values in the userdata of the baseline coreection window.
  									%the 'draw' command will also put them into the 'userdata' of the
									%main figure window.
  ManualBasl('draw', FigHandle, 'dummy', 'dummy');
  
elseif (strcmp(Command, 'draw'))
  QmatNMR.handles = get(gcf, 'userdata');
  OrgPos = [QmatNMR.handles(1) QmatNMR.handles(2)];
  OrgPosAxis = QmatNMR.handles(3);
  A = QmatNMR.handles(4);
  B = QmatNMR.handles(5);
  C = QmatNMR.handles(6);
  D = QmatNMR.handles(7);
  E = QmatNMR.handles(8);
  F = QmatNMR.handles(9);
  
						%The original spectrum was put in the userdata !
  OrgLineData = get(FigHandle, 'userdata');
  OrgLine = OrgLineData.Spectrum;
  BaslFunc = OrgLineData.BaslFunc;

						%Get the right handle for the line to be changed !
  QmatNMR.Temp = findobj(findobj(get(FigHandle, 'children'), 'type', 'axes'), 'type', 'line');
  OrgLineHandle = QmatNMR.Temp(length(QmatNMR.Temp));
  OrgAxisHandle = get(QmatNMR.Temp(length(QmatNMR.Temp)), 'parent');

    						%Evaluate the baseline correction for these parameters
  						%and display the corrected line
  x = 1:length(OrgLine);
  NewLine = eval(['OrgLine - (' BaslFunc ')']);
  
  OrgLineData.NewLine = NewLine;
  OrgLineData.Text = ['"' BaslFunc '"  --> (A=' num2str(A) ', B=' num2str(B) ', C=' num2str(C) ', D=' num2str(D) ', E=' num2str(E) ', F=' num2str(F) ')'];
  OrgLineData.Values = [A B C D E F];
  set(FigHandle, 'userdata', OrgLineData);
  set(OrgLineHandle, 'ydata', NewLine);
  
  if isempty(findobj(allchild(OrgAxisHandle), 'tag', 'ManualBaslcor'))
    QmatNMR.BaslLine = copyobj(OrgLineHandle, OrgAxisHandle);
    set(QmatNMR.BaslLine, 'color', 'b', 'ydata', eval(BaslFunc), 'tag', 'ManualBaslcor');
  else
    QmatNMR.BaslLine = findobj(allchild(OrgAxisHandle), 'tag', 'ManualBaslcor');
    set(QmatNMR.BaslLine, 'ydata', eval(BaslFunc));
  end  

end  
  
