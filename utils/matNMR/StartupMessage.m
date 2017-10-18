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
%StartupMessage creates a text which is shown at startup of matNMR
%29-10-'03

try
  QTEMP1 = [];
  QTEMP2 = [];
  QTEMP3 = [];
  
  %title, centered
  QTEMP1 = [QTEMP1 text(0.50, 1.00, 'Welcome to matNMR')];
  QTEMP1 = [QTEMP1 text(0.50, 0.26, 'Is your version of matNMR up to date?')];
  QTEMP1 = [QTEMP1 text(0.50, 0.10, 'Download the latest version now at matnmr.sourceforge.net')];
  
  %normal text, aligned left
  QTEMP2 = [QTEMP2 text(0.05, 0.85, 'The most important changes in recent versions :')];
  QTEMP2 = [QTEMP2 text(0.05, 0.75, '        -File import menus are simplified BUT manipulating series is implemented differently!')];
  QTEMP2 = [QTEMP2 text(0.05, 0.67, '        -Macro''s can now be converted into scripts (1D macros only, for now!)')];
  QTEMP2 = [QTEMP2 text(0.05, 0.59, '        -Legend now available inside the fitting routines')];
  QTEMP2 = [QTEMP2 text(0.05, 0.51, '        -A short tutorial for matNMR was added to the manual for novel users. See paragraph 4.1!')];
  QTEMP2 = [QTEMP2 text(0.05, 0.43, '        -matNMR is published! JMR 187 (2007), 19-26. Please adapt your citations!!')];
  QTEMP2 = [QTEMP2 text(0.05, 0.35, '        -Implemented fitting of CSA tensors from static spectra and from MAS sideband intensities')];
  
  %normal text, centered
  QTEMP3 = [QTEMP3 text(0.50, 0.18, QmatNMR.VersionVar)];
  
  
  %
  %Set font sizes and horizontal alignments
  %
  set(QTEMP1, 'horizontalalignment', 'center', 'fontunits', 'normalized', 'fontsize', 0.08, 'backgroundcolor', QmatNMR.ColorScheme.Text2Back, 'color', QmatNMR.ColorScheme.Text2Fore);
  set(QTEMP2, 'horizontalalignment', 'left',   'fontunits', 'normalized', 'fontsize', 0.05, 'backgroundcolor', QmatNMR.ColorScheme.Text1Back, 'color', QmatNMR.ColorScheme.Text1Fore);
  set(QTEMP3, 'horizontalalignment', 'center', 'fontunits', 'normalized', 'fontsize', 0.05, 'backgroundcolor', QmatNMR.ColorScheme.Text1Back, 'color', QmatNMR.ColorScheme.Text1Fore);
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
