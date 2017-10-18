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
%regellb.m takes care of the choices possible for apodization ...

try
  QTEMP20 = get(QmatNMR.h75, 'value');
  repair
  
  switch QTEMP20
    case 1
      repairapodize;
      removecurrentline
      QmatNMR.lbstatus = 0;		%flag for no line broadening
      historyapodize
      Qspcrel;
      CheckAxis;					%checks whether the axis is ascending or descending and adjusts the
  						%plot direction if necessary
      simpelplot;
    
    case 2		%exponential
      QmatNMR.lbTempstatus = 50;
      QuiInput('Apodization functions :  Exponential', ' OK | CANCEL', 'apodize1d', [], 'Line broadening factor (in Hz) :', QmatNMR.lb);
  
    case 3		%cos^2
      QmatNMR.lbTempstatus = -99;
      QuiInput('Apodization functions :  Cos^2', ' OK | CANCEL', 'apodize1d', [], 'Phase factor (0=cos, 1=sin) :', QmatNMR.PhaseFactor, 'Span (1=zero at end of FID) :', QmatNMR.Cos2Span);
  
    case 4		%Gaussian
      QmatNMR.lbTempstatus = 10;
      QuiInput('Apodization functions :  Gaussian', ' OK | CANCEL', 'apodize1d', [], 'Exp. Broadening factor (in Hz and negative) :', QmatNMR.lb, 'Gaussian broadening factor (in Hz) :', QmatNMR.gb);
  
    case 5		%Hamming
      QmatNMR.lbTempstatus = -30;
      QuiInput('Apodization functions :  Hamming', ' OK | CANCEL', 'apodize1d', [], 'Phase factor (0=cos, 1=sin) :', QmatNMR.PhaseFactor);
  
    case 6		%shifting Gaussian (T1-dependant)
      if ((QmatNMR.Dim == 0) | (QmatNMR.Dim == 2))
        disp('matNMR WARNING:  The TD 1 shifting Gaussian apodization only works for the T2 domain of 2D spectra !');
      else  
        QmatNMR.lbTempstatus = 100;
        QuiInput('Apodization functions :  Shifting Gaussian', ' OK | CANCEL', 'apodize1d', [], ...
    	  'Moving Line Broadening factor (in Hz) :', QmatNMR.gb, ...
      	  'Sweepwidth TD 2 :', QmatNMR.SWTD2, ...
  	  'Sweepwidth TD 1 :', QmatNMR.SWTD1, ...
  	  'Shearing Factor :', QmatNMR.ShearingFactor, ...
  	  'Position of the echo maximum :', QmatNMR.EchoMaximum, ...
  	  '&PODirection of the shift in time:|Positive|Negative', QmatNMR.ShiftDirection+1);
      end
    
    case 7		%Exponential for full echo processing
      QmatNMR.lbTempstatus = 501;
      QuiInput('Apodization functions :  Exponential for full echo''s', ' OK | CANCEL', 'apodize1d', [], 'Line broadening factor (in Hz) :', QmatNMR.lb);
  
    
    case 8		%Gaussian for full echo processing
      QmatNMR.lbTempstatus = 101;
      QuiInput('Apodization functions :  Gaussian for full echo''s', ' OK | CANCEL', 'apodize1d', [], 'Line Broadening factor (in Hz and negative) :', QmatNMR.lb, 'Gaussian broadening factor (in Hz) :', QmatNMR.gb);
  
  
    case 9		%shifting Gaussian (T1-dependant) for echo's
      if ((QmatNMR.Dim == 0) | (QmatNMR.Dim == 2))
        disp('matNMR WARNING:  The TD 1 shifting Gaussian apodization only works for the T2 domain of 2D spectra !');
      else
        QmatNMR.lbTempstatus = 1001;
        QuiInput('Apodization functions :  Shifting Gaussian', ' OK | CANCEL', 'apodize1d', [], ...
    	  'Moving Line Broadening factor (in Hz) :', QmatNMR.gb, ...
    	  'Sweepwidth TD 2 :', QmatNMR.SWTD2, ...
  	  'Sweepwidth TD 1 :', QmatNMR.SWTD1, ...
  	  'Shearing Factor :', QmatNMR.ShearingFactor, ...
  	  'Pos. echo max. (= 0 after a "swap whole echo"!!):', QmatNMR.EchoMaximum);
      end
  
    otherwise
      error('matNMR ERROR: Unknown code for apodization!');
    
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
