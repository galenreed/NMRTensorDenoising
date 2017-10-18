function hh = errorbarMatNMR(x, y, l,u,symbol)
%ERRORBAR Error bar plot.
%   ERRORBAR(X,Y,L,U) plots the graph of vector X vs. vector Y with
%   error bars specified by the vectors L and U.  L and U contain the
%   lower and upper error ranges for each point in Y.  Each error bar
%   is L(i) + U(i) long and is drawn a distance of U(i) above and L(i)
%   below the points in (X,Y).  The vectors X,Y,L and U must all be
%   the same length.  If X,Y,L and U are matrices then each column
%   produces a separate line.
%
%   ERRORBAR(X,Y,E) or ERRORBAR(Y,E) plots Y with error bars [Y-E Y+E].
%   ERRORBAR(...,'LineSpec') uses the color and linestyle specified by
%   the string 'LineSpec'.  See PLOT for possibilities.
%
%   H = ERRORBAR(...) returns a vector of line handles.
%
%   For example,
%      x = 1:10;
%      y = sin(x);
%      e = std(y)*ones(size(x));
%      errorbar(x,y,e)
%   draws symmetric error bars of unit standard deviation.

%   L. Shure 5-17-88, 10-1-91 B.A. Jones 4-5-93
%   Copyright 1984-2002 The MathWorks, Inc. 
%   $Revision: 5.19 $  $Date: 2002/06/05 20:05:14 $

%
%   Adapted for matNMR by Jacco van Beek
%   02-07-2004
%

if min(size(x))==1,
  npt = length(x);
  x = x(:);
  y = y(:);
    if nargin > 2,
        if ~isstr(l),  
            l = l(:);
        end
        if nargin > 3
            if ~isstr(u)
                u = u(:);
            end
        end
    end
else
  [npt,n] = size(x);
end

if nargin == 3
    if ~isstr(l)  
        u = l;
        symbol = '-';
    else
        symbol = l;
        l = y;
        u = y;
        y = x;
        [m,n] = size(y);
        x(:) = (1:npt)'*ones(1,n);;
    end
end

if nargin == 4
    if isstr(u),    
        symbol = u;
        u = l;
    else
        symbol = '-';
    end
end


if nargin == 2
    l = y;
    u = y;
    y = x;
    [m,n] = size(y);
    x(:) = (1:npt)'*ones(1,n);;
    symbol = '-';
end

u = abs(u);
l = abs(l);
    
if isstr(x) | isstr(y) | isstr(u) | isstr(l)
    error('Arguments must be numeric.')
end

if ~isequal(size(x),size(y)) | ~isequal(size(x),size(l)) | ~isequal(size(x),size(u)),
  error('The sizes of X, Y, L and U must be the same.');
end

%
%changed by Jacco van Beek
%if the length of the array is 1 then we try and detect what the current value is for
%the xlim property in the current axis
%
%if the hold status for the current axis is NOT replace then we assume that another
%line is already in the plot and we again use the xlim property
%
if (length(x) == 1)
  tee = get(gca, 'xlim');
  tee = (max(tee(:))-min(tee(:)))/50;  % make tee .04 x-distance for error bars
  
elseif ~strcmp(get(gca, 'nextplot'), 'replace')
  tee = get(gca, 'xlim');
  tee = (max(tee(:))-min(tee(:)))/50;  % make tee .04 x-distance for error bars

else
  tee = (max(x(:))-min(x(:)))/50;  % make tee .04 x-distance for error bars
end
xl = x - tee;
xr = x + tee;
ytop = y + u;
ybot = y - l;
%
%Added by Jacco van Beek
%
%The next few lines define the variables ybotTMP1 and ybotTMP2 and these are used to force
%the routine to draw the connecting line between the errorbars in multiple steps. This is done
%to ensure that when the user wants a logarithmic scale, the lines appear even if the coordinates
%are in reality negative. The horizontal lines of the errorbars may not be shown but at least 
%the connecting line is shown.
%
ybotTMP1 = y;
ybotTMP1(find( (ytop > 0) & (y < 1e-14) )) = 1e-14;

ybotTMP2 = ybot;
ybotTMP2(find( (ytop > 0) & (ybot < 1e-14) )) = 1e-14;

n = size(y,2);

% Plot graph and bars
hold_state = ishold;
cax = newplot;
next = lower(get(cax,'NextPlot'));

% build up nan-separated vector for bars
xb = zeros(npt*11,n);
xb(1:11:end,:) = x;
xb(2:11:end,:) = x;
xb(3:11:end,:) = x;
xb(4:11:end,:) = x;
xb(5:11:end,:) = NaN;
xb(6:11:end,:) = xl;
xb(7:11:end,:) = xr;
xb(8:11:end,:) = NaN;
xb(9:11:end,:) = xl;
xb(10:11:end,:) = xr;
xb(11:11:end,:) = NaN;

yb = zeros(npt*11,n);
yb(1:11:end,:) = ytop;
yb(2:11:end,:) = ybotTMP1;
yb(3:11:end,:) = ybotTMP2;
yb(4:11:end,:) = ybot;
yb(5:11:end,:) = NaN;
yb(6:11:end,:) = ytop;
yb(7:11:end,:) = ytop;
yb(8:11:end,:) = NaN;
yb(9:11:end,:) = ybot;
yb(10:11:end,:) = ybot;
yb(11:11:end,:) = NaN;

[ls,col,mark,msg] = colstyle(symbol); if ~isempty(msg), error(msg); end
symbol = [ls mark col]; % Use marker only on data part
esymbol = ['-' col]; % Make sure bars are solid

h = plot(xb,yb,esymbol); hold on
h = [h;plot(x,y,symbol)]; 

if ~hold_state, hold off; end

if nargout>0, hh = h; end
