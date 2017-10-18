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
%convertstates.m is used to convert states experiments taken on a Bruker machine and convert it to
%the format that is used by matNMR. MatNMR uses the same format as Chemagnetics does and so the
%FID-matrix should be built up like this :
%
% |----------------> real part of the matrix
% |RR           RI
% |
% |
% |
% |
% ------------------ complex part of the matrix
% |IR           II
% |
% |
% |
% |
% |
% 
% So the RR part is the real part in t1 and t2. The RI is the imaginary part in t1 and the real part
% in t2, etc.
%
%
% On Bruker and Varian machines the imaginary parts in t1 will probably be alternated with the real parts in t1
% so:  (RR RI)1
%      (IR II)1
%      (RR RI)2
%      (IR II)2
% etc.
%
%
%
%
% Jacco van Beek
% 15-10-'98
%

function [ret, dim1, dim2] = ConvertStates(QMatrix)
  [Qy Qx] = size(QMatrix);			%Qy denotes the td1 direction in matNMR !!
  						%Note: the user himself is responsible for putting
  						%the right dimension as td1 !!
  ret = zeros(Qy/2, 2*Qx);
  
  teller = 1:(Qy/2);
  
  ret(teller, 1:Qx) = QMatrix((teller-1)*2+1, :);
  ret(teller, (Qx+1):(2*Qx)) = QMatrix(teller*2, :);

  dim1 = 2*Qx;
  dim2 = Qy/2;
    
  disp(['new size of the 2D states FID is :  ', num2str(Qy/2), ' x ', num2str(2*Qx), ' points (td1 x td2). ']);
end
