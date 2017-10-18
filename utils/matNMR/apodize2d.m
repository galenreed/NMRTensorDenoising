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
%apodize.m takes care of the apodization of the current dimension of the 2D spectrum using the current
%apodization function
%21-2-1997

try
  if (QmatNMR.Dim == 0)
    disp('matNMR NOTICE: 2D processing functions are not allowed in 1D mode!')
  
  else  
    watch;
    if ~ (QmatNMR.lbstatus == 0)			%Only apodize if the user has defined an apodization function
    
      %
      %create entry in the undo matrix
      %
      regelUNDO
  
  
      %
      %clear the a posteriori entries
      %
      QmatNMR.APosterioriMacro = AddToMacro;
      QmatNMR.APosterioriHistory = '';
      QmatNMR.APosterioriHistoryEntry = 0;
  
    
      %Now apodize according to the right dimension
      if QmatNMR.Dim == 1						%apodize td2
        if ((QmatNMR.lbstatus == 100) | (QmatNMR.lbstatus == 1001))		%Shifting Gaussian function (normal and for echo's!)
          QmatNMR.howFT = get(QmatNMR.Four, 'value');				%States processing ?
          if ((QmatNMR.howFT == 3) | (QmatNMR.howFT == 6))			%States or States-TPPI
            QmatNMR.Spec2D = QmatNMR.Spec2D .* QmatNMR.emacht;
            QmatNMR.Spec2Dhc = QmatNMR.Spec2Dhc .* QmatNMR.emacht;
          else							%No States
            QmatNMR.Spec2D = QmatNMR.Spec2D .* QmatNMR.emacht;
          end
        
        else
    
          QmatNMR.howFT = get(QmatNMR.Four, 'value');				%States processing ?
          if ((QmatNMR.howFT == 3) | (QmatNMR.howFT == 6))			%States or States-TPPI
            for QTEMP40=1:QmatNMR.SizeTD1					%Multiply all rows with the apodization function
              QmatNMR.Spec2D(QTEMP40, :) = (QmatNMR.Spec2D(QTEMP40, :) .* QmatNMR.emacht);
              QmatNMR.Spec2Dhc(QTEMP40, :) = (QmatNMR.Spec2Dhc(QTEMP40, :) .* QmatNMR.emacht);
            end  
    
          else							%No States
            for QTEMP40=1:QmatNMR.SizeTD1					%Multiply all rows with the apodization function
              QmatNMR.Spec2D(QTEMP40, :) = (QmatNMR.Spec2D(QTEMP40, :) .* QmatNMR.emacht);
            end
          end
        end;  
  
  
        %
        %clear the a posteriori entries
        %
        QmatNMR.APosterioriMacro = AddToMacro;
        QmatNMR.APosterioriHistory = '';
        QmatNMR.APosterioriHistoryEntry = 0;
  
  
        historyapodize;		%fill in history
        removecurrentline;
        QmatNMR.lbstatus=0;		%reset linebroadening flag and button
        set(QmatNMR.h75, 'value', 1);
        getcurrentspectrum	%get spectrum to show on the screen
        Qspcrel
        CheckAxis
    
        if (~QmatNMR.BusyWithMacro)
          simpelplot		%replot spectrum but don't change the scale
          Arrowhead;
        end  
    
        disp('apodization of TD2 finished ');
      
      else								%apodize td1
        QmatNMR.emacht = QmatNMR.emacht';
        QmatNMR.howFT = get(QmatNMR.Four, 'value');				%States processing ?
        if ((QmatNMR.howFT == 3) | (QmatNMR.howFT == 6))				%States or States-TPPI
          for QTEMP40=1:QmatNMR.SizeTD2
            QmatNMR.Spec2D(:, QTEMP40) = (QmatNMR.Spec2D(:, QTEMP40) .* QmatNMR.emacht);
            QmatNMR.Spec2Dhc(:, QTEMP40) = (QmatNMR.Spec2Dhc(:, QTEMP40) .* QmatNMR.emacht);
          end;  
    
        else							%No States
          for QTEMP40=1:QmatNMR.SizeTD2
            QmatNMR.Spec2D(:, QTEMP40) = (QmatNMR.Spec2D(:, QTEMP40) .* QmatNMR.emacht);
          end;  
        end
    
        historyapodize;		%fill in history
        removecurrentline;
        QmatNMR.lbstatus=0;		%reset linebroadening flag and button
        set(QmatNMR.h75, 'value', 1);
        getcurrentspectrum	%get spectrum to show on the screen
        Qspcrel
        CheckAxis
    
        if (~QmatNMR.BusyWithMacro)
          simpelplot		%replot spectrum but don't change the scale
          Arrowhead;
        end  
    
        disp('apodization of TD1 finished');
      end
    
    else
      disp('matNMR ERROR: No apodization function has been defined yet !!!');
      beep
    end  
  end

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
