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
%regelRI.m takes care of displaying the real, imaginary or absolute part of a FID/spectrum.

try
  watch;
  
  repairapodize;				%when busy with apodizing, first remove this function. The
  					%simpelplot.m will put it back again.
  
  regeldisplaymode
  switch (QmatNMR.DisplayMode)
    case 1      %Real spectrum
      disp('Display mode set to real');
    
    case 2      %Imaginary spectrum
      disp('Display mode set to imaginary');
  
    case 3      %Both Real and Imaginary spectrum together
      disp('Display mode set to both');
  
    case 4      %Absolute spectrum
      disp('Display mode set to absolute');
  
    case 5      %Power spectrum
      disp('Display mode set to power spectrum');
  
    otherwise
      disp('matNMR ERROR: unknown value for QDisplayMode!');
      disp('matNMR ERROR: Abort ...');
      return
  end	 
  
  
  %
  %Now update the screen. Only for non-default plot types and the display mode 'both' do we use asaanpas 
  %else we use simpelplot
  %
  if ((QmatNMR.PlotType == 1) & (QmatNMR.DisplayMode ~= 3) & (QmatNMR.DisplayModeOLD ~= 3))	%if the plot type is non-default OR the new OR the previous display mode was "both" then do asaanpas!
    Qspcrel
    CheckAxis;				%checks whether the axis is ascending or descending and adjusts the
  					%plot direction if necessary
    set(gca, 'xtickmode', 'auto');
    simpelplot;
    
  else
    %
    %If the plot type was anything but the default (=1) then we do a reset figure
    %
    %Alternatively the 'both' option requires a special treatment since it is sort of a strange plot.
    %The axis is set to points temporarily because else it cannot be plotted (at least
    %not without going into strange bends)
    %
    asaanpas;
  end
  
  Arrowhead;

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
