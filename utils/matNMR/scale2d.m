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
%scale2d.m finishes the work of stats2d.m
%
%21-2-1997

try
  [QTEMP16, QTEMP15] = size(QmatNMR.Spec2D3D);
    
  QTEMPvec1 = zeros(1, QTEMP15);
  QTEMPvec2 = zeros(1, QTEMP16);
  
  			%define a new axis
  if QmatNMR.statuspar2d == 1	%PPM
    QTEMP17=1:QTEMP15;
    QTEMPvec1(1, QTEMP17) = QmatNMR.waarde2 + (QTEMP17-QmatNMR.offset2)*QmatNMR.SWTD2*1000/(QTEMP15*QmatNMR.SFTD2);
    
    QTEMP18=1:QTEMP16;
    QTEMPvec2(1, QTEMP18) = QmatNMR.waarde1 + (QTEMP18-QmatNMR.offset1)*QmatNMR.SWTD1*1000/(QTEMP16*QmatNMR.SFTD1); 
  
    QmatNMR.textt1 = 'T1 (ppm)';
    QmatNMR.textt2 = 'T2 (ppm)';
    disp('Axes in ppm');
    
  elseif QmatNMR.statuspar2d == 2	%Hz
  			%Axis for td 2
    QTEMP17=1:QTEMP15;
    if (QmatNMR.gamma2d1 == 1)	%y > 0
      QTEMPvec1(1, QTEMP17) =  QmatNMR.waarde2 - (QTEMP17-QmatNMR.offset2)*QmatNMR.SWTD2/QTEMP15*1000;
      
    else			%y < 0
      QTEMPvec1(1, QTEMP17) =  fliplr(QmatNMR.waarde2 - (QTEMP17-(QTEMP15+1-QmatNMR.offset2))*QmatNMR.SWTD2/QTEMP15*1000);
    end;  
  
  			%Axis for td 1
    QTEMP18=1:QTEMP16;
    if (QmatNMR.gamma2d2 == 1)	%y > 0
      QTEMPvec2(1, QTEMP18) =  QmatNMR.waarde1 - (QTEMP18-QmatNMR.offset1)*QmatNMR.SWTD1/QTEMP16*1000;
      
    else			%y < 0
      QTEMPvec2(1, QTEMP18) =  fliplr(QmatNMR.waarde1 - (QTEMP18-(QTEMP16+1-QmatNMR.offset1))*QmatNMR.SWTD1/QTEMP16*1000);
    end;  
    
  
    QmatNMR.textt1 = 'T1 (Hz)';
    QmatNMR.textt2 = 'T2 (Hz)';
    disp('Axes in Hz');
    
  elseif QmatNMR.statuspar2d == 3	%kHz
  			%Axis for td 2
    QTEMP17=1:QTEMP15;
    if (QmatNMR.gamma2d1 == 1)	%y > 0
      QTEMPvec1(1, QTEMP17) =  QmatNMR.waarde2 - (QTEMP17-QmatNMR.offset2)*QmatNMR.SWTD2/QTEMP15;
      
    else			%y < 0
      QTEMPvec1(1, QTEMP17) =  fliplr(QmatNMR.waarde2 - (QTEMP17-(QTEMP15+1-QmatNMR.offset2))*QmatNMR.SWTD2/QTEMP15);
    end;  
  
  			%Axis for td 1
    QTEMP18=1:QTEMP16;
    if (QmatNMR.gamma2d2 == 1)	%y > 0
      QTEMPvec2(1, QTEMP18) =  QmatNMR.waarde1 - (QTEMP18-QmatNMR.offset1)*QmatNMR.SWTD1/QTEMP16;
      
    else			%y < 0
      QTEMPvec2(1, QTEMP18) =  fliplr(QmatNMR.waarde1 - (QTEMP18-(QTEMP16+1-QmatNMR.offset1))*QmatNMR.SWTD1/QTEMP16);
    end;  
  
    QmatNMR.textt1 = 'T1 (kHz)';
    QmatNMR.textt2 = 'T2 (kHz)';
    disp('Axes in kHz');
    
  elseif QmatNMR.statuspar2d == 4	%time
    QTEMPvec1 = QmatNMR.TimeAxisStartTD2 + (0:(QTEMP15-1))*QmatNMR.TimeAxisDwellTD2;
    QTEMPvec2 = QmatNMR.TimeAxisStartTD1 + (0:(QTEMP16-1))*QmatNMR.TimeAxisDwellTD1;
    
    QmatNMR.textt1 = 'T1 (Time)';
    QmatNMR.textt2 = 'T2 (Time)';
    
    disp('Time Axes');
    
  elseif QmatNMR.statuspar2d == 5	%points
    QTEMPvec1 = 1:QTEMP15;
    QTEMPvec2 = 1:QTEMP16;
    
    QmatNMR.textt1 = 'T1 (Points)';
    QmatNMR.textt2 = 'T2 (Points)';
    
    disp('Axes in Points');
    
  elseif QmatNMR.statuspar2d == 6	%user-defined axis
    QTEMPvec1 = eval(QmatNMR.UserDefAxisT2Cont);
    QTEMPvec2 = eval(QmatNMR.UserDefAxisT1Cont);
    
    QmatNMR.textt1 = 'T1 (User-Def.)';
    QmatNMR.textt2 = 'T2 (User-Def.)';
    
    disp('User-Defined Axes');
  end
  
  QmatNMR.aswaarden = [QTEMPvec1(1) QTEMPvec1(QTEMP15) QTEMPvec2(1) QTEMPvec2(QTEMP16)];
  
  
  
  
  
  				%make new axis effective ...
    				%First determine the axis properties of the current axis from the
  				%userdata axis property --> the axis information is saved into that!
  QTEMP11 = get(QmatNMR.Fig2D3D, 'userdata');
  QTEMP12 = QTEMP11.PlotParams(QmatNMR.AxisNR2D3D).AxisProps;
  QTEMP1 = QTEMP12(1:2);
  QTEMP2 = QTEMP12(3:4);
      
  				%Then set the new axis    
  QmatNMR.Axis2D3DTD2 = QTEMPvec1;
  QmatNMR.Axis2D3DTD1 = QTEMPvec2;
  
  				%Then calculate the slope and offset of the new axis
  QTEMP3 = [(QmatNMR.Axis2D3DTD2(2)-QmatNMR.Axis2D3DTD2(1)) (2*QmatNMR.Axis2D3DTD2(1)-QmatNMR.Axis2D3DTD2(2))];
  QTEMP4 = [(QmatNMR.Axis2D3DTD1(2)-QmatNMR.Axis2D3DTD1(1)) (2*QmatNMR.Axis2D3DTD1(1)-QmatNMR.Axis2D3DTD1(2))];
  
  if (sign(QTEMP1(1)) == sign(QTEMP3(1))) & (sign(QTEMP2(1)) == sign(QTEMP4(1))) & (QTEMP3(1) > 0) & (QTEMP4(1) > 0)
  				%it is much faster to adjust the 'xdata' and 'ydata' property of all
  				%patches and lines than to recalculate the whole contour plot.
  				%This however only works when the directions of both axis vectors have
  				%not changed. In this case they have not and therefore:
  				
  				%Then reset all patches to the new axis
  				%
  				%old axis: value = a*x + b
  				%new axis: value = c*x + d
  				%
  				%method: new value= (value-b)*c/a + d
  				%
    QTEMP5 = QTEMP3(1)/QTEMP1(1);
    QTEMP6 = QTEMP4(1)/QTEMP2(1);
    QTEMP7 = [findobj(allchild(gca), 'type', 'patch'); findobj(allchild(gca), 'type', 'line'); findobj(allchild(gca), 'type', 'surface'); findobj(allchild(gca), 'type', 'image')];
    for QTEMP8=1:length(QTEMP7)
      QTEMP9 = get(QTEMP7(QTEMP8), 'xdata');
      QTEMP10= get(QTEMP7(QTEMP8), 'ydata');
      set(QTEMP7(QTEMP8), 'xdata', (QTEMP9-QTEMP1(2))*QTEMP5+QTEMP3(2), 'ydata', (QTEMP10-QTEMP2(2))*QTEMP6+QTEMP4(2));
    end
  
    axis(QmatNMR.aswaarden);
    
    				%save the offset and slope of each axis ruler in the userdata of the axis
  				%then always the intensity can be calculated properly (for 'get position' and
  				%'peak picking')
    QTEMP11.PlotParams(QmatNMR.AxisNR2D3D).AxisProps = [(QmatNMR.Axis2D3DTD2(2)-QmatNMR.Axis2D3DTD2(1)) (2*QmatNMR.Axis2D3DTD2(1)-QmatNMR.Axis2D3DTD2(2)) (QmatNMR.Axis2D3DTD1(2)-QmatNMR.Axis2D3DTD1(1)) (2*QmatNMR.Axis2D3DTD1(1)-QmatNMR.Axis2D3DTD1(2))];
    QTEMP11.PlotParams(QmatNMR.AxisNR2D3D).AnalyserAxisTD2 = QmatNMR.Axis2D3DTD2;
    QTEMP11.PlotParams(QmatNMR.AxisNR2D3D).AnalyserAxisTD1 = QmatNMR.Axis2D3DTD1;
    set(QmatNMR.Fig2D3D, 'userdata', QTEMP11);  
  
    %
    %In case the current plot is a contour plot then we need to check whether a 
    %peak list is present and, if so, replot it as well
    %
    if ((QTEMP11.PlotType(QmatNMR.AxisNR2D3D) == 1) | (QTEMP11.PlotType(QmatNMR.AxisNR2D3D) == 2))
    				%change the values in the peak list too! because else the positions will
  				%not be maintained properly.
      if ~isempty(QmatNMR.PeakList)
        QmatNMR.PeakList(:, 1) = (QmatNMR.PeakList(:, 1)-QTEMP1(2))*QTEMP5 + QTEMP3(2);
        QmatNMR.PeakList(:, 2) = (QmatNMR.PeakList(:, 2)-QTEMP2(2))*QTEMP6 + QTEMP4(2);
        restorepeaklist2
      end
    end  
      
  else				%
    				%no other choice but to redraw the whole plot .... 
  				%
  
  				%old axis: value = a*x + b
  				%new axis: value = c*x + d
  				%
  				%method: new value= (value-b)*c/a + d
  				%
    QTEMP5 = QTEMP3(1)/QTEMP1(1);
    QTEMP6 = QTEMP4(1)/QTEMP2(1);
  
    				%save the offset and slope of each axis ruler in the userdata of the axis
  				%then always the intensity can be calculated properly (for 'get position' and
  				%'peak picking')
    QTEMP11.PlotParams(QmatNMR.AxisNR2D3D).AxisProps = [(QmatNMR.Axis2D3DTD2(2)-QmatNMR.Axis2D3DTD2(1)) (2*QmatNMR.Axis2D3DTD2(1)-QmatNMR.Axis2D3DTD2(2)) (QmatNMR.Axis2D3DTD1(2)-QmatNMR.Axis2D3DTD1(1)) (2*QmatNMR.Axis2D3DTD1(1)-QmatNMR.Axis2D3DTD1(2))];
    QTEMP11.PlotParams(QmatNMR.AxisNR2D3D).AnalyserAxisTD2 = QmatNMR.Axis2D3DTD2;
    QTEMP11.PlotParams(QmatNMR.AxisNR2D3D).AnalyserAxisTD1 = QmatNMR.Axis2D3DTD1;
    set(QmatNMR.Fig2D3D, 'userdata', QTEMP11);  
  
    %
    %In case the current plot is a contour plot then we need to check whether a 
    %peak list is present and, if so, replot it as well
    %
    if ((QTEMP11.PlotType(QmatNMR.AxisNR2D3D) == 1) | (QTEMP11.PlotType(QmatNMR.AxisNR2D3D) == 2))
    				%change the values in the peak list too! because else the positions will
  				%not be maintained properly.
      if ~isempty(QmatNMR.PeakList)
        QmatNMR.PeakList(:, 1) = (QmatNMR.PeakList(:, 1)-QTEMP1(2))*QTEMP5 + QTEMP3(2);
        QmatNMR.PeakList(:, 2) = (QmatNMR.PeakList(:, 2)-QTEMP2(2))*QTEMP6 + QTEMP4(2);
      
    
    				%take care of text labels from the peak list as they will be lost elseway
        QTEMP11 = size(QmatNMR.PeakList);
    					%Create a proper list to save
        QTEMP12 = [QmatNMR.PeakList(1:QTEMP11(1), 1:3) QmatNMR.PeakList(1:QTEMP11(1), 5)];
        QTEMP13 = get(QmatNMR.PeakList(1,4), 'String');
        for QTel=2:QTEMP11(1)
          QTEMP13 = str2mat(QTEMP13, get(QmatNMR.PeakList(QTel,4), 'String'));
        end  
      end  
  
      QmatNMR.RestorePeaklist = 1;	%this flag is used to make plotcont NOT execute the restorepeaklist routine
      plotcont
      QmatNMR.RestorePeaklist = 0;
      restorepeaklist3
  
    elseif (QTEMP11.PlotType(QmatNMR.AxisNR2D3D) == 3)	%mesh/surface plot
      dispmesh
  
    elseif (QTEMP11.PlotType(QmatNMR.AxisNR2D3D) == 4)	%stack3d plot
      dispstack3D
  
    elseif (QTEMP11.PlotType(QmatNMR.AxisNR2D3D) == 5)	%raster plot
      dispraster2D
  
    elseif (QTEMP11.PlotType(QmatNMR.AxisNR2D3D) == 6)	%polar plot
      disp('matNMR WARNING: This is not supported. Please report this as a bug!')
  
    elseif (QTEMP11.PlotType(QmatNMR.AxisNR2D3D) == 7)	%mesh/surface plot
      disp('matNMR WARNING: This is not supported. Please report this as a bug!')
  
    elseif (QTEMP11.PlotType(QmatNMR.AxisNR2D3D) == 8)	%line plot
      disp('matNMR WARNING: This is not supported. Please report this as a bug!')
    end
  end  
  
  
  %%%%
  %%%%Some beauty is needed now ...
  %%%%
  
  		%put new labels along the axes
  xlabel(strrep(QmatNMR.textt2, '\n', char(10)));
  ylabel(strrep(QmatNMR.textt1, '\n', char(10)));         
  		%
  		%save the axis vectors in the designated variables for PPM and Hz is asked
  		%for in the input window ...
  		%but not for a user-defined variable!
  		%
  if (QmatNMR.statuspar2d < 5)		%save unless axis in points or user-defined axis.
    if ~isempty(QmatNMR.UserDefAxisT2Cont)
      eval([QmatNMR.UserDefAxisT2Cont ' = QTEMPvec1;']);
    end
  
    if ~isempty(QmatNMR.UserDefAxisT1Cont)
      eval([QmatNMR.UserDefAxisT1Cont ' = QTEMPvec2;']);
    end
  end
  
  
  
  
  %
  %If asked for by the user now the axis variables will be connected to the variable and
  %the history will be appended. If the current variable is not a structure yet, it will
  %be made into a matNMR structure and saved as such in the workspace. If the current
  %variable name cannot be stored in the workspace the user will be asked to supply a
  %new name (or cancel)
  %
  if (QmatNMR.ConnectAxisToVariable2D)
    %
    %check whether the axes are linear. If not then they can't be stored
    %
    QTEMP2 = LinearAxis(QmatNMR.Axis2D3DTD2);
    QTEMP3 = LinearAxis(QmatNMR.Axis2D3DTD1);
    
    if ~(QTEMP2 | QTEMP3)		%both axes non-linear. Give message and abort
      disp('matNMR WARNING: Both new axes are non-linear and will therefore not be saved in the history macro!');
      disp('matNMR WARNING: This means it will not be available when reprocessing from the history.');
      disp('matNMR WARNING: spectrum variable remains unchanged.')
      return
  
    elseif ~(QTEMP2)		%only TD 2 non-linear
      disp('matNMR WARNING: The new axis for TD 2 is non-linear and will therefore not be saved in the history macro!');
      disp('matNMR WARNING: This means it will not be available when reprocessing from the history.');
  
    elseif ~(QTEMP3)		%only TD 1 non-linear
      disp('matNMR WARNING: The new axis for TD 1 is non-linear and will therefore not be saved in the history macro!');
      disp('matNMR WARNING: This means it will not be available when reprocessing from the history.');
    end
    
    %
    %check whether the variable already is a structure
    %
    if (isa(eval(QmatNMR.SpecName2D3D), 'struct'))
      %
      %no action. It is a structure and we should have the variables QmatNMR.History2D3D and
      %QmatNMR.ContSpecHistoryMacro in the workspace memory.
      %
  
    %
    %it's not a structure but is it a proper variable name so we can make it into a structure?
    %
    elseif CheckVariableName(QmatNMR.SpecName2D3D)
      
      					%it is a good name and so we make a structure out of it and fill it.
      eval([QmatNMR.SpecName2D3D ' = GenerateMatNMRStructure;']);
      eval([QmatNMR.SpecName2D3D '.Spectrum = QmatNMR.Spec2D3D;']);
  
    else
      %
      %we need to ask for a proper name unfortunately
      %
      QuiInput('Cannot save the axes using the current name!', ' OK | CANCEL', 'regelConnectAxisToSpectrum', [], 'Please supply a new variable name :', QmatNMR.SpecName2D3D);
      return
      
    end  
  
    if (QTEMP2)
      QmatNMR.History2D3D = str2mat(QmatNMR.History2D3D, 'User-defined axis for TD2');
      QmatNMR.ContSpecHistoryMacro = AddToMacro(QmatNMR.ContSpecHistoryMacro, 14, (QmatNMR.Axis2D3DTD2(2)-QmatNMR.Axis2D3DTD2(1)), (2*QmatNMR.Axis2D3DTD2(1)-QmatNMR.Axis2D3DTD2(2)), 1, QmatNMR.SFTD2, QmatNMR.SWTD2);    %code for user-defined axis, Linear increment of the axis, offset for the axis, dimension to work on, spectral frequency, sweepwidth
    end
  
    if (QTEMP3)
      QmatNMR.History2D3D = str2mat(QmatNMR.History2D3D, 'User-defined axis for TD1');
      QmatNMR.ContSpecHistoryMacro = AddToMacro(QmatNMR.ContSpecHistoryMacro, 14, (QmatNMR.Axis2D3DTD1(2)-QmatNMR.Axis2D3DTD1(1)), (2*QmatNMR.Axis2D3DTD1(1)-QmatNMR.Axis2D3DTD1(2)), 2, QmatNMR.SFTD1, QmatNMR.SWTD1);    %code for user-defined axis, Linear increment of the axis, offset for the axis, dimension to work on, spectral frequency, sweepwidth
    end
    
    %
    %Append all variables in the structure in the workspace.
    %
    eval([QmatNMR.SpecName2D3D '.AxisTD2 = QmatNMR.Axis2D3DTD2;']);
    eval([QmatNMR.SpecName2D3D '.AxisTD1 = QmatNMR.Axis2D3DTD1;']);
    eval([QmatNMR.SpecName2D3D '.History = QmatNMR.History2D3D;']);
    eval([QmatNMR.SpecName2D3D '.HistoryMacro = QmatNMR.ContSpecHistoryMacro;']);
    eval([QmatNMR.SpecName2D3D '.SweepWidthTD2 = QmatNMR.SWTD2;']);
    eval([QmatNMR.SpecName2D3D '.SpectralFrequencyTD2 = QmatNMR.SFTD2;']);
    eval([QmatNMR.SpecName2D3D '.SweepWidthTD1 = QmatNMR.SWTD1;']);
    eval([QmatNMR.SpecName2D3D '.SpectralFrequencyTD1 = QmatNMR.SFTD1;']);
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
