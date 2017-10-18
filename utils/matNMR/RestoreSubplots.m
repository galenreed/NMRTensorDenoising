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
%RestoreSubplots.m handles the restoring of the size of the subplots in the contour and mesh window
%after the colorbar is removed.
%06-07-'98

function RestoreSubplots(FigHandle, Var)

global QmatNMR

%Restore the original sizes of the axes
  switch Var(1),

  case 1,				%1x1
    QTEMP1 = [0.80 0.80];

  case 3,				%2x1
    QTEMP1 = [0.80 0.35];

  case 14,				%3x1
    QTEMP1 = [0.80 0.22];

  case 15,				%4x1
    QTEMP1 = [0.80 0.17];

  case 16,				%5x1
    QTEMP1 = [0.80 0.15];

  case 17,				%6x1
    QTEMP1 = [0.80 0.10];

  case 2,				%1x2
    QTEMP1 = [0.35 0.80];

  case 4,				%2x2
    QTEMP1 = [0.35 0.35];

  case 8,				%3x2
    QTEMP1 = [0.35 0.22];

  case 19,				%4x2
    QTEMP1 = [0.35 0.17];

  case 7,				%2x3
    QTEMP1 = [0.22 0.35];

  case 5,				%3x3
    QTEMP1 = [0.22 0.22];

  case 12,				%4x3
    QTEMP1 = [0.22 0.17];

  case 18, 				%2x4
    QTEMP1 = [0.17 0.35];

  case 11, 				%3x4
    QTEMP1 = [0.17 0.22];

  case 6,				%4x4
    QTEMP1 = [0.17 0.17];
 
  case 31,				%5x4
    QTEMP1 = [0.17 0.15];
    
  case 32,				%6x4
    QTEMP1 = [0.17 0.12];
    
  case 33,				%7x4
    QTEMP1 = [0.17 0.10];
    
  case 34,				%8x4
    QTEMP1 = [0.17 0.10];

  case 13,				%4x5
    QTEMP1 = [0.15 0.16];

  case 9,				%5x5
    QTEMP1 = [0.15 0.15];

  case 30,				%6x5
    QTEMP1 = [0.15 0.12];

  case 10,				%6x6
    QTEMP1 = [0.12 0.12];

  case 20,				%7x7
    QTEMP1 = [0.10 0.10];

  case 21,				%8x8
    QTEMP1 = [0.10 0.10];

  case 22,				%9x9
    QTEMP1 = [0.092 0.092];

  case 23,				%10x10
    QTEMP1 = [0.083 0.083];

  case 24,				%11x11
    QTEMP1 = [0.075 0.075];

  case 25,				%12x12
    QTEMP1 = [0.068 0.068];

  case 26,				%13x13
    QTEMP1 = [0.063 0.063];

  case 29,				%14x14
    QTEMP1 = [0.059 0.059];

  case 27,				%19x19
    QTEMP1 = [0.040 0.040];

  case 28,				%37x37
    QTEMP1 = [0.023 0.023];
  
  case 98, 				%user-defined grid with irregular spacing
    %
    %The UserDefValues should be a vector with [NrPlotsX OffsetX WidthAxisX(1:NrPlotsX) SpaceX NrPlotsY OffsetY WidthAxisY(1:NrPlotsY) SpaceY]
    %
    UserDefValues = Var(2:end);
    NrPlotsX   = UserDefValues(1);
    OffsetX    = UserDefValues(2);
    WidthAxisX = UserDefValues(3:(2+NrPlotsX));
    SpaceX     = UserDefValues(2+NrPlotsX+1);
    NrPlotsY   = UserDefValues(2+NrPlotsX+2);
    OffsetY    = UserDefValues(2+NrPlotsX+3);
    WidthAxisY = UserDefValues((2+NrPlotsX+4):(2+NrPlotsX+3+NrPlotsY));
    SpaceY     = UserDefValues(2+NrPlotsX+3+NrPlotsY+1);

    QTEMP1x = WidthAxisX;
    QTEMP1y = WidthAxisY;
  
  case 99, 				%user-defined grid with regular spacing
    %
    %The UserDefValues should be a vector with [NrPlotsX OffsetX WidthAxisX SpaceX NrPlotsY OffsetY WidthAxisY SpaceY]
    %
    UserDefValues = Var(2:end);
    NrPlotsX   = UserDefValues(1);
    OffsetX    = UserDefValues(2);
    WidthAxisX = UserDefValues(3);
    SpaceX     = UserDefValues(4);
    NrPlotsY   = UserDefValues(5);
    OffsetY    = UserDefValues(6);
    WidthAxisY = UserDefValues(7);
    SpaceY     = UserDefValues(8);

    QTEMP1 = [WidthAxisX WidthAxisY];
    
  end

  if (Var(1) ~= 98)
    %
    %for all regular grids of subplots
    %
    
    %reset Sizes to normal if no colorbar is present
    %find only regular axes
    AllAxes = findobj(FigHandle, 'tag', 'RegularAxis');
  
    for QTEMP2 = 1:length(AllAxes)
      AxesNR = get(AllAxes(QTEMP2), 'userdata');
  
      if ~ isempty(AxesNR)
        if (QmatNMR.ContColorbarIndicator(AxesNR) == 0)
          QTEMP3 = get(AllAxes(QTEMP2), 'position');
          set(AllAxes(QTEMP2), 'position', [QTEMP3(1:2) QTEMP1]);
        end
      end
    end

  else
    %
    %for irregular grids of subplots
    %
    
    %reset Sizes to normal if no colorbar is present
    %find only regular axes
    AllAxes = findobj(FigHandle, 'tag', 'RegularAxis');
  
    for QTEMP2 = 1:length(AllAxes)
      AxesNR = get(AllAxes(QTEMP2), 'userdata');
      IndexY = floor((AxesNR-1) / NrPlotsX) + 1;
      IndexX = AxesNR-1 - (IndexY-1)*NrPlotsX + 1;
  
      if ~ isempty(AxesNR)
        if (QmatNMR.ContColorbarIndicator(AxesNR) == 0)
          QTEMP3 = get(AllAxes(QTEMP2), 'position');
          set(AllAxes(QTEMP2), 'position', [QTEMP3(1:2) QTEMP1x(IndexX) QTEMP1y(IndexY)]);
        end
      end
    end
  end


%
%if projection axes are present then a different size is maintained for the single axis
%
QTEMP2 = findobj(allchild(QmatNMR.Fig2D3D), 'tag', 'Projection');
if ~isempty(QTEMP2)
  QTEMP3 = get(AllAxes(1), 'position');
  set(AllAxes(1), 'position', [QTEMP3(1:2) QTEMP1-0.05]);
  
  updateprojectionaxes
end
