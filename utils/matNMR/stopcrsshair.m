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
%stopcrsshair.m removes the uicontrols from crsshair.m from the matNMR figure window
%21-12-'96

try
  global QmatNMR
  
  %for crsshair.m:
  
  	%
  	%Delete the UIcontrols 
  	%
  	QmatNMR.XHRhandles=QmatNMR.XHR_plot_data;
  	QmatNMR.XHRQmatNMR.X_ydata_line=QmatNMR.XHRhandles(1);
  	QmatNMR.XHRY_ydata_line=QmatNMR.XHRhandles(2);
  	QmatNMR.XHRQmatNMR.X_aQmatNMR.Xis=QmatNMR.XHRhandles(3);
  	QmatNMR.XHRQmatNMR.XaQmatNMR.Xis_teQmatNMR.Xt=QmatNMR.XHRhandles(4);
  	QmatNMR.XHRQmatNMR.X_num=QmatNMR.XHRhandles(5);
  	QmatNMR.XHRxindex_text=QmatNMR.XHRhandles(6);
  	QmatNMR.XHRQmatNMR.Xindex_num=QmatNMR.XHRhandles(7);
  	QmatNMR.XHRY_teQmatNMR.Xt=QmatNMR.XHRhandles(8);
  	QmatNMR.XHRY_num=QmatNMR.XHRhandles(9);  
  	QmatNMR.XHRtrace_switcher=QmatNMR.XHRhandles(10);
          QmatNMR.XHRQmatNMR.Xhairs_on=QmatNMR.XHRhandles(11);
          QmatNMR.XHRcloser=QmatNMR.XHRhandles(12);
          delete(QmatNMR.XHRQmatNMR.XaQmatNMR.Xis_teQmatNMR.Xt);
          delete(QmatNMR.XHRQmatNMR.X_ydata_line);
          delete(QmatNMR.XHRY_ydata_line);
          delete(QmatNMR.XHRQmatNMR.X_num);
          delete(QmatNMR.XHRY_teQmatNMR.Xt);
          delete(QmatNMR.XHRxindex_text);
          delete(QmatNMR.XHRQmatNMR.Xindex_num);
          delete(QmatNMR.XHRY_num);
          delete(QmatNMR.XHRQmatNMR.Xhairs_on);
  	delete(QmatNMR.XHRtrace_switcher);
          delete(QmatNMR.XHRcloser); 
  	delete(QmatNMR.XHRExtra);
  	delete(QmatNMR.XHRExtra2);
  	set(QmatNMR.XHR_plot,'WindowButtonUpFcn','');
  	set(QmatNMR.XHR_plot,'WindowButtonMotionFcn','');	
          set(QmatNMR.XHR_plot,'WindowButtonDownFcn',QmatNMR.XHR_button_data);
          refresh(QmatNMR.Fig)
  
  %for matNMR:
  
  	%
  	%re-enable all UIcontrols again
  	%
        QmatNMR.SETbuttons = findobj(allchild(QmatNMR.Fig), 'type', 'uicontrol');
        set(QmatNMR.SETbuttons, 'enable', 'on');
  
  	clear QSETteller

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
