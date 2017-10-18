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
function crsshair(action);
%         crsshair
%
%  A gui interface for reading (x,y) values from a plot.
%	
%  A set of mouse driven crosshairs is placed on the current axes,
%  and displays the current (x,y) position, interpolated between points. 
%  For multiple QmatNMR.XHRtraces, only plots with the same length(xdata) 
%  will be tracked. Select done after using to remove the gui stuff, 
%  and to restore the mouse buttons to previous values.
%
%   Richard G. Cobb    3/96
%   cobbr@plk.af.mil 
%

%
% adapted for matNMR by Jacco van Beek
% 1-1-'97
%

global QmatNMR

if nargin == 0
        QmatNMR.XHR_plot=QmatNMR.Fig;
        QmatNMR.XHRx_axis=gca;
        QmatNMR.XHR_xdata=[];
        QmatNMR.XHR_ydata=[];
        QmatNMR.XHR_colors=[];
        sibs=get(QmatNMR.XHRx_axis,'Children');
        found=0;
        for Qi=1:size(sibs)
         if strcmp(get(sibs(Qi),'Type'),'line') 
           if length(get(sibs(Qi),'XData')) > length(QmatNMR.XHR_xdata)
             found=1;
             QmatNMR.XHR_xdata=[];
             QmatNMR.XHR_ydata=[];
	     QmatNMR.XHR_xdata(:,found)=get(sibs(Qi),'XData').';	     
             QmatNMR.XHR_ydata(:,found)=get(sibs(Qi),'Ydata').';
             QmatNMR.XHR_colors = get(sibs(Qi),'Color').';
           elseif length(get(sibs(Qi),'XData')) == length(QmatNMR.XHR_xdata)
             found=found+1;
             QmatNMR.XHR_xdata(:,found)=get(sibs(Qi),'XData').';
             QmatNMR.XHR_ydata(:,found)=get(sibs(Qi),'Ydata').';
             QmatNMR.XHR_colors(:,found) = get(sibs(Qi),'Color').';
 	   end
         end
        end
        QmatNMR.XHR_button_data=get(QmatNMR.XHR_plot,'WindowButtonDownFcn');
	set(QmatNMR.XHR_plot,'WindowButtonDownFcn','crsshair(''down'');');
	QmatNMR.XHRQmatNMR.X_rng=get(QmatNMR.XHRx_axis,'Xlim');
	QmatNMR.XHRy_rng_ydata=get(QmatNMR.XHRx_axis,'Ylim');

