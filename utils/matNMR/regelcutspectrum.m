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
%regelcutspectrum.m cuts the current 2D spectrum into slices and glues them together again. This
%is usefull when analysing or plotting 2D spectra with narrow peaks which are spread across a few
%bands in the spectrum.
%lightly based on a routine by Edme Hardy
%04-10-'00

try
  if (QmatNMR.buttonList == 1)
  %
  %Determine the ranges and tickmark positions and linespec for the 
  %separation lines from the input parameters
  %
    QmatNMR.CutRangeTD2 	= sort(eval(['[' QmatNMR.uiInput1 ']']));
    QmatNMR.CutRangeTD1 	= sort(eval(['[' QmatNMR.uiInput2 ']']));
    QmatNMR.CutTicksTD2 	= sort(eval(['[' QmatNMR.uiInput3 ']']));
    QmatNMR.CutTicksTD1 	= sort(eval(['[' QmatNMR.uiInput4 ']']));
    
    QmatNMR.CutSaveVariable = QmatNMR.uiInput5;
  
  
  %
  %Now check the specified ranges
  %
    QmatNMR.TotalCoordsTD2 = length(QmatNMR.CutRangeTD2);
    QmatNMR.TotalCoordsTD1 = length(QmatNMR.CutRangeTD1);
    if (isempty(QmatNMR.CutRangeTD2) | isempty(QmatNMR.CutRangeTD1) | mod(QmatNMR.TotalCoordsTD1, 2) | mod(QmatNMR.TotalCoordsTD2, 2))
      error('matNMR ERROR: lengths of the ranges in TD2 and TD1 are empty or not even numbers. Aborting ...');
  
    else
    %
    %Now determine the ranges in points (now the ranges are still in the units of the axis vectors!)
    %
      %First calculate the slope, offset and linearity of the axes
      QTEMP1 = [(QmatNMR.Axis2D3DTD2(2)-QmatNMR.Axis2D3DTD2(1)) (2*QmatNMR.Axis2D3DTD2(1)-QmatNMR.Axis2D3DTD2(2))];
      QTEMP2 = [(QmatNMR.Axis2D3DTD1(2)-QmatNMR.Axis2D3DTD1(1)) (2*QmatNMR.Axis2D3DTD1(1)-QmatNMR.Axis2D3DTD1(2))];
      if ~LinearAxis(QmatNMR.Axis2D3DTD2)	%if the axis is non-linear set a flag for it!
        QTEMP1(1) = 0;
      end  
      if ~LinearAxis(QmatNMR.Axis2D3DTD1)	%if the axis is non-linear set a flag for it!
        QTEMP2(1) = 0;
      end
      
      %the ranges in points
      if QTEMP1(1)			%linear axis in TD 2 -> use increment and offsets
        QTEMP3 = round((QmatNMR.CutRangeTD2-QTEMP1(2)) ./ QTEMP1(1));
      
      else				%non-linear axis in TD 2 -> use full axis vector
        for QTEMP40 = 1:length(QmatNMR.CutRangeTD2)
          [QTEMP5 QTEMP6] = min(abs(QmatNMR.Axis2D3DTD2 - QmatNMR.CutRangeTD2(QTEMP40)));
          QTEMP3(QTEMP40) = QTEMP6;
        end  
      end  
      QTEMP3 = sort(QTEMP3);
    
      if QTEMP2(1)			%linear axis in TD 1 -> use increment and offsets
        QTEMP4 = round((QmatNMR.CutRangeTD1-QTEMP2(2)) ./ QTEMP2(1));
      
      else				%non-linear axis in TD 1 -> use full axis vector
        for QTEMP40 = 1:length(QmatNMR.CutRangeTD1)
          [QTEMP5 QTEMP6] = min(abs(QmatNMR.Axis2D3DTD1 - QmatNMR.CutRangeTD1(QTEMP40)));
          QTEMP4(QTEMP40) = QTEMP6;
        end  
      end  
      QTEMP4 = sort(QTEMP4);
  
    %
    %Check the ranges for being within the span of the spectrum. When the outside limits 
    %are not within these limits then they will be set to the outer limits. When other
    %points fall outside the limits too then the routine will abort.
    %
      [QTEMP9, QTEMP10] = size(QmatNMR.Spec2D3D);
      %range TD2
      if (QTEMP3(1) < 1)
        QTEMP3(1) = 1;
      end
      
      if (QTEMP3(QmatNMR.TotalCoordsTD2) > QTEMP10)
        QTEMP3(QmatNMR.TotalCoordsTD2) = QTEMP10;
      end  
      
      %range TD1
      if (QTEMP4(1) < 1)
        QTEMP4(1) = 1;
      end
      
      if (QTEMP4(QmatNMR.TotalCoordsTD1) > QTEMP9)
        QTEMP4(QmatNMR.TotalCoordsTD1) = QTEMP9;
      end
  
  
  
    %
    %Define the new spectrum based on these ranges. Between the blocks (i.e. at the cutting line) the
    %value of the matrix is set to NaN. This should prevent problems with other routines like "get Position"
    %(crsshaird2d) and "Peak Picking" (GetPeaks).
    %
      QTEMP5 = [];
      QTEMP6 = [];
      QmatNMR.NewAxisTD2 = [];
      QmatNMR.NewAxisTD1 = [];
      QmatNMR.PosNaNTD2 = 0;
      QmatNMR.PosNaNTD1 = 0;
      %determine the final size of the spectrum in TD2
      for Qtel1=1:2:QmatNMR.TotalCoordsTD2
        QmatNMR.NewAxisTD2 = [QmatNMR.NewAxisTD2 QmatNMR.Axis2D3DTD2(QTEMP3(Qtel1):QTEMP3(Qtel1+1)) NaN];
        QTEMP5 = [QTEMP5 length(QTEMP3(Qtel1):QTEMP3(Qtel1+1))];
      end
      %where do we put the cutting lines in the new matrix?
      for Qtel1=1:(length(QTEMP5)-1)
        QmatNMR.PosNaNTD2(Qtel1) = sum(QTEMP5(1:Qtel1))+Qtel1;
      end  
      %add a 0 at the end to avoid an error in the for-loop while filling the matrix
      QmatNMR.PosNaNTD2 = [QmatNMR.PosNaNTD2 0];
  
    
      %determine the final size of the spectrum in TD1
      for Qtel1=1:2:QmatNMR.TotalCoordsTD1
        QmatNMR.NewAxisTD1 = [QmatNMR.NewAxisTD1 QmatNMR.Axis2D3DTD1(QTEMP4(Qtel1):QTEMP4(Qtel1+1)) NaN];
        QTEMP6 = [QTEMP6 length(QTEMP4(Qtel1):QTEMP4(Qtel1+1))];
      end
      %where do we put the cutting lines in the new matrix?
      for Qtel1=1:(length(QTEMP6)-1)
        QmatNMR.PosNaNTD1(Qtel1) = sum(QTEMP6(1:Qtel1))+Qtel1;
      end
      %add a 0 at the end to avoid an error in the for-loop while filling the matrix
      QmatNMR.PosNaNTD1 = [QmatNMR.PosNaNTD1 0];
  
      
      %create a temporary matrix for the new spectrum
      QTEMP9 = sum(QTEMP6) + QmatNMR.TotalCoordsTD1/2 - 1;
      QTEMP10 = sum(QTEMP5) + QmatNMR.TotalCoordsTD2/2 - 1;
      QTEMP7 = zeros(QTEMP9, QTEMP10);
      QTEMP11 = zeros(1, QTEMP9);
      QTEMP12 = zeros(1, QTEMP10);
  
  
      %fill the new matrix
      QmatNMR.TotalTD1 = 0;
      QmatNMR.TotalTD2 = 0;
      for Qtel1=1:2:QmatNMR.TotalCoordsTD2
        for QTEMP41=1:2:QmatNMR.TotalCoordsTD1
          QTEMP7(QmatNMR.TotalTD1+(1:QTEMP6(ceil(QTEMP41/2))), QmatNMR.TotalTD2+(1:QTEMP5(ceil(Qtel1/2)))) = QmatNMR.Spec2D3D(QTEMP4(QTEMP41):QTEMP4(QTEMP41+1), QTEMP3(Qtel1):QTEMP3(Qtel1+1));
  
  	QTEMP11(QmatNMR.TotalTD1+(1:QTEMP6(ceil(QTEMP41/2)))) = QmatNMR.Axis2D3DTD1(QTEMP4(QTEMP41):QTEMP4(QTEMP41+1));
  	QTEMP12(QmatNMR.TotalTD2+(1:QTEMP5(ceil(Qtel1/2)))) = QmatNMR.Axis2D3DTD2(QTEMP3(Qtel1):QTEMP3(Qtel1+1));
          
  	QmatNMR.TotalTD1 = QmatNMR.PosNaNTD1(ceil(QTEMP41/2));
        end
        QmatNMR.TotalTD2 = QmatNMR.PosNaNTD2(ceil(Qtel1/2));
      end  
  
      %put the NaN's where the cutting lines are
      QTEMP7(:, QmatNMR.PosNaNTD2(1:(QmatNMR.TotalCoordsTD2/2-1))) = NaN;
      QTEMP7(QmatNMR.PosNaNTD1(1:(QmatNMR.TotalCoordsTD1/2-1)), :) = NaN;
  
  
  
      %
      %Store the cut spectrum in a matNMR structure
      %
      QmatNMR.Spec2D3DCutSpectrum = GenerateMatNMRStructure;
      QmatNMR.Spec2D3DCutSpectrum.Spectrum 		= QTEMP7;
      QmatNMR.Spec2D3DCutSpectrum.AxisTD2     		= QTEMP12;
      QmatNMR.Spec2D3DCutSpectrum.AxisTD1    		= QTEMP11;
      QmatNMR.Spec2D3DCutSpectrum.CutSpectrumAxisTD2 	= QTEMP12;
      QmatNMR.Spec2D3DCutSpectrum.CutSpectrumAxisTD1 	= QTEMP11;
      QmatNMR.Spec2D3DCutSpectrum.CutSpectrumTicksTD2 	= QmatNMR.CutTicksTD2;
      QmatNMR.Spec2D3DCutSpectrum.CutSpectrumTicksTD1 	= QmatNMR.CutTicksTD1;
      QmatNMR.Spec2D3DCutSpectrum.CutSpectrumPosNaNTD2 	= QmatNMR.PosNaNTD2;
      QmatNMR.Spec2D3DCutSpectrum.CutSpectrumPosNaNTD1 	= QmatNMR.PosNaNTD1;
    
    
      %
      %Now define the name of the preparated variable, which will be used for the next plot
      %
      QmatNMR.SpecName2D3D = 'QmatNMR.Spec2D3DCutSpectrum';
      QmatNMR.UserDefAxisT2Cont = '';
      QmatNMR.UserDefAxisT1Cont = '';
      
      
      %
      %Save the strip plot in the workspace if asked for
      %
      if ~isempty(QmatNMR.CutSaveVariable)
        try
          eval([QmatNMR.CutSaveVariable ' = QmatNMR.Spec2D3DCutSpectrum;']);
  
        catch
          beep
          disp(['matNMR WARNING: could not store the strip plot as "' QmatNMR.CutSaveVariable '" in the workspace. Please make sure the variable name is allowed.']);
        end
      end
    end
    
    disp('Define Cut Limits finished: current zoom limits will be taken for the next plot when using the variable "QmatNMR.Spec2D3DCutSpectrum".');
  
  else
    disp('Cutting spectrum into slices cancelled ...');
  end  
    
  
  clear QTEMP* Qtel1

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
