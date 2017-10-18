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
%regelUNDO.m takes care of the undo function in matNMR. A struct array of matNMR structures
%	is created to store the data. If undo is unwanted (QmatNMR.UnDo=0) then nothing is
%	done. This routine may cause extreme memory usage and one must be very careful
%	with setting QmatNMR.UnDo too large.
%	To execute an undo the routine doUnDo.m is used.
%
%03-08-'01

try
  if (QmatNMR.Dim == 0)		%we're in 1D mode
    if (QmatNMR.UnDo1D)			%only execute if an undo matrix is present.
      %
      %check whether the size of the undo matrix (1D mode) corresponds to QmatNMR.UnDo
      %
      if (isfield(QmatNMR, 'UnDoMatrix1D'))
        if (~(QmatNMR.UnDo1D == size(QmatNMR.UnDoMatrix1D, 2)) | ~(isstruct(QmatNMR.UnDoMatrix1D)))
          QmatNMR.UnDoMatrix1D = GenerateMatNMRStructure(1);
          for QTEMP41 = 2:QmatNMR.UnDo1D
            QmatNMR.UnDoMatrix1D(QTEMP41) = GenerateMatNMRStructure(1);
          end
        end
      else
        QmatNMR.UnDoMatrix1D = GenerateMatNMRStructure(1);
        for QTEMP41 = 2:QmatNMR.UnDo1D
          QmatNMR.UnDoMatrix1D(QTEMP41) = GenerateMatNMRStructure(1);
        end
      end
      
      if ~(strcmp(QmatNMR.History(size(QmatNMR.History,1), 1:5), 'Phase') & (QmatNMR.BusyWith1DPhaseCorrection))
      						%if the last entry in the history is a phase correction, and the current
  						%manipulation is also a phase correction then don't append to the undo 
  						%in all other cases we append normally to the undo matrix
        %
        %Add the current spectrum and other data in the first entry of the UnDo matrix, while
        %shifting the others ahead.
        %
        QmatNMR.UnDoMatrix1D(2:QmatNMR.UnDo1D) 		= QmatNMR.UnDoMatrix1D(1:(QmatNMR.UnDo1D-1));
        QmatNMR.UnDoMatrix1D(1).Spectrum 	= QmatNMR.Spec1D;
        QmatNMR.UnDoMatrix1D(1).History 		= QmatNMR.History;
        QmatNMR.UnDoMatrix1D(1).HistoryMacro 	= QmatNMR.HistoryMacro;
        QmatNMR.UnDoMatrix1D(1).AxisTD2 		= QmatNMR.Axis1D;
        QmatNMR.UnDoMatrix1D(1).SweepWidthTD2 	= QmatNMR.SW1D;
        QmatNMR.UnDoMatrix1D(1).SpectralFrequencyTD2 = QmatNMR.SF1D;
        QmatNMR.UnDoMatrix1D(1).FIDstatusTD2 	= QmatNMR.FIDstatus;
        QmatNMR.UnDoMatrix1D(1).GammaTD2 	= QmatNMR.gamma1d;
        QmatNMR.UnDoMatrix1D(1).Phase0 		= QmatNMR.fase0;
        QmatNMR.UnDoMatrix1D(1).Phase1 		= QmatNMR.fase1;
        QmatNMR.UnDoMatrix1D(1).Phase2 		= QmatNMR.fase2;
        QmatNMR.UnDoMatrix1D(1).Phase1Start 	= QmatNMR.fase1start;
        QmatNMR.UnDoMatrix1D(1).Phase1StartIndex 	= QmatNMR.fase1startIndex;
        QmatNMR.UnDoMatrix1D(1).DefaultAxisFlagTD2= QmatNMR.RulerXAxis;
        QmatNMR.UnDoMatrix1D(1).DefaultAxisRefkHzTD2= QmatNMRsettings.DefaultAxisReferencekHz;
        QmatNMR.UnDoMatrix1D(1).DefaultAxisRefPPMTD2= QmatNMRsettings.DefaultAxisReferencePPM;
        QmatNMR.UnDoMatrix1D(1).DefaultAxisCarrierIndexTD2 = QmatNMRsettings.DefaultAxisCarrierIndex;
      end
    
    else 	%clear the undo matrices to save memory
      if (isfield(QmatNMR, 'UnDoMatrix1D'))
        QmatNMR = rmfield(QmatNMR, 'UnDoMatrix1D');
      end
    end
    
  else				%2D mode
    if (QmatNMR.UnDo2D)			%only execute if an undo matrix is present.
      %
      %check whether the size of the undo matrix (2D mode) corresponds to QmatNMR.UnDo
      %
      if (isfield(QmatNMR, 'UnDoMatrix2D'))
        if (~(QmatNMR.UnDo2D == size(QmatNMR.UnDoMatrix2D, 2)) | ~(isstruct(QmatNMR.UnDoMatrix2D)))
          QmatNMR.UnDoMatrix2D = GenerateMatNMRStructure(1);
          for QTEMP41 = 2:QmatNMR.UnDo2D
            QmatNMR.UnDoMatrix2D(QTEMP41) = GenerateMatNMRStructure(1);
          end
        end
      else
        QmatNMR.UnDoMatrix2D = GenerateMatNMRStructure(1);
        for QTEMP41 = 2:QmatNMR.UnDo2D
          QmatNMR.UnDoMatrix2D(QTEMP41) = GenerateMatNMRStructure(1);
        end
      end
      
      if ~(QmatNMR.BusyWith1DPhaseCorrection)
        						%if the current action is a 1D phase correction then don't append to 
  						%the undo in all other cases we append normally to the undo matrix
        %
        %Add the current spectrum and other data in the first entry of the UnDo matrix, while
        %shifting the others ahead.
        %
        QmatNMR.UnDoMatrix2D(2:QmatNMR.UnDo2D) 		= QmatNMR.UnDoMatrix2D(1:(QmatNMR.UnDo2D-1));
        QmatNMR.UnDoMatrix2D(1).Spectrum 	= QmatNMR.Spec2D;
        QmatNMR.UnDoMatrix2D(1).Hypercomplex	= QmatNMR.Spec2Dhc;
        QmatNMR.UnDoMatrix2D(1).History 		= QmatNMR.History;
        QmatNMR.UnDoMatrix2D(1).HistoryMacro 	= QmatNMR.HistoryMacro;
        QmatNMR.UnDoMatrix2D(1).AxisTD2 		= QmatNMR.AxisTD2;
        QmatNMR.UnDoMatrix2D(1).AxisTD1 		= QmatNMR.AxisTD1;
        QmatNMR.UnDoMatrix2D(1).SweepWidthTD2 	= QmatNMR.SWTD2;
        QmatNMR.UnDoMatrix2D(1).SweepWidthTD1 	= QmatNMR.SWTD1;
        QmatNMR.UnDoMatrix2D(1).SpectralFrequencyTD2 = QmatNMR.SFTD2;
        QmatNMR.UnDoMatrix2D(1).SpectralFrequencyTD1 = QmatNMR.SFTD1;
        QmatNMR.UnDoMatrix2D(1).FIDstatusTD2 	= QmatNMR.FIDstatus2D1;
        QmatNMR.UnDoMatrix2D(1).FIDstatusTD1 	= QmatNMR.FIDstatus2D2;
        QmatNMR.UnDoMatrix2D(1).GammaTD2 	= QmatNMR.gamma1;
        QmatNMR.UnDoMatrix2D(1).GammaTD1 	= QmatNMR.gamma2;
        QmatNMR.UnDoMatrix2D(1).DefaultAxisFlagTD2 = QmatNMR.RulerXAxis1;
        QmatNMR.UnDoMatrix2D(1).DefaultAxisFlagTD1 = QmatNMR.RulerXAxis2;
        QmatNMR.UnDoMatrix2D(1).DefaultAxisCarrierIndexTD2 = QmatNMRsettings.DefaultAxisCarrierIndex1;
        QmatNMR.UnDoMatrix2D(1).DefaultAxisRefkHzTD2= QmatNMRsettings.DefaultAxisReferencekHz1;
        QmatNMR.UnDoMatrix2D(1).DefaultAxisRefPPMTD2= QmatNMRsettings.DefaultAxisReferencePPM1;
        QmatNMR.UnDoMatrix2D(1).DefaultAxisCarrierIndexTD1 = QmatNMRsettings.DefaultAxisCarrierIndex2;
        QmatNMR.UnDoMatrix2D(1).DefaultAxisRefkHzTD1= QmatNMRsettings.DefaultAxisReferencekHz2;
        QmatNMR.UnDoMatrix2D(1).DefaultAxisRefPPMTD1= QmatNMRsettings.DefaultAxisReferencePPM2;
    
        if ~isempty(QmatNMR.PeakListNums)
          QmatNMR.UnDoMatrix2D(1).PeakListNums 	= QmatNMR.PeakListNums;
          QmatNMR.UnDoMatrix2D(1).PeakListText 	= QmatNMR.PeakListText;
        end
  
        %
        %The next values are for the phase. For 2D spectra these are not actually stored because
        %of the following reason:
        %Suppose we store the phase values. And suppose we have just selected a phase for the
        %2D which we like. We will now execute the "set phase 2D" function. This in turn will
        %first make a backup for the undo function. And because the phase values have already
        %been set at this time (essentially we have first done 1D phase correction), these
        %new values will be connected to the old 2D spectrum. And upon undoing we would
        %restore the old spectrum with the new phase values. This creates a strange situation
        %since the new phase values were only valid for the current slice in the screen.
        %Now, we could obviously use the docurrentphase script to execute these phase values
        %for the old spectrum. This could be useful but has the strong disadvantage that the
        %line in the screen doesn't change upon pushing the undo button! Obviously there was
        %a change because we're really back to the moment just before pushing the "set phase
        %2D" button, but that is a very subtle difference (note though that with the single-
        %slice phase setting the difference is relevant). I have chosen to go back to before
        %having set the new phase values because that way the change is more obvious.
        %
        QmatNMR.UnDoMatrix2D(1).Phase0 		= 0;
        QmatNMR.UnDoMatrix2D(1).Phase1 		= 0;
        QmatNMR.UnDoMatrix2D(1).Phase2 		= 0;
        QmatNMR.UnDoMatrix2D(1).Phase1Start 	= QmatNMR.fase1start;
        QmatNMR.UnDoMatrix2D(1).Phase1StartIndex 	= QmatNMR.fase1startIndex;
      end
    
    else 	%clear the undo matrices to save memory
      if (isfield(QmatNMR, 'UnDoMatrix2D'))
        QmatNMR = rmfield(QmatNMR, 'UnDoMatrix2D');
      end
    end
  end

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
