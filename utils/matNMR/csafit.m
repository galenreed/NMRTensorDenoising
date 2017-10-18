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
function CSAfit(command) 
%  peakfit.m 
%  Created: 4-Mar-94 
%  Using  : GUIMaker by Patrick Marchand 
%                         (pmarchan@motown.ge.com) 
%  Author :  Sean M. Brennan (Bren@SLAC.stanford.edu)
%  Mods.  :  5-3-94 change cursor procedure
%   

%  Copyright (c) 1994 by Patrick Marchand 
%       Permission is granted to modify and re-distribute this 
%	code in any manner as long as this notice is preserved. 
%	All standard disclaimers apply. 

%
% adapted for matNMR by Jacco van Beek
% 16-01-'07
%
global PFITX PFITDY PFITFY PFIT_LAMBDA Pverbose Pstdv QmatNMR


if nargin == 0 
  command = 'init';
end 

if ~strcmp(command,'init')
  [fitbut, simbut, ed, ck, pop, TolBut, NrIterBut, noibut, noibute, zombut, redisbut, simplexbut, gradbut, refreshbut, printbut, stopbut, verbbut] = CSApk_udata;

  if (get(zombut,'Value')==1)
    ZoomMatNMR FitWindow off;
  end

  CSAFitFigure = findobj(allchild(0), 'Tag', 'CSAFit');
  CSAFitAxis   = findobj(get(CSAFitFigure, 'children'), 'tag', 'CSAFitAxis');
  axes(CSAFitAxis);
end

