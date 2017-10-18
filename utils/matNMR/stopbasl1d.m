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
%stopbasl1d.m handles the accepting of a certain baseline fit (see basl1dmenu.m)
%20-1-'98

try
  if QTEMP == 1		%reject baseline fit and restore original spectrum
    delete(QmatNMR.Basl1Dfig)
    QmatNMR.Basl1Dfig = []; 
    QmatNMR.Spec1D = QmatNMR.backup; 
    
    figure(QmatNMR.Fig);
    enablephasebuttons;
    delete(findobj(get(findobj(get(QmatNMR.Fig, 'children'), 'type', 'axes'), 'children'), 'tag', 'BaselinePeaks'));
    delete(findobj(get(findobj(get(QmatNMR.Fig, 'children'), 'type', 'axes'), 'children'), 'tag', 'BaselineDualDisp'));
    QmatNMR.nrspc = QmatNMR.nrspc - 1;
    delete(findobj(allchild(QmatNMR.Fig), 'tag', 'ManualBaslcor'));   
    
    asaanpas
  
    disp('1D Baseline correction rejected, original spectrum has been restored');
    clear QTEMP
  
  
  elseif QTEMP == 2	%Accept baseline fit
    QmatNMR.Dim = 0;		%switch to 1D processing just to be sure
    QmatNMR.SwitchTo1D = 0;
    
    QTEMP = get(QmatNMR.bas3, 'string');
    figure(QmatNMR.Fig);
    
    if (QmatNMR.FitPerformed == 1)		%automatic fit
      QmatNMR.History = str2mat(QmatNMR.History, ['Automatic 1D Baseline correction performed : ' QTEMP(get(QmatNMR.bas3, 'value'), :) ' of order ' get(QmatNMR.bas5, 'string')]);
      						%now add the peak list into the macro ...
      QTEMP2 = ceil(length(QmatNMR.BaslcorPeakList)/(QmatNMR.MacroLength-1));
      QTEMP = zeros(1, QTEMP2*(QmatNMR.MacroLength-1));
      QTEMP(1:length(QmatNMR.BaslcorPeakList)) = QmatNMR.BaslcorPeakList;
      for QTEMP40=1:QTEMP2
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 8, QTEMP((QTEMP40-1)*(QmatNMR.MacroLength-1)+ (1:(QmatNMR.MacroLength-1))));
        
        if QmatNMR.RecordingMacro
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 8, QTEMP((QTEMP40-1)*(QmatNMR.MacroLength-1)+ (1:(QmatNMR.MacroLength-1))));
        end
      end
  
      %first add dimension-specific information, and then the current command
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 9, 1, get(QmatNMR.bas3, 'value'), str2num(get(QmatNMR.bas5, 'string')));	%code for baslcor 1D, automatic, function, order
  
      if QmatNMR.RecordingMacro
        %first add dimension-specific information, and then the current command
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 9, 1, get(QmatNMR.bas3, 'value'), str2num(get(QmatNMR.bas5, 'string')));	%code for baslcor 1D, automatic, function, order
      end
        
      repair				%set all phase buttons to zero
      disp('1D automatic baseline correction accepted');
  
    else
      disp('No baseline fit performed ! Nothing changed ...');  
    end
  
    delete(findobj(get(findobj(get(QmatNMR.Fig, 'children'), 'type', 'axes'), 'children'), 'tag', 'BaselinePeaks'));
    delete(findobj(get(findobj(get(QmatNMR.Fig, 'children'), 'type', 'axes'), 'children'), 'tag', 'BaselineDualDisp'));
    delete(findobj(allchild(QmatNMR.Fig), 'tag', 'ManualBaslcor'));   
    QmatNMR.nrspc = QmatNMR.nrspc - 1;
      
    try
      delete(QmatNMR.Basl1Dfig)
    end
    enablephasebuttons;
    QmatNMR.Basl1Dfig = []; 
    asaanpas
  
  else			%Undo-button
    if (QmatNMR.FitPerformed == 1)
      figure(QmatNMR.Fig);
  
      delete(findobj(allchild(QmatNMR.Fig), 'tag', 'ManualBaslcor')); 
  
      QmatNMR.Spec1D = QmatNMR.backup; 
      Qspcrel;
      CheckAxis; 
      simpelplot
      resetXaxis;		%reset the x-limits
  
      figure(QmatNMR.Basl1Dfig);
    
      QmatNMR.FitPerformed = 0;
    else
      disp('No 1D automatic baseline correction performed. Can''t undo !');
    end
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
