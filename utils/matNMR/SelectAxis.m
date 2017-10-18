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
%SelectAxis.m defines a buttondown-function for the current axis that makes it selected.
%then MATLAB draws handles around the axis and the user knows this axis is the current one.
%06-07-'98
%
%
% NOTE: the Rotate3DmatNMR routine will run the SelectAxis routine whenever the axis on which it
%	operates is not the current axis. This means that ALL variables used in SelectAxis
%	must be global and also defined in the Rotate3DmatNMR routine. Any changes here MUST also
%	be incorporated in Rotate3DmatNMR!
%Jacco, 09-03-2005
%

try
  QTEMP19 = gcf;
  QmatNMR.TEMPAxis = gca;
  
  if ~(QTEMP19 == QmatNMR.Fig2D3D)
    SelectFigure;
    QTEMP1 = 1;
  
  else
    QTEMP1 = get(QTEMP19, 'SelectionType');
    if strcmp(QTEMP1,'normal')
      QTEMP1 = 1;
    elseif strcmp(QTEMP1,'extend')
      QTEMP1 = 2;
    elseif strcmp(QTEMP1,'alt')
      QTEMP1 = 2;
    end
  end
  
  if (strcmp(get(QmatNMR.Fig2D3D, 'tag'), '2D/3D Viewer'))	%only do the following in a 2D/3D Viewer window
  %
  %change the axis and unselect all other axes if the left button is pushed
  %select an additional axis if the right button is pushed (axis not changed!)
  %
    if (QTEMP1 == 1)		%Left button was pressed --> select that axis
      %
      %check whether the selected axis is a colorbar. If so then change the selected status
      %otherwise select that axis as the current axis.
      %
      if strcmp(get(QmatNMR.TEMPAxis, 'tag'), 'Colorbar')
        %
        %set the selected status for this colorbar axis
        %
        set(findobj(allchild(QmatNMR.Fig2D3D), 'selected', 'on'), 'selected', 'off');
        set(QmatNMR.TEMPAxis, 'selected', 'on');
      
      %
      %check whether the selected axis is a colorbar. If so then change the selected status
      %otherwise select that axis as the current axis.
      %
      elseif strcmp(get(QmatNMR.TEMPAxis, 'tag'), 'Projection')
        %
        %set the selected status for this projection axis
        %
        updateprojectionaxes
        set(findobj(allchild(QmatNMR.Fig2D3D), 'selected', 'on'), 'selected', 'off');
        set(QmatNMR.TEMPAxis, 'selected', 'on');
        
      
      else
        QmatNMR.AxisHandle2D3D = QmatNMR.TEMPAxis; 	%select this axis as the current one
        set(findobj(allchild(QmatNMR.Fig2D3D), 'selected', 'on'), 'selected', 'off');
        set(QmatNMR.AxisHandle2D3D, 'selected', 'on');
        QTEMP1 = get(QmatNMR.Fig2D3D, 'userdata');
      
        QmatNMR.AxisNR2D3D = find(QTEMP1.AxesHandles == QmatNMR.AxisHandle2D3D);
        %colorbar indicator
        set(QmatNMR.c19, 'value', QmatNMR.ContColorbarIndicator(QmatNMR.AxisNR2D3D));
        
        %z-axis indicator
        set(QmatNMR.R27, 'value', QmatNMR.ZAxisIndicator(QmatNMR.AxisNR2D3D));
        
        QmatNMR.aswaarden = [get(QmatNMR.AxisHandle2D3D, 'xlim') get(QmatNMR.AxisHandle2D3D, 'ylim')]; %change the matNMR parameter for the plot limits
        QmatNMR.History2D3D = QTEMP1.PlotParams(QmatNMR.AxisNR2D3D).History;
        
        %hold status
        QmatNMR.Hold2D3D = QTEMP1.PlotParams(QmatNMR.AxisNR2D3D).Hold;
        set(QmatNMR.c11, 'value', QmatNMR.Hold2D3D);
        
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
            %perform the normal checks for variable names
            [QmatNMR.SpecName2D3DProc QmatNMR.CheckInput] = checkinput(QTEMP1);
            checkinputcont
            try
              %axis for TD2
              QTEMP3 = QTEMP31.AnalyserAxisTD2;
              %axis for TD1
              QTEMP4 = QTEMP31.AnalyserAxisTD1;
        
              %the spectrum
              QTEMP1 = squeeze(eval(QmatNMR.SpecName2D3DProc));
              
              QTEMP2 = 1;
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
        
        updateprojectionaxes
      end
  
    else
      %
      %toggle the selected status for this axis
      %
      if strcmp(get(QmatNMR.TEMPAxis, 'selected'), 'on')
        set(QmatNMR.TEMPAxis, 'selected', 'off');
      else
        set(QmatNMR.TEMPAxis, 'selected', 'on');
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
