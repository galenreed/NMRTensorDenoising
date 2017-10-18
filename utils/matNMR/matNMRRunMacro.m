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
%
% matNMRRunMacro
%
% syntax: MatrixOut = matNMRRunMacro(MatrixIn, Macro)
%
% Allows executing a matNMR processing (and/or plotting) macro <Macro> from a script, 
% applied to matrix <MatrixIn>. The matNMR main window MUST be open when starting this function.
% The resulting spectrum will be given as a matNMR structure! The input parameters may
% be strings, which is the most memory-efficient option, or normal matrices.
% IF <MatrixIn> or <Macro> are strings then they MUST evaluate into valid and 
% GLOBALLY-DEFINED matrices!
%
% OR
%
% syntax: matNMRRunMacro(Macro);
%
% Allows executing a matNMR plotting macro in the current window (gcf), regardless what
% window it is. Processing functions are allowed in the macro but ONLY if the current window 
% is the matNMR main window. Plotting functions can be run on any window as long as they have 
% the same subplot configuration as the window in which the macro was recorded.
%
%
% Jacco van Beek
% 25-07-2004
%

function MatrixOut = matNMRRunMacro(MatrixIn, Macro)

  MatrixOut = [];
  CurrentFigure = gcf;

%
%read all global variables as matNMR uses them
%
  global QmatNMR QmatNMRsettings


%
%first check how many input parameters were given
%
  if (nargin == 1)
    Macro = MatrixIn;
    MatrixIn = [];
  end


