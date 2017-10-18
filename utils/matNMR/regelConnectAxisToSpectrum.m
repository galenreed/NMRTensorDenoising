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
% regelConnectAxisToSpectrum takes care of the input of a proper variable name
% whenever the user has asked for the axes to be connected to a 2D spectrum,
% whilst there not being a proper variable name (called from scale2d - 2D/3D viewer)
%
% 20-03-'03

try
  if (QmatNMR.buttonList == 1)
    QmatNMR.SpecName2D3D = QmatNMR.uiInput1;
  
    if ~CheckVariableName(QmatNMR.SpecName2D3D)
      disp('matNMR WARNING: not a correct name for a workspace variable!')
      QuiInput('Cannot save the axes using the current name!', ' OK | CANCEL', 'regelConnectAxisToSpectrum', [], 'Please supply a new variable name :', QmatNMR.SpecName2D3D);
      return
      
    else
      %
      %since the variable name is no longer the same as the name of the spectrum that was originally plotted
      %in the 2D/3D Viewer window, we are effectively dealing with a new variable. Thus we may overwrite
      %any existing variable with the same name. The processing history is not overwritten here because it
      %should have been initialized properly in the checkinputcont routine.
      %
      eval([QmatNMR.SpecName2D3D ' = GenerateMatNMRStructure;']);
      eval([QmatNMR.SpecName2D3D '.Spectrum = QmatNMR.Spec2D3D;']);
    end  
  
    QTEMP2 = LinearAxis(QmatNMR.Axis2D3DTD2);
    QTEMP3 = LinearAxis(QmatNMR.Axis2D3DTD1);
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
  
  else
    disp('Saving of the new axes with the spectrum was cancelled ...');
  end

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
