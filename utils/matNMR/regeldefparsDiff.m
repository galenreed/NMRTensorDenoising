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
%regeldefparsDiff.m takes care of the input for supplying the constants needed for
%the diffusion fit.
%26-03-'03

try
  if (QmatNMR.buttonList == 1)				%= OK-button
    %
    %protect ourselves against any empty strings in the input box, to avoid error
    %messages with the eval command. If any is empty then we'll just reopen the input
    %window
    %
    if isempty(QmatNMR.uiInput1) | isempty(QmatNMR.uiInput2) | isempty(QmatNMR.uiInput3)
      disp('matNMR WARNING: empty input boxes are not allowed.');
      
      QuiInput('Input constants :', ' OK | CANCEL', 'regeldefparsDiff;', [], ...
    	     '\gamma/2\pi in MHz/T :', num2str(QmatNMR.DiffGamma, 15), ...
    	     'Gradient duration \delta in s :', num2str(QmatNMR.Diffdelta, 15), ...
               '\alpha :', num2str(QmatNMR.Diffalpha, 15), ...
    	     'Gradient spacing \Delta in s :', num2str(QmatNMR.DiffDELTA, 15), ...
               '\tau (\pi-pulse) for bipolar gradients in s (0 if not applicable) :', num2str(QmatNMR.Difftau, 15), ...
               '\beta :', num2str(QmatNMR.Diffbeta, 15));
    else
      QmatNMR.DiffGamma = eval(QmatNMR.uiInput1);
      QmatNMR.Diffdelta = eval(QmatNMR.uiInput2);
      QmatNMR.Diffalpha = eval(QmatNMR.uiInput3);
      QmatNMR.DiffDELTA = eval(QmatNMR.uiInput4);
      QmatNMR.Difftau   = eval(QmatNMR.uiInput5);
      QmatNMR.Diffbeta  = eval(QmatNMR.uiInput6);
      if (QmatNMR.Diffbeta == 0)
        QmatNMR.Diffbeta = 1;
      end
  
      %
      %continue by going back to Difffit
      %
      Difffit('defparsbut2');
    end
  
  elseif (QmatNMR.buttonList == 2)			%= Read Bruker == HIGHLY SPECIFIC!! MAY CHANGE IN FUTURE!
      QmatNMR.DiffGamma = eval(QmatNMR.uiInput1);	%gamma still needs to be entered in the input window
      QmatNMR.Difftau   = eval(QmatNMR.uiInput4);	%tau still needs to be entered in the input window
  
      [QmatNMR.my_dummy, QmatNMR.my_path] = uigetfile([pwd filesep '*.*'], 'Select ACQUS File');
      QmatNMR.my_fp=fopen(strcat(QmatNMR.my_path,'acqus'),'r');
      while(feof(QmatNMR.my_fp)==0)
          QmatNMR.my_line=fgetl(QmatNMR.my_fp);
          if strncmp(QmatNMR.my_line,'##$P= (0..', 5)
              QmatNMR.my_line=fgetl(QmatNMR.my_fp);
              QmatNMR.my_num1=sscanf(QmatNMR.my_line,'%f ',inf);
              QmatNMR.my_line=fgetl(QmatNMR.my_fp);
              QmatNMR.my_num2=sscanf(QmatNMR.my_line,'%f ',inf);
              QmatNMR.my_numsp=[QmatNMR.my_num1;QmatNMR.my_num2];
          end
          if strncmp(QmatNMR.my_line,'##$D= (0..', 5)
              QmatNMR.my_line=fgetl(QmatNMR.my_fp);
              QmatNMR.my_num1=sscanf(QmatNMR.my_line,'%f ',inf);
              QmatNMR.my_line=fgetl(QmatNMR.my_fp);
              QmatNMR.my_num2=sscanf(QmatNMR.my_line,'%f ',inf);
              QmatNMR.my_numsd=[QmatNMR.my_num1;QmatNMR.my_num2];
          end
      end
      QmatNMR.my_D=QmatNMR.my_numsd(21);
      QmatNMR.my_d=(QmatNMR.my_numsp(18)+QmatNMR.my_numsp(19))/1000000;
  
      %
      %the important parameters
      %
      QmatNMR.Diffdelta = QmatNMR.my_d;
      QmatNMR.DiffDELTA = QmatNMR.my_D;
  
      fclose(QmatNMR.my_fp);
  
  else
    disp('Input of constants for diffusion fit was cancelled ...');
  end; 

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
