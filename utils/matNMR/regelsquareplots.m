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
%regelsquareplots.m performs the input for regelsquareplots.m which in turn ensures that the
%subplots in the current 2D/3D viewer window are rescaled according to their current axis
%limits. This makes peaks look square. The figure window is also made square.
%26-10-'10

try
  if (QmatNMR.buttonList == 1)
    QTEMP20 = gca;	%the current axis
    QTEMP21 = gcf; 	%the current figure window


    %
    %the input parameters are the plotting range (in normalized units) and the 
    %minimum space between subplots
    %
    QTEMP31 = eval(QmatNMR.uiInput1);
    QTEMP32 = eval(QmatNMR.uiInput2);
    %from this we calculate the offset for the position vectors of the axes
    QTEMP33 = (1-QTEMP31)/2;
    

    %
    %make the figure window square such that a round peak is round for the eye
    %
    QTEMP43 = get(QTEMP21, 'units');
    set(QTEMP21, 'units', 'centimeters');
    QTEMP44 = get(QTEMP21, 'position');
    set(QTEMP21, 'position', [QTEMP44(1:2) min(QTEMP44(3:4)) min(QTEMP44(3:4))]);
    set(QTEMP21, 'units', QTEMP43);
    

    %
    %make the axis positions such that the size of the axis reflects the spectral width of each subplot
    %
    QmatNMR.AllAxes = findobj(QTEMP21, 'type', 'axes', 'tag', 'RegularAxis');
    QmatNMR.AxesNR = cell2mat(get(QmatNMR.AllAxes, 'userdata'));
    QmatNMR.AllAxes = QmatNMR.AllAxes(QmatNMR.AxesNR);

    QTEMP23 = findobj(QmatNMR.AllAxes, 'userdata', 1);
    set(QTEMP23, 'units', 'normalized');
    QTEMP17 = get(QTEMP23, 'position');
    
    %
    %first we check the sizes of all subplots in each direction
    %
    QTEMPSWx = [];
    QTEMPSWy = [];
    for QTEMP4 = 1:length(QmatNMR.AllAxes);
      QmatNMR.AxesNR = get(QmatNMR.AllAxes(QTEMP4), 'userdata');
    
      if ~isempty(QmatNMR.AxesNR)
        set(QmatNMR.AllAxes(QTEMP4), 'units', 'normalized');
        QTEMP18 = get(QmatNMR.AllAxes(QTEMP4), 'position');
        if (QTEMP18(2) == QTEMP17(2))         %check whether this axis has the correct position
          QTEMPSWx = [QTEMPSWx abs(diff(get(QmatNMR.AllAxes(QTEMP4), 'xlim')))];
        end
        if (QTEMP18(1) == QTEMP17(1))         %check whether this axis has the correct position
          QTEMPSWy = [QTEMPSWy abs(diff(get(QmatNMR.AllAxes(QTEMP4), 'ylim')))];
        end
      end
    end

    %
    %the direction with the largest total width is the master (NOTE: this assumes that the axes have the same units!!!)
    %
    if (sum(QTEMPSWx) > sum(QTEMPSWy))
      QTEMPsumSW = sum(QTEMPSWx);
      QTEMPTotWidth = QTEMP31 - QTEMP32 * (length(QTEMPSWx) - 1);
      QTEMPSpaceX = QTEMP32;
    
    else
      QTEMPsumSW = sum(QTEMPSWy);
      QTEMPTotWidth = QTEMP31 - QTEMP32 * (length(QTEMPSWy) - 1);
      QTEMPSpaceY = QTEMP32;
    end
    
    %
    %the size of all subplots in each direction in normalized units
    %
    QTEMPSizeX = QTEMPSWx / QTEMPsumSW * QTEMPTotWidth;
    QTEMPSizeY = QTEMPSWy / QTEMPsumSW * QTEMPTotWidth;
    
    %
    %the distance between subplots in the slave dimension
    %
    if (sum(QTEMPSWx) > sum(QTEMPSWy))
      QTEMPSpaceY = (QTEMP31  - sum(QTEMPSizeY)) / (length(QTEMPSWy) - 1);
    
    else
      QTEMPSpaceX = (QTEMP31  - sum(QTEMPSizeX)) / (length(QTEMPSWx) - 1);
    end
    
    %
    %here all the sizes of the subplots are set
    %
    QmatNMR.AllAxes = findobj(QTEMP21, 'type', 'axes', 'tag', 'RegularAxis');
    QTEMP60 = 0;
    QTEMPOffsetY = 1 - QTEMP33;
    for QTEMP61=1:length(QTEMPSWy)
      QTEMPOffsetY = QTEMPOffsetY - QTEMPSizeY(QTEMP61);
      QTEMPOffsetX = QTEMP33;
    
      for QTEMP62=1:length(QTEMPSWx)
        QTEMP60 = QTEMP60 + 1; 
        QTEMP23 = findobj(QmatNMR.AllAxes, 'userdata', QTEMP60);
        set(QTEMP23, 'position', [QTEMPOffsetX QTEMPOffsetY QTEMPSizeX(QTEMP62) QTEMPSizeY(QTEMP61)]);
        
        QTEMPOffsetX = QTEMPOffsetX + QTEMPSpaceX + QTEMPSizeX(QTEMP62);
      end
    
      QTEMPOffsetY = QTEMPOffsetY - QTEMPSpaceY;
    end
    
    %
    %Since the subplot grid now is irregular we need to update the parameters accordingly in the userdat of the figure
    %
    QmatNMR.ContSubplots = [98 length(QTEMPSWx) QTEMP33 QTEMPSizeX QTEMPSpaceX length(QTEMPSWy) QTEMP33 QTEMPSizeY QTEMPSpaceY];
    QTEMP = get(QTEMP21, 'userdata');
    QTEMP.Subplots = QmatNMR.ContSubplots;
    set(QTEMP21, 'userdata', QTEMP);

    disp('Squaring of the subplots has finished.');
  
  else
    disp('Squaring of the subplots cancelled ...');
  end  
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
