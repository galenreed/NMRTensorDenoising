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
%UpdateFigure updates all UI controls and variables when switching between 2D/3D viewer windows.
%
%12-07-'04

try
  figure(QmatNMR.Q2DButtonPanel);
  figure(QmatNMR.Fig2D3D);
  
  QTEMP1 = get(QmatNMR.Fig2D3D, 'userdata');
  QmatNMR.ContColorbarIndicator = QTEMP1.ColorBarIndicator;
  QmatNMR.contcolorbar = QTEMP1.ColorBarHandles;
  QmatNMR.ContNrSubplots = QTEMP1.NrAxes;
  QmatNMR.ContSubplots = QTEMP1.SubPlots;
  
  %
  %If the user has clicked an axis in the window then this axis will become the current axis.
  %If a colorbar or any other non-standard axis was clicked then axis number 1 will become
  %the current axis
  %
  QmatNMR.AxisNR2D3D = find(QTEMP1.AxesHandles == get(QmatNMR.Fig2D3D, 'currentaxes'));
  if isempty(QmatNMR.AxisNR2D3D)
    QmatNMR.AxisNR2D3D = 1;
  end
  
  QmatNMR.AxisHandle2D3D = QTEMP1.AxesHandles(QmatNMR.AxisNR2D3D);
  set(QmatNMR.c19, 'value', QmatNMR.ContColorbarIndicator(QmatNMR.AxisNR2D3D));
  set(QTEMP1.AxesHandles(QmatNMR.AxisNR2D3D), 'selected', 'on');
  
  QmatNMR.ZAxisIndicator = QTEMP1.ZAxisIndicator;
  set(QmatNMR.R27, 'value', QmatNMR.ZAxisIndicator(QmatNMR.AxisNR2D3D));
  
  %
  %Update the hold, zoom and rotate3d indicators in the 2D/3D Panel window
  %
  QmatNMR.Hold2D3D = QTEMP1.PlotParams(QmatNMR.AxisNR2D3D).Hold;
  set(QmatNMR.c11, 'value', QmatNMR.Hold2D3D);
  
  if (QTEMP1.Zoom)
    set(QmatNMR.c10, 'value', 1);
  
  else
    set(QmatNMR.c10, 'value', 0);
  end
  
  if (QTEMP1.Rotate3D)
    set(QmatNMR.c16, 'value', 1);
  
  else
    set(QmatNMR.c16, 'value', 0);
  end
  
  
  %
  %read the name of the current colormap from the figure's userdata
  %
  QmatNMR.CurrentColorMap = QTEMP1.ColorMap;
  
  
  %
  %attempt to reconstruct the original spectrum from the name of the spectrum as given in the input window
  %NOTE: this has the inherent danger that the thus created spectrum is not the same as the original one.
  %Espcially when random functions are used in the name this risk is large. Therefore I exclude all such functions
  %from this approach.
  %
  if ExistField(QTEMP1, 'PlotParams') & ExistField(QTEMP1.PlotParams(QmatNMR.AxisNR2D3D), 'name')
    QTEMP31 = QTEMP1.PlotParams(QmatNMR.AxisNR2D3D);
    QTEMP1 = QTEMP1.PlotParams(QmatNMR.AxisNR2D3D).Name;
    if ~isempty(findstr(QTEMP1, 'rand(')) | ~isempty(findstr(QTEMP1, 'randn(')) | ~isempty(findstr(QTEMP1, 'randperm('))
  %    disp('FAILED due to rand functions')
  
    else
      try
        %perform the normal checks for variable names
        [QmatNMR.SpecName2D3DProc QmatNMR.CheckInput] = checkinput(QTEMP1);
        checkinputcont
        
        if (QmatNMR.BREAK == 0)
          %axis for TD2
          QTEMP3 = QTEMP31.AnalyserAxisTD2;
          %axis for TD1
          QTEMP4 = QTEMP31.AnalyserAxisTD1;
    
          %the spectrum
          QTEMP1 = squeeze(eval(QmatNMR.SpecName2D3DProc));
          
          QTEMP2 = 1;
  
        else		%evaluation of input string failed in checkinputcont. But this is no big problem
        			%and we simply reset these two flag variables and continue
          QTEMP2 = 0;
          QmatNMR.BREAK = 0;
        end
      catch
  %      disp('FAILED due to whatever')
  %      QmatNMR.SpecName2D3DProc
        QTEMP2 = 0;
      end
      %if no error has occurred then we accept the result and change the QmatNMR.Spec2D3D variable
      if (QTEMP2)
        QmatNMR.Spec2D3D = QTEMP1;
        QmatNMR.Axis2D3DTD2 = QTEMP3;
        QmatNMR.Axis2D3DTD1 = QTEMP4;
      end
    end
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
