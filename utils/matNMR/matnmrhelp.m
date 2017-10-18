function matnmrhelp(topic,pagetitle,helptitle,varargin)
%HELPWIN On-line help, separate window for navigation.
%   HELPWIN TOPIC opens a help window and displays the help text for the
%   given TOPIC.  Links are created to functions referenced in the 'See Also'
%   line of the help text.
%
%   matnmrhelp(HELP_STR,TITLE) displays the string HELP_STR in the help
%   window.  HELP_STR may be passed in as a string with each line separated
%   by carriage returns, a column vector cell array of strings with each cell
%   (row) representing a line or as a string matrix with each row representing
%   a line.  The optional string TITLE will appear in the title edit box.
%
%   matnmrhelp({TITLE1 HELP_STR1;TITLE2 HELP_STR2;...},PAGE) displays one page
%   of multi-page help text.  The multi-page help text is passed in as a
%   cell array of strings or cells containing TITLE and HELP_STR pairs.
%   Each row of the multi-page help text cell array (dimensioned number of
%   pages by 2) consists of a title string paired with a string, cell array
%   or string matrix of help text.  The second argument PAGE is a string 
%   which must match one of the TITLE entries in the multi-page help text.
%   The matching TITLE represents the page that is to be displayed first.
%   If no second argument is given, the first page is displayed.
%
%   A third argument may be passed to HELPWIN which is a string that becomes
%   the title of the help window figure.
%
%   Additional arguments, after the window title, will be interpreted as
%   Handle Graphics parameter-value pairs to be applied to the text displayed
%   in the help window.
%
%   Examples.
%             helpwin plot
%             matnmrhelp('Help String','title')
%             matnmrhelp(['Help text for' sprintf('\n') 'my m-file.'],'title')
%             matnmrhelp({'Help String for';'my m-file'},'title')
%             matnmrhelp(str,'Topic 2','My Title')
%               where,
%               str =  { 'Topic 1' 'Help string for Topic 1';
%                        'Topic 2' 'Help string for Topic 2';
%                        'Topic 3' 'Help string for Topic 3' }
%
%   See also DOC, DOCOPT, HELP, WEB.

%   Copyright (c) 1984-96 by The MathWorks, Inc.
%   $Revision: 1.26 $


%
% adapted for matNMR by
% Jacco van Beek
% 08-08-'97
%
global QmatNMR

% If no arguments are given, load up the Home help page.
if nargin==0
   topic = 'HelpwinHome';
end

% Switchyard on 'topic'.  It is either a command or a help entry.
if iscell(topic), 
   cmd = char(topic(1,1));
else
   cmd = char(topic(1,:));
end

switch cmd

%-----------------------------------------------------------------------
case 'HelpwinPage'
   % This case is used to link a page to others pages in the text entry.
   TopicPop = gco;
   val = get(TopicPop,'value');
   if val~=1
      refstr = get(TopicPop,'string');
      ref = deblank(refstr{val});
      topic = get(TopicPop,'userdata');
      matnmrhelp(topic,ref);
   end

%-----------------------------------------------------------------------
case 'HelpwinSeealso'
   % This case is used to link a page to others referenced in the
   % See Also text.
   SeeAlsoPop = gco;
   val = get(SeeAlsoPop,'value');
   if val~=1
      set(SeeAlsoPop,'value',1);
      refstr = get(SeeAlsoPop,'string');
      ref = deblank(refstr{val});
      if length(ref) >= 5
         if strcmp(ref(1:5),'More ')
            ind = max(findstr(ref,' help'));
            if ~isempty(ind)
               doc(ref(6:ind-1));
            end
         else
            matnmrhelp(ref);
         end
      else
         matnmrhelp(ref);
      end
   end
   
%-----------------------------------------------------------------------
case 'HelpwinBack'
   % This case is used to go back one page in the stack.
   BackBtn = gco;
   fig = gcf;
   fud = get(fig,'UserData');
   pgtitle = get(findobj(gcf,'tag','CurHelpEdit'),'string');
   if pgtitle(1) == ' ', pgtitle(1) = []; end  % remove first char if space
   match = min(strmatch(pgtitle,{fud.pagetitle},'exact'));
   ref = fud(match+1);
   set(BackBtn,'UserData',1);  % set flag to indicate Back call
   matnmrhelp(ref.topic,ref.pagetitle,ref.helptitle);
   
