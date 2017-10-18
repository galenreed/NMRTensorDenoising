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
%regelleftshift.m takes care of left or right shifting spectra, both 1D and 2D
%5-12-'97

try
  if QmatNMR.buttonList == 1
    watch;
  
    QmatNMR.NrLeftShift = eval(QmatNMR.uiInput1);
    if (QmatNMR.NrLeftShift == 0)			%no shift then return without acting
      Arrowhead
      return
    end
  
    if (QmatNMR.SwitchTo1D) 		%switch from 2D to 1D processing if necessary
      SwitchTo1D
    end
  
    %
    %create entry in the undo matrix
    %
    regelUNDO
  
    %
    %safety check to see whether this value isn't larger than the dimension sizes
    %
    if (QmatNMR.Dim==0) 		%1D
      if (abs(QmatNMR.NrLeftShift) > QmatNMR.Size1D)
        disp('matNMR WARNING: value for number of points to shift is larger than dimension size');
        disp('matNMR WARNING: shift data points cancelled ...');
        return
      end
    elseif (QmatNMR.Dim == 1) 	%TD2
      if (abs(QmatNMR.NrLeftShift) > QmatNMR.SizeTD2)
        disp('matNMR WARNING: value for number of points to shift is larger than dimension size');
        disp('matNMR WARNING: shift data points cancelled ...');
        return
      end
    else				%TD1
      if (abs(QmatNMR.NrLeftShift) > QmatNMR.SizeTD1)
        disp('matNMR WARNING: value for number of points to shift is larger than dimension size');
        disp('matNMR WARNING: shift data points cancelled ...');
        return
      end
    end
  
    QmatNMR.howFT = get(QmatNMR.Four, 'value');		%determine the type of fourier transform currently selected
  
  %
  %Now shift the data. This is divided in sections for left and right shifts
  %
    if (QmatNMR.NrLeftShift > 0)		%left shift
      QTEMP11 = 'left';
  
      if (QmatNMR.Dim == 0)
        QTEMP23 = QmatNMR.Spec1D;
        QmatNMR.Spec1D = zeros(size(QmatNMR.Spec1D));
        QmatNMR.Spec1D(1:(length(QmatNMR.Spec1D)-QmatNMR.NrLeftShift)) = QTEMP23((1+QmatNMR.NrLeftShift):length(QmatNMR.Spec1D));
        repair
  
      elseif (QmatNMR.Dim == 1)
        if (QmatNMR.SingleSlice) 	%operate ONLY on current slice
          QmatNMR.Spec2D(QmatNMR.rijnr, :) = [QmatNMR.Spec2D(QmatNMR.rijnr, (1+QmatNMR.NrLeftShift):QmatNMR.SizeTD2) zeros(1, QmatNMR.NrLeftShift)];
  	if ((QmatNMR.howFT == 3) | (QmatNMR.howFT == 6))%states or States-TPPI
            QmatNMR.Spec2Dhc(QmatNMR.rijnr, :) = [QmatNMR.Spec2Dhc(QmatNMR.rijnr, (1+QmatNMR.NrLeftShift):QmatNMR.SizeTD2) zeros(1, QmatNMR.NrLeftShift)];
  	end
  
        else			%operate on the entire matrix
          if ((QmatNMR.howFT == 3) | (QmatNMR.howFT == 6)) %states or States-TPPI
            QTEMP23 = QmatNMR.Spec2D;
            QTEMP24= QmatNMR.Spec2Dhc;
  
            QmatNMR.Spec2D = zeros(QmatNMR.SizeTD1, QmatNMR.SizeTD2);
            QmatNMR.Spec2D = zeros(QmatNMR.SizeTD1, QmatNMR.SizeTD2);
  
            QmatNMR.Spec2D(:, 1:(QmatNMR.SizeTD2-QmatNMR.NrLeftShift)) = QTEMP23 (:, (1+QmatNMR.NrLeftShift):QmatNMR.SizeTD2);
            QmatNMR.Spec2Dhc(:, 1:(QmatNMR.SizeTD2-QmatNMR.NrLeftShift)) = QTEMP24(:, (1+QmatNMR.NrLeftShift):QmatNMR.SizeTD2);
  
  
          else				%no states
            QTEMP23 = QmatNMR.Spec2D;
            QmatNMR.Spec2D = zeros(QmatNMR.SizeTD1, QmatNMR.SizeTD2);
  
            QmatNMR.Spec2D(:, 1:(QmatNMR.SizeTD2-QmatNMR.NrLeftShift)) = QTEMP23(:, (1+QmatNMR.NrLeftShift):QmatNMR.SizeTD2);
          end
        end
        getcurrentspectrum		%get spectrum to show on the screen
  
  
      elseif (QmatNMR.Dim == 2)
        if (QmatNMR.SingleSlice) 	%operate ONLY on current slice
          QmatNMR.Spec2D(:, QmatNMR.kolomnr) = [QmatNMR.Spec2D((1+QmatNMR.NrLeftShift):QmatNMR.SizeTD1, QmatNMR.kolomnr); zeros(QmatNMR.NrLeftShift, 1)];
  	if ((QmatNMR.howFT == 3) | (QmatNMR.howFT == 6))%states or States-TPPI
            QmatNMR.Spec2Dhc(:, QmatNMR.kolomnr) = [QmatNMR.Spec2Dhc((1+QmatNMR.NrLeftShift):QmatNMR.SizeTD1, QmatNMR.kolomnr); zeros(QmatNMR.NrLeftShift, 1)];
  	end
  
        else			%operate on the entire matrix
          if ((QmatNMR.howFT == 3)	| (QmatNMR.howFT == 6))%states or States-TPPI
            QTEMP23 = QmatNMR.Spec2D;
            QTEMP24= QmatNMR.Spec2Dhc;
  
            QmatNMR.Spec2D = zeros(QmatNMR.SizeTD1, QmatNMR.SizeTD2);
            QmatNMR.Spec2D = zeros(QmatNMR.SizeTD1, QmatNMR.SizeTD2);
  
            QmatNMR.Spec2D(1:(QmatNMR.SizeTD1-QmatNMR.NrLeftShift), :) = QTEMP23 ((1+QmatNMR.NrLeftShift):QmatNMR.SizeTD1, :);
            QmatNMR.Spec2Dhc(1:(QmatNMR.SizeTD1-QmatNMR.NrLeftShift), :) = QTEMP24((1+QmatNMR.NrLeftShift):QmatNMR.SizeTD1, :);
  
  
          else				%no states
            QTEMP23 = QmatNMR.Spec2D;
            QmatNMR.Spec2D = zeros(QmatNMR.SizeTD1, QmatNMR.SizeTD2);
  
            QmatNMR.Spec2D(1:(QmatNMR.SizeTD1-QmatNMR.NrLeftShift), :) = QTEMP23 ((1+QmatNMR.NrLeftShift):QmatNMR.SizeTD1, :);
          end
        end
        getcurrentspectrum		%get spectrum to show on the screen
      end
  
  
    elseif (QmatNMR.NrLeftShift < 0)		%right shift
      QTEMP11 = 'right';
  
      if (QmatNMR.Dim == 0)
        QTEMP23 = QmatNMR.Spec1D;
        QmatNMR.Spec1D = zeros(size(QmatNMR.Spec1D));
        QmatNMR.Spec1D((1-QmatNMR.NrLeftShift):(length(QmatNMR.Spec1D))) = QTEMP23(1:length(QmatNMR.Spec1D)+QmatNMR.NrLeftShift);
        repair
  
      elseif (QmatNMR.Dim == 1)
        if (QmatNMR.SingleSlice) 	%operate ONLY on current slice
          QmatNMR.Spec2D(QmatNMR.rijnr, :) = [zeros(1, -QmatNMR.NrLeftShift) QmatNMR.Spec2D(QmatNMR.rijnr, 1:(QmatNMR.NrLeftShift+QmatNMR.SizeTD2))];
  	if ((QmatNMR.howFT == 3) | (QmatNMR.howFT == 6))%states or States-TPPI
            QmatNMR.Spec2Dhc(QmatNMR.rijnr, :) = [zeros(1, -QmatNMR.NrLeftShift) QmatNMR.Spec2Dhc(QmatNMR.rijnr, 1:(QmatNMR.NrLeftShift+QmatNMR.SizeTD2))];
  	end
  
        else			%operate on the entire matrix
          if ((QmatNMR.howFT == 3)	| (QmatNMR.howFT == 6))%states or States-TPPI
            QTEMP23 = QmatNMR.Spec2D;
            QTEMP24= QmatNMR.Spec2Dhc;
  
            QmatNMR.Spec2D = zeros(QmatNMR.SizeTD1, QmatNMR.SizeTD2);
            QmatNMR.Spec2D = zeros(QmatNMR.SizeTD1, QmatNMR.SizeTD2);
  
            QmatNMR.Spec2D(:, (1-QmatNMR.NrLeftShift):QmatNMR.SizeTD2) = QTEMP23 (:, 1:(QmatNMR.NrLeftShift+QmatNMR.SizeTD2));
            QmatNMR.Spec2Dhc(:, (1-QmatNMR.NrLeftShift):QmatNMR.SizeTD2) = QTEMP24(:, 1:(QmatNMR.NrLeftShift+QmatNMR.SizeTD2));
  
  
          else				%no states
            QTEMP23 = QmatNMR.Spec2D;
            QmatNMR.Spec2D = zeros(QmatNMR.SizeTD1, QmatNMR.SizeTD2);
  
            QmatNMR.Spec2D(:, (1-QmatNMR.NrLeftShift):QmatNMR.SizeTD2) = QTEMP23 (:, 1:(QmatNMR.NrLeftShift+QmatNMR.SizeTD2));
  
          end
        end
        getcurrentspectrum		%get spectrum to show on the screen
  
  
      elseif (QmatNMR.Dim == 2)
        if (QmatNMR.SingleSlice) 	%operate ONLY on current slice
          QmatNMR.Spec2D(:, QmatNMR.kolomnr) = [zeros(-QmatNMR.NrLeftShift, 1); QmatNMR.Spec2D(1:(QmatNMR.NrLeftShift+QmatNMR.SizeTD1), QmatNMR.kolomnr)];
  	if ((QmatNMR.howFT == 3) | (QmatNMR.howFT == 6))%states or States-TPPI
            QmatNMR.Spec2Dhc(:, QmatNMR.kolomnr) = [zeros(-QmatNMR.NrLeftShift, 1); QmatNMR.Spec2Dhc(1:(QmatNMR.NrLeftShift+QmatNMR.SizeTD1), QmatNMR.kolomnr)];
  	end
  
        else			%operate on the entire matrix
          if ((QmatNMR.howFT == 3)	| (QmatNMR.howFT == 6))%states or States-TPPI
            QTEMP23 = QmatNMR.Spec2D;
            QTEMP24= QmatNMR.Spec2Dhc;
  
            QmatNMR.Spec2D = zeros(QmatNMR.SizeTD1, QmatNMR.SizeTD2);
            QmatNMR.Spec2D = zeros(QmatNMR.SizeTD1, QmatNMR.SizeTD2);
  
            QmatNMR.Spec2D((1-QmatNMR.NrLeftShift):QmatNMR.SizeTD1, :) = QTEMP23 (1:(QmatNMR.NrLeftShift+QmatNMR.SizeTD1), :);
            QmatNMR.Spec2Dhc((1-QmatNMR.NrLeftShift):QmatNMR.SizeTD1, :) = QTEMP24(1:(QmatNMR.NrLeftShift+QmatNMR.SizeTD1), :);
  
  
          else				%no states
            QTEMP23 = QmatNMR.Spec2D;
            QmatNMR.Spec2D = zeros(QmatNMR.SizeTD1, QmatNMR.SizeTD2);
  
            QmatNMR.Spec2D((1-QmatNMR.NrLeftShift):QmatNMR.SizeTD1, :) = QTEMP23 (1:(QmatNMR.NrLeftShift+QmatNMR.SizeTD1), :);
          end
        end
        getcurrentspectrum		%get spectrum to show on the screen
  
      end
  
    else
      disp('Left shift cancelled ...');
    end;
  
  
    %
    %Now that the shift is finished, update the history and produce output on screen
    %
    if (QmatNMR.Dim > 0)
      if QmatNMR.SingleSlice
        disp(['Current slice of the 2D spectrum shifted ' num2str(abs(QmatNMR.NrLeftShift)) ' points to the ' QTEMP11 ' ...']);
        QmatNMR.History = str2mat(QmatNMR.History, ['Single slice in current dimension shifted ' num2str(abs(QmatNMR.NrLeftShift)) ' points to the right ...'], ['Dimension (1 = TD2, 2 = TD1) = ' num2str(QmatNMR.Dim)]);
  
        if (QmatNMR.Dim == 1)     	%TD2
          QTEMP12 = QmatNMR.rijnr;
  
          %first add dimension-specific information, and then the current command
          QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
          QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
  
        else			%TD1
          QTEMP12 = QmatNMR.kolomnr;
  
          %first add dimension-specific information, and then the current command
          QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
          QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
        end
  
        %code for shift, nr of points to shift, FT mode, dimension, single slice flag and which slice
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 103, QmatNMR.NrLeftShift, QmatNMR.howFT, QmatNMR.Dim, QmatNMR.SingleSlice, QTEMP12);
  
        if QmatNMR.RecordingMacro
          %first add dimension-specific information, and then the current command
          if (QmatNMR.Dim == 1)     	%TD2
            %first add dimension-specific information, and then the current command
            QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
            QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
  
          else			%TD1
            %first add dimension-specific information, and then the current command
            QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
            QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
          end
  
  	%code for shift, nr of points to shift, FT mode, dimension, single slice flag and which slice
  	QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 103, QmatNMR.NrLeftShift, QmatNMR.howFT, QmatNMR.Dim, QmatNMR.SingleSlice, QTEMP12);
        end
  
      else
        disp(['Current dimension of the 2D spectrum shifted ' num2str(abs(QmatNMR.NrLeftShift)) ' points to the ' QTEMP11 ' ...']);
        QmatNMR.History = str2mat(QmatNMR.History, ['Current dimension shifted ' num2str(abs(QmatNMR.NrLeftShift)) ' points to the right ...'], ['Dimension (1 = TD2, 2 = TD1) = ' num2str(QmatNMR.Dim)]);
  
        if (QmatNMR.Dim == 1)     	%TD2
          %first add dimension-specific information, and then the current command
          QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
          QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
  
        else			%TD1
          %first add dimension-specific information, and then the current command
          QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
          QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
        end
  
  
        %code for shift, nr of points to shift, FT mode, dimension
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 103, QmatNMR.NrLeftShift, QmatNMR.howFT, QmatNMR.Dim);
  
        if QmatNMR.RecordingMacro
          %first add dimension-specific information, and then the current command
          if (QmatNMR.Dim == 1)     	%TD2
            %first add dimension-specific information, and then the current command
            QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
            QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
  
          else			%TD1
            %first add dimension-specific information, and then the current command
            QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
            QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
          end
  
  	%code for shift, nr of points to shift, FT mode, dimension, single slice flag and which slice
  	QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 103, QmatNMR.NrLeftShift, QmatNMR.howFT, QmatNMR.Dim);
        end
      end
  
    else
      disp(['Current 1D spectrum shifted ' num2str(abs(QmatNMR.NrLeftShift)) ' points to the ' QTEMP11 ' ...']);
  
      QmatNMR.History = str2mat(QmatNMR.History, ['Current 1D FID shifted ' num2str(abs(QmatNMR.NrLeftShift)) ' points to the right ...']);
  
      %first add dimension-specific information, and then the current command
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 1, QmatNMR.NrLeftShift, QmatNMR.howFT); 	      %code for left shift, nr of points to shift, FT mode
  
      if QmatNMR.RecordingMacro
        %first add dimension-specific information, and then the current command
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 1, QmatNMR.NrLeftShift, QmatNMR.howFT);	      %code for left shift, nr of points to shift, FT mode
      end
    end;
  
  
    %
    %reset the single-slice flag
    %
    QmatNMR.SingleSlice = 0;
  
  
    %
    %Update display
    %
    if (~QmatNMR.BusyWithMacro)
      asaanpas
      Arrowhead;
    end
  
  else
    disp('Left shift cancelled ...');
    QmatNMR.SwitchTo1D = 0;	%reset flag because it is possible that the user came from a 2D but cancelled the action
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
