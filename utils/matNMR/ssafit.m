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
function SSAfit(command) 
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
  [fitbut, simbut, ed, ck, TolBut, NrIterBut, noibut, noibute, zombut, redisbut, simplexbut, gradbut, gammabut, carrierbut, omegarbut, refreshbut, printbut, stopbut, verbbut] = SSApk_udata;

  if (get(zombut,'Value')==1)
    ZoomMatNMR FitWindow off;
  end

  SSAFitFigure = findobj(allchild(0), 'Tag', 'SSAFit');
  SSAFitAxis   = findobj(get(SSAFitFigure, 'children'), 'tag', 'SSAFitAxis');
  axes(SSAFitAxis);
end

if isstr(command) 
	if strcmp(command,'init') 
		SSApk_init
 		[fitbut, simbut, ed, ck, TolBut, NrIterBut, noibut, noibute, zombut, redisbut, simplexbut, gradbut, gammabut, carrierbut, omegarbut, refreshbut, printbut, stopbut, verbbut] = SSApk_udata;
                
		SSAFitFigure = findobj(0, 'Tag', 'SSAFit');
                SSAFitAxis   = findobj(allchild(SSAFitFigure), 'tag', 'SSAFitAxis');
		axes(SSAFitAxis);
                axis on
		set(SSAFitAxis, 'nextplot', 'replacechildren', ...
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
			 'tag', 'SSAFitAxis', ...
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
		  set(SSAFitAxis, 'XGrid','on', 'YGrid','on', 'XDir', 'reverse', ... 
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
		  set(SSAFitAxis, 'XGrid','on', 'YGrid','on', 'XDir', 'normal', ... 
		      'fontsize', QmatNMR.TextSize, 'fontname', QmatNMR.TextFont, 'fontangle', QmatNMR.TextAngle, 'fontweight', QmatNMR.TextWeight);

                  ymin = min(PFITDY);
                  ymax = max(PFITDY);
                  if ((ymin == 0) & (ymax == 0))
                    ymin = -1;
                    ymax = 1;
                  end
                  axis([min(PFITX) max(PFITX) (ymin-0.1*abs(ymin)) (ymax + 0.1*abs(ymax))]);
		end  
                setappdata(SSAFitAxis, 'ZoomLimitsMatNMR', [min(PFITX) max(PFITX) (ymin-0.1*abs(ymin)) (ymax + 0.1*abs(ymax))]);
                
                %
                %read out the current value for the carrier frequency from the main window
                %
                set(carrierbut, 'String', num2str(QmatNMR.SF1D, 10));
		
		disp('SSATENSORFIT succesfully initiated ...');
		
	elseif strcmp(command,'new') 		%when a fit window is already opened, just update the plot
	        set(SSAFitAxis, 'nextplot', 'replacechildren');

                axis on
		set(SSAFitAxis, ...
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
			 'tag', 'SSAFitAxis', ...
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
		  set(SSAFitAxis, 'XGrid','on', 'YGrid','on', 'XDir', 'reverse', ... 
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
		  set(SSAFitAxis, 'XGrid','on', 'YGrid','on', 'XDir', 'normal', ... 
		      'fontsize', QmatNMR.TextSize, 'fontname', QmatNMR.TextFont, 'fontangle', QmatNMR.TextAngle, 'fontweight', QmatNMR.TextWeight);

                  ymin = min(PFITDY);
                  ymax = max(PFITDY);
                  if ((ymin == 0) & (ymax == 0))
                    ymin = -1;
                    ymax = 1;
                  end
                  axis([min(PFITX) max(PFITX) (ymin-0.1*abs(ymin)) (ymax + 0.1*abs(ymax))]);
		end  
                setappdata(SSAFitAxis, 'ZoomLimitsMatNMR', [min(PFITX) max(PFITX) (ymin-0.1*abs(ymin)) (ymax + 0.1*abs(ymax))]);

                %
                %read out the current value for the carrier frequency from the main window
                %
                set(carrierbut, 'String', num2str(QmatNMR.SF1D, 10));

		
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
                NrGammaAngles = eval(get(gammabut, 'String'));
                
                Sigma_iso = eval(get(ed(1), 'String'));
                nu0 = eval(get(carrierbut, 'String'));
                nur = eval(get(omegarbut, 'String'));


                %
                %Then we read in all fit parameters
                %

                %
                %The simulation routine keeps track of which parameters are fitted and which values are constant
                %Here we create the appropriate data structure
                %
                Constants = fitssa;
                

                %
                %Now we fill in the parameters as either fit parameter or as a constant (depends on the check button)
                %
                ParamCounter = 0;
                if (get(ck(1), 'value'))      %keep delta constant
                  Constants.delta = eval(get(ed(2), 'String'));
                else
                  ParamCounter = ParamCounter + 1;
                  Parameters(ParamCounter) = eval(get(ed(2), 'String'));
                end

                if (get(ck(2), 'value'))      %keep eta constant
                  Constants.eta = eval(get(ed(3), 'String'));
                else
                  ParamCounter = ParamCounter + 1;
                  Parameters(ParamCounter) = eval(get(ed(3), 'String'));
                end

                if (get(ck(3), 'value'))      %keep Intensity constant
                  Constants.Intensity = eval(get(ed(4), 'String'));
                else
                  ParamCounter = ParamCounter + 1;
                  Parameters(ParamCounter) = eval(get(ed(4), 'String'));
                end


                %
                %start the fit
                %
                [ParametersOut, Error, Fit] = fitssa(PFITDY, PFITX, Parameters, Constants, nu0, nur, SIMPLEXflag, GRADIENTflag, NrGammaAngles, Epsilon, FitOptions, PlotIntermediate, NoFitFLAG);
                
                
                %
                %Add the carrier frequency, the MAS frequency and the isotropic shift to the results vector
                %
                ParametersOut = [ParametersOut nu0 nur Sigma_iso];
                
                
                %
                %show the final result and insert the parameter values into the corresponding UIcontrols
                %
                tmp = get(SSAFitAxis, 'nextplot');
                hold on
                delete(findobj(allchild(gcf), 'tag', 'SSAFitHandle'))
                if (PFITX(1) < PFITX(2))
                  SSAFitHandle = plot(PFITX, Fit, QmatNMR.color(rem(1, length(QmatNMR.color)) + 1));
                  set(SSAFitAxis, 'xdir', 'reverse');
                else
                  SSAFitHandle = plot(fliplr(PFITX), fliplr(Fit), QmatNMR.color(rem(1, length(QmatNMR.color)) + 1));
                  set(SSAFitAxis, 'xdir', 'normal');
                end
                set(SSAFitAxis, 'nextplot', tmp);
                set(SSAFitHandle, 'tag', 'SSAFitHandle')
                drawnow
                
                for tel2=1:3
                  set(ed(1+tel2), 'String', num2str(ParametersOut(tel2), 6));
                end
                %to update the principal components
                ssafit('ed');


                %
                %Store the fitted parameters in the workspace
                %
                if isfield(QmatNMR, 'SSAFitResults')
                  QmatNMR = rmfield(QmatNMR, 'SSAFitResults');
                end
                QmatNMR.SSAFitResults.Parameters 	= ParametersOut;
		QmatNMR.SSAFitResults.Fit 		= Fit;
		QmatNMR.SSAFitResults.Data 		= PFITDY;
		QmatNMR.SSAFitResults.Axis 		= PFITX;
		QmatNMR.SSAFitResults.Error		= Error;
		QmatNMR.SSAFitResults.Sigma 		= Epsilon;


                %
                %to store the results we need to make the designated variable global. In case the name
                %points to a structure variable, we need to use only the main variable, hence the following
                %check.
                %
                QTEMP = findstr(QmatNMR.VariableNameSSAFit, '.');
                if QTEMP
                  eval(['global ' QmatNMR.VariableNameSSAFit(1:(QTEMP-1))]);
                else
                 eval(['global ' QmatNMR.VariableNameSSAFit]);
                end
                eval([QmatNMR.VariableNameSSAFit ' = QmatNMR.SSAFitResults;']);

		fprintf(1, '\n\nFitting finished ...\nThe results have been written to "%s" in the MATLAB workspace.\nType "global %s" once to allow access to the variable\n\n', QmatNMR.VariableNameSSAFit, QmatNMR.VariableNameSSAFit);
		fprintf(1, 'For Matlab 7: use "cell2mat(cellfun(@(x) x,{%s.Parameters},''UniformOutput'', false)'')"\nto convert an array of structures into a matrix for further manipulation.\n\n', QmatNMR.VariableNameSSAFit);


	elseif strcmp(command,'zombut')
               if (get(zombut,'Value')==1)
                  ZoomMatNMR FitWindow on;
               elseif(get(zombut,'Value')==0)
                  ZoomMatNMR FitWindow off;  
               end


	elseif strcmp(command,'loadpars1')			%Load parameters input window
                QuiInput('Load fit parameters from the workspace :', ' OK | CANCEL', 'regelloadparsSSA', [], 'Name of variable :', QmatNMR.ViewNameSSAFit);

	elseif strcmp(command,'loadpars2')			%Load parameters input window callback
                QmatNMR.ViewNameSSAFit = QmatNMR.GetString;
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
                %write values to the UIcontrols
                %
                if (length(QmatNMR.InitialFitPars.Parameters) == 7)
                  %set the fixed values (carrier, MAS frequency and isotropic shift
                  set(carrierbut, 'String', num2str(QmatNMR.InitialFitPars.Parameters(5), 6));
                  set(omegarbut, 'String', num2str(QmatNMR.InitialFitPars.Parameters(6), 6));
                  set(ed(1), 'String', num2str(QmatNMR.InitialFitPars.Parameters(7), 6));

                  %
                  %set the constraints and the sigma if they were stored in the structure
                  %
                  if isfield(QmatNMR.InitialFitPars, 'Sigma')
                    set(noibute, 'string', num2str(QmatNMR.InitialFitPars.Sigma, 6));
                  end
                  
                  %set the fitted values
                  for tel2=1:3
                    set(ed(1+tel2), 'String', num2str(QmatNMR.InitialFitPars.Parameters(tel2), 6));
                  end
                  
                  %to update the principal components
                  ssafit('ed');

                else  
                  error('matNMR ERROR: the length of the vector is not correct !!');
                end



	elseif strcmp(command,'defvar1')			%Define variable name for Results
                QuiInput('Define Results Variable :', ' OK | CANCEL', 'regeldefvarSSA', [], 'Name of variable :', QmatNMR.VariableNameSSAFit);

	elseif strcmp(command,'defvar2')			%Define variable name for Results callback
                QmatNMR.VariableNameSSAFit = QmatNMR.uiInput1;
                %
                %to store the results we need to make the designated variable global. In case the name
                %points to a structure variable, we need to use only the main variable, hence the following
                %check.
                %
                QTEMP = findstr(QmatNMR.VariableNameSSAFit, '.');
                if QTEMP
                  eval(['global ' QmatNMR.VariableNameSSAFit(1:(QTEMP-1))]);
                else
  		  eval(['global ' QmatNMR.VariableNameSSAFit]);
                end
		eval([QmatNMR.VariableNameSSAFit ' = 1;']);
		disp('  ');
		disp(['matNMR NOTICE: new variable name "' QmatNMR.VariableNameSSAFit '" defined for SSArupole-tensor fitting results. ']);
		disp(['matNMR NOTICE: To be able to access this variable please type:']);
		disp('  ');
                if QTEMP
		  disp(['               global ' QmatNMR.VariableNameSSAFit(1:(QTEMP-1))]);
                else
		  disp(['               global ' QmatNMR.VariableNameSSAFit]);
                end
		disp('  ');



	elseif strcmp(command,'view1')			%View Fit Results input window
                QuiInput('View Fit Results :', ' OK | CANCEL', 'regelviewresultsSSA', [], 'Name of variable :', QmatNMR.ViewNameSSAFit);

	elseif strcmp(command,'view2')			%View Fit Results input window callback
                QmatNMR.ViewNameSSAFit = QmatNMR.GetString;
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
                if (length(QmatNMR.InitialFitPars.Parameters) == 7)
                  %
                  %write values to the console window
                  %
                  fprintf(1, '\n\nFit results (spinning sideband amplitudes): \n\ndelta = %7.2f ppm, eta = %7.2f, Intensity = %7.2f \n', QmatNMR.InitialFitPars.Parameters(1:3));
                  fprintf(1, 'using :  omega0/(2pi) = %7.2f MHz, omegar/(2pi) = %7.2f kHz, Sigma_iso = %7.2f ppm\n', QmatNMR.InitialFitPars.Parameters(5:7));
                  fprintf(1, 'Chi^2 : ERROR = %10.5g \n\n', QmatNMR.InitialFitPars.Parameters(4));

                  %
                  %write values to the UIcontrols
                  %
                  %set the fixed values (carrier, MAS frequency and isotropic shift
                  set(carrierbut, 'String', num2str(QmatNMR.InitialFitPars.Parameters(5), 6));
                  set(omegarbut, 'String', num2str(QmatNMR.InitialFitPars.Parameters(6), 6));
                  set(ed(1), 'String', num2str(QmatNMR.InitialFitPars.Parameters(7), 6));

                  %
                  %set the constraints and the sigma if they were stored in the structure
                  %
                  if isfield(QmatNMR.InitialFitPars, 'Sigma')
                    set(noibute, 'string', num2str(QmatNMR.InitialFitPars.Sigma, 6));
                  end
                  
                  %set the fitted values
                  for tel2=1:3
                    set(ed(1+tel2), 'String', num2str(QmatNMR.InitialFitPars.Parameters(tel2), 6));
                  end
                  
                  %to update the principal components
                  ssafit('ed');


                  %
                  %plot the data and fit
                  %
                  PFITX  = QmatNMR.InitialFitPars.Axis;
                  PFITDY = QmatNMR.InitialFitPars.Data;
                  Fit    = QmatNMR.InitialFitPars.Fit;
                  set(SSAFitAxis, 'nextplot', 'replacechildren');
                  axis on
                  set(SSAFitAxis, ...
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
  			 'tag', 'SSAFitAxis', ...
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
                    set(SSAFitAxis, 'XGrid','on', 'YGrid','on', 'XDir', 'reverse', ... 
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
                    set(SSAFitAxis, 'XGrid','on', 'YGrid','on', 'XDir', 'normal', ... 
  		      'fontsize', QmatNMR.TextSize, 'fontname', QmatNMR.TextFont, 'fontangle', QmatNMR.TextAngle, 'fontweight', QmatNMR.TextWeight);
  
                    ymin = min(PFITDY);
                    ymax = max(PFITDY);
                    if ((ymin == 0) & (ymax == 0))
                      ymin = -1;
                      ymax = 1;
                    end
                    axis([min(PFITX) max(PFITX) (ymin-0.1*abs(ymin)) (ymax + 0.1*abs(ymax))]);
                  end  
                  setappdata(SSAFitAxis, 'ZoomLimitsMatNMR', [min(PFITX) max(PFITX) (ymin-0.1*abs(ymin)) (ymax + 0.1*abs(ymax))]);


                  tmp = get(SSAFitAxis, 'nextplot');
                  hold on
                  delete(findobj(allchild(gcf), 'tag', 'SSAFitHandle'))
                  if (PFITX(1) < PFITX(2))
                    SSAFitHandle = plot(PFITX, Fit, QmatNMR.color(rem(1, length(QmatNMR.color)) + 1));
                    set(SSAFitAxis, 'xdir', 'reverse');
                  else
                    SSAFitHandle = plot(fliplr(PFITX), fliplr(Fit), QmatNMR.color(rem(1, length(QmatNMR.color)) + 1));
                    set(SSAFitAxis, 'xdir', 'normal');
                  end
                  set(SSAFitAxis, 'nextplot', tmp);
                  set(SSAFitHandle, 'tag', 'SSAFitHandle')
                  drawnow
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

          %
          %only allow axes in points since the axis denotes the index of the sideband
          %
          if (QmatNMR.Rincr ~= 1)
            beep
            disp('matNMR WARNING: axis vector doesn''t correspond to increasing indices of sidebands. Aborting ...')
            return
          end

          SSAlsq(QmatNMR.Axis1D(QTEMP3:QTEMP4).',real(QmatNMR.Spec1D(QTEMP3:QTEMP4).'));    %take the 1D spectrum into the fitting routine


%
%when the state the parameter buttons is changed, then we update the corresponding buttons
%
	elseif strcmp(command,'ed')
          sigma_iso = eval(get(ed(1), 'String'));
          delta = eval(get(ed(2), 'String'));
          eta = eval(get(ed(3), 'String'));
          %constrain eta between 0 and 1
          eta=abs(eta);
          if (eta > 1)
            eta=1;
          end
          
          sigma_33 = sigma_iso + delta;
          sigma_22 = sigma_iso + delta * (eta - 1.0)/2;
          sigma_11 = sigma_iso - delta * (eta + 1.0)/2;

          set(ed(2), 'string', num2str(delta, 6));
          set(ed(3), 'string', num2str(eta, 6));
          set(ed(5), 'string', num2str(sigma_11, 6));
          set(ed(6), 'string', num2str(sigma_22, 6));
          set(ed(7), 'string', num2str(sigma_33, 6));
	end 
end

if (get(zombut,'Value')==1)
ZoomMatNMR FitWindow on;
end
