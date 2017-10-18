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
%regelsize1d.m is the script that changes the size of a 1D spectrum QmatNMR.Spec1DPlot
%21-12-'96

try
  if QmatNMR.buttonList == 1						%= OK-button
    watch
  
    %
    %extract the new size
    %
    QTEMP9 = length(QmatNMR.uiInput1);
    if ((QmatNMR.uiInput1(QTEMP9) == 'k') | (QmatNMR.uiInput1(QTEMP9) == 'K'))
      QTEMP9 = round(str2num(QmatNMR.uiInput1(1:(QTEMP9-1))) * 1024 );
    else
      QTEMP9 = round(str2num(QmatNMR.uiInput1));
    end
  
  
    %
    %Check whether the new size is any different from the old one. If not don't do
    %anything, to avoid writing a possibly disturbing processing action to the history
    %
    if (QmatNMR.Size1D == QTEMP9)		%sizes are the same
      disp('matNMR NOTICE: new size is the same as the old size. No action taken!');
      QmatNMR.SwitchTo1D = 0; 	%reset flag
      Arrowhead
  
    else
      if (QmatNMR.SwitchTo1D) 		%switch from 2D to 1D processing if necessary
        SwitchTo1D
      end
      
      %
      %create entry in the undo matrix
      %
      regelUNDO
  
      %
      %here we change the size by making avariable of the new size and adding the current FID
      %to the beginning, UNLESS we have a whole-echo FT selected. Then we add the new points
      %from the center of the FID
      %
      QmatNMR.Size1D = QTEMP9;		%the new size
      QTEMP4 = length(QmatNMR.Spec1D);		%the previous size
      QTEMP = zeros(1, QmatNMR.Size1D);
      if (QmatNMR.howFT ~= 5) 		%always add to the end, except for whole-echo processing
        if (QTEMP4 > QmatNMR.Size1D) 		%old size is larger than new size
          QTEMP(1:QmatNMR.Size1D) = QmatNMR.Spec1D(1:QmatNMR.Size1D);
          QmatNMR.Spec1D = QTEMP;
        else			%new size is larger than old size
          QTEMP(1:QTEMP4) = QmatNMR.Spec1D;
          QmatNMR.Spec1D = QTEMP;
        end
      
      else			%in case of whole-echo we add from the center of the FID
        if (QTEMP4 > QmatNMR.Size1D) 		%old size is larger than new size
          QTEMP(1:ceil(QmatNMR.Size1D/2)) = QmatNMR.Spec1D(1:ceil(QmatNMR.Size1D/2));
          QTEMP((ceil(QmatNMR.Size1D/2)+1):QmatNMR.Size1D) = QmatNMR.Spec1D((QTEMP4+1-floor(QmatNMR.Size1D/2)):QTEMP4);
          QmatNMR.Spec1D = QTEMP;
        else			%new size is larger than old size
          QTEMP(1:ceil(QTEMP4/2)) = QmatNMR.Spec1D(1:ceil(QTEMP4/2));
          QTEMP((QmatNMR.Size1D+1-floor(QTEMP4/2)):QmatNMR.Size1D) = QmatNMR.Spec1D((ceil(QTEMP4/2)+1):QTEMP4);
          QmatNMR.Spec1D = QTEMP;
        end
      end
    
      %
      %ALWAYS revert to the default axis
      %
      QmatNMR.RulerXAxis = 0;		%Flag for default axis
      
      QmatNMR.fase1startIndex = floor(QmatNMR.Size1D/2)+1;
    
      QmatNMR.lbstatus=0;				%reset linebroadening flag and button
    
      QmatNMR.Dim = 0;
      setfourmode
      disp(['The new size of the 1D spectrum is : ', num2str(QmatNMR.Size1D) ' points.']);
      QmatNMR.History = str2mat(QmatNMR.History, ['The new size of the 1D spectrum is : ', num2str(QmatNMR.Size1D)]);
    
      %first add dimension-specific information, and then the current command
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 4, QmatNMR.Size1D, QmatNMR.howFT);		%code for set size 1D, new size, FT mode
        
      if QmatNMR.RecordingMacro
        %first add dimension-specific information, and then the current command
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 4, QmatNMR.Size1D, QmatNMR.howFT);		%code for set size 1D, new size, FT mode
      end
    
      repair
      
      if (~QmatNMR.BusyWithMacro)
        asaanpas
        Arrowhead
      end
    end
  
  else
    disp('No changes made in the size of the spectrum !');
    QmatNMR.SwitchTo1D = 0;	%reset flag because it is possible that the user came from a 2D but cancelled the action
  end; 
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
