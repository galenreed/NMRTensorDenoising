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
%switch2Daid
%
%switches between on and off for the 2D phasing aid
%
%02-08-'05

try
  if get(QmatNMR.p31, 'value')
    %
    %the 2D phasing aid should be switched on. Let's check whether we're in 2D mode first
    %
    if (QmatNMR.Dim == 0) 	%1D mode --> switch off the 2D phasing aid
      %disp('matNMR NOTICE: 2D phasing aid is not available in 1D mode!');
      set(QmatNMR.p31, 'value', 0)
      set([QmatNMR.p32, QmatNMR.p33 QmatNMR.p34 QmatNMR.p35 QmatNMR.p36 QmatNMR.p37 QmatNMR.p38], 'visible', 'off');
      if (QmatNMR.phasing == 1)
        set([QmatNMR.p6], 'visible', 'on');
      end
      set([QmatNMR.p33 QmatNMR.p34 QmatNMR.p36 QmatNMR.p37], 'string', '');
      delete(findobj(allchild(QmatNMR.Fig), 'tag', '2DPhasingAidAxis1'));
      delete(findobj(allchild(QmatNMR.Fig), 'tag', '2DPhasingAidAxis2'));
  
    else 			%2D mode
      set(QmatNMR.p31, 'value', 1)
      set([QmatNMR.p32, QmatNMR.p33 QmatNMR.p34 QmatNMR.p35 QmatNMR.p36 QmatNMR.p37 QmatNMR.p38], 'visible', 'on');
      set([QmatNMR.p33 QmatNMR.p34 QmatNMR.p36 QmatNMR.p37], 'string', '');
      set([QmatNMR.p6], 'visible', 'off');
      delete(findobj(allchild(QmatNMR.Fig), 'tag', '2DPhasingAidIndex1'));
      delete(findobj(allchild(QmatNMR.Fig), 'tag', '2DPhasingAidIndex2'));
      delete(findobj(allchild(QmatNMR.Fig), 'tag', '2DPhasingAidIndex3'));
      delete(findobj(allchild(QmatNMR.Fig), 'tag', '2DPhasingAidIndex4'));
      delete(findobj(allchild(QmatNMR.Fig), 'tag', '2DPhasingAidIndex1text'));
      delete(findobj(allchild(QmatNMR.Fig), 'tag', '2DPhasingAidIndex2text'));
      delete(findobj(allchild(QmatNMR.Fig), 'tag', '2DPhasingAidIndex3text'));
      delete(findobj(allchild(QmatNMR.Fig), 'tag', '2DPhasingAidIndex4text'));
    end
  
  else
    set(QmatNMR.p31, 'value', 0)
    set([QmatNMR.p32, QmatNMR.p33 QmatNMR.p34 QmatNMR.p35 QmatNMR.p36 QmatNMR.p37 QmatNMR.p38], 'visible', 'off');
    if (QmatNMR.phasing == 1)
      set([QmatNMR.p6], 'visible', 'on');
    end
    set([QmatNMR.p33 QmatNMR.p34 QmatNMR.p36 QmatNMR.p37], 'string', '');
    delete(findobj(allchild(QmatNMR.Fig), 'tag', '2DPhasingAidAxis1'));
    delete(findobj(allchild(QmatNMR.Fig), 'tag', '2DPhasingAidAxis2'));
  end

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
