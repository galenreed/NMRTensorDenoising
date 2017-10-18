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
%asksavetoBrukerSpectrum.m asks for a file name for the current 1D or 2D spectrum
%
%26-11-'08


try
  %
  %Check size of spectrum for being a power of 2
  %
  if ( (log2(QmatNMR.SizeTD1) ~= round(log2(QmatNMR.SizeTD1))) | (log2(QmatNMR.SizeTD2) ~= round(log2(QmatNMR.SizeTD2))) )
    beep
    disp('matNMR NOTICE: Bruker data must be sized as powers of 2. Aborting export ...');
    return
  end
  
  
  %
  %give notice for axis vector
  %
  beep
  disp('matNMR NOTICE: this routine assumes that the current axis is in ppm!');
  
  
  %
  %get input
  %
  if (QmatNMR.Dim == 0)
    QuiInput('Save current 1D spectrum as Bruker spectrum :', ' OK | CANCEL', 'regelsavetoBrukerSpectrum', [], ... 
           'Name dataset :', QmatNMR.BrukerSpectrumName, ...
  	 'Path :', pwd, ...
           'Nucleus (e.g. 1H or 13C) :', QmatNMR.NucleusTD2);
  
  else  
    QuiInput('Save current 2D spectrum as Bruker spectrum :', ' OK | CANCEL', 'regelsavetoBrukerSpectrum', [], ... 
           'Name dataset :', QmatNMR.BrukerSpectrumName, ...
  	 'Path :', pwd, ...
           'Nucleus TD2 (e.g. 1H or 13C) :', QmatNMR.NucleusTD2, ...
           'Nucleus TD1 (e.g. 1H or 13C) :', QmatNMR.NucleusTD1);
  end

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
