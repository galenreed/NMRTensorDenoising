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
%regelsupertitle.m puts a super title over a plot in the contour and mesh window
%19-08-'98

try
  if QmatNMR.buttonList == 1
    QTEMP = findobj(allchild(gcf), 'tag', 'SuperTitle');
    				%first put the text in the plot
    set(QTEMP, 'string', QmatNMR.uiInput1, 'fontsize', eval(QmatNMR.uiInput2), 'rotation', eval(QmatNMR.uiInput3), 'color', QmatNMR.ColorScheme.AxisFore);
    QTEMP2 = get(QTEMP, 'position');
    
    				%then look at how big the string is and place it somewhere in
  				%the top part of the plot
    QTEMP1 = get(QTEMP, 'extent');
    set(QTEMP, 'position', [((1-QTEMP1(3))/2) QTEMP2(2) 0]);
  
    %
    %Add an entry to the plotting macro if we're recording one
    %
    if (QmatNMR.RecordingPlottingMacro)
      %
      %store the string
      %
      QTEMP1 = deblank(fliplr(deblank(fliplr(QmatNMR.uiInput1))));			%remove trailing and heading spaces
      QTEMP11 = double(['QmatNMR.uiInput1 = ''' QTEMP1 '''']);
      QTEMP12 = ceil(length(QTEMP11)/(QmatNMR.MacroLength-1));
      QTEMP13 = zeros(1, QTEMP12*(QmatNMR.MacroLength-1));
      QTEMP13(1:length(QTEMP11)) = QTEMP11;
      for QTEMP40=1:QTEMP12
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 711, QTEMP13((QTEMP40-1)*(QmatNMR.MacroLength-1)+ (1:(QmatNMR.MacroLength-1))));
      end
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 712);
      
      %
      %Then store the processing action
      %
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 745, eval(QmatNMR.uiInput2), eval(QmatNMR.uiInput3));
    end
    
    disp('Super title added to the plot. Text can be dragged by using the left mouse button');
  else
    disp('Super title cancelled ...');
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
