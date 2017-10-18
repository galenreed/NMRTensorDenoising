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
%drawalllabels.m redraws the peak list connected to the current spectrum variable
%05-10-'00

try
  %get the name of the spectrum from the userdata
  QTEMP9 = get(QmatNMR.Fig2D3D, 'userdata'); 
  [QmatNMR.SpecName2D3D, QmatNMR.CheckInput] = checkinput(QTEMP9.PlotParams(QmatNMR.AxisNR2D3D).Name); 
  
  %check whether this is a spectrum that was cut
  QmatNMR.NewAxisTD2 = QTEMP9.PlotParams(QmatNMR.AxisNR2D3D).AnalyserAxisTD2;
  QmatNMR.NewAxisTD1 = QTEMP9.PlotParams(QmatNMR.AxisNR2D3D).AnalyserAxisTD1;
  QTEMP2 = QTEMP9.PlotParams(QmatNMR.AxisNR2D3D).AxisProps;
  if QTEMP2(1)	%linear axis in TD2 -> use axis increment and offset
    QTEMP3 = (1:QTEMP9.PlotParams(QmatNMR.AxisNR2D3D).SizeTD2)*QTEMP2(1) + QTEMP2(2);
  
  else		%nin-linear axis -> extract from the userdata directly
    QTEMP3 = QTEMP9.PlotParams(QmatNMR.AxisNR2D3D).AxisTD2;
  end  
  
  if QTEMP2(3)	%linear axis in TD1 -> use axis increment and offset
    QTEMP4 = (1:QTEMP9.PlotParams(QmatNMR.AxisNR2D3D).SizeTD1)*QTEMP2(3) + QTEMP2(4);
  
  else		%nin-linear axis -> extract from the userdata directly
    QTEMP4 = QTEMP9.PlotParams(QmatNMR.AxisNR2D3D).AxisTD1;
  end  
  %set the cutspectrum flag when the axes are not equal
  QmatNMR.FlagCutSpectrum = ~ all((QTEMP3 == QmatNMR.NewAxisTD2) & (QTEMP4 == QmatNMR.NewAxisTD1));
  
  
  %restore peak list
  restorepeaklist
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
