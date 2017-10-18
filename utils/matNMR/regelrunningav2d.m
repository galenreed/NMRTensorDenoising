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
%regelrunningav2d.m performs the solvent suppression routine as described
%	by Marion, Ikura and Bax in Journal of Magnetic Resonance, 84, 425-430 (1989)
% 	Instead of the high-frequency component being kept, we now keep the low-frequency component.
%
%01-04-'10

try
  if QmatNMR.buttonList == 1						%= OK-button
    watch
  
    %
    %create entry in the undo matrix
    %
    regelUNDO
  
    QmatNMR.SolventSuppressionWindow = QmatNMR.uiInput1;
    QmatNMR.SolventSuppressionWidth = eval(QmatNMR.uiInput2);
    QmatNMR.SolventSuppressionExtrapolate = eval(QmatNMR.uiInput3);
   
  
    %
    %read FT mode
    %
    QmatNMR.howFT = get(QmatNMR.Four, 'value');		%what type of FT is currently selected
    Qi = sqrt(-1);
  
  
    %
    %unless both dimensions are FIDs we allow for the user to specify the regions of interest, in order to
    %speed up the SD (i.e. not to do SD on noise as this is pointless)
    %
    if (~QmatNMR.BusyWithMacro)
      QmatNMR.SDPeakList = [];
      if ((QmatNMR.FIDstatus2D1 == 2) & (QmatNMR.FIDstatus2D2 == 2))
      elseif ((QmatNMR.Dim == 1) & (QmatNMR.FIDstatus2D2 == 1))
        defpeaksSD
      elseif ((QmatNMR.Dim == 2) & (QmatNMR.FIDstatus2D1 == 1))
        defpeaksSD
      end
    end
  
    if isempty(QmatNMR.SDPeakList)
      if (QmatNMR.Dim == 1)
        QmatNMR.SDPeakList = 1:QmatNMR.SizeTD1;
        
      else
        QmatNMR.SDPeakList = 1:QmatNMR.SizeTD2;
      end
      QmatNMR.SDPeakListIndices = [];
    end
  
  
    %
    %execute the running average
    %
    if (QmatNMR.Dim == 1)				%TD 2
      QTEMP3 = -QmatNMR.SolventSuppressionWidth:QmatNMR.SolventSuppressionWidth;
      QTEMP1 = zeros(QmatNMR.SizeTD1, QmatNMR.SizeTD2);	%the matrix for the real values of QmatNMR.Spec2D
      QTEMP4 = zeros(QmatNMR.SizeTD1, QmatNMR.SizeTD2);	%the matrix for the imaginary values of QmatNMR.Spec2D
  
      if (QmatNMR.SolventSuppressionWindow == 1) 		%use gaussian window function
        %
        %First we calculate the normalization factor
        %
        QmatNMR.NormalizationFactor = sum(exp(-4*QTEMP3.^2/QmatNMR.SolventSuppressionWidth^2));
        QTEMP5 = (exp(-4*QTEMP3.^2/QmatNMR.SolventSuppressionWidth^2));
  
        QmatNMR.History = str2mat(QmatNMR.History, ['Running average performed on TD 2 with Gaussian, width=' num2str(QmatNMR.SolventSuppressionWidth) ', jump size extrapolation=' num2str(QmatNMR.SolventSuppressionExtrapolate)]);
    
      elseif (QmatNMR.SolventSuppressionWindow == 2) 	%use sine-bell function
        %
        %First we calculate the normalization factor
        %
        QmatNMR.NormalizationFactor = sum(cos(QTEMP3*pi/(2*QmatNMR.SolventSuppressionWidth+2)));
        QTEMP5 = (cos(QTEMP3*pi/(2*QmatNMR.SolventSuppressionWidth+2)));
    
        QmatNMR.History = str2mat(QmatNMR.History, ['Running average performed on TD 2 with Sine-Bell, width=' num2str(QmatNMR.SolventSuppressionWidth) ', jump size extrapolation=' num2str(QmatNMR.SolventSuppressionExtrapolate)]);
        
      else  					%use rectangular function
        %
        %First we calculate the normalization factor
        %
        QmatNMR.NormalizationFactor = 2*QmatNMR.SolventSuppressionWidth+1;
        QTEMP5 = ones(1, length(QTEMP3));
    
        QmatNMR.History = str2mat(QmatNMR.History, ['Running average performed on TD 2 with Rectangle, width=' num2str(QmatNMR.SolventSuppressionWidth) ', jump size extrapolation=' num2str(QmatNMR.SolventSuppressionExtrapolate)]);
      end
  
  
      if ~((QmatNMR.howFT == 3) | (QmatNMR.howFT == 6))	%anything but States or States-TPPI
        %
        %Then we calculate all the points that need not be extrapolated
        %
        for QTEMP2=1:(2*QmatNMR.SolventSuppressionWidth+1)
          QTEMP1(QmatNMR.SDPeakList, (1+QmatNMR.SolventSuppressionWidth):(QmatNMR.SizeTD2-QmatNMR.SolventSuppressionWidth)) = QTEMP1(QmatNMR.SDPeakList, (1+QmatNMR.SolventSuppressionWidth):(QmatNMR.SizeTD2-QmatNMR.SolventSuppressionWidth)) + QTEMP5(QTEMP2) .*(real(QmatNMR.Spec2D(QmatNMR.SDPeakList, ((1+QmatNMR.SolventSuppressionWidth):(QmatNMR.SizeTD2-QmatNMR.SolventSuppressionWidth)) + QTEMP2 - QmatNMR.SolventSuppressionWidth - 1)));
          QTEMP4(QmatNMR.SDPeakList, (1+QmatNMR.SolventSuppressionWidth):(QmatNMR.SizeTD2-QmatNMR.SolventSuppressionWidth)) = QTEMP4(QmatNMR.SDPeakList, (1+QmatNMR.SolventSuppressionWidth):(QmatNMR.SizeTD2-QmatNMR.SolventSuppressionWidth)) + QTEMP5(QTEMP2) .*(imag(QmatNMR.Spec2D(QmatNMR.SDPeakList, ((1+QmatNMR.SolventSuppressionWidth):(QmatNMR.SizeTD2-QmatNMR.SolventSuppressionWidth)) + QTEMP2 - QmatNMR.SolventSuppressionWidth - 1)));
        end
    
        %
        %And finally we calculate all the points that must be extrapolated
        %
        %start of the FID
        QTEMP2 = (QTEMP1(QmatNMR.SDPeakList, QmatNMR.SolventSuppressionWidth+1)-QTEMP1(QmatNMR.SDPeakList, QmatNMR.SolventSuppressionWidth+QmatNMR.SolventSuppressionExtrapolate))/QmatNMR.SolventSuppressionExtrapolate;
        QTEMP1(QmatNMR.SDPeakList, 1:QmatNMR.SolventSuppressionWidth) = QTEMP1(QmatNMR.SDPeakList, QmatNMR.SolventSuppressionWidth+1)*ones(1, QmatNMR.SolventSuppressionWidth) + QTEMP2*(QmatNMR.SolventSuppressionWidth:-1:1);
    
        QTEMP2 = (QTEMP4(QmatNMR.SDPeakList, QmatNMR.SolventSuppressionWidth+1)-QTEMP4(QmatNMR.SDPeakList, QmatNMR.SolventSuppressionWidth+QmatNMR.SolventSuppressionExtrapolate))/QmatNMR.SolventSuppressionExtrapolate;
        QTEMP4(QmatNMR.SDPeakList, 1:QmatNMR.SolventSuppressionWidth) = QTEMP4(QmatNMR.SDPeakList, QmatNMR.SolventSuppressionWidth+1)*ones(1, QmatNMR.SolventSuppressionWidth) + QTEMP2*(QmatNMR.SolventSuppressionWidth:-1:1);
    
        %end of the FID    
        QTEMP2 = (-QTEMP1(QmatNMR.SDPeakList, QmatNMR.SizeTD2-QmatNMR.SolventSuppressionWidth)+QTEMP1(QmatNMR.SDPeakList, QmatNMR.SizeTD2-QmatNMR.SolventSuppressionWidth-QmatNMR.SolventSuppressionExtrapolate+1))/QmatNMR.SolventSuppressionExtrapolate;
        QTEMP1(QmatNMR.SDPeakList, (QmatNMR.SizeTD2-QmatNMR.SolventSuppressionWidth+1):QmatNMR.SizeTD2 ) = QTEMP1(QmatNMR.SDPeakList, QmatNMR.SizeTD2-QmatNMR.SolventSuppressionWidth)*ones(1, QmatNMR.SolventSuppressionWidth) + QTEMP2*(1:QmatNMR.SolventSuppressionWidth);
    
        QTEMP2 = (-QTEMP4(QmatNMR.SDPeakList, QmatNMR.SizeTD2-QmatNMR.SolventSuppressionWidth)+QTEMP4(QmatNMR.SDPeakList, QmatNMR.SizeTD2-QmatNMR.SolventSuppressionWidth-QmatNMR.SolventSuppressionExtrapolate+1))/QmatNMR.SolventSuppressionExtrapolate;
        QTEMP4(QmatNMR.SDPeakList, (QmatNMR.SizeTD2-QmatNMR.SolventSuppressionWidth+1):QmatNMR.SizeTD2 ) = QTEMP4(QmatNMR.SDPeakList, QmatNMR.SizeTD2-QmatNMR.SolventSuppressionWidth)*ones(1, QmatNMR.SolventSuppressionWidth) + QTEMP2*(1:QmatNMR.SolventSuppressionWidth);
    
    
        %
        %And we substract the matrix from the original matrix
        %
        QmatNMR.Spec2D = ((QTEMP1 + Qi*QTEMP4)/QmatNMR.NormalizationFactor);
  
      else	%States or States-TPPI
        QTEMP6 = zeros(QmatNMR.SizeTD1, QmatNMR.SizeTD2);	    %the matrix for the real values of QmatNMR.Spec2Dhc
        QTEMP7 = zeros(QmatNMR.SizeTD1, QmatNMR.SizeTD2);	    %the matrix for the imaginary values of QmatNMR.Spec2Dhc
  
        %
        %Then we calculate all the points that need not be extrapolated
        %
        for QTEMP2=1:(2*QmatNMR.SolventSuppressionWidth+1)
          QTEMP1(QmatNMR.SDPeakList, (1+QmatNMR.SolventSuppressionWidth):(QmatNMR.SizeTD2-QmatNMR.SolventSuppressionWidth)) = QTEMP1(QmatNMR.SDPeakList, (1+QmatNMR.SolventSuppressionWidth):(QmatNMR.SizeTD2-QmatNMR.SolventSuppressionWidth)) + QTEMP5(QTEMP2) .*(real(QmatNMR.Spec2D(QmatNMR.SDPeakList, ((1+QmatNMR.SolventSuppressionWidth):(QmatNMR.SizeTD2-QmatNMR.SolventSuppressionWidth)) + QTEMP2 - QmatNMR.SolventSuppressionWidth - 1)));
          QTEMP4(QmatNMR.SDPeakList, (1+QmatNMR.SolventSuppressionWidth):(QmatNMR.SizeTD2-QmatNMR.SolventSuppressionWidth)) = QTEMP4(QmatNMR.SDPeakList, (1+QmatNMR.SolventSuppressionWidth):(QmatNMR.SizeTD2-QmatNMR.SolventSuppressionWidth)) + QTEMP5(QTEMP2) .*(imag(QmatNMR.Spec2D(QmatNMR.SDPeakList, ((1+QmatNMR.SolventSuppressionWidth):(QmatNMR.SizeTD2-QmatNMR.SolventSuppressionWidth)) + QTEMP2 - QmatNMR.SolventSuppressionWidth - 1)));
          QTEMP6(QmatNMR.SDPeakList, (1+QmatNMR.SolventSuppressionWidth):(QmatNMR.SizeTD2-QmatNMR.SolventSuppressionWidth)) = QTEMP6(QmatNMR.SDPeakList, (1+QmatNMR.SolventSuppressionWidth):(QmatNMR.SizeTD2-QmatNMR.SolventSuppressionWidth)) + QTEMP5(QTEMP2) .*(real(QmatNMR.Spec2Dhc(QmatNMR.SDPeakList, ((1+QmatNMR.SolventSuppressionWidth):(QmatNMR.SizeTD2-QmatNMR.SolventSuppressionWidth)) + QTEMP2 - QmatNMR.SolventSuppressionWidth - 1)));
          QTEMP7(QmatNMR.SDPeakList, (1+QmatNMR.SolventSuppressionWidth):(QmatNMR.SizeTD2-QmatNMR.SolventSuppressionWidth)) = QTEMP7(QmatNMR.SDPeakList, (1+QmatNMR.SolventSuppressionWidth):(QmatNMR.SizeTD2-QmatNMR.SolventSuppressionWidth)) + QTEMP5(QTEMP2) .*(imag(QmatNMR.Spec2Dhc(QmatNMR.SDPeakList, ((1+QmatNMR.SolventSuppressionWidth):(QmatNMR.SizeTD2-QmatNMR.SolventSuppressionWidth)) + QTEMP2 - QmatNMR.SolventSuppressionWidth - 1)));
        end
    
        %
        %And finally we calculate all the points that must be extrapolated
        %
        %start of the FID
        QTEMP2 = (QTEMP1(QmatNMR.SDPeakList, QmatNMR.SolventSuppressionWidth+1)-QTEMP1(QmatNMR.SDPeakList, QmatNMR.SolventSuppressionWidth+QmatNMR.SolventSuppressionExtrapolate))/QmatNMR.SolventSuppressionExtrapolate;
        QTEMP1(QmatNMR.SDPeakList, 1:QmatNMR.SolventSuppressionWidth) = QTEMP1(QmatNMR.SDPeakList, QmatNMR.SolventSuppressionWidth+1)*ones(1, QmatNMR.SolventSuppressionWidth) + QTEMP2*(QmatNMR.SolventSuppressionWidth:-1:1);
    
        QTEMP2 = (QTEMP4(QmatNMR.SDPeakList, QmatNMR.SolventSuppressionWidth+1)-QTEMP4(QmatNMR.SDPeakList, QmatNMR.SolventSuppressionWidth+QmatNMR.SolventSuppressionExtrapolate))/QmatNMR.SolventSuppressionExtrapolate;
        QTEMP4(QmatNMR.SDPeakList, 1:QmatNMR.SolventSuppressionWidth) = QTEMP4(QmatNMR.SDPeakList, QmatNMR.SolventSuppressionWidth+1)*ones(1, QmatNMR.SolventSuppressionWidth) + QTEMP2*(QmatNMR.SolventSuppressionWidth:-1:1);
    
        QTEMP2 = (QTEMP6(QmatNMR.SDPeakList, QmatNMR.SolventSuppressionWidth+1)-QTEMP6(QmatNMR.SDPeakList, QmatNMR.SolventSuppressionWidth+QmatNMR.SolventSuppressionExtrapolate))/QmatNMR.SolventSuppressionExtrapolate;
        QTEMP6(QmatNMR.SDPeakList, 1:QmatNMR.SolventSuppressionWidth) = QTEMP6(QmatNMR.SDPeakList, QmatNMR.SolventSuppressionWidth+1)*ones(1, QmatNMR.SolventSuppressionWidth) + QTEMP2*(QmatNMR.SolventSuppressionWidth:-1:1);
    
        QTEMP2 = (QTEMP7(QmatNMR.SDPeakList, QmatNMR.SolventSuppressionWidth+1)-QTEMP7(QmatNMR.SDPeakList, QmatNMR.SolventSuppressionWidth+QmatNMR.SolventSuppressionExtrapolate))/QmatNMR.SolventSuppressionExtrapolate;
        QTEMP7(QmatNMR.SDPeakList, 1:QmatNMR.SolventSuppressionWidth) = QTEMP7(QmatNMR.SDPeakList, QmatNMR.SolventSuppressionWidth+1)*ones(1, QmatNMR.SolventSuppressionWidth) + QTEMP2*(QmatNMR.SolventSuppressionWidth:-1:1);
    
        %end of the FID    
        QTEMP2 = (-QTEMP1(QmatNMR.SDPeakList, QmatNMR.SizeTD2-QmatNMR.SolventSuppressionWidth)+QTEMP1(QmatNMR.SDPeakList, QmatNMR.SizeTD2-QmatNMR.SolventSuppressionWidth-QmatNMR.SolventSuppressionExtrapolate+1))/QmatNMR.SolventSuppressionExtrapolate;
        QTEMP1(QmatNMR.SDPeakList, (QmatNMR.SizeTD2-QmatNMR.SolventSuppressionWidth+1):QmatNMR.SizeTD2 ) = QTEMP1(QmatNMR.SDPeakList, QmatNMR.SizeTD2-QmatNMR.SolventSuppressionWidth)*ones(1, QmatNMR.SolventSuppressionWidth) + QTEMP2*(1:QmatNMR.SolventSuppressionWidth);
    
        QTEMP2 = (-QTEMP4(QmatNMR.SDPeakList, QmatNMR.SizeTD2-QmatNMR.SolventSuppressionWidth)+QTEMP4(QmatNMR.SDPeakList, QmatNMR.SizeTD2-QmatNMR.SolventSuppressionWidth-QmatNMR.SolventSuppressionExtrapolate+1))/QmatNMR.SolventSuppressionExtrapolate;
        QTEMP4(QmatNMR.SDPeakList, (QmatNMR.SizeTD2-QmatNMR.SolventSuppressionWidth+1):QmatNMR.SizeTD2 ) = QTEMP4(QmatNMR.SDPeakList, QmatNMR.SizeTD2-QmatNMR.SolventSuppressionWidth)*ones(1, QmatNMR.SolventSuppressionWidth) + QTEMP2*(1:QmatNMR.SolventSuppressionWidth);
  
        QTEMP2 = (-QTEMP6(QmatNMR.SDPeakList, QmatNMR.SizeTD2-QmatNMR.SolventSuppressionWidth)+QTEMP6(QmatNMR.SDPeakList, QmatNMR.SizeTD2-QmatNMR.SolventSuppressionWidth-QmatNMR.SolventSuppressionExtrapolate+1))/QmatNMR.SolventSuppressionExtrapolate;
        QTEMP6(QmatNMR.SDPeakList, (QmatNMR.SizeTD2-QmatNMR.SolventSuppressionWidth+1):QmatNMR.SizeTD2 ) = QTEMP6(QmatNMR.SDPeakList, QmatNMR.SizeTD2-QmatNMR.SolventSuppressionWidth)*ones(1, QmatNMR.SolventSuppressionWidth) + QTEMP2*(1:QmatNMR.SolventSuppressionWidth);
    
        QTEMP2 = (-QTEMP7(QmatNMR.SDPeakList, QmatNMR.SizeTD2-QmatNMR.SolventSuppressionWidth)+QTEMP7(QmatNMR.SDPeakList, QmatNMR.SizeTD2-QmatNMR.SolventSuppressionWidth-QmatNMR.SolventSuppressionExtrapolate+1))/QmatNMR.SolventSuppressionExtrapolate;
        QTEMP7(QmatNMR.SDPeakList, (QmatNMR.SizeTD2-QmatNMR.SolventSuppressionWidth+1):QmatNMR.SizeTD2 ) = QTEMP7(QmatNMR.SDPeakList, QmatNMR.SizeTD2-QmatNMR.SolventSuppressionWidth)*ones(1, QmatNMR.SolventSuppressionWidth) + QTEMP2*(1:QmatNMR.SolventSuppressionWidth);
    
    
        %
        %And we substract the matrix from the original matrix
        %
        QmatNMR.Spec2D = ((QTEMP1 + Qi*QTEMP4)/QmatNMR.NormalizationFactor);
        QmatNMR.Spec2Dhc = ((QTEMP6 + Qi*QTEMP7)/QmatNMR.NormalizationFactor);
      end
  
  
      
    else			%TD 1
      QTEMP3 = -QmatNMR.SolventSuppressionWidth:QmatNMR.SolventSuppressionWidth;
      QmatNMR.Spec2D = QmatNMR.Spec2D.';			%transposing the matrix increases the speed of this routine dramatically!!
      					%it takes MATLAB much less time to extract Matrix1(:, 30:600) than it does
  					%to extract Matrix2(30:600, :) and Matrix2 = Matrix1';
      QTEMP1 = zeros(QmatNMR.SizeTD2, QmatNMR.SizeTD1);	%the matrix for the real values of QmatNMR.Spec2D
      QTEMP4 = zeros(QmatNMR.SizeTD2, QmatNMR.SizeTD1);	%the matrix for the imaginary values of QmatNMR.Spec2D
  
      if (QmatNMR.SolventSuppressionWindow == 1) 		%use gaussian window function
        %
        %First we calculate the normalization factor
        %
        QmatNMR.NormalizationFactor = sum(exp(-4*QTEMP3.^2/QmatNMR.SolventSuppressionWidth^2));
        QTEMP5 = (exp(-4*QTEMP3.^2/QmatNMR.SolventSuppressionWidth^2));
  
        QmatNMR.History = str2mat(QmatNMR.History, ['Running average performed on TD 1 with Gaussian, width=' num2str(QmatNMR.SolventSuppressionWidth) ', jump size extrapolation=' num2str(QmatNMR.SolventSuppressionExtrapolate)]);
    
      elseif (QmatNMR.SolventSuppressionWindow == 2) 	%use sine-bell function
        %
        %First we calculate the normalization factor
        %
        QmatNMR.NormalizationFactor = sum(cos(QTEMP3*pi/(2*QmatNMR.SolventSuppressionWidth+2)));
        QTEMP5 = (cos(QTEMP3*pi/(2*QmatNMR.SolventSuppressionWidth+2)));
    
        QmatNMR.History = str2mat(QmatNMR.History, ['Running average performed on TD 1 with Sine-Bell, width=' num2str(QmatNMR.SolventSuppressionWidth) ', jump size extrapolation=' num2str(QmatNMR.SolventSuppressionExtrapolate)]);
        
      else  					%use rectangular function
        %
        %First we calculate the normalization factor
        %
        QmatNMR.NormalizationFactor = 2*QmatNMR.SolventSuppressionWidth+1;
        QTEMP5 = ones(1, length(QTEMP3));
    
        QmatNMR.History = str2mat(QmatNMR.History, ['Running average performed on TD 1 with Rectangle, width=' num2str(QmatNMR.SolventSuppressionWidth) ', jump size extrapolation=' num2str(QmatNMR.SolventSuppressionExtrapolate)]);
      end
  
  
      if ~((QmatNMR.howFT == 3) | (QmatNMR.howFT == 6))	%anything but States or States-TPPI
        %
        %Then we calculate all the points that need not be extrapolated
        %
        for QTEMP2=1:(2*QmatNMR.SolventSuppressionWidth+1)
          QTEMP1(QmatNMR.SDPeakList, (1+QmatNMR.SolventSuppressionWidth):(QmatNMR.SizeTD1-QmatNMR.SolventSuppressionWidth)) = QTEMP1(QmatNMR.SDPeakList, (1+QmatNMR.SolventSuppressionWidth):(QmatNMR.SizeTD1-QmatNMR.SolventSuppressionWidth)) + QTEMP5(QTEMP2) .*(real(QmatNMR.Spec2D(QmatNMR.SDPeakList, ((1+QmatNMR.SolventSuppressionWidth):(QmatNMR.SizeTD1-QmatNMR.SolventSuppressionWidth)) + QTEMP2 - QmatNMR.SolventSuppressionWidth - 1)));
          QTEMP4(QmatNMR.SDPeakList, (1+QmatNMR.SolventSuppressionWidth):(QmatNMR.SizeTD1-QmatNMR.SolventSuppressionWidth)) = QTEMP4(QmatNMR.SDPeakList, (1+QmatNMR.SolventSuppressionWidth):(QmatNMR.SizeTD1-QmatNMR.SolventSuppressionWidth)) + QTEMP5(QTEMP2) .*(imag(QmatNMR.Spec2D(QmatNMR.SDPeakList, ((1+QmatNMR.SolventSuppressionWidth):(QmatNMR.SizeTD1-QmatNMR.SolventSuppressionWidth)) + QTEMP2 - QmatNMR.SolventSuppressionWidth - 1)));
        end
    
        %
        %And finally we calculate all the points that must be extrapolated
        %
        %start of the FID
        QTEMP2 = (QTEMP1(QmatNMR.SDPeakList, QmatNMR.SolventSuppressionWidth+1)-QTEMP1(QmatNMR.SDPeakList, QmatNMR.SolventSuppressionWidth+QmatNMR.SolventSuppressionExtrapolate))/QmatNMR.SolventSuppressionExtrapolate;
        QTEMP1(QmatNMR.SDPeakList, 1:QmatNMR.SolventSuppressionWidth) = QTEMP1(QmatNMR.SDPeakList, QmatNMR.SolventSuppressionWidth+1)*ones(1, QmatNMR.SolventSuppressionWidth) + QTEMP2*(QmatNMR.SolventSuppressionWidth:-1:1);
    
        QTEMP2 = (QTEMP4(QmatNMR.SDPeakList, QmatNMR.SolventSuppressionWidth+1)-QTEMP4(QmatNMR.SDPeakList, QmatNMR.SolventSuppressionWidth+QmatNMR.SolventSuppressionExtrapolate))/QmatNMR.SolventSuppressionExtrapolate;
        QTEMP4(QmatNMR.SDPeakList, 1:QmatNMR.SolventSuppressionWidth) = QTEMP4(QmatNMR.SDPeakList, QmatNMR.SolventSuppressionWidth+1)*ones(1, QmatNMR.SolventSuppressionWidth) + QTEMP2*(QmatNMR.SolventSuppressionWidth:-1:1);
    
        %end of the FID    
        QTEMP2 = (-QTEMP1(QmatNMR.SDPeakList, QmatNMR.SizeTD1-QmatNMR.SolventSuppressionWidth)+QTEMP1(QmatNMR.SDPeakList, QmatNMR.SizeTD1-QmatNMR.SolventSuppressionWidth-QmatNMR.SolventSuppressionExtrapolate+1))/QmatNMR.SolventSuppressionExtrapolate;
        QTEMP1(QmatNMR.SDPeakList, (QmatNMR.SizeTD1-QmatNMR.SolventSuppressionWidth+1):QmatNMR.SizeTD1 ) = QTEMP1(QmatNMR.SDPeakList, QmatNMR.SizeTD1-QmatNMR.SolventSuppressionWidth)*ones(1, QmatNMR.SolventSuppressionWidth) + QTEMP2*(1:QmatNMR.SolventSuppressionWidth);
    
        QTEMP2 = (-QTEMP4(QmatNMR.SDPeakList, QmatNMR.SizeTD1-QmatNMR.SolventSuppressionWidth)+QTEMP4(QmatNMR.SDPeakList, QmatNMR.SizeTD1-QmatNMR.SolventSuppressionWidth-QmatNMR.SolventSuppressionExtrapolate+1))/QmatNMR.SolventSuppressionExtrapolate;
        QTEMP4(QmatNMR.SDPeakList, (QmatNMR.SizeTD1-QmatNMR.SolventSuppressionWidth+1):QmatNMR.SizeTD1 ) = QTEMP4(QmatNMR.SDPeakList, QmatNMR.SizeTD1-QmatNMR.SolventSuppressionWidth)*ones(1, QmatNMR.SolventSuppressionWidth) + QTEMP2*(1:QmatNMR.SolventSuppressionWidth);
    
    
        %
        %We keep the low-frequency component AND we transpose the matrix again
        %
        QmatNMR.Spec2D = ((QTEMP1 + Qi*QTEMP4)/QmatNMR.NormalizationFactor).';
  
      else	%States or States-TPPI
        QmatNMR.Spec2Dhc = QmatNMR.Spec2Dhc.';			%transposing the matrix increases the speed of this routine dramatically!!
      					%it takes MATLAB much less time to extract Matrix1(:, 30:600) than it does
  					%to extract Matrix2(30:600, :) and Matrix2 = Matrix1';
        QTEMP6 = zeros(QmatNMR.SizeTD2, QmatNMR.SizeTD1);	%the matrix for the real values of QmatNMR.Spec2Dhc
        QTEMP7 = zeros(QmatNMR.SizeTD2, QmatNMR.SizeTD1);	%the matrix for the imaginary values of QmatNMR.Spec2Dhc
  
        %
        %Then we calculate all the points that need not be extrapolated
        %
        for QTEMP2=1:(2*QmatNMR.SolventSuppressionWidth+1)
          QTEMP1(QmatNMR.SDPeakList, (1+QmatNMR.SolventSuppressionWidth):(QmatNMR.SizeTD1-QmatNMR.SolventSuppressionWidth)) = QTEMP1(QmatNMR.SDPeakList, (1+QmatNMR.SolventSuppressionWidth):(QmatNMR.SizeTD1-QmatNMR.SolventSuppressionWidth)) + QTEMP5(QTEMP2) .*(real(QmatNMR.Spec2D(QmatNMR.SDPeakList, ((1+QmatNMR.SolventSuppressionWidth):(QmatNMR.SizeTD1-QmatNMR.SolventSuppressionWidth)) + QTEMP2 - QmatNMR.SolventSuppressionWidth - 1)));
          QTEMP4(QmatNMR.SDPeakList, (1+QmatNMR.SolventSuppressionWidth):(QmatNMR.SizeTD1-QmatNMR.SolventSuppressionWidth)) = QTEMP4(QmatNMR.SDPeakList, (1+QmatNMR.SolventSuppressionWidth):(QmatNMR.SizeTD1-QmatNMR.SolventSuppressionWidth)) + QTEMP5(QTEMP2) .*(imag(QmatNMR.Spec2D(QmatNMR.SDPeakList, ((1+QmatNMR.SolventSuppressionWidth):(QmatNMR.SizeTD1-QmatNMR.SolventSuppressionWidth)) + QTEMP2 - QmatNMR.SolventSuppressionWidth - 1)));
          QTEMP6(QmatNMR.SDPeakList, (1+QmatNMR.SolventSuppressionWidth):(QmatNMR.SizeTD1-QmatNMR.SolventSuppressionWidth)) = QTEMP6(QmatNMR.SDPeakList, (1+QmatNMR.SolventSuppressionWidth):(QmatNMR.SizeTD1-QmatNMR.SolventSuppressionWidth)) + QTEMP5(QTEMP2) .*(real(QmatNMR.Spec2Dhc(QmatNMR.SDPeakList, ((1+QmatNMR.SolventSuppressionWidth):(QmatNMR.SizeTD1-QmatNMR.SolventSuppressionWidth)) + QTEMP2 - QmatNMR.SolventSuppressionWidth - 1)));
          QTEMP7(QmatNMR.SDPeakList, (1+QmatNMR.SolventSuppressionWidth):(QmatNMR.SizeTD1-QmatNMR.SolventSuppressionWidth)) = QTEMP7(QmatNMR.SDPeakList, (1+QmatNMR.SolventSuppressionWidth):(QmatNMR.SizeTD1-QmatNMR.SolventSuppressionWidth)) + QTEMP5(QTEMP2) .*(imag(QmatNMR.Spec2Dhc(QmatNMR.SDPeakList, ((1+QmatNMR.SolventSuppressionWidth):(QmatNMR.SizeTD1-QmatNMR.SolventSuppressionWidth)) + QTEMP2 - QmatNMR.SolventSuppressionWidth - 1)));
        end
    
        %
        %And finally we calculate all the points that must be extrapolated
        %
        %start of the FID
        QTEMP2 = (QTEMP1(QmatNMR.SDPeakList, QmatNMR.SolventSuppressionWidth+1)-QTEMP1(QmatNMR.SDPeakList, QmatNMR.SolventSuppressionWidth+QmatNMR.SolventSuppressionExtrapolate))/QmatNMR.SolventSuppressionExtrapolate;
        QTEMP1(QmatNMR.SDPeakList, 1:QmatNMR.SolventSuppressionWidth) = QTEMP1(QmatNMR.SDPeakList, QmatNMR.SolventSuppressionWidth+1)*ones(1, QmatNMR.SolventSuppressionWidth) + QTEMP2*(QmatNMR.SolventSuppressionWidth:-1:1);
    
        QTEMP2 = (QTEMP4(QmatNMR.SDPeakList, QmatNMR.SolventSuppressionWidth+1)-QTEMP4(QmatNMR.SDPeakList, QmatNMR.SolventSuppressionWidth+QmatNMR.SolventSuppressionExtrapolate))/QmatNMR.SolventSuppressionExtrapolate;
        QTEMP4(QmatNMR.SDPeakList, 1:QmatNMR.SolventSuppressionWidth) = QTEMP4(QmatNMR.SDPeakList, QmatNMR.SolventSuppressionWidth+1)*ones(1, QmatNMR.SolventSuppressionWidth) + QTEMP2*(QmatNMR.SolventSuppressionWidth:-1:1);
    
        QTEMP2 = (QTEMP6(QmatNMR.SDPeakList, QmatNMR.SolventSuppressionWidth+1)-QTEMP6(QmatNMR.SDPeakList, QmatNMR.SolventSuppressionWidth+QmatNMR.SolventSuppressionExtrapolate))/QmatNMR.SolventSuppressionExtrapolate;
        QTEMP6(QmatNMR.SDPeakList, 1:QmatNMR.SolventSuppressionWidth) = QTEMP6(QmatNMR.SDPeakList, QmatNMR.SolventSuppressionWidth+1)*ones(1, QmatNMR.SolventSuppressionWidth) + QTEMP2*(QmatNMR.SolventSuppressionWidth:-1:1);
    
        QTEMP2 = (QTEMP7(QmatNMR.SDPeakList, QmatNMR.SolventSuppressionWidth+1)-QTEMP7(QmatNMR.SDPeakList, QmatNMR.SolventSuppressionWidth+QmatNMR.SolventSuppressionExtrapolate))/QmatNMR.SolventSuppressionExtrapolate;
        QTEMP7(QmatNMR.SDPeakList, 1:QmatNMR.SolventSuppressionWidth) = QTEMP7(QmatNMR.SDPeakList, QmatNMR.SolventSuppressionWidth+1)*ones(1, QmatNMR.SolventSuppressionWidth) + QTEMP2*(QmatNMR.SolventSuppressionWidth:-1:1);
    
        %end of the FID    
        QTEMP2 = (-QTEMP1(QmatNMR.SDPeakList, QmatNMR.SizeTD1-QmatNMR.SolventSuppressionWidth)+QTEMP1(QmatNMR.SDPeakList, QmatNMR.SizeTD1-QmatNMR.SolventSuppressionWidth-QmatNMR.SolventSuppressionExtrapolate+1))/QmatNMR.SolventSuppressionExtrapolate;
        QTEMP1(QmatNMR.SDPeakList, (QmatNMR.SizeTD1-QmatNMR.SolventSuppressionWidth+1):QmatNMR.SizeTD1 ) = QTEMP1(QmatNMR.SDPeakList, QmatNMR.SizeTD1-QmatNMR.SolventSuppressionWidth)*ones(1, QmatNMR.SolventSuppressionWidth) + QTEMP2*(1:QmatNMR.SolventSuppressionWidth);
    
        QTEMP2 = (-QTEMP4(QmatNMR.SDPeakList, QmatNMR.SizeTD1-QmatNMR.SolventSuppressionWidth)+QTEMP4(QmatNMR.SDPeakList, QmatNMR.SizeTD1-QmatNMR.SolventSuppressionWidth-QmatNMR.SolventSuppressionExtrapolate+1))/QmatNMR.SolventSuppressionExtrapolate;
        QTEMP4(QmatNMR.SDPeakList, (QmatNMR.SizeTD1-QmatNMR.SolventSuppressionWidth+1):QmatNMR.SizeTD1 ) = QTEMP4(QmatNMR.SDPeakList, QmatNMR.SizeTD1-QmatNMR.SolventSuppressionWidth)*ones(1, QmatNMR.SolventSuppressionWidth) + QTEMP2*(1:QmatNMR.SolventSuppressionWidth);
    
        QTEMP2 = (-QTEMP6(QmatNMR.SDPeakList, QmatNMR.SizeTD1-QmatNMR.SolventSuppressionWidth)+QTEMP6(QmatNMR.SDPeakList, QmatNMR.SizeTD1-QmatNMR.SolventSuppressionWidth-QmatNMR.SolventSuppressionExtrapolate+1))/QmatNMR.SolventSuppressionExtrapolate;
        QTEMP6(QmatNMR.SDPeakList, (QmatNMR.SizeTD1-QmatNMR.SolventSuppressionWidth+1):QmatNMR.SizeTD1 ) = QTEMP6(QmatNMR.SDPeakList, QmatNMR.SizeTD1-QmatNMR.SolventSuppressionWidth)*ones(1, QmatNMR.SolventSuppressionWidth) + QTEMP2*(1:QmatNMR.SolventSuppressionWidth);
    
        QTEMP2 = (-QTEMP7(QmatNMR.SDPeakList, QmatNMR.SizeTD1-QmatNMR.SolventSuppressionWidth)+QTEMP7(QmatNMR.SDPeakList, QmatNMR.SizeTD1-QmatNMR.SolventSuppressionWidth-QmatNMR.SolventSuppressionExtrapolate+1))/QmatNMR.SolventSuppressionExtrapolate;
        QTEMP7(QmatNMR.SDPeakList, (QmatNMR.SizeTD1-QmatNMR.SolventSuppressionWidth+1):QmatNMR.SizeTD1 ) = QTEMP7(QmatNMR.SDPeakList, QmatNMR.SizeTD1-QmatNMR.SolventSuppressionWidth)*ones(1, QmatNMR.SolventSuppressionWidth) + QTEMP2*(1:QmatNMR.SolventSuppressionWidth);
    
    
        %
        %We keep the low-frequency component AND we transpose the matrix again
        %
        QmatNMR.Spec2D = ((QTEMP1 + Qi*QTEMP4)/QmatNMR.NormalizationFactor).';
        QmatNMR.Spec2Dhc = ((QTEMP6 + Qi*QTEMP7)/QmatNMR.NormalizationFactor).';
      end
    end
  
  
    %
    %To finish off ...
    %  
    QTEMP1 = 0;		%clear variables
    QTEMP4 = 0;
    QTEMP6 = 0;
    QTEMP7 = 0;
    getcurrentspectrum	%get current spectrum
  
    
    %
    %take care of the history macro
    %
  
    %add the peak list into the macro ...
    QTEMP2 = ceil(length(QmatNMR.SDPeakListIndices)/(QmatNMR.MacroLength-1));
    QTEMP = zeros(1, QTEMP2*(QmatNMR.MacroLength-1));
    QTEMP(1:length(QmatNMR.SDPeakListIndices)) = QmatNMR.SDPeakListIndices;
    for QTEMP40=1:QTEMP2
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 128, QTEMP((QTEMP40-1)*(QmatNMR.MacroLength-1)+ (1:(QmatNMR.MacroLength-1))));
      
      if QmatNMR.RecordingMacro
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 128, QTEMP((QTEMP40-1)*(QmatNMR.MacroLength-1)+ (1:(QmatNMR.MacroLength-1))));
      end
    end
    QmatNMR.SDPeakListIndices = [];
    QmatNMR.SDPeakList = [];
  
  
    %first add dimension-specific information, and then the current command
    if (QmatNMR.Dim == 1) 		%TD2
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
  
    else
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
    end
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 134, QmatNMR.SolventSuppressionWindow, QmatNMR.SolventSuppressionWidth, QmatNMR.SolventSuppressionExtrapolate, QmatNMR.Dim, QmatNMR.howFT);	%code for solvent suppression 2D
  
    if QmatNMR.RecordingMacro
      %first add dimension-specific information, and then the current command
      if (QmatNMR.Dim == 1)		%TD2
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
  
      else
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
      end
  
      QmatNMR.Macro = AddToMacro(QmatNMR.HistoryMacro, 134, QmatNMR.SolventSuppressionWindow, QmatNMR.SolventSuppressionWidth, QmatNMR.SolventSuppressionExtrapolate, QmatNMR.Dim, QmatNMR.howFT);	%code for solvent suppression 2D
    end
      
    if (~QmatNMR.BusyWithMacro)
      asaanpas
      Arrowhead;
    end
    
    QTEMP = str2mat('TD2', 'TD1');
    disp(['2D running average performed on ' QTEMP(QmatNMR.Dim, :)]);
  
  else
    disp('2D running average cancelled ...');
  end  
  
  clear QTEMP* Qi

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
