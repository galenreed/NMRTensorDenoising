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
%stopbasl2d.m handles the accepting of a certain baseline fit (see basl2dmenu.m)
%20-1-'98

try
  if (QmatNMR.Dim == 1)
    QmatNMR.BaselineDimension = 'TD2';
  elseif (QmatNMR.Dim == 2)
    QmatNMR.BaselineDimension = 'TD1';
  end
  
  if QTEMP == 1		%reject baseline fit and restore original spectrum
    QmatNMR.Spec2D = (QmatNMR.backup + sqrt(-1)*imag(QmatNMR.Spec2D));
    getcurrentspectrum
    
    enablephasebuttons;
    figure(QmatNMR.Fig);
    delete(findobj(allchild(QmatNMR.Fig), 'tag', 'BaselinePeaks'));
    Qspcrel
    CheckAxis
    simpelplot;
    resetXaxis;		%reset the x-limits
    
    disp(['2D Baseline correction on ' QmatNMR.BaselineDimension ' rejected, original spectrum has been restored']);
  
    try
      delete(QmatNMR.Basl2Dfig)
    end
    QmatNMR.Basl2Dfig = []; 
    QmatNMR.backup = [];
  
  elseif QTEMP == 2	%Accept baseline fit
    if (QmatNMR.FitPerformed == 1)
      						%now add the peak list into the processing history macro ...
      QTEMP10 = ceil(length(QmatNMR.BaslcorPeakList)/(QmatNMR.MacroLength-1));
      QTEMP2 = zeros(1, QTEMP10*(QmatNMR.MacroLength-1));
      QTEMP2(1:length(QmatNMR.BaslcorPeakList)) = QmatNMR.BaslcorPeakList;
      for QTEMP40=1:QTEMP10
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 8, QTEMP2((QTEMP40-1)*(QmatNMR.MacroLength-1)+ (1:(QmatNMR.MacroLength-1))));
        
        if QmatNMR.RecordingMacro
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 8, QTEMP2((QTEMP40-1)*(QmatNMR.MacroLength-1)+ (1:(QmatNMR.MacroLength-1))));
        end 
      end
      						%and now the finishing statement to define the 2D baseline correction in the processing history macro
      %first add dimension-specific information, and then the current command
      if (QmatNMR.Dim == 1)
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
  
      else
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
      end
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 118, QmatNMR.Dim, get(QmatNMR.Q2dbas3, 'value'), str2num(get(QmatNMR.Q2dbas5, 'string')), QmatNMR.SelectedAreaHistoryCode);	%code for baslcor 2D, dimension, function, order, region of the spectrum
  
      if QmatNMR.RecordingMacro
        %first add dimension-specific information, and then the current command
        if (QmatNMR.Dim == 1)
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
    
        else
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
        end
  
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 118, QmatNMR.Dim, get(QmatNMR.Q2dbas3, 'value'), str2num(get(QmatNMR.Q2dbas5, 'string')), QmatNMR.SelectedAreaHistoryCode);	%code for baslcor 2D, dimension, function, order, region of the spectrum
      end
  
      %show output to the screen and to the processing history text
      QTEMP = get(QmatNMR.Q2dbas3, 'string');
      if (QmatNMR.Dim==1)
        if ~(QmatNMR.SizeTD1 == length(QmatNMR.SelectedArea(1):QmatNMR.SelectedArea(2)))
          disp(['2D Baseline correction on ' QmatNMR.BaselineDimension ' accepted and performed on rows ' num2str(QmatNMR.SelectedArea(1)) ':' num2str(QmatNMR.SelectedArea(2)) ' of the matrix']);
          QmatNMR.History = str2mat(QmatNMR.History, ['Baseline correction performed on selection of TD' num2str(~(QmatNMR.Dim-1)+1) ', rows ' num2str(QmatNMR.SelectedArea(1)) ':' num2str(QmatNMR.SelectedArea(2)) ' : ' QTEMP(get(QmatNMR.Q2dbas3, 'value'), :) ' of order ' get(QmatNMR.Q2dbas5, 'string')]);
        else
  
          disp(['2D Baseline correction on ' QmatNMR.BaselineDimension ' accepted and performed on whole 2D matrix']);
          QmatNMR.History = str2mat(QmatNMR.History, ['Baseline correction performed on TD' num2str(~(QmatNMR.Dim-1)+1) ' : ' QTEMP(get(QmatNMR.Q2dbas3, 'value'), :) ' of order ' get(QmatNMR.Q2dbas5, 'string')]);
        end
      else
  
        if ~(QmatNMR.SizeTD2 == length(QmatNMR.SelectedArea(1):QmatNMR.SelectedArea(2)))
          disp(['2D Baseline correction on ' QmatNMR.BaselineDimension ' accepted and performed on columns ' num2str(QmatNMR.SelectedArea(1)) ':' num2str(QmatNMR.SelectedArea(2)) ' of the matrix']);
          QmatNMR.History = str2mat(QmatNMR.History, ['Baseline correction performed on selection of TD' num2str(~(QmatNMR.Dim-1)+1) ', columns ' num2str(QmatNMR.SelectedArea(1)) ':' num2str(QmatNMR.SelectedArea(2)) ' : ' QTEMP(get(QmatNMR.Q2dbas3, 'value'), :) ' of order ' get(QmatNMR.Q2dbas5, 'string')]);
        else
  
          disp(['2D Baseline correction on ' QmatNMR.BaselineDimension ' accepted and performed on whole 2D matrix']);
          QmatNMR.History = str2mat(QmatNMR.History, ['Baseline correction performed on TD' num2str(~(QmatNMR.Dim-1)+1) ' : ' QTEMP(get(QmatNMR.Q2dbas3, 'value'), :) ' of order ' get(QmatNMR.Q2dbas5, 'string')]);
        end
      end
    else
  
      disp('No 2D baseline correction performed ! Nothing changed ...');
    end
  
    try
      delete(QmatNMR.Basl2Dfig)
    end
    figure(QmatNMR.Fig);
    enablephasebuttons;
    delete(findobj(get(findobj(get(QmatNMR.Fig, 'children'), 'type', 'axes'), 'children'), 'tag', 'BaselinePeaks'));
    QmatNMR.Basl2Dfig = []; 
    QmatNMR.backup = [];
  
    if (~QmatNMR.BusyWithMacro)
      getcurrentspectrum
      asaanpas
      Arrowhead;
    end
       
  
  else			%Undo-button
    if (QmatNMR.FitPerformed == 1)
      QTEMP = (QmatNMR.backup + sqrt(-1)*imag(QmatNMR.Spec2D));
      QmatNMR.Spec2D = QTEMP;
    
      getcurrentspectrum
      Qspcrel
      CheckAxis
  
      figure(QmatNMR.Fig); 
      simpelplot 
      resetXaxis;		%reset the x-limits
    
      disp(['2D Baseline correction on ' QmatNMR.BaselineDimension ' undone ...']);
    
      QmatNMR.FitPerformed = 0;
    
    else  
      disp('No 2D baseline correction performed. Can''t undo !');
    end
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
