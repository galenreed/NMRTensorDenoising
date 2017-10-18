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
%makenew1D.m is the script that reads a new 1D spectrum and initializes the main
%window again for starting a new processing job.
%9-8-'96

try
  %read in variable(s) depending on the datatype. The expression given by the user is checked for variables and
  %functions (that are assumed to give proper results). The 1D data matrix is constructed from this information depending on whether
  %the variable is a structure or not (matNMR datatype). The history is only taken from a structure
  %if the variable QmatNMR.numbvars is 1 !!
  %
  QmatNMR.History = '';
  QmatNMR.HistoryMacro = AddToMacro;
  QmatNMR.numbvars = 0;
  QmatNMR.numbstructs = 0;
  QmatNMR.Dim = 0;	%1d spectrum
  ClearDefaultAxis
  QmatNMR.BusyWithMacro = 0;	%reset macro flag just to be sure
  QmatNMR.BREAK = 0;
  
  
  QmatNMR.SpecNameProc = QmatNMR.Spec1DName;		%check out the new spectrum variable
  checkinput1d
  
  if (QmatNMR.BREAK) 		%this is not a 1D!
    QmatNMR.BREAK = 0;
  
  else
    detaxisprops
    
    QmatNMR.FIDstatusLast = QmatNMR.FIDstatus;	%Is it an FID or a spectrum ? Final setting
    regeldisplaymode
    
    QmatNMR.Dim = 0;	%1d spectrum
    QmatNMR.LastVar = 1;
    
    QmatNMR.dph0 = 0;				%reset phase buttons
    QmatNMR.dph1 = 0;
    QmatNMR.dph2 = 0;
    QmatNMR.fase0 = 0;
    QmatNMR.fase1 = 0;
    QmatNMR.fase2 = 0;
    QmatNMR.fase1startIndex = floor(QmatNMR.Size1D/2)+1;
    QmatNMR.fase1start = interp1((1:QmatNMR.Size1D).', QmatNMR.Axis1D, QmatNMR.fase1startIndex);
    
    QmatNMR.LineTag1D = QmatNMR.Spec1DName;			%reset the line tag
    
    QmatNMR.min=0;					%reset baseline peaklist variable
    QmatNMR.BaslcorPeakList= [];
    
    QmatNMR.lbstatus=0;				%reset linebroadening flag and button
        
    
    %
    %Clear the old undo matrix and create a new one, if wanted
    %
    if (QmatNMR.UnDo1D)
      QmatNMR.UnDoMatrix1D = GenerateMatNMRStructure;
    end  
    
    QmatNMR.last = QmatNMR.newinlist;
    figure(QmatNMR.Fig);
    title(strrep(QmatNMR.Spec1DName, '_', '\_'), 'Color', QmatNMR.ColorScheme.AxisFore);
    
    repair;			%restore phase slide buttons
    if (~QmatNMR.matNMRRunMacroFlag)
      asaanpas;		%display new FID / spectrum
    end
  
    QmatNMR.Temp = get(QmatNMR.FID, 'String');
    disp(['Loaded new 1D: ' QmatNMR.Spec1DName]);
    disp(['size of the new 1D ' deblank(QmatNMR.Temp(QmatNMR.FIDstatus, :)) ' is :  ', num2str(QmatNMR.Size1D), ' points.']);
     
    					%Set history
    if (QmatNMR.numbvars > 1)			%With multiple variables clear the history and start over
      QmatNMR.History = '';
    end
    if (strcmp(QmatNMR.History, '') | isempty(QmatNMR.History))
      QmatNMR.History = str2mat('', 'Processing History :', '', ['Name of the variable          :  ' QmatNMR.Spec1DName]);
      QTEMP = clock;
      QTEMP1 = sprintf('%.0f',QTEMP(4)+100);
      QTEMP2 = sprintf('%.0f',QTEMP(5)+100);
      QmatNMR.History = str2mat(QmatNMR.History, ['Processed on ' date ' at ' QTEMP1(2:3) ':' QTEMP2(2:3)]);
      QmatNMR.History = str2mat(QmatNMR.History, ['size of the new 1D ' deblank(QmatNMR.Temp(QmatNMR.FIDstatus, :)) ' is     :  ', num2str(QmatNMR.Size1D) ' points']);
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
