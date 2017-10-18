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
%doeopties.m is the script that executes all changes in the options menu
%Qoptions.m
%9-8-'96

try
  QmatNMR.yschaal = get(QmatNMR.o3, 'Value');		%y scale
  QmatNMR.gridvar = get(QmatNMR.o4, 'Value');		%grid
  QmatNMR.Q1DMenu = get(QmatNMR.o6, 'value'); 		%show 1D menu at startup
  QmatNMR.PhaseMenu = get(QmatNMR.o6a, 'value'); 	%show phase menu at startup
  QmatNMR.Q2DMenu = get(QmatNMR.o6b, 'value'); 		%show 2D menu at startup
  QmatNMR.xschaal = get(QmatNMR.o8, 'Value');		%x scale
  QTEMP2 = get(QmatNMR.o9, 'Value');		%relative y scale
  QmatNMR.under = eval(get(QmatNMR.o14,'String'));	%lower limit for contour plots
  QmatNMR.over = eval(get(QmatNMR.o16, 'String'));	%upper limit for contour plots
  QmatNMR.numbcont = eval(get(QmatNMR.o12, 'String'));	%number of contours
  QmatNMR.az = eval(get(QmatNMR.o18, 'String'));	%Azimuth angle for mesh plot
  QmatNMR.el = eval(get(QmatNMR.o20, 'String'));	%Elevation angle for mesh plot
  QmatNMR.stackaz = eval(get(QmatNMR.o24, 'String'));	%Azimuth angle for 3D stack plot
  QmatNMR.stackel = eval(get(QmatNMR.o26, 'String'));	%Elevation angle for 3D stack plot
  QmatNMR.ShowLogo=get(QmatNMR.o27, 'value');		%Show Logo
  QmatNMR.four2 = get(QmatNMR.o21, 'value');		%Fourier mode TD2
  QmatNMR.four1 = get(QmatNMR.o22, 'value');		%Fourier mode TD1
  QmatNMR.negcont = get(QmatNMR.o28, 'value');		%Show negative contours
  QmatNMR.matNMRSafety = get(QmatNMR.o29, 'value'); 	%ask before quit
  QmatNMR.PaperOrientation = get(QmatNMR.o30, 'value');	%paper orientation
  QmatNMR.PaperSize = get(QmatNMR.o31, 'value');	%paper size
  QmatNMRsettings.DefaultColormap = get(QmatNMR.o32, 'value');	%default colormap when that is used by Subplots.m
  if (QmatNMRsettings.DefaultColormap < 5)
    QmatNMRsettings.DefaultColormap = 6;			%by default use the hsv colormap if none is selected
  end
  QmatNMR.UnDo1D = eval(get(QmatNMR.o33, 'string'));	%how many undo-steps are allowed for 1D processing
  QmatNMR.UnDo2D = eval(get(QmatNMR.o34, 'string'));	%how many undo-steps are allowed for 2D processing
  QmatNMRsettings.DefaultRulerXAxis1FREQ = get(QmatNMR.o35, 'value');%what is the default frequency domain axis for TD2
  QmatNMRsettings.DefaultRulerXAxis2FREQ = get(QmatNMR.o36, 'value');%what is the default frequency domain axis for TD1
  QmatNMRsettings.DefaultRulerXAxis1TIME = get(QmatNMR.o37, 'value');%what is the default time domain axis for TD2
  QmatNMRsettings.DefaultRulerXAxis2TIME = get(QmatNMR.o38, 'value');%what is the default time domain axis for TD1
  QmatNMR.fftstatus = get(QmatNMR.o39, 'value');	%execute multiplication by 0.5 of first point in the FID
  
    
  if QmatNMR.doeopties == 2
    try
      delete(QmatNMR.ofig);
    end
    QmatNMR.ofig = [];
  else
    figure(QmatNMR.Fig);
  end
  
  
  if (QmatNMR.four2 == 3)		%states
    QmatNMR.four1 = 3;
  end
  if (QmatNMR.four2 == 5)		%Whole Echo
    QmatNMR.four1 = 5;
  end  
  
  
  if QmatNMR.yschaal 
    set(gca, 'ytickmode', 'auto');
  else
    set(gca, 'ytick', []);
  end
  
  if QmatNMR.gridvar 
    set(gca, 'ytickmode', 'auto');
    grid on;
    QmatNMR.gridvar = 1;
    if ~QmatNMR.yschaal 
      set(gca, 'ytick', []);
    end
  else
    grid off;
  end
  
  if QmatNMR.xschaal
    set(gca, 'xtickmode', 'auto');
  else
    set(gca, 'xtick', []);
  end
  
  if ~(QTEMP2 == QmatNMR.yrelative)
    QmatNMR.yrelative = QTEMP2;
  
    if QmatNMR.yrelative
      QmatNMR.Spec1DPlot = QmatNMR.Spec1D / max(real(QmatNMR.Spec1D));
    else
      QmatNMR.Spec1DPlot = QmatNMR.Spec1D;
    end;    
  end
  
  asaanpas
  regelUNDO
  
  if ~ (QmatNMR.doeopties == 2)
    figure(QmatNMR.ofig);
  end
  
  if QmatNMR.doeopties == 1
    SetOptions(1)
  
    saveoptions
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
