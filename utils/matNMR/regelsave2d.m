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
%regelsave2d.m takes care of saving the current 2D spectrum into the MATLAB workspace
%21-12-'96

try
  if QmatNMR.buttonList == 1						%= OK-button
    watch;
  
    %
    %read the input parameters
    %
    QmatNMR.SaveImaginary = QmatNMR.uiInput2;
    QmatNMR.SaveHistory = QmatNMR.uiInput3;
    QmatNMR.SaveHypercomplex = QmatNMR.uiInput4;
    QmatNMR.SaveAxis = QmatNMR.uiInput5;
  
    %
    %save the variable
    %
    if (QmatNMR.SaveHistory | QmatNMR.SaveHypercomplex | QmatNMR.SaveAxis)		%Connect history and/or hypercomplex part to spectrum --> make structure
      %first generate a generic structure
      eval([QmatNMR.uiInput1 '= GenerateMatNMRStructure;']);
  
      if (QmatNMR.SaveImaginary)
        eval([QmatNMR.uiInput1 '.Spectrum = QmatNMR.Spec2D;']);
      else
        eval([QmatNMR.uiInput1 '.Spectrum = real(QmatNMR.Spec2D);']);
      end
      
      if (QmatNMR.SaveHistory)				%save history ?
        eval([QmatNMR.uiInput1 '.History = QmatNMR.History;']);
        eval([QmatNMR.uiInput1 '.HistoryMacro = QmatNMR.HistoryMacro;']);
      else
        eval([QmatNMR.uiInput1 '.History = [];']);
        eval([QmatNMR.uiInput1 '.HistoryMacro = AddToMacro;']);
      end
  
      disp(['The current 2D spectrum was saved as a structure in the workspace as : "' QmatNMR.uiInput1 '"']);
      
      					%save the hypercomplex part ?
      if (QmatNMR.SaveHypercomplex & QmatNMR.SaveImaginary)
        if (sum(sum(abs(QmatNMR.Spec2Dhc))) == 0)	%don't save if it is zero
          eval([QmatNMR.uiInput1 '.Hypercomplex = [];']);
        else
          eval([QmatNMR.uiInput1 '.Hypercomplex = QmatNMR.Spec2Dhc;']);
        end
      else				%don't save if it is not wanted
        eval([QmatNMR.uiInput1 '.Hypercomplex = [];']);
      end;  
  
          			      %save the current axes in the structure ?
      if (QmatNMR.SaveAxis)
        if (QmatNMR.RulerXAxis1 == 1)  %non-default axis in TD2
  	eval([QmatNMR.uiInput1 '.AxisTD2 = QmatNMR.AxisTD2;']);
  
        else			      %Don't save if the axis is a default axis.
  	eval([QmatNMR.uiInput1 '.AxisTD2 = [];']);
        end
        eval([QmatNMR.uiInput1 '.DefaultAxisReference = QmatNMRsettings.DefaultAxisReference2D;']);
        eval([QmatNMR.uiInput1 '.DefaultAxisCarrierIndexTD2 = QmatNMRsettings.DefaultAxisCarrierIndex1;']);
        eval([QmatNMR.uiInput1 '.DefaultAxisRefkHzTD2 = QmatNMRsettings.DefaultAxisReferencekHz1;']);
        eval([QmatNMR.uiInput1 '.DefaultAxisRefPPMTD2 = QmatNMRsettings.DefaultAxisReferencePPM1;']);
  
        if (QmatNMR.RulerXAxis2 == 1)  %non-default axis in TD1
  	eval([QmatNMR.uiInput1 '.AxisTD1 = QmatNMR.AxisTD1;']);
  
        else			      %Don't save if the axis is a default axis.
  	eval([QmatNMR.uiInput1 '.AxisTD1 = [];']);
        end
        eval([QmatNMR.uiInput1 '.DefaultAxisCarrierIndexTD1 = QmatNMRsettings.DefaultAxisCarrierIndex2;']);
        eval([QmatNMR.uiInput1 '.DefaultAxisRefkHzTD1 = QmatNMRsettings.DefaultAxisReferencekHz2;']);
        eval([QmatNMR.uiInput1 '.DefaultAxisRefPPMTD1 = QmatNMRsettings.DefaultAxisReferencePPM2;']);
      else
        eval([QmatNMR.uiInput1 '.AxisTD2 = [];']);
        eval([QmatNMR.uiInput1 '.DefaultAxisReference = [];']);
        eval([QmatNMR.uiInput1 '.DefaultAxisCarrierIndexTD2 = [];']);
        eval([QmatNMR.uiInput1 '.DefaultAxisRefkHzTD2 = [];']);
        eval([QmatNMR.uiInput1 '.DefaultAxisRefPPMTD2 = [];']);
  
        eval([QmatNMR.uiInput1 '.AxisTD1 = [];']);
        eval([QmatNMR.uiInput1 '.DefaultAxisCarrierIndexTD1 = [];']);
        eval([QmatNMR.uiInput1 '.DefaultAxisRefkHzTD1 = [];']);
        eval([QmatNMR.uiInput1 '.DefaultAxisRefPPMTD1 = [];']);
      end;  
  
      eval([QmatNMR.uiInput1 '.SweepWidthTD2 = QmatNMR.SWTD2;']);
      eval([QmatNMR.uiInput1 '.SpectralFrequencyTD2 = QmatNMR.SFTD2;']);
      eval([QmatNMR.uiInput1 '.SweepWidthTD1 = QmatNMR.SWTD1;']);
      eval([QmatNMR.uiInput1 '.SpectralFrequencyTD1 = QmatNMR.SFTD1;']);
      eval([QmatNMR.uiInput1 '.FIDstatusTD2  = QmatNMR.FIDstatus2D1;']);
      eval([QmatNMR.uiInput1 '.FIDstatusTD1  = QmatNMR.FIDstatus2D2;']);
      eval([QmatNMR.uiInput1 '.GammaTD2 	    = QmatNMR.gamma1;']);
      eval([QmatNMR.uiInput1 '.GammaTD1 	    = QmatNMR.gamma2;']);
  
      
      					%Create Peak List entries in structure for later use!
      eval([QmatNMR.uiInput1 '.PeakListNums = [];']);
      eval([QmatNMR.uiInput1 '.PeakListText = [];']);
    else
      if (QmatNMR.SaveImaginary)
        eval([QmatNMR.uiInput1 ' = QmatNMR.Spec2D;']);
      else
        eval([QmatNMR.uiInput1 ' = real(QmatNMR.Spec2D);']);
      end      
      
      disp(['The current 2D spectrum was saved as a matrix in the workspace as : "' QmatNMR.uiInput1 '"']);
    end
  
  
    QmatNMR.newinlist.Spectrum = QmatNMR.uiInput1;			%put name in list of last 10 variables if it is new
    QmatNMR.newinlist.AxisTD2 = '';
    QmatNMR.newinlist.AxisTD1 = '';
    putinlist2d;
  
  
    Arrowhead;
  else
    disp('The current 2D spectrum was not saved in the workspace !');
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
