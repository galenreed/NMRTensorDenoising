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
%setphase2d.m sets the phase of the current dimension of the 2D FID/Spectrum by taking the current
%values for QmatNMR.fase0 and QmatNMR.fase1start
%
%21-2-1997
%15-12-'00

try
  if (QmatNMR.Dim == 0)
    disp('matNMR NOTICE: 2D processing functions are not allowed in 1D mode!')
  
  else  
    watch;
    
    %
    %create entry in the undo matrix
    %
    regelUNDO
    
    if (QmatNMR.bezigmetfase == 1)
      QmatNMR.howFT = get(QmatNMR.Four, 'value');	%Read current fourier mode
    
      if QmatNMR.Dim == 1	%TD2 := QmatNMR.Dim = 1
        Qi = sqrt(-1)*pi/180;
        QmatNMR.z = -((1:QmatNMR.SizeTD2)-QmatNMR.fase1startIndex)/(QmatNMR.SizeTD2);
        QmatNMR.z2 = -2*(((1:QmatNMR.SizeTD2)-floor(QmatNMR.SizeTD2/2)-1)/(QmatNMR.SizeTD2)).^2;
        QTEMP = (exp(Qi*(QmatNMR.fase0 + QmatNMR.fase1*QmatNMR.z + QmatNMR.fase2*QmatNMR.z2)));
      
        if QmatNMR.SingleSlice 	%operate on a single slice ONLY
          if ((QmatNMR.howFT == 3) | (QmatNMR.howFT == 6))		%States or States-TPPI
            QmatNMR.Spec2D(QmatNMR.rijnr, :) = (QmatNMR.Spec2D(QmatNMR.rijnr, :) .* QTEMP);
            QmatNMR.Spec2Dhc(QmatNMR.rijnr, :) = (QmatNMR.Spec2Dhc(QmatNMR.rijnr, :) .* QTEMP);
      
          else			%other
            QmatNMR.Spec2D(QmatNMR.rijnr, :) = (QmatNMR.Spec2D(QmatNMR.rijnr, :) .* QTEMP);
          end  
  
        else		%operate on the entire matrix
        			%from a test on a Windows machine and a SUN Solaris system this went fastest using 
                          %row-wise muliplications for Matlab 6.5.1 and matrix-wise for Matlab 7.0.4
                          %Jacco, 04-08-2005
          if (QmatNMR.MatlabVersion >= 7)
            QTEMP12 = ((QTEMP.') * ones(1, QmatNMR.SizeTD1)).';
    
            if ((QmatNMR.howFT == 3) | (QmatNMR.howFT == 6))		%States or States-TPPI
              QmatNMR.Spec2D = QmatNMR.Spec2D .* QTEMP12;
              QmatNMR.Spec2Dhc = QmatNMR.Spec2Dhc .* QTEMP12;
        
            else			%other
              QmatNMR.Spec2D = QmatNMR.Spec2D .* QTEMP12;
            end
            QTEMP12 = 0; 		%clear the memory space occupied by the matrix
  
          else		%for older version of Matlab use row-wise multiplications
            QTEMP12 = 1:QmatNMR.SizeTD1;
            QTEMP = QTEMP.';
  
            if ((QmatNMR.howFT == 3) | (QmatNMR.howFT == 6))		%States or States-TPPI
              QmatNMR.Spec2D = QmatNMR.Spec2D.';
              QmatNMR.Spec2Dhc = QmatNMR.Spec2Dhc.';
              for QTEMP40 = QTEMP12
                QmatNMR.Spec2D(:, QTEMP40) = (QmatNMR.Spec2D(:, QTEMP40) .* QTEMP);
                QmatNMR.Spec2Dhc(:, QTEMP40) = (QmatNMR.Spec2Dhc(:, QTEMP40) .* QTEMP);
              end;  
              QmatNMR.Spec2D = QmatNMR.Spec2D.';
              QmatNMR.Spec2Dhc = QmatNMR.Spec2Dhc.';
        
            else			%other
              QmatNMR.Spec2D = QmatNMR.Spec2D.';
              for QTEMP40 = QTEMP12
                QmatNMR.Spec2D(:, QTEMP40) = (QmatNMR.Spec2D(:, QTEMP40) .* QTEMP);
              end;  
              QmatNMR.Spec2D = QmatNMR.Spec2D.';
            end  
          end
        end
  
        if QmatNMR.SingleSlice 	%operate on a single slice only
          if (QmatNMR.fase2)
            QmatNMR.History = str2mat(QmatNMR.History, ['Phase correction for current slice of TD2      :  0th order = ' num2str(QmatNMR.fase0, 5) '   1st order = ' num2str(QmatNMR.fase1, 5) '   2nd order = ' num2str(QmatNMR.fase2, 5) '   ref. peak Ph1 = ' num2str(QmatNMR.fase1start, 5)]);
          else
            QmatNMR.History = str2mat(QmatNMR.History, ['Phase correction for current slice of TD2      :  0th order = ' num2str(QmatNMR.fase0, 5) '   1st order = ' num2str(QmatNMR.fase1, 5) '   ref. peak Ph1 = ' num2str(QmatNMR.fase1start, 5)]);
          end
          disp('phase set for the current slice of the TD2');
  
        else		%operate on the entire matrix
          if (QmatNMR.fase2)
            QmatNMR.History = str2mat(QmatNMR.History, ['Phase correction for TD2      :  0th order = ' num2str(QmatNMR.fase0, 5) '   1st order = ' num2str(QmatNMR.fase1, 5) '   2nd order = ' num2str(QmatNMR.fase2, 5) '   ref. peak Ph1 = ' num2str(QmatNMR.fase1start, 5)]);
          else
            QmatNMR.History = str2mat(QmatNMR.History, ['Phase correction for TD2      :  0th order = ' num2str(QmatNMR.fase0, 5) '   1st order = ' num2str(QmatNMR.fase1, 5) '   ref. peak Ph1 = ' num2str(QmatNMR.fase1start, 5)]);
          end
          disp('phase set for TD2');
        end    
  
      else	%TD1 := QmatNMR.Dim = 2
        Qi = sqrt(-1);
        QmatNMR.z = -((1:QmatNMR.SizeTD1)-QmatNMR.fase1startIndex)/(QmatNMR.SizeTD1);
        QmatNMR.z2 = -2*(((1:QmatNMR.SizeTD1)-floor(QmatNMR.SizeTD1/2)-1)/(QmatNMR.SizeTD1)).^2;
        QTEMP = (exp(Qi*pi/180*(QmatNMR.fase0 + QmatNMR.fase1*QmatNMR.z + QmatNMR.fase2*QmatNMR.z2)).');
  
        if QmatNMR.SingleSlice 	%operate on a single slice ONLY
          QTEMP12 = QmatNMR.kolomnr;
        else		%operate on the entire matrix
          QTEMP12 = 1:QmatNMR.SizeTD2;
        end
  
        			%from a test on a Windows machine and a SUN Solaris system this went fastest using 
                          %column-wise muliplications for both Matlab 6.5.1 and Matlab 7.0.4
                          %Jacco, 04-08-2005
        if QmatNMR.HyperComplex  		      %Amplitude modulated spectra
  	for QTEMP40 = QTEMP12
            QTEMP1 = (real(QmatNMR.Spec2D(:, QTEMP40)) + Qi*real(QmatNMR.Spec2Dhc(:, QTEMP40))) .* QTEMP;
            QTEMP2 = (imag(QmatNMR.Spec2D(:, QTEMP40)) + Qi*imag(QmatNMR.Spec2Dhc(:, QTEMP40))) .* QTEMP;
            
  	  QmatNMR.Spec2D(:, QTEMP40) = real(QTEMP1) + Qi*real(QTEMP2);
  	  QmatNMR.Spec2Dhc(:, QTEMP40) = imag(QTEMP1) + Qi*imag(QTEMP2);
  	end;  
    
        else			      %Phase modulated spectra
  	for QTEMP40 = QTEMP12
  	  QmatNMR.Spec2D(:, QTEMP40) = ( QmatNMR.Spec2D(:, QTEMP40) .* QTEMP );
  	end;  
        end
  
        if QmatNMR.SingleSlice 	%operate on a single slice only
          if (QmatNMR.fase2)
            QmatNMR.History = str2mat(QmatNMR.History, ['Phase correction for current slice of TD1      :  0th order = ' num2str(QmatNMR.fase0, 5) '   1st order = ' num2str(QmatNMR.fase1, 5) '   2nd order = ' num2str(QmatNMR.fase2, 5) '   ref. peak Ph1 = ' num2str(QmatNMR.fase1start, 5)]);
          else
            QmatNMR.History = str2mat(QmatNMR.History, ['Phase correction for current slice of TD1      :  0th order = ' num2str(QmatNMR.fase0, 5) '   1st order = ' num2str(QmatNMR.fase1, 5) '   ref. peak Ph1 = ' num2str(QmatNMR.fase1start, 5)]);
          end
          disp('phase set for the current slice of the TD1');
  
        else		%operate on the entire matrix
          if (QmatNMR.fase2)
            QmatNMR.History = str2mat(QmatNMR.History, ['Phase correction for TD1      :  0th order = ' num2str(QmatNMR.fase0, 5) '   1st order = ' num2str(QmatNMR.fase1, 5) '   2nd order = ' num2str(QmatNMR.fase2, 5) '   ref. peak Ph1 = ' num2str(QmatNMR.fase1start, 5)]);
          else
            QmatNMR.History = str2mat(QmatNMR.History, ['Phase correction for TD1      :  0th order = ' num2str(QmatNMR.fase0, 5) '   1st order = ' num2str(QmatNMR.fase1, 5) '   ref. peak Ph1 = ' num2str(QmatNMR.fase1start, 5)]);
          end
          disp('phase set for TD1');
        end    
      end
    
  
      %
      %determine the current row/column number, and set dimension-specific information in the history macro's
      %      
      if (QmatNMR.Dim == 1)     %TD2
        QTEMP12 = QmatNMR.rijnr;
        
        %first add dimension-specific information, and then the current command
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
  
        if QmatNMR.RecordingMacro
          %first add dimension-specific information, and then the current command
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
        end
  
      else
        QTEMP12 = QmatNMR.kolomnr;
  
        %first add dimension-specific information, and then the current command
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
        
        if QmatNMR.RecordingMacro
          %first add dimension-specific information, and then the current command
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
        end
      end
  
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 113, QmatNMR.fase0, QmatNMR.fase1, QmatNMR.fase1start, QmatNMR.fase2, QmatNMR.Dim, QmatNMR.howFT, QmatNMR.SingleSlice, QTEMP12, 1);
      if QmatNMR.RecordingMacro
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 113, QmatNMR.fase0, QmatNMR.fase1, QmatNMR.fase1start, QmatNMR.fase2, QmatNMR.Dim, QmatNMR.howFT, QmatNMR.SingleSlice, QTEMP12, 1);
      end
      
    else
      disp('No phase correction needed (all zeros)');  
    end  
  
  
    %
    %clear the a posteriori entries
    %
    QmatNMR.APosterioriMacro = AddToMacro;
    QmatNMR.APosterioriHistory = '';
  
  
    %
    %reset the flag for single-slice manipulations
    %
    QmatNMR.SingleSlice = 0;
  
    Qspcrel
    CheckAxis
    repair;
    
    if (~QmatNMR.BusyWithMacro)
      simpelplot;
  
      Arrowhead
    end
  end
  
  clear QTEMP* Qi

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
