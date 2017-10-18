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
function Qtextdata(command, Button)
%
% This routine changes the text properties of each newly drawn line for matNMR !!
%
% Jacco van Beek, june '97
%
%
% button were taken as in QezLegend.
%

global QmatNMR

if (nargin < 1)
  CurmatNMRWindow = gcf;
end  

if ((nargin < 1) & (QmatNMR.leginp2 == 0))		%If window does not exist make new one.
%
  T1 = QmatNMR.FontList;
  T2 = ['6 ';'7 ';'8 ';'9 ';'10';'11';'12';'14';'16';'18';'20';'24';'30';'36';'48';'72'];
  T3 = ['Normal ';'Italic ';'Oblique'];        
  T4 = ['Light ';'Normal';'Demi  ';'Bold  '];

  QmatNMR.leginp2=figure('Color','k','NumberTitle','off','Name',...
	'Text Properties',...
  	'Units','Pixels',...
        'Menubar','none',...
	'Tag', num2str(CurmatNMRWindow), ...
	'CloseRequestFCN','global QmatNMR; try; delete(QmatNMR.leginp2); end; QmatNMR.leginp2 = [];', ...
	'color', QmatNMR.ColorScheme.Figure1Back, ...
	'Position',[525  80 285 82]);

  %
  %To work around a Matlab bug (see BugFixes.txt, 11-05-'04) we redefine the position and units.
  %
  set(QmatNMR.leginp2, 'units', 'pixels', 'position', [525  80 285 82]);

  axes('units', 'Normalized', 'Position', [0 0 1 1]);
  axis off
  axis([0,1,0,1])
  

%=======
  
%Close button
  uicontrol('Parent',QmatNMR.leginp2,...
			'style','pushbutton',...
			'string','Close',...
			'units','Pixels',...
			'position',[5 2 80 28],...
			'BackGroundColor', QmatNMR.ColorScheme.Button4Back, ...
			'ForeGroundColor', QmatNMR.ColorScheme.Button4Fore, ...
			'callback','global QmatNMR; try; delete(QmatNMR.leginp2); end; QmatNMR.leginp2 = [];');

%Save button
  uicontrol('Parent',QmatNMR.leginp2,...
			'style','pushbutton',...
			'string','Save',...
			'units','Pixels',...
			'position',[20 50 50 28],...
			'BackGroundColor', QmatNMR.ColorScheme.Button3Back, ...
			'ForeGroundColor', QmatNMR.ColorScheme.Button3Fore, ...
			'callback','Qtextdata(5)');

  
  uicontrol('Parent',QmatNMR.leginp2,...
			'Style', 'Pushbutton', ...
  			'Units', 'Pixels', ...
  			'Position', [ 90 61 90 20],...
  			'String', 'Font :', ...
			'BackGroundColor', QmatNMR.ColorScheme.Button2Back, ...
			'ForeGroundColor', QmatNMR.ColorScheme.Button2Fore, ...
  			'HorizontalAlignment', 'center');
  			
  mi(1) = uicontrol('Parent',QmatNMR.leginp2,...
			'Style','Popup','Units','Pixels',...
			'Position',[185 61 100 20],...
			'String',T1,...
			'Visible','on',...
                        'HorizontalAlignment', 'left',...
			'BackGroundColor', QmatNMR.ColorScheme.Button1Back, ...
			'ForeGroundColor', QmatNMR.ColorScheme.Button1Fore, ...
			'CallBack','Qtextdata(1)');
			

  Ttmp = QmatNMR.FontList;
  for teller=1:size(Ttmp, 1)
    if strcmp(deblank(Ttmp(teller, :)), QmatNMR.TextFont)
      set(mi(1), 'value', teller);
    end
  end;    
  			
  

  uicontrol('Parent',QmatNMR.leginp2,...
			'Style', 'Pushbutton', ...
  			'Units', 'Pixels', ...
  			'Position', [ 90 41 90 20],...
			'BackGroundColor', QmatNMR.ColorScheme.Button2Back, ...
			'ForeGroundColor', QmatNMR.ColorScheme.Button2Fore, ...
 			'String', 'Font Size :', ...
  			'HorizontalAlignment', 'center');
 
  mi(2) = uicontrol('Parent',QmatNMR.leginp2,...
			'Style','Popup','Units','Pixels',...
			'Position',[185 41 100 20],...
			'String',T2,...
			'Visible','on',...
                        'HorizontalAlignment', 'left',...
			'BackGroundColor', QmatNMR.ColorScheme.Button1Back, ...
			'ForeGroundColor', QmatNMR.ColorScheme.Button1Fore, ...
			'CallBack','Qtextdata(2)');

  Ttmp=T2;
  for teller=1:14
    if strcmp(deblank(Ttmp(teller, :)), num2str(QmatNMR.TextSize))
      set(mi(2), 'value', teller);
    end
  end;    


  uicontrol('Parent',QmatNMR.leginp2,...
			'Style', 'Pushbutton', ...
  			'Units', 'Pixels', ...
  			'Position', [ 90  21 90 20],...
			'BackGroundColor', QmatNMR.ColorScheme.Button2Back, ...
			'ForeGroundColor', QmatNMR.ColorScheme.Button2Fore, ...
  			'String', 'Font Angle :', ...
  			'HorizontalAlignment', 'center');

  mi(3) = uicontrol('Parent',QmatNMR.leginp2,...
			'Style','Popup','Units','Pixels',...
			'Position',[185  21 100 20],...
			'String',T3,...
			'Visible','on',...
                        'HorizontalAlignment', 'left',...
			'BackGroundColor', QmatNMR.ColorScheme.Button1Back, ...
			'ForeGroundColor', QmatNMR.ColorScheme.Button1Fore, ...
			'CallBack','Qtextdata(3)');

  Ttmp = ['normal ';'italic ';'oblique'];
  for teller=1:3
    if strcmp(deblank(Ttmp(teller, :)), QmatNMR.TextAngle)
      set(mi(3), 'value', teller);
    end
  end;    


  uicontrol('Parent',QmatNMR.leginp2,...
			'Style', 'Pushbutton', ...
  			'Units', 'Pixels', ...
  			'Position', [ 90   1 90 20],...
			'BackGroundColor', QmatNMR.ColorScheme.Button2Back, ...
			'ForeGroundColor', QmatNMR.ColorScheme.Button2Fore, ...
  			'String', 'Font Weight :', ...
  			'HorizontalAlignment', 'center');

  mi(4) = uicontrol('Parent',QmatNMR.leginp2,...
			'Style','Popup','Units','Pixels',...
			'Position',[185   1 100 20],...
			'String',T4,...
			'Visible','on',...
                        'HorizontalAlignment', 'left',...
			'BackGroundColor', QmatNMR.ColorScheme.Button1Back, ...
			'ForeGroundColor', QmatNMR.ColorScheme.Button1Fore, ...
			'CallBack','Qtextdata(4)');

  Ttmp = ['light ';'normal';'demi  ';'bold  '];
  for teller=1:4
    if strcmp(deblank(Ttmp(teller, :)), QmatNMR.TextWeight)
      set(mi(4), 'value', teller);
    end
  end;    
 
 
  set(QmatNMR.leginp2, 'userdata', mi);
  figure(QmatNMR.leginp2);

elseif ((nargin < 1) & (QmatNMR.leginp2 > 0))			%Figure window already exists so pull to front
	figure(QmatNMR.leginp2)
	set(QmatNMR.leginp2, 'Tag', num2str(CurmatNMRWindow));
	
elseif command==1
	T1 = QmatNMR.FontList;
        handles = get(gcf,'UserData');

        QmatNMR.TextFont = deblank(T1(get(handles(1),'Value'),:));
	CurAxis = findobj(allchild(str2num(get(QmatNMR.leginp2, 'Tag'))), 'type', 'axes');
	AxesChildren = allchild(CurAxis);
	
	if (length(CurAxis) > 1)
	  AxesChildren = cat(1,AxesChildren{:});
	end  

	set(findobj(AxesChildren, 'fontname', get(CurAxis(1), 'fontname')), 'FontName', QmatNMR.TextFont)
        set(CurAxis, 'FontName', QmatNMR.TextFont);
        

elseif command==2
	T2 = ['6 '; '7 ';'8 ';'9 ';'10';'11';'12';'14';'16';'18';'20';'24';'30';'36';'48';'72'];
        handles = get(gcf,'UserData');

        QmatNMR.TextSize = str2num(deblank(T2(get(handles(2),'Value'),:)));
	CurAxis = findobj(allchild(str2num(get(QmatNMR.leginp2, 'Tag'))), 'type', 'axes');
	AxesChildren = allchild(CurAxis);
	
	if (length(CurAxis) > 1)
	  AxesChildren = cat(1,AxesChildren{:});
	end  
	
	set(findobj(AxesChildren, 'fontsize', get(CurAxis(1), 'fontsize')), 'fontsize', QmatNMR.TextSize)
        set(CurAxis, 'FontSize', QmatNMR.TextSize);

elseif command==3
        T3 = ['normal ';'italic ';'oblique'];        
	handles = get(gcf,'UserData');

        QmatNMR.TextAngle = deblank(T3(get(handles(3),'Value'),:));
	CurAxis = findobj(allchild(str2num(get(QmatNMR.leginp2, 'Tag'))), 'type', 'axes');
	AxesChildren = allchild(CurAxis);
	
	if (length(CurAxis) > 1)
	  AxesChildren = cat(1,AxesChildren{:});
	end  

	set(findobj(AxesChildren, 'fontangle', get(CurAxis(1), 'fontangle')), 'FontAngle', QmatNMR.TextAngle)
        set(CurAxis, 'FontAngle', QmatNMR.TextAngle);

elseif command==4
	T4 = ['light ';'normal';'demi  ';'bold  '];        
	handles = get(gcf, 'userData');
	
	QmatNMR.TextWeight = deblank(T4(get(handles(4), 'Value'), :));
	CurAxis = findobj(allchild(str2num(get(QmatNMR.leginp2, 'Tag'))), 'type', 'axes');
	AxesChildren = allchild(CurAxis);
	
	if (length(CurAxis) > 1)
	  AxesChildren = cat(1,AxesChildren{:});
	end  

	set(findobj(AxesChildren, 'fontweight', get(CurAxis(1), 'fontweight')), 'FontWeight', QmatNMR.TextWeight)
        set(CurAxis, 'FontWeight', QmatNMR.TextWeight);

elseif command==5 		%save settings into options file
        SetOptions(6);
        saveoptions
end
