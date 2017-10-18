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
% ====================================================================================
%
%
% About matNMR :
%
%
% MatNMR was first written as a routine for processing some data that had
% been corrupted during an NMR measurement. However, over time (as a sort
% of outlet for stress and boredom) I have added various functions that can be
% useful for an NMR spectroscopist.
% Now matNMR allows for 1D and 2D processing, peak fitting, T1 fitting and 
% making nice plots (with contours or sufaces or 3D stack plots). MatNMR 
% was never intended to and most likely probably never will compete with 
% commercially available NMR processing programs as they are more 
% specialized anyway. However it is much more flexible than those programs
% and new functions can be added very easily. Also, it is full integrated within
% the Matlab environment.
%
% matNMR fills a niche in the sense that it offers a high degree of
% flexibility in the processing of NMR data. This is because it uses 
% many of MATLAB's features directly but also allows the user to do so! 
%
% ---> so when matNMR asks for input ANY MATLAB statement can be given <---
% ---> as long as the resulting output is of the proper format !!      <---
%
% This gives many possibilities that commercial programs can never offer. 
% So when you want to solve a certain matter that cannot be performed with 
% commercial programs matNMR provides an easily extendable basis set of 
% NMR related functions.
%
% MatNMR basically is a collective of scripts (m-files) and some functions.
% All variables that are used are therefore visible in the MATLAB workspace.
% To prevent any problems with user-defined variables all variables in matNMR 
% start with a capital letter QmatNMR. Please be sure to remember this when you try 
% to save your workspace because else all your MATLAB files will become very large.
% Upon stopping matNMR all variables that were used by it will be removed
% allowing the user to save the workspace properly.
% Three scripts can be started independantly from the MATLAB prompt :
%
%    - nmr.m      = The main routine, everything can be done from here !!
%    - cont.m     = Contour routine
%    - mesher.m   = 3D Surface routine
%
% In general it is not necessary to close any of the windows when you want 
% to start another function. Open windows should never create conflicts.
%
% It is possible to stop any process while it is running by pressing
% <Control>-C. Then whatever is running is stopped and you regain control of
% the UI-controls. Press the "Reset-figure" button in the main window
% to restore the mouse pointer if it still looks like a clock.
%
%
% One last point ... You are free to use, alter and distribute all files that
% come with matNMR provided you do not remove my name or any of the other
% names from them. I would of course be very greatful for comments and new 
% or improved functions!
%
%
%
% Jacco van Beek
% jabe@users.sourceforge.net
% Copyright 1997-2006
%
