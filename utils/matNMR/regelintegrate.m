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
%regelintegrate.m takes care of integrating 2D spectra.
%24-08-'98

try
  if (QmatNMR.buttonList == 1)			%= OK-button
    QTEMP1 = QmatNMR.uiInput1;
    QmatNMR.IntegrationValue = eval(QmatNMR.uiInput3);
  					%integrate QmatNMR.Spec2D3D
    eval(['QmatNMR.Spec2D3D = ' QmatNMR.uiInput3 '*QmatNMR.Spec2D3D/sum(sum(real(QmatNMR.Spec2D3D(' QmatNMR.uiInput2 '))));']);
    disp(['Spectrum integrated to ' num2str(eval(QmatNMR.uiInput3), 10) ' for range (' QmatNMR.uiInput2 ')']);  
    
    					%save the integrated spectrum in the designated variable
    if exist(QTEMP1)					
      if (isa(eval(QTEMP1), 'struct'))
        eval([QTEMP1 '.Spectrum = QmatNMR.Spec2D3D;']);
        eval([QTEMP1 '.History = str2mat(' QTEMP1 '.History, [''Spectrum integrated to '' num2str(eval(QmatNMR.uiInput3), 10) '' for range ('' QmatNMR.uiInput2 '')'']);']);
        
        QTEMP2 = findstr(QmatNMR.uiInput2, ',');		%explore the range
        QTEMP3 = eval(QmatNMR.uiInput2(1:(QTEMP2-1)));	%range for TD1
        QTEMP4 = eval(QmatNMR.uiInput2((QTEMP2+1):length(QmatNMR.uiInput2)));	%range for TD2
        [QTEMP1 '.HistoryMacro = AddToMacro(' QTEMP1 '.HistoryMacro, 119,' num2str(QTEMP4(1)) ',' num2str(QTEMP4(length(QTEMP4))) ',' num2str(QTEMP3(1)) ',' num2str(QTEMP3(length(QTEMP3))) ', QmatNMR.IntegrationValue);']
        eval([QTEMP1 '.HistoryMacro = AddToMacro(' QTEMP1 '.HistoryMacro, 119,' num2str(QTEMP4(1)) ',' num2str(QTEMP4(length(QTEMP4))) ',' num2str(QTEMP3(1)) ',' num2str(QTEMP3(length(QTEMP3))) ', QmatNMR.IntegrationValue);']);
        
        disp(['Integrated spectrum saved in existing structure ' QTEMP1]);
      else  
        eval([QTEMP1 ' = QmatNMR.Spec2D3D;']);
      
        disp(['Integrated spectrum saved as ' QTEMP1]);
      end
    else  
      eval([QTEMP1 ' = QmatNMR.Spec2D3D;']);
     
      disp(['Integrated spectrum saved as ' QTEMP1]);
    end
  
  else
    disp('Integration cancelled ...');
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
