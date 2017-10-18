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
%regelskyline.m shows the skyline projection along a certain angle of the current 2D spectrum

try
  if (QmatNMR.buttonList == 1)				%= OK-button
    watch;
  
    QmatNMR.FIDstatus = QmatNMR.FIDstatus2D1;			%Is this dimension still an FID ?
    set(QmatNMR.FID, 'value', QmatNMR.FIDstatus);
    regeldisplaymode
  
    QmatNMR.SkyLineAngle = mod(str2num(QmatNMR.uiInput1), 180);
    QmatNMR.Spec1D = Qskyline(QmatNMR.Spec2D, QmatNMR.SkyLineAngle);
    
    if (length(QmatNMR.Spec1D) == 0)
      getcurrentspectrum
      disp('matNMR WARNING: No Skyline found. Maybe something is wrong ?!?')
      Arrowhead
  
    else
      [QTEMP1 QTEMP2] = size(QmatNMR.Spec1DPlot);
  
      QmatNMR.Axis1D(1:QTEMP2) = 1:QTEMP2;
      QmatNMR.RulerXAxis = 1;		%since we define an axis in Points
      QmatNMR.texie = 'Points';
      QmatNMR.Rincr = 1;
      QmatNMR.Rnull = 0;
      QmatNMR.Dim = 0;
      setfourmode
  
      if (~QmatNMR.BusyWithMacro)
        %clear the previous 1D undo matrix
        QmatNMR.UnDoMatrix1D = GenerateMatNMRStructure;
      
        asaanpas;
        title([QmatNMR.uiInput1 ' degree skyline projection from ' strrep(QmatNMR.Spec2DName, '_', '\_')], 'Color', QmatNMR.ColorScheme.AxisFore);
      end  
  
    %add this action to the processing history
      QmatNMR.History = str2mat(QmatNMR.History, 'Switched from 2D to 1D mode');
      QmatNMR.History = str2mat(QmatNMR.History, 'Extracted a skyline projection from the spectrum');
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 205, QmatNMR.SkyLineAngle);	%code for skyline projection, angle to project at
      if QmatNMR.RecordingMacro
        QmatNMR.Macro = AddToMacro(QmatNMR.HistoryMacro, 205, QmatNMR.SkyLineAngle);	%code for skyline projection, angle to project at
      end
  
      disp('Skyline Projection finished');
      Arrowhead;
      clear QTEMP*
    end  
  else
    disp('Skyline projection cancelled');
  end  

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
