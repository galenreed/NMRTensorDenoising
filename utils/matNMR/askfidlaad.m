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
%askfidlaad.m opens an input window to get information about the binary FID that needs to be
%read into MATLAB
%18-03-'99


try
  if (QmatNMR.Xfilename == 0)			%first check whether a previous filename exists
    fidlaad				%if not, go to the normal "binary FID" mode
    
  else  					%skip searching for file and go directly to the input window
    QmatNMR.Xtext = [QmatNMR.Xpath QmatNMR.Xfilename];
    if findstr(QmatNMR.Xtext, '$#$')		%detect the $#$ sequence from a previous loading of a series of FIDs
      QmatNMR.Xtext = strrep(QmatNMR.Xtext, '$#$', num2str(QmatNMR.FIDRangeIn(1)));
    end
    QmatNMR.Xsize = dir(QmatNMR.Xtext);
        
    if ~isempty(QmatNMR.Xsize)
      QTEMP1 = num2str(QmatNMR.Xsize.bytes/4, 7);
    else
      QTEMP1 = 'NOT FOUND';
    end
  
  
    %
    %open the input window
    %
    QuiInput('Read Binary FID files from disk :', 'OK | CANCEL', 'regelQfidread', [], ...
             'Name of file : &CAregelinputbuttonsfidlaadSeries4', QmatNMR.Xtext, ...
             ['Size in T2 (total number of points = ' QTEMP1 ') : '], QmatNMR.size1last(1), ...
             'Size in T1 (points) : ', QmatNMR.size2last, ...
             'Name in Workspace : ', QmatNMR.namelast, ...
             '&POFile Format : | XWinNMR/TopSpin (Bruker) | Spinsight (Chemagnetics) | winNMR (Bruker) | UXNMR (Bruker) | VNMR (Varian) | MacNMR 5.0 (TecMag) | NTNMR (TecMag) | Bruker Aspect 2000/3000 | JEOL Generic Format (.bin) | SMIS (.mrd) | CMXW (fid?d) | Generic 1 &CAregelinputbuttonsfidlaad', QmatNMR.DataFormat, ...
             '&CKRead standard parameter files? &CAregelinputbuttonsfidlaad', QmatNMR.ReadParameterFilesFlag, ...
             '&CKLoad into matNMR directly?', QmatNMR.LoadINTOmatNMRDirectly);
  
    regelinputbuttonsfidlaad		%update the buttons according to the selected file format
  end  
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
