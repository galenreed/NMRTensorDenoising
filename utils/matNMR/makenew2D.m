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
%makenew2D.m loads a 2D FID and shows the 1st experiment as a 1D spectrum in the
%main window. All necessary variables that need to be initialized are so in here.
%9-8-'96

try
  watch;

  %read in variable(s) depending on the datatype. The expression given by the user is checked for variables and
  %functions (that are assumed to give proper results). The 2D data matrix is constructed from this information depending on whether
  %the variable is a structure or not (matNMR datatype). The history is only read in from a structure
  %if the variable QmatNMR.numbvars is 1 !!
  %
  QmatNMR.History = '';
  QmatNMR.HistoryMacro = AddToMacro;
  QmatNMR.ExecutingMacro = AddToMacro;
  QmatNMR.Dim = 1;	%2d spectrum, td 2
  QmatNMR.numbvars = 0;
  QmatNMR.numbstructs = 0;
  QmatNMR.PeakListNums = [];
  QmatNMR.PeakListText = [];
  QmatNMR.Dim = 1;	%2d spectrum, td 2
  ClearDefaultAxis
  QmatNMR.BusyWithMacro = 0;	%reset macro flag just to be sure
  QmatNMR.BREAK = 0;
  QmatNMR.Spec2DName = QmatNMR.Spec1DName;	%in order to remember the 2D spectrum/FID variable name

  %
  %now check the supplied variable name for structures and extract the necessary parameters from it.
  %
  QmatNMR.SpecNameProc = QmatNMR.Spec1DName;
  checkinput2d

  if (QmatNMR.BREAK)
    QmatNMR.BREAK = 0;

  else
    QmatNMR.FIDstatus = QmatNMR.FIDstatus2D1;		%Is it an FID or a spectrum ? Final setting
    QmatNMR.FIDstatusLast = QmatNMR.FIDstatus;
    regeldisplaymode


    QmatNMR.gamma1d = QmatNMR.gamma1;			%set the sign of the gyromagnetic ratio


    					%get the first slice and set the axes and size variables
    QmatNMR.Axis1D = QmatNMR.AxisTD2;
    QmatNMR.Size1D = QmatNMR.SizeTD2;
    detaxisprops;
    QmatNMR.Spec1D = QmatNMR.Spec2D(1, :);



    QmatNMR.Dim = 1;	%2d spectrum, td 2
    QmatNMR.LastVar = 2;

    QmatNMR.min = 0;
    QmatNMR.xmin = 0;
    QmatNMR.totaalX = 500000;
    QmatNMR.totaalY = 500000;
    QmatNMR.minY = 0;
    QmatNMR.maxY = 500000;
    QmatNMR.ymin = 0;
    QmatNMR.BaslcorPeakList= [];

    QmatNMR.LineTag2D = QmatNMR.Spec1DName;			%reset the line tag

    QmatNMR.lbstatus=0;				%reset linebroadening flag and button

    QmatNMR.kolomnr = 1;
    QmatNMR.rijnr = 1;
    QmatNMR.texie = ['Row ', num2str(QmatNMR.rijnr), '          '];

    QmatNMR.last = QmatNMR.newinlist;

    QmatNMR.SW1D = QmatNMR.SWTD2;
    QmatNMR.SF1D = QmatNMR.SFTD2;

    				%reset the phase variables
    QmatNMR.fase0 = 0;
    QmatNMR.fase1 = 0;
    QmatNMR.fase2 = 0;
    QmatNMR.dph0 = 0;
    QmatNMR.dph1 = 0;
    QmatNMR.dph2 = 0;
    QmatNMR.fase1startIndex = floor(QmatNMR.Size1D/2)+1;
    QmatNMR.fase1start = interp1((1:QmatNMR.Size1D).', QmatNMR.Axis1D, QmatNMR.fase1startIndex);

    QmatNMR.RulerXAxis = QmatNMR.RulerXAxis1;

    if (~QmatNMR.BusyWithMacro3D)
      figure(QmatNMR.Fig);
    end
    title(strrep(QmatNMR.Spec1DName, '_', '\_'), 'Color', QmatNMR.ColorScheme.AxisFore);

    %
    %Clear the old undo matrix and create a new one, if wanted
    %
    if (QmatNMR.UnDo2D)
      QmatNMR.UnDoMatrix2D = GenerateMatNMRStructure;

      if (QmatNMR.UnDo1D)
        QmatNMR.UnDoMatrix1D = GenerateMatNMRStructure;
      end
    end

    setfourmode

    repair;
    Arrowhead;

    if (~QmatNMR.BusyWithMacro3D & ~QmatNMR.matNMRRunMacroFlag)
      asaanpas;
    end

    QmatNMR.Temp = get(QmatNMR.FID, 'String');
    disp(['Loaded new 2D: ' QmatNMR.Spec2DName]);
    disp(['Size of the new 2D ' deblank(QmatNMR.Temp(QmatNMR.FIDstatus, :)) ' is :  ', num2str(QmatNMR.SizeTD1), ' x ', num2str(QmatNMR.SizeTD2), ' points (td1 x td2).']);


    		%Set history variable
    if (QmatNMR.numbvars > 1)			%With multiple variables clear the history and start over
      QmatNMR.History = '';
    end
    if (strcmp(QmatNMR.History, '') | isempty(QmatNMR.History))
      QmatNMR.History = str2mat('', 'Processing History :', '', ['Name of the variable          :  ' QmatNMR.Spec2DName]);
      QTEMP = clock;
      QTEMP1 = sprintf('%.0f',QTEMP(4)+100);
      QTEMP2 = sprintf('%.0f',QTEMP(5)+100);
      QmatNMR.History = str2mat(QmatNMR.History, ['Processed on ' date ' at ' QTEMP1(2:3) ':' QTEMP2(2:3)]);
      QmatNMR.History = str2mat(QmatNMR.History, ['size of the new 2D ' deblank(QmatNMR.Temp(QmatNMR.FIDstatus, :)) ' is     :  ', num2str(QmatNMR.SizeTD1), ' x ', num2str(QmatNMR.SizeTD2), ' points (td1 x td2).']);
    end


    %
    %switch off the 2D phasing aid
    %
    set(QmatNMR.p31, 'value', 0)
    switch2Daid
  end

  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
