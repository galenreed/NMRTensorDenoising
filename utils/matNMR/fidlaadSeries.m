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
%
%
% matNMR v. 3.9.0 - A processing toolbox for NMR/EPR under MATLAB
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
%fidlaadSeries.m calls a routine with which binary FID files can be read from disk
%and then switches back to askfidlaadSeries.m
%06-11-'01

try
  QmatNMR.Xfilename = 0;
  QmatNMR.Xtext = '';
  
  if (QmatNMR.ReuseLastDirectory)
    [QTEMP1, QTEMP2] = uigetfile([QmatNMR.Xpath filesep QmatNMR.SearchProfile], 'Select Binary File to Open');
  else
    [QTEMP1, QTEMP2] = uigetfile([pwd filesep QmatNMR.SearchProfile], 'Select Binary File to Open');
  end
  
  if (~isequal(QTEMP1, 0) & ~isequal(QTEMP2, 0))
    QmatNMR.Xfilename = QTEMP1;
    QmatNMR.Xpath = QTEMP2;
  end
  
  
  %
  %try and spot the data format. Only change the current setting if we're really sure about it
  %
  if ~isempty(dir([QmatNMR.Xpath 'acqu'])) & ~isempty(dir([QmatNMR.Xpath 'acqus'])) & ~isempty(dir([QmatNMR.Xpath 'pdata']))
    QmatNMR.DataFormat = 1;           %Bruker XWinNMR/TopSpin format
  
  elseif ~isempty(dir([QmatNMR.Xpath 'data'])) & ~isempty(dir([QmatNMR.Xpath 'acq'])) & ~isempty(dir([QmatNMR.Xpath 'acq_2']))
    QmatNMR.DataFormat = 2;           %Chemagnetics/Varian Spinsight format
  
  elseif ~isempty(dir([QmatNMR.Xpath '*fid'])) & ~isempty(dir([QmatNMR.Xpath 'procpar'])) & ~isempty(dir([QmatNMR.Xpath 'text']))
    QmatNMR.DataFormat = 5;           %Varian VNMRJ format
  
  elseif ~isempty(dir([QmatNMR.Xpath '*.tnt']))
    QmatNMR.DataFormat = 7;           %TecMag NTNMR format
  
  elseif ~isempty(dir([QmatNMR.Xpath '*.bin'])) & ~isempty(dir([QmatNMR.Xpath '*.hdr']))
    QmatNMR.DataFormat = 9;           %JEOL generic format
  
  elseif ~isempty(dir([QmatNMR.Xpath 'd'])) & ~isempty(dir([QmatNMR.Xpath 'pb']))
    QmatNMR.DataFormat = 11;           %Chemagnetics CMXW format
  end
  
  
  %
  %open the input window
  %
  if (~ (QmatNMR.Xfilename == 0))
    askfidlaadSeries
  end

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