%
%
%   Frame and Buttons
%
%

        QmatNMR.XHRExtra  = uicontrol('parent', QmatNMR.Fig, 'Style', 'Frame', 'units', 'Normalized', 'Position', [0 .925 1 .076], 'backgroundcolor', QmatNMR.ColorScheme.Frame2);
	QmatNMR.XHRExtra2 = uicontrol('parent', QmatNMR.Fig, 'Style', 'Frame', 'units', 'Normalized', 'Position', [.74 .00 .26 .27], 'backgroundcolor', QmatNMR.ColorScheme.Frame2, 'visible', 'off');

	QmatNMR.XHRxindex_text=uicontrol('parent', QmatNMR.Fig, 'Style','Pushbutton','Units','Normalized',...
			'Position',[.15 .94 .075 .045],...
			'backgroundcolor', QmatNMR.ColorScheme.Button1Back, ...
			'foregroundcolor', QmatNMR.ColorScheme.Button1Fore, ...
			'String','X index');
	QmatNMR.XHRQmatNMR.Xindex_num=uicontrol('parent', QmatNMR.Fig, 'Style','edit','Units','Normalized',...
			'Position',[.225 .94 .075 .045],...
			'backgroundcolor', QmatNMR.ColorScheme.Button11Back, ...
			'foregroundcolor', QmatNMR.ColorScheme.Button11Fore, ...
			'String',' ');


	QmatNMR.XHRxaxis_text=uicontrol('parent', QmatNMR.Fig, 'Style','Pushbutton','Units','Normalized',...
			'Position',[.35 .94 .1 .045],...
			'backgroundcolor', QmatNMR.ColorScheme.Button1Back, ...
			'foregroundcolor', QmatNMR.ColorScheme.Button1Fore, ...
			'String','X value');
	QmatNMR.XHRQmatNMR.X_num=uicontrol('parent', QmatNMR.Fig, 'Style','edit','Units','Normalized',...
			'Position',[.45 .94 .15 .045],...
			'backgroundcolor', QmatNMR.ColorScheme.Button11Back, ...
			'foregroundcolor', QmatNMR.ColorScheme.Button11Fore, ...
			'String',' ');


	QmatNMR.XHRy_text=uicontrol('parent', QmatNMR.Fig, 'Style','Pushbutton','Units','Normalized',...
			'Position',[.65 .94 .1 .045],...
			'backgroundcolor', QmatNMR.ColorScheme.Button1Back, ...
			'foregroundcolor', QmatNMR.ColorScheme.Button1Fore, ...
			'String','Y value');
	QmatNMR.XHRy_num=uicontrol('parent', QmatNMR.Fig, 'Style','edit','Units','Normalized',...
			'Position',[.75 .94 .15 .045],...
			'backgroundcolor', QmatNMR.ColorScheme.Button11Back, ...
			'foregroundcolor', QmatNMR.ColorScheme.Button11Fore, ...
			'String',' ');

        QmatNMR.XHRcloser=uicontrol('parent', QmatNMR.Fig, 'Style','Push','Units','Normalized',...
		'Position',[.05 0.945 .08 .04],...
		'String','Done',...
		'CallBack','stopcrsshair',...
                'backgroundcolor', QmatNMR.ColorScheme.Button3Back, ...
                'foregroundcolor', QmatNMR.ColorScheme.Button3Fore, ...
		'Visible','on');

	QmatNMR.XHRxhairs_on=uicontrol('parent', QmatNMR.Fig, 'Style','Text','Units','Normalized',...
				'Position',[.78 .15 .19 .05],...
				'FontName', 'Helvetica', ...
				'FontSize', 16, ...
				'FontWeight', 'normal', ...
				'BackGroundColor', [.2 .2 .4], ...
				'ForeGroundColor', [1 1 1], ...
				'String','The Crosshair is now on :',...
				'Visible','off');
		z(1,:)=['Line nr. ' num2str(1)];
		for Qi=2:min(size(QmatNMR.XHR_ydata))
  		  z=[z ' | Line nr. ' num2str(Qi)];
		end
		QmatNMR.XHRtraces=z;	
	
	QmatNMR.XHRtrace_switcher=uicontrol('parent', QmatNMR.Fig, 'Style','Popup','Units','Normalized',...
			'Position',[.8 .08 .15 .04],...
			'String',QmatNMR.XHRtraces,...
			'BackGroundColor',[1 1 0],...
			'Visible','off',...
			'CallBack',['crsshair(''up'');',]);	
	if min(size(QmatNMR.XHR_ydata))>1,
		set(QmatNMR.XHRtrace_switcher,'Visible','On','Value',1);
		set(QmatNMR.XHRxhairs_on,'Visible','On');
		set(QmatNMR.XHRExtra2, 'visible', 'on');
	end
		QmatNMR.XHRQmatNMR.X_ydata_line=line(QmatNMR.XHRQmatNMR.X_rng,[QmatNMR.XHRy_rng_ydata(1) QmatNMR.XHRy_rng_ydata(1)]);
		QmatNMR.XHRy_ydata_line=line(QmatNMR.XHRQmatNMR.X_rng,[QmatNMR.XHRy_rng_ydata(1) QmatNMR.XHRy_rng_ydata(1)]);
		set(QmatNMR.XHRQmatNMR.X_ydata_line,'Color',QmatNMR.XHR_colors(:, 1).', 'Tag', 'GetPositionLine');
		set(QmatNMR.XHRy_ydata_line,'Color',QmatNMR.XHR_colors(:, 1).', 'Tag', 'GetPositionLine');
		set(QmatNMR.XHRQmatNMR.X_ydata_line,'EraseMode','xor');set(QmatNMR.XHRy_ydata_line,...
                   'EraseMode','xor');		

	QmatNMR.XHR_plot_data=[QmatNMR.XHRQmatNMR.X_ydata_line QmatNMR.XHRy_ydata_line  ...
		  QmatNMR.XHRx_axis   QmatNMR.XHRxaxis_text QmatNMR.XHRQmatNMR.X_num...
		  QmatNMR.XHRxindex_text QmatNMR.XHRQmatNMR.Xindex_num QmatNMR.XHRy_text QmatNMR.XHRy_num  ...
		  QmatNMR.XHRtrace_switcher QmatNMR.XHRxhairs_on QmatNMR.XHRcloser QmatNMR.XHRExtra];
		
else
	QmatNMR.XHRhandles=QmatNMR.XHR_plot_data;
	QmatNMR.XHRQmatNMR.X_ydata_line=QmatNMR.XHRhandles(1);
	QmatNMR.XHRy_ydata_line=QmatNMR.XHRhandles(2);
	QmatNMR.XHRx_axis=QmatNMR.XHRhandles(3);
	QmatNMR.XHRxaxis_text=QmatNMR.XHRhandles(4);
	QmatNMR.XHRQmatNMR.X_num=QmatNMR.XHRhandles(5);
	QmatNMR.XHRxindex_text=QmatNMR.XHRhandles(6);
	QmatNMR.XHRQmatNMR.Xindex_num=QmatNMR.XHRhandles(7);
	QmatNMR.XHRy_text=QmatNMR.XHRhandles(8);
	QmatNMR.XHRy_num=QmatNMR.XHRhandles(9);
	QmatNMR.XHRtrace_switcher=QmatNMR.XHRhandles(10);
	QmatNMR.XHRxhairs_on=QmatNMR.XHRhandles(11);
	QmatNMR.XHRcloser=QmatNMR.XHRhandles(12);
	index = 1 + min(size(QmatNMR.XHR_ydata)) - get(QmatNMR.XHRtrace_switcher,'Value');
	QmatNMR.XHR_xdata_col=QmatNMR.XHR_xdata(:,index);
        QmatNMR.XHR_ydata_col=QmatNMR.XHR_ydata(:,index);


	if strcmp(action,'down');
	  set(QmatNMR.XHR_plot,'WindowButtonMotionFcn','crsshair(''move'');');
  	  set(QmatNMR.XHR_plot,'WindowButtonUpFcn','crsshair(''up'');');

	elseif strcmp(action,'up');
	  set(QmatNMR.XHR_plot,'WindowButtonMotionFcn',' ');
	  set(QmatNMR.XHR_plot,'WindowButtonUpFcn',' ');
	end


	pt=get(QmatNMR.XHRx_axis,'Currentpoint');
	xdata_pt=pt(1,1);
	if xdata_pt>=max(QmatNMR.XHR_xdata_col),
		xdata_pt=max(QmatNMR.XHR_xdata_col);
		k=length(QmatNMR.XHR_xdata_col);
	elseif xdata_pt<=min(QmatNMR.XHR_xdata_col),
		xdata_pt=min(QmatNMR.XHR_xdata_col);
		k=2;
	else, 
		k=find(QmatNMR.XHR_xdata_col>xdata_pt);k=k(1);
	end

        %
	%first we interpolate between the x coordinates to determine the y value
	%
        ydata_pt = interp1q(QmatNMR.XHR_xdata_col, QmatNMR.XHR_ydata_col, xdata_pt);

	%
	%then, from the y value we interpolate the x value, but only if the difference
	%between the two closest x coordinates is not 0 or NaN (that crashes interp1)
	%
	if (sum(isnan([QmatNMR.XHR_ydata_col(k-1) QmatNMR.XHR_ydata_col(k)])))
	  k_index_pt = k;		%at least one y value is NaN
	else
  	  if diff([QmatNMR.XHR_ydata_col(k-1) QmatNMR.XHR_ydata_col(k)])
  	    k_index_pt = interp1([QmatNMR.XHR_ydata_col(k-1) QmatNMR.XHR_ydata_col(k)], [(k-1); k], ydata_pt);
  	  else
	    k_index_pt = k;		%y values are both 0
	  end
	end

	QmatNMR.XHRQmatNMR.X_rng=get(QmatNMR.XHRx_axis,'Xlim');
	QmatNMR.XHRy_rng_ydata=get(QmatNMR.XHRx_axis,'Ylim');
	set(QmatNMR.XHRQmatNMR.X_ydata_line,'XData',[xdata_pt xdata_pt],'Ydata',QmatNMR.XHRy_rng_ydata);
	set(QmatNMR.XHRy_ydata_line,'XData',QmatNMR.XHRQmatNMR.X_rng,'Ydata',[ydata_pt ydata_pt]);
	set(QmatNMR.XHRQmatNMR.X_ydata_line,'Color',QmatNMR.XHR_colors(:, index).');
        set(QmatNMR.XHRy_ydata_line,'Color',QmatNMR.XHR_colors(:, index).');	
	set(QmatNMR.XHRQmatNMR.X_num,'String',num2str(xdata_pt,8));
	
	%
	%now we determine the index in points. Depending on what the plot direction is
	%and whether the current line is an FID or a spectrum (determined by QmatNMR.FIDstatus
	%variable), the indexing is different.
	%
	if strcmp(get(gca, 'xdir'), 'reverse')
  	  set(QmatNMR.XHRQmatNMR.Xindex_num, 'String', num2str(k_index_pt, 8));
	else
	  if (QmatNMR.FIDstatus == 2)		%FID
	    if (QmatNMR.Rincr > 0)	%ascending axis
              set(QmatNMR.XHRQmatNMR.Xindex_num, 'String', num2str(k_index_pt, 8));
	    else		%descending axis
	      set(QmatNMR.XHRQmatNMR.Xindex_num, 'String', num2str(length(QmatNMR.XHR_xdata_col) - k_index_pt + 1, 8));
	    end
	  else				%Spectrum
  	    set(QmatNMR.XHRQmatNMR.Xindex_num, 'String', num2str(length(QmatNMR.XHR_xdata_col) - k_index_pt + 1, 8));
	  end
	end
	set(QmatNMR.XHRy_num,'String',num2str(ydata_pt,8));
	QmatNMR.XHR_plot_data=[QmatNMR.XHRQmatNMR.X_ydata_line QmatNMR.XHRy_ydata_line  ...
		  QmatNMR.XHRx_axis   QmatNMR.XHRxaxis_text QmatNMR.XHRQmatNMR.X_num...
		  QmatNMR.XHRxindex_text QmatNMR.XHRQmatNMR.Xindex_num QmatNMR.XHRy_text QmatNMR.XHRy_num  ...
		  QmatNMR.XHRtrace_switcher QmatNMR.XHRxhairs_on QmatNMR.XHRcloser QmatNMR.XHRExtra];
end

