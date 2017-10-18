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
%asklp1d.m handles linear prediction on 1D FID's both forward and backward !
%
%11-06-'98


try
  if (QmatNMR.FIDstatus == 1)
    beep
    disp('matNMR NOTICE: cannot perform linear prediction on frequency domain data. Refusing to act ...');
    return
  end

  QTEMP10 = QmatNMR.Size1D;
  if (QTEMP10 > 256)
    QTEMP10 = 256;
  end

  if (QmatNMR.LPtype == 1)
    QuiInput('Backward Prediction :', ' OK | CANCEL', 'regellp1d', [], ...
  	     'nr of points to predict backward :', QmatNMR.lpNrPoints, ...
  	     'nr of points to use for back prediction (>256 = slow!):', QTEMP10, ...
  	     'nr of frequencies :', QmatNMR.lpNrFreqs, ...
  	     'S/N ratio :', QmatNMR.lpSNratio);
  		
  elseif (QmatNMR.LPtype == 2)
    QuiInput('Backward Prediction :', ' OK | CANCEL', 'regellp1d', [], ...
  	     'nr of points to predict backward :', QmatNMR.lpNrPoints, ...
  	     'nr of points to use for back prediction (>256 = slow!):', QTEMP10, ...
  	     'nr of frequencies (-1: AIC, -2: MDL, >0: manual) :', QmatNMR.lpNrFreqs, ...
  	     'S/N ratio :', QmatNMR.lpSNratio);
  		
  elseif (QmatNMR.LPtype == 3)
    QuiInput('Forward Prediction :', ' OK | CANCEL', 'regellp1d', [], ...
  	     'nr of points to predict forward :', QmatNMR.lpNrPoints, ...
  	     'nr of points to use for forward prediction (>256 = slow!):', QTEMP10, ...
  	     'nr of frequencies :', QmatNMR.lpNrFreqs, ...
  	     'S/N ratio :', QmatNMR.lpSNratio);
  		
  else
    QuiInput('Forward Prediction :', ' OK | CANCEL', 'regellp1d', [], ...
  	     'nr of points to predict forward :', QmatNMR.lpNrPoints, ...
  	     'nr of points to use for forward prediction (>256 = slow!):', QTEMP10, ...
  	     'nr of frequencies (-1: AIC, -2: MDL, >0: manual) :', QmatNMR.lpNrFreqs, ...
  	     'S/N ratio :', QmatNMR.lpSNratio);
  end;		
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
