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
%convertEAE.m is used to convert echo / anti-echo experiments to hypercomplex
%the format that is used by matNMR. MatNMR uses the same format as Chemagnetics does and so the
%FID-matrix should be built up like this :
%
% |----------------> real part of the matrix
% |ER           AER
% |
% |
% |
% |
% ------------------ complex part of the matrix
% |EI           AEI
% |
% |
% |
% |
% |
% 
% So the ER part is the echo part in t1 and real part in t2. The AER is the anti-echo part in t1 and the real part
% in t2, etc.
%
%
% On Bruker and Varian machines the imaginary parts in t1 will probably be alternated with the real parts in t1
% so:  (ER EI)1
%      (AER AEI)1
%      (ER EI)2
%      (AER AEI)2
% etc.
%
%
%
%
% Jacco van Beek
% 16-08-'06
%

function [QFT1, QFT2, dim1, dim2] = convertEAE(QMatrix, QMatrixhc)

  if (nargin == 1)
    %
    %dataset is not yet hypercomplex
    %
    [Qy Qx] = size(QMatrix);			%Qy denotes the td1 direction in matNMR !!
    						%Note: the user himself is responsible for putting
    						%the right dimension as td1 !!
    QFT1 = zeros(Qy, Qx/2);
    QFT2 = zeros(Qy, Qx/2);
    
    QFT1 =           QMatrix(:, 1:(Qx/2)) + QMatrix(:, (Qx/2+1):Qx);
    QFT2 = sqrt(-1)*(QMatrix(:, 1:(Qx/2)) - QMatrix(:, (Qx/2+1):Qx));
  
    dim1 = Qx/2;
    dim2 = Qy;
      
    disp(['new size of the 2D states FID is :  ', num2str(Qy), ' x ', num2str(Qx/2), ' points (td1 x td2). ']);

  else
    %
    %just in case the dataset is already hypercomplex
    %
    [Qy Qx] = size(QMatrix);			%Qy denotes the td1 direction in matNMR !!
    						%Note: the user himself is responsible for putting
    						%the right dimension as td1 !!
    QFT1 = zeros(Qy, Qx);
    QFT2 = zeros(Qy, Qx);
    
    QFT1 =           QMatrix(:, 1:Qx) + QMatrixhc(:, 1:Qx);
    QFT2 = sqrt(-1)*(QMatrix(:, 1:Qx) - QMatrixhc(:, 1:Qx));
  
    dim1 = Qx;
    dim2 = Qy;
      
    disp(['new size of the 2D states FID is :  ', num2str(Qy), ' x ', num2str(Qx/2), ' points (td1 x td2). ']);
  end
end
