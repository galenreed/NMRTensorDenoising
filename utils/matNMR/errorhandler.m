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
%errorhandler.m handles any error message occuring unexpectedly whilst running matNMR.
%A popup window will appear asking the user to send a bug report
%29-09-2009

if ~isempty(lasterr)
  QTEMP  = version;
  QTEMP2 = findstr(QTEMP, '.');
  QTEMP3 = str2num(QTEMP(1:QTEMP2(2)-1));
  %
  %Now we convert the version to a number that can be sorted
  %
  QTEMP4 = num2str(QTEMP3);
  QTEMP5 = findstr(QTEMP4, '.');
  QTEMP3 = 100*floor(QTEMP3) + str2num(QTEMP4((1+QTEMP5):end));

  if (QTEMP3 < 705)
    %
    %Before Matlab 7.5 the error handling was essentially useless and it was much nicer to see the
    %full error message produced by Matlab in the console window. The full error message will therefore
    %be produced at the end of the routine after the popup window has been generated.
    %
    QmatNMR.ME = lasterror;
    disp(' ');
    disp(' ');
    disp('matNMR ERROR:');
    disp(' ');
    disp(QmatNMR.ME.message);
    disp(QmatNMR.ME.identifier);
    disp(' ');
    disp(' ');
  
  else
    %
    %From Matlab 7.5 the error handling is much nicer and we have much more information to work with
    %
    QmatNMR.ME = lasterror;
    disp(' ');
    disp(' ');
    disp('matNMR ERROR:');
    disp(' ');
    disp(QmatNMR.ME.message);
    disp(QmatNMR.ME.identifier);
    for QTEMP1 = 1:length(QmatNMR.ME.stack)
      fprintf(1, 'In:  "%s"  on line %d\n', QmatNMR.ME.stack(QTEMP1).file, QmatNMR.ME.stack(QTEMP1).line);
    end
    disp(' ');
    disp(' ');
  end
  beep

  
  %
  %Create popup window with a message to the user
  %
  QuiInput(['An unexpected error has occured!' char(10) char(10) ...
            'If this is a persistent problem then' char(10) 'please send an e-mail to:' char(10) char(10) '        jabe@users.sourceforge.net' char(10) char(10) ...
            'with the output shown in the console window' char(10) 'and a description of your actions.'], 'Continue', '');
  waitforbuttonpress
  

  %
  %clear the lasterr buffer to prevent multiple popups of the error window
  %
  lasterr('');

  
  if (QmatNMR.MatlabVersion < 705)
    %
    %Before Matlab 7.5 the error handling was essentially useless and it was much nicer to see the
    %full error message produced by Matlab in the console window. Hence we rethrow the error such that
    %we see where exactly the problem lies
    %
    rethrow(lasterror)
  end
  
  clear QTEMP*
end
