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
%contcmap.m handles changing of the colormap in a 2D/3D viewer window
%
%30-09-'98

try
  %
  %switch figure if necessary only because this will cause an additional rendering step
  %
  if (gcf ~= QmatNMR.Fig2D3D)
    figure(QmatNMR.Fig2D3D);
  end
  
  QTEMP2 = get(QmatNMR.c8, 'Value');
  QColorMaps(QTEMP2);
  
  %
  %set the value for the current colormap if the user has chosen a new colormap
  %
  if ~isempty(deblank(QmatNMR.PopupStr2(QTEMP2, :)))
    QmatNMR.CurrentColorMap = QmatNMR.PopupStr2(QTEMP2, :);
    QTEMP1 = get(QmatNMR.Fig2D3D, 'userdata');
    QTEMP1.ColorMap = QmatNMR.CurrentColorMap;
    set(QmatNMR.Fig2D3D, 'userdata', QTEMP1);
  end
  
  
  %
  %Add an entry to the plotting macro if we're recording one
  %
  if (QmatNMR.RecordingPlottingMacro)
    %
    %Store the processing action
    %
    QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 752, QTEMP2);
  end
  
  
  %
  %Perform the action
  %
  %if necessary reset all color bars in the figure to the new color map
  QTEMP1 = find(QmatNMR.ContColorbarIndicator == 1);
  for QTEMP3 = 1:length(QTEMP1)
    %axes(findobj(allchild(QmatNMR.Fig2D3D), 'type', 'axes', 'userdata', QTEMP1(QTEMP3)));
    set(QmatNMR.Fig2D3D, 'currentaxes', findobj(allchild(QmatNMR.Fig2D3D), 'type', 'axes', 'userdata', QTEMP1(QTEMP3)));
    try
      delete(QmatNMR.contcolorbar(QTEMP1(QTEMP3)));
    catch
      %
      %issue a warning statement and wait for the response
      %
      beep
      QuiInput(['matNMR WARNING:' char(10)  char(10) 'The current 2D/3D viewer window appears' char(10) 'to be corrupted! Please close this window or' char(10) 'select a new subplot configuration.'], 'Continue', '');
      waitforbuttonpress
    end
    RestoreSubplots(QmatNMR.Fig2D3D, QmatNMR.ContSubplots);
    QmatNMR.contcolorbar(QTEMP1(QTEMP3)) = colorbarmatNMR('vert');
    set(gcf, 'nextplot', 'add');		%default for matNMR. if left as "replacechildren" (done by colorbar.m)
  end
  %axes(findobj(allchild(QmatNMR.Fig2D3D), 'type', 'axes', 'userdata', QmatNMR.AxisNR2D3D));
  set(QmatNMR.Fig2D3D, 'currentaxes', findobj(allchild(QmatNMR.Fig2D3D), 'type', 'axes', 'userdata', QmatNMR.AxisNR2D3D));
  set(QmatNMR.c8, 'value', 1);
  
  %
  %Store the updated information in the figure userdata
  %
  QTEMP1 = get(QmatNMR.Fig2D3D, 'userdata');
  QTEMP1.ColorBarHandles = QmatNMR.contcolorbar;
  set(QmatNMR.Fig2D3D, 'userdata', QTEMP1);
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
