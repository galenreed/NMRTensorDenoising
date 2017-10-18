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
%regelshowprojections shows projections for the current spectrum in the 2D/3D viewer
%17-01-'07
%

try
  if (QmatNMR.buttonList == 1)
    QmatNMR.ProjectionType     = eval(QmatNMR.uiInput1);
    QmatNMR.ProjectionRangeTD2 = QmatNMR.uiInput2;
    QmatNMR.ProjectionRangeTD1 = QmatNMR.uiInput3;
    QmatNMR.ContourLineSpec    = QmatNMR.uiInput4;
  
    %
    %first delete any old projection axes
    %
    delete(findobj(allchild(QmatNMR.Fig2D3D), 'tag', 'Projection'));
  
    %
    %determine the current axis directions for the plot
    %
    QTEMP1 = get(QmatNMR.Fig2D3D , 'userdata');
    QTEMP31 = get(QTEMP1.AxesHandles(1), 'xdir');
    QTEMP32 = get(QTEMP1.AxesHandles(1), 'ydir');
  
    %
    %determine what to calculate
    %
    switch QmatNMR.ProjectionType 
      case 1,
        %skyline TD1
        if isempty(QmatNMR.ProjectionRangeTD2)
          QTEMP21 = Qskyline(QmatNMR.Spec2D3D,0); % right slice
        else
          QTEMP21 = Qskyline(QmatNMR.Spec2D3D(:,eval(QmatNMR.ProjectionRangeTD2)),0); % right slice
        end
  
        %skyline TD2
        if isempty(QmatNMR.ProjectionRangeTD1)
          QTEMP22 = Qskyline(QmatNMR.Spec2D3D,90);  %top slice
        else
          QTEMP22 = Qskyline(QmatNMR.Spec2D3D(eval(QmatNMR.ProjectionRangeTD1), :),90);  %top slice
        end
  
      case 2,
        %sum TD1
        if isempty(QmatNMR.ProjectionRangeTD2)
          QTEMP21 = real(sum(QmatNMR.Spec2D3D, 2)).';
        else
          QTEMP21 = real(sum(QmatNMR.Spec2D3D(:,eval(QmatNMR.ProjectionRangeTD2)), 2)).';
        end
  
        %sum TD2
        if isempty(QmatNMR.ProjectionRangeTD1)
          QTEMP22 = real(sum(QmatNMR.Spec2D3D, 1));
        else
          QTEMP22 = real(sum(QmatNMR.Spec2D3D(eval(QmatNMR.ProjectionRangeTD1),:), 1));
        end
  
      case 3,
        %single slice projection
        if isempty(QmatNMR.ProjectionRangeTD2) | isempty(QmatNMR.ProjectionRangeTD1)
          beep
          disp('matNMR WARNING: no slice entered. Aborting projection ...');
          return
        end
        QTEMP21 = real(QmatNMR.Spec2D3D(:,eval(QmatNMR.ProjectionRangeTD2))).';
        QTEMP22 = real(QmatNMR.Spec2D3D(eval(QmatNMR.ProjectionRangeTD1),:));
  
      otherwise
        disp('Error');
        return;
    end
  
  
    %
    %reduce size of axis, by assuming the default axis position
    %
    QTEMP12 = [0.10 0.10 0.80 0.80];
    set(QTEMP1.AxesHandles(1), 'position', [QTEMP12(1:2) QTEMP12(3:4)-0.05]);
  
    
    %==============================================================
    %%show the top figure (horizontal = projection on TD2)
    %==============================================================
    %
    %create top axis
    %
    QTEMP3 = axes('Position', [QTEMP12(1) QTEMP12(2)+QTEMP12(4)-0.05 QTEMP12(3)-0.05 0.1], 'tag', 'Projection', 'Buttondownfcn', 'SelectAxis', 'Color', QmatNMR.ColorScheme.Figure1Back, 'xcolor', QmatNMR.ColorScheme.Figure1Back, 'ycolor', QmatNMR.ColorScheme.Figure1Back, 'zcolor', QmatNMR.ColorScheme.Figure1Back);
    hold on
    QTEMP24 = QmatNMR.Axis2D3DTD2;
    if (QTEMP24(1) > QTEMP24(2))	%descending axis
      QTEMP24 = fliplr(QTEMP24);
      QTEMP22 = fliplr(QTEMP22);
    end  
  
    if length(QmatNMR.ContourLineSpec)
      plot(QTEMP24, QTEMP22, QmatNMR.ContourLineSpec);
    else
      plot(QTEMP24, QTEMP22, QTEMP24, QTEMP22*0, 'w:');
    end
    
    %
    %determine tight axis limits
    %
    axis tight
    QTEMP5 = axis;
  
    %
    %add a zero-line. This will only be visible if the axis limits determined previously shows 0!
    %
    hold on
    plot(QTEMP24, QTEMP22*0, 'w:');
    hold off
  
    axis([QmatNMR.aswaarden(1:2) (QTEMP5(3)-0.05*(QTEMP5(4)-QTEMP5(3))) (QTEMP5(4)+0.05*(QTEMP5(4)-QTEMP5(3)))]);
  
    set(QTEMP3,'YTickLabel',[],'XTickLabel',[], 'YTick',[], 'XTick',[], 'xdir', QTEMP31);
    box on
    set(QTEMP3, 'tag', 'Projection', 'Buttondownfcn', 'SelectAxis');
    setappdata(QTEMP3, 'ProjectionDirection', 1)
    
    %%%=====================================================
    %%show the right figure (vertical = projection on TD1)
    %%%=====================================================
    %
    %create right axis
    %
    QTEMP3 = axes('Position', [QTEMP12(1)+QTEMP12(3)-0.05 QTEMP12(2) 0.1 QTEMP12(4)-0.05], 'tag', 'Projection', 'Buttondownfcn', 'SelectAxis', 'Color', QmatNMR.ColorScheme.Figure1Back, 'xcolor', QmatNMR.ColorScheme.Figure1Back, 'ycolor', QmatNMR.ColorScheme.Figure1Back, 'zcolor', QmatNMR.ColorScheme.Figure1Back);
    hold on
    QTEMP23 = QmatNMR.Axis2D3DTD1;
    if (QTEMP23(1) > QTEMP23(2))	%descending axis
      QTEMP23 = fliplr(QTEMP23);
      QTEMP21 = fliplr(QTEMP21);
    end  
    if length(QmatNMR.ContourLineSpec)
      plot(QTEMP21, QTEMP23, QmatNMR.ContourLineSpec);
    else
      plot(QTEMP21, QTEMP23, QTEMP21*0, QTEMP23, 'w:');
    end
    
    %
    %determine tight axis limits
    %
    axis tight
    QTEMP5 = axis;
  
    %
    %add a zero-line. This will only be visible if the axis limits determined previously shows 0!
    %
    hold on
    plot(QTEMP21*0, QTEMP23, 'w:');
    hold off
  
    axis([(QTEMP5(1)-0.05*(QTEMP5(2)-QTEMP5(1))) (QTEMP5(2)+0.05*(QTEMP5(2)-QTEMP5(1))) QmatNMR.aswaarden(3:4)]);
    set(QTEMP3,'YTickLabel',[],'XTickLabel',[], 'YTick',[], 'XTick',[], 'ydir', QTEMP32);
    box on
    set(QTEMP3, 'tag', 'Projection', 'Buttondownfcn', 'SelectAxis');
    setappdata(QTEMP3, 'ProjectionDirection', 2)
    
    
    %%%=====================================================
    %% go back to the original handle
    %%%=====================================================
    %axes(QTEMP1.AxesHandles(1));
    set(QmatNMR.Fig2D3D, 'currentaxes', QTEMP1.AxesHandles(1));
  
    %
    %delete current title
    %
    title('', 'Color', QmatNMR.ColorScheme.AxisFore);
    
    clear QTEMP*
  
  else
    disp('Creating projections of current 2D spectrum was aborted ...');
  end

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
