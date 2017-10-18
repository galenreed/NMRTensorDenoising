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
%doUnDo.m executes an undo. The data is read from the first entry of the undo matrix and
%	important variables are reset. The undo matrix is updated and the spectrum is plotted.
%
%03-08-'01
%

try
  if (QmatNMR.Dim == 0)		%we're in 1D mode
    if (QmatNMR.UnDo1D)			%only execute if an undo matrix is present.
      %
      %only if the size(spectrum, 2) > 1 then undo steps are available
      %
      if (size(QmatNMR.UnDoMatrix1D(1).Spectrum, 2) > 1)
        %
        %Read variables from the undo matrix
        %
        QmatNMR.Spec1D 		= QmatNMR.UnDoMatrix1D(1).Spectrum;
        QmatNMR.History 		= QmatNMR.UnDoMatrix1D(1).History;
        QmatNMR.HistoryMacro 	= QmatNMR.UnDoMatrix1D(1).HistoryMacro;
        QmatNMR.Axis1D 		= QmatNMR.UnDoMatrix1D(1).AxisTD2;
        QmatNMR.SW1D 		= QmatNMR.UnDoMatrix1D(1).SweepWidthTD2;
        QmatNMR.SF1D 		= QmatNMR.UnDoMatrix1D(1).SpectralFrequencyTD2;
        QmatNMR.gamma1d 		= QmatNMR.UnDoMatrix1D(1).GammaTD2;
        QmatNMR.FIDstatus 	= QmatNMR.UnDoMatrix1D(1).FIDstatusTD2;
        QmatNMR.fase0 		= QmatNMR.UnDoMatrix1D(1).Phase0;
        QmatNMR.fase1 		= QmatNMR.UnDoMatrix1D(1).Phase1;
        QmatNMR.fase2 		= QmatNMR.UnDoMatrix1D(1).Phase2;
        QmatNMR.fase1start 	= QmatNMR.UnDoMatrix1D(1).Phase1Start;
        QmatNMR.fase1startIndex 	= QmatNMR.UnDoMatrix1D(1).Phase1StartIndex;
        QmatNMR.RulerXAxis 	= QmatNMR.UnDoMatrix1D(1).DefaultAxisFlagTD2;
        QmatNMRsettings.DefaultAxisCarrierIndex = QmatNMR.UnDoMatrix1D(1).DefaultAxisCarrierIndexTD2;
        QmatNMRsettings.DefaultAxisReferencekHz = QmatNMR.UnDoMatrix1D(1).DefaultAxisRefkHzTD2;
        QmatNMRsettings.DefaultAxisReferencePPM = QmatNMR.UnDoMatrix1D(1).DefaultAxisRefPPMTD2;
  
  
        %
        %shift the other entries up in the undo matrix. The last entry is cleared.
        %
        if (QmatNMR.UnDo1D == 1)
          QmatNMR.UnDoMatrix1D = GenerateMatNMRStructure(1);
        else
          QmatNMR.UnDoMatrix1D(1:(QmatNMR.UnDo1D-1)) = QmatNMR.UnDoMatrix1D(2:QmatNMR.UnDo1D);
          QmatNMR.UnDoMatrix1D(QmatNMR.UnDo1D) = GenerateMatNMRStructure(1);
        end
        
          
        %
        %reset some other variables
        %
        QmatNMR.Size1D = length(QmatNMR.Spec1D);
  
        QmatNMR.bezigmetfase = 0;			%reset phasing flag
        QmatNMR.dph0 = 0;				%reset phase buttons
        QmatNMR.dph1 = 0;
        QmatNMR.dph2 = 0;
        
        QmatNMR.min = 0;				%reset baseline peaklist variable
        QmatNMR.BaslcorPeakList = [];
        
        QmatNMR.lbstatus = 0;			%reset linebroadening flag and button
        
        QmatNMR.FIDstatusLast = QmatNMR.FIDstatus;	%spectrum or FID?
        regeldisplaymode
  
  
        %
        %replot the spectrum
        %
        updatebuttons
        detaxisprops
        asaanpas
        
        %
        %output
        %
        disp('previous 1D processing action undone');
    
      else
        disp('matNMR NOTICE: cannot undo further');
      end
    end  
  
  else		%2D mode
    if (QmatNMR.UnDo2D)	%only execute if an undo matrix is present.
      %
      %only if the size(spectrum, 2) > 1 then undo steps are available
      %
      if (size(QmatNMR.UnDoMatrix2D(1).Spectrum, 2) > 1)
        %
        %Read variables from the undo matrix
        %
        QmatNMR.Spec2D 		= QmatNMR.UnDoMatrix2D(1).Spectrum;
        QmatNMR.Spec2Dhc 		= QmatNMR.UnDoMatrix2D(1).Hypercomplex;
        QmatNMR.History 		= QmatNMR.UnDoMatrix2D(1).History;
        QmatNMR.HistoryMacro 	= QmatNMR.UnDoMatrix2D(1).HistoryMacro;
        QmatNMR.AxisTD2 		= QmatNMR.UnDoMatrix2D(1).AxisTD2;
        QmatNMR.AxisTD1 		= QmatNMR.UnDoMatrix2D(1).AxisTD1;
        QmatNMR.SWTD2 		= QmatNMR.UnDoMatrix2D(1).SweepWidthTD2;
        QmatNMR.SWTD1 		= QmatNMR.UnDoMatrix2D(1).SweepWidthTD1;
        QmatNMR.SFTD2 		= QmatNMR.UnDoMatrix2D(1).SpectralFrequencyTD2;
        QmatNMR.SFTD1 		= QmatNMR.UnDoMatrix2D(1).SpectralFrequencyTD1;
        QmatNMR.FIDstatus2D1 	= QmatNMR.UnDoMatrix2D(1).FIDstatusTD2;
        QmatNMR.FIDstatus2D2 	= QmatNMR.UnDoMatrix2D(1).FIDstatusTD1;
        QmatNMR.gamma1 		= QmatNMR.UnDoMatrix2D(1).GammaTD2;
        QmatNMR.gamma2 		= QmatNMR.UnDoMatrix2D(1).GammaTD1;
        if ~isempty(QmatNMR.UnDoMatrix2D(1).PeakListNums)
          QmatNMR.PeakListNums = QmatNMR.UnDoMatrix2D(1).PeakListNums;
          QmatNMR.PeakListText = QmatNMR.UnDoMatrix2D(1).PeakListText;
        end  
        QmatNMR.fase0 		= QmatNMR.UnDoMatrix2D(1).Phase0;
        QmatNMR.fase1 		= QmatNMR.UnDoMatrix2D(1).Phase1;
        QmatNMR.fase2 		= QmatNMR.UnDoMatrix2D(1).Phase2;
        QmatNMR.fase1start 	= QmatNMR.UnDoMatrix2D(1).Phase1Start;
        QmatNMR.fase1startIndex 	= QmatNMR.UnDoMatrix2D(1).Phase1StartIndex;
        QmatNMR.RulerXAxis1 	= QmatNMR.UnDoMatrix2D(1).DefaultAxisFlagTD2;
        QmatNMR.RulerXAxis2 	= QmatNMR.UnDoMatrix2D(1).DefaultAxisFlagTD1;
        QmatNMRsettings.DefaultAxisReferencekHz1 = QmatNMR.UnDoMatrix2D(1).DefaultAxisRefkHzTD2;
        QmatNMRsettings.DefaultAxisReferencePPM1 = QmatNMR.UnDoMatrix2D(1).DefaultAxisRefPPMTD2;
        QmatNMRsettings.DefaultAxisReferencekHz2 = QmatNMR.UnDoMatrix2D(1).DefaultAxisRefkHzTD1;
        QmatNMRsettings.DefaultAxisReferencePPM2 = QmatNMR.UnDoMatrix2D(1).DefaultAxisRefPPMTD1;
        QmatNMRsettings.DefaultAxisCarrierIndex1 = QmatNMR.UnDoMatrix2D(1).DefaultAxisCarrierIndexTD2;
        QmatNMRsettings.DefaultAxisCarrierIndex2 = QmatNMR.UnDoMatrix2D(1).DefaultAxisCarrierIndexTD1;
      
      
        %
        %shift the other entries up in the undo matrix. The last entry is cleared.
        %
        if (QmatNMR.UnDo2D == 1)
          QmatNMR.UnDoMatrix2D = GenerateMatNMRStructure(1);
        else
          QmatNMR.UnDoMatrix2D(1:(QmatNMR.UnDo2D-1)) = QmatNMR.UnDoMatrix2D(2:QmatNMR.UnDo2D);
          QmatNMR.UnDoMatrix2D(QmatNMR.UnDo2D) = GenerateMatNMRStructure(1);
        end
        
          
        %
        %reset some other variables that are dimension specific
        %
        [QmatNMR.SizeTD1, QmatNMR.SizeTD2] = size(QmatNMR.Spec2D);
        if (QmatNMR.Dim == 1)		%TD2
          QmatNMR.FIDstatus = QmatNMR.FIDstatus2D1;
  	QmatNMR.Axis1D = QmatNMR.AxisTD2;
  	QmatNMR.Size1D = QmatNMR.SizeTD2;
  	QmatNMR.SW1D = QmatNMR.SWTD2;
          QmatNMR.SF1D = QmatNMR.SFTD2;
  	QmatNMR.gamma1d = QmatNMR.gamma1;
  	QmatNMR.RulerXAxis = QmatNMR.RulerXAxis1;
  
        else				%TD1
          QmatNMR.FIDstatus = QmatNMR.FIDstatus2D2;
  	QmatNMR.Axis1D = QmatNMR.AxisTD1;
  	QmatNMR.Size1D = QmatNMR.SizeTD1;
  	QmatNMR.SW1D = QmatNMR.SWTD1;
          QmatNMR.SF1D = QmatNMR.SFTD1;
  	QmatNMR.gamma1d = QmatNMR.gamma2;
  	QmatNMR.RulerXAxis = QmatNMR.RulerXAxis2;
        end
  
  
        QmatNMR.bezigmetfase = 0;			%reset phasing flag
        QmatNMR.dph0 = 0;				%reset phase buttons
        QmatNMR.dph1 = 0;
        QmatNMR.dph2 = 0;
        
        QmatNMR.min = 0;				%reset baseline peaklist variable
        QmatNMR.BaslcorPeakList = [];
        
        QmatNMR.lbstatus = 0;			%reset linebroadening flag and button
  
  
        %
        %replot the spectrum
        %
        updatebuttons
        getcurrentspectrum
        detaxisprops
        asaanpas
        
        %
        %output
        %
        disp('previous 2D processing action undone');
    
      else
        disp('matNMR NOTICE: cannot undo further');
      end
    end  
  end
  
  %
  %Add the undo step into the history macro when recording a macro only!
  %
  if QmatNMR.RecordingMacro
    QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 0);
  end  

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
