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
function ret = Integrate2D(var1)

global QmatNMR

if (var1 > 0)
  set(gcf,'windowbuttondownfcn',['Integrate2D(' num2str(-var1) ');'], ...
          'windowbuttonupfcn','', ...
          'windowbuttonmotionfcn','',...
          'interruptible','on')
  set(gca,'interruptible','on', 'buttondownfcn', '')
  
  disp('Integrating mode: select a part of the spectrum to integrate (use left mouse button)');
  disp('Right button cancels integration');

else
  button = get(gcf, 'SelectionType');
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
      beginpunt = get(gca,'currentpoint');

      rbbox([get(gcf,'currentpoint') 0 0],get(gcf,'currentpoint'));
      eindpunt = get(gca,'currentpoint');
    end

				%
				%sort output such that matrix is:  [top-left-X    top-left-Y]
				%                                  [bot-right-X  bot-right-Y]
				%
    Pos = [sort([beginpunt(1,1); eindpunt(1,1)]) sort([beginpunt(1,2); eindpunt(1,2)])];

				%Now determine the position in points
    QTEMP = get(QmatNMR.Fig2D3D, 'userdata');
	    						%read offset and slope of the axes vectors in the plot
    QmatNMR.AxisData = QTEMP.PlotParams(QmatNMR.AxisNR2D3D).AxisProps;
	    						%and from them determine the real position in points

    X = sort(round((Pos(1:2, 1)-QmatNMR.AxisData(2)) ./ QmatNMR.AxisData(1)));
    Y = sort(round((Pos(1:2, 2)-QmatNMR.AxisData(4)) ./ QmatNMR.AxisData(3)));
    
				%Check whether the coordinates are within the matrix bounds
    [QmatNMR.tmp1, QmatNMR.tmp2] = size(QmatNMR.Spec2D3D);
    if (X(1) < 1); X(1)=1; end
    if (X(2) > max(QmatNMR.tmp2)); X(2)=max(QmatNMR.tmp2); end
    if (Y(1) < 1); Y(1)=1; end
    if (Y(2) > max(QmatNMR.tmp1)); Y(2)=max(QmatNMR.tmp1); end

    if (var1 == -1)	%mode is "get integral"
      disp(['Integral of selected region is: ' num2str(sum(sum(real(QmatNMR.Spec2D3D(Y(1):Y(2), X(1):X(2)))))) '  (standard deviation = ' num2str(std(reshape(real(QmatNMR.Spec2D3D(Y(1):Y(2), X(1):X(2))), length(Y(1):Y(2))*length(X(1):X(2)), 1))) ')']);
    
    elseif (var1 == -2)	%mode is "set integral"
				%restore the windowbuttondownfunction.      
      set(gcf,'windowbuttondownfcn','', ...
            'windowbuttonupfcn','', ...
            'windowbuttonmotionfcn','',...
            'interruptible','on')
      set(gca,'interruptible','on', 'buttondownfcn', 'SelectAxis')
      Arrowhead
  
      if strcmp(QmatNMR.SpecName2D3D, 'QmatNMR.Spec2D')
        QuiInput('Integrate 2D spectrum :', ' OK | CANCEL', 'regelintegrate', [], 'Save as :', '', 'Integration range (TD1, TD2) :', [num2str(Y(1)) ':' num2str(Y(2)) ', ' num2str(X(1)) ':' num2str(X(2))], 'Integration value :', QmatNMR.IntegrationValue);
      else
        QuiInput('Integrate 2D spectrum :', ' OK | CANCEL', 'regelintegrate', [], 'Save as :', QmatNMR.SpecName2D3D, 'Integration range (TD1, TD2) :', [num2str(Y(1)) ':' num2str(Y(2)) ', ' num2str(X(1)) ':' num2str(X(2))], 'Integration value :', QmatNMR.IntegrationValue);
      end
    end  

  else				%Right button was pressed --> stop routine  
    set(gcf,'windowbuttondownfcn','', ...
          'windowbuttonupfcn','', ...
          'windowbuttonmotionfcn','',...
          'interruptible','on')
    set(gca,'interruptible','on', 'buttondownfcn', 'SelectAxis')
    Arrowhead

    disp('Integration cancelled ...');
  end
end
