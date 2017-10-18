function str2val(obj, mn, mx, type, prec)
%STR2VAL Set the value of an edit uicontrol to its string value.
%
%      STR2VAL(H, MIN, MAX, TYPE)
%
%   The value displayed as a string in the uicontrol H
%   is converted to a number, restricted to the range
%   MIN MAX and set into the 'value' H parameter.
%   TYPE define the type of number: INT or FLOAT.
%
%   This function is used in the EDITNUM function
%
%   Claudio June 8,  1996.

% This function can be modified with the only restriction that the
% next two lines have to be reteined.
%                 Copyright (c) 1995 by Claudio Rivetti
%                       claudio@alice.uoregon.edu
%

%
% Adapted for matNMR by Jacco van Beek
% April 7, 1997.
%

if nargin < 1, error('Too few input arguments');end
if nargin > 5, error('Too many input arguments');end

if nargin == 1
  mn=-inf;
  mx=inf;
  type='FLOAT';
end

if nargin == 2
  mx=inf;
  type='FLOAT';
end

if nargin == 3
  type='FLOAT';
end

if nargin < 5
  prec = 0;
end
  
value=str2num(get(obj, 'string'));

if isempty(value)
  value = 0;
end

value=max(value, mn);
value=min(value,mx);

if strcmp(upper(type), 'INT')
  str=int2str(value);
else
  if prec == 0
    str=num2str(value);
  else
    str=num2str(value, prec);
  end
end  

set(obj, 'string', str, 'value', value);


return
