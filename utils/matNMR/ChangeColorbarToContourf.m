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
%ChangeColorbarToContourf.m modifies a colorbar such that the
%colors from the colormap are shown using a PATCH instead of an IMAGE.
%This makes the colormap printable as mif.
%
%27-07-2001
%


function ChangeColorbarToContourf(CurrentAxisHandle, ColorbarAxisHandle)
  
  %
  %First we extract the important things from the current colorbar
  %
  CurrentFigure = get(CurrentAxisHandle, 'parent');
  ColorbarAxisYLim = get(ColorbarAxisHandle, 'ylim');
  ColorbarAxisYTick = get(ColorbarAxisHandle, 'ytick');
  ColorbarUserdata = get(ColorbarAxisHandle, 'userdata');
  ColorbarImageHandle = get(ColorbarAxisHandle, 'children');

  ColorbarDeleteFcn = get(ColorbarImageHandle, 'deletefcn');
  ColorbarTag = get(ColorbarImageHandle, 'tag');
  if (iscell(ColorbarTag))		%when executing this function on a plot with a
  					%colorbar of filled contours these variables will be
					%cell arrays!
    ColorbarTag = ColorbarTag{1};
    ColorbarDeleteFcn = ColorbarDeleteFcn{1};
  end
  
  %
  %Now we can delete the colorbar image, after we set deletefunction off!
  %
  set(ColorbarImageHandle, 'deletefcn', '');
  delete(ColorbarImageHandle)
  
  %
  %And now we create the filled contours in the ColorbarAxisHandle
  %
  axes(ColorbarAxisHandle);
  contourf([0 1], ColorbarAxisYLim, [0 0; 1 1], 150);
  
  ColorbarPatchHandles = get(ColorbarAxisHandle, 'children');
  caxis([0 1]);
  set(ColorbarPatchHandles, 'deletefcn', ColorbarDeleteFcn, 'tag', ColorbarTag);
  axis([0 1 ColorbarAxisYLim])
  shading flat
  set(ColorbarAxisHandle, 'yaxislocation', 'right', 'xtick', [], ...
                          'ytick', ColorbarAxisYTick, 'userdata', ColorbarUserdata);
  view([0 90]);

  %add SelectAxis to the buttondownfunction of the colorbar
  set(ColorbarAxisHandle, 'buttondownfcn', 'SelectAxis');
  
  %axes(CurrentAxisHandle);
  set(CurrentFigure, 'currentaxes', CurrentAxisHandle);
  disp('Current colorbar converted to filled contours');
