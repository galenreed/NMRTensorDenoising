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
%definecutspectrum.m asks the user to mark all peaks in the current 2D spectrum for making a cut spectrum
%04-07-2007

try
  disp('matNMR Notice: Please define all peak areas by clicking on the mouse button on the left and right of it');
  disp('matNMR Notice: by clicking outside the axis the function stops and you can continue');
  disp('matNMR Notice: If no peak areas are defined then the entire spectrum is predicted.');
  
  %
  %switch figure if necessary only because this will cause an additional rendering step
  %
  if (gcf ~= QmatNMR.Fig2D3D)
    figure(QmatNMR.Fig2D3D);
  end
  
  
  %
  %ask for peaks
  %
  QmatNMR.Error = 0;
  QmatNMR.ButSoort = 1;
  QmatNMR.CutRangeTD2 = [];
  QmatNMR.CutRangeTD1 = [];
  
  QTEMP22 = get(gca, 'nextplot');
  
  while ((~QmatNMR.Error) & (QmatNMR.ButSoort == 1))
    [QmatNMR.xpos, QmatNMR.ypos, QmatNMR.ButSoort] = ginput(1);
    QmatNMR.Error = pk_inbds(QmatNMR.xpos, QmatNMR.ypos);		%See whether button was pushed inside the axis !
  
    if ((~ QmatNMR.Error) & (QmatNMR.ButSoort == 1)) 
      hold on
      QmatNMR.PlotHandle = plot([QmatNMR.xpos QmatNMR.xpos], QmatNMR.Axis2D3DTD1([1 end]), 'r--');
      set(QmatNMR.PlotHandle, 'tag', 'CutSpectrumPeaks');
  
      QmatNMR.PlotHandle = plot(QmatNMR.Axis2D3DTD2([1 end]), [QmatNMR.ypos QmatNMR.ypos], 'r--');
      set(QmatNMR.PlotHandle, 'tag', 'CutSpectrumPeaks');
      set(gca, 'nextplot', QTEMP22);
      
      %
      %add coodinates to vectors
      %
      QmatNMR.CutRangeTD2 = [QmatNMR.CutRangeTD2 QmatNMR.xpos];
      QmatNMR.CutRangeTD1 = [QmatNMR.CutRangeTD1 QmatNMR.ypos];
  
    else
  
      delete(findobj(allchild(gcf), 'tag', 'CutSpectrumPeaks'))
    end  
  end
  
  clear QTEMP*
  
  
  %
  %finish off by opening an input window
  %
  QmatNMR.CutRangeTD2 = sort(QmatNMR.CutRangeTD2);
  QmatNMR.CutRangeTD1 = sort(QmatNMR.CutRangeTD1);
  QmatNMR.CutTicksTD2 = [];
  QmatNMR.CutTicksTD1 = [];
  askcutspectrum

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
