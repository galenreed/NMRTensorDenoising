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
%regelshowsidebands shows indicators in the current plot to denote sidebands
%based on the spinning speed and the sweepwidth that were entered by the user
%29-10-'03

try
  if QmatNMR.buttonList == 1		%OK-button
    QmatNMR.spinningspeed = eval(QmatNMR.uiInput1);
  
    if ((QmatNMR.uiInput2(length(QmatNMR.uiInput2)) == 'k') | (QmatNMR.uiInput2(length(QmatNMR.uiInput2)) == 'K'))
      QmatNMR.SW1D = abs(eval(QmatNMR.uiInput2(1:(length(QmatNMR.uiInput2)-1))) * 1000 );
    else
      QmatNMR.SW1D = abs(eval(QmatNMR.uiInput2));
    end
  
    if (QmatNMR.Dim == 1)
      QmatNMR.SWTD2 = QmatNMR.SW1D;
    elseif (QmatNMR.Dim == 2)
      QmatNMR.SWTD1 = QmatNMR.SW1D;
    end;  
    
    QmatNMR.sidebandLineStyle 	= QmatNMR.uiInput3;
    QmatNMR.sidebandLinewidth 	= QmatNMR.uiInput4;
    QmatNMR.sidebandMarker 	= QmatNMR.uiInput5;
    QmatNMR.sidebandMarkerSize 	= QmatNMR.uiInput6;
    QmatNMR.sidebandColour        = QmatNMR.uiInput7;
  
    %
    %the arrays with possible attributes for the markers (same as in askshowsidebands!)
    %
    QTEMP3 = str2mat('-   ', '--  ', ':   ', '-.  ', 'none');
    QTEMP4 = [0.5 1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0 15.0 20.0 30.0];
    QTEMP5 = str2mat('none', '.', '+', 'o', '*', 'x', 'square', 'diamond', '^', 'v', '>', '<', 'pentagram', 'hexagram');
    QTEMP6 = [0.5 1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0 15.0 20.0 30.0];
    QTEMP7 = str2mat('r', 'g', 'b', 'y', 'm', 'c', 'k', 'w');
  
    %
    %now ask the user to show the peak for which to show the sidebands by supplying
    %a crosshair cursor. When executing a macro this step is skipped as the data should be
    %stored in the macro
    %
    if (~QmatNMR.BusyWithMacro)
      disp('matNMR NOTICE: please press the mouse button over the peak that you want to assign the sidebands to.');
      [QTEMP92, QTEMP91] = ginput(1);
    end
    
    %
    %Determine the positions of the sidebands in the spectrum
    %
    QTEMP10 = QmatNMR.spinningspeed/QmatNMR.SW1D*QmatNMR.Size1D;		%ratio of sweep width to MAS speed in points
    QTEMP11 = ((QTEMP92 - QmatNMR.Rnull) / QmatNMR.Rincr); 		%peak offset in points
    QTEMP11 = (QTEMP11-QTEMP10*ceil(QmatNMR.Size1D/QTEMP10)):QTEMP10:(QTEMP11+QTEMP10*ceil(QmatNMR.Size1D/QTEMP10));
    QTEMP11 = QTEMP11(find((QTEMP11 > 0) & (QTEMP11 < QmatNMR.Size1D)));	%final array of sideband positions
    
    %
    %put the markers in the plot and add the requested attributes to them. Since a marker is
    %only set at a data point we currently take 10 points per QmatNMR.totaalY so that the markers can
    %always be seen. Obviously, the viewing range must be chosen appropriately before starting
    %this routine.
    %
    for QTEMP2=1:length(QTEMP11)
      %create the data points in the y direction
      QTEMP13 = [(QmatNMR.ymin-5*QmatNMR.totaalY):QmatNMR.totaalY/9:(QmatNMR.ymin+6*QmatNMR.totaalY)];
      %create the data points in the x direction
      QTEMP12 = interp1(QmatNMR.Axis1D, QTEMP11(QTEMP2))*ones(1, length(QTEMP13));
      %draw the line and set the attributes
      QTEMP10 = line(QTEMP12, QTEMP13);
      set(QTEMP10, 'linestyle' , QTEMP3(QmatNMR.sidebandLineStyle, :), ...
                   'linewidth' , QTEMP4(QmatNMR.sidebandLinewidth), ...
  	         'marker'    , QTEMP5(QmatNMR.sidebandMarker, :), ...
  	         'markersize', QTEMP6(QmatNMR.sidebandMarkerSize), ...
                   'color'     , QTEMP7(QmatNMR.sidebandColour, :));
    end
  
  
    %
    %add this to the processing history
    %
    QmatNMR.History = str2mat(QmatNMR.History, 'Sidebands shown in the current view');
    
    if (QmatNMR.Dim == 0)
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
  
    elseif (QmatNMR.Dim == 1)
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
  
    else
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
    end
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 401);
    %
    %then store the input string and the action into the history macro
    %
    QTEMP1 = deblank(fliplr(deblank(fliplr(QmatNMR.uiInput3))));			%remove trailing and heading spaces
    QTEMP11 = double(['QmatNMR.uiInput1 = ''' QTEMP1 '''']);
    QTEMP12 = ceil(length(QTEMP11)/(QmatNMR.MacroLength-1));
    QTEMP13 = zeros(1, QTEMP12*(QmatNMR.MacroLength-1));
    QTEMP13(1:length(QTEMP11)) = QTEMP11;
    for QTEMP40=1:QTEMP12
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 711, QTEMP13((QTEMP40-1)*(QmatNMR.MacroLength-1)+ (1:(QmatNMR.MacroLength-1))));
    end
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 712);
    QTEMP1 = deblank(fliplr(deblank(fliplr(QmatNMR.uiInput4))));			%remove trailing and heading spaces
    QTEMP11 = double(['QmatNMR.uiInput1 = ''' QTEMP1 '''']);
    QTEMP12 = ceil(length(QTEMP11)/(QmatNMR.MacroLength-1));
    QTEMP13 = zeros(1, QTEMP12*(QmatNMR.MacroLength-1));
    QTEMP13(1:length(QTEMP11)) = QTEMP11;
    for QTEMP40=1:QTEMP12
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 711, QTEMP13((QTEMP40-1)*(QmatNMR.MacroLength-1)+ (1:(QmatNMR.MacroLength-1))));
    end
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 712);
    QTEMP1 = deblank(fliplr(deblank(fliplr(QmatNMR.uiInput5))));			%remove trailing and heading spaces
    QTEMP11 = double(['QmatNMR.uiInput1 = ''' QTEMP1 '''']);
    QTEMP12 = ceil(length(QTEMP11)/(QmatNMR.MacroLength-1));
    QTEMP13 = zeros(1, QTEMP12*(QmatNMR.MacroLength-1));
    QTEMP13(1:length(QTEMP11)) = QTEMP11;
    for QTEMP40=1:QTEMP12
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 711, QTEMP13((QTEMP40-1)*(QmatNMR.MacroLength-1)+ (1:(QmatNMR.MacroLength-1))));
    end
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 712);
    QTEMP1 = deblank(fliplr(deblank(fliplr(QmatNMR.uiInput6))));			%remove trailing and heading spaces
    QTEMP11 = double(['QmatNMR.uiInput1 = ''' QTEMP1 '''']);
    QTEMP12 = ceil(length(QTEMP11)/(QmatNMR.MacroLength-1));
    QTEMP13 = zeros(1, QTEMP12*(QmatNMR.MacroLength-1));
    QTEMP13(1:length(QTEMP11)) = QTEMP11;
    for QTEMP40=1:QTEMP12
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 711, QTEMP13((QTEMP40-1)*(QmatNMR.MacroLength-1)+ (1:(QmatNMR.MacroLength-1))));
    end
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 712);
    QTEMP1 = deblank(fliplr(deblank(fliplr(QmatNMR.uiInput7))));			%remove trailing and heading spaces
    QTEMP11 = double(['QmatNMR.uiInput1 = ''' QTEMP1 '''']);
    QTEMP12 = ceil(length(QTEMP11)/(QmatNMR.MacroLength-1));
    QTEMP13 = zeros(1, QTEMP12*(QmatNMR.MacroLength-1));
    QTEMP13(1:length(QTEMP11)) = QTEMP11;
    for QTEMP40=1:QTEMP12
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 711, QTEMP13((QTEMP40-1)*(QmatNMR.MacroLength-1)+ (1:(QmatNMR.MacroLength-1))));
    end
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 712);
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 704, QmatNMR.spinningspeed, QmatNMR.SW1D, QTEMP92);	%code for showing sidebands
    
    if (QmatNMR.RecordingPlottingMacro | QmatNMR.RecordingMacro)
      if (QmatNMR.Dim == 0)
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
  
      elseif (QmatNMR.Dim == 1)
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
  
      else
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
      end
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 401);
  
      %
      %then store the input string and the action into the history macro
      %
      QTEMP1 = deblank(fliplr(deblank(fliplr(QmatNMR.uiInput3))));			%remove trailing and heading spaces
      QTEMP11 = double(['QmatNMR.uiInput1 = ''' QTEMP1 '''']);
      QTEMP12 = ceil(length(QTEMP11)/(QmatNMR.MacroLength-1));
      QTEMP13 = zeros(1, QTEMP12*(QmatNMR.MacroLength-1));
      QTEMP13(1:length(QTEMP11)) = QTEMP11;
      for QTEMP40=1:QTEMP12
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 711, QTEMP13((QTEMP40-1)*(QmatNMR.MacroLength-1)+ (1:(QmatNMR.MacroLength-1))));
      end
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 712);
      QTEMP1 = deblank(fliplr(deblank(fliplr(QmatNMR.uiInput4))));			%remove trailing and heading spaces
      QTEMP11 = double(['QmatNMR.uiInput1 = ''' QTEMP1 '''']);
      QTEMP12 = ceil(length(QTEMP11)/(QmatNMR.MacroLength-1));
      QTEMP13 = zeros(1, QTEMP12*(QmatNMR.MacroLength-1));
      QTEMP13(1:length(QTEMP11)) = QTEMP11;
      for QTEMP40=1:QTEMP12
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 711, QTEMP13((QTEMP40-1)*(QmatNMR.MacroLength-1)+ (1:(QmatNMR.MacroLength-1))));
      end
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 712);
      QTEMP1 = deblank(fliplr(deblank(fliplr(QmatNMR.uiInput5))));			%remove trailing and heading spaces
      QTEMP11 = double(['QmatNMR.uiInput1 = ''' QTEMP1 '''']);
      QTEMP12 = ceil(length(QTEMP11)/(QmatNMR.MacroLength-1));
      QTEMP13 = zeros(1, QTEMP12*(QmatNMR.MacroLength-1));
      QTEMP13(1:length(QTEMP11)) = QTEMP11;
      for QTEMP40=1:QTEMP12
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 711, QTEMP13((QTEMP40-1)*(QmatNMR.MacroLength-1)+ (1:(QmatNMR.MacroLength-1))));
      end
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 712);
      QTEMP1 = deblank(fliplr(deblank(fliplr(QmatNMR.uiInput6))));			%remove trailing and heading spaces
      QTEMP11 = double(['QmatNMR.uiInput1 = ''' QTEMP1 '''']);
      QTEMP12 = ceil(length(QTEMP11)/(QmatNMR.MacroLength-1));
      QTEMP13 = zeros(1, QTEMP12*(QmatNMR.MacroLength-1));
      QTEMP13(1:length(QTEMP11)) = QTEMP11;
      for QTEMP40=1:QTEMP12
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 711, QTEMP13((QTEMP40-1)*(QmatNMR.MacroLength-1)+ (1:(QmatNMR.MacroLength-1))));
      end
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 712);
      QTEMP1 = deblank(fliplr(deblank(fliplr(QmatNMR.uiInput7))));			%remove trailing and heading spaces
      QTEMP11 = double(['QmatNMR.uiInput1 = ''' QTEMP1 '''']);
      QTEMP12 = ceil(length(QTEMP11)/(QmatNMR.MacroLength-1));
      QTEMP13 = zeros(1, QTEMP12*(QmatNMR.MacroLength-1));
      QTEMP13(1:length(QTEMP11)) = QTEMP11;
      for QTEMP40=1:QTEMP12
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 711, QTEMP13((QTEMP40-1)*(QmatNMR.MacroLength-1)+ (1:(QmatNMR.MacroLength-1))));
      end
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 712);
  
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 704, QmatNMR.spinningspeed, QmatNMR.SW1D, QTEMP92);	%code for showing sidebands
    end
    
    disp('sidebands indicated in the current spectrum');
  
  else
    disp('Action cancelled. No sidebands will be indicated ...');
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
