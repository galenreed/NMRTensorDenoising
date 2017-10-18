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
%SetDimensionSpecificParameters takes care of setting dimension-specific parameters
%when executing macro's. This is necessary to avoid problems with default axes.
%
%05-03-'04

try
  %
  %QmatNMR.DimensionParams contains all the dimension-specific information and is passed through by RunMacro
  %
  if (QmatNMR.DimensionParams(2) == 0) 		%the next step in the macro specifies a 1D mode. In case we
  				%are coming from a 2D mode we need to set some variables first
    SwitchTo1D
  end
  
  QmatNMR.Dim = QmatNMR.DimensionParams(2);
  switch QmatNMR.Dim		%for which dimension is this data valid?
    case 0	%data for 1D
      %
      %first set the 2D parameters
      %
      QmatNMR.SW1D 		= QmatNMR.DimensionParams(3);
      QmatNMR.SF1D 		= QmatNMR.DimensionParams(4);
      QmatNMR.gamma1d 		= QmatNMR.DimensionParams(5);
      QmatNMR.FIDstatus 		= QmatNMR.DimensionParams(6);
      QmatNMR.RulerXAxis 		= QmatNMR.DimensionParams(7);
      QmatNMRsettings.DefaultRulerXAxis1TIME = QmatNMR.DimensionParams(8);
      QmatNMRsettings.DefaultRulerXAxis1FREQ = QmatNMR.DimensionParams(9);
      QmatNMR.four2 		= QmatNMR.DimensionParams(10);
      
    case 1	%data for TD2
      %
      %first set the 2D parameters
      %
      QmatNMR.Size1D 		= QmatNMR.SizeTD2;
      QmatNMR.SWTD2 		= QmatNMR.DimensionParams(3);
      QmatNMR.SFTD2 		= QmatNMR.DimensionParams(4);
      QmatNMR.gamma1 		= QmatNMR.DimensionParams(5);
      QmatNMR.FIDstatus2D1 	= QmatNMR.DimensionParams(6);
      QmatNMR.RulerXAxis1 	= QmatNMR.DimensionParams(7);
      QmatNMRsettings.DefaultRulerXAxis1TIME = QmatNMR.DimensionParams(8);
      QmatNMRsettings.DefaultRulerXAxis1FREQ = QmatNMR.DimensionParams(9);
      QmatNMR.rijnr 		= QmatNMR.DimensionParams(10);
      QmatNMR.four2 		= QmatNMR.DimensionParams(11);
  
      %
      %Then update the corresponding 1D parameters, after which the default axes can be determined
      %
      QmatNMR.SW1D 		= QmatNMR.SWTD2;
      QmatNMR.SF1D 		= QmatNMR.SFTD2;
      QmatNMR.gamma1d 		= QmatNMR.gamma1;
      QmatNMR.FIDstatus 		= QmatNMR.FIDstatus2D1;
      QmatNMR.RulerXAxis 		= QmatNMR.RulerXAxis1;
      
      
    case 2 	%data for TD1
      %
      %first set the 2D parameters
      %
      QmatNMR.Size1D 		= QmatNMR.SizeTD1;
      QmatNMR.SWTD1 		= QmatNMR.DimensionParams(3);
      QmatNMR.SFTD1 		= QmatNMR.DimensionParams(4);
      QmatNMR.gamma2 		= QmatNMR.DimensionParams(5);
      QmatNMR.FIDstatus2D2 	= QmatNMR.DimensionParams(6);
      QmatNMR.RulerXAxis2 	= QmatNMR.DimensionParams(7);
      QmatNMRsettings.DefaultRulerXAxis2TIME = QmatNMR.DimensionParams(8);
      QmatNMRsettings.DefaultRulerXAxis2FREQ = QmatNMR.DimensionParams(9);
      QmatNMR.kolomnr 		= QmatNMR.DimensionParams(10);
      QmatNMR.four1 		= QmatNMR.DimensionParams(11);
  
      %
      %Then update the corresponding 1D parameters, after which the default axes can be determined
      %
      QmatNMR.SW1D 		= QmatNMR.SWTD1;
      QmatNMR.SF1D 		= QmatNMR.SFTD1;
      QmatNMR.gamma1d 		= QmatNMR.gamma2;
      QmatNMR.FIDstatus 		= QmatNMR.FIDstatus2D2;
      QmatNMR.RulerXAxis 		= QmatNMR.RulerXAxis2;
    
    otherwise
      error('matNMR ERROR: wrong dimension code for "SetDimensionSpecificParameters". Please check!');
  end
  
  
  %
  %set the buttons in the main window according to the values, unless we're processing a macro
  %
  if (~QmatNMR.BusyWithMacro)
    updatebuttons
  end
  
  
  %
  %create the default axis for the current dimension, if the flag is such
  %
  if (QmatNMR.RulerXAxis == 0)
    GetDefaultAxis
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