%-----------------------------------------------------------------------
case 'HelpwinForward'
   % This case is used to go forward one page in the stack.
   fig = gcf;
   BackBtn = findobj(fig,'Tag','BackBtn');
   fud = get(fig,'UserData');
   pgtitle = get(findobj(gcf,'tag','CurHelpEdit'),'string');
   if pgtitle(1) == ' ', pgtitle(1) = []; end  % remove first char if space
   match = max(strmatch(pgtitle,{fud.pagetitle},'exact'));
   ref = fud(match-1);
   set(BackBtn,'UserData',1);  % set flag to indicate Back/Forw call to
   matnmrhelp(ref.topic,ref.pagetitle,ref.helptitle);
   
%-----------------------------------------------------------------------
case 'HelpwinHome'
   % This case is used to go to the Home help screen.
   matnmrhelp('about.hlp','matNMR Help Topics');
   
%-----------------------------------------------------------------------
case 'HelpwinOpen'
   % This case is used to open another link from a double-click in
   % the list box.

   % Determine whether this is a double click.
   fig = gcf;
   if strcmp(get(fig,'SelectionType'),'open')
      ListBox = findobj(fig,'Tag','ListBox');
      SeeAlsoPop = findobj(fig,'tag','SeeAlsoPop');

      ln = get(ListBox,'value');
      helpstr = get(ListBox,'string');      

      % Find the function link index or the See Also index.
      hstr = helpstr';
      hstr = lower(hstr(:)');
      cols = size(helpstr,2);
      seealso = floor((findstr('see also',hstr)/cols) + 1);
      dash = floor((findstr(' - ',hstr)/cols) + 1);

      % If there is a 'See Also', follow the 'See also' index
      if ~isempty(seealso)
         if ln == seealso
            % Determine which item in the list is a the first in the 
            % 'See also' text list.
            poplist = get(SeeAlsoPop,'string');
            
            val = 3;			%altered for matNMR --> no more HTML help !
               
            matnmrhelp(poplist{val});  % gets first reference in 'See also' list.
            
         end
      end

      % If there are dashes follow the function link.
      if ~isempty(dash)
         if any(ln == dash)
            loc = min(findstr('-',helpstr(ln,:)));
            ref = deblank(helpstr(ln,1:loc-1));
            ind = min(find(isletter(ref)));
            ref = ref(ind:end);
            % Process a 'Readme' tag.
            if strcmp(ref,'Readme')
               CurHelpEdit = findobj(fig,'Tag','CurHelpEdit');
               pre = deblank(get(CurHelpEdit,'string'));
               if (pre(1)==' '), pre(1) = []; end
               matnmrhelp([pre filesep ref]);
            % Else, just follow the link.   
            else
               matnmrhelp(ref);
            end
         end
      end

   end

%-----------------------------------------------------------------------
case 'HelpwinHelpDesk'
   % This case is used to link HTML-based documentaion.
   doc;   
   
%-----------------------------------------------------------------------
case 'HelpwinMoreHelp'
   % This case is used to link HTML-based documentaion.
   nexttopic = get(findobj(gcf,'tag','CurHelpEdit'),'string');
   if nexttopic(1) == ' ', nexttopic(1) = []; end  % remove first char if space
   doc(nexttopic);

%-----------------------------------------------------------------------
otherwise

   % Try to find the figure.  Note the awkward spelling of the tag to prevent
   % others from accidentally grabing this hidden figure.
   fig = findobj(allchild(0),'tag','MatNMRHelpFigure');
   CR = sprintf('\n');

   % Determine if the input consists of a cell array or paged help text.
   topic_is_cell = iscell(topic);
   multi_page_text = topic_is_cell & (size(topic,2) > 1);
   
   % Strip off the first character if it is a space.  The space is inserted
   % on purpose for better display in the edit box.
   if ~topic_is_cell & size(topic,1) == 1 & topic(1)==' ' , topic(1) = []; end

   % Create the figure if it doesn't exist.
   if isempty(fig),
      % Get a good font and figure size for this platform.
      [fname,fsize] = goodfonts;
      
      % Create the figure.
      fig = figure( ...
         'Visible','off', ...
         'HandleVisibility','callback', ...
         'MenuBar','none', ...
         'Name','matNMR Help Window', ...
         'Color', [0.7 0.7 0.7], ...
         'NumberTitle','off', ...
         'IntegerHandle','off', ...
         'Units','normalized', ...
	 'position', [0.1311    0.4322    0.7370    0.4667],...
         'Tag','MatNMRHelpFigure');

  %
  %To work around a Matlab bug (see BugFixes.txt, 11-05-'04) we redefine the position and units.
  %
  set(fig, 'units', 'normalized', 'position', [0.1311    0.4322    0.7370    0.4667]);
            
      % Create the rest of the UIs.
      ListBox = uicontrol('Parent',fig, ...
         'CallBack','matnmrhelp(''HelpwinOpen'');', ...
         'FontName',fname, ...
         'FontSize',fsize, ...
         'Max',2, ...
         'Units','normalized', ...
         'Position',[0 0 1 0.8482], ...
         'String',' ', ...
         'Style','listbox', ...
         'Tag','ListBox', ...
         'BackgroundColor', QmatNMR.ColorScheme.Button12Back, ...
         'ForegroundColor', QmatNMR.ColorScheme.Button12Fore, ...
         'Value',[]);
      CurHelpEdit = uicontrol('Parent',fig, ...
         'BackgroundColor',[1 1 1], ...
         'Units','normalized', ...
         'Position',[.0111 .9297 .4283 .0590], ...
         'Style','edit', ...
         'HorizontalAlignment','left', ...
         'Tag','CurHelpEdit', ...
         'Callback','matnmrhelp(get(gco,''string''));');
      SeeAlsoPop = uicontrol('Parent',fig, ...
         'BackgroundColor',[1 1 1], ...
         'CallBack','matnmrhelp(''HelpwinSeealso'');', ...
         'Min',1, ...
         'Units','normalized', ...
         'Position',[.4505 .9297 .1780 .0590], ...
         'String','See also', ...
         'Style','popupmenu', ...
         'HorizontalAlignment','left', ...
         'Tag','SeeAlsoPop', ...
         'Value',1);
      HomeBtn = uicontrol('Parent',fig, ...
         'CallBack','matnmrhelp(''HelpwinHome'');', ...
         'Units','normalized', ...
         'Position',[.2002 .8595 .0834 .0590], ...
         'String','Home', ...
         'BackgroundColor', QmatNMR.ColorScheme.Button5Back, ...
         'ForegroundColor', QmatNMR.ColorScheme.Button5Fore, ...
         'Tag','HomeBtn');
      BackBtn = uicontrol('Parent',fig, ...
         'CallBack','matnmrhelp(''HelpwinBack'');', ...
         'Units','normalized', ...
         'Position',[.0111 .8595 .0834 .0590], ...
         'String','Back', ...
         'UserData',0, ...
         'BackgroundColor', QmatNMR.ColorScheme.Button4Back, ...
         'ForegroundColor', QmatNMR.ColorScheme.Button4Fore, ...
         'Tag','BackBtn');
      ForwardBtn = uicontrol('Parent',fig, ...
         'CallBack','matnmrhelp(''HelpwinForward'');', ...
         'Units','normalized', ...
         'Position',[.1057 .8595 .0834 .0590], ...
         'String','Forward', ...
         'BackgroundColor', QmatNMR.ColorScheme.Button4Back, ...
         'ForegroundColor', QmatNMR.ColorScheme.Button4Fore, ...
         'Tag','ForwardBtn');
      PrintBtn = uicontrol('Parent',fig, ...
         'CallBack','mathelpprint', ...
         'Units','normalized', ...
         'Position',[.2948 .8595 .1669 .0590], ...
         'String','Print', ...
         'BackgroundColor', QmatNMR.ColorScheme.Button5Back, ...
         'ForegroundColor', QmatNMR.ColorScheme.Button5Fore, ...
         'Tag','PrintBtn');
      CloseBtn = uicontrol('Parent',fig, ...
         'CallBack','delete(gcf)', ...
         'Units','normalized', ...
         'Position',[.8220 .8595 .1669 .0590], ...
         'String','Close', ...
         'BackgroundColor', QmatNMR.ColorScheme.Button3Back, ...
         'ForegroundColor', QmatNMR.ColorScheme.Button3Fore, ...
         'Tag','CloseBtn');
      
      % Set 'Busy Action, QmatNMR.ueue' and 'Interruptible, Off' on all objects.
      set(findobj(fig),'BusyAction','queue','Interruptible','off');

   else
      figure(fig);
      ListBox = findobj(fig,'tag','ListBox');
      CurHelpEdit = findobj(fig,'tag','CurHelpEdit');
      SeeAlsoPop = findobj(fig,'tag','SeeAlsoPop');
      HomeBtn = findobj(fig,'tag','HomeBtn');
      BackBtn = findobj(fig,'tag','BackBtn');
      ForwardBtn = findobj(fig,'tag','ForwardBtn');

   end
   
   % Turn on figure visiblity.
   set(fig,'visible','on');

   % Create Page popup if not necessary and non-existent.  Otherwise, simply
   % load up the help string with the help text for the requested topic.
   if multi_page_text
      % Get the help text for the requested topic from the cell array.
      if nargin < 2
         pagetitle = topic{1,1};
      elseif isempty(pagetitle)
         pagetitle = topic{1,1};
      end
      ind = strmatch(pagetitle,topic(:,1),'exact');
      if isempty(ind), ind = 1; end

      helpstr = char(topic{ind,2});
      slash_n = find(helpstr==CR);
      if slash_n
         % Replace pipes with '!' for display if necessary,
         % replace the carriage returns in the help string with pipes
         % so that the list box can correctly interpret them.
         % Add one extra line to top of display.  
         helpstr(find(helpstr == '|')) = '!';
         helpstr(slash_n) = '|';
         helpstr = ['|' helpstr];
      else
         % Add one extra line to top of display.  
         helpstr = str2mat('',helpstr);
      end

      % Set the popup string.
      ref = [{'Topics'}; topic(:,1)];
      if length(ref) < 2
         set(SeeAlsoPop,'string',ref,...
             'enable','off');
      else
         set(SeeAlsoPop,'string',ref, ...
             'callback','matnmrhelp(''HelpwinPage'');', ...
             'enable','on',...
             'value',1,...
             'userdata',topic);
      end

      % Set the current topic.
      pgtitle = topic{ind,1};
      
   elseif (iscell(topic) | any(find(topic==32)) | ...
           size(topic,1) > 1 | any(find(topic==CR)))
      helpstr = char(topic);
      slash_n = find(helpstr==CR);
      if slash_n
         % Replace pipes with '!' for display if necessary,
         % replace the carriage returns in the help string with pipes
         % so that the list box can correctly interpret them.
         % Add one extra line to top of display.  
         helpstr(find(helpstr == '|')) = '!';
         helpstr(slash_n) = '|';
         helpstr = ['|' helpstr];
      else
         % Add one extra line to top of display.  
         helpstr = str2mat('',helpstr);
      end

      if nargin < 2
         pgtitle = 'matNMR Help';
      else
         if isempty(pagetitle)
            pgtitle = 'matNMR Help';
         else
            pgtitle = pagetitle;
         end
      end
      
   else
      % Get the help text for the requested topic.
      helpstr = help(topic);
      slash_n = 1;
      pgtitle = topic;

      % Error handling.  If topic not found, send an error message to the window.
      if isempty(helpstr)
         helpstr = [CR ' Topic ''' pgtitle ''' was not found.'];
      end

      % Replace pipes with '!' for display if necessary,
      % replace the carriage returns in the help string with pipes
      % so that the list box can correctly interpret them.
      % Add one extra line to top of display.  
      helpstr(find(helpstr == '|')) = '!';
      helpstr(find(helpstr==CR)) = '|';
      helpstr = ['|' helpstr];
         
   end
      
   % Store the arguments in the userdata of the figure.  This is a stack
   % which enables the Back button to work for the last few selections.
   fud = get(fig,'UserData');
   curArg = struct('topic',{[]},'pagetitle',{[]},'helptitle',{[]});
   curArg.topic = topic;
   curArg.pagetitle = pgtitle;
   if nargin >= 3
      curArg.helptitle = helptitle;
   end
   if isempty(fud)
      fud = curArg;  % protects for first time through code.
   else
      backflag = get(BackBtn,'UserData');  % flag to indicate that Back/Forw button was
      if backflag == 0                     % pressed.
         str = get(CurHelpEdit,'string');
         if str(1) == ' ', str(1) = []; end;  % remove first char is space
         match = strmatch(str,{fud.pagetitle},'exact');
         if ~isempty(match)
            fud(1:match-1) = [];     % eliminate the items 'above' the selected items
         end
         fud = [curArg fud];
         if length(fud) >= 7         % limits stack to 6 elements
            fud(7) = [];             % or 5 Back button presses
         end
      else
         set(BackBtn,'UserData',0);  % clear backflag
      end
   end
   set(fig,'UserData',fud);

   % Check to see whether the Back and Forward buttons should be disabled.
   match = strmatch(pgtitle,{fud.pagetitle},'exact');
   if match == length(fud)
      set(BackBtn,'enable','off');
   else
      set(BackBtn,'enable','on');
   end
   if match == 1
      set(ForwardBtn,'enable','off');
   else
      set(ForwardBtn,'enable','on');
   end
   
   % Replace all tabs with single spaces.
   helpstr(find(helpstr==9)) = ' ';
   
   % Set the listbox string to the help string and set the topic name in the
   % edit box.
   set(CurHelpEdit,'string',[' ' pgtitle]);  % extra space for better display.
   set(ListBox,'value',[],'string',helpstr,'ListBoxTop',1);
   
   if any(slash_n) & ~multi_page_text
      % Set up the string for the See Also pop-up
      cnt=1;
      ref={'See also'};
      if ~(any(find(pgtitle==filesep)) | ...
           any(find(pgtitle=='/')) | ...
           any(find(pgtitle(2:end)==' ')))
         ref = {'See also' [pgtitle]};
         cnt = cnt + 1;
      end
      
      % Enable links to the related topics found after the 'See Also'.
      seealso=max(findstr(helpstr,'See also'));  % Finds LAST 'See Also'.
      overind = max(findstr(helpstr,'| Overloaded methods'));
      if ~isempty(seealso)
         p=seealso+8;
         				%
         				%For matNMR:
         				%Originally helpwin.m did not recognise periods for links
         				%and this was necessary for matNMR. So the function isdot
         				%makes sure periods (".") are also taken into account !
         				%
         lmask=[zeros(1,p-1) (isletter(helpstr(p:end))+isdot(helpstr(p:end)))];
         umask=helpstr==upper(helpstr);
         undmask=helpstr=='_';
         nmask = [zeros(1,p-1) ...
               ((helpstr(p:end) >= '0') & (helpstr(p:end) <= '9'))];
         rmask=lmask&umask | undmask | nmask;
         ln=length(helpstr);
         if ~isempty(overind), ln=overind-1; end
         while 1
            q=p;
            while ~rmask(p) & p<ln
               p=p+1;
            end
            q=p+1;
            if q>=ln, break; end
            while rmask(q)
               q=q+1;
            end
            cnt=cnt+1;
            if q>p+1,  % Protects against single letter references.
               ref{cnt}=lower(helpstr(p:q-1));
            end
            p=q;
         end
      end
   
      % Enable link to overloaded methods.
      if ~isempty(overind)
         ln = length(helpstr);
         eol = find(helpstr(overind+1:ln)=='|');
         p = findstr(helpstr(overind:ln),'help ');
         for i=1:length(p)
            cnt = cnt + 1;
            ref{cnt} = helpstr(overind+p(i)+4:overind+eol(i+1)-1);
         end
         
      end
   
      % Set the See Also popup values.
      set(SeeAlsoPop,'value',1);
      if size(ref,2) < 2
         set(SeeAlsoPop,'string',ref,...
             'enable','off');
      else
         set(SeeAlsoPop,'string',ref, ...
             'callback','matnmrhelp(''HelpwinSeealso'');', ...
             'enable','on');
      end

   elseif ~multi_page_text 
      set(SeeAlsoPop,'string',{'See also'},...
          'enable','off');

   end   

   % Set the figure title if supplied.
   if nargin >= 3
      if isempty(helptitle)
         set(fig,'Name','matNMR Help Window');
      else
         set(fig,'Name',helptitle);
      end
   else
      set(fig,'Name','matNMR Help Window');
   end

   % Set any HG properties that were passed in.
   if ~isempty(varargin)
      narg = length(varargin);
      set(ListBox,varargin(1:2:narg),varargin(2:2:narg))
   end

end

% Done.

%-----------------Function GOODFONTS-----------------
function [fname,fsize] = goodfonts
%       Returns a good font for a list box on this platform
%       and return the resulting figure width for an 80 column
%       display.

% fname - string
% fsize - points

global QmatNMR

fname = get(0, 'DefaultUIControlFontName');
fsize = QmatNMR.UIFontSize;
