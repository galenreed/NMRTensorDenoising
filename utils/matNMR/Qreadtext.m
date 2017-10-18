function T=Qreadtext(File)
%Qreadtext Read a text file
%
%       T=Qreadtext(FileName)
%
% Reads a text file into a MATLAB String.
%

% Copyright (c) 1996 by Claudio Rivetti 
% claudio@alice.uoregon.edu
%
% Last version: June 23,  1996.

if nargin ~= 1
	error('wrong number of input arguments.');
end

[fp, msg]=fopen(File);
if fp==-1
	error(msg);
end

T=fread(fp, inf, 'char');
T=setstr(T');
fclose(fp);

return
