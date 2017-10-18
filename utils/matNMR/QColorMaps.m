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
%The function QColorMaps offers the possibility to change the color map for the contour and mesh 
%windows.
%17-4-'97

function QColorMaps(Value)

global QmatNMR

if (Value == 2)			%invert current colour map
  set(gcf, 'colormap', flipud(get(gcf, 'colormap')));
  disp('Colormap inverted');

elseif (Value == 3)		%adjust limits of posneg maps based on the spectrum in the current axis
  %
  %adjust the limits for the posneg colour maps based on the current spectrum
  %
  QTEMP1 = get(QmatNMR.Fig2D3D, 'userdata');

%adjusting to the current spectrum (below)
%  AdjustPosNeg(QTEMP1.PlotParams(QmatNMR.AxisNR2D3D).MinInt, QTEMP1.PlotParams(QmatNMR.AxisNR2D3D).MaxInt);
%has been changed to adjusting to current caxis settings
  QTEMP2 = caxis;
  AdjustPosNeg(QTEMP2(1), QTEMP2(2));

  disp('PosNeg Colormaps adjusted to the maximum and minimum of the current spectrum');

  %apply the last-used PosNeg colourmap to the current window
  colormap(eval(QmatNMR.PosNegMapLast));

elseif (Value == 4)		%reset limits of posneg maps
  AdjustPosNeg;
  disp('PosNeg Colormaps reset');

elseif (Value > 4)		%select new colour map
  if (findstr(QmatNMR.PopupStr2(Value, :), 'PosNeg'))
    QmatNMR.PosNegMapLast = deblank(QmatNMR.PopupStr2(Value, :));
  end  
  colormap(eval(QmatNMR.PopupStr2(Value, :)));

  disp(['Colormap changed to : ' QmatNMR.PopupStr(Value, :)]);
end

