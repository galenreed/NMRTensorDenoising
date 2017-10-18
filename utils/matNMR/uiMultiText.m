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
function z = uiMultiText(x, y, z, q1,q2,q3,q4,q5,q6,q7,q8,q9,q10,q11,q12,q13,q14,q15,q16,q17,q18,q19,q20,q21,q22,q23,q24)

%uiMultiText Add multi-line text to the current plot.
%
% t = uiMultiText(x, y, 'string')
%    This is just like the call text(x,y,'string'), except that the
%    text string may contain newlines (character value 10) to cause
%    multiple text objects to display on successive lines.  The text
%    objects are returned.
%
%    If the string starts with '-', it is displayed with the bottom line
%    (instead of the usual top line) at the location specified.
%
% t = uiMultiText(x, y, z, 'string')
%    Use this form for three-dimensional plots.
%
% t = uiMultiText(x, y, [z,] 'string', spacing)
%    As above, but display successive lines at the given spacing instead
%    of the default, which is calculated from the font size.  This spacing
%    is measured in pixels, not native (axes) units.  As a special case,
%    if  -10 < spacing <= 0,  it is used as an increment added to the default.
%
% t = uiMultiText(...args..., 'FontName', 'Times', 'Units', 'pixels', ...)
%    The arguments described above may be followed by name/value pairs
%    to set FontName, FontSize, Units, VerticalAlignment, and so on
%    for the text string.  Do 'get(text)' to see them all.  Setting the
%    'Position' argument this way does NOT work; you must use x and y.
%
% Written by Dave Mellinger, dkm1@cornell.edu .  This version 1/28/94.

global QmatNMR

sep = 10;			% separator charater for successive lines
if (isstr(z)),
  dims = 2;
  str = z;
else
  dims = 3;
  str = q1;
end
arg = dims - 1;			% number of first q arg to use
spacing = 0;
if (nargin-dims > 1), if (~isstr(eval(['q',num2str(arg)]))), 
  spacing = eval(['q',num2str(arg)]); 
  arg = arg + 1;
end; end

sgn = -1;
if str(1) == '-'
  str = str(2:length(str));
  sgn = 1;
end

div = [0, find([str,sep] == sep)];
idx = 1 : length(div)-1;
if (sgn > 0), idx = fliplr(idx); end

z = [];
offset = 0;
for Qi = idx
  s = str(div(Qi)+1 : div(Qi+1)-1);		% needed for MATLAB crash bug

  if (length(s))
    t = text('String', s);
  else
    t = text('String','');
  end

  z = [z, t];
  for j = arg:2:nargin-4	% do before getting extent or setting position
    eval(sprintf('set(t, q%d, q%d);', j, j+1));
  end
  if (dims == 2), set(t, 'Position', [x y]);
  else set(t, 'Position', [x y z]);
  end

  unitsSave = get(t, 'Units'); set(t,'Units', 'pixels')
  if (Qi == idx(1) & spacing <= 0 & spacing > -10)
    ext = get(z(1),'Extent');
    spacing = spacing + ext(4);
  end
  pos = get(t, 'position');
  set(t, 'Position', [pos(1) pos(2)+offset pos(3:length(pos))]);

  set(t,'Units',unitsSave);
  offset = offset + spacing * sgn;
end

if (sgn > 0), z = fliplr(z); end
