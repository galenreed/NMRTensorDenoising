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
% regelsavefitdisk stores the plot of the current fit window on disk as an m-file.
%
% Jacco van Beek
% 02-02-07

try
  if QmatNMR.buttonList == 1		%OK-button
    %
    %first we copy the window to a new one
    %
    QmatNMR.New = copyobj(gcf, 0);
    
    
    %
    %Then we delete all callbacks of the uicontrols and delete the menubar
    %
    set(findobj(allchild(QmatNMR.New), 'type', 'uicontrol'), 'callback', '');
    delete(findobj(allchild(QmatNMR.New), 'type', 'uimenu'));
    set(QmatNMR.New, 'CloseRequestFCN', 'closereq');
    
    
    %
    %Create a new menubar
    %
    Rotate3DmatNMR off
    ZoomMatNMR FitWindow off
    QmatNMR.C1 = uimenu('label', '   Close Window   ');
    	uimenu(QmatNMR.C1, 'label', 'Close Window', 'callback', 'close', 'accelerator', 'w');
  	
    QmatNMR.C2 = uimenu('label', '   Zoom   ');
    	uimenu(QmatNMR.C2, 'label', 'Zoom', 'callback', 'view(2); Rotate3DmatNMR off; ZoomMatNMR 2D3DViewer');
  	
    QmatNMR.C3 = uimenu('label', '   Rotate3D   ');
    	uimenu(QmatNMR.C3, 'label', 'Rotate3D', 'callback', 'Rotate3DmatNMR on');
  	
    QmatNMR.C4 = uimenu('label', '   Get Position   ');
    	uimenu(QmatNMR.C4, 'label', 'Get Position', 'callback', 'view(2); ZoomMatNMR 2D3DViewer off; crsshair2d('''', '''')');
    
    QTEMP1 = ['global QmatNMR; figure(QmatNMR.New); matprint;'];
    QmatNMR.C5 = uimenu('label', '   Printing Menu   ');
    	uimenu(QmatNMR.C5, 'label', 'Printing Menu', 'callback', QTEMP1, 'accelerator', 'p');
  
    
    %
    %Then we print as an m-file
    %
    if strcmp(QmatNMR.uiInput1((end-1):end), '.m')
      QmatNMR.uiInput1 = QmatNMR.uiInput1(1:(end-2));
    end
    saveas(QmatNMR.New, [QmatNMR.uiInput1 '.m'], 'mfig');
    
    
    %
    %finish
    %
    disp(['current window save on disk as ' QmatNMR.uiInput1 '.m']);
    delete(QmatNMR.New)
  
  else
    disp('Save of fit (plot) to disk as m-file was cancelled ...');
  end

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
