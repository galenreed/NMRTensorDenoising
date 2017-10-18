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
%FIDstatus.m gives the possibility for the user to declare a certain spectrum as an FID
%That way the time scale is plotted properly (from left to right)
%10-12-'97

try
  QmatNMR.FIDstatus = get(QmatNMR.FID, 'value');
  regeldisplaymode
  
  if (QmatNMR.Dim == 1)				%set parameters for a 2D.
    QmatNMR.FIDstatus2D1 = QmatNMR.FIDstatus;
    
  elseif (QmatNMR.Dim == 2)
    QmatNMR.FIDstatus2D2 = QmatNMR.FIDstatus;
  end
  
  %
  %if the current axis is the default axis then we select the default axis
  %
  if (QmatNMR.RulerXAxis == 0)
    asaanpas
    
  else
    QmatNMR.TEMPRincr = QmatNMR.Rincr;			%needed to determine whether the axis direction has changed sign
    detaxisprops
    Qspcrel
    CheckAxis				%Check whether the new axis is descending or ascending
    if (QmatNMR.nrspc > 1)
    	%With dual plots it is important to determine whether the slope of the new axis has
    	%the same sign as the previous axis. If the slope has changed sign all spectra need
    	%to be flipped from left to right and this is only possible for the original spectrum
    	%(in principal also for the last added multiple spectrum but I don't want to make it
    	%too complicated). The plot will be reset then and all multiple spectra are removed
    	%If the slope has the same sign only the axis property will be changed for all handles.
    	%
    	%17-05-'00: When doing a dual plot now an axis can be supplied with the new trace. This
    	%means the length of the new trace may be different from the length of the old trace.
    	%Also the axis may just be different. If this is the case then an asaanpas will be done.
    	%I don't want to make an incredibly difficult routine out of this.
    	%
      QTEMP4 = findobj(findobj(allchild(QmatNMR.Fig), 'type', 'axes', 'tag', 'MainAxis'), 'type', 'line');
      for QTEMP5=1:QmatNMR.nrspc-1
        %now we check whether all curves have equal lengths
        if (length(get(QTEMP4(QTEMP5), 'xdata')) == length(get(QTEMP4(QTEMP5+1), 'xdata')))
          QTEMP6 = sum(find(get(QTEMP4(QTEMP5), 'xdata') == get(QTEMP4(QTEMP5+1), 'xdata') == 0));
        else
          QTEMP6 = 1;
        end
            
        if (QTEMP6)	%not all axes are equal --> do an asaanpas
          break
        end
      end
      
      if (QTEMP6)		%different lengths ...
        asaanpas
        
      elseif (sign(QmatNMR.TEMPRincr) == sign(QmatNMR.Rincr))
        set(QTEMP4, 'xdata', QmatNMR.Axis1DPlot);
        set(findobj(allchild(QmatNMR.Fig), 'type', 'axes', 'tag', 'MainAxis'), 'xdir', QmatNMR.AxisPlotDirection);
      
      else
        asaanpas;
      end  
      
    else  
      set(findobj(findobj(allchild(QmatNMR.Fig), 'type', 'axes', 'tag', 'MainAxis'), 'type', 'line'), ...
    		'xdata', QmatNMR.Axis1DPlot, 'ydata', QmatNMR.Spec1DPlot);
      set(findobj(allchild(QmatNMR.Fig), 'type', 'axes', 'tag', 'MainAxis'), 'xdir', QmatNMR.AxisPlotDirection);
    end
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
