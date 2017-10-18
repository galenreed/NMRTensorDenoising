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
%four1d performes the Fourier transformation for a 1D FID
%9-8-'96

try
  watch;
  
  if (QmatNMR.SwitchTo1D) 		%switch from 2D to 1D processing if necessary
    SwitchTo1D
  end
  
  
  %
  %What FT mode is requested?
  %
  QmatNMR.howFT = get(QmatNMR.Four, 'value');
  
  
  %
  %create entry in the undo matrix
  %
  regelUNDO
  
  
  %
  %Execute the FT
  %
  if (QmatNMR.InverseFTflag)	%do inverse FT
    if ((QmatNMR.howFT == 1) | (QmatNMR.howFT == 2) | (QmatNMR.howFT == 3) | (QmatNMR.howFT == 5) | (QmatNMR.howFT == 6))	%Complex FT, real FT, States, whole echo, States-TPPI
      QmatNMR.Spec1D = ifft(fftshift(QmatNMR.Spec1D), QmatNMR.Size1D);
  
    else
      disp('matNMR NOTICE: inverse FT not implemented for current FT mode. Aborting ...');
      return
    end
  
    if ((QmatNMR.fftstatus == 1) & (QmatNMR.howFT ~= 5))	%Divide first point by 0.5 if necessary (not for whole echo!)
      QmatNMR.Spec1D(1) = QmatNMR.Spec1D(1) / 0.5;
    end
    
    historyFT
    disp('Inverse Fourier transformation (1D) finished');
    
  
  else			%forward FT
    %
    %Multiply first point by 0.5 is requested
    %
    if ((QmatNMR.fftstatus == 1) & (QmatNMR.howFT ~= 5))	%Multiply first point with 0.5 if necessary (not for whole echo!)
      QmatNMR.Spec1D(1) = QmatNMR.Spec1D(1) * 0.5;
    end
    
    %
    %Execute requested FT
    %
    if ((QmatNMR.howFT == 1) | (QmatNMR.howFT == 5))	%Complex FT or whole echo
      QmatNMR.Spec1D = fftshift(fft(QmatNMR.Spec1D, QmatNMR.Size1D));
      historyFT
      disp('Complex Fourier transformation (1D) finished');
      
    elseif (QmatNMR.howFT == 2)	%Real FT
      QmatNMR.Spec1D = fftshift(fft(real(QmatNMR.Spec1D), QmatNMR.Size1D));
      historyFT
      disp('Real Fourier transformation (1D) finished');
      
    elseif QmatNMR.howFT == 4			%TPPI FT
      QmatNMR.Spec1D = fft(real(QmatNMR.Spec1D), 2*QmatNMR.Size1D);
      QmatNMR.Spec1D = QmatNMR.Spec1D(1:QmatNMR.Size1D);
      historyFT
      QmatNMR.SW1D = QmatNMR.SW1D/2;
      disp('TPPI Fourier transformation (1D) finished');
      
    elseif QmatNMR.howFT == 7			%Bruker qseq FT
      QTEMP = zeros(1, 2*QmatNMR.Size1D);		%the complex data vector first needs to be put into a real vector and then every
      QmatNMR.Spec1D(2:2:QmatNMR.Size1D) = -QmatNMR.Spec1D(2:2:QmatNMR.Size1D);%third and fourth point must be negated before doing a TPPI-like transformation
    									%as the vector is still complex the third and fourth points are in fact all even complex points!
      QTEMP(1:2:2*QmatNMR.Size1D) = real(QmatNMR.Spec1D);
      QTEMP(2:2:2*QmatNMR.Size1D) = imag(QmatNMR.Spec1D);
      QmatNMR.Spec1D = fft(real(QTEMP), 2*QmatNMR.Size1D);
      QmatNMR.Spec1D = QmatNMR.Spec1D(1:QmatNMR.Size1D);
      historyFT
      QmatNMR.SW1D = QmatNMR.SW1D/2;
      disp('Fourier transformation (1D) for Bruker qseq acquisition finished');
  
    elseif QmatNMR.howFT == 8 			%Sine FT
      %
      %in case of a Sine FT we perform a real FT + 90 degree phase shift and invert half of the spectrum
      %
      QmatNMR.Spec1D = fftshift(fft(real(QmatNMR.Spec1D), QmatNMR.Size1D));
      QmatNMR.Spec1D = -imag(QmatNMR.Spec1D) + sqrt(-1)*real(QmatNMR.Spec1D);
      QmatNMR.Spec1D(1:floor(QmatNMR.Size1D/2)) = -QmatNMR.Spec1D(1:floor(QmatNMR.Size1D/2));
      historyFT
  
    else					%States or States-TPPI wanted but is not possible for 1D !!
      QmatNMR.howFT = 1;	%revert to complex FFT
      QmatNMR.Spec1D = fftshift(fft(QmatNMR.Spec1D, QmatNMR.Size1D));
      historyFT
      disp('Complex Fourier transformation (1D) finished');
    end
  end
  
  
  %
  %Finish off
  %
  QmatNMR.lbstatus=0;				%reset linebroadening flag and button
  if (QmatNMR.InverseFTflag)	%do inverse FT
    QmatNMR.FIDstatus = 2;			%set correct plotting direction for FID's
  else
    QmatNMR.FIDstatus = 1;			%set correct plotting direction for spectra
  end
  QmatNMR.InverseFTflag = 0; 			%reset inverse FT flag just to be sure
  
  repair
  regeldisplaymode
  
  %
  %ALWAYS revert to the default axis
  %
  QmatNMR.RulerXAxis = 0;		%Flag for default axis
  QmatNMRsettings.DefaultAxisCarrierIndex = floor(QmatNMR.Size1D/2)+1; 	%after FT we ALWAYS assume that the carrier is in the center of the spectrum
  
  if (~QmatNMR.BusyWithMacro)
    asaanpas
    Arrowhead;
  
  else
    GetDefaultAxis			%calculate default axis
    detaxisprops
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
