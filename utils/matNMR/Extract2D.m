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
function ret = Extract2D(var1)

global QmatNMR

if (var1 > 0)
  set(QmatNMR.Fig2D3D,'windowbuttondownfcn',['Extract2D(0);'], ...
          'windowbuttonupfcn','', ...
          'windowbuttonmotionfcn','',...
          'buttondownfcn', '', ...
          'interruptible','on')
  set(QmatNMR.AxisHandle2D3D,'interruptible','on', 'buttondownfcn', '');

  disp('Extraction mode: select a part of the spectrum to extract (use left mouse button)');
  disp('Right button cancels extraction');

else
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
      rbbox;
      eindpunt = get(QmatNMR.AxisHandle2D3D,'currentpoint');
    end

				%
				%sort output such that matrix is:  [top-left-X    top-left-Y]
				%                                  [bot-right-X  bot-right-Y]
				%
    QmatNMR.Pos = [sort([beginpunt(1,1); eindpunt(1,1)]) sort([beginpunt(1,2); eindpunt(1,2)])];

				%Now determine the QmatNMR.Position in points
    QTEMP = get(QmatNMR.Fig2D3D, 'userdata');		%extract the userdata from the figure window
					       	%read offset and slope of the axes vectors in the plot
    QmatNMR.AxisData = QTEMP.PlotParams(QmatNMR.AxisNR2D3D).AxisProps;
    QmatNMR.SpecName2D3D = QTEMP.PlotParams(QmatNMR.AxisNR2D3D).Name;
    QmatNMR.SizeTD2 = QTEMP.PlotParams(QmatNMR.AxisNR2D3D).SizeTD2;
    QmatNMR.SizeTD1 = QTEMP.PlotParams(QmatNMR.AxisNR2D3D).SizeTD1;
    if (QmatNMR.AxisData(1))		%linear axis in TD2 -> use axis increment and offset values to create axis vector
      QmatNMR.Axis2D3DTD2 = [QmatNMR.AxisData(2) + QmatNMR.AxisData(1)*(1:QmatNMR.SizeTD2)];
    
    else			%extract axis vector directly from userdata
      QmatNMR.Axis2D3DTD2 = QTEMP.PlotParams(QmatNMR.AxisNR2D3D).AxisTD2;
    end  

    if (QmatNMR.AxisData(3))		%linear axis in TD1 -> use axis increment and offset values to create axis vector
      QmatNMR.Axis2D3DTD1 = [QmatNMR.AxisData(4) + QmatNMR.AxisData(3)*(1:QmatNMR.SizeTD1)];
    
    else			%extract axis vector directly from userdata
      QmatNMR.Axis2D3DTD1 = QTEMP.PlotParams(QmatNMR.AxisNR2D3D).AxisTD1;
    end  
    
					       	%and from them determine the real position in points

    if ~ isempty(QmatNMR.AxisData)			%when the user has plotted some spectrum himself
	    					%into the contour window then probably the axes information
						%will not have been written into the userdata property.
						%Then this could give errors ...
      
      %
      %first determine the coordinate in points. The method depends on whether the axis
      %was linear or non-linear.
      %
      if (QmatNMR.AxisData(1))		%linear axis in TD2 -> use axis increment and offset values
        X = round((QmatNMR.Pos(1:2, 1)-QmatNMR.AxisData(2)) ./ QmatNMR.AxisData(1));
      else
      				%non-linear axis -> use the minimum distance to the next point in the axis vector
        [X, QTEMP2] = min(abs(QmatNMR.Axis2D3DTD2 - QmatNMR.Pos(1, 1)));
        [X, QTEMP3] = min(abs(QmatNMR.Axis2D3DTD2 - QmatNMR.Pos(2, 1)));
        X = [TEMP2 QTEMP3];
      end
      
      if (QmatNMR.AxisData(3))		%linear axis in TD1 -> use axis increment and offset values
        Y = round((QmatNMR.Pos(1:2, 2)-QmatNMR.AxisData(4)) ./ QmatNMR.AxisData(3));
      else
      				%non-linear axis -> use the minimum distance to the next point in the axis vector
        [Y, QTEMP2] = min(abs(QmatNMR.Axis2D3DTD1 - QmatNMR.Pos(1, 2)));
        [Y, QTEMP3] = min(abs(QmatNMR.Axis2D3DTD1 - QmatNMR.Pos(2, 2)));
        Y = [TEMP2 QTEMP3];
      end

    
				%Check whether the coordinates are within the matrix bounds
      if (X(1) < 1); X(1)=1; end
      if (X(2) > max(QmatNMR.SizeTD2)); X(2)=max(QmatNMR.SizeTD2); end
      if (Y(1) < 1); Y(1)=1; end
      if (Y(2) > max(QmatNMR.SizeTD1)); Y(2)=max(QmatNMR.SizeTD1); end

				%restore the windowbuttondownfunction.
      set(QmatNMR.Fig2D3D,'windowbuttondownfcn','', ...
          'windowbuttonupfcn','', ...
          'windowbuttonmotionfcn','',...
          'interruptible','on')
%      set(QmatNMR.AxisHandle2D3D,'interruptible','on', 'buttondownfcn', 'SelectAxis')
      Arrowhead
      drawnow

      disp('matNMR NOTE: due to a MATLAB bug/feature the input window has been put behind the current');
      disp('matNMR NOTE: window. Please go back to this window to continue. Sorry!');
      if strcmp(QmatNMR.SpecName2D3D, 'QmatNMR.Spec2D')
        QuiInput('Extract part of 2D spectrum :', ' OK | CANCEL', 'regelextract', [], ...
      		'Save as :', '', ...
		'Range :', [num2str(QmatNMR.Axis2D3DTD1(Y(1))) ':' num2str(QmatNMR.Axis2D3DTD1(Y(2))) ', ' num2str(QmatNMR.Axis2D3DTD2(X(1))) ':' num2str(QmatNMR.Axis2D3DTD2(X(2)))], ...
		'&CKRedraw Spectrum ?', 1);
      else
        QuiInput('Extract part of 2D spectrum :', ' OK | CANCEL', 'regelextract', [], ...
      		'Save as :', QmatNMR.SpecName2D3D, ...
		'Range :', [num2str(QmatNMR.Axis2D3DTD1(Y(1))) ':' num2str(QmatNMR.Axis2D3DTD1(Y(2))) ', ' num2str(QmatNMR.Axis2D3DTD2(X(1))) ':' num2str(QmatNMR.Axis2D3DTD2(X(2)))], ...
		'&CKRedraw Spectrum ?', 1);
      end
    else
      %no axis information was found in the userdata
      %cancel now!
      error('matNMR ERROR: cannot find axis properties in figure window''s userdata. Aborting ...');
    end  

  else				%Right button was pressed --> stop routine  
    set(QmatNMR.Fig2D3D,'windowbuttondownfcn','', ...
          'windowbuttonupfcn','', ...
          'windowbuttonmotionfcn','',...
          'buttondownfcn', 'SelectFigure', ...
          'interruptible','on')
    set(QmatNMR.AxisHandle2D3D,'interruptible','on', 'buttondownfcn', 'SelectAxis')
    Arrowhead

    disp('Extraction cancelled ...');
  end
end
