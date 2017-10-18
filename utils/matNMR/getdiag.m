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
%getdiag.m takes the diagonal of a 2D variable and shows it as a 1D spectrum
%14-4-'97

try
  if (QmatNMR.Dim == 0)
    disp('matNMR NOTICE: 2D processing functions are not allowed in 1D mode!')
  
  else
    if QmatNMR.lbstatus | QmatNMR.bezigmetfase
      disp('matNMR WARNING:  not possible while apodizing or phasing!     getdiag cancelled');
  
    else
      watch;
  
      QmatNMR.FIDstatus = QmatNMR.FIDstatus2D1;			%Is this dimension still an FID ?
      set(QmatNMR.FID, 'value', QmatNMR.FIDstatus);
  
      if ((QmatNMR.SizeTD2 == QmatNMR.SizeTD1) & (QmatNMR.Rincr2 == QmatNMR.Rincr1) & (QmatNMR.Rnull2 == QmatNMR.Rnull1))
        QmatNMR.Spec1D = diag(QmatNMR.Spec2D).'; 		%square matrix and equal axes in both dimensions ==> simplest case
        QmatNMR.Axis1D = QmatNMR.AxisTD2;
        QmatNMR.Rnull = QmatNMR.Rnull1;
        QmatNMR.Rincr = QmatNMR.Rincr1;
  
      else
        %
        %The matrix is not square and/or the axes are not commensurate, so we interpolate
        %
  
        %
        %First check out which parts of the axes overlap. This area ONLY will be interpolated
        %
        QTEMP5 = [max([min(QmatNMR.AxisTD2) min(QmatNMR.AxisTD1)]) min([max(QmatNMR.AxisTD2) max(QmatNMR.AxisTD1)])];
  
        %
        %Create a new axis that will be used for the interpolation of the signal on the diagonal
        %The new axis uses the axis increment of TD2!
        %
        if (QmatNMR.Rincr1 > 0)
          QTEMP6 = QTEMP5(1):QmatNMR.Rincr1:QTEMP5(2);
  
        else
          QTEMP6 = QTEMP5(2):QmatNMR.Rincr1:QTEMP5(1);
        end
  
        if isempty(QTEMP6)
          beep
          disp('matNMR NOTICE: no common area could be found in the axes of the current spectrum for the diagonal. Aborting ...');
          return
        end
  
  
        %
        %Now interpolate
        %
        QmatNMR.Spec1D = interp2(QmatNMR.AxisTD2, QmatNMR.AxisTD1, QmatNMR.Spec2D, QTEMP6, QTEMP6, 'linear');
  
  
        %
        %Update the axis
        %
        QmatNMR.Axis1D = QTEMP6;
        QmatNMR.Rincr = (QmatNMR.Axis1D(2) - QmatNMR.Axis1D(1));
        QmatNMR.Rnull = QmatNMR.Axis1D(1) - QmatNMR.Rincr;
      end
  
      [QTEMP1 QTEMP2] = size(QmatNMR.Spec1D);
  
      QmatNMR.Dim = 0;
      setfourmode
  
      QmatNMR.RulerXAxis = 1; 		%we have defined a user-defined axis
  
      if (~QmatNMR.BusyWithMacro)
        %clear the previous 1D undo matrix
        QmatNMR.UnDoMatrix1D = GenerateMatNMRStructure;
  
        asaanpas;
        title(['The diagonal from ' strrep(QmatNMR.Spec2DName, '_', '\_')], 'Color', QmatNMR.ColorScheme.AxisFore);
      end
  
    %add this action to the processing history
      QmatNMR.History = str2mat(QmatNMR.History, 'Switched from 2D to 1D mode');
      QmatNMR.History = str2mat(QmatNMR.History, 'Extracted the diagonal from the spectrum');
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 201);	%code for diagonal
      if QmatNMR.RecordingMacro
        QmatNMR.Macro = AddToMacro(QmatNMR.HistoryMacro, 201);	%code for diagonal
      end
  
      disp('Diagonal finished');
      Arrowhead;
    end
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