if isstr(command) 
	if strcmp(command,'init') 
		CSApk_init
 		[fitbut, simbut, ed, ck, pop, TolBut, NrIterBut, noibut, noibute, zombut, redisbut, simplexbut, gradbut, refreshbut, printbut, stopbut, verbbut] = CSApk_udata;
                
		CSAFitFigure = findobj(0, 'Tag', 'CSAFit');
                CSAFitAxis   = findobj(allchild(CSAFitFigure), 'tag', 'CSAFitAxis');
		axes(CSAFitAxis);
                axis on
		set(CSAFitAxis, 'nextplot', 'replacechildren', ...
	                 'units', 'normalized', ...
	                 'position',[0.2933    0.3200    0.6833    0.6429], ...
			 'nextplot', 'replacechildren', ...
                         'XGrid','on', ...
			 'YGrid','on', ...
			 'FontSize', QmatNMR.TextSize, ...
			 'FontName', QmatNMR.TextFont, ...
			 'FontAngle', QmatNMR.TextAngle, ...
			 'FontWeight', QmatNMR.TextWeight, ...
			 'LineWidth', QmatNMR.LineWidth, ...
			 'visible','on', ...
			 'tag', 'CSAFitAxis', ...
			 'view', [0 90], ...
			 'color', QmatNMR.ColorScheme.AxisBack, ...
			 'xcolor', QmatNMR.ColorScheme.AxisFore, ...
			 'ycolor', QmatNMR.ColorScheme.AxisFore, ...
			 'zcolor', QmatNMR.ColorScheme.AxisFore, ...
			 'visible', 'on', ...
			 'xscale', 'linear', ...
			 'yscale', 'linear', ...
			 'zscale', 'linear', ...
			 'xtickmode', 'auto', ...
			 'ytickmode', 'auto', ...
			 'ztickmode', 'auto', ...
			 'xticklabelmode', 'auto', ...
			 'yticklabelmode', 'auto', ...
			 'zticklabelmode', 'auto', ...
			 'selected', 'off', ...
			 'userdata', 1, ...
                         'xdir', 'normal', ...
                         'ydir', 'normal', ...
                         'zdir', 'normal', ...
			 'box', 'on');

		if (PFITX(1) < PFITX(2))
		  plot(PFITX, PFITDY, QmatNMR.LineColor);
		  set(CSAFitAxis, 'XGrid','on', 'YGrid','on', 'XDir', 'reverse', ... 
		      'fontsize', QmatNMR.TextSize, 'fontname', QmatNMR.TextFont, 'fontangle', QmatNMR.TextAngle, 'fontweight', QmatNMR.TextWeight);

                  ymin = min(PFITDY);
                  ymax = max(PFITDY);
                  if ((ymin == 0) & (ymax == 0))
                    ymin = -1;
                    ymax = 1;
                  end
                  axis([min(PFITX) max(PFITX) (ymin-0.1*abs(ymin)) (ymax + 0.1*abs(ymax))]);
		else
		  plot(fliplr(PFITX), fliplr(PFITDY), QmatNMR.LineColor);
		  set(CSAFitAxis, 'XGrid','on', 'YGrid','on', 'XDir', 'normal', ... 
		      'fontsize', QmatNMR.TextSize, 'fontname', QmatNMR.TextFont, 'fontangle', QmatNMR.TextAngle, 'fontweight', QmatNMR.TextWeight);

                  ymin = min(PFITDY);
                  ymax = max(PFITDY);
                  if ((ymin == 0) & (ymax == 0))
                    ymin = -1;
                    ymax = 1;
                  end
                  axis([min(PFITX) max(PFITX) (ymin-0.1*abs(ymin)) (ymax + 0.1*abs(ymax))]);
		end  
                setappdata(CSAFitAxis, 'ZoomLimitsMatNMR', [min(PFITX) max(PFITX) (ymin-0.1*abs(ymin)) (ymax + 0.1*abs(ymax))]);
		
		disp('CSATENSORFIT succesfully initiated ...');
		
	elseif strcmp(command,'new') 		%when a fit window is already opened, just update the plot
	        set(CSAFitAxis, 'nextplot', 'replacechildren');

                axis on
		set(CSAFitAxis, ...
	                 'units', 'normalized', ...
	                 'position',[0.2933    0.3200    0.6833    0.6429], ...
			 'nextplot', 'replacechildren', ...
                         'XGrid','on', ...
			 'YGrid','on', ...
			 'FontSize', QmatNMR.TextSize, ...
			 'FontName', QmatNMR.TextFont, ...
			 'FontAngle', QmatNMR.TextAngle, ...
			 'FontWeight', QmatNMR.TextWeight, ...
			 'LineWidth', QmatNMR.LineWidth, ...
			 'visible','on', ...
			 'tag', 'CSAFitAxis', ...
			 'color', QmatNMR.ColorScheme.AxisBack, ...
			 'xcolor', QmatNMR.ColorScheme.AxisFore, ...
			 'ycolor', QmatNMR.ColorScheme.AxisFore, ...
			 'zcolor', QmatNMR.ColorScheme.AxisFore, ...
			 'view', [0 90], ...
			 'visible', 'on', ...
			 'xscale', 'linear', ...
			 'yscale', 'linear', ...
			 'zscale', 'linear', ...
			 'xtickmode', 'auto', ...
			 'ytickmode', 'auto', ...
			 'ztickmode', 'auto', ...
			 'xticklabelmode', 'auto', ...
			 'yticklabelmode', 'auto', ...
			 'zticklabelmode', 'auto', ...
			 'selected', 'off', ...
			 'userdata', 1, ...
                         'xdir', 'normal', ...
                         'ydir', 'normal', ...
                         'zdir', 'normal', ...
			 'box', 'on');

		if (PFITX(1) < PFITX(2))
		  plot(PFITX, PFITDY, QmatNMR.LineColor);
		  set(CSAFitAxis, 'XGrid','on', 'YGrid','on', 'XDir', 'reverse', ... 
		      'fontsize', QmatNMR.TextSize, 'fontname', QmatNMR.TextFont, 'fontangle', QmatNMR.TextAngle, 'fontweight', QmatNMR.TextWeight);

                  ymin = min(PFITDY);
                  ymax = max(PFITDY);
                  if ((ymin == 0) & (ymax == 0))
                    ymin = -1;
                    ymax = 1;
                  end
                  axis([min(PFITX) max(PFITX) (ymin-0.1*abs(ymin)) (ymax + 0.1*abs(ymax))]);
		else
		  plot(fliplr(PFITX), fliplr(PFITDY), QmatNMR.LineColor);
		  set(CSAFitAxis, 'XGrid','on', 'YGrid','on', 'XDir', 'normal', ... 
		      'fontsize', QmatNMR.TextSize, 'fontname', QmatNMR.TextFont, 'fontangle', QmatNMR.TextAngle, 'fontweight', QmatNMR.TextWeight);

                  ymin = min(PFITDY);
                  ymax = max(PFITDY);
                  if ((ymin == 0) & (ymax == 0))
                    ymin = -1;
                    ymax = 1;
                  end
                  axis([min(PFITX) max(PFITX) (ymin-0.1*abs(ymin)) (ymax + 0.1*abs(ymax))]);
		end  
                setappdata(CSAFitAxis, 'ZoomLimitsMatNMR', [min(PFITX) max(PFITX) (ymin-0.1*abs(ymin)) (ymax + 0.1*abs(ymax))]);

		
	elseif strcmp(command,'fitbut') 
                %
                %First we determine whether the user wants to simulate or fit the spectrum
                %
                xxx = gco;
                if strcmp(get(xxx, 'userdata'), 'simbut')
                  NoFitFLAG = 1;
                else
                  NoFitFLAG = 0;
                end


                %
                %First we read out the parameters that are not fitted
                %
                FitOptions = optimset;
                FitOptions.TolFun = eval(get(TolBut, 'String'));
                FitOptions.MaxFunEvals = eval(get(NrIterBut, 'String'));
                QTEMP = str2mat('final', 'off', 'iter', 'notify', 'final');
                FitOptions.Display = deblank(QTEMP(get(verbbut, 'value'), :));
                
                PlotIntermediate = get(redisbut, 'value')-1;
                Epsilon = eval(get(noibute, 'String'));
                SIMPLEXflag = get(simplexbut, 'value');
                GRADIENTflag = get(gradbut, 'value');


                %
                %Then we read in all fit parameters
                %
                %find out how many lines must be fitted -> check is the "sigma_11"
                NrLines = 0;
                for tel=1:4
                  if (~isempty(get(ed((tel-1)*6+1),'String')))
                    NrLines = NrLines + 1;
                  end
                end
                
                
                %
                %The simulation routine keeps track of which parameters are fitted and which values are constant
                %Here we create the appropriate data structure
                %
                Constants = fitcsatensor(NrLines);
                

                %
                %Now we fill in the parameters as either fit parameter or as a constant (depends on the check button)
                %
                ParamCounter = 0;
                for tel=1:NrLines
                  if (get(ck((tel-1)*6+1), 'value'))	%keep sigma_11 constant
                    Constants(tel).sigma11 = eval(get(ed((tel-1)*6+1), 'String'));
                  else
                    ParamCounter = ParamCounter + 1;
                    Parameters(ParamCounter) = eval(get(ed((tel-1)*6+1), 'String'));
                  end

                  if (get(pop(tel), 'value')-1)         %force symmetric tensor
                    Constants(tel).ForceSymmetric = 1;
                  else
                    Constants(tel).ForceSymmetric = 0;
                    if (get(ck((tel-1)*6+2), 'value'))	%keep sigma_22 constant
                      Constants(tel).sigma22 = eval(get(ed((tel-1)*6+2), 'String'));
                    else
                      ParamCounter = ParamCounter + 1;
                      Parameters(ParamCounter) = eval(get(ed((tel-1)*6+2), 'String'));
                    end
                  end

                  if (get(ck((tel-1)*6+3), 'value'))	%keep sigma_33 constant
                    Constants(tel).sigma33 = eval(get(ed((tel-1)*6+3), 'String'));
                  else
                    ParamCounter = ParamCounter + 1;
                    Parameters(ParamCounter) = eval(get(ed((tel-1)*6+3), 'String'));
                  end

                  if (get(ck((tel-1)*6+4), 'value'))	%keep GaussianLB constant
                    Constants(tel).GaussianLB = eval(get(ed((tel-1)*6+4), 'String'));
                  else
                    ParamCounter = ParamCounter + 1;
                    Parameters(ParamCounter) = eval(get(ed((tel-1)*6+4), 'String'));
                  end

                  if (get(ck((tel-1)*6+5), 'value'))	%keep LorentzianLB constant
                    Constants(tel).LorentzianLB = eval(get(ed((tel-1)*6+5), 'String'));
                  else
                    ParamCounter = ParamCounter + 1;
                    Parameters(ParamCounter) = eval(get(ed((tel-1)*6+5), 'String'));
                  end

                  if (get(ck((tel-1)*6+6), 'value'))	%keep Intensity constant
                    Constants(tel).Intensity = eval(get(ed((tel-1)*6+6), 'String'));
                  else
                    ParamCounter = ParamCounter + 1;
                    Parameters(ParamCounter) = eval(get(ed((tel-1)*6+6), 'String'));
                  end
                end
                %
                %finally the background and slope
                %
                if (get(ck(25), 'value'))     %keep Background constant
                  Constants(tel).Background = eval(get(ed(25), 'String'));
                else
                  ParamCounter = ParamCounter + 1;
                  Parameters(ParamCounter) = eval(get(ed(25), 'String'));
                end
                if (get(ck(26), 'value'))     %keep Slope constant
                  Constants(tel).Slope = eval(get(ed(26), 'String'));
                else
                  ParamCounter = ParamCounter + 1;
                  Parameters(ParamCounter) = eval(get(ed(26), 'String'));
                end


                %
                %start the fit
                %
                [ParametersOut, Error, Fit] = fitcsatensor(PFITDY, PFITX, Parameters, Constants, SIMPLEXflag, GRADIENTflag, Epsilon, FitOptions, PlotIntermediate, NoFitFLAG);
                
                
                %
                %show the final result and insert the parameter values into the corresponding UIcontrols
                %
                tmp = get(CSAFitAxis, 'nextplot');
                hold on
                delete(findobj(allchild(gcf), 'tag', 'CSAFitHandle'))
                if (PFITX(1) < PFITX(2))
                  CSAFitHandle = plot(PFITX, real(Fit), QmatNMR.color(rem(1, length(QmatNMR.color)) + 1));
                  set(CSAFitAxis, 'xdir', 'reverse');
                else
                  CSAFitHandle = plot(fliplr(PFITX), fliplr(real(Fit)), QmatNMR.color(rem(1, length(QmatNMR.color)) + 1));
                  set(CSAFitAxis, 'xdir', 'normal');
                end
                set(CSAFitAxis, 'nextplot', tmp);
                set(CSAFitHandle, 'tag', 'CSAFitHandle')
                drawnow
                
                for tel=1:NrLines
                  for tel2=1:6
                    set(ed(tel2+(tel-1)*6), 'String', num2str(ParametersOut(tel2+(tel-1)*6), 6));
                  end
                end
                set(ed(25), 'String', num2str(ParametersOut(end-2), 3));
                set(ed(26), 'String', num2str(ParametersOut(end-1), 3));


                %
                %Store the fitted parameters in the workspace
                %
                if isfield(QmatNMR, 'CSAFitResults')
                  QmatNMR = rmfield(QmatNMR, 'CSAFitResults');
                end
                QmatNMR.CSAFitResults.Parameters 	= ParametersOut;
		QmatNMR.CSAFitResults.Fit 		= Fit;
		QmatNMR.CSAFitResults.Data 		= PFITDY;
		QmatNMR.CSAFitResults.Axis 		= PFITX;
		QmatNMR.CSAFitResults.Error		= Error;
		QmatNMR.CSAFitResults.Sigma 		= Epsilon;
		QmatNMR.CSAFitResults.Constraints 	= cell2mat(get(ck([1:NrLines*6 25 26]), 'value'));


                %
                %to store the results we need to make the designated variable global. In case the name
                %points to a structure variable, we need to use only the main variable, hence the following
                %check.
                %
                QTEMP = findstr(QmatNMR.VariableNameCSAFit, '.');
                if QTEMP
                  eval(['global ' QmatNMR.VariableNameCSAFit(1:(QTEMP-1))]);
                else
                 eval(['global ' QmatNMR.VariableNameCSAFit]);
                end
                eval([QmatNMR.VariableNameCSAFit ' = QmatNMR.CSAFitResults;']);

		fprintf(1, '\n\nFitting finished ...\nThe results have been written to "%s" in the MATLAB workspace.\nType "global %s" once to allow access to the variable\n\n', QmatNMR.VariableNameCSAFit, QmatNMR.VariableNameCSAFit);
		fprintf(1, 'For Matlab 7: use "cell2mat(cellfun(@(x) x,{%s.Parameters},''UniformOutput'', false)'')"\nto convert an array of structures into a matrix for further manipulation.\n\n', QmatNMR.VariableNameCSAFit);
	

	elseif strcmp(command,'noibut') 
                disp(' ');
                disp('You have to define the area in which only noise is present');
                disp('Move the mouse pointer to the desired coordinates and click a button ...');
                disp(' ');

                set(CSAFitAxis, 'nextplot', 'add');
                PY = get(CSAFitAxis, 'ylim');
                QmatNMR.resolution = (max(PFITX) - min(PFITX))/length(PFITX);
                QmatNMR.waarden(1, :) = ginput(1);
                plot([QmatNMR.waarden(1,1) QmatNMR.waarden(1,1)], PY, 'r--');

                QmatNMR.waarden(2, :) = ginput(1);
                plot([QmatNMR.waarden(2,1) QmatNMR.waarden(2,1)], PY, 'r--');

                axis on
		set(CSAFitAxis, ...
	                 'units', 'normalized', ...
	                 'position',[0.2933    0.3200    0.6833    0.6429], ...
			 'nextplot', 'replacechildren', ...
                         'XGrid','on', ...
			 'YGrid','on', ...
			 'FontSize', QmatNMR.TextSize, ...
			 'FontName', QmatNMR.TextFont, ...
			 'FontAngle', QmatNMR.TextAngle, ...
			 'FontWeight', QmatNMR.TextWeight, ...
			 'LineWidth', QmatNMR.LineWidth, ...
			 'visible','on', ...
			 'tag', 'CSAFitAxis', ...
			 'view', [0 90], ...
			 'color', QmatNMR.ColorScheme.AxisBack, ...
			 'xcolor', QmatNMR.ColorScheme.AxisFore, ...
			 'ycolor', QmatNMR.ColorScheme.AxisFore, ...
			 'zcolor', QmatNMR.ColorScheme.AxisFore, ...
			 'visible', 'on', ...
			 'xscale', 'linear', ...
			 'yscale', 'linear', ...
			 'zscale', 'linear', ...
			 'xtickmode', 'auto', ...
			 'ytickmode', 'auto', ...
			 'ztickmode', 'auto', ...
			 'xticklabelmode', 'auto', ...
			 'yticklabelmode', 'auto', ...
			 'zticklabelmode', 'auto', ...
			 'selected', 'off', ...
			 'userdata', 1, ...
                         'xdir', 'normal', ...
                         'ydir', 'normal', ...
                         'zdir', 'normal', ...
			 'box', 'on');

		if (PFITX(1) < PFITX(2))
		  set(CSAFitAxis, 'XGrid','on', 'YGrid','on', 'XDir', 'reverse');
		else
		  set(CSAFitAxis, 'XGrid','on', 'YGrid','on', 'XDir', 'normal');
		end  

                if QmatNMR.waarden(2,1) < QmatNMR.waarden(1,1)
                  QmatNMR.waarden = flipud(QmatNMR.waarden);
                end

                QmatNMR.waarden(1,1) = find(PFITX>(QmatNMR.waarden(1,1)-0.5*(QmatNMR.resolution)) & ...
                                     PFITX<=(QmatNMR.waarden(1,1)+0.5*(QmatNMR.resolution)));
                QmatNMR.waarden(2,1) = find(PFITX<=(QmatNMR.waarden(2,1)+0.5*(QmatNMR.resolution)) & ...
                                     PFITX>(QmatNMR.waarden(2,1)-0.5*(QmatNMR.resolution)));

                if (QmatNMR.waarden(1, 1) < 1)
                  QmatNMR.waarden(1, 1) = 1;
                end;
                
                %sort the indices to make sure the lowest comes first
                QmatNMR.waarden = sort([QmatNMR.waarden(1,1) QmatNMR.waarden(2,1)]);
                QTEMP = std(PFITDY(QmatNMR.waarden(1):QmatNMR.waarden(2)));
                if (abs(QTEMP) < eps)
                  QTEMP = 1;
                  beep
                  disp('matNMR WARNING: designated area has standard deviation that is close to eps. Value was refused!');
                end

                set(noibute, 'string', num2str(QTEMP, 10));

	elseif strcmp(command,'zombut')
               if (get(zombut,'Value')==1)
                  ZoomMatNMR FitWindow on;
               elseif(get(zombut,'Value')==0)
                  ZoomMatNMR FitWindow off;  
               end


	elseif strcmp(command,'loadpars1')			%Load parameters input window
                QuiInput('Load fit parameters from the workspace :', ' OK | CANCEL', 'regelloadparsCSA', [], 'Name of variable :', QmatNMR.ViewNameCSAFit);

	elseif strcmp(command,'loadpars2')			%Load parameters input window callback
                QmatNMR.ViewNameCSAFit = QmatNMR.GetString;
                QmatNMR.InitialFitPars = QmatNMR.GetVar;

                %
                %due to a change in the way the parameters are stored we need to ensure backward compatibility
                %
                if ~isstruct(QmatNMR.InitialFitPars)
                  %
                  %convert the variable to the new structure
                  %
                  QmatNMR.InitialFitPars.Parameters = QmatNMR.InitialFitPars;

                elseif ~isfield(QmatNMR.InitialFitPars, 'Parameters')
                  disp('matNMR WARNING: incorrect variable structure for fit parameters. Aborting ...')
                  beep
                  return
                end

                %
                %continue
                %
                if (mod((length(QmatNMR.InitialFitPars.Parameters)-3), 6) == 0)
                  NrLines = (length(QmatNMR.InitialFitPars.Parameters)-3)/6;
                  for tel=1:NrLines
                    for tel2=1:6
                      set(ed(tel2+(tel-1)*6), 'String', num2str(QmatNMR.InitialFitPars.Parameters(tel2+(tel-1)*6), 6));
                    end
                  end
                  for tel=NrLines+1:4
                    for tel2=1:6
                      set(ed(tel2+(tel-1)*6), 'String', '');
                    end
                  end
                  set(ed(25), 'String', num2str(QmatNMR.InitialFitPars.Parameters(end-2), 6));
                  set(ed(26), 'String', num2str(QmatNMR.InitialFitPars.Parameters(end-1), 6));

                  %
                  %set the constraints and the sigma if they were stored in the structure
                  %
                  if isfield(QmatNMR.InitialFitPars, 'Sigma')
                    set(noibute, 'string', num2str(QmatNMR.InitialFitPars.Sigma, 6));
                  end
                  
                  if isfield(QmatNMR.InitialFitPars, 'Constraints')
                    for teller=1:(length(QmatNMR.InitialFitPars.Constraints)-2)
                      set(ck(teller), 'value', QmatNMR.InitialFitPars.Constraints(teller));
                    end
                    set(ck(25), 'value', QmatNMR.InitialFitPars.Constraints(end-1));
                    set(ck(26), 'value', QmatNMR.InitialFitPars.Constraints(end));
                  end
                else  
                  error('matNMR ERROR: the length of the vector is not correct !!');
                end



	elseif strcmp(command,'defvar1')			%Define variable name for Results
                QuiInput('Define Results Variable :', ' OK | CANCEL', 'regeldefvarCSA', [], 'Name of variable :', QmatNMR.VariableNameCSAFit);

	elseif strcmp(command,'defvar2')			%Define variable name for Results callback
                QmatNMR.VariableNameCSAFit = QmatNMR.uiInput1;
                %
                %to store the results we need to make the designated variable global. In case the name
                %points to a structure variable, we need to use only the main variable, hence the following
                %check.
                %
                QTEMP = findstr(QmatNMR.VariableNameCSAFit, '.');
                if QTEMP
                  eval(['global ' QmatNMR.VariableNameCSAFit(1:(QTEMP-1))]);
                else
  		  eval(['global ' QmatNMR.VariableNameCSAFit]);
                end
		eval([QmatNMR.VariableNameCSAFit ' = 1;']);
		disp('  ');
		disp(['matNMR NOTICE: new variable name "' QmatNMR.VariableNameCSAFit '" defined for CSArupole-tensor fitting results. ']);
		disp(['matNMR NOTICE: To be able to access this variable please type:']);
		disp('  ');
                if QTEMP
		  disp(['               global ' QmatNMR.VariableNameCSAFit(1:(QTEMP-1))]);
                else
		  disp(['               global ' QmatNMR.VariableNameCSAFit]);
                end
		disp('  ');



	elseif strcmp(command,'view1')			%View Fit Results input window
                QuiInput('View Fit Results :', ' OK | CANCEL', 'regelviewresultsCSA', [], 'Name of variable :', QmatNMR.ViewNameCSAFit);

	elseif strcmp(command,'view2')			%View Fit Results input window callback
                QmatNMR.ViewNameCSAFit = QmatNMR.GetString;
                QmatNMR.InitialFitPars = QmatNMR.GetVar;

                %
                %due to a change in the way the parameters are stored we need to ensure backward compatibility
                %
                if ~isstruct(QmatNMR.InitialFitPars)
                  %
                  %convert the variable to the new structure
                  %
                  QmatNMR.InitialFitPars.Parameters = QmatNMR.InitialFitPars;

                elseif ~isfield(QmatNMR.InitialFitPars, 'Parameters')
                  disp('matNMR WARNING: incorrect variable structure for fit parameters. Aborting ...')
                  beep
                  return
                end

                %
                %continue
                %
                if (mod((length(QmatNMR.InitialFitPars.Parameters)-3), 6) == 0)
                  NrLines = (length(QmatNMR.InitialFitPars.Parameters)-3)/6;

                  %
                  %write values to the console window
                  %
                  fprintf(1, '\n\n');
                  for tel=1:NrLines
                    fprintf(1, 'Fit results for line %d:  isoCS = %7.2f ppm, Cq = %6.4f MHz, eta = %5.3f, LB (Gaussian) = %7.3f ppm, LB (Lorentzian) = %7.3f ppm, Intensity = %7.2f \n', tel, QmatNMR.InitialFitPars.Parameters(((tel-1)*6+1):tel*6));
                  end
                  fprintf(1, 'Background = %7.2f, Slope = %7.2f\n\n\n', QmatNMR.InitialFitPars.Parameters(end-2:end-1));


                  %
                  %write values to the UIcontrols
                  %
                  for tel=1:NrLines
                    for tel2=1:6
                      set(ed(tel2+(tel-1)*6), 'String', num2str(QmatNMR.InitialFitPars.Parameters(tel2+(tel-1)*6), 6));
                    end
                  end
                  for tel=NrLines+1:4
                    for tel2=1:6
                      set(ed(tel2+(tel-1)*6), 'String', '');
                    end
                  end
                  set(ed(25), 'String', num2str(QmatNMR.InitialFitPars.Parameters(end-2), 6));
                  set(ed(26), 'String', num2str(QmatNMR.InitialFitPars.Parameters(end-1), 6));

                  %
                  %set the constraints and the sigma if they were stored in the structure
                  %
                  if isfield(QmatNMR.InitialFitPars, 'Sigma')
                    set(noibute, 'string', num2str(QmatNMR.InitialFitPars.Sigma, 6));
                  end
                  
                  if isfield(QmatNMR.InitialFitPars, 'Constraints')
                    for teller=1:(length(QmatNMR.InitialFitPars.Constraints)-2)
                      set(ck(teller), 'value', QmatNMR.InitialFitPars.Constraints(teller));
                    end
                    set(ck(25), 'value', QmatNMR.InitialFitPars.Constraints(end-1));
                    set(ck(26), 'value', QmatNMR.InitialFitPars.Constraints(end));
                  end
 
 
                  %
                  %plot the data and fit
                  %
                  PFITX  = QmatNMR.InitialFitPars.Axis;
                  PFITDY = QmatNMR.InitialFitPars.Data;
                  Fit    = QmatNMR.InitialFitPars.Fit;
                  axis on
                  set(CSAFitAxis, ...
  	                 'units', 'normalized', ...
  	                 'position',[0.2933    0.3200    0.6833    0.6429], ...
  			 'nextplot', 'replacechildren', ...
                           'XGrid','on', ...
  			 'YGrid','on', ...
  			 'FontSize', QmatNMR.TextSize, ...
  			 'FontName', QmatNMR.TextFont, ...
  			 'FontAngle', QmatNMR.TextAngle, ...
  			 'FontWeight', QmatNMR.TextWeight, ...
  			 'LineWidth', QmatNMR.LineWidth, ...
  			 'visible','on', ...
  			 'tag', 'CSAFitAxis', ...
  			 'color', QmatNMR.ColorScheme.AxisBack, ...
  			 'xcolor', QmatNMR.ColorScheme.AxisFore, ...
  			 'ycolor', QmatNMR.ColorScheme.AxisFore, ...
  			 'zcolor', QmatNMR.ColorScheme.AxisFore, ...
  			 'view', [0 90], ...
  			 'visible', 'on', ...
  			 'xscale', 'linear', ...
  			 'yscale', 'linear', ...
  			 'zscale', 'linear', ...
  			 'xtickmode', 'auto', ...
  			 'ytickmode', 'auto', ...
  			 'ztickmode', 'auto', ...
  			 'xticklabelmode', 'auto', ...
  			 'yticklabelmode', 'auto', ...
  			 'zticklabelmode', 'auto', ...
  			 'selected', 'off', ...
  			 'userdata', 1, ...
                           'xdir', 'normal', ...
                           'ydir', 'normal', ...
                           'zdir', 'normal', ...
  			 'box', 'on');
  
                  if (PFITX(1) < PFITX(2))
                    plot(PFITX, PFITDY, QmatNMR.LineColor);
                    set(CSAFitAxis, 'XGrid','on', 'YGrid','on', 'XDir', 'reverse', ... 
  		                    'fontsize', QmatNMR.TextSize, 'fontname', QmatNMR.TextFont, 'fontangle', QmatNMR.TextAngle, 'fontweight', QmatNMR.TextWeight);
  
                    ymin = min(PFITDY);
                    ymax = max(PFITDY);
                    if ((ymin == 0) & (ymax == 0))
                      ymin = -1;
                      ymax = 1;
                    end
                    axis([min(PFITX) max(PFITX) (ymin-0.1*abs(ymin)) (ymax + 0.1*abs(ymax))]);
                  else
                    plot(fliplr(PFITX), fliplr(PFITDY), QmatNMR.LineColor);
                    set(CSAFitAxis, 'XGrid','on', 'YGrid','on', 'XDir', 'normal', ... 
  		                    'fontsize', QmatNMR.TextSize, 'fontname', QmatNMR.TextFont, 'fontangle', QmatNMR.TextAngle, 'fontweight', QmatNMR.TextWeight);
  
                    ymin = min(PFITDY);
                    ymax = max(PFITDY);
                    if ((ymin == 0) & (ymax == 0))
                      ymin = -1;
                      ymax = 1;
                    end
                    axis([min(PFITX) max(PFITX) (ymin-0.1*abs(ymin)) (ymax + 0.1*abs(ymax))]);
                  end  
                  setappdata(CSAFitAxis, 'ZoomLimitsMatNMR', [min(PFITX) max(PFITX) (ymin-0.1*abs(ymin)) (ymax + 0.1*abs(ymax))]);

                  tmp = get(CSAFitAxis, 'nextplot');
                  hold on
                  delete(findobj(allchild(gcf), 'tag', 'CSAFitHandle'))
                  if (PFITX(1) < PFITX(2))
                    CSAFitHandle = plot(PFITX, real(Fit), QmatNMR.color(rem(1, length(QmatNMR.color)) + 1));
                    set(CSAFitAxis, 'xdir', 'reverse');
                  else
                    CSAFitHandle = plot(fliplr(PFITX), fliplr(real(Fit)), QmatNMR.color(rem(1, length(QmatNMR.color)) + 1));
                    set(CSAFitAxis, 'xdir', 'normal');
                  end
                  set(CSAFitAxis, 'nextplot', tmp);
                  set(CSAFitHandle, 'tag', 'CSAFitHandle')

                else  
                  error('matNMR ERROR: the length of the vector is not correct !!');
                end



	elseif strcmp(command,'refreshbut')			%refresh the screen by taking the current 1D spectrum from the main window
	  global QmatNMR
	  
	  QmatNMR.FitResults = 0;

          % Find the indices for the part of the data arrays to overload into the peakfit routine
          if (QmatNMR.DisplayMode == 3)
            disp('matNMR NOTICE: when working in display mode "both" zoom limits are not taken into account!');
            QmatNMR.lowerbound = min(QmatNMR.Axis1D);
            QmatNMR.upperbound = max(QmatNMR.Axis1D);
          
          else
            QmatNMR.lowerbound = min([QmatNMR.xmin (QmatNMR.xmin+QmatNMR.totaalX)]);
            QmatNMR.upperbound = max([QmatNMR.xmin (QmatNMR.xmin+QmatNMR.totaalX)]);
          end
          
          %
          %Now we want to see which part of the spectrum is zoomed in to right now. Only this
          %region will be overloaded into the peak fitting routine. We have to make a distinction
          %between a linear axis vector and a non-linear one.
          if (LinearAxis(QmatNMR.Axis1D))
            QmatNMR.resolution = abs( QmatNMR.Axis1D(1) - QmatNMR.Axis1D(2) );
            QTEMP3 = find(QmatNMR.Axis1D>(QmatNMR.lowerbound-0.5*(QmatNMR.resolution)) & QmatNMR.Axis1D<=(QmatNMR.lowerbound+0.5*(QmatNMR.resolution)));
            QTEMP4 = find(QmatNMR.Axis1D<=(QmatNMR.upperbound+0.5*(QmatNMR.resolution)) & QmatNMR.Axis1D>(QmatNMR.upperbound-0.5*(QmatNMR.resolution)));
          
          else
          			%non-linear axis -> use the one with the lowest distance to the next point in the axis vector
            [QTEMP1, QTEMP3] = min(abs(QmatNMR.Axis1D - QmatNMR.lowerbound));
            [QTEMP1, QTEMP4] = min(abs(QmatNMR.Axis1D - QmatNMR.upperbound));
          end
          
          QTEMP = sort([QTEMP3 QTEMP4]);
          QTEMP3 = QTEMP(1);
          QTEMP4 = QTEMP(2);
          
          if ((isempty(QTEMP3)) | (QTEMP3 < 1))
           QTEMP3 = 1;
          end
          
          if ((isempty(QTEMP4)) | (QTEMP4 > QmatNMR.Size1D))
           QTEMP4 = QmatNMR.Size1D;
          end
          
          CSAlsq(QmatNMR.Axis1D(QTEMP3:QTEMP4).',real(QmatNMR.Spec1D(QTEMP3:QTEMP4).'));    %take the 1D spectrum into the fitting routine

