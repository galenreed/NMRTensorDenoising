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
%askimportGENERIC.m opens an input window to get information about the binary data that needs to be
%read into MATLAB
%07-05-2010


try
  if (QmatNMR.Xfilename == 0)			%first check whether a previous filename exists
    importGENERIC				%if not, go to the normal "binary FID" mode
    
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
    QuiInput('Read binary data files from disk :', 'OK | CANCEL', 'regelimportGENERIC', [], ...
             'Filename :  &CAregelinputbuttonsGENERICSeries3', QmatNMR.Xtext, ...
             'Name in Workspace : ', QmatNMR.namelast, ...
             'Size in T2 (real+imag points): ', QmatNMR.size1last(1), ...
             'Size in T1 (points) : ', QmatNMR.size2last, ...
             '&POByte ordering : | little endian | big endian | VAX D | VAX G | Cray | IEEE-le.l64 | IEEE-be.l64 ', QmatNMR.GENERICByteOrdering, ...
             '&POData format : | float32 | float64 | single | double | int8 | int16 | int32 | int64 | uint8 | uint16 | uint32 | uint64 | uchar | schar', QmatNMR.GENERICDataFormat, ...
             'Header size (bytes) : ', QmatNMR.GENERICHeaderBytes1, ...
             'Header size for each T1 (bytes) : ', QmatNMR.GENERICHeaderBytes2, ...
             '&POData ordering : | complex (RI RI RI) | complex (RRR III) | only real', QmatNMR.GENERICDataOrdering, ...
             '&CKLoad into matNMR directly?', QmatNMR.LoadINTOmatNMRDirectly);
  end  
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
