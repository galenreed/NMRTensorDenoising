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
%
% matNMRCadzow1DFD
%
% syntax: [MatrixOut, SV] = matNMRCadzow1DFD(MatrixIn, SpectralWindows, WindowSize, NrFreqs, CadzowRepeat)
%
% Allows performing Cadzow filtering to frequency-domain data with very low S/N. The Cadzow filter essentially 
% performs something of a principal component analysis. By excluding all but NrFreqs components noise is 
% strongly reduced. Naturally, the result may well be unphysical!
% By repeating the filter the results may improve (or worsen). The window size should be between 0.2 and 
% 0.5, with 0.33 a good optimum between speed and accuracy. The number of expected frequencies NrFreqs 
% constrains the final result and should be played with to distinguish between artefacts and real peaks.
% see also: IEEE Trans. Acoustics Speech and Signal Processing 36 (1988), 49-62
%
% SpectralWindows must be a nx2 sized matrix where n defines the number of spectral ranges in which peaks are
% expected. The 2 indices denote begin and end of the spectral window in data points.
% NrFreqs is a vector of length n with the number of frequencies that are expected for each window.
%
% We might just as well use the matNMRCadzowLPSVD1D routine wenn we're at it ...
%
% SV will show the singular values determined during the Cadzow filtering. These have some diagnostic value.
%
% Jacco van Beek
% 04-03-2008
%

function [MatrixOut, SV] = matNMRCadzow1DFD(MatrixIn, SpectralWindows, WindowSize, NrFreqs, CadzowRepeat)

%
%define an empty output variable by default
%
  MatrixOut = [];
  SV = [];


%
%Check whether data is truly 1D
%
  if ((ndims(MatrixIn) == 2) & ~isa(MatrixIn, 'struct'))
    [SizeTD1, SizeTD2] = size(MatrixIn);
    if ((SizeTD1 ~= 1) & (SizeTD2 ~= 1))
      beep
      disp('matNMRLP1D ERROR: data  is not 1D. Aborting ...');
      return;
  
    else
      Size = length(MatrixIn);
    end

  else
    beep
    disp('matNMRLP1D ERROR: data  is not 1D. Aborting ...');
    return
  end


%
%Analyse spectrum: gives dampening, amplitudess, phase, frequency
%
  %
  %Execute Cadzow filter as many times as asked for
  %
  MatrixOut = MatrixIn;
  for QTEMP1 = 1:CadzowRepeat
    [MatrixOut, QTEMP2] = cadzow(MatrixOut, NrFreqs, CadzowWindow);
    SV(QTEMP1, :) = QTEMP2;
  end
