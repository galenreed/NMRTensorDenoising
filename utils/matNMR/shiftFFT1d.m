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
%shiftFFT1d.m performs a FFT shift on the current 1d spectrum
%NOTE: as the fftshift command on a matrix is completely
%	different than for a vector this is done by using a for loop.
%20-03-'98
%14-12-'00

try
  watch
  
  if (QmatNMR.SwitchTo1D) 		%switch from 2D to 1D processing if necessary
    SwitchTo1D
  end
  
  %
  %create entry in the undo matrix
  %
  regelUNDO
  
  if (rem(QmatNMR.Size1D, 2)==1)	%issue warning message if the spectrum is of odd length
    disp('matNMR WARNING: spectrum size is of odd length. Multiple FFTshift''s will change peak positions!')
  end  
    
  QmatNMR.Spec1D = fftshift(QmatNMR.Spec1D);
  Qspcrel
  CheckAxis
  repair
  
  QmatNMR.History = str2mat(QmatNMR.History, 'FFT shift');
  
  %first add dimension-specific information, and then the current command
  QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
  QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 6);	%code for FFT shift 1D
  
  if QmatNMR.RecordingMacro
    %first add dimension-specific information, and then the current command
    QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
    QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 6);	%code for FFT shift 1D
  end
  
  if (~QmatNMR.BusyWithMacro)
    simpelplot;
    resetXaxis;		%reset the x-limits
    Arrowhead
  end
      
  disp('Finished performing fftshift on 1D spectrum ...');

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
