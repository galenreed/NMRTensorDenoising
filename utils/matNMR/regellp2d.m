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
%regellp2d.m performs the linear prediction on the current dimension of 2D FID's
%
%11-06-'98

try
  if QmatNMR.buttonList == 1						%= OK-button
    watch;
  
    %
    %create entry in the undo matrix
    %
    regelUNDO
  
    QmatNMR.lpNrPoints = eval(QmatNMR.uiInput1);
    QmatNMR.lpNrPointsToUse = eval(QmatNMR.uiInput2);
    QmatNMR.lpNrFreqs  = eval(QmatNMR.uiInput3);
    QmatNMR.lpSNratio  = eval(QmatNMR.uiInput4);
  
  
    %
    %give warning if too many points should be taken into account because things get really slow
    %
    if (QmatNMR.lpNrPointsToUse > 256)
      disp('matNMR NOTICE: linear prediction inherently becomes very slow when more than 256 points from the FID')
      disp('matNMR NOTICE: should be used to predict from, and often without improvement over e.g. 128 points.')
      disp('matNMR NOTICE: Please consider to reduce this number!')
    end
  
  
    %
    %make sure that the number of frequencies aren't negative for lpsvd
    %
    if ((QmatNMR.LPtype == 1) | (QmatNMR.LPtype == 3))		%lpsvd method
      if (QmatNMR.lpNrFreqs < 1)
        beep
        disp('matNMR WARNING: number of frequencies cannot be smaller than 1 for lpsvd! Aborting ... ')
        return;
      end
    end
  
  
    %
    %read FT mode
    %
    QmatNMR.howFT = get(QmatNMR.Four, 'value');
  
  
    %
    %unless both dimensions are FIDs we allow for the user to specify the regions of interest, in order to
    %speed up the LP (i.e. not to do LP on noise as this is pointless)
    %
    if (~QmatNMR.BusyWithMacro)
      QmatNMR.LPPeakList = [];
      if ((QmatNMR.FIDstatus2D1 == 2) & (QmatNMR.FIDstatus2D2 == 2))
      elseif ((QmatNMR.Dim == 1) & (QmatNMR.FIDstatus2D2 == 1))
        defpeaksLP
      elseif ((QmatNMR.Dim == 2) & (QmatNMR.FIDstatus2D1 == 1))
        defpeaksLP
      end
    end
  
    if isempty(QmatNMR.LPPeakList)
      if (QmatNMR.Dim == 1)
        QmatNMR.LPPeakList = 1:QmatNMR.SizeTD1;
        
      else
        QmatNMR.LPPeakList = 1:QmatNMR.SizeTD2;
      end
    end
    QTEMP7 = 0; 		%used as counter during LP
  
  
    %
    %action
    %
    if (QmatNMR.Dim == 1)			%TD2 from 2D FID ...
    
  			%first arrange the spectral matrix to its new size  
      QTEMP8 = QmatNMR.Spec2D;
      QTEMP9 = QmatNMR.Spec2Dhc;
      
      %some Fourier modes only have real parts defined.
      if ((QmatNMR.howFT == 2) | (QmatNMR.howFT == 4) | (QmatNMR.howFT == 8))
        QTEMP8 = real(QTEMP8);
        QTEMP9 = real(QTEMP9);
      end
      
      if (QmatNMR.LPtype < 3)			%backward prediction --> put zeros in front of matrix
        QmatNMR.Spec2D = zeros(QmatNMR.SizeTD1, QmatNMR.lpNrPoints+QmatNMR.SizeTD2);
        QmatNMR.Spec2D(:, (QmatNMR.lpNrPoints+1):(QmatNMR.lpNrPoints+QmatNMR.SizeTD2)) = QTEMP8;
  
        QmatNMR.Spec2Dhc = zeros(QmatNMR.SizeTD1, QmatNMR.lpNrPoints+QmatNMR.SizeTD2);
        QmatNMR.Spec2Dhc(:, (QmatNMR.lpNrPoints+1):(QmatNMR.lpNrPoints+QmatNMR.SizeTD2)) = QTEMP9;
   
     else  				%forward prediction --> put zeros at back of matrix
        QmatNMR.Spec2D = zeros(QmatNMR.SizeTD1, QmatNMR.lpNrPoints+QmatNMR.SizeTD2);
        QmatNMR.Spec2D(:, 1:QmatNMR.SizeTD2) = QTEMP8;
  
        QmatNMR.Spec2Dhc = zeros(QmatNMR.SizeTD1, QmatNMR.lpNrPoints+QmatNMR.SizeTD2);
        QmatNMR.Spec2Dhc(:, 1:QmatNMR.SizeTD2) = QTEMP9;
      end
    
    
    
  			%Perform the linear prediction on all rows
      for QTEMP40 = QmatNMR.LPPeakList
        QTEMP7 = QTEMP7 + 1;
        fprintf(1, '\rProcessing row %4g out of %4g requested rows ... ', QTEMP7, length(QmatNMR.LPPeakList));
      
  			%analyse spectrum: gives ampl., phase, frequency
        if ((QmatNMR.LPtype == 1) | (QmatNMR.LPtype == 3))	%lpsvd method
          QTEMP12 = QTEMP8(QTEMP40, 1:QmatNMR.lpNrPointsToUse);
          if (norm(QTEMP12) > 100*eps)
            QTEMP2 = lpsvd(QTEMP12, QmatNMR.lpNrFreqs);
          else
            QTEMP2 = [];
          end
  	if isempty(QTEMP2)
  	  QTEMP2 = zeros(1,4);
  	end  
  
          if ((QmatNMR.howFT == 3)| (QmatNMR.howFT == 6))	%states or States-TPPI
            QTEMP12 = QTEMP9(QTEMP40, 1:QmatNMR.lpNrPointsToUse);
            if (norm(QTEMP12) > 100*eps)
              QTEMP4 = lpsvd(QTEMP12, QmatNMR.lpNrFreqs);
  
              if isempty(QTEMP4)
                QTEMP4 = zeros(1,4);
              end  
            else
              QTEMP4 = zeros(1, 4);
            end
  	end  
    
        else				%itmpm method
          QTEMP12 = QTEMP8(QTEMP40, 1:QmatNMR.lpNrPointsToUse);
          if (norm(QTEMP12) > 100*eps)
            QTEMP2 = itcmp(QTEMP12, QmatNMR.lpNrFreqs);
          else
            QTEMP2 = [];
          end
  	if isempty(QTEMP2)
  	  QTEMP2 = zeros(1,4);
  	end  
  
          if ((QmatNMR.howFT == 3)| (QmatNMR.howFT == 6))	%states or States-TPPI
            QTEMP12 = QTEMP9(QTEMP40, 1:QmatNMR.lpNrPointsToUse);
            if (norm(QTEMP12) > 100*eps)
              QTEMP4 = itcmp(QTEMP12, QmatNMR.lpNrFreqs);
  
              if isempty(QTEMP4)
                QTEMP4 = zeros(1,4);
              end  
            else
              QTEMP4 = zeros(1, 4);
            end
          end  
        end
  
  			%predict points and add to the spectrum
          if (QmatNMR.LPtype < 3)			%backward prediction
            QmatNMR.Spec2D(QTEMP40, 1:QmatNMR.lpNrPoints) = (cegnt( (-QmatNMR.lpNrPoints):(-1) , QTEMP2, QmatNMR.lpSNratio, 100*rand(1,1))).';
  
            if ((QmatNMR.howFT == 3)| (QmatNMR.howFT == 6))	%states or States-TPPI
              QmatNMR.Spec2Dhc(QTEMP40, 1:QmatNMR.lpNrPoints) = (cegnt( (-QmatNMR.lpNrPoints):(-1) , QTEMP4, QmatNMR.lpSNratio, 100*rand(1,1))).';
            end    
      
          else					%forward prediction
            QmatNMR.Spec2D(QTEMP40, (QmatNMR.SizeTD2+1):(QmatNMR.SizeTD2+QmatNMR.lpNrPoints)) = (cegnt( (QmatNMR.Size1D):(QmatNMR.Size1D+QmatNMR.lpNrPoints-1) , QTEMP2, QmatNMR.lpSNratio, 100*rand(1,1))).';
  
            if ((QmatNMR.howFT == 3)| (QmatNMR.howFT == 6))	%states or States-TPPI
              QmatNMR.Spec2Dhc(QTEMP40, (QmatNMR.SizeTD2+1):(QmatNMR.SizeTD2+QmatNMR.lpNrPoints)) = (cegnt( (QmatNMR.Size1D):(QmatNMR.Size1D+QmatNMR.lpNrPoints-1) , QTEMP4, QmatNMR.lpSNratio, 100*rand(1,1))).';
  	  end  
          end    
      end
    
    
    % 
    % 
    %  
    else	%TD 1 of 2D FID ...
  			%first arrange the spectral matrix to its new size  
      Qi = sqrt(-1);
      QTEMP8 = QmatNMR.Spec2D;
      QTEMP9 = QmatNMR.Spec2Dhc;
  
  
      %the Fourier mode is needed to know which parts to combine
      if ((QmatNMR.howFT == 1) | (QmatNMR.howFT == 5) | (QmatNMR.howFT == 7))	%Complex FT and Whole Echo and Bruker qseq
        QTEMP10 = QmatNMR.Spec2D;
        QTEMP11 = QmatNMR.Spec2Dhc;
      
      elseif ((QmatNMR.howFT == 2) | (QmatNMR.howFT == 4) | (QmatNMR.howFT == 8))	%real FT and TPPI and sine FT
        QTEMP10 = real(QmatNMR.Spec2D);
        QTEMP11 = real(QmatNMR.Spec2Dhc);
  
      elseif ((QmatNMR.howFT == 3) | (QmatNMR.howFT == 6))         		%STATES and STATES-TPPI
        QTEMP10 = real(QmatNMR.Spec2D) + Qi*real(QmatNMR.Spec2Dhc);
        QTEMP11 = imag(QmatNMR.Spec2D) + Qi*imag(QmatNMR.Spec2Dhc);
      end
  
  
      if (QmatNMR.LPtype < 3)			%backward prediction --> put zeros in front of matrix
        QmatNMR.Spec2D = zeros(QmatNMR.SizeTD1+QmatNMR.lpNrPoints, QmatNMR.SizeTD2);
        QmatNMR.Spec2D((QmatNMR.lpNrPoints+1):(QmatNMR.lpNrPoints+QmatNMR.SizeTD1), :) = QTEMP8;
  
        QmatNMR.Spec2Dhc = zeros(QmatNMR.SizeTD1+QmatNMR.lpNrPoints, QmatNMR.SizeTD2);
        QmatNMR.Spec2Dhc((QmatNMR.lpNrPoints+1):(QmatNMR.lpNrPoints+QmatNMR.SizeTD1), :) = QTEMP9;
      else  				%forward prediction --> put zeros at back of matrix
        QmatNMR.Spec2D = zeros(QmatNMR.SizeTD1+QmatNMR.lpNrPoints, QmatNMR.SizeTD2);
        QmatNMR.Spec2D(1:QmatNMR.SizeTD1, :) = QTEMP8;
  
        QmatNMR.Spec2Dhc = zeros(QmatNMR.SizeTD1+QmatNMR.lpNrPoints, QmatNMR.SizeTD2);
        QmatNMR.Spec2Dhc(1:QmatNMR.SizeTD1, :) = QTEMP9;
      end
      
  			%Perform the linear prediction on all columns
      for QTEMP40 = QmatNMR.LPPeakList
        QTEMP7 = QTEMP7 + 1;
        fprintf(1, '\rProcessing column %4g out of %4g requested columns ... ', QTEMP7, length(QmatNMR.LPPeakList));
      
  			%analyse spectrum: gives ampl., phase, frequency
        if ((QmatNMR.LPtype == 1) | (QmatNMR.LPtype == 3))	%lpsvd method
          QTEMP12 = QTEMP10(1:QmatNMR.lpNrPointsToUse, QTEMP40);
          if (norm(QTEMP12) > 100*eps)
            QTEMP2 = lpsvd(QTEMP12, QmatNMR.lpNrFreqs);
          else
            QTEMP2 = [];
          end
  	if isempty(QTEMP2)
  	  QTEMP2 = zeros(1,4);
  	end  
  
          if (QmatNMR.HyperComplex)
            QTEMP12 = QTEMP11(1:QmatNMR.lpNrPointsToUse, QTEMP40);
            if (norm(QTEMP12) > 100*eps)
              QTEMP4 = lpsvd(QTEMP12, QmatNMR.lpNrFreqs);
            else
              QTEMP4 = [];
            end
            if isempty(QTEMP4)
              QTEMP4 = zeros(1,4);
            end
  	end
    
        else				%itmpm method
          QTEMP12 = QTEMP10(1:QmatNMR.lpNrPointsToUse, QTEMP40);
          if (norm(QTEMP12) > 100*eps)
            QTEMP2 = itcmp(QTEMP12, QmatNMR.lpNrFreqs);
          else
            QTEMP2 = [];
          end
  	if isempty(QTEMP2)
  	  QTEMP2 = zeros(1,4);
  	end  
  
          if (QmatNMR.HyperComplex)
            QTEMP12 = QTEMP11(1:QmatNMR.lpNrPointsToUse, QTEMP40);
            if (norm(QTEMP12) > 100*eps)
              QTEMP4 = itcmp(QTEMP12, QmatNMR.lpNrFreqs);
            else
              QTEMP4 = [];
            end
            if isempty(QTEMP4)
              QTEMP4 = zeros(1,4);
            end
  	end
        end
  
  			%predict points and add to the spectrum
          if (QmatNMR.LPtype < 3)			%backward prediction
            QTEMP12 = (cegnt( (-QmatNMR.lpNrPoints):(-1) , QTEMP2, QmatNMR.lpSNratio, 100*rand(1,1)));
  
            if (QmatNMR.HyperComplex)
              QTEMP13 = (cegnt( (-QmatNMR.lpNrPoints):(-1) , QTEMP4, QmatNMR.lpSNratio, 100*rand(1,1)));
              QmatNMR.Spec2D( 1:QmatNMR.lpNrPoints , QTEMP40) = real(QTEMP12) + Qi*real(QTEMP13);
              QmatNMR.Spec2Dhc( 1:QmatNMR.lpNrPoints , QTEMP40) = imag(QTEMP12) + Qi*imag(QTEMP13);
  
            else
              QmatNMR.Spec2D( 1:QmatNMR.lpNrPoints , QTEMP40) = real(QTEMP12);
            end
  
          else					%forward prediction
            QTEMP12 = (cegnt( (QmatNMR.Size1D):(QmatNMR.Size1D+QmatNMR.lpNrPoints-1) , QTEMP2, QmatNMR.lpSNratio, 100*rand(1,1)));
  
            if (QmatNMR.HyperComplex)
              QTEMP13 = (cegnt( (QmatNMR.Size1D):(QmatNMR.Size1D+QmatNMR.lpNrPoints-1) , QTEMP4, QmatNMR.lpSNratio, 100*rand(1,1)));
              QmatNMR.Spec2D( (QmatNMR.SizeTD1+1):(QmatNMR.SizeTD1+QmatNMR.lpNrPoints) , QTEMP40) = real(QTEMP12) + Qi*real(QTEMP13);
              QmatNMR.Spec2Dhc( (QmatNMR.SizeTD1+1):(QmatNMR.SizeTD1+QmatNMR.lpNrPoints) , QTEMP40) = imag(QTEMP12) + Qi*imag(QTEMP13);
  
            else
              QmatNMR.Spec2D( (QmatNMR.SizeTD1+1):(QmatNMR.SizeTD1+QmatNMR.lpNrPoints) , QTEMP40) = real(QTEMP12);
            end
          end
      end
    end
  
  
    %
    % Now that the prediction has finished, take care of some organizational things ....
    %
  
    %
    %ALWAYS revert to the default axis
    %
    QmatNMR.RulerXAxis = 0;		%Flag for default axis
    if (QmatNMR.Dim == 1) 		%TD2
      QmatNMR.RulerXAxis1 = 0;		%Flag for default axis
    else
      QmatNMR.RulerXAxis2 = 0;		%Flag for default axis
    end
  
      					%Add action to history
    if (QmatNMR.LPtype == 1)
      QmatNMR.History = str2mat(QmatNMR.History, ['Linear back prediction on TD ' num2str(QmatNMR.Dim) ' : LPSVD, ' num2str(QmatNMR.lpNrPoints) ' points predicted, ' num2str(QmatNMR.lpNrPointsToUse) ' points used to do prediction, ' num2str(QmatNMR.lpNrFreqs) ' freqs, ' num2str(QmatNMR.lpSNratio) ' SN ratio']);
  
    elseif (QmatNMR.LPtype == 2) 
      QmatNMR.History = str2mat(QmatNMR.History, ['Linear back prediction on TD ' num2str(QmatNMR.Dim) ' : ITMPM, ' num2str(QmatNMR.lpNrPoints) ' points predicted, ' num2str(QmatNMR.lpNrPointsToUse) ' points used to do prediction, ' num2str(QmatNMR.lpNrFreqs) ' freqs, ' num2str(QmatNMR.lpSNratio) ' SN ratio']);
  
    elseif (QmatNMR.LPtype == 3)
      QmatNMR.History = str2mat(QmatNMR.History, ['Linear forward prediction on TD ' num2str(QmatNMR.Dim) ' : LPSVD, ' num2str(QmatNMR.lpNrPoints) ' points predicted, ' num2str(QmatNMR.lpNrPointsToUse) ' points used to do prediction, ' num2str(QmatNMR.lpNrFreqs) ' freqs, ' num2str(QmatNMR.lpSNratio) ' SN ratio']);
  
    else  
      QmatNMR.History = str2mat(QmatNMR.History, ['Linear forward prediction on TD ' num2str(QmatNMR.Dim) ' : ITMPM, ' num2str(QmatNMR.lpNrPoints) ' points predicted, ' num2str(QmatNMR.lpNrPointsToUse) ' points used to do prediction, ' num2str(QmatNMR.lpNrFreqs) ' freqs, ' num2str(QmatNMR.lpSNratio) ' SN ratio']);
    end
  
  
    %now add the peak list into the macro ...
    QTEMP2 = ceil(length(QmatNMR.LPPeakListIndices)/(QmatNMR.MacroLength-1));
    QTEMP = zeros(1, QTEMP2*(QmatNMR.MacroLength-1));
    QTEMP(1:length(QmatNMR.LPPeakListIndices)) = QmatNMR.LPPeakListIndices;
    for QTEMP40=1:QTEMP2
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 126, QTEMP((QTEMP40-1)*(QmatNMR.MacroLength-1)+ (1:(QmatNMR.MacroLength-1))));
      
      if QmatNMR.RecordingMacro
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 126, QTEMP((QTEMP40-1)*(QmatNMR.MacroLength-1)+ (1:(QmatNMR.MacroLength-1))));
      end
    end
    QmatNMR.LPPeakListIndices = [];
    QmatNMR.LPPeakList = [];
  
  
    %first add dimension-specific information, and then the current command
    if (QmatNMR.Dim == 1) 		%TD2
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
    
    else
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
    end
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 117, QmatNMR.LPtype, QmatNMR.lpNrPoints, QmatNMR.lpNrPointsToUse, QmatNMR.lpNrFreqs, QmatNMR.lpSNratio, QmatNMR.Dim, QmatNMR.howFT);	%code for LP 2D, forward ITMPM, etc ...	
  
    if QmatNMR.RecordingMacro
      %first add dimension-specific information, and then the current command
      if (QmatNMR.Dim == 1)		%TD2
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
      
      else
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
      end
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 117, QmatNMR.LPtype, QmatNMR.lpNrPoints, QmatNMR.lpNrPointsToUse, QmatNMR.lpNrFreqs, QmatNMR.lpSNratio, QmatNMR.Dim, QmatNMR.howFT);	%code for LP 2D, forward ITMPM, etc ...	
    end
  
    QmatNMR.Temp = get(QmatNMR.FID, 'String');
    [QmatNMR.SizeTD1, QmatNMR.SizeTD2] = size(QmatNMR.Spec2D);
  
    getcurrentspectrum		%get spectrum to show on the screen
  
  
    disp(' ');
    disp(['New Size of the 2D spectrum : ', num2str(QmatNMR.SizeTD1), ' x ', num2str(QmatNMR.SizeTD2) ' (td1 x td2)']);
  
    if (~QmatNMR.BusyWithMacro)
      asaanpas
      Arrowhead
      
    else
      GetDefaultAxis
    end  
  
    				%reset the phase variables
    QmatNMR.fase0 = 0;
    QmatNMR.fase1 = 0;
    QmatNMR.fase2 = 0;
    QmatNMR.dph0 = 0;
    QmatNMR.dph1 = 0;
    QmatNMR.dph2 = 0;
    QmatNMR.fase1startIndex = floor(QmatNMR.Size1D/2)+1;
    repair
  
    disp('2D Linear prediction finished ...');
  else
    disp('No linear prediction performed.');
  end   
  
  clear Qi QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
