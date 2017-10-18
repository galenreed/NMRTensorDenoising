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
% pickslices2Daid provides a GUI to picking slices for the 2D phasing aid, by using a crosshair
%
% 03-08-2005
%

try
  QmatNMR.Error = 0;
  QmatNMR.ButSoort = 1;
  QmatNMR.PiekTeller = 0;
  QTEMP = zeros(1, 2);
  while ((~QmatNMR.Error) & (QmatNMR.ButSoort == 1) & (QmatNMR.PiekTeller < 2))
    [QmatNMR.xpos, QmatNMR.ypos, QmatNMR.ButSoort] = ginput(1);
    QmatNMR.Error = pk_inbds(QmatNMR.xpos, QmatNMR.ypos);		%See whether button was pushed inside the axis !
    QmatNMR.PiekTeller = QmatNMR.PiekTeller + 1;
  
    QTEMP(QmatNMR.PiekTeller) = round( (QmatNMR.xpos-QmatNMR.Rnull)/QmatNMR.Rincr );%Check whether the point is not outside the vectors
    if (QTEMP(QmatNMR.PiekTeller) < 1)			%actual length....
      QTEMP(QmatNMR.PiekTeller) = 1;
    end
    if (QTEMP(QmatNMR.PiekTeller) > QmatNMR.Size1D)
      QTEMP(QmatNMR.PiekTeller) = QmatNMR.Size1D;
    end
  
    if ((~ QmatNMR.Error) & (QmatNMR.ButSoort == 1)) 
      if (QmatNMR.Dim == 1)
        if (QmatNMR.PiekTeller == 1)
          set(QmatNMR.p36, 'string', num2str(QTEMP(QmatNMR.PiekTeller)));
  
        else
          set(QmatNMR.p37, 'string', num2str(QTEMP(QmatNMR.PiekTeller)));
        end
  
      else
        if (QmatNMR.PiekTeller == 1)
          set(QmatNMR.p33, 'string', num2str(QTEMP(QmatNMR.PiekTeller)));
  
        else
          set(QmatNMR.p34, 'string', num2str(QTEMP(QmatNMR.PiekTeller)));
        end
      end
    else
      return
    end
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
