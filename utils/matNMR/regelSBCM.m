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
%regelSBCM.m converts one or multiple contour plots such that the colour of each contour is propotional
%to the surface it (roughly) spans.
%17-07-'09

try
  if QmatNMR.buttonList == 1			%OK-button
    QTEMP20 = gca;	%the current axis
    QTEMP21 = gcf; 	%the current figure window
  
    if (QmatNMR.uiInput1 == 1)			%Only change selected axes
      QmatNMR.AllAxes = findobj(findobj(QTEMP21, 'type', 'axes'), 'selected', 'on');
      if isempty(QmatNMR.AllAxes)
        QmatNMR.AllAxes = QTEMP20;
      end
    
      for QTEMP4 = 1:length(QmatNMR.AllAxes)
        QmatNMR.AxesNR = get(QmatNMR.AllAxes(QTEMP4), 'userdata');
  
        if ~isempty(QmatNMR.AxesNR)
          QTEMP14 = findobj(allchild(QmatNMR.AllAxes(QTEMP4)), 'type', 'patch');

          %
          %a highly simplified calculation of the area by taking a square around the patch
          %
          %QTEMP5 = length(QTEMP14);
          %QTEMP6 = zeros(1, QTEMP5);
          %for QTEMP7=1:QTEMP5
          %  QTEMP6(QTEMP7) = (max(get(QTEMP14(QTEMP7), 'xdata')) - min(get(QTEMP14(QTEMP7), 'xdata'))) * (max(get(QTEMP14(QTEMP7), 'ydata')) - min(get(QTEMP14(QTEMP7), 'ydata')));
          %end

          %
          %Now a calculation using the Matlab function polyarea
          %
          QTEMP5 = length(QTEMP14);
          QTEMP6 = zeros(1, QTEMP5);
          for QTEMP7=1:QTEMP5
            QTEMP71 = get(QTEMP14(QTEMP7), 'xdata');
            QTEMP72 = get(QTEMP14(QTEMP7), 'ydata');
            QTEMP6(QTEMP7) = polyarea(QTEMP71(1:end-1), QTEMP72(1:end-1));
          end

          QTEMP6 = QTEMP6/max(QTEMP6);
          QTEMP6 = log10(1./QTEMP6);
          
          for QTEMP7=1:QTEMP5
            QTEMP8 = get(QTEMP14(QTEMP7), 'cdata');
            QTEMP8 = QTEMP8*QTEMP6(QTEMP7)/QTEMP8(1);
            set(QTEMP14(QTEMP7), 'cdata', QTEMP8);
          end
  
          set(QmatNMR.AllAxes(QTEMP4), 'clim', [min(QTEMP6) max(QTEMP6)])
        end	  
      end
       
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
      
      %
      %set the colormap to bone and invert it
      %
      for QTEMP = 1:size(QmatNMR.PopupStr, 1);
        if strcmp(QmatNMR.PopupStr(QTEMP, 1:4), 'bone')
          set(QmatNMR.c8, 'value', QTEMP);	%BONE colormap
        end
      end
      contcmap
      set(QmatNMR.c8, 'value', 2);	%INVERT
      contcmap
  
      if (~QmatNMR.BusyWithMacro)
        drawnow
      end
  
      disp('Contour plots converted for all selected axes ...');
  
  
    elseif (QmatNMR.uiInput1 == 2) 		%apply to all subplots
      QmatNMR.AllAxes = findobj(QTEMP21, 'type', 'axes', 'tag', 'RegularAxis');
  
      for QTEMP4 = 1:length(QmatNMR.AllAxes)
        QmatNMR.AxesNR = get(QmatNMR.AllAxes(QTEMP4), 'userdata');
  
        if ~isempty(QmatNMR.AxesNR)
          QTEMP14 = findobj(allchild(QmatNMR.AllAxes(QTEMP4)), 'type', 'patch');
  
          QTEMP5 = length(QTEMP14);
          QTEMP6 = zeros(1, QTEMP5);
          for QTEMP7=1:QTEMP5
            QTEMP6(QTEMP7) = (max(get(QTEMP14(QTEMP7), 'xdata')) - min(get(QTEMP14(QTEMP7), 'xdata'))) * (max(get(QTEMP14(QTEMP7), 'ydata')) - min(get(QTEMP14(QTEMP7), 'ydata')));
          end
          
          QTEMP6 = QTEMP6/max(QTEMP6);
          QTEMP6 = log10(1./QTEMP6);
          
          for QTEMP7=1:QTEMP5
            QTEMP8 = get(QTEMP14(QTEMP7), 'cdata');
            QTEMP8 = QTEMP8*QTEMP6(QTEMP7)/QTEMP8(1);
            set(QTEMP14(QTEMP7), 'cdata', QTEMP8);
          end
  
          set(QmatNMR.AllAxes(QTEMP4), 'clim', [min(QTEMP6) max(QTEMP6)])
        end	  
      end
       
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
      
      %
      %set the colormap to bone and invert it
      %
      for QTEMP = 1:size(QmatNMR.PopupStr, 1);
        if strcmp(QmatNMR.PopupStr(QTEMP, 1:4), 'bone')
          set(QmatNMR.c8, 'value', QTEMP);	%BONE colormap
        end
      end
      contcmap
      set(QmatNMR.c8, 'value', 2);	%INVERT
      contcmap
  
      if (~QmatNMR.BusyWithMacro)
        drawnow
      end
  
      disp('Contour plots converted for all axes ...');
      
  
    elseif (QmatNMR.uiInput1 == 3) 		%apply to the current row of subplots
      QmatNMR.AllAxes = findobj(findobj(QTEMP21, 'type', 'axes', 'tag', 'RegularAxis'), 'selected', 'on');
      if isempty(QmatNMR.AllAxes)
        QmatNMR.AllAxes = QTEMP20;
      end
      %
      %demand that at most 1 subplot is selected
      %
      if (length(QmatNMR.AllAxes) > 1)
        disp('matNMR WARNING: only 1 subplot may be selected to work on the current row');
        askSBCM
        return
      end
      %
      %Select all subplots and determine the position of the current row
      %
      QTEMP17 = get(QmatNMR.AllAxes, 'position');
      QmatNMR.AllAxes = findobj(QTEMP21, 'type', 'axes', 'tag', 'RegularAxis');
    
      for QTEMP4 = 1:length(QmatNMR.AllAxes)
        QmatNMR.AxesNR = get(QmatNMR.AllAxes(QTEMP4), 'userdata');
  
        if ~isempty(QmatNMR.AxesNR)
          QTEMP18 = get(QmatNMR.AllAxes(QTEMP4), 'position');
          if (QTEMP18(2) == QTEMP17(2)) 	%check whether this axis has the correct position
            QTEMP14 = findobj(allchild(QmatNMR.AllAxes(QTEMP4)), 'type', 'patch');
    
            QTEMP5 = length(QTEMP14);
            QTEMP6 = zeros(1, QTEMP5);
            for QTEMP7=1:QTEMP5
              QTEMP6(QTEMP7) = (max(get(QTEMP14(QTEMP7), 'xdata')) - min(get(QTEMP14(QTEMP7), 'xdata'))) * (max(get(QTEMP14(QTEMP7), 'ydata')) - min(get(QTEMP14(QTEMP7), 'ydata')));
            end
            
            QTEMP6 = QTEMP6/max(QTEMP6);
            QTEMP6 = log10(1./QTEMP6);
            
            for QTEMP7=1:QTEMP5
              QTEMP8 = get(QTEMP14(QTEMP7), 'cdata');
              QTEMP8 = QTEMP8*QTEMP6(QTEMP7)/QTEMP8(1);
              set(QTEMP14(QTEMP7), 'cdata', QTEMP8);
            end
    
            set(QmatNMR.AllAxes(QTEMP4), 'clim', [min(QTEMP6) max(QTEMP6)])
          end
        end	  
      end
       
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
      
      %
      %set the colormap to bone and invert it
      %
      for QTEMP = 1:size(QmatNMR.PopupStr, 1);
        if strcmp(QmatNMR.PopupStr(QTEMP, 1:4), 'bone')
          set(QmatNMR.c8, 'value', QTEMP);	%BONE colormap
        end
      end
      contcmap
      set(QmatNMR.c8, 'value', 2);	%INVERT
      contcmap
  
      if (~QmatNMR.BusyWithMacro)
        drawnow
      end
  
      disp('Contour plots converted for all axes in the current row ...');
      
  
    elseif (QmatNMR.uiInput1 == 4) 		%apply to the current column of subplots
      QmatNMR.AllAxes = findobj(findobj(QTEMP21, 'type', 'axes', 'tag', 'RegularAxis'), 'selected', 'on');
      if isempty(QmatNMR.AllAxes)
        QmatNMR.AllAxes = QTEMP20;
      end
      %
      %demand that at most 1 subplot is selected
      %
      if (length(QmatNMR.AllAxes) > 1)
        disp('matNMR WARNING: only 1 subplot may be selected to work on the current column');
        askSBCM
        return
      end
      %
      %Select all subplots and determine the position of the current row
      %
      QTEMP17 = get(QmatNMR.AllAxes, 'position');
      QmatNMR.AllAxes = findobj(QTEMP21, 'type', 'axes', 'tag', 'RegularAxis');
    
      for QTEMP4 = 1:length(QmatNMR.AllAxes)
        QmatNMR.AxesNR = get(QmatNMR.AllAxes(QTEMP4), 'userdata');
  
        if ~isempty(QmatNMR.AxesNR)
          QTEMP18 = get(QmatNMR.AllAxes(QTEMP4), 'position');
          if (QTEMP18(1) == QTEMP17(1)) 	%check whether this axis has the correct position
            QTEMP14 = findobj(allchild(QmatNMR.AllAxes(QTEMP4)), 'type', 'patch');
    
            QTEMP5 = length(QTEMP14);
            QTEMP6 = zeros(1, QTEMP5);
            for QTEMP7=1:QTEMP5
              QTEMP6(QTEMP7) = (max(get(QTEMP14(QTEMP7), 'xdata')) - min(get(QTEMP14(QTEMP7), 'xdata'))) * (max(get(QTEMP14(QTEMP7), 'ydata')) - min(get(QTEMP14(QTEMP7), 'ydata')));
            end
            
            QTEMP6 = QTEMP6/max(QTEMP6);
            QTEMP6 = log10(1./QTEMP6);
            
            for QTEMP7=1:QTEMP5
              QTEMP8 = get(QTEMP14(QTEMP7), 'cdata');
              QTEMP8 = QTEMP8*QTEMP6(QTEMP7)/QTEMP8(1);
              set(QTEMP14(QTEMP7), 'cdata', QTEMP8);
            end
    
            set(QmatNMR.AllAxes(QTEMP4), 'clim', [min(QTEMP6) max(QTEMP6)])
          end
        end	  
      end
       
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
      
      %
      %set the colormap to bone and invert it
      %
      for QTEMP = 1:size(QmatNMR.PopupStr, 1);
        if strcmp(QmatNMR.PopupStr(QTEMP, 1:4), 'bone')
          set(QmatNMR.c8, 'value', QTEMP);	%BONE colormap
        end
      end
      contcmap
      set(QmatNMR.c8, 'value', 2);	%INVERT
      contcmap
  
      if (~QmatNMR.BusyWithMacro)
        drawnow
      end
  
      disp('Contour plots converted for all axes in the current column ...');
    end  
  
  else
    disp('Converting of contour plot to surface-based colour mapping was cancelled ...');
  end  
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
