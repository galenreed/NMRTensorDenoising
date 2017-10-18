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
%regeldelete.m deletes a single row/column from a 2D matrix
%31-10-'08

try
  watch;
  
  %
  %create entry in the undo matrix
  %
  regelUNDO
  
  
  %
  %Delete current row/column from matrix
  %
  if (QmatNMR.Dim == 1)         %TD2
    QmatNMR.Spec2D   = QmatNMR.Spec2D  ([1:(QmatNMR.rijnr-1) (QmatNMR.rijnr+1):QmatNMR.SizeTD1], :);
    QmatNMR.Spec2Dhc = QmatNMR.Spec2Dhc([1:(QmatNMR.rijnr-1) (QmatNMR.rijnr+1):QmatNMR.SizeTD1], :);
    QmatNMR.AxisTD1 = QmatNMR.AxisTD1([1:(QmatNMR.rijnr-1) (QmatNMR.rijnr+1):QmatNMR.SizeTD1]);
    QmatNMR.SizeTD1 = QmatNMR.SizeTD1-1;
    QmatNMR.RulerXAxis2 = 1;
  
  else                          %TD1
    QmatNMR.Spec2D   = QmatNMR.Spec2D  (:, [1:(QmatNMR.rijnr-1) (QmatNMR.rijnr+1):QmatNMR.SizeTD1]);
    QmatNMR.Spec2Dhc = QmatNMR.Spec2Dhc(:, [1:(QmatNMR.rijnr-1) (QmatNMR.rijnr+1):QmatNMR.SizeTD1]);
    QmatNMR.AxisTD2 = QmatNMR.AxisTD2([1:(QmatNMR.rijnr-1) (QmatNMR.rijnr+1):QmatNMR.SizeTD1]);
    QmatNMR.SizeTD2 = QmatNMR.SizeTD2-1;
    QmatNMR.RulerXAxis1 = 1;
  end
  
  getcurrentspectrum            %get spectrum to show on the screen
  
  
  %
  %Now that the shift is finished, update the history and produce output on screen
  %
  if (QmatNMR.Dim == 1)             %TD2
    QTEMP12 = QmatNMR.rijnr;
  
    %first add dimension-specific information, and then the current command
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
  
    %code for shift, nr of points to shift, FT mode, dimension, single slice flag and which slice
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 132, QmatNMR.Dim, QmatNMR.rijnr);
  else                      %TD1
    QTEMP12 = QmatNMR.kolomnr;
  
    %first add dimension-specific information, and then the current command
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
  
    %code for shift, nr of points to shift, FT mode, dimension, single slice flag and which slice
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 132, QmatNMR.Dim, QmatNMR.kolomnr);
  end
  
  if QmatNMR.RecordingMacro
    %first add dimension-specific information, and then the current command
    if (QmatNMR.Dim == 1)           %TD2
      %first add dimension-specific information, and then the current command
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
  
      %code for shift, nr of points to shift, FT mode, dimension, single slice flag and which slice
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 132, QmatNMR.Dim, QmatNMR.rijnr);
    else                    %TD1
      %first add dimension-specific information, and then the current command
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
  
      %code for shift, nr of points to shift, FT mode, dimension, single slice flag and which slice
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 132, QmatNMR.Dim, QmatNMR.kolomnr);
    end
  end
  
  
  %
  %reset the single-slice flag
  %
  QmatNMR.SingleSlice = 0;
  
  
  %
  %Update display
  %
  disp('Deleted current row/column from 2D matrix ...');
  if (~QmatNMR.BusyWithMacro)
    asaanpas
    Arrowhead;
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
