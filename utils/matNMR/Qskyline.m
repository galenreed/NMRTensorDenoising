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
%Qskyline.m returns the skyline projection at an angle Angle of Matrix
%5-3-1997
%
%Qskyline.m gives the skyline projection 
%
% usage:  Qskyline(Matrix, Angle)
%
% where the Angle corresponds to :
%
% Angle =   0:  view([ 90  0])
% Angle =  45:  view([ 45  0])
% Angle =  90:  view([  0  0])
% Angle = 135:  view([-45  0])
%

function ret = Qskyline(Matrix, Angle);

[Size1, Size2] = size(Matrix);

Matrix = real(Matrix);

if (Angle == 90)
  ret = zeros(1, Size2);

  for tel1 = 1:Size2
    ret(tel1) = max(Matrix(:, tel1));
  end; 

elseif (Angle == 0)
  ret = zeros(1, Size1);

  for tel1 = 1:Size1
    ret(tel1) = max(Matrix(tel1, :));
  end; 

elseif ((Angle == 135) & (Size1 == Size2))
  ret = zeros(1, 2*Size1-1);

  for tel1 = 1:(2*Size1-1)
    ret(tel1) = max(diag(Matrix, tel1-Size1));
  end
  
elseif ((Angle == 45) & (Size1 == Size2))
  ret = zeros(1, 2*Size1-1);
  Matrix = fliplr(Matrix);
  
  for tel1 = 1:(2*Size1-1)
    ret(tel1) = max(diag(Matrix, -tel1+Size1));
  end

else
  [QmatNMR.x QmatNMR.y] = size(Matrix)
  [xx, yy]= meshgrid(QmatNMR.y, QmatNMR.x);
  zz = 0*xx;
  
  [xx, yy, zz] = EulerRotate(xx, yy, zz, Angle, 0, 0);
  
  min(min(xx))
  max(max(xx))
  min(min(yy))
  max(max(yy))

  disp('matNMR NOTICE: Sorry, skyline projections along arbitrary angle or with non-square matrices are not implemented yet ...');
end


%=========================================================================
function [xx, yy, zz] = EulerRotate(x, y, z, Alpha, Beta, Gamma)
%EulerRotate rotates the matrices x, y and z by the Euler rotation over
%	Alpha, Beta, Gamma.
%	
%Jacco van Beek
%05-08-1999
%

if ~(nargin==6)
  error('EulerRotate error: wrong number of input parameters!');

else  
  Alpha = Alpha * pi / 180;
  Beta  = Beta * pi / 180;
  Gamma = Gamma * pi / 180;

  CoG = cos(Gamma);
  CoB = cos(Beta);
  CoA = cos(Alpha);
  SiG = sin(Gamma);
  SiB = sin(Beta);
  SiA = sin(Alpha);

  T1  = CoG*CoB*CoA;
  T2  = SiG*SiA;
  T3  = CoG*CoB*SiA;
  T4  = SiG*CoA;
  T5  = CoG*SiB;
  T6  = SiG*CoB*CoA;
  T7  = CoG*SiA;
  T8  = SiG*CoB*SiA;
  T9  = CoG*CoA;
  T10 = SiG*SiB;
  T11 = SiB*CoA;
  T12 = SiB*SiA;
  T13 = CoB;
  
  xx =  x*T1 - x*T2 + y*T3 + y*T4 - z*T5;
  yy = -x*T6 - x*T7 - y*T8 + y*T9 + z*T10;
  zz =  x*T11 + y*T12 + z*T13;
end
