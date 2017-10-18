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
function Qfontops(command)
%
% This routine changes the font list for matNMR !!
%
%06-10-'00

global QmatNMR QmatNMRsettings

if ((nargin < 1) & (QmatNMR.leginp4 == 0))		%If window does not exist make new one.
%
  QmatNMR.leginp4=figure('Color','k','NumberTitle','off', ...
  	'Name', 'Font list for matNMR',...
  	'Units','normalized',...
        'Menubar','none',...
	'color', QmatNMR.ColorScheme.Figure1Back, ...
	'Position',[0.05 0.4 0.9 0.15], ...
        'closerequestfcn', 'global QmatNMR; try; delete(QmatNMR.leginp4); end; QmatNMR.leginp4 = [];');

  %
  %To work around a Matlab bug (see BugFixes.txt, 11-05-'04) we redefine the position and units.
  %
  set(QmatNMR.leginp4, 'units', 'normalized', 'position', [0.05 0.4 0.9 0.15]);

  AxisHandle = axes('units', 'Normalized', 'Position', [0 0 1 1]);
  axis off
  axis([0,1,0,1])
  

%=======
  
%Close button
  uicontrol('Parent',QmatNMR.leginp4,...
			'style','pushbutton',...
			'string','Close',...
			'units','Pixels',...
			'position',[5 2 80 35],...
			'units', 'normalized', ...
			'BackGroundColor', QmatNMR.ColorScheme.Button4Back, ...
			'ForeGroundColor', QmatNMR.ColorScheme.Button4Fore, ...
			'callback', 'global QmatNMR; try; delete(QmatNMR.leginp4); end; QmatNMR.leginp4 = [];');

%Execute button
  uicontrol('Parent',QmatNMR.leginp4,...
			'style','pushbutton',...
			'string','Execute',...
			'units','Pixels',...
			'position',[100 2 80 35],...
			'units', 'normalized', ...
			'BackGroundColor', QmatNMR.ColorScheme.Button5Back, ...
			'ForeGroundColor', QmatNMR.ColorScheme.Button5Fore, ...
			'callback','Qfontops(3)');

%Save button
  uicontrol('Parent',QmatNMR.leginp4,...
			'style','pushbutton',...
			'string','Save',...
			'units','Pixels',...
			'position',[200 2 80 35],...
			'units', 'normalized', ...
			'BackGroundColor', QmatNMR.ColorScheme.Button3Back, ...
			'ForeGroundColor', QmatNMR.ColorScheme.Button3Fore, ...
			'callback','Qfontops(2)');

%Import system fonts button
  uicontrol('Parent',QmatNMR.leginp4,...
			'style','pushbutton',...
			'string','Import system fonts',...
			'units','Pixels',...
			'position',[350 2 180 35],...
			'units', 'normalized', ...
			'BackGroundColor', QmatNMR.ColorScheme.Button1Back, ...
			'ForeGroundColor', QmatNMR.ColorScheme.Button1Fore, ...
			'callback','Qfontops(4)');



%buttons for editing the font list	
  uicontrol('Parent',QmatNMR.leginp4,...
			'Style', 'Pushbutton', ...
			'units', 'normalized', ...
  			'Position', [0.025 0.65 0.95 ,0.25],...
  			'String', 'Font List :', ...
			'BackGroundColor', QmatNMR.ColorScheme.Button2Back, ...
			'ForeGroundColor', QmatNMR.ColorScheme.Button2Fore, ...
  			'HorizontalAlignment', 'center');

  QTEMP1 = '';
  for QTEMP40=1:size(QmatNMR.FontList, 1)
    QTEMP1 = [QTEMP1 sprintf('%s,', deblank(QmatNMR.FontList(QTEMP40, :)))];
  end
  mi(1) = uicontrol('Parent',QmatNMR.leginp4,...
			'Style','Edit', ...
			'units', 'normalized', ...
  			'Position', [0.025 0.4 0.95 ,0.25],...
			'String', QTEMP1,...
			'Visible','on',...
                        'HorizontalAlignment', 'left',...
			'BackGroundColor', QmatNMR.ColorScheme.Button1Back, ...
			'ForeGroundColor', QmatNMR.ColorScheme.Button1Fore, ...
			'CallBack','Qfontops(3)');


%
% Now save all button QmatNMR.handles in the userdata
% 
  set(QmatNMR.leginp4, 'userdata', mi);
  figure(QmatNMR.leginp4);

elseif ((nargin < 1) & (QmatNMR.leginp4 > 0))			%Figure window already exists so pull to front
	figure(QmatNMR.leginp4)
	
elseif command==2					%save Font list as default
  %first we extract the new font list
  Qfontops(3);

  
  %
  %the new font list may not contain the current font. This must be checked and if so 
  %the first entry from the font list will be selected as current font
  %
  QTEMP1 = 0;
  for teller=1:size(QmatNMR.FontList, 1)
    if strcmp(deblank(QmatNMR.FontList(teller, :)), QmatNMRsettings.DefaultTextFont);
      QTEMP1 = 1;
      break
    end
  end  
  if ~QTEMP1
    disp('matNMR WARNING: The new font list does not contain the default font name.');
    disp('matNMR WARNING: Therefore the first entry from the list will be made the default font.');

    QmatNMRsettings.DefaultTextFont = deblank(QmatNMR.FontList(1, :));
    disp(['Default font set to "' QmatNMRsettings.DefaultTextFont '"']);
  end

  SetOptions(4)
  %then we save all options
  saveoptions
    
elseif command==3					%font list has been changed
  %
  %First we extract the font list from the uicontrol
  %
  QmatNMR.handles = get(QmatNMR.leginp4, 'userdata');
  QTEMP1 = get(QmatNMR.handles(1), 'String');
  QTEMP2 = [0 sort([findstr(QTEMP1, ',') findstr(QTEMP1, '.') findstr(QTEMP1, ':') findstr(QTEMP1, ';') findstr(QTEMP1, '|') ]) length(QTEMP1)+1];
  QTEMP3 = [];
  for QTEMP40=1:(length(QTEMP2)-1)
    QTEMP4 = QTEMP1((QTEMP2(QTEMP40)+1):(QTEMP2(QTEMP40+1)-1));
    if ~ isempty(QTEMP4)
      if isempty(QTEMP3)
        QTEMP3 = QTEMP4;
      else
        QTEMP3 = str2mat(QTEMP3, QTEMP4);
      end
    end  
  end
  if ~isempty(QTEMP3)
    QmatNMR.FontList = lower(QTEMP3);

  else				%empty string --> we do not allow this and return the old list
    QTEMP1 = '';					%now we make QmatNMR.FontList into a linear string so we can put it in the
    for QTEMP40=1:size(QmatNMR.FontList, 1)			%edit button for the user to see.
      QTEMP1 = [QTEMP1 sprintf('%s,', deblank(QmatNMR.FontList(QTEMP40, :)))];
    end
  
    QmatNMR.handles = get(QmatNMR.leginp4, 'userdata');		%finally we put the string in the edit button
    set(QmatNMR.handles(1), 'String', QTEMP1);
    disp('matNMR WARNING: new font list empty. Previous list restored.');    
  end
  
  
  %
  %the new font list may not contain the current font. This must be checked and if so 
  %the first entry from the font list will be selected as current font
  %
  QTEMP1 = 0;
  for teller=1:size(QmatNMR.FontList, 1)
    if strcmp(deblank(QmatNMR.FontList(teller, :)), QmatNMR.TextFont);
      QTEMP1 = 1;
      break
    end
  end  
  if ~QTEMP1
    disp('matNMR WARNING: The new font list does not contain the current font name.');
    disp('matNMR WARNING: Therefore the first entry from the list will be made the current font.');

    QmatNMR.TextFont = deblank(QmatNMR.FontList(1, :));
    disp(['Current font set to "' QmatNMR.TextFont '"']);
  end

    
elseif command==4					%read in all system fonts as given by listfonts.m
  QmatNMR.FontList = char(listfonts);			%this gives a character array with all the system fonts.
  
  QTEMP1 = '';					%now we make this into a linear string so we can put it in the
  for QTEMP40=1:size(QmatNMR.FontList, 1)			%edit button for the user to see.
    QTEMP1 = [QTEMP1 sprintf('%s,', deblank(QmatNMR.FontList(QTEMP40, :)))];
  end

  QmatNMR.handles = get(QmatNMR.leginp4, 'userdata');		%finally we put the string in the edit button
  set(QmatNMR.handles(1), 'String', QTEMP1);
end
