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
%makenew3D.m loads a new 3D as a series of 2D FID's/spectra and shows the 1st experiment of the
%first 2D as a 1D spectrum in the main window. 
%All necessary variables that need to be initialized are so in here.
%03-07-'04

try
  watch;
  
  
  %
  %set the UI control for the input variable
  %
  QmatNMR.Q3DInput = QmatNMR.Spec1DName;
  QmatNMR.Spec3DName = QmatNMR.Spec1DName;
  set(QmatNMR.but3D3, 'String', QmatNMR.Q3DInput);
  
  
  %
  %reset the UI control for the output variable
  %
  QmatNMR.Q3DOutput = '';
  set(QmatNMR.but3D5, 'String', QmatNMR.Q3DOutput);
  
  
  %
  %reset the UI control for the index counter
  %
  QmatNMR.Q3DIndex = 1;
  set(QmatNMR.but3D7, 'string', QmatNMR.Q3DIndex);
  
  
  %
  %Check whether the input variable is a real variable or not. If not then we make a
  %temporary variable in the workspace that will contain the 3D matrix (takes more
  %memory!
  %
  if (CheckVariableName(QmatNMR.Q3DInput))
    QmatNMR.Q3DInput2 = QmatNMR.Q3DInput;
  
  else
    eval(['QmatNMR.Temp3DVar = ' QmatNMR.Q3DInput ';']);
    QmatNMR.Q3DInput2 = 'QmatNMR.Temp3DVar';
  end
  
  %
  %determine the size of the 3D
  %
  if (isstruct(eval(QmatNMR.Q3DInput2)))
    %
    %make sure it is really a 3D matrix
    %
    QTEMP4 = size(squeeze(eval([QmatNMR.Q3DInput2 '.Spectrum'])));
    if (length(QTEMP4) == 1)
      disp('matNMR NOTICE: the variable is in fact a 1D and will be loaded as such.');
      QmatNMR.ask = 1;
      regelnaam;
      return
  
    elseif (length(QTEMP4) == 2)
      disp('matNMR NOTICE: the variable is in fact a 2D and will be loaded as such.');
      QmatNMR.ask = 2;
      regelnaam
      return
  
    elseif (length(QTEMP4) == 3)
      QmatNMR.Size3D = QTEMP4(1);
  
    else
      disp('matNMR WARNING: matrix has dimensionality higher than 3! Aborting...');
      return
    end
  
  else
    %
    %make sure it is really a 3D matrix
    %
    QTEMP4 = size(squeeze(eval(QmatNMR.Q3DInput2)));
    if (length(QTEMP4) == 1)
      disp('matNMR NOTICE: the variable is in fact a 1D and will be loaded as such.');
      try
        delete(QmatNMR.fig3D);
      end
      QmatNMR.fig3D = [];
  
      QmatNMR.Spec1DName = QmatNMR.Q3DInput;
      [QmatNMR.Spec1DName, QmatNMR.CheckInput] = checkinput(QmatNMR.Spec1DName);%adjust the format of the input expression for later use
      makenew1D
      return
  
    elseif (length(QTEMP4) == 2)
      disp('matNMR NOTICE: the variable is in fact a 2D and will be loaded as such.');
      try
        delete(QmatNMR.fig3D);
      end
      QmatNMR.fig3D = [];
  
      QmatNMR.Spec1DName = QmatNMR.Q3DInput;
      [QmatNMR.Spec1DName, QmatNMR.CheckInput] = checkinput(QmatNMR.Spec1DName);%adjust the format of the input expression for later use
      makenew2D
      return
  
    elseif (length(QTEMP4) == 3)
      QmatNMR.Size3D = QTEMP4(1);
  
    else
      disp('matNMR WARNING: matrix has dimensionality higher than 3! Aborting...');
      return
    end
  end
  
  
  %
  %make the main window the current one by pulling it forward
  %
  Arrowhead
  figure(QmatNMR.Fig)
  
  
  %
  %now read in the current 2D by using the index for the 3D
  %
  disp('Loading 3D as series of 2D, starting with first index');
  QmatNMR.Spec1DName = [QmatNMR.Q3DInput2 '(' num2str(QmatNMR.Q3DIndex) ', :, :)'];
  [QmatNMR.Spec1DName, QmatNMR.CheckInput] = checkinput(QmatNMR.Spec1DName);%adjust the format of the input expression for later use
  makenew2D
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
