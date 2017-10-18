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
% pcolor3d
%
% syntax: handle = pcolor3d(x, y, C)
%
% performs the 3D equivalent of a pcolor plot. Instead of having a flat surface with colors
% matching the value of the matrix C, now each value is made into a rectangular bar with
% a uniform colour matching the value in C.
%
% Jacco van Beek
% 15-12-2004
%

function pcolor3d(x, y, C, Type)

  %
  %remember current hold setting
  %
  TMP = get(gca, 'nextplot');

  if (nargin == 1)
    C = x;
    x = 1:size(C, 2);
    y = 1:size(C, 1);
  end

  [size2, size1] = size(C);
  
  %
  %The old scheme to determine the width of each bar did not work for non-linear axes!
  %
% incrX = (x(2)-x(1));
% incrY = (y(2)-y(1));

  %
  %generate grid points for the x-axis. This scheme also works for non-linear axes!
  %
  if (size1 == 1)
    AxisX = x;
  else
    incrX = diff(x);
    AxisX(1) = x(1) - incrX(1)/2;
    AxisX(2:size1) = x(1:(size1-1)) + incrX/2;
    AxisX(size1+1) = x(end) + incrX(end)/2;
  end


  %
  %generate grid points for the y-axis. This scheme also works for non-linear axes!
  %
  if (size2 == 1)
    AxisY = y;
  else
    incrY = diff(y);
    AxisY(1) = y(1) - incrY(1)/2;
    AxisY(2:size2) = y(1:(size2-1)) + incrY/2;
    AxisY(size2+1) = y(end) + incrY(end)/2;
  end
  


  hold on
  for tel1=1:size1
    for tel2=1:size2
      tmpvalue = C(tel2, tel1);
      
      if (Type == 1)
        %
        %The old scheme to determine the width of each bar did not work for non-linear axes!
        %
  %     tmpaxis1 = [x(tel1) x(tel1)+incrX] - incrX/2;
  %     tmpaxis2 = [y(tel2) y(tel2)+incrY] - incrY/2;
  
  
        %
        %The new scheme works for non-linear axes!
        %
        tmpaxis1 = AxisX([tel1 tel1+1]);
        tmpaxis2 = AxisY([tel2 tel2+1]);

        %
        %Create a closed bar in 3D space of monotone colour
        %
        if ~isnan(tmpvalue)
          %bottom surface
          surf(tmpaxis1, tmpaxis2, zeros(2), tmpvalue);
    
          %side 1 surface
          surf([tmpaxis1(1) tmpaxis1(1)], [tmpaxis2(1) tmpaxis2(2)], [0 tmpvalue; 0 tmpvalue], tmpvalue)
          
          %side 3 surface
          surf([tmpaxis1(2) tmpaxis1(2)], [tmpaxis2(1) tmpaxis2(2)], [0 tmpvalue; 0 tmpvalue], tmpvalue)
          
          %side 2 surface
          surf([tmpaxis1(1) tmpaxis1(2)], [tmpaxis2(1) tmpaxis2(1)], [0 0; tmpvalue tmpvalue], tmpvalue)
          
          %side 4 surface
          surf([tmpaxis1(1) tmpaxis1(2)], [tmpaxis2(2) tmpaxis2(2)], [0 0; tmpvalue tmpvalue], tmpvalue)
          
          %top surface
          surf(tmpaxis1, tmpaxis2, tmpvalue*ones(2), tmpvalue);
        end
      
      else
        if ~isnan(tmpvalue)
          %
          %closed cyclinder
          %
          [xx, yy, zz] = ClosedCylinder(1/2.2, tmpvalue, 30);
          surf(xx+x(tel1), yy+y(tel2), zz, zeros(size(zz))+tmpvalue)
        end
      end
    end
  end
  

  %
  %restore original hold setting
  %
  set(gca, 'nextplot', TMP);
  minminC = min(min(C));
  if (minminC == max(max(C)))
    minminC = 0;
  end
  set(gca, 'zlim', [minminC max(max(C))]);



%=========================================================================
function [xx,yy,zz] = ClosedCylinder(r, l, n, zlength)
%CLOSEDCYLINDER Generates a closed cylinder.
%   [X,Y,Z] = CYLINDER(R,N) forms the unit cylinder based on the generator
%   curve in the vector R. Vector R contains the radius at equally
%   spaced points along the unit height of the cylinder. The cylinder
%   has N points around the circumference. SURF(X,Y,Z) displays the
%   cylinder.
%
%   [X,Y,Z] = CYLINDER(R), and [X,Y,Z] = CYLINDER default to N = 20
%   and R = [1 1].
%
%   Omitting output arguments causes the cylinder to be displayed with
%   a SURF command and no outputs to be returned.
%
%   See also SPHERE CYLINDER.

%   Clay M. Thompson 4-24-91, CBM 8-21-92.
%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 5.3 $  $Date: 1997/11/21 23:46:14 $
%
%   the parameter zlength has been added to be able to create a cylinder
%   which the same amount of points in the z-direction. That way the object
%   can be used to produce a curve.
%
%   Jacco van Beek
%   5 august 1999
%

if nargin < 4, zlength = 1; end
if nargin < 3, n = 20; zlength = 1; end
if nargin < 2, l=1; n=20; zlength = 1; end
if nargin < 1, r = [1 1]'; l=1; n=20; zlength = 1; end

r = r(:); % Make sure r is a vector.
m = length(r); if m==1, r = [r;r]; m = 2; end
theta = (0:n)/n*2*pi;
sintheta = sin(theta); sintheta(n+1) = 0;

%
%First define the cylinder
%
  x = (r(1)+(0:zlength)*(r(2)-r(1))/zlength)' * cos(theta);
  y = (r(1)+(0:zlength)*(r(2)-r(1))/zlength)' * sintheta;
  z = (0:l/zlength:l)' * ones(1, n+1);


%
%Now close the cylinder
%
  phi = (0:n)/n*2*pi;
  x1 = []; y1 = []; z1 = [];
  x2 = []; y2 = []; z2 = [];
  
  if ~(r(1)==0)
    R = 0:r(1)/n:r(1);
    x1 = (R' * cos(phi));
    y1 = (R' * sin(phi));
    z1 = (zeros(n+1));
  end  

  if ~(r(2)==0)
    R = 0:r(2)/n:r(2);
    x2 = (R' * cos(phi));
    y2 = (R' * sin(phi));
    z2 = (zeros(n+1)+l);
  end  

  xx = [x1; x; x2];
  yy = [y1; y; y2];
  zz = [z1; z; z2];









%LinearAxis.m checks whether a certain vector has a constant directional coefficient
%output: 1=linear axis, 0=non-linear axis.
%23-03-'99

function ret = LinearAxis(Axis, Precision)

  if (nargin == 1)		%as diff is an approximation it is possible that even though an
    Precision = 1e-9;		%axis is linear elements are 1e-11. Therefore this precaution...
  end
  
  if (any(imag(Axis)))		%Axis is a complex vector for some fucked up reason
    ret = ~(any(abs(diff(real(Axis), 2)) > Precision));

  else  
    ret = ~(any(abs(diff(Axis, 2)) > Precision));
  end  









