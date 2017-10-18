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
%regelsavedisk1d.m takes care of saving the current 1D spectrum to disk
%21-12-'96

try
  if QmatNMR.buttonList == 1						%= OK-button
    watch;
  
    if (QmatNMR.SwitchTo1D) 		%switch from 2D to 1D processing if necessary
      SwitchTo1D
    end
  
  
    %
    %read the input parameters
    %
    QmatNMR.SaveImaginary = QmatNMR.uiInput4;
    QmatNMR.SaveHistory = QmatNMR.uiInput5;
    QmatNMR.SaveAxis = QmatNMR.uiInput6;
  
    %check whether filename ends with ".mat"
    if isempty(findstr(QmatNMR.uiInput2, '.mat'))
      QmatNMR.uiInput2 = [QmatNMR.uiInput2 '.mat'];
    end
  
    %
    %save the variable
    %
  						%First save the spectrum in the workspace
    if isempty(findstr(QmatNMR.uiInput1, ' '))		%don't do following when multiple variables have been entered
      if (QmatNMR.SaveHistory | QmatNMR.SaveAxis)		%Connect history or axis to spectrum --> make structure
        %first generate a generic structure
        eval([QmatNMR.uiInput1 '= GenerateMatNMRStructure;']);
  
        if (QmatNMR.SaveImaginary)
          eval([QmatNMR.uiInput1 '.Spectrum = QmatNMR.Spec1D;']);
        else
          eval([QmatNMR.uiInput1 '.Spectrum = real(QmatNMR.Spec1D);']);
        end
  
        if (QmatNMR.SaveHistory)				%save history ?
          eval([QmatNMR.uiInput1 '.History = QmatNMR.History;']);
          eval([QmatNMR.uiInput1 '.HistoryMacro = QmatNMR.HistoryMacro;']);
        else
          eval([QmatNMR.uiInput1 '.History = [];']);
          eval([QmatNMR.uiInput1 '.HistoryMacro = AddToMacro;']);
        end
  
        if (QmatNMR.SaveAxis)				%save current axis ?
          if (QmatNMR.RulerXAxis == 1)	%save axis if non-default
            eval([QmatNMR.uiInput1 '.AxisTD2 = QmatNMR.Axis1D;']);
  
          else    			%don't save the axis, but do save the reference values if it is a default axis
            eval([QmatNMR.uiInput1 '.AxisTD2 = [];']);
          end
          eval([QmatNMR.uiInput1 '.DefaultAxisReference = QmatNMRsettings.DefaultAxisReference1D;']);
          eval([QmatNMR.uiInput1 '.DefaultAxisCarrierIndexTD2 = QmatNMRsettings.DefaultAxisCarrierIndex;']);
          eval([QmatNMR.uiInput1 '.DefaultAxisRefkHzTD2 = QmatNMRsettings.DefaultAxisReferencekHz;']);
          eval([QmatNMR.uiInput1 '.DefaultAxisRefPPMTD2 = QmatNMRsettings.DefaultAxisReferencePPM;']);
  
        else
          eval([QmatNMR.uiInput1 '.AxisTD2 = [];']);
          eval([QmatNMR.uiInput1 '.DefaultAxisReference = [];']);
          eval([QmatNMR.uiInput1 '.DefaultAxisCarrierIndexTD2 = [];']);
          eval([QmatNMR.uiInput1 '.DefaultAxisRefkHzTD2 = [];']);
          eval([QmatNMR.uiInput1 '.DefaultAxisRefPPMTD2 = [];']);
        end
  
        eval([QmatNMR.uiInput1 '.SweepWidthTD2 = QmatNMR.SW1D;']);
        eval([QmatNMR.uiInput1 '.SpectralFrequencyTD2 = QmatNMR.SF1D;']);
        eval([QmatNMR.uiInput1 '.FIDstatusTD2 = QmatNMR.FIDstatus;']);
        eval([QmatNMR.uiInput1 '.GammaTD2 = QmatNMR.gamma1d;']);
  
      					%Create dummy List entries in structure
        eval([QmatNMR.uiInput1 '.AxisTD1 = [];']);
        eval([QmatNMR.uiInput1 '.SweepWidthTD1 = [];']);
        eval([QmatNMR.uiInput1 '.SpectralFrequencyTD1 = [];']);
        eval([QmatNMR.uiInput1 '.Hypercomplex = [];']);
        eval([QmatNMR.uiInput1 '.PeakListNums = [];']);
        eval([QmatNMR.uiInput1 '.PeakListText = [];']);
        eval([QmatNMR.uiInput1 '.FIDstatusTD1 = [];']);
        eval([QmatNMR.uiInput1 '.GammaTD1     = [];']);
        eval([QmatNMR.uiInput1 '.DefaultAxisCarrierIndexTD1 = [];']);
        eval([QmatNMR.uiInput1 '.DefaultAxisRefkHzTD1 = [];']);
        eval([QmatNMR.uiInput1 '.DefaultAxisRefPPMTD1 = [];']);
  
        disp(['The current 1D spectrum was saved as a structure on disk and in the workspace as : "' QmatNMR.uiInput2 '"']);
      else
        if (QmatNMR.SaveImaginary)
          eval([QmatNMR.uiInput1 ' = QmatNMR.Spec1D;']);
        else
          eval([QmatNMR.uiInput1 ' = real(QmatNMR.Spec1D);']);
        end
  
        disp(['The current 1D spectrum was saved as a matrix on disk and in the workspace as : "' QmatNMR.uiInput2 '"']);
      end
    else
      disp(['The variables have been saved on disk as : "' QmatNMR.uiInput2 '"']);
    end
  
    						%Now save the variable to disk
    if strcmp(QmatNMR.uiInput3, '')
      QmatNMR.uiInput3 = '.';
    end
    eval(['save ''' QmatNMR.uiInput3 filesep QmatNMR.uiInput2 ''' ' QmatNMR.uiInput1]);
  
    QmatNMR.newinlist.Spectrum = QmatNMR.uiInput1;		%put name in list of last 10 variables if it is new
    QmatNMR.newinlist.Axis = '';
    putinlist1d;
  
  
    if (QmatNMR.uiInput6) 				%if needed clear variable from the workspace
      eval(['clear ' QmatNMR.uiInput1]);
    end
  
    asaanpas
  
    Arrowhead;
  else
    disp('The current 1D spectrum was not saved in the workspace !');
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
