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
%convertBrukerqseq1d.m is used to convert 1D Bruker qseq (Redfield) experiments taken on a Bruker machine and 
%convert it to a format that can be used by matNMR. 
%The function is of the script is as follows :
%
% The data are ordered in the following way :
%
% Re  1  3  5  7  9
% Im   2  4  6  8  10
%
% To process this as a normal TPPI one has to make a real vector out of this and invert every 3rd and 4th
% data point
% Then a normal real FT will do the job. Throw away half of the points and you'll be finished.
%
% Jacco van Beek
% 23-11-'98
%

try
  watch
  if (QmatNMR.SwitchTo1D) 		%switch from 2D to 1D processing if necessary
    SwitchTo1D
  end
  
  %
  %create entry in the undo matrix
  %
  regelUNDO

  if ~isreal(QmatNMR.Spec1D)		%convert to a real vector if it is complex.
    QTEMP1 = zeros(1, 2*QmatNMR.Size1D);
    QTEMP1(1:2:2*QmatNMR.Size1D) = real(QmatNMR.Spec1D);
    QTEMP1(2:2:2*QmatNMR.Size1D) = imag(QmatNMR.Spec1D);
    QmatNMR.Spec1D = QTEMP1;
    QmatNMR.Size1D = 2*QmatNMR.Size1D;
    
  else
    disp('matNMR WARNING: 1D vector is not complex and cannot be transformed.');
    disp('matNMR WARNING: conversion of Bruker qseq data cancelled.');
    return
  end  
  
  if (rem(QmatNMR.Size1D, 4))		%check whether the length of the fid is a multiple of 4. If not, make so
    QmatNMR.Spec1D( (QmatNMR.Size1D+1):(QmatNMR.Size1D+rem(QmatNMR.Size1D, 4)) ) = 0;
    QmatNMR.Size1D = length(QmatNMR.Spec1D);
  end
  
  				%combine and invert the four parts ...
  QmatNMR.Spec1D(1, 3:4:QmatNMR.Size1D) = -QmatNMR.Spec1D(3:4:QmatNMR.Size1D);
  QmatNMR.Spec1D(1, 4:4:QmatNMR.Size1D) = -QmatNMR.Spec1D(4:4:QmatNMR.Size1D);

				%finish up
  disp('Converting 1D Bruker qseq (Redfield) data to 1D TPPI data ...');
  disp(['new size of the 1D FID is :  ', num2str(QmatNMR.Size1D, 10), ' points. ']);
  QmatNMR.History = str2mat(QmatNMR.History, 'Converted 1D Bruker qseq FID to 1D TPPI FID');

  %first add dimension-specific information, and then the current command
  QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
  QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 13);
  
  if QmatNMR.RecordingMacro
    %first add dimension-specific information, and then the current command
    QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
    QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 13);
  end

  QmatNMR.lbstatus = 0;
  
  %
  %ALWAYS revert to the default axis
  %
  QmatNMR.RulerXAxis = 0;		%Flag for default axis

  Qspcrel
  CheckAxis
  repair

  if (~QmatNMR.BusyWithMacro)
    asaanpas
    Arrowhead
  end  

  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
