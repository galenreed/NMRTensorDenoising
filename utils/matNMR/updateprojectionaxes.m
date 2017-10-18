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
% updateprojectionaxes updates the position of projection axes and their axis limits, based on the
% regular axis they belong to
% 20-04-'07


try
  QmatNMR.TargetAxis = gca; 			%current axis
  
  %
  %update projection axes to the new axis limits, if they exist
  %
  QTEMP2 = findobj(allchild(QmatNMR.Fig2D3D), 'tag', 'Projection');
  
  if ~isempty(QTEMP2)
    %use the position of the regular axis to update the position of the projection axes
    QTEMP4 = get(QmatNMR.Fig2D3D, 'userdata');
    QTEMP4 = get(QTEMP4.AxesHandles, 'position');
    for QTEMP10=1:length(QTEMP2)
      QTEMP3 = getappdata(QTEMP2(QTEMP10), 'ProjectionDirection');
      if (QTEMP3 == 1)           %the projection on TD2
        %activate the axis
        axes(QTEMP2(QTEMP10))
  
        %update the axis position
        QTEMP5 = get(QTEMP2(QTEMP10), 'position');
        set(QTEMP2(QTEMP10), 'position', [QTEMP4(1) QTEMP5(2) QTEMP4(3) QTEMP5(4)]);
  
        %update the axis limits
        axis tight
        QTEMP5 = axis;
        axis([QmatNMR.aswaarden(1:2) (QTEMP5(3)-0.05*(QTEMP5(4)-QTEMP5(3))) (QTEMP5(4)+0.05*(QTEMP5(4)-QTEMP5(3)))]);
  
      elseif (QTEMP3 == 2)      %the projection on TD1
        %activate the axis
        axes(QTEMP2(QTEMP10))
  
        %update the axis position
        QTEMP5 = get(QTEMP2(QTEMP10), 'position');
        set(QTEMP2(QTEMP10), 'position', [QTEMP5(1) QTEMP4(2) QTEMP5(3) QTEMP4(4)]);
  
        %update the axis limits
        axis tight
        QTEMP5 = axis;
        axis([(QTEMP5(1)-0.05*(QTEMP5(2)-QTEMP5(1))) (QTEMP5(2)+0.05*(QTEMP5(2)-QTEMP5(1))) QmatNMR.aswaarden(3:4)]);
      end
    end
  
    %axes(QmatNMR.TargetAxis)
    set(QmatNMR.Fig2D3D, 'currentaxes', QmatNMR.TargetAxis);
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
