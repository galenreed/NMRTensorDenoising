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
%regelconcatenate.m handles concatenation of 1D and 2D matrices
%08-10-2003

try
  if QmatNMR.buttonList == 1		%OK-button
    watch;
  
    QmatNMR.ConcatenateTimes = eval(QmatNMR.uiInput1);
    QmatNMR.ConcatenateDirection = QmatNMR.uiInput2;
  
    %
    %create entry in the undo matrix
    %
    regelUNDO
  
    if (QmatNMR.Dim == 0) | (QmatNMR.SwitchTo1D == 1)		%for 1D spectra
      if (QmatNMR.SwitchTo1D) 		%switch from 2D to 1D processing if necessary
        SwitchTo1D
      end
  
      if (QmatNMR.ConcatenateDirection == 1) 	%concatenate into a longer 1D
        QmatNMR.Spec1D = QConcatenateMatrix(QmatNMR.Spec1D, QmatNMR.ConcatenateTimes, QmatNMR.ConcatenateDirection-1);
        QmatNMR.Size1D = length(QmatNMR.Spec1D);
  
        disp('Concatenation of 1D spectrum finished');
        disp(['New size of the 1D ' deblank(QmatNMR.Temp(QmatNMR.FIDstatus, :)) ' is :  ', num2str(QmatNMR.Size1D), ' points.']);
        repair
        QmatNMR.Axis1D = zeros(1, QmatNMR.Size1D);
        QmatNMR.Axis1D(1:QmatNMR.Size1D) = 1:QmatNMR.Size1D;
        detaxisprops
  
      else				%concatenate into a new 2D
        QmatNMR.Spec2D = QConcatenateMatrix(QmatNMR.Spec1D, QmatNMR.ConcatenateTimes, QmatNMR.ConcatenateDirection-1);
  
        [QTEMP3, QTEMP4] = size(QmatNMR.Spec2D);
        QmatNMR.Spec2Dhc = zeros(QTEMP3, QTEMP4);
        QmatNMR.Temp = get(QmatNMR.FID, 'String');
        QmatNMR.SizeTD2 = QTEMP4;
        QmatNMR.SizeTD1 = QTEMP3;
  
        QmatNMR.History = '';
        QmatNMR.HistoryMacro = AddToMacro;
        QmatNMR.numbvars = 0;
        QmatNMR.numbstructs = 0;
        QmatNMR.PeakListNums = [];
        QmatNMR.PeakListText = [];
        QmatNMR.FIDstatus2D1 = QmatNMR.FIDstatus;
        QmatNMR.FIDstatus2D2 = 2;
        QmatNMR.FIDstatus = QmatNMR.FIDstatus2D1;		%Is it an FID or a spectrum ? Final setting
        QmatNMR.FIDstatusLast = QmatNMR.FIDstatus;
        regeldisplaymode
        QmatNMR.AxisTD2 = QmatNMR.Axis1D;
        QmatNMR.AxisTD1 = 1:size(QmatNMR.Spec2D, 1);
        QmatNMR.SizeTD2 = QmatNMR.Size1D;
        QmatNMR.SizeTD1 = size(QmatNMR.Spec2D, 1);
        QmatNMR.Axis1D = QmatNMR.AxisTD2;
        QmatNMR.Size1D = QmatNMR.SizeTD2;
        detaxisprops;
        QmatNMR.Spec1D = QmatNMR.Spec2D(1, :);
  
        QmatNMR.Dim = 1;	%2d spectrum, td 2
  
        QmatNMR.min = 0;
        QmatNMR.xmin = 0;
        QmatNMR.totaalX = 500000;
        QmatNMR.totaalY = 500000;
        QmatNMR.minY = 0;
        QmatNMR.maxY = 500000;
        QmatNMR.ymin = 0;
        QmatNMR.BaslcorPeakList= [];
  
        QmatNMR.lbstatus=0;				%reset linebroadening flag and button
  
        QmatNMR.kolomnr = 1;
        QmatNMR.rijnr = 1;
  
        				%reset the phase variables
        QmatNMR.fase0 = 0;
        QmatNMR.fase1 = 0;
        QmatNMR.fase2 = 0;
        QmatNMR.dph0 = 0;
        QmatNMR.dph1 = 0;
        QmatNMR.dph2 = 0;
        QmatNMR.fase1startIndex = floor(QmatNMR.Size1D/2)+1;
        QmatNMR.fase1start = interp1((1:QmatNMR.Size1D).', QmatNMR.Axis1D, QmatNMR.fase1startIndex);
        repair
  
        updatebuttons
  
        disp('Concatenation of 1D spectrum along TD 1 finished ===> New 2D created!!!');
        disp(['Size of the new 2D ' deblank(QmatNMR.Temp(QmatNMR.FIDstatus, :)) ' is :  ', num2str(QmatNMR.SizeTD1), ' x ', num2str(QmatNMR.SizeTD2), ' points (td1 x td2).']);
      end
  
      if (~QmatNMR.BusyWithMacro)
        asaanpas
        Arrowhead
      end
  
      QTEMP9 = str2mat('along TD2', 'along TD1');
      QmatNMR.History = str2mat(QmatNMR.History, ['Concatenation of 1D: repeated ' num2str(QmatNMR.ConcatenateTimes) ' times along ' QTEMP9(QmatNMR.ConcatenateDirection, :)]);
  
      %first add dimension-specific information, and then the current command
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 18, QmatNMR.ConcatenateTimes, QmatNMR.ConcatenateDirection);	%code for LP 1D, backward ITMPM, etc ...
  
      if QmatNMR.RecordingMacro
        %first add dimension-specific information, and then the current command
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 18, QmatNMR.ConcatenateTimes, QmatNMR.ConcatenateDirection);	%code for LP 1D, backward LPSVD, etc ...
      end
  
    else				%for 2D spectrum
      QmatNMR.Spec2D = QConcatenateMatrix(QmatNMR.Spec2D, QmatNMR.ConcatenateTimes, QmatNMR.ConcatenateDirection-1);
      QmatNMR.Spec2Dhc = QConcatenateMatrix(QmatNMR.Spec2Dhc, QmatNMR.ConcatenateTimes, QmatNMR.ConcatenateDirection-1);
  
      [QTEMP3, QTEMP4] = size(QmatNMR.Spec2D);
      QmatNMR.Temp = get(QmatNMR.FID, 'String');
      QmatNMR.SizeTD2 = QTEMP4;
      QmatNMR.SizeTD1 = QTEMP3;
  
      getcurrentspectrum		%get spectrum to show on the screen
  
      if (~QmatNMR.BusyWithMacro)
        asaanpas
        Arrowhead
      end
  
      QTEMP9 = str2mat('along TD2', 'along TD1');
      QmatNMR.History = str2mat(QmatNMR.History, ['Concatenation of 2D: repeated ' num2str(QmatNMR.ConcatenateTimes) ' times along ' QTEMP9(QmatNMR.ConcatenateDirection, :)]);
  
      %first add dimension-specific information, and then the current command
      if (QmatNMR.Dim == 1) 	%TD2
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
  
      else
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
      end
  
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 124, QmatNMR.ConcatenateTimes, QmatNMR.ConcatenateDirection, QmatNMR.Dim);	%code for LP 1D, backward ITMPM, etc ...
  
      if QmatNMR.RecordingMacro
        %first add dimension-specific information, and then the current command
        if (QmatNMR.Dim == 1) 	%TD2
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
  
        else
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
        end
  
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 124, QmatNMR.ConcatenateTimes, QmatNMR.ConcatenateDirection, QmatNMR.Dim);	%code for LP 1D, backward LPSVD, etc ...
      end
  
      disp(['Concatenation of 2D spectrum ' QTEMP9(QmatNMR.ConcatenateDirection, :) ' finished']);
      disp(['New size of the 2D ' deblank(QmatNMR.Temp(QmatNMR.FIDstatus, :)) ' is :  ', num2str(QmatNMR.SizeTD1), ' x ', num2str(QmatNMR.SizeTD2), ' points (td1 x td2).']);
    end
  
    QmatNMR.SwitchTo1D = 0;		%reset the flag for 2D -> 1D
  
  else
    disp('Concatenation of matrix cancelled ...');
    QmatNMR.SwitchTo1D = 0;	%reset flag because it is possible that the user came from a 2D but cancelled the action
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
