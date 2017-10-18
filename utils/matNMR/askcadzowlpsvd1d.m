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
%askcadzowlpsvd1d.m handles input for Cadzow filtering followed by LPSVD spectral estimation
%
%03-03-'08


try
  if (QmatNMR.FIDstatus == 1) 		%frequency-domain data
    %
    %First define small spectral windows that are expected to contain peaks
    %
    defpeaksCadzow
    
    %
    %Get more input
    %
    if (length(QmatNMR.CadzowNrFreqs) == QmatNMR.CadzowNumPeaks)
      QTEMP = ['[' num2str(QmatNMR.CadzowNrFreqs(1)) ']']; 		%use previous values if possible
    else
      QTEMP = '[1]';	 %otherwise fill in 1
    end
    for QTEMP1 = 2:QmatNMR.CadzowNumPeaks
      if (length(QmatNMR.CadzowNrFreqs) == QmatNMR.CadzowNumPeaks)
        QTEMP = [QTEMP(1:end-1) ' ' num2str(QmatNMR.CadzowNrFreqs(QTEMP1)) ']']; 		%use previous values if possible
      else
        QTEMP = [QTEMP(1:end-1) ' 1]']; 		%otherwise fill in 1
      end
    end
    QuiInput('Cadzow filtering + LPSVD estimation :', ' OK | CANCEL', 'regelcadzowlpsvd1d', [], ...
             'Window size of Hankel matrix (0.2-0.5) :', QmatNMR.CadzowWindow, ...
             'Nr of frequencies in spectral windows :', QTEMP, ...
             'Repeat Cadzow filter how many times :', QmatNMR.CadzowRepeat);
  
  else 					%time-domain data
    QuiInput('Cadzow filtering + LPSVD estimation :', ' OK | CANCEL', 'regelcadzowlpsvd1d', [], ...
             'Window size of Hankel matrix (0.2-0.5) :', QmatNMR.CadzowWindow, ...
             '# frequencies :', QmatNMR.CadzowNrFreqs, ...
             'Repeat Cadzow filter how many times :', QmatNMR.CadzowRepeat, ...
             'Nr of Points to use for final FID :', QmatNMR.CadzowLPSVDpoints);
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
