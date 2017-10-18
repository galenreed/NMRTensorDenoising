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
%askshearingTD.m takes care of the input for the shearing transformation in time domain
%
%23-07-'97

try
  if (QmatNMR.Dim == 0)
    disp('matNMR NOTICE: 2D processing functions are not allowed in 1D mode!')
  
  else  
    if QmatNMR.lbstatus | QmatNMR.bezigmetfase
      disp('matNMR WARNING:  not possible while apodizing or phasing!     askshearingTD cancelled');
    
    else
      if ~(QmatNMR.Dim == 2)		%if current dimension is not TD1
        QTEMP = str2mat('Complex FT TD1', 'Real FT TD1', 'States TD1', 'TPPI TD1', 'Whole Echo TD1', 'States-TPPI TD1', 'Bruker qseq TD1', 'Sine FT TD1');
        disp('matNMR WARNING: current dimension was not TD1 !!');
        disp(['The default FT mode for TD1 (' deblank(QTEMP(QmatNMR.four1, :)) ') will be assumed when shearing.']);
      end
    
      QuiInput('Shearing Transformation in Time Domain :', ' OK | CANCEL', 'regelshearingTD', [], ...
               'Shearing factor : ', QmatNMR.ShearingFactor, ...
               'Spectral Width in TD 2 (kHz) :', QmatNMR.SWTD2, ...
               'Spectral Width in TD 1 (kHz) :', QmatNMR.SWTD1);
    end
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
