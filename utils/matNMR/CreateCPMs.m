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
%CreateCPMs.m handles the creation of conditional probability matrices (CPMs) in matNMR. 
%It is a rather simplistic routine though.
%
%based on GetPeaks!
%
%The idea for the CPMs comes from the paper by Sylvian Cadars, Anne Lesage and Lyndom Emsley, JACS 2005
%The output was copied from that produced by Sylvian's Matlab script.
%
%23-09-'05

function [x, y, value, button] = CreateCPMs(var1)

%
%first define all standard matNMR globals within this function so we can create new 2D/3D viewer windows
%at will.
%
global QmatNMR

%
%run the routine
%
if (var1 == 1) 		%start the routine by defining a windowbuttondown function
  set(QmatNMR.Fig2D3D,'windowbuttondownfcn',['SelectFigure; CreateCPMs(0);'], ...
          'windowbuttonupfcn','', ...
          'windowbuttonmotionfcn','',...
          'interruptible','on')
  set(QmatNMR.AxisHandle2D3D,'interruptible','on', 'buttondownfcn', '')

else
  %
  %the routine
  %
  button = get(QmatNMR.Fig2D3D, 'SelectionType');
  if strcmp(button,'normal')
    button = 1;
  elseif strcmp(button,'extend')
    button = 2;
  elseif strcmp(button,'alt')
    button = 3;
  end


  if (button == 1)		%Left button was pressed --> select peak
    eindpunt = 0;
    while (eindpunt == 0)
      beginpunt = get(QmatNMR.AxisHandle2D3D,'currentpoint');

      rbbox([get(QmatNMR.Fig2D3D,'currentpoint') 0 0],get(QmatNMR.Fig2D3D,'currentpoint'));
      eindpunt = get(QmatNMR.AxisHandle2D3D,'currentpoint');
    end
    
    %
    %Prevent action when the left button was pushed but no peak was selected!
    %
    if isequal(beginpunt, eindpunt)
      return
    end

				%
				%sort output such that matrix is:  [top-left-X    top-left-Y]
				%                                  [bot-right-X  bot-right-Y]
				%
    QmatNMR.Pos = [sort([beginpunt(1,1); eindpunt(1,1)]) sort([beginpunt(1,2); eindpunt(1,2)])];


				%Extract plot parameters from the figure window's userdata
    QTEMP1 = get(QmatNMR.Fig2D3D, 'userdata');				
    QmatNMR.AxisData = QTEMP1.PlotParams(QmatNMR.AxisNR2D3D).AxisProps;
    if ~(QmatNMR.AxisData(1))		%non-linear axis in TD2 -> extract axis vector directly from userdata
      QmatNMR.Axis2D3DTD2 = QTEMP1.PlotParams(QmatNMR.AxisNR2D3D).AxisTD2;
    end  

    if ~(QmatNMR.AxisData(3))		%non-linear axis in TD1 -> extract axis vector directly from userdata
      QmatNMR.Axis2D3DTD1 = QTEMP1.PlotParams(QmatNMR.AxisNR2D3D).AxisTD1;
    end  

    if ~ isempty(QmatNMR.AxisData)			%when the user has plotted some spectrum himself
	    					%into the contour window then probably the axes information
						%will not have been written into the userdata property.
						%Then this could give errors ...

      %
      %now determine the coordinate in points. The method depends on whether the axis
      %was linear or non-linear.
      %
      if (QmatNMR.AxisData(1))		%linear axis in TD2 -> use axis increment and offset values
        X = round((QmatNMR.Pos(1:2, 1)-QmatNMR.AxisData(2)) ./ QmatNMR.AxisData(1));
      else
      				%non-linear axis -> use the minimum distance to the next point in the axis vector
        [X, QTEMP2] = min(abs(QmatNMR.Axis2D3DTD2 - QmatNMR.Pos(1, 1)));
        [X, QTEMP3] = min(abs(QmatNMR.Axis2D3DTD2 - QmatNMR.Pos(2, 1)));
        X = [QTEMP2 QTEMP3];
      end
      
      if (QmatNMR.AxisData(3))		%linear axis in TD1 -> use axis increment and offset values
        Y = round((QmatNMR.Pos(1:2, 2)-QmatNMR.AxisData(4)) ./ QmatNMR.AxisData(3));
      else
      				%non-linear axis -> use the minimum distance to the next point in the axis vector
        [Y, QTEMP2] = min(abs(QmatNMR.Axis2D3DTD1 - QmatNMR.Pos(1, 2)));
        [Y, QTEMP3] = min(abs(QmatNMR.Axis2D3DTD1 - QmatNMR.Pos(2, 2)));
        Y = [QTEMP2 QTEMP3];
      end

    else
      %no axis information found. Cannot continue!
      error('matNMR ERROR: cannot find axis information in figure window''s userdata. Aborting ...');
    end
				%Check whether the coordinates are within the matrix bounds
    [QmatNMR.tmp1, QmatNMR.tmp2] = size(QmatNMR.Spec2D3D);
    X = sort(X);
    Y = sort(Y);
    if (X(1) < 1); X(1)=1; end
    if (X(2) > max(QmatNMR.tmp2)); X(2)=max(QmatNMR.tmp2); end
    if (Y(1) < 1); Y(1)=1; end
    if (Y(2) > max(QmatNMR.tmp1)); Y(2)=max(QmatNMR.tmp1); end

%
%ask the user in an additional input window for the coordinates in the units of the axes
%
    QuiInput('Define range for CPM :', ' OK | CANCEL', 'regelCPMs', [], ...
             'Range (TD1, TD2) :', [num2str(QmatNMR.Axis2D3DTD1(Y(1))) ':' num2str(QmatNMR.Axis2D3DTD1(Y(2))) ', ' num2str(QmatNMR.Axis2D3DTD2(X(1))) ':' num2str(QmatNMR.Axis2D3DTD2(X(2)))]);


  elseif (button == 2)		%Middle button was pressed --> no function defined currently!
    disp('CreateCPMs: click left and drag to select a region of interest or right-click to stop')



  elseif (button == 3)		%Right button was pressed --> stop routine  
    disp('CreateCPMs stopped...');
    set(QmatNMR.Fig2D3D,'windowbuttondownfcn','SelectFigure', ...
          'windowbuttonupfcn','', ...
          'windowbuttonmotionfcn','',...
          'interruptible','on')
    set(QmatNMR.AxisHandle2D3D,'interruptible','on', 'buttondownfcn', 'SelectAxis')
    disp('  ');
    
    Arrowhead
  end
end
