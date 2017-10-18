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
%defineplotlimits.m: if an area in the contour plot is zoomed into, then this routine makes
%certain that for the next plot the plot range is taken to be this area
%
%05-01-'00

try
  if (QmatNMR.buttonList == 1)
    QmatNMR.CutSaveVariable = QmatNMR.uiInput1;
  
  
    %
    %Define the plot limits and cut the spectrum accordingly
    %
    [QmatNMR.Q1, QmatNMR.Q2] = size(QmatNMR.Spec2D3D);
    
    if (QmatNMR.Q1 == 0)					%if there is no current spectrum in the contour routine take
      QmatNMR.SpecName2D3D = 'matNMR';				%the default name
      
    elseif (QmatNMR.aswaarden == [1 QmatNMR.Q2 1 QmatNMR.Q1])		%if the current spectrum in the contour routine is plotted with an axis in points
      QmatNMR.SpecName2D3D = 'QmatNMR.Spec2D3D';				%and the spectrum is not zoomed into then take these values into the mesh routine.
    
    else
    	%first determine the real area in points (the actual scale of the axis might also be in Hz or something else)
    
    	%
    	%get the axis properties
    	%
      QTEMP = get(QmatNMR.Fig2D3D, 'userdata');
      QTEMP1 = QTEMP.PlotParams(QmatNMR.AxisNR2D3D).AxisProps;
    
    	%
    	%first for TD2
    	%
      QmatNMR.Cincr1 = QTEMP1(1);				%the following are some variables to be able to get the coordinates
      QmatNMR.Cnull1 = QTEMP1(2);				%to use in the stack plot, even when an axis is defined
    						%in something else than points ! This only works for
    						%linear increments of course !!
      QmatNMR.Tnum1 = ceil( abs((QmatNMR.aswaarden(2)-QmatNMR.aswaarden(1)) / QmatNMR.Cincr1)  );
      if (QmatNMR.Cincr1>0)
        QmatNMR.Tnum2 = floor( (QmatNMR.aswaarden(1) - QmatNMR.Cnull1) / QmatNMR.Cincr1 );
        
      else
        QmatNMR.Tnum2 = floor( (QmatNMR.aswaarden(2) - QmatNMR.Cnull1) / QmatNMR.Cincr1 );
      end  
    
    						%Now check whether the determined values are within
        						%bounds (so not longer than the original QmatNMR.Axis2D3DTD2)
      if (QmatNMR.Tnum2 < 1)
        QmatNMR.Tnum2 = 1;
      end
      
      if ((QmatNMR.Tnum2+QmatNMR.Tnum1) > QTEMP.PlotParams(QmatNMR.AxisNR2D3D).SizeTD2)
        QmatNMR.Tnum1 = QTEMP.PlotParams(QmatNMR.AxisNR2D3D).SizeTD2 - QmatNMR.Tnum2;
      end
    
    
    	%
    	%then for Qcontvec2
    	%
      QmatNMR.Cincr2 = QTEMP1(3);				%the following are some variables to be able to get the coordinates
      QmatNMR.Cnull2 = QTEMP1(4);				%to use in the stack plot, even when an axis is defined
    						%in something else than points ! This only works for
    						%linear increments of course !!
      QmatNMR.Tnum3 = ceil ( abs((QmatNMR.aswaarden(4) - QmatNMR.aswaarden(3)) / QmatNMR.Cincr2)  );
      if (QmatNMR.Cincr2>0)
        QmatNMR.Tnum4 = floor( (QmatNMR.aswaarden(3) - QmatNMR.Cnull2) / QmatNMR.Cincr2 );
      
      else
        QmatNMR.Tnum4 = floor( (QmatNMR.aswaarden(4) - QmatNMR.Cnull2) / QmatNMR.Cincr2 );
      end  
    
    						%Now check whether the determined values are within
        						%bounds (so not longer than the original QmatNMR.Axis2D3DTD1)
      if (QmatNMR.Tnum4 < 1)
        QmatNMR.Tnum4 = 1;
      end
    
      if ((QmatNMR.Tnum3+QmatNMR.Tnum4) > QTEMP.PlotParams(QmatNMR.AxisNR2D3D).SizeTD1)
        QmatNMR.Tnum3 = QTEMP.PlotParams(QmatNMR.AxisNR2D3D).SizeTD1 - QmatNMR.Tnum4;
      end
      
    
      %
      %now define a new variable that contains the zoomed-in spectrum and the corresponding axis
      %
      QmatNMR.Spec2D3DDefinePlot = GenerateMatNMRStructure;
      eval(['QmatNMR.Spec2D3DDefinePlot.Spectrum = QmatNMR.Spec2D3D(' num2str(QmatNMR.Tnum4) ':' num2str(QmatNMR.Tnum3+QmatNMR.Tnum4) ',' num2str(QmatNMR.Tnum2) ':' num2str(QmatNMR.Tnum1+QmatNMR.Tnum2) ');']);
      QmatNMR.Spec2D3DDefinePlot.AxisTD2 = (QmatNMR.Cnull1 + QmatNMR.Cincr1*QmatNMR.Tnum2):QmatNMR.Cincr1:(QmatNMR.Cnull1 + QmatNMR.Cincr1*(QmatNMR.Tnum1+QmatNMR.Tnum2));
      QmatNMR.Spec2D3DDefinePlot.AxisTD1 = (QmatNMR.Cnull2 + QmatNMR.Cincr2*QmatNMR.Tnum4):QmatNMR.Cincr2:(QmatNMR.Cnull2 + QmatNMR.Cincr2*(QmatNMR.Tnum3+QmatNMR.Tnum4));
      QmatNMR.Spec2D3DDefinePlot.FIDstatusTD2 = 1;	%assume data is a spectrum
      QmatNMR.Spec2D3DDefinePlot.FIDstatusTD1 = 1;	%assume data is a spectrum
      
                                                 %Now define the axes and spectral area to be loaded in mesher.m
      QmatNMR.SpecName2D3D = 'QmatNMR.Spec2D3DDefinePlot';
      QmatNMR.UserDefAxisT2Cont = '';
      QmatNMR.UserDefAxisT1Cont = '';
      
      
      %
      %Save the strip plot in the workspace if asked for
      %
      if ~isempty(QmatNMR.CutSaveVariable)
        try
          eval([QmatNMR.CutSaveVariable ' = QmatNMR.Spec2D3DDefinePlot;']);
  
        catch
          beep
          disp(['matNMR WARNING: could not store the defined plot as "' QmatNMR.CutSaveVariable '" in the workspace. Please make sure the variable name is allowed.']);
        end
      end
    
     
      %
      %switch figure if necessary only because this will cause an additional rendering step
      %
      if (gcf ~= QmatNMR.Fig2D3D)
        figure(QmatNMR.Fig2D3D);
      end
      disp('Define Plot finished: current zoom limits will be taken for the next plot when using the variable "QmatNMR.Spec2D3DDefinePlot".');
    end
  
  else
    disp('Defining plot limits cancelled ...');
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