%
%when the state of a popup button for symmtric tensors is changed, then we activate/deactivate the sigma_22 button
%
	elseif strcmp(command,'pop(1)')
          tel = 1;
          if (get(pop(tel), 'value') == 1) 	%is not a symmetric tensor
            set([ck((tel-1)*6+2) ed((tel-1)*6+2)], 'visible', 'on');
          else 					%tensor is forced to be symmetric
            set([ck((tel-1)*6+2) ed((tel-1)*6+2)], 'visible', 'off');
          end
	elseif strcmp(command,'pop(2)') 
          tel = 2;
          if (get(pop(tel), 'value') == 1) 	%is not a symmetric tensor
            set([ck((tel-1)*6+2) ed((tel-1)*6+2)], 'visible', 'on');
          else 					%tensor is forced to be symmetric
            set([ck((tel-1)*6+2) ed((tel-1)*6+2)], 'visible', 'off');
          end
	elseif strcmp(command,'pop(3)') 
          tel = 3;
          if (get(pop(tel), 'value') == 1) 	%is not a symmetric tensor
            set([ck((tel-1)*6+2) ed((tel-1)*6+2)], 'visible', 'on');
          else 					%tensor is forced to be symmetric
            set([ck((tel-1)*6+2) ed((tel-1)*6+2)], 'visible', 'off');
          end
	elseif strcmp(command,'pop(4)') 
          tel = 4;
          if (get(pop(tel), 'value') == 1) 	%is not a symmetric tensor
            set([ck((tel-1)*6+2) ed((tel-1)*6+2)], 'visible', 'on');
          else 					%tensor is forced to be symmetric
            set([ck((tel-1)*6+2) ed((tel-1)*6+2)], 'visible', 'off');
          end
	end 
end

if (get(zombut,'Value')==1)
ZoomMatNMR FitWindow on;
end
