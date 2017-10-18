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
%scale1d.m provides the possibility of getting a x scale in Hz or PPM
%9-8-'96

try
  %
  %create entry in the undo matrix. In case QmatNMR.statuspar > 3 then the UNDO is created in the
  %predecessing routines.
  %
  if (QmatNMR.statuspar < 4)
    regelUNDO
  end
  
  %get the axis handle
  QmatNMR.TEMPAxis = gca;

  %
  %set the flag for a user-defined axis
  %
  QmatNMR.RulerXAxis = 1;
  set(QmatNMR.h670, 'checked', 'off');
  
  %
  %the next few axis types will override the flag for user-defained axis
  %
  if (QmatNMR.statuspar == 1)			%PPM-scale
    QmatNMR.Axis1D = zeros(1, QmatNMR.Size1D);
    QmatNMR.Axis1D(1:QmatNMR.Size1D) = QmatNMR.waarde + ((1:QmatNMR.Size1D)-QmatNMR.offsetx)*QmatNMR.SW1D*1000/(QmatNMR.Size1D*QmatNMR.SF1D);
    
    QmatNMR.texie = ['ppm'];
    disp('Axis in ppm');
    
    QmatNMR.RulerXAxis = 0;
    set(QmatNMR.h670, 'checked', 'on');
    
  elseif (QmatNMR.statuspar == 2)		%Hz-scale
    QmatNMR.Axis1D = zeros(1, QmatNMR.Size1D);
  
    if (QmatNMR.gamma1d == 1)	%y > 0
      QmatNMR.Axis1D(1:QmatNMR.Size1D) =  QmatNMR.waarde - ((1:QmatNMR.Size1D)-QmatNMR.offsetx)*QmatNMR.SW1D/QmatNMR.Size1D*1000;
      
    else			%y < 0
      QmatNMR.Axis1D(1:QmatNMR.Size1D) =  QmatNMR.waarde + ((1:QmatNMR.Size1D)-QmatNMR.offsetx)*QmatNMR.SW1D/QmatNMR.Size1D*1000;
    end  
      
    QmatNMR.texie = ['Hz'];
    disp('Axis in Hz');
    
    QmatNMR.RulerXAxis = 0;
    set(QmatNMR.h670, 'checked', 'on');
    
  elseif (QmatNMR.statuspar == 3)		%kHz-scale
    QmatNMR.Axis1D = zeros(1, QmatNMR.Size1D);
  
    if (QmatNMR.gamma1d == 1)	%y > 0
      QmatNMR.Axis1D(1:QmatNMR.Size1D) =  QmatNMR.waarde - ((1:QmatNMR.Size1D)-QmatNMR.offsetx)*QmatNMR.SW1D/QmatNMR.Size1D;
      
    else			%y < 0
      QmatNMR.Axis1D(1:QmatNMR.Size1D) =  QmatNMR.waarde + ((1:QmatNMR.Size1D)-QmatNMR.offsetx)*QmatNMR.SW1D/QmatNMR.Size1D;
    end  
  
    QmatNMR.texie = ['kHz'];
    disp('Axis in kHz');
    
    QmatNMR.RulerXAxis = 0;
    set(QmatNMR.h670, 'checked', 'on');
  end  
  
  
  %
  %update the reference position for the first-order phase correction based on the new axis
  %
  QmatNMR.fase1start = interp1((1:QmatNMR.Size1D).', QmatNMR.Axis1D, QmatNMR.fase1startIndex);
  
  
  %
  %begin updating the display
  %
  QmatNMR.RincrOLD = QmatNMR.Rincr;			%needed to determine wther the axis direction has changed sign
  QmatNMR.Size1D = length(QmatNMR.Axis1D);
  detaxisprops
  Qspcrel
  CheckAxis				%Check whether the new axis is descending or ascending
  
  
  %
  %Even though the default axis may be switched off, we set the reference values. Just in case the
  %user wants to go back to the default axis at some point.
  %
  if (QmatNMR.statuspar <= 3)		%only do this for ppm/Hz and kHz scales
    if (QmatNMR.statuspar == 1)			%PPM-scale
      QmatNMRsettings.DefaultAxisReferencePPM = QmatNMR.Axis1D(floor(QmatNMR.Size1D/2)+1) + (QmatNMRsettings.DefaultAxisCarrierIndex - floor(QmatNMR.Size1D/2)-1)*QmatNMR.Rincr;
      if (QmatNMR.gamma1d == 1)  %y > 0
        QmatNMRsettings.DefaultAxisReferencekHz = -(QmatNMRsettings.DefaultAxisReferencePPM * QmatNMR.SF1D)/1000;
      else
        QmatNMRsettings.DefaultAxisReferencekHz =  (QmatNMRsettings.DefaultAxisReferencePPM * QmatNMR.SF1D)/1000;
      end
    
    elseif (QmatNMR.statuspar == 2)		%Hz-scale
      if (QmatNMR.gamma1d == 1)  %y > 0
        QmatNMRsettings.DefaultAxisReferencekHz = (QmatNMR.Axis1D(floor(QmatNMR.Size1D/2)+1) + (QmatNMRsettings.DefaultAxisCarrierIndex - floor(QmatNMR.Size1D/2)-1)*QmatNMR.Rincr)/1000;
        QmatNMRsettings.DefaultAxisReferencePPM = -(QmatNMRsettings.DefaultAxisReferencekHz * 1000 / QmatNMR.SF1D);
      else
        QmatNMRsettings.DefaultAxisReferencekHz = (QmatNMR.Axis1D(floor(QmatNMR.Size1D/2)+1) + (QmatNMRsettings.DefaultAxisCarrierIndex - floor(QmatNMR.Size1D/2)-1)*QmatNMR.Rincr)/1000;
        QmatNMRsettings.DefaultAxisReferencePPM = (QmatNMRsettings.DefaultAxisReferencekHz * 1000 / QmatNMR.SF1D);
      end
    
    elseif (QmatNMR.statuspar == 3)		%kHz-scale
      if (QmatNMR.gamma1d == 1)  %y > 0
        QmatNMRsettings.DefaultAxisReferencekHz = QmatNMR.Axis1D(floor(QmatNMR.Size1D/2)+1) + (QmatNMRsettings.DefaultAxisCarrierIndex - floor(QmatNMR.Size1D/2)-1)*QmatNMR.Rincr;
        QmatNMRsettings.DefaultAxisReferencePPM = -(QmatNMRsettings.DefaultAxisReferencekHz * 1000 / QmatNMR.SF1D);
      else
        QmatNMRsettings.DefaultAxisReferencekHz = QmatNMR.Axis1D(floor(QmatNMR.Size1D/2)+1) + (QmatNMRsettings.DefaultAxisCarrierIndex - floor(QmatNMR.Size1D/2)-1)*QmatNMR.Rincr;
        QmatNMRsettings.DefaultAxisReferencePPM = (QmatNMRsettings.DefaultAxisReferencekHz * 1000 / QmatNMR.SF1D);
      end
    end
    
    if (QmatNMR.Dim == 1)			%TD2
      QmatNMRsettings.DefaultAxisReferencekHz1= QmatNMRsettings.DefaultAxisReferencekHz; 	%TD2
      QmatNMRsettings.DefaultAxisReferencePPM1= QmatNMRsettings.DefaultAxisReferencePPM; 	%TD2
    
    elseif (QmatNMR.Dim == 2) 		%TD1
      QmatNMRsettings.DefaultAxisReferencekHz2= QmatNMRsettings.DefaultAxisReferencekHz; 	%TD1
      QmatNMRsettings.DefaultAxisReferencePPM2= QmatNMRsettings.DefaultAxisReferencePPM; 	%TD1
    end
  end
  
  
  %
  %change the display, but only if we're not running a macro!
  %
  if (~QmatNMR.BusyWithMacro)
    if (QmatNMR.DisplayMode == 3)			%Both = Real+Imaginary spectrum
      asaanpas				%since this is such a special display mode we always
      					%do a "reset figure"
    else
      QTEMP6 = 0;
      if (QmatNMR.nrspc > 1)
      	%With dual plots it is important to determine whether the slope of the new axis has
      	%the same sign as the previous axis. If the slope has changed sign all spectra need
      	%to be flipped from left to right and this is only possible for the original spectrum
      	%(in principal also for the last added multiple spectrum but I don't want to make it
      	%too complicated). The plot will be reset then and all multiple spectra are removed
      	%If the slope has the same sign only the axis property will be changed for all handles.
      	%
      	%17-05-'00: When doing a dual plot now an axis can be supplied with the new trace. This
      	%means the length of the new trace may be different from the length of the old trace.
      	%Also the axis may just be different. If this is the case then an asaanpas will be done.
      	%I don't want to make an incredibly difficult routine out of this.
      	%
        QTEMP4 = findobj(findobj(allchild(gcf), 'type', 'axes', 'userdata', 1), 'type', 'line');
        for QTEMP5=1:QmatNMR.nrspc-1
          QTEMP8 = get(QTEMP4(QTEMP5), 'xdata');
          QTEMP9 = get(QTEMP4(QTEMP5+1), 'xdata');
          if length(QTEMP8) ~= length(QTEMP9)
            QTEMP6 = 1;
          else
            QTEMP6 = sum(find(QTEMP8 == QTEMP9 == 0));
          end
          
  	      if (QTEMP6)	%not all axes are equal --> do an asaanpas
            break
          end
        end
        
        QTEMP6 = 1;
      end
xx = QmatNMR.FIDstatus        
tt = QmatNMR.texie
      if (QTEMP6)
        asaanpas

      elseif (sign(QmatNMR.RincrOLD) == sign(QmatNMR.Rincr))
        set(findobj(findobj(allchild(QmatNMR.Fig), 'type', 'axes', 'userdata', 1), 'type', 'line'), 'xdata', QmatNMR.Axis1DPlot);
        set(findobj(allchild(QmatNMR.Fig), 'type', 'axes', 'userdata', 1), 'xdir', QmatNMR.AxisPlotDirection);
        updatebuttons
        
      else  
        asaanpas
      end
xx = QmatNMR.FIDstatus
tt = QmatNMR.texie
      xlabel(strrep(QmatNMR.texie, '\n', char(10)));
      
  		%set the axis limits to the new values
      QmatNMR.xmin = QmatNMR.Axis1DPlot(1);
      QmatNMR.totaalX = QmatNMR.Axis1DPlot(QmatNMR.Size1D) - QmatNMR.Axis1DPlot(1);
      axis([QmatNMR.xmin (QmatNMR.xmin+QmatNMR.totaalX) QmatNMR.ymin (QmatNMR.ymin+QmatNMR.totaalY)]);
      %
      %store the new axis limits for the zoom routine
      %
      setappdata(QmatNMR.TEMPAxis, 'ZoomLimitsMatNMR', [QmatNMR.xmin (QmatNMR.xmin+QmatNMR.totaalX) QmatNMR.ymin (QmatNMR.ymin+QmatNMR.totaalY)]);
    end
  end
  
  
  %
  %save the axis vector and or external reference in the designated variables but only for PPM, Hz and kHz scales ...
  %NOT for a user-defined axis
  %
  %only store external reference for PPM, Hz and kHz scales
  %
  if (QmatNMR.statuspar ~= 6)
    %
    %Store the axis vector if asked for
    %
    if ~isempty(QmatNMR.UserDefAxis)
      eval([QmatNMR.UserDefAxis ' = QmatNMR.Axis1D;']);
    end
  
  
    %
    %Store as external reference in its variable and if asked for in the workspace
    %
    if (QmatNMR.Dim == 0) 	%1D
      if (QmatNMR.statuspar == 1)        %external reference in ppm
        QmatNMRsettings.DefaultAxisReference1D.ReferenceFrequency = QmatNMR.SF1D;
        QmatNMRsettings.DefaultAxisReference1D.ReferenceValue = QmatNMR.Axis1D(floor(QmatNMR.Size1D/2)+1);
        QmatNMRsettings.DefaultAxisReference1D.ReferenceUnit = 1;
      
      elseif (QmatNMR.statuspar == 2)    %external reference in kHz (from a Hz scale)
        QmatNMRsettings.DefaultAxisReference1D.ReferenceFrequency = QmatNMR.SF1D;
        QmatNMRsettings.DefaultAxisReference1D.ReferenceValue = QmatNMR.Axis1D(floor(QmatNMR.Size1D/2)+1)/1000;
        QmatNMRsettings.DefaultAxisReference1D.ReferenceUnit = 2;
      
      elseif (QmatNMR.statuspar == 3)    %external reference in kHz (from a kHz scale)
        QmatNMRsettings.DefaultAxisReference1D.ReferenceFrequency = QmatNMR.SF1D;
        QmatNMRsettings.DefaultAxisReference1D.ReferenceValue = QmatNMR.Axis1D(floor(QmatNMR.Size1D/2)+1);
        QmatNMRsettings.DefaultAxisReference1D.ReferenceUnit = 2;
      end
  
    elseif (QmatNMR.Dim == 1) 	%TD2
      if (QmatNMR.statuspar == 1)        %external reference in ppm
        QmatNMRsettings.DefaultAxisReference1D.ReferenceFrequency(1) = QmatNMR.SF1D;
        QmatNMRsettings.DefaultAxisReference1D.ReferenceValue(1) = QmatNMR.Axis1D(floor(QmatNMR.Size1D/2)+1);
        QmatNMRsettings.DefaultAxisReference1D.ReferenceUnit(1) = 1;
      
      elseif (QmatNMR.statuspar == 2)    %external reference in kHz (from a Hz scale)
        QmatNMRsettings.DefaultAxisReference1D.ReferenceFrequency(1) = QmatNMR.SF1D;
        QmatNMRsettings.DefaultAxisReference1D.ReferenceValue(1) = QmatNMR.Axis1D(floor(QmatNMR.Size1D/2)+1)/1000;
        QmatNMRsettings.DefaultAxisReference1D.ReferenceUnit(1) = 2;
      
      elseif (QmatNMR.statuspar == 3)    %external reference in kHz (from a kHz scale)
        QmatNMRsettings.DefaultAxisReference1D.ReferenceFrequency(1) = QmatNMR.SF1D;
        QmatNMRsettings.DefaultAxisReference1D.ReferenceValue(1) = QmatNMR.Axis1D(floor(QmatNMR.Size1D/2)+1);
        QmatNMRsettings.DefaultAxisReference1D.ReferenceUnit(1) = 2;
      end
      QmatNMRsettings.DefaultAxisReference2D = QmatNMRsettings.DefaultAxisReference1D;
  
    elseif (QmatNMR.Dim == 2) 	%TD1
      if (QmatNMR.statuspar == 1)        %external reference in ppm
        QmatNMRsettings.DefaultAxisReference1D.ReferenceFrequency(2) = QmatNMR.SF1D;
        QmatNMRsettings.DefaultAxisReference1D.ReferenceValue(2) = QmatNMR.Axis1D(floor(QmatNMR.Size1D/2)+1);
        QmatNMRsettings.DefaultAxisReference1D.ReferenceUnit(2) = 1;
      
      elseif (QmatNMR.statuspar == 2)    %external reference in kHz (from a Hz scale)
        QmatNMRsettings.DefaultAxisReference1D.ReferenceFrequency(2) = QmatNMR.SF1D;
        QmatNMRsettings.DefaultAxisReference1D.ReferenceValue(2) = QmatNMR.Axis1D(floor(QmatNMR.Size1D/2)+1)/1000;
        QmatNMRsettings.DefaultAxisReference1D.ReferenceUnit(2) = 2;
      
      elseif (QmatNMR.statuspar == 3)    %external reference in kHz (from a kHz scale)
        QmatNMRsettings.DefaultAxisReference1D.ReferenceFrequency(2) = QmatNMR.SF1D;
        QmatNMRsettings.DefaultAxisReference1D.ReferenceValue(2) = QmatNMR.Axis1D(floor(QmatNMR.Size1D/2)+1);
        QmatNMRsettings.DefaultAxisReference1D.ReferenceUnit(2) = 2;
      end
      QmatNMRsettings.DefaultAxisReference2D = QmatNMRsettings.DefaultAxisReference1D;
    end
  
    if ~isempty(QmatNMR.UserDefRef)
      eval([QmatNMR.UserDefRef ' = QmatNMRsettings.DefaultAxisReference1D;']);
    end
  end
  
  
  if (LinearAxis(QmatNMR.Axis1D))
  		%save the new axis into the HistoryMacro
  
    if (QmatNMR.Dim == 0)		%1D
      QmatNMR.History = str2mat(QmatNMR.History, 'User-defined axis for current 1D spectrum');
  
      %first add dimension-specific information, and then the current command
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
      
      if QmatNMR.RecordingMacro
        %first add dimension-specific information, and then the current command
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
      end
  
    elseif (QmatNMR.Dim == 1)  	%TD2
      QmatNMR.History = str2mat(QmatNMR.History, 'User-defined axis for TD2');
  
      %first add dimension-specific information, and then the current command
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
      
      if QmatNMR.RecordingMacro
        %first add dimension-specific information, and then the current command
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
      end
  
    elseif (QmatNMR.Dim == 2)  	%TD1
      QmatNMR.History = str2mat(QmatNMR.History, 'User-defined axis for TD1');
  
      %first add dimension-specific information, and then the current command
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
      
      if QmatNMR.RecordingMacro
        %first add dimension-specific information, and then the current command
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
      end
    end
  
  
    %
    %Now finish the additions to the (history) macros
    %
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 14, QmatNMR.Rincr, QmatNMR.Rnull, QmatNMR.Dim, QmatNMR.SF1D, QmatNMR.SW1D, 0);	%code for user-defined axis, Linear increment of the axis, offset for the axis, dimension to work on, spectral frequency, sweepwidth, linear axis
    
    if QmatNMR.RecordingMacro
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 14, QmatNMR.Rincr, QmatNMR.Rnull, QmatNMR.Dim, QmatNMR.SF1D, QmatNMR.SW1D, 0);  	%code for user-defined axis, Linear increment of the axis, offset for the axis, dimension to work on, spectral frequency, sweepwidth, linear axis
    end
      
    
  else
    %
    %non-linear axes are stored entirely in the processing macro
    %
    QmatNMR.RincrOLD = 'QmatNMR.uiInput1 = ''[';
    for QTEMP4 = 1:length(QmatNMR.Axis1D)
      QmatNMR.RincrOLD = [QmatNMR.RincrOLD num2str(QmatNMR.Axis1D(QTEMP4), 10) ' '];
    end
  
    QmatNMR.RincrOLD = [QmatNMR.RincrOLD ']'''];
    QTEMP11 = double(QmatNMR.RincrOLD);
    QTEMP12 = ceil(length(QTEMP11)/(QmatNMR.MacroLength-1));
    QTEMP11 = [QTEMP11 zeros(1, QTEMP12*(QmatNMR.MacroLength-1) - length(QTEMP11))];
    QTEMP13 = zeros(QTEMP12, QmatNMR.MacroLength);
    QTEMP13(:, 2:end) = reshape(QTEMP11, QmatNMR.MacroLength-1, QTEMP12).';
    QTEMP13(:, 1) = 711;
  
    QmatNMR.HistoryMacro = [QmatNMR.HistoryMacro; QTEMP13];
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 712);
  
    if QmatNMR.RecordingMacro
      QmatNMR.Macro = [QmatNMR.Macro; QTEMP13];
    end  
    if QmatNMR.RecordingMacro
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 712);
    end  
  
  
    %
    %Some text output for the processing history
    %
    if (QmatNMR.Dim == 0)
      QmatNMR.History = str2mat(QmatNMR.History, 'Non-linear user-defined axis for the current 1D spectrum');
      
    elseif (QmatNMR.Dim == 1)  
      QmatNMR.History = str2mat(QmatNMR.History, 'Non-linear user-defined axis for TD2');
      
    elseif (QmatNMR.Dim == 2)  
      QmatNMR.History = str2mat(QmatNMR.History, 'Non-linear user-defined axis for TD1');
    end
  
  
    %
    %Dimension-specific information for the (history) macros
    %
    if (QmatNMR.Dim == 0)		%1D
      %first add dimension-specific information, and then the current command
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
      
      if QmatNMR.RecordingMacro
        %first add dimension-specific information, and then the current command
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
      end
  
    elseif (QmatNMR.Dim == 1)  	%TD2
      %first add dimension-specific information, and then the current command
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
      
      if QmatNMR.RecordingMacro
        %first add dimension-specific information, and then the current command
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
      end
  
    elseif (QmatNMR.Dim == 2)  	%TD1
      %first add dimension-specific information, and then the current command
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
      
      if QmatNMR.RecordingMacro
        %first add dimension-specific information, and then the current command
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
      end
    end
  
  
    %
    %Now finish the additions to the (history) macros
    %
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 14, QmatNMR.Rincr, QmatNMR.Rnull, QmatNMR.Dim, QmatNMR.SF1D, QmatNMR.SW1D, 1);	%code for user-defined axis, Linear increment of the axis, offset for the axis, dimension to work on, spectral frequency, sweepwidth, NON-LINEAR axis
    
    if QmatNMR.RecordingMacro
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 14, QmatNMR.Rincr, QmatNMR.Rnull, QmatNMR.Dim, QmatNMR.SF1D, QmatNMR.SW1D, 1);  	%code for user-defined axis, Linear increment of the axis, offset for the axis, dimension to work on, spectral frequency, sweepwidth, NON-LINEAR axis
    end
  end
  
  
  		%in case of a 2D spectrum save the axis in a variable such that matNMR knows what axis
  		%belongs to what dimension of the 2D
  if (QmatNMR.Dim == 1)		%td2
    QmatNMR.RulerXAxis1 = 1;
    QmatNMR.AxisTD2 = QmatNMR.Axis1D;
    QmatNMR.texie1 = QmatNMR.texie;
    
    detaxisprops			%determine axes offsets and increments
  
  elseif (QmatNMR.Dim == 2)  	%td1
    QmatNMR.RulerXAxis2 = 1;
    QmatNMR.AxisTD1 = QmatNMR.Axis1D;
    QmatNMR.texie2 = QmatNMR.texie;
    
    detaxisprops			%determine axes offsets and increments
  end
  
  
  		%switch the zoom back on when it was on prior to changing the axis
  if (QmatNMR.ReturnZoomFlag)
    switchzoomon
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
