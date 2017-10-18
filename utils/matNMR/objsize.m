function ext = objsize(ObjType,NumChars,NumLines)
%OBJSIZE Calculate appropriate UIControl size
%OBJSIZE(ObjType,NumChars,NumLines)
%OBJSIZE calculates the appropriate size for 
%UIControls on the platform being used; standard
%spacing is different for Macintosh and PC's as 
%opposed to UNIX machines.  This helps generate
%pleasing GUI's on whichever platform.

%Copyright (c) 1995 by Keith Rogers

if(nargin < 3)
	NumLines = 1;
end
ext = zeros(1,2);
if(strcmp(computer,'MAC2') | strcmp(computer,'PCWIN'))
	if(strcmp(ObjType,'uitext'))
		ext(1) = 10*NumChars+7;
		ext(2) = 13*NumLines - 1;
	elseif(strcmp(ObjType,'edit'))
		ext(1) = 10*NumChars+1;
		ext(2) = 14*NumLines + 4;
	elseif(strcmp(ObjType,'pushbutton'))
		ext(1) = 10*NumChars+6;
		ext(2) = 18;
	elseif(strcmp(ObjType,'popupmenu'))
		ext(1) = 10*NumChars+36;
		ext(2) = 18;
	elseif(strcmp(ObjType,'checkbox') | strcmp(ObjType,'radio'))
		ext(1) = 10*NumChars+17;
		ext(2) = 12;
	end
else
	if(strcmp(ObjType,'uitext'))
		ext(1) = 5*NumChars+3;
		ext(2) = 12*NumLines+2;
	elseif(strcmp(ObjType,'edit'))
		ext(1) = 5*NumChars+4;
		ext(2) = 12*NumLines + 2;
	elseif(strcmp(ObjType,'pushbutton'))
		ext(1) = 6*NumChars+1;
		ext(2) = 14;
	elseif(strcmp(ObjType,'popupmenu'))
		ext(1) = 6*NumChars+18;
		ext(2) = 14;
	elseif(strcmp(ObjType,'checkbox') | strcmp(ObjType,'radio'))
		ext(1) = 6*NumChars+16;
		ext(2) = 14;
	end
end
