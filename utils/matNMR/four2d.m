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
%four2d.m handles the Fourier transformation of the current dimension of the 2D FID
%(QmatNMR.Dim = 1 === TD2) (QmatNMR.Dim =2 === TD1)
%21-2-1997

try
  if (QmatNMR.Dim == 0)
    disp('matNMR NOTICE: 2D processing functions are not allowed in 1D mode!')
  
  else  
    if QmatNMR.lbstatus | QmatNMR.bezigmetfase
      disp('matNMR WARNING:  not possible while apodizing or phasing!     four2d cancelled');
    
    else  
      watch;
      
      %
      %Determine the FT mode
      %
      QmatNMR.howFT = get(QmatNMR.Four, 'value');
  
  
      %
      %create entry in the undo matrix
      %
      regelUNDO
  
  
    %
    %
    % Now do TD2 ...
    %
    %
    
    
      if (QmatNMR.Dim == 1)			%FT TD2
        QTEMP40 = 1:QmatNMR.SizeTD1;
  
        if (QmatNMR.InverseFTflag)	%do inverse FT
          if ((QmatNMR.howFT == 1) | (QmatNMR.howFT == 2) | (QmatNMR.howFT == 5))	%Complex FT, real FT, whole echo 
            QmatNMR.Spec2D   = ifft(fftshift(QmatNMR.Spec2D, 2), [], 2);
        
          elseif ((QmatNMR.howFT == 3) | (QmatNMR.howFT == 6))	%STATES, STATES-TPPI
            QmatNMR.Spec2D   = ifft(fftshift(QmatNMR.Spec2D, 2), [], 2);
            QmatNMR.Spec2Dhc = ifft(fftshift(QmatNMR.Spec2Dhc, 2), [], 2);
        
          else
            disp('matNMR NOTICE: inverse FT not implemented for current FT mode. Aborting ...');
            return
          end
        
          if ((QmatNMR.fftstatus == 1) & (QmatNMR.howFT ~= 5))	%Divide first point by 0.5 if necessary (not for whole echo!)
            QmatNMR.Spec2D(1:QmatNMR.SizeTD1, 1) = (QmatNMR.Spec2D(1:QmatNMR.SizeTD1, 1) / 0.5);
  
            if ((QmatNMR.howFT == 3) | (QmatNMR.howFT == 6)) 	%States
              QmatNMR.Spec2Dhc(1:QmatNMR.SizeTD1, 1) = (QmatNMR.Spec2Dhc(1:QmatNMR.SizeTD1, 1) / 0.5);
            end
          end
          disp('Inverse Fourier transformation of TD2 finished');
  
        else			%forward FT
          if ((QmatNMR.fftstatus == 1) & (QmatNMR.howFT ~= 5))	%Multiply first point with 0.5 if necessary (not for whole echo!)
            QmatNMR.Spec2D(QTEMP40, 1) = QmatNMR.Spec2D(QTEMP40, 1) * 0.5;
          
            if QmatNMR.howFT == 3			%States
              QmatNMR.Spec2Dhc(QTEMP40, 1) = QmatNMR.Spec2Dhc(QTEMP40, 1) * 0.5;
            end  
          end
      
      
      
      
          if ((QmatNMR.howFT == 1) | (QmatNMR.howFT == 5))	%Complex FT and Whole Echo
            if (sum(sum(QmatNMR.Spec2Dhc)) == 0)  %normally the hypercomplex part will have zero sum
              QmatNMR.Spec2D = fftshift(fft(QmatNMR.Spec2D, [], 2), 2);
  
            else                                  %if not, then we'll do the FT on the hypercomplex part too.
                                                  %to cover the case that FT in TD1 is done before FT
                                                  %in TD2 in case of TPPI in TD1
              QmatNMR.Spec2D   = fftshift(fft(QmatNMR.Spec2D, [], 2), 2);
              QmatNMR.Spec2Dhc = fftshift(fft(QmatNMR.Spec2Dhc, [], 2), 2);
            end
            disp('Complex Fourier transformation of TD2 finished');
      
      
      
          elseif QmatNMR.howFT == 2				%Real FT
            QmatNMR.Spec2D = fftshift(fft(real(QmatNMR.Spec2D), [], 2), 2);
            disp('Real Fourier transformation of TD2 finished');
      
      
      
      
          elseif ((QmatNMR.howFT == 3) | (QmatNMR.howFT == 6))	%States FT or States-TPPI
            QmatNMR.Spec2D   = fftshift(fft(QmatNMR.Spec2D, [], 2), 2);
            QmatNMR.Spec2Dhc = fftshift(fft(QmatNMR.Spec2Dhc, [], 2), 2);
            disp('States (normal complex) Fourier transformation of TD2 finished');
      
      
      
      
          elseif QmatNMR.howFT == 4				%TPPI FT
            if (sum(sum(QmatNMR.Spec2Dhc)) == 0)  %normally the hypercomplex part will have zero sum
              for QTEMP40=1:QmatNMR.SizeTD1
                QTEMP1 = fftshift(fft(real(QmatNMR.Spec2D(QTEMP40, :)), 2*QmatNMR.SizeTD2));
                QmatNMR.Spec2D(QTEMP40, :) = QTEMP1(1:QmatNMR.SizeTD2);
              end
  
            else                                  %if not, then we'll do the FT on the hypercomplex part too.
                                                  %to cover the case that FT in TD1 is done before FT
                                                  %in TD2 in case of TPPI in TD1
              for QTEMP40=1:QmatNMR.SizeTD1
                QTEMP1 = fftshift(fft(real(QmatNMR.Spec2D(QTEMP40, :)), 2*QmatNMR.SizeTD2));
                QmatNMR.Spec2D(QTEMP40, :) = QTEMP1(1:QmatNMR.SizeTD2);
  
                QTEMP1 = fftshift(fft(real(QmatNMR.Spec2Dhc(QTEMP40, :)), 2*QmatNMR.SizeTD2));
                QmatNMR.Spec2Dhc(QTEMP40, :) = QTEMP1(1:QmatNMR.SizeTD2);
              end
            end
    
            disp('TPPI Fourier transformation of TD2 finished');
            disp('matNMR NOTICE: please beware that this is an unusual transform to use for TD2 (except for converted qseq data)!')
      
      
      
      
          elseif (QmatNMR.howFT == 7)			%Bruker qseq data
            for QTEMP40=1:QmatNMR.SizeTD1
              QTEMP1 = QmatNMR.Spec2D(QTEMP40, :);
              QTEMP1(2:2:QmatNMR.SizeTD2) = -QTEMP1(2:2:QmatNMR.SizeTD2);
              QTEMP2 = zeros(1, 2*QmatNMR.SizeTD2);
              QTEMP2(1:2:2*QmatNMR.SizeTD2) = real(QTEMP1);
              QTEMP2(2:2:2*QmatNMR.SizeTD2) = imag(QTEMP1);
              QTEMP1 = fftshift(fft(QTEMP2, 2*QmatNMR.SizeTD2));
              QmatNMR.Spec2D(QTEMP40, :) = QTEMP1(1:QmatNMR.SizeTD2);
            end
    	  
            disp('Bruker qseq Fourier transformation of TD2 finished');
      
      
      
      
          elseif (QmatNMR.howFT == 8)			%Sine FT = real FT + 90 degree phase shift + inversion of first half of the spectrum
            QmatNMR.Spec2D = fftshift(fft(real(QmatNMR.Spec2D), [], 2), 2);
            %
            %in case of a real + Sine FT we perform a 90 degree phase shift and invert half of the spectrum
            %
            QmatNMR.Spec2D = -imag(QmatNMR.Spec2D) + sqrt(-1)*real(QmatNMR.Spec2D);
            QmatNMR.Spec2D(:, 1:floor(QmatNMR.SizeTD2/2)) = -QmatNMR.Spec2D(:, 1:floor(QmatNMR.SizeTD2/2));
    	  
            disp('Sine FT of TD2 finished');
          end
        end
      
  
      %
      %Now set some variables right ...
      %
        QmatNMR.totaalX = QmatNMR.SizeTD2;
        QmatNMR.lbstatus = 0;				%remove line broadening flag
      
        getcurrentspectrum			%get spectrum to show on the screen
    
        historyFT
  
        if ((QmatNMR.howFT == 4) | (QmatNMR.howFT == 7))		%TPPI or Bruker qseq
  	if (QmatNMR.Dim == 1) 		%TD2
            QmatNMR.SWTD2 = QmatNMR.SWTD2 / 2; 	%adjust the sweepwidth to half it's previous value
  	  QmatNMR.SW1D = QmatNMR.SWTD2;
          else
            QmatNMR.SWTD1 = QmatNMR.SWTD1 / 2; 	%adjust the sweepwidth to half it's previous value
  	  QmatNMR.SW1D = QmatNMR.SWTD1;
  	end
        end
  
        if (QmatNMR.InverseFTflag)
          QmatNMR.FIDstatus2D1 = 2;			%This is now an FID
          QmatNMR.FIDstatus = 2;				%So when plotting the axis needs to be reversed
  	QmatNMR.InverseFTflag = 0;
        else
          QmatNMR.FIDstatus2D1 = 1;			%This is no longer an FID
          QmatNMR.FIDstatus = 1;				%So when plotting the axis needs to be reversed
        end
  
        set(QmatNMR.FID, 'value', QmatNMR.FIDstatus);
        regeldisplaymode
  
        QmatNMR.lbstatus=0;				%reset linebroadening flag and button
        set(QmatNMR.h75, 'value', 1);
    
        getcurrentspectrum			%get spectrum to show on the screen
  
        %
        %ALWAYS revert to the default axis after a fourier transform
        %
        QmatNMR.RulerXAxis = 0;				%Flag for default axis
        QmatNMRsettings.DefaultAxisCarrierIndex = floor(QmatNMR.SizeTD2/2)+1; 	%after FT we ALWAYS assume that the carrier is in the center of the spectrum
        QmatNMR.RulerXAxis1 = 0;
        QmatNMRsettings.DefaultAxisCarrierIndex1 = floor(QmatNMR.SizeTD2/2)+1; 	%after FT we ALWAYS assume that the carrier is in the center of the spectrum
   
    
    %
    %
    % Now do TD1 ...
    %
    %
    
    
      else					%FT TD1
        Qi = sqrt(-1);
        QTEMP40 = 1:QmatNMR.SizeTD2;
     
        if (QmatNMR.InverseFTflag)	%do inverse FT
          if ((QmatNMR.howFT == 1) | (QmatNMR.howFT == 2) | (QmatNMR.howFT == 5))	%Complex FT, real FT, whole echo 
            QmatNMR.Spec2D   = ifft(fftshift(QmatNMR.Spec2D, 1), [], 1);
        
          elseif ((QmatNMR.howFT == 3) | (QmatNMR.howFT == 6))	%STATES, STATES-TPPI
            QTEMP1 = real(QmatNMR.Spec2D) + Qi*real(QmatNMR.Spec2Dhc);	
            QTEMP2 = imag(QmatNMR.Spec2D) + Qi*imag(QmatNMR.Spec2Dhc); 						
  
            for QTEMP40=1:QmatNMR.SizeTD2;
              QmatNMR.tmp1 = ifft(fftshift(QTEMP1(:, QTEMP40)));
              QmatNMR.tmp2 = ifft(fftshift(QTEMP2(:, QTEMP40)));
            
              QmatNMR.Spec2D(:, QTEMP40) = real(QmatNMR.tmp1) + Qi*real(QmatNMR.tmp2);
              QmatNMR.Spec2Dhc(:, QTEMP40) = imag(QmatNMR.tmp1) + Qi*imag(QmatNMR.tmp2);
            end
        
          else
            disp('matNMR NOTICE: inverse FT not implemented for current FT mode. Aborting ...');
            return
          end
        
          if ((QmatNMR.fftstatus == 1) & (QmatNMR.howFT ~= 5))	%Divide first point by 0.5 if necessary (not for whole echo!)
            QmatNMR.Spec2D(1, 1:QmatNMR.SizeTD2) = (QmatNMR.Spec2D(1, 1:QmatNMR.SizeTD2) / 0.5);
  
            if ((QmatNMR.howFT == 3) | (QmatNMR.howFT == 6))%States
              QmatNMR.Spec2Dhc(1, 1:QmatNMR.SizeTD2) = (QmatNMR.Spec2Dhc(1, 1:QmatNMR.SizeTD2) / 0.5);
            end
          end
          disp('Inverse Fourier transformation of TD1 finished');
  
        else			%forward FT
          if ((QmatNMR.fftstatus == 1) & (QmatNMR.howFT ~= 5))	%Multiply first point with 0.5 if necessary (not for whole echo!)
            QmatNMR.Spec2D(1, QTEMP40) = (QmatNMR.Spec2D(1, QTEMP40) * 0.5);
          
            if ((QmatNMR.howFT == 3) | (QmatNMR.howFT == 6))%States
              QmatNMR.Spec2Dhc(1, QTEMP40) = (QmatNMR.Spec2Dhc(1, QTEMP40) * 0.5);
            end
          end
      
      
      
      
          if ((QmatNMR.howFT == 1) | (QmatNMR.howFT == 5))	%Complex FT and Whole Echo
            QmatNMR.Spec2D   = fftshift(fft(QmatNMR.Spec2D, [], 1), 1);
            disp('Complex Fourier transformation of TD1 finished');
      
      
      
      
      
          elseif QmatNMR.howFT == 2			%Real FT
            QmatNMR.Spec2D   = fftshift(fft(real(QmatNMR.Spec2D), [], 1), 1);
            disp('Real Fourier transformation of TD1 finished');
      
      
      
      
      
          elseif QmatNMR.howFT == 3			%States FT
            QTEMP1 = real(QmatNMR.Spec2D) + Qi*real(QmatNMR.Spec2Dhc);	
            QTEMP2 = imag(QmatNMR.Spec2D) + Qi*imag(QmatNMR.Spec2Dhc); 						
          
            for QTEMP40=1:QmatNMR.SizeTD2;
              QmatNMR.tmp1 = fftshift(fft(QTEMP1(:, QTEMP40)));
              QmatNMR.tmp2 = fftshift(fft(QTEMP2(:, QTEMP40)));
            
              QmatNMR.Spec2D(:, QTEMP40) = real(QmatNMR.tmp1) + Qi*real(QmatNMR.tmp2);
              QmatNMR.Spec2Dhc(:, QTEMP40) = imag(QmatNMR.tmp1) + Qi*imag(QmatNMR.tmp2);
            end
            disp('States Fourier transformation of TD1 finished');
       
      
      
      
          
          elseif QmatNMR.howFT == 4			%TPPI FT
            for QTEMP40=1:QmatNMR.SizeTD2;
              QmatNMR.tmp1 = fft((real(QmatNMR.Spec2D(:, QTEMP40))), 2*QmatNMR.SizeTD1);
              QmatNMR.tmp2 = fft((imag(QmatNMR.Spec2D(:, QTEMP40))), 2*QmatNMR.SizeTD1);
    
              QmatNMR.Spec2D(:, QTEMP40) = real(QmatNMR.tmp1(1:QmatNMR.SizeTD1)) + Qi*real(QmatNMR.tmp2(1:QmatNMR.SizeTD1));
              QmatNMR.Spec2Dhc(:, QTEMP40) = imag(QmatNMR.tmp1(1:QmatNMR.SizeTD1)) + Qi*imag(QmatNMR.tmp2(1:QmatNMR.SizeTD1));
            end
            disp('TPPI Fourier transformation of TD1 finished');
          
      
      
      
      
      
          elseif QmatNMR.howFT == 6			%States-TPPI FT
            %
            %First we negate every second complex point
            %
            QTEMP1 = real(QmatNMR.Spec2D) + Qi*real(QmatNMR.Spec2Dhc);
            QTEMP1(2:2:QmatNMR.SizeTD1, :) = -QTEMP1(2:2:QmatNMR.SizeTD1, :);
      
            QTEMP2 = imag(QmatNMR.Spec2D) + Qi*imag(QmatNMR.Spec2Dhc); 						
            QTEMP2(2:2:QmatNMR.SizeTD1, :) = -QTEMP2(2:2:QmatNMR.SizeTD1, :);
          
            for QTEMP40=1:QmatNMR.SizeTD2;
              QmatNMR.tmp1 = fftshift(fft(QTEMP1(:, QTEMP40)));
              QmatNMR.tmp2 = fftshift(fft(QTEMP2(:, QTEMP40)));
            
              QmatNMR.Spec2D(:, QTEMP40) = real(QmatNMR.tmp1) + Qi*real(QmatNMR.tmp2);
              QmatNMR.Spec2Dhc(:, QTEMP40) = imag(QmatNMR.tmp1) + Qi*imag(QmatNMR.tmp2);
            end
            disp('States-TPPI Fourier transformation of TD1 finished');
      
      
      
      
          elseif (QmatNMR.howFT == 7)		%Bruker qseq data
            for QTEMP40=1:QmatNMR.SizeTD2;
              QmatNMR.tmp1 = real(QmatNMR.Spec2D(:, QTEMP40));
              QmatNMR.tmp1(3:4:QmatNMR.SizeTD1) = -QmatNMR.tmp1(3:4:QmatNMR.SizeTD1);
              QmatNMR.tmp1(4:4:QmatNMR.SizeTD1) = -QmatNMR.tmp1(4:4:QmatNMR.SizeTD1);
              QmatNMR.tmp1 = fft(QmatNMR.tmp1, 2*QmatNMR.SizeTD1);
      
              QmatNMR.tmp2 = imag(QmatNMR.Spec2D(:, QTEMP40));
              QmatNMR.tmp2(3:4:QmatNMR.SizeTD1) = -QmatNMR.tmp2(3:4:QmatNMR.SizeTD1);
              QmatNMR.tmp2(4:4:QmatNMR.SizeTD1) = -QmatNMR.tmp2(4:4:QmatNMR.SizeTD1);
              QmatNMR.tmp2 = fft(QmatNMR.tmp2, 2*QmatNMR.SizeTD1);
      
              QmatNMR.Spec2D(:, QTEMP40) = real(QmatNMR.tmp1(1:QmatNMR.SizeTD1)) + Qi*real(QmatNMR.tmp2(1:QmatNMR.SizeTD1));
              QmatNMR.Spec2Dhc(:, QTEMP40) = imag(QmatNMR.tmp1(1:QmatNMR.SizeTD1)) + Qi*imag(QmatNMR.tmp2(1:QmatNMR.SizeTD1));
            end
            disp('Bruker qseq Fourier transformation of TD1 finished');
      
      
      
      
      
          elseif (QmatNMR.howFT == 8)			%Sine FT
            QmatNMR.Spec2D   = fftshift(fft(real(QmatNMR.Spec2D), [], 1), 1);
            QmatNMR.Spec2D = -imag(QmatNMR.Spec2D) + sqrt(-1)*real(QmatNMR.Spec2D);
            QmatNMR.Spec2D(1:floor(QmatNMR.SizeTD1/2), :) = -QmatNMR.Spec2D(1:floor(QmatNMR.SizeTD1/2), :);
            disp('Sine FT of TD1 finished');
      
      
      
      
          else
            %
            %Then we do a normal States FT
            %
            for QTEMP40=1:QmatNMR.SizeTD2;
              QmatNMR.tmp1 = fftshift(fft(QTEMP1(:, QTEMP40)));
              QmatNMR.tmp2 = fftshift(fft(QTEMP2(:, QTEMP40)));
            
              QmatNMR.Spec2D(:, QTEMP40) = real(QmatNMR.tmp1) + Qi*real(QmatNMR.tmp2);
              QmatNMR.Spec2Dhc(:, QTEMP40) = imag(QmatNMR.tmp1) + Qi*imag(QmatNMR.tmp2);
            end
            disp('States-TPPI Fourier transformation of TD1 finished');
          end
        end
  
  
      %
      %Now set some variables right ...
      %
        historyFT
        if ((QmatNMR.howFT == 4) | (QmatNMR.howFT == 7))		%TPPI or Bruker qseq
  	if (QmatNMR.Dim == 1) 		%TD2
            QmatNMR.SWTD2 = QmatNMR.SWTD2 / 2; 	%adjust the sweepwidth to half it's previous value
  	  QmatNMR.SW1D = QmatNMR.SWTD2;
          else
            QmatNMR.SWTD1 = QmatNMR.SWTD1 / 2; 	%adjust the sweepwidth to half it's previous value
  	  QmatNMR.SW1D = QmatNMR.SWTD1;
  	end
        end
    
        if (QmatNMR.InverseFTflag)
          QmatNMR.FIDstatus2D2 = 2;			%This is now an FID
          QmatNMR.FIDstatus = 2;				%So when plotting the axis needs to be reversed
  	QmatNMR.InverseFTflag = 0;
        else
          QmatNMR.FIDstatus2D2 = 1;			%This is no longer an FID
          QmatNMR.FIDstatus = 1;				%So when plotting the axis needs to be reversed
        end
        set(QmatNMR.FID, 'value', QmatNMR.FIDstatus);
        regeldisplaymode
  
        QmatNMR.lbstatus=0;				%reset linebroadening flag and button
     
        getcurrentspectrum		%get spectrum to show on the screen
  
        %
        %ALWAYS revert to the default axis after a fourier transform
        %
        QmatNMR.RulerXAxis = 0;		%Flag for default axis
        QmatNMR.RulerXAxis2 = 0;
        QmatNMRsettings.DefaultAxisCarrierIndex = floor(QmatNMR.SizeTD1/2)+1; 	%after FT we ALWAYS assume that the carrier is in the center of the spectrum
        QmatNMRsettings.DefaultAxisCarrierIndex2 = floor(QmatNMR.SizeTD1/2)+1; 	%after FT we ALWAYS assume that the carrier is in the center of the spectrum
      end
  
    
      if (~QmatNMR.BusyWithMacro)
        asaanpas;
        Arrowhead
      
      else
        GetDefaultAxis		%calculate default axis
        detaxisprops
      end
    end
  end
  
  clear Qi QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
