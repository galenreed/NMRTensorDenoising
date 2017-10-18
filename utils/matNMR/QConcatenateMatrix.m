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
%QConcatenateMatrix.m
%
%	syntax:		QConcatenateMatrix(Matrix, nTimes, Direction)
%
%	returns a 2D Matrix which is made up of nTimes Matrix, which must be 1D or 2D itself: 
%
%			  [Matrix Matrix Matrix ... Matrix]
%					or
%			[Matrix; Matrix; Matrix; ...; Matrix]
%
%	By default the first way is performed (Direction=0 or not given at all).
%	When Direction is set to 1 then the second way is performed.
%
%Jacco van Beek
%14-01-1999
%

function ret = QConcatenateMatrix(Matrix, nTimes, Direction)

  if (nargin<2)
    error('QConcatenateMatrix:  Not enough input parameters!')
    
  else
    if (nargin==2) 
      Direction = 0;				%by default append matrix horizontally
    end  
    temp = size(Matrix);
    
    if (Direction==0)
      ret = zeros(temp(1), nTimes*temp(2));	%append matrix horizontally
      
      for teller=1:nTimes
        ret(:, ((teller-1)*temp(2)+1):(teller*temp(2))) = Matrix;
      end
      
    else  
      ret = zeros(temp(1)*nTimes, temp(2));	%append matrix vertically
      
      for teller=1:nTimes
        ret(((teller-1)*temp(1)+1):(teller*temp(1)), :) = Matrix;
      end
      
    end  	
  end  
