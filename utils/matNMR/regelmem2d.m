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
%regelmem2d.m performs maximum entropy (MEM) reconstruction of 2D FID's
%
%10-06-'09

try
  if QmatNMR.buttonList == 1						%= OK-button
    watch;
  
    %
    %create entry in the undo matrix
    %
    regelUNDO
  
    QmatNMR.MEMNrPoints = eval(QmatNMR.uiInput1);
    QmatNMR.MEMNrPointsToUse = eval(QmatNMR.uiInput2);
    QmatNMR.MEMOrder  = eval(QmatNMR.uiInput3);
  
  
    %
    %read FT mode
    %
    QmatNMR.howFT = get(QmatNMR.Four, 'value');
  
  
    %
    %unless both dimensions are FIDs we allow for the user to specify the regions of interest, in order to
    %speed up the MEM (i.e. not to do MEM on noise as this is pointless)
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
      
      QmatNMR.Spec2D = zeros(QmatNMR.SizeTD1, QmatNMR.MEMNrPoints);
      QmatNMR.Spec2D(:, 1:QmatNMR.SizeTD2) = QTEMP8;
  
      QmatNMR.Spec2Dhc = zeros(QmatNMR.SizeTD1, QmatNMR.MEMNrPoints);
      QmatNMR.Spec2Dhc(:, 1:QmatNMR.SizeTD2) = QTEMP9;
      QmatNMR.SizeTD2 = QmatNMR.MEMNrPoints;
    
    
    
  			%Perform the linear prediction on all rows
      for QTEMP40 = QmatNMR.LPPeakList
        QTEMP7 = QTEMP7 + 1;
        fprintf(1, '\rProcessing row %4g out of %4g requested rows ... ', QTEMP7, length(QmatNMR.LPPeakList));
      
        QTEMP12 = QTEMP8(QTEMP40, 1:QmatNMR.MEMNrPointsToUse);
        if (norm(QTEMP12) > 100*eps)
          %
          %use the lpc algorithm to analyze the time-domain data
          %
          if (QmatNMR.MEMOrder == -1)
            QTEMP2 = lpc(QTEMP12);
          else
            QTEMP2 = lpc(QTEMP12, QmatNMR.MEMOrder);
          end
  
          %
          %reconstruct the new FID from the filter coefficients
          %
          QTEMP13 = filter([1 zeros(1, QmatNMR.MEMOrder)], QTEMP2, [QmatNMR.Spec2D(QTEMP40, 1) zeros(1, QmatNMR.MEMNrPoints-1)]);
          QmatNMR.Spec2D(QTEMP40, :) = QTEMP13;
        end
  
        if ((QmatNMR.howFT == 3)| (QmatNMR.howFT == 6)) %states or States-TPPI
          QTEMP12 = QTEMP9(QTEMP40, 1:QmatNMR.MEMNrPointsToUse);
          if (norm(QTEMP12) > 100*eps)
            %
            %use the lpc algorithm to analyze the time-domain data
            %
            if (QmatNMR.MEMOrder == -1)
              QTEMP2 = lpc(QTEMP12);
            else
              QTEMP2 = lpc(QTEMP12, QmatNMR.MEMOrder);
            end
    
            %
            %reconstruct the new FID from the filter coefficients
            %
            QTEMP13 = filter([1 zeros(1, QmatNMR.MEMOrder)], QTEMP2, [QmatNMR.Spec2Dhc(QTEMP40, 1) zeros(1, QmatNMR.MEMNrPoints-1)]);
            QmatNMR.Spec2Dhc(QTEMP40, :) = QTEMP13;
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
  
      QmatNMR.Spec2D = zeros(QmatNMR.MEMNrPoints, QmatNMR.SizeTD2);
      QmatNMR.Spec2D(1:QmatNMR.SizeTD1, :) = QTEMP8;
  
      QmatNMR.Spec2Dhc = zeros(QmatNMR.MEMNrPoints, QmatNMR.SizeTD2);
      QmatNMR.Spec2Dhc(1:QmatNMR.SizeTD1, :) = QTEMP9;
      QmatNMR.SizeTD1 = QmatNMR.MEMNrPoints;
  
  
      
  			%Perform the linear prediction on all columns
      for QTEMP40 = QmatNMR.LPPeakList
        QTEMP7 = QTEMP7 + 1;
        fprintf(1, '\rProcessing column %4g out of %4g requested columns ... ', QTEMP7, length(QmatNMR.LPPeakList));
        QTEMP12 = QTEMP10(1:QmatNMR.MEMNrPointsToUse, QTEMP40);
        if (norm(QTEMP12) > 100*eps)
          %
          %use the lpc algorithm to analyze the time-domain data
          %
          if (QmatNMR.MEMOrder == -1)
            QTEMP2 = lpc(QTEMP12);
          else
            QTEMP2 = lpc(QTEMP12, QmatNMR.MEMOrder);
          end
    
          %
          %reconstruct the new FID from the filter coefficients
          %
          QTEMP12 = filter([1 zeros(1, QmatNMR.MEMOrder)], QTEMP2, [QTEMP10(1, QTEMP40) zeros(1, QmatNMR.MEMNrPoints-1)]);
        end
  
  
        if (QmatNMR.HyperComplex)
          QTEMP13 = QTEMP11(1:QmatNMR.MEMNrPointsToUse, QTEMP40);
          if (norm(QTEMP12) > 100*eps)
            %
            %use the lpc algorithm to analyze the time-domain data
            %
            if (QmatNMR.MEMOrder == -1)
              QTEMP2 = lpc(QTEMP13);
            else
              QTEMP2 = lpc(QTEMP13, QmatNMR.MEMOrder);
            end
      
            %
            %reconstruct the new FID from the filter coefficients
            %
            QTEMP13 = filter([1 zeros(1, QmatNMR.MEMOrder)], QTEMP2, [QTEMP11(1, QTEMP40) zeros(1, QmatNMR.MEMNrPoints-1)]);
          end
        end
  
  
        %
        %put result in the matrix
        %
        if (QmatNMR.HyperComplex)
          QmatNMR.Spec2D( 1:QmatNMR.MEMNrPoints , QTEMP40) = (real(QTEMP12) + Qi*real(QTEMP13)).';
          QmatNMR.Spec2Dhc( 1:QmatNMR.MEMNrPoints , QTEMP40) = (imag(QTEMP12) + Qi*imag(QTEMP13)).';
  
        else
          if ((QmatNMR.howFT == 1) | (QmatNMR.howFT == 5) | (QmatNMR.howFT == 7))	%Complex FT and Whole Echo and Bruker qseq
            QmatNMR.Spec2D( 1:QmatNMR.MEMNrPoints , QTEMP40) = QTEMP12.';
          else
            QmatNMR.Spec2D( 1:QmatNMR.MEMNrPoints , QTEMP40) = real(QTEMP12).';
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
    QmatNMR.History = str2mat(QmatNMR.History, ['Maximum entropy reconstruction:  on TD ' num2str(QmatNMR.Dim) ', LPC, ' num2str(QmatNMR.MEMNrPoints, 6) ' points in reconstructed FID, ' num2str(QmatNMR.MEMNrPointsToUse, 6) ' points used to do prediction, to order ' num2str(QmatNMR.MEMOrder, 6)]);
  
  
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
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 133, QmatNMR.MEMNrPoints, QmatNMR.MEMNrPointsToUse, QmatNMR.MEMOrder, QmatNMR.Dim, QmatNMR.howFT);  %code for MEM 2D
  
    if QmatNMR.RecordingMacro
      %first add dimension-specific information, and then the current command
      if (QmatNMR.Dim == 1)		%TD2
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
      
      else
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
      end
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 133, QmatNMR.MEMNrPoints, QmatNMR.MEMNrPointsToUse, QmatNMR.MEMOrder, QmatNMR.Dim, QmatNMR.howFT);  %code for MEM 2D
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
  
    disp('2D maximum entropy reconstruction finished ...');
  else
    disp('No maximum entropy reconstruction performed.');
  end   
  
  clear Qi QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
