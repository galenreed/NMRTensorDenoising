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
%
% update2Daid updates the view for the 2D phasing aid.
%
% 02-08-'05

try
  delete(findobj(allchild(QmatNMR.Fig), 'tag', '2DPhasingAidIndex1'));
  delete(findobj(allchild(QmatNMR.Fig), 'tag', '2DPhasingAidIndex2'));
  delete(findobj(allchild(QmatNMR.Fig), 'tag', '2DPhasingAidIndex3'));
  delete(findobj(allchild(QmatNMR.Fig), 'tag', '2DPhasingAidIndex4'));
  delete(findobj(allchild(QmatNMR.Fig), 'tag', '2DPhasingAidIndex1text'));
  delete(findobj(allchild(QmatNMR.Fig), 'tag', '2DPhasingAidIndex2text'));
  delete(findobj(allchild(QmatNMR.Fig), 'tag', '2DPhasingAidIndex3text'));
  delete(findobj(allchild(QmatNMR.Fig), 'tag', '2DPhasingAidIndex4text'));
  if (QmatNMR.Dim ~= 0) & (get(QmatNMR.p31, 'value'))
    %
    %create 2 new axes on top of the normal one, in which we'll plot the other slices
    %
    if isempty(findobj(allchild(QmatNMR.Fig), 'tag', '2DPhasingAidAxis1'))
      QTEMP = QmatNMR.ColorScheme.AxisBack;		%make the background color of the new axes equal to the main axis or, if
      if strcmp(QTEMP, 'none') 			%the main axis doesn't have a color defined (i.e. 'none') we use the figure
        QTEMP = QmatNMR.ColorScheme.Figure1Back; 	%background colorS
      end
      axes('position', [0.1150 0.7400 0.4100 0.2500], 'Color', QTEMP, 'tag', '2DPhasingAidAxis1', 'box', 'on', 'xtick', [], 'ytick', [], 'hittest', 'off', 'nextplot', 'add')
      axes('position', [0.5250 0.7400 0.4100 0.2500], 'Color', QTEMP, 'tag', '2DPhasingAidAxis2', 'box', 'on', 'xtick', [], 'ytick', [], 'hittest', 'off', 'nextplot', 'add')
  
    else						%just pull the extra axes in front
      %axes(findobj(allchild(QmatNMR.Fig), 'tag', '2DPhasingAidAxis1'))
      %axes(findobj(allchild(QmatNMR.Fig), 'tag', '2DPhasingAidAxis2'))
      set(QmatNMR.Fig, 'currentaxes', findobj(allchild(QmatNMR.Fig), 'tag', '2DPhasingAidAxis1'))
      set(QmatNMR.Fig, 'currentaxes', findobj(allchild(QmatNMR.Fig), 'tag', '2DPhasingAidAxis2'))
    end
    set(QmatNMR.Fig, 'currentaxes', findobj(allchild(QmatNMR.Fig), 'tag', 'MainAxis'));
  
  
    %
    %determine the position of the reference for first-order phase correction from the current axis
    %
    QmatNMR.fase1startIndex = interp1(QmatNMR.Axis1D, (1:QmatNMR.Size1D).', QmatNMR.fase1start);
  
    %
    %
    Qi = sqrt(-1)*pi/180;
    QmatNMR.z = -((1:QmatNMR.Size1D)-QmatNMR.fase1startIndex)/(QmatNMR.Size1D);
    QmatNMR.z2 = -2*(((1:QmatNMR.Size1D)-floor(QmatNMR.Size1D/2)-1)/(QmatNMR.Size1D)).^2;
    QTEMP2 = (exp(Qi*(QmatNMR.fase0 + QmatNMR.fase1*QmatNMR.z + QmatNMR.fase2*QmatNMR.z2)));	%the vector that executes the phase correction
  
    %
    %first see whether index 1 is filled for TD 2
    %
    QTEMP = get(QmatNMR.p33, 'string');
    if ~isempty(QTEMP)
      %
      %get slice from the spectrum
      %
      QTEMP = eval(QTEMP);
      if (QmatNMR.Dim == 1)		%TD2 is being phase corrected
        QTEMP1 = QmatNMR.Spec2D(QTEMP, :);
        QTEMP1 = QTEMP1 .* QTEMP2;
  
      else 			%TD1
        if (QmatNMR.HyperComplex)
          QTEMP1 = real(QmatNMR.Spec2D(QTEMP, :)) + sqrt(-1)*real(QmatNMR.Spec2Dhc(QTEMP, :));
  
        else
          QTEMP1 = QmatNMR.Spec2D(QTEMP, :);
        end
  
        QTEMP1 = QTEMP1 .* QTEMP2(QTEMP);
      end
      
      %
      %add line to plot
      %
      hold on
      QTEMP = plot(QmatNMR.AxisTD2, real(QTEMP1)-QmatNMR.totaalY/12, [QmatNMR.color(rem(QmatNMR.nrspc, length(QmatNMR.color)) + 1) QmatNMR.MarkerType QmatNMR.LineType]);
      set(QTEMP, 'LineWidth', QmatNMR.LineWidth, 'MarkerSize', QmatNMR.MarkerSize, 'buttondownfcn', 'MoveLine', ...
                 'hittest', 'off', 'Tag', '2DPhasingAidIndex1', 'parent', findobj(allchild(QmatNMR.Fig), 'tag', '2DPhasingAidAxis1'));
      set(gca, 'nextplot', 'replacechildren');
  
  
      %
      %Add a text label
      %
      QTEMP3 = text(0, 0, ['row ' get(QmatNMR.p33, 'string')]);
      set(QTEMP3, 'parent', findobj(allchild(QmatNMR.Fig), 'tag', '2DPhasingAidAxis1'), 'units', 'normalized', 'position', [0.01 0.86 0.0], ...
          'color', get(findobj(allchild(QmatNMR.Fig), 'tag', '2DPhasingAidIndex1'), 'color'), 'tag', '2DPhasingAidIndex1text');
    end
  
    
    %
    %first see whether index 2 is filled for TD 2
    %
    QTEMP = get(QmatNMR.p34, 'string');
    if ~isempty(QTEMP)
      %
      %get slice from the spectrum
      %
      QTEMP = eval(QTEMP);
      if (QmatNMR.Dim == 1)		%TD2 is being phase corrected
        QTEMP1 = QmatNMR.Spec2D(QTEMP, :);
        QTEMP1 = QTEMP1 .* QTEMP2;
  
      else 			%TD1
        if (QmatNMR.HyperComplex)
          QTEMP1 = real(QmatNMR.Spec2D(QTEMP, :)) + sqrt(-1)*real(QmatNMR.Spec2Dhc(QTEMP, :));
  
        else
          QTEMP1 = QmatNMR.Spec2D(QTEMP, :);
        end
  
        QTEMP1 = QTEMP1 .* QTEMP2(QTEMP);
      end
      
      %
      %add line to plot
      %
      hold on
      QTEMP = plot(QmatNMR.AxisTD2, real(QTEMP1)+QmatNMR.totaalY/12, [QmatNMR.color(rem(QmatNMR.nrspc, length(QmatNMR.color)) + 2) QmatNMR.MarkerType QmatNMR.LineType]);
      set(QTEMP, 'LineWidth', QmatNMR.LineWidth, 'MarkerSize', QmatNMR.MarkerSize, 'buttondownfcn', 'MoveLine', ...
                 'hittest', 'off', 'Tag', '2DPhasingAidIndex2', 'parent', findobj(allchild(QmatNMR.Fig), 'tag', '2DPhasingAidAxis1'));
      set(gca, 'nextplot', 'replacechildren');
  
  
      %
      %Add a text label
      %
      QTEMP3 = text(0, 0, ['row ' get(QmatNMR.p34, 'string')]);
      set(QTEMP3, 'parent', findobj(allchild(QmatNMR.Fig), 'tag', '2DPhasingAidAxis1'), 'units', 'normalized', 'position', [0.01 0.96 0.0], ...
          'color', get(findobj(allchild(QmatNMR.Fig), 'tag', '2DPhasingAidIndex2'), 'color'), 'tag', '2DPhasingAidIndex2text');
    end
    if (QmatNMR.Dim == 1)
      set(findobj(allchild(QmatNMR.Fig), 'tag', '2DPhasingAidAxis1'), 'xlim', [QmatNMR.xmin QmatNMR.xmin+QmatNMR.totaalX], 'ylim', [QmatNMR.ymin QmatNMR.ymin+QmatNMR.totaalY]);
    
    else
      set(findobj(allchild(QmatNMR.Fig), 'tag', '2DPhasingAidAxis1'), 'xlim', sort(QmatNMR.AxisTD2([1 QmatNMR.SizeTD2])), 'ylim', [QmatNMR.ymin QmatNMR.ymin+QmatNMR.totaalY]);
    end
    
  
    %
    %first see whether index 1 is filled for TD 1
    %
    QTEMP = get(QmatNMR.p36, 'string');
    if ~isempty(QTEMP)
      %
      %get slice from the spectrum
      %
      QTEMP = eval(QTEMP);
      if (QmatNMR.Dim == 1)		%TD2 is being phase corrected
        QTEMP1 = QmatNMR.Spec2D(:, QTEMP);
        QTEMP1 = (QTEMP1.') .* QTEMP2(QTEMP);
  
      else 			%TD1
        if (QmatNMR.HyperComplex)
          QTEMP1 = real(QmatNMR.Spec2D(:, QTEMP)) + sqrt(-1)*real(QmatNMR.Spec2Dhc(:, QTEMP));
        else
          QTEMP1 = QmatNMR.Spec2D(:, QTEMP);
          
        end
  
        QTEMP1 = (QTEMP1.') .* QTEMP2;
      end
      
      %
      %add line to plot
      %
      hold on
      QTEMP = plot(QmatNMR.AxisTD1, real(QTEMP1)-QmatNMR.totaalY/12, [QmatNMR.color(rem(QmatNMR.nrspc, length(QmatNMR.color)) + 1) QmatNMR.MarkerType QmatNMR.LineType]);
      set(QTEMP, 'LineWidth', QmatNMR.LineWidth, 'MarkerSize', QmatNMR.MarkerSize, 'buttondownfcn', 'MoveLine', ...
                 'hittest', 'off', 'Tag', '2DPhasingAidIndex3', 'parent', findobj(allchild(QmatNMR.Fig), 'tag', '2DPhasingAidAxis2'));
      set(gca, 'nextplot', 'replacechildren');
  
  
      %
      %Add a text label
      %
      QTEMP3 = text(0, 0, ['column ' get(QmatNMR.p36, 'string')]);
      set(QTEMP3, 'parent', findobj(allchild(QmatNMR.Fig), 'tag', '2DPhasingAidAxis2'), 'units', 'normalized', 'position', [0.01 0.86 0.0], ...
          'color', get(findobj(allchild(QmatNMR.Fig), 'tag', '2DPhasingAidIndex3'), 'color'), 'tag', '2DPhasingAidIndex3text');
    end
  
    
    %
    %first see whether index 2 is filled for TD 1
    %
    QTEMP = get(QmatNMR.p37, 'string');
    if ~isempty(QTEMP)
      %
      %get slice from the spectrum
      %
      QTEMP = eval(QTEMP);
      if (QmatNMR.Dim == 1)		%TD2 is being phase corrected
        QTEMP1 = QmatNMR.Spec2D(:, QTEMP);
        QTEMP1 = (QTEMP1.') .* QTEMP2(QTEMP);
  
      else 			%TD1
        if (QmatNMR.HyperComplex)
          QTEMP1 = real(QmatNMR.Spec2D(:, QTEMP)) + sqrt(-1)*real(QmatNMR.Spec2Dhc(:, QTEMP));
  
        else
          QTEMP1 = QmatNMR.Spec2D(:, QTEMP);
        end
  
        QTEMP1 = (QTEMP1.') .* QTEMP2;
      end
      
      %
      %add line to plot
      %
      hold on
      QTEMP = plot(QmatNMR.AxisTD1, real(QTEMP1)+QmatNMR.totaalY/12, [QmatNMR.color(rem(QmatNMR.nrspc, length(QmatNMR.color)) + 2) QmatNMR.MarkerType QmatNMR.LineType]);
      set(QTEMP, 'LineWidth', QmatNMR.LineWidth, 'MarkerSize', QmatNMR.MarkerSize, 'buttondownfcn', 'MoveLine', ...
                 'hittest', 'off', 'Tag', '2DPhasingAidIndex4', 'parent', findobj(allchild(QmatNMR.Fig), 'tag', '2DPhasingAidAxis2'));
      set(gca, 'nextplot', 'replacechildren');
  
  
      %
      %Add a text label
      %
      QTEMP3 = text(0, 0, ['column ' get(QmatNMR.p37, 'string')]);
      set(QTEMP3, 'parent', findobj(allchild(QmatNMR.Fig), 'tag', '2DPhasingAidAxis2'), 'units', 'normalized', 'position', [0.01 0.96 0.0], ...
          'color', get(findobj(allchild(QmatNMR.Fig), 'tag', '2DPhasingAidIndex4'), 'color'), 'tag', '2DPhasingAidIndex4text');
    end
    if (QmatNMR.Dim == 1)
      set(findobj(allchild(QmatNMR.Fig), 'tag', '2DPhasingAidAxis2'), 'xlim', sort(QmatNMR.AxisTD1([1 QmatNMR.SizeTD1])), 'ylim', [QmatNMR.ymin QmatNMR.ymin+QmatNMR.totaalY]);
    else
      set(findobj(allchild(QmatNMR.Fig), 'tag', '2DPhasingAidAxis2'), 'xlim', [QmatNMR.xmin QmatNMR.xmin+QmatNMR.totaalX], 'ylim', [QmatNMR.ymin QmatNMR.ymin+QmatNMR.totaalY]);
    end
  end
  
  clear QTEMP* Qi

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