%
%Then check whether the MatrixIn is empty. If so then we assume that we are dealing with
%a plotting macro and won't enforce the macro to be run in the main window
%
  if ~isempty(MatrixIn)
  %
  %first check whether the matNMR main window is open
  %
    if isempty(findobj(0, 'tag', 'matNMRmainwindow'))
      disp('matNMRRunMacro ERROR: matNMR main window does not appear to be open. Aborting ...');
      return
    end
  
  
  %
  %Load the required matrix into matNMR
  %
    QmatNMR.matNMRRunMacroFlag = 1;
    if (~isa(MatrixIn, 'char'))
      %determine the type of matrix (1D, 2D or 3D)
      QmatNMR.MatrixIn = MatrixIn;
  
      %
      %if QTEMP is empty then this probably means it wasn't defined as global
      %
      if isempty(QmatNMR.MatrixIn)
        disp('matNMRRunMacro ERROR: MatrixIn points to an empty spectrum. Was it defined as global? Aborting ...');
        return
      end
      
      %
      %check whether the input matrix is a matNMR structure
      %
      matNMRRunMacroStructureFlag = 0;
      if isa(QmatNMR.MatrixIn, 'struct')
        QTEMP1 = size(QmatNMR.MatrixIn.Spectrum);
        matNMRRunMacroStructureFlag = 1;
      
      else
        QTEMP1 = size(QmatNMR.MatrixIn);
      end
      
      matNMRRunMacro3DFlag = 0;
      if (length(QTEMP1) > 3)
        disp('matNMRRunMacro ERROR: matNMR cannot deal with matrices of 4 or more dimensions. Aborting ...');
        return
  
      elseif (min(QTEMP1) == 1)	%1D spectrum/FID
        QmatNMR.ask = 1;
        QmatNMR.uiInput1 = 'QmatNMR.MatrixIn';
        QmatNMR.uiInput2 = '';
        QmatNMR.uiInput3 = '';
        QmatNMR.buttonList = 1;
        regelnaam
  
      elseif (length(QTEMP1) == 2)	%2D spectrum/FID
        QmatNMR.ask = 2;
        QmatNMR.uiInput1 = 'QmatNMR.MatrixIn';
        QmatNMR.uiInput2 = '';
        QmatNMR.uiInput3 = '';
        QmatNMR.buttonList = 1;
        regelnaam
  
      else 				%3D spectrum/FID
        matNMRRunMacro3DFlag = 1;
        %
        %set the flag for processing a macro on a 3D
        %
        QmatNMR.BusyWithMacro3D = 1;
        QmatNMR.ask = 3;
        QmatNMR.uiInput1 = 'QmatNMR.MatrixIn';
        QmatNMR.uiInput2 = '';
        QmatNMR.uiInput3 = '';
        QmatNMR.buttonList = 1;
        regelnaam
      end
  
    else		%MatrixIn is a string
      %determine the type of matrix (1D, 2D or 3D)
      eval(['global ' MatrixIn]);
      
      %
      %if MatrixIn doesn't exist in the workspace, or it's an empty variable, then 
      %this probably means it wasn't defined as global
      %
      QTEMP1 = exist(MatrixIn);
      eval(['QTEMP2 = isempty(' MatrixIn ');']);
      if (~QTEMP1 | QTEMP2)
        disp('matNMRRunMacro ERROR: MatrixIn points to an empty spectrum. Was it defined as global? Aborting ...');
        return
      end
      
      %
      %check whether the input matrix is a matNMR structure
      %
      matNMRRunMacroStructureFlag = 0;
      eval(['QTEMP1 = isa(' MatrixIn ', ''struct'');']);
      if QTEMP1
        eval(['QTEMP1 = size(squeeze(' MatrixIn '.Spectrum))']);
        matNMRRunMacroStructureFlag = 1
  
      else
        eval(['QTEMP1 = size(squeeze(' MatrixIn '))']);
      end
      
      matNMRRunMacro3DFlag = 0;
      if (length(QTEMP1) > 3)
        disp('matNMRRunMacro ERROR: matNMR cannot deal with matrices of 4 or more dimensions. Aborting ...');
        return
  
      elseif (min(QTEMP1) == 1)	%1D spectrum/FID
        QmatNMR.ask = 1;
        QmatNMR.uiInput1 = MatrixIn;
        QmatNMR.uiInput2 = '';
        QmatNMR.uiInput3 = '';
        QmatNMR.buttonList = 1;
        regelnaam
  
      elseif (length(QTEMP1) == 2)	%2D spectrum/FID
        QmatNMR.ask = 2;
        QmatNMR.uiInput1 = MatrixIn;
        QmatNMR.uiInput2 = '';
        QmatNMR.uiInput3 = '';
        QmatNMR.buttonList = 1;
        regelnaam
  
      else 				%3D spectrum/FID
        matNMRRunMacro3DFlag = 1;
        QmatNMR.ask = 3;
        QmatNMR.uiInput1 = MatrixIn;
        QmatNMR.uiInput2 = '';
        QmatNMR.uiInput3 = '';
        QmatNMR.buttonList = 1;
        regelnaam
      end
    end
  
  else		%MatrixIn is empty and so we check whether the macro contains processing
  		%function because then the current figure window MUST be the main window
    if find(Macro(2:end, 1) < 700)
      %
      %There are processing functions in this macro. Therefore we demand that the current
      %window is the main window.
      %
      if ~strcmp(get(CurrentFigure, 'tag'), 'matNMRmainwindow')
        disp('matNMRRunMacro ERROR: macro contains processing functions but current window is NOT the main window. Aborting ...');
        return
      end
    end
    
  end
  
  
  %
  %Execute the requested macro
  %
  if find(Macro(2:end, 1) < 700)		%are there any processing actions in the macro?
    %
    %The macro contains processing actions
    %
    if isa(Macro, 'char')			%is <Macro> a string?
      eval(['global ' Macro]);
      QmatNMR.uiInput1 = Macro;
  
    else
      global QmatNMR
      QmatNMR.MacroIn = Macro;
      QmatNMR.uiInput1 = 'QmatNMR.MacroIn';
    end

    QmatNMR.StepWise = 0;
    QmatNMR.buttonList = 1;
  
    if (matNMRRunMacro3DFlag == 0)	%MatrixIn points to either a 1D or 2D matrix
      regelexecutemacro
  
    %
    %Recreate the output matrix as a matNMR Structure
    %
      MatrixOut = GenerateMatNMRStructure;
      if (QmatNMR.Dim == 0)	%1D mode
        MatrixOut.Spectrum = QmatNMR.Spec1D;

        %always store the axis vector but also include the default axis information
        MatrixOut.AxisTD2 = QmatNMR.Axis1D;
        MatrixOut.DefaultAxisReference = QmatNMRsettings.DefaultAxisReference1D;
        MatrixOut.DefaultAxisCarrierIndexTD2 = QmatNMRsettings.DefaultAxisCarrierIndex;
        MatrixOut.DefaultAxisRefkHzTD2 = QmatNMRsettings.DefaultAxisReferencekHz;
        MatrixOut.DefaultAxisRefPPMTD2 = QmatNMRsettings.DefaultAxisReferencePPM;

        MatrixOut.SweepWidthTD2 = QmatNMR.SW1D;
        MatrixOut.SpectralFrequencyTD2 = QmatNMR.SF1D;
        MatrixOut.GammaTD2 = QmatNMR.gamma1d;
        MatrixOut.FIDstatusTD2 = QmatNMR.FIDstatus;
        MatrixOut.History = QmatNMR.History;
        MatrixOut.HistoryMacro = QmatNMR.HistoryMacro;
    
      else			%2D mode
        MatrixOut.Spectrum = QmatNMR.Spec2D;
        if (QmatNMR.HyperComplex)
          MatrixOut.HyperComplex = QmatNMR.Spec2Dhc;
        end

        %always store the axis vector but also include the default axis information
        MatrixOut.AxisTD2  = QmatNMR.AxisTD2;
        MatrixOut.DefaultAxisReference = QmatNMRsettings.DefaultAxisReference2D;
        MatrixOut.DefaultAxisCarrierIndexTD2 = QmatNMRsettings.DefaultAxisCarrierIndex1;
        MatrixOut.DefaultAxisRefkHzTD2 = QmatNMRsettings.DefaultAxisReferencekHz1;
        MatrixOut.DefaultAxisRefPPMTD2 = QmatNMRsettings.DefaultAxisReferencePPM1;
  
        if (QmatNMR.RulerXAxis2 == 1)  %non-default axis in TD1
          MatrixOut.AxisTD1  = QmatNMR.AxisTD1;
  
        else			      %Don't save if the axis is a default axis.
          MatrixOut.AxisTD1  = [];
        end
        MatrixOut.DefaultAxisCarrierIndexTD1 = QmatNMRsettings.DefaultAxisCarrierIndex2;
        MatrixOut.DefaultAxisRefkHzTD1 = QmatNMRsettings.DefaultAxisReferencekHz2;
        MatrixOut.DefaultAxisRefPPMTD1 = QmatNMRsettings.DefaultAxisReferencePPM2;

        MatrixOut.SweepWidthTD2 = QmatNMR.SWTD2;
        MatrixOut.SweepWidthTD1 = QmatNMR.SWTD1;
        MatrixOut.SpectralFrequencyTD2 = QmatNMR.SFTD2;
        MatrixOut.SpectralFrequencyTD1 = QmatNMR.SFTD1;
        MatrixOut.GammaTD2 = QmatNMR.gamma1;
        MatrixOut.GammaTD1 = QmatNMR.gamma2;
        MatrixOut.FIDstatusTD2 = QmatNMR.FIDstatus2D1;
        MatrixOut.FIDstatusTD1 = QmatNMR.FIDstatus2D2;
        MatrixOut.History = QmatNMR.History;
        MatrixOut.HistoryMacro = QmatNMR.HistoryMacro;
      end
  
    else 					%MatrixIn points to a 3D matrix
      %
      %first we define an output variable for the 3D
      %
      MatrixOut = GenerateMatNMRStructure;
      set(QmatNMR.but3D5, 'string', 'MatrixOut');
      regeloutput3d
      
      %
      %execute the macro
      %
      regelexecutemacro3d
    end
  
    QmatNMR.matNMRRunMacroFlag = 0;
    asaanpas
  
  else
    %
    %The macro contains only plotting actions
    %
    if isa(Macro, 'char')			%is <Macro> a string?
      QmatNMR.ExecutingMacro = eval(Macro);
  
    else
      QmatNMR.ExecutingMacro = Macro;
    end

    RunMacro
  end

  %clear variable
  QmatNMR.MatrixIn = 0;
  disp('matNMRRunMacro succesfully finished executing macro.')
