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
%regelsize2d.m takes care of the input of the new size of a 2D matrix after QmatNMR.uiInput.m
%21-12-'96
%

try
  if QmatNMR.buttonList == 1						%= OK-button
    watch;
  
    %
    %create entry in the undo matrix
    %
    regelUNDO
  
    [QTEMP4, QTEMP3] = size(QmatNMR.Spec2D);
  
    QTEMP9 = length(QmatNMR.uiInput1);					%Size TD 2
    if ((QmatNMR.uiInput1(QTEMP9) == 'k') | (QmatNMR.uiInput1(QTEMP9) == 'K'))
      QTEMP11 = round(str2num(QmatNMR.uiInput1(1:(QTEMP9-1))) * 1024 );
    else
      QTEMP11 = round(str2num(QmatNMR.uiInput1));
    end
  
    QTEMP9 = length(QmatNMR.uiInput2);					%Size TD 1
    if ((QmatNMR.uiInput2(QTEMP9) == 'k') | (QmatNMR.uiInput2(QTEMP9) == 'K'))
      QTEMP12 = round(str2num(QmatNMR.uiInput2(1:(QTEMP9-1))) * 1024 );
    else
      QTEMP12 = round(str2num(QmatNMR.uiInput2));
    end
  
  
    %
    %Now check which dimensions have changed size. If there was no change then -99 is stored
    %in the history macro to ensure that the macro will also work for differently-sized
    %matrices.
    %
    if (QmatNMR.SizeTD2 == QTEMP11)
      QTEMP13 = -99;
    else
      QTEMP13 = QTEMP11;
    end
    QmatNMR.SizeTD2 = QTEMP11;
  
    if (QmatNMR.SizeTD1 == QTEMP12)
      QTEMP14 = -99;
    else
      QTEMP14 = QTEMP12;
    end
    QmatNMR.SizeTD1 = QTEMP12;
  
  
    %
    %Change the size of the matrix
    %
    QTEMP1 = QmatNMR.Spec2D;									%QTEMP1 = spectrum of the old size
    QTEMP2 = QmatNMR.Spec2Dhc;									%QTEMP2 = spectrum of the old size
    QmatNMR.Spec2D = zeros(QmatNMR.SizeTD1, QmatNMR.SizeTD2);					%QmatNMR.Spectrum of the new size
    QmatNMR.Spec2Dhc = zeros(QmatNMR.SizeTD1, QmatNMR.SizeTD2);
  
    %
    %now we put the original matrices in the newly-proportioned matrix. If the Fourier mode
    %in TD2 is that for whole-echo then we will append from the center in that dimension,
    %otherwise we append from the right-hand side
    %
    if (QmatNMR.four2 ~= 5)		%all but whole-echo
      if (QTEMP3 >= QmatNMR.SizeTD2) & (QTEMP4 >= QmatNMR.SizeTD1)				%change the size of the spectrum
        QmatNMR.Spec2D(1:QmatNMR.SizeTD1, 1:QmatNMR.SizeTD2) = QTEMP1(1:QmatNMR.SizeTD1, 1:QmatNMR.SizeTD2);		%new size is smaller in both time domains !
        QmatNMR.Spec2Dhc(1:QmatNMR.SizeTD1, 1:QmatNMR.SizeTD2) = QTEMP2(1:QmatNMR.SizeTD1, 1:QmatNMR.SizeTD2);		%new size is smaller in both time domains !
        
      elseif (QTEMP3 >= QmatNMR.SizeTD2)
        QmatNMR.Spec2D(1:QTEMP4, 1:QmatNMR.SizeTD2) = QTEMP1(1:QTEMP4, 1:QmatNMR.SizeTD2);			%new size of TD 2 is smaller than before, TD 1 NOT !
        QmatNMR.Spec2Dhc(1:QTEMP4, 1:QmatNMR.SizeTD2) = QTEMP2(1:QTEMP4, 1:QmatNMR.SizeTD2);			%new size of TD 2 is smaller than before, TD 1 NOT !
    
      elseif (QTEMP4 >= QmatNMR.SizeTD1)
        QmatNMR.Spec2D(1:QmatNMR.SizeTD1, 1:QTEMP3) = QTEMP1(1:QmatNMR.SizeTD1, 1:QTEMP3);			%new size of TD 1 is smaller than before, TD 2 NOT !
        QmatNMR.Spec2Dhc(1:QmatNMR.SizeTD1, 1:QTEMP3) = QTEMP2(1:QmatNMR.SizeTD1, 1:QTEMP3);			%new size of TD 1 is smaller than before, TD 2 NOT !
        
      else
        QmatNMR.Spec2D(1:QTEMP4, 1:QTEMP3) = QTEMP1;					%new size is bigger than old one in both time domains!
        QmatNMR.Spec2Dhc(1:QTEMP4, 1:QTEMP3) = QTEMP2;					%new size is bigger than old one in both time domains!
      end
  
    else				%whole-echo in TD2
      if (QTEMP3 >= QmatNMR.SizeTD2) & (QTEMP4 >= QmatNMR.SizeTD1)				%change the size of the spectrum
        QmatNMR.Spec2D(1:QmatNMR.SizeTD1, 1:ceil(QmatNMR.SizeTD2/2)) = QTEMP1(1:QmatNMR.SizeTD1, 1:ceil(QmatNMR.SizeTD2/2));			%new size is smaller in both time domains !
        QmatNMR.Spec2D(1:QmatNMR.SizeTD1, (ceil(QmatNMR.SizeTD2/2)+1):QmatNMR.SizeTD2) = QTEMP1(1:QmatNMR.SizeTD1, (QTEMP3+1-floor(QmatNMR.SizeTD2/2)):QTEMP3);	%new size is smaller in both time domains !
  
        QmatNMR.Spec2Dhc(1:QmatNMR.SizeTD1, 1:ceil(QmatNMR.SizeTD2/2)) = QTEMP2(1:QmatNMR.SizeTD1, 1:ceil(QmatNMR.SizeTD2/2));			%new size is smaller in both time domains !
        QmatNMR.Spec2Dhc(1:QmatNMR.SizeTD1, (ceil(QmatNMR.SizeTD2/2)+1):QmatNMR.SizeTD2) = QTEMP2(1:QmatNMR.SizeTD1, (QTEMP3+1-floor(QmatNMR.SizeTD2/2)):QTEMP3);	%new size is smaller in both time domains !
  
      elseif (QTEMP3 >= QmatNMR.SizeTD2)
        QmatNMR.Spec2D(1:QTEMP4, 1:ceil(QmatNMR.SizeTD2/2)) = QTEMP1(1:QTEMP4, 1:ceil(QmatNMR.SizeTD2/2));			%new size of TD 2 is smaller than before, TD 1 NOT !
        QmatNMR.Spec2D(1:QTEMP4, (ceil(QmatNMR.SizeTD2/2)+1):QmatNMR.SizeTD2) = QTEMP1(1:QTEMP4, (QTEMP3+1-floor(QmatNMR.SizeTD2/2)):QTEMP3);	%new size of TD 2 is smaller than before, TD 1 NOT !
  
        QmatNMR.Spec2Dhc(1:QTEMP4, 1:ceil(QmatNMR.SizeTD2/2)) = QTEMP2(1:QTEMP4, 1:ceil(QmatNMR.SizeTD2/2));			%new size of TD 2 is smaller than before, TD 1 NOT !
        QmatNMR.Spec2Dhc(1:QTEMP4, (ceil(QmatNMR.SizeTD2/2)+1):QmatNMR.SizeTD2) = QTEMP2(1:QTEMP4, (QTEMP3+1-floor(QmatNMR.SizeTD2/2)):QTEMP3);	%new size of TD 2 is smaller than before, TD 1 NOT !
    
      elseif (QTEMP4 >= QmatNMR.SizeTD1)
        QmatNMR.Spec2D(1:QmatNMR.SizeTD1, 1:ceil(QTEMP3/2)) = QTEMP1(1:QmatNMR.SizeTD1, 1:ceil(QTEMP3/2));			%new size of TD 1 is smaller than before, TD 2 NOT !
        QmatNMR.Spec2D(1:QmatNMR.SizeTD1, (QmatNMR.SizeTD2+1-floor(QTEMP3/2)):QmatNMR.SizeTD2) = QTEMP1(1:QmatNMR.SizeTD1, (ceil(QTEMP3/2)+1):QTEMP3);	%new size of TD 1 is smaller than before, TD 2 NOT !
  
        QmatNMR.Spec2Dhc(1:QmatNMR.SizeTD1, 1:ceil(QTEMP3/2)) = QTEMP2(1:QmatNMR.SizeTD1, 1:ceil(QTEMP3/2));			%new size of TD 1 is smaller than before, TD 2 NOT !
        QmatNMR.Spec2Dhc(1:QmatNMR.SizeTD1, (QmatNMR.SizeTD2+1-floor(QTEMP3/2)):QmatNMR.SizeTD2) = QTEMP2(1:QmatNMR.SizeTD1, (ceil(QTEMP3/2)+1):QTEMP3);	%new size of TD 1 is smaller than before, TD 2 NOT !
        
      else
        QmatNMR.Spec2D(1:QTEMP4, 1:ceil(QTEMP3/2)) = QTEMP1(:, 1:ceil(QTEMP3/2));			%new size is bigger than old one in both time domains!
        QmatNMR.Spec2D(1:QTEMP4, (QmatNMR.SizeTD2+1-floor(QTEMP3/2)):QmatNMR.SizeTD2) = QTEMP1(:, (ceil(QTEMP3/2)+1):QTEMP3);	%new size is bigger than old one in both time domains!
  
        QmatNMR.Spec2Dhc(1:QTEMP4, 1:ceil(QTEMP3/2)) = QTEMP2(:, 1:ceil(QTEMP3/2));			%new size is bigger than old one in both time domains!
        QmatNMR.Spec2Dhc(1:QTEMP4, (QmatNMR.SizeTD2+1-floor(QTEMP3/2)):QmatNMR.SizeTD2) = QTEMP2(:, (ceil(QTEMP3/2)+1):QTEMP3);	%new size is bigger than old one in both time domains!
      end
    end
  
  
  				%prevent possible errors by checking the current row and column number
    if (QmatNMR.rijnr > QmatNMR.SizeTD1)
      QmatNMR.rijnr = 1;
    end
    if (QmatNMR.kolomnr > QmatNMR.SizeTD2)
      QmatNMR.kolomnr = 1;
    end
  
    getcurrentspectrum		%get spectrum to show on the screen
  
    %
    %ALWAYS revert to the default axis, but only for dimensions that have changed
    %
    if (QmatNMR.Dim == 1)		%TD2
      QmatNMR.RulerXAxis = 0;		%Flag for default axis
      QmatNMR.RulerXAxis1 = 0;
      QmatNMR.AxisTD2 = GetDefaultAxisDual(QmatNMR.SizeTD2, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMRsettings.DefaultAxisReferencekHz1, QmatNMRsettings.DefaultAxisReferencePPM1, QmatNMRsettings.DefaultAxisCarrierIndex1);
  
      if (QTEMP14 ~= -99)
        QmatNMR.RulerXAxis2 = 0;
        QmatNMR.AxisTD1 = GetDefaultAxisDual(QmatNMR.SizeTD1, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMRsettings.DefaultAxisReferencekHz2, QmatNMRsettings.DefaultAxisReferencePPM2, QmatNMRsettings.DefaultAxisCarrierIndex2);
      end
  
    else 				%TD1
      QmatNMR.RulerXAxis = 0;		%Flag for default axis
      QmatNMR.RulerXAxis2 = 0;
      QmatNMR.AxisTD1 = GetDefaultAxisDual(QmatNMR.SizeTD1, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMRsettings.DefaultAxisReferencekHz2, QmatNMRsettings.DefaultAxisReferencePPM2, QmatNMRsettings.DefaultAxisCarrierIndex2);
  
      if (QTEMP13 ~= -99)
        QmatNMR.RulerXAxis1 = 0;
        QmatNMR.AxisTD2 = GetDefaultAxisDual(QmatNMR.SizeTD2, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMRsettings.DefaultAxisReferencekHz1, QmatNMRsettings.DefaultAxisReferencePPM1, QmatNMRsettings.DefaultAxisCarrierIndex1);
      end
    end
    
    QmatNMR.fase1startIndex = floor(QmatNMR.Size1D/2)+1;
    QmatNMR.lbstatus=0;				%reset linebroadening flag and button
  
    disp(['New Size of the 2D spectrum : ', num2str(QmatNMR.SizeTD1), ' x ', num2str(QmatNMR.SizeTD2) ' points (td1 x td2)']);
    QmatNMR.History = str2mat(QmatNMR.History, ['New Size of the 2D spectrum   :  ', num2str(QmatNMR.SizeTD1), ' x ', num2str(QmatNMR.SizeTD2) ' (td1 x td2)']);
  
    %first add dimension-specific information, and then the current command
    if (QmatNMR.Dim == 1)		%TD2
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
    
    else
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
    end
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 102, QTEMP13, QTEMP14);
      
    if QmatNMR.RecordingMacro
      %first add dimension-specific information, and then the current command
      if (QmatNMR.Dim == 1) 	%TD2
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
      
      else
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
      end
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 102, QTEMP13, QTEMP14);
    end
      
    if (~QmatNMR.BusyWithMacro)
      asaanpas
      Arrowhead
    end  
  else
    disp('No changes made in the size of the spectrum !');
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
