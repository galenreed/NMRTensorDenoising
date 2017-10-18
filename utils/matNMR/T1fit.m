function T1fit(command) 
%  T1fit.m 
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
% 1-1-'97
%
global PFITX PFITDY PFITFY PFIT_LAMBDA Pverbose Pstdv QmatNMR

if nargin == 0 
	command = 'init';
end 

if ~ strcmp(command,'init'), 
  [ed,ck, fitbut, TolBut, NrIterBut, redisbut, lijstbut, simplexbut, stopbut, printbut, refreshbut, logbut, txt1, txt2, txt5, txt6, txt7, txt8, txt9, txt10, txt11, logbut2] = T1pk_udata;

  T1FitAxis=findobj(allchild(gcf), 'tag', 'T1FitAxis');
  axes(T1FitAxis);
end

if isstr(command) 
	if strcmp(command,'init') 
		T1pk_init
		[ed,ck, fitbut, TolBut, NrIterBut, redisbut, lijstbut, simplexbut, stopbut, printbut, refreshbut, logbut, txt1, txt2, txt5, txt6, txt7, txt8, txt9, txt10, txt11, logbut2] = T1pk_udata;
		T1pk_inivl(ck,ed);
		
                Pstdv = 1.0;
         	Pverbose(1)=0;    %This will NOT tell them the results
	        Pverbose(2)=1;    %This will replot each loop
	        Pverbose(3)=1;
                
                T1FitAxis=findobj(get(gcf, 'children'), 'tag', 'T1FitAxis');
		axes(T1FitAxis);

		plot(PFITX, PFITDY, [QmatNMR.LineColor 'p--']);
                axis on
		set(T1FitAxis, 'nextplot', 'replacechildren', ...
	             'units', 'normalized', ...
	             'position',[0.05 0.32 .9 .62], ...
		     'nextplot', 'replacechildren', ...
                     'XGrid','on', ...
		     'YGrid','on', ...
		     'FontSize', QmatNMR.TextSize, ...
		     'FontName', QmatNMR.TextFont, ...
		     'FontAngle', QmatNMR.TextAngle, ...
		     'FontWeight', QmatNMR.TextWeight, ...
		     'LineWidth', QmatNMR.LineWidth, ...
		     'visible','on', ...
		     'tag', 'T1FitAxis', ...
		     'view', [0 90], ...
		     'color', QmatNMR.ColorScheme.AxisBack, ...
		     'xcolor', QmatNMR.ColorScheme.AxisFore, ...
		     'ycolor', QmatNMR.ColorScheme.AxisFore, ...
		     'zcolor', QmatNMR.ColorScheme.AxisFore, ...
		     'visible', 'on', ...
		     'xscale', 'linear', ...
		     'zscale', 'linear', ...
		     'xtickmode', 'auto', ...
		     'ytickmode', 'auto', ...
		     'ztickmode', 'auto', ...
		     'xticklabelmode', 'auto', ...
		     'yticklabelmode', 'auto', ...
		     'zticklabelmode', 'auto', ...
		     'selected', 'off', ...
		     'xdir', 'normal', ...
		     'ydir', 'normal', ...
		     'zdir', 'normal', ...
		     'userdata', 1, ...
		     'box', 'on');
		title('', 'Color', QmatNMR.ColorScheme.AxisFore);

                %
                %determine plot limits
                %
                ymin = min(PFITDY);
                ymax = max(PFITDY);
                if ((ymin == 0) & (ymax == 0))
                  ymin = -1;
                  ymax = 1;
                elseif (ymin == 0)
                  ymin = 1e-14;
                end
		%
                %set yscale type and axis limits according to the users' wishes
                %
                if (get(logbut, 'value'))
                  set(T1FitAxis, 'yscale', 'log');
                  QTEMP = abs(max(PFITX) - min(PFITX));
                  axis([min(PFITX)-QTEMP/20 max(PFITX)+QTEMP/20 (ymin-(10^floor(log10(abs(ymin)))/2)) (1.5*ymax)]);
                  setappdata(T1FitAxis, 'ZoomLimitsMatNMR', [min(PFITX)-QTEMP/20 max(PFITX)+QTEMP/20 (ymin-(10^floor(log10(abs(ymin)))/2)) (1.5*ymax)]);

                else
                  set(T1FitAxis, 'yscale', 'linear');
                  QTEMP = abs(max(PFITX) - min(PFITX));
                  axis([min(PFITX)-QTEMP/20 max(PFITX)+QTEMP/20 (ymin-0.1*ymax) (1.1*ymax)]);
                  setappdata(T1FitAxis, 'ZoomLimitsMatNMR', [min(PFITX)-QTEMP/20 max(PFITX)+QTEMP/20 (ymin-0.1*ymax) (1.1*ymax)]);
                end

                if (get(logbut2, 'value'))
                  set(T1FitAxis, 'xscale', 'log');
                else
                  set(T1FitAxis, 'xscale', 'linear');
                end

                ZoomMatNMR FitWindow on
		xlabel('time');
		
		disp('T1fit succesfully initiated ...');
		
	elseif strcmp(command,'new') 		%when a fit window is already opened, just update the plot
		plot(PFITX, PFITDY, [QmatNMR.LineColor 'p--']);
                axis on
		set(T1FitAxis, 'nextplot', 'replacechildren', ...
	             'units', 'normalized', ...
	             'position',[0.05 0.32 .9 .62], ...
		     'nextplot', 'replacechildren', ...
                     'XGrid','on', ...
		     'YGrid','on', ...
		     'FontSize', QmatNMR.TextSize, ...
		     'FontName', QmatNMR.TextFont, ...
		     'FontAngle', QmatNMR.TextAngle, ...
		     'FontWeight', QmatNMR.TextWeight, ...
		     'LineWidth', QmatNMR.LineWidth, ...
		     'visible','on', ...
		     'tag', 'T1FitAxis', ...
		     'view', [0 90], ...
		     'color', QmatNMR.ColorScheme.AxisBack, ...
		     'xcolor', QmatNMR.ColorScheme.AxisFore, ...
		     'ycolor', QmatNMR.ColorScheme.AxisFore, ...
		     'zcolor', QmatNMR.ColorScheme.AxisFore, ...
		     'visible', 'on', ...
		     'xscale', 'linear', ...
		     'zscale', 'linear', ...
		     'xtickmode', 'auto', ...
		     'ytickmode', 'auto', ...
		     'ztickmode', 'auto', ...
		     'xticklabelmode', 'auto', ...
		     'yticklabelmode', 'auto', ...
		     'zticklabelmode', 'auto', ...
		     'selected', 'off', ...
		     'xdir', 'normal', ...
		     'ydir', 'normal', ...
		     'zdir', 'normal', ...
		     'userdata', 1, ...
		     'box', 'on');
		title('', 'Color', QmatNMR.ColorScheme.AxisFore);

                %
                %determine plot limits
                %
                ymin = min(PFITDY);
                ymax = max(PFITDY);
                if ((ymin == 0) & (ymax == 0))
                  ymin = -1;
                  ymax = 1;
                elseif (ymin == 0)
                  ymin = 1e-14;
                end
		%
                %set yscale type and axis limits according to the users' wishes
                %
                if (get(logbut, 'value'))
                  set(T1FitAxis, 'yscale', 'log');
                  QTEMP = abs(max(PFITX) - min(PFITX));
                  axis([min(PFITX)-QTEMP/20 max(PFITX)+QTEMP/20 (ymin-(10^floor(log10(abs(ymin)))/2)) (1.5*ymax)]);
                  setappdata(T1FitAxis, 'ZoomLimitsMatNMR', [min(PFITX)-QTEMP/20 max(PFITX)+QTEMP/20 (ymin-(10^floor(log10(abs(ymin)))/2)) (1.5*ymax)]);

                else
                  set(T1FitAxis, 'yscale', 'linear');
                  QTEMP = abs(max(PFITX) - min(PFITX));
                  axis([min(PFITX)-QTEMP/20 max(PFITX)+QTEMP/20 (ymin-0.1*ymax) (1.1*ymax)]);
                  setappdata(T1FitAxis, 'ZoomLimitsMatNMR', [min(PFITX)-QTEMP/20 max(PFITX)+QTEMP/20 (ymin-0.1*ymax) (1.1*ymax)]);
                end
                if (get(logbut2, 'value'))
                  set(T1FitAxis, 'xscale', 'log');
                else
                  set(T1FitAxis, 'xscale', 'linear');
                end

                ZoomMatNMR FitWindow on

		xlabel('time');

		T1pk_inivl(ck,ed);
		
	elseif strcmp(command,'fitbut') 
		
  		PFIT_LAMBDA=[]; 
		if abs(str2num(get(ed(7),'String'))) > 0,
			lam_len= 8;
		elseif abs(str2num(get(ed(5),'String'))) > 0,
			lam_len= 6;
		elseif abs(str2num(get(ed(3),'String'))) > 0,
			lam_len= 4;
		elseif abs(str2num(get(ed(1),'String'))) > 0,
			lam_len= 2;
		end
			
		%
                %read the standard deviation of the noise from the edit button
                %
                Pstdv = 1.0 / eval(get(ed(11), 'string'));
                
		PFIT_LAMBDA=zeros(1,lam_len);
		for i=1:lam_len,
			PFIT_LAMBDA(i)= str2num(get(ed(i),'String'));
		end
		lam_len=lam_len+1;
		PFIT_LAMBDA(lam_len)= str2num(get(ed(9),'String'));
		lam_len=lam_len+1;
		PFIT_LAMBDA(lam_len)= str2num(get(ed(10),'String'));
	
			constrain=T1pk_gtcon(ck,lam_len);%which variables need to be fitted and which not ?
			npts=length(PFITX);
	        	wt=Pstdv * ones(npts,1);
			PFITFY=T1pk_qvt(PFITX,PFIT_LAMBDA);
		
			plot(PFITX, PFITDY, [QmatNMR.LineColor 'p--'], PFITX, PFITFY, QmatNMR.color(rem(1, length(QmatNMR.color)) + 1));
                        axis on
        		set(T1FitAxis, 'nextplot', 'replacechildren', ...
        	             'units', 'normalized', ...
        	             'position',[0.05 0.32 .9 .62], ...
        		     'nextplot', 'replacechildren', ...
                             'XGrid','on', ...
        		     'YGrid','on', ...
        		     'FontSize', QmatNMR.TextSize, ...
        		     'FontName', QmatNMR.TextFont, ...
        		     'FontAngle', QmatNMR.TextAngle, ...
        		     'FontWeight', QmatNMR.TextWeight, ...
        		     'LineWidth', QmatNMR.LineWidth, ...
        		     'visible','on', ...
        		     'tag', 'T1FitAxis', ...
        		     'view', [0 90], ...
        		     'color', QmatNMR.ColorScheme.AxisBack, ...
        		     'xcolor', QmatNMR.ColorScheme.AxisFore, ...
        		     'ycolor', QmatNMR.ColorScheme.AxisFore, ...
        		     'zcolor', QmatNMR.ColorScheme.AxisFore, ...
        		     'visible', 'on', ...
        		     'xscale', 'linear', ...
        		     'zscale', 'linear', ...
        		     'xtickmode', 'auto', ...
        		     'ytickmode', 'auto', ...
        		     'ztickmode', 'auto', ...
        		     'xticklabelmode', 'auto', ...
        		     'yticklabelmode', 'auto', ...
        		     'zticklabelmode', 'auto', ...
        		     'selected', 'off', ...
        		     'xdir', 'normal', ...
        		     'ydir', 'normal', ...
        		     'zdir', 'normal', ...
        		     'userdata', 1, ...
        		     'box', 'on');
        		title('', 'Color', QmatNMR.ColorScheme.AxisFore);

                        %
                        %determine plot limits
                        %
                        ymin = min(PFITDY);
                        ymax = max(PFITDY);
                        if ((ymin == 0) & (ymax == 0))
                          ymin = -1;
                          ymax = 1;
                        elseif (ymin == 0)
                          ymin = 1e-14;
                        end
			%
                        %set yscale type and axis limits according to the users' wishes
                        %
                        if (get(logbut, 'value'))
                          set(T1FitAxis, 'yscale', 'log');
                          QTEMP = abs(max(PFITX) - min(PFITX));
                          axis([min(PFITX)-QTEMP/20 max(PFITX)+QTEMP/20 (ymin-(10^floor(log10(abs(ymin)))/2)) (1.5*ymax)]);
                          setappdata(T1FitAxis, 'ZoomLimitsMatNMR', [min(PFITX)-QTEMP/20 max(PFITX)+QTEMP/20 (ymin-(10^floor(log10(abs(ymin)))/2)) (1.5*ymax)]);

                        else
                          set(T1FitAxis, 'yscale', 'linear');
                          QTEMP = abs(max(PFITX) - min(PFITX));
                          axis([min(PFITX)-QTEMP/20 max(PFITX)+QTEMP/20 (ymin-0.1*ymax) (1.1*ymax)]);
                          setappdata(T1FitAxis, 'ZoomLimitsMatNMR', [min(PFITX)-QTEMP/20 max(PFITX)+QTEMP/20 (ymin-0.1*ymax) (1.1*ymax)]);
                        end

                        if (get(logbut2, 'value'))
                          set(T1FitAxis, 'xscale', 'log');
                        else
                          set(T1FitAxis, 'xscale', 'linear');
                        end

                        ZoomMatNMR FitWindow on

        	        drawnow;
			set(gcf,'Pointer','watch');
		
			FITtol = str2num(get(TolBut, 'String'));
			FITMaxIter = str2num(get(NrIterBut, 'String'));
		
                        tic;
			[PFITFY,PFIT_LAMBDA,kvg,iter,corp,covp,covr,stdresid,Z,r2]= ...
			T1leasqr(PFITX,PFITDY,PFIT_LAMBDA,'T1pk_qvt',FITtol,FITMaxIter,wt,constrain,'T1pk_qvtdf');
                        toc;
	
			set(gcf,'Pointer','arrow');
			
                        if (get(logbut2, 'value'))
                          set(T1FitAxis, 'xscale', 'log');
                        else
                          set(T1FitAxis, 'xscale', 'linear');
                        end

			chi2= sum(((PFITDY-PFITFY).*wt).^2)/(npts-lam_len);
			fprintf(1, 'Chisqr= %g\n',chi2);

			for i=1:lam_len-2,
				set(ed(i),'String',num2str(PFIT_LAMBDA(i), 6));
			end
			set(ed(9),'String',num2str(PFIT_LAMBDA(lam_len-1), 6));
			set(ed(10), 'String',num2str(PFIT_LAMBDA(lam_len), 6));
			
						%The matrix with the fit results is built up like :
						% 	- fit parameters :
						%		- For each exponential
						%			- coefficient
						%			- time constant
						%		- constant
						%		- amplitude
						%

			Ptemp = [PFIT_LAMBDA];
			QmatNMR.T1FitArray = PFITFY';
		
                %
                %Store the fit into a structure variable
                %
                if isfield(QmatNMR, 'T1FitResults')
                  QmatNMR = rmfield(QmatNMR, 'T1FitResults');
                end
		QmatNMR.T1FitResults.Parameters  = Ptemp;
		QmatNMR.T1FitResults.Fit 	 = PFITFY;
		QmatNMR.T1FitResults.Data 	 = PFITDY;
		QmatNMR.T1FitResults.Axis 	 = PFITX;
		QmatNMR.T1FitResults.Error	 = chi2;
		QmatNMR.T1FitResults.Sigma	 = Pstdv;
		QmatNMR.T1FitResults.Constraints = cell2mat(get(ck([1:(lam_len-2) 9 10]), 'value'));

                %
                %to store the results we need to make the designated variable global. In case the name
                %points to a structure variable, we need to use only the main variable, hence the following
                %check.
                %
                QTEMP = findstr(QmatNMR.VariableNameT1Fit, '.');
                if QTEMP
                  eval(['global ' QmatNMR.VariableNameT1Fit(1:(QTEMP-1))]);
                else
  		  eval(['global ' QmatNMR.VariableNameT1Fit]);
                end
		eval([QmatNMR.VariableNameT1Fit ' = QmatNMR.T1FitResults';]);

		fprintf(1, '\n\nFitting finished ...\nThe results have been written to "%s" in the MATLAB workspace.\nType "global %s" once to allow access to the variable\n\n', QmatNMR.VariableNameT1Fit, QmatNMR.VariableNameT1Fit);
		fprintf(1, 'For Matlab 7: use "cell2mat(cellfun(@(x) x,{%s.Parameters},''UniformOutput'', false)'')"\nto convert an array of structures into a matrix for further manipulation.\n\n', QmatNMR.VariableNameT1Fit);
	
		

	elseif strcmp(command,'redisbut')
               val = get(redisbut,'Value');
               if val == 1
                  Pverbose(2) = 0;
               elseif val == 2
                  Pverbose(2) = 1;
               elseif val == 3
                  Pverbose(2) = 5;
               elseif val == 4
                  Pverbose(2) = 10;
               elseif val == 5
                  Pverbose(2) = 25;
               elseif val == 6
                  Pverbose(2) = 50;
               elseif val == 7
                  Pverbose(2) = 100;
               end
	
		

	elseif strcmp(command,'logbut')
                %
                %determine plot limits
                %
                ymin = min(PFITDY);
                ymax = max(PFITDY);
                if ((ymin == 0) & (ymax == 0))
                  ymin = -1;
                  ymax = 1;
                elseif (ymin == 0)
                  ymin = 1e-14;
                end
		%
                %set yscale type and axis limits according to the users' wishes
                %
                if (get(logbut, 'value'))
                  set(T1FitAxis, 'yscale', 'log');
                  QTEMP = abs(max(PFITX) - min(PFITX));
                  axis([min(PFITX)-QTEMP/20 max(PFITX)+QTEMP/20 (ymin-(10^floor(log10(abs(ymin)))/2)) (1.5*ymax)]);
                  setappdata(T1FitAxis, 'ZoomLimitsMatNMR', [min(PFITX)-QTEMP/20 max(PFITX)+QTEMP/20 (ymin-(10^floor(log10(abs(ymin)))/2)) (1.5*ymax)]);

                else
                  set(T1FitAxis, 'yscale', 'linear');
                  QTEMP = abs(max(PFITX) - min(PFITX));
                  axis([min(PFITX)-QTEMP/20 max(PFITX)+QTEMP/20 (ymin-0.1*ymax) (1.1*ymax)]);
                  setappdata(T1FitAxis, 'ZoomLimitsMatNMR', [min(PFITX)-QTEMP/20 max(PFITX)+QTEMP/20 (ymin-0.1*ymax) (1.1*ymax)]);
                end

                ZoomMatNMR FitWindow on
               
               
	elseif strcmp(command,'lijstbut')			%Button for extended output for each fit
               Pverbose(1) = get(lijstbut,'Value');

	elseif strcmp(command,'simplexbut')			%Button for Simplex prefit
               Pverbose(3) = get(simplexbut,'Value');

	elseif strcmp(command,'loadpars1')			%Load parameters input window
                QuiInput('Load fit parameters from the workspace :', ' OK | CANCEL', 'regelloadparsT1;', [], 'Name of variable :', QmatNMR.ViewNameT1Fit);

	elseif strcmp(command,'loadpars2')			%Load parameters input window callback
                QmatNMR.ViewNameT1Fit = QmatNMR.GetString;
                QmatNMR.InitialFitPars = QmatNMR.GetVar;
                %
                %due to a change in the way the parameters are stored we need to ensure backward compatibility
                %
                if ~isstruct(QmatNMR.InitialFitPars)
                  %
                  %convert the variable to the new structure
                  %
                  QmatNMR.InitialFitPars.Parameters = QmatNMR.InitialFitPars(2:end);

                elseif ~isfield(QmatNMR.InitialFitPars, 'Parameters')
                  disp('matNMR WARNING: incorrect variable structure for fit parameters. Aborting ...')
                  beep
                  return
                end

                %
                %continue
                %
		QTEMP9 = length(QmatNMR.InitialFitPars.Parameters);

                if (mod((QTEMP9-2), 2) == 0)
                  for teller=1:9		%First clear the old values
                    set(ed(teller), 'String', '');
                  end
                    
                                                %Then put in the new values  
                  npeaks = ((QTEMP9-2) / 2);
                    
                  for teller=1:(QTEMP9-2)
                    set(ed(teller), 'String', num2str(QmatNMR.InitialFitPars.Parameters(teller), 6));
                  end

                  set(ed(9), 'String', num2str(QmatNMR.InitialFitPars.Parameters(QTEMP9-1), 6));
                  set(ed(10), 'String', num2str(QmatNMR.InitialFitPars.Parameters(QTEMP9), 6));
                  
                  %
                  %set the constraints and the sigma if they were stored in the structure
                  %
                  if isfield(QmatNMR.InitialFitPars, 'Sigma')
                    set(ed(11), 'string', num2str(QmatNMR.InitialFitPars.Sigma, 6));
                  end
                  
                  if isfield(QmatNMR.InitialFitPars, 'Constraints')
                    for teller=1:(length(QmatNMR.InitialFitPars.Constraints)-2)
                      set(ck(teller), 'value', QmatNMR.InitialFitPars.Constraints(teller));
                    end
                    set(ck(9), 'value', QmatNMR.InitialFitPars.Constraints(end-1));
                    set(ck(10), 'value', QmatNMR.InitialFitPars.Constraints(end));
                  end
                  
                else  
                  error('matNMR ERROR: the length of the vector is not correct !!');
                end



	elseif strcmp(command,'defvar1')			%Define variable name for Results
                QuiInput('Define Results Variable :', ' OK | CANCEL', 'regeldefvarT1;', [], 'Name of variable :', QmatNMR.VariableNameT1Fit);

	elseif strcmp(command,'defvar2')			%Define variable name for Results callback
                QmatNMR.VariableNameT1Fit = QmatNMR.uiInput1;
                %
                %to store the results we need to make the designated variable global. In case the name
                %points to a structure variable, we need to use only the main variable, hence the following
                %check.
                %
                QTEMP = findstr(QmatNMR.VariableNameT1Fit, '.');
                if QTEMP
                  eval(['global ' QmatNMR.VariableNameT1Fit(1:(QTEMP-1))]);
                else
  		  eval(['global ' QmatNMR.VariableNameT1Fit]);
                end
		eval(['global ' QmatNMR.VariableNameT1Fit]);
		eval([QmatNMR.VariableNameT1Fit ' = 1;']);
		disp('  ');
		disp(['matNMR NOTICE: new variable name "' QmatNMR.VariableNameT1Fit '" defined for T1 fitting results. ']);
		disp(['matNMR NOTICE: To be able to access this variable please type:']);
		disp('  ');
                if QTEMP
  		  disp(['               global ' QmatNMR.VariableNameT1Fit(1:(QTEMP-1))]);
                else
  		  disp(['               global ' QmatNMR.VariableNameT1Fit]);
                end
		disp('  ');



	elseif strcmp(command,'view1')			%View Fit Results input window
                QuiInput('View Fit Results :', ' OK | CANCEL', 'regelviewresultsT1;', [], 'Name of variable :', QmatNMR.ViewNameT1Fit);

	elseif strcmp(command,'view2')			%View Fit Results input window callback
                QmatNMR.ViewNameT1Fit = QmatNMR.GetString;
                QmatNMR.InitialFitPars = QmatNMR.GetVar;
                %
                %due to a change in the way the parameters are stored we need to ensure backward compatibility
                %
                if ~isstruct(QmatNMR.InitialFitPars)
                  %
                  %convert the variable to the new structure
                  %
                  QmatNMR.InitialFitPars.Parameters = QmatNMR.InitialFitPars(2:end);

                else
                  if ~isfield(QmatNMR.InitialFitPars, 'Parameters')
                    disp('matNMR WARNING: incorrect variable structure for fit parameters. Aborting ...')
                    beep
                    return

                  else
                    %
                    %import the data so it can be fitted again
                    %
                    PFITX = QmatNMR.InitialFitPars.Axis;
                    PFITDY = QmatNMR.InitialFitPars.Data;


                    %
                    %Plot the data in the figure window for the new format
                    %
                    plot(QmatNMR.InitialFitPars.Axis, QmatNMR.InitialFitPars.Data, [QmatNMR.LineColor 'p'], QmatNMR.InitialFitPars.Axis, QmatNMR.InitialFitPars.Fit, QmatNMR.color(rem(1, length(QmatNMR.color)) + 1));

                    axis on
                    set(T1FitAxis, 'nextplot', 'replacechildren', ...
    	             'units', 'normalized', ...
    	             'position',[0.05 0.32 .9 .62], ...
    		     'nextplot', 'replacechildren', ...
                         'XGrid','on', ...
    		     'YGrid','on', ...
    		     'FontSize', QmatNMR.TextSize, ...
    		     'FontName', QmatNMR.TextFont, ...
    		     'FontAngle', QmatNMR.TextAngle, ...
    		     'FontWeight', QmatNMR.TextWeight, ...
    		     'LineWidth', QmatNMR.LineWidth, ...
    		     'visible','on', ...
    		     'tag', 'T1FitAxis', ...
    		     'view', [0 90], ...
    		     'color', QmatNMR.ColorScheme.AxisBack, ...
    		     'xcolor', QmatNMR.ColorScheme.AxisFore, ...
    		     'ycolor', QmatNMR.ColorScheme.AxisFore, ...
    		     'zcolor', QmatNMR.ColorScheme.AxisFore, ...
    		     'visible', 'on', ...
    		     'xscale', 'linear', ...
    		     'zscale', 'linear', ...
    		     'xtickmode', 'auto', ...
    		     'ytickmode', 'auto', ...
    		     'ztickmode', 'auto', ...
    		     'xticklabelmode', 'auto', ...
    		     'yticklabelmode', 'auto', ...
    		     'zticklabelmode', 'auto', ...
    		     'selected', 'off', ...
    		     'xdir', 'normal', ...
    		     'ydir', 'normal', ...
    		     'zdir', 'normal', ...
    		     'userdata', 1, ...
    		     'box', 'on');
                    title('', 'Color', QmatNMR.ColorScheme.AxisFore);
    
                    %
                    %determine plot limits
                    %
                    ymin = min(QmatNMR.InitialFitPars.Data);
                    ymax = max(QmatNMR.InitialFitPars.Data);
                    if ((ymin == 0) & (ymax == 0))
                      ymin = -1;
                      ymax = 1;
                    elseif (ymin == 0)
                      ymin = 1e-14;
                    end
                    %
                    %set yscale type and axis limits according to the users' wishes
                    %
                    if (get(logbut, 'value'))
                      set(T1FitAxis, 'yscale', 'log');
                      QTEMP = abs(max(QmatNMR.InitialFitPars.Axis) - min(QmatNMR.InitialFitPars.Axis));
                      axis([min(QmatNMR.InitialFitPars.Axis)-QTEMP/20 max(QmatNMR.InitialFitPars.Axis)+QTEMP/20 (ymin-(10^floor(log10(abs(ymin)))/2)) (1.5*ymax)]);
                      setappdata(T1FitAxis, 'ZoomLimitsMatNMR', [min(QmatNMR.InitialFitPars.Axis)-QTEMP/20 max(QmatNMR.InitialFitPars.Axis)+QTEMP/20 (ymin-(10^floor(log10(abs(ymin)))/2)) (1.5*ymax)]);
    
                    else
                      set(T1FitAxis, 'yscale', 'linear');
                      QTEMP = abs(max(QmatNMR.InitialFitPars.Axis) - min(QmatNMR.InitialFitPars.Axis));
                      axis([min(QmatNMR.InitialFitPars.Axis)-QTEMP/20 max(QmatNMR.InitialFitPars.Axis)+QTEMP/20 (ymin-0.1*ymax) (1.1*ymax)]);
                      setappdata(T1FitAxis, 'ZoomLimitsMatNMR', [min(QmatNMR.InitialFitPars.Axis)-QTEMP/20 max(QmatNMR.InitialFitPars.Axis)+QTEMP/20 (ymin-0.1*ymax) (1.1*ymax)]);
                    end
    
                    if (get(logbut2, 'value'))
                      set(T1FitAxis, 'xscale', 'log');
                    else
                      set(T1FitAxis, 'xscale', 'linear');
                    end

                    ZoomMatNMR FitWindow on
                    xlabel('time');
                  end
                end

                %
                %continue with showing the parameters in the Matlab root window
                %
		QTEMP9 = length(QmatNMR.InitialFitPars.Parameters);

                if (mod((QTEMP9-2), 2) == 0)
                  npeaks = ((QTEMP9-2) / 2);

                  s1 = sprintf('T1 Fit Results of variable "%s" :\n\n   Number of Exponentials  =  %d\n   Chi^2 =  %4.5f\n', QmatNMR.uiInput1, npeaks, QmatNMR.InitialFitPars.Error);
                  
                  for teller = 1:npeaks
                    s2 = sprintf('   Exponential %d:   Coefficient = %0.7g\n                    T1          = %6.2f\n', ...
                                 teller, QmatNMR.InitialFitPars.Parameters(1+((teller-1)*2)), QmatNMR.InitialFitPars.Parameters(2+((teller-1)*2)));
		    s1 = str2mat(s1, s2); 
                  end
                  
                  s3 = sprintf('   Constant  =  %0.5g\n   Amplitude =  %0.7g\n\n\n', QmatNMR.InitialFitPars.Parameters(QTEMP9-1), QmatNMR.InitialFitPars.Parameters(QTEMP9));
                  s1 = str2mat(s1, s3);

                  disp(s1);


                  %
                  %finally we show the parameters in the UIcontrols in the window
                  %
                  for teller=1:9		%First clear the old values
                    set(ed(teller), 'String', '');
                  end
                    
                                                %Then put in the new values  
                  npeaks = ((QTEMP9-2) / 2);
                    
                  for teller=1:(QTEMP9-2)
                    set(ed(teller), 'String', num2str(QmatNMR.InitialFitPars.Parameters(teller), 6));
                  end

                  set(ed(9), 'String', num2str(QmatNMR.InitialFitPars.Parameters(QTEMP9-1), 6));
                  set(ed(10), 'String', num2str(QmatNMR.InitialFitPars.Parameters(QTEMP9), 6));

                  
                  %
                  %set the constraints and the sigma if they were stored in the structure
                  %
                  if isfield(QmatNMR.InitialFitPars, 'Sigma')
                    set(ed(11), 'string', num2str(QmatNMR.InitialFitPars.Sigma, 6));
                  end
                  
                  if isfield(QmatNMR.InitialFitPars, 'Constraints')
                    for teller=1:(length(QmatNMR.InitialFitPars.Constraints)-2)
                      set(ck(teller), 'value', QmatNMR.InitialFitPars.Constraints(teller));
                    end
                    set(ck(9), 'value', QmatNMR.InitialFitPars.Constraints(end-1));
                    set(ck(10), 'value', QmatNMR.InitialFitPars.Constraints(end));
                  end
                  
                else  
                  error('matNMR ERROR: the length of the vector is not correct !!');
                end






	elseif strcmp(command,'viewadd1')			%Add Fit Results to plot
                QuiInput('Add Fit Results to plot :', ' OK | CANCEL', 'regelviewaddresultsT1;', [], 'Name of variable :', QmatNMR.ViewNameT1Fit);

	elseif strcmp(command,'viewadd2')			%View Fit Results input window callback
                QmatNMR.ViewNameT1Fit = QmatNMR.GetString;
                QmatNMR.InitialFitPars = QmatNMR.GetVar;
                
                %find the right axis
                QTEMP = findobj(allchild(0), 'tag', 'T1FitAxis');
                set(get(QTEMP, 'parent'), 'currentaxes', QTEMP)

                QTEMP1 = 0;
                if (mod((length(QmatNMR.InitialFitPars.Parameters)-2), 2) == 0)
                  npeaks = ((length(QmatNMR.InitialFitPars.Parameters)-2) / 2);
                
                  s1 = sprintf('   T1 Fit Results :\n\n   Number of Exponentials  =  %d\n   Chi^2 =  %4.5e\n', npeaks, QmatNMR.InitialFitPars.Error);
                  snew = s1;
                  
                  for teller = 1:npeaks
                    s2 = sprintf('\n   Exponential %d:   Coefficient = %0.3g,   %s %6.3g %s\n', ...
                                 teller, QmatNMR.InitialFitPars.Parameters(1+((teller-1)*2)),'  \bfT1             =',QmatNMR.InitialFitPars.Parameters(2+((teller-1)*2)),' \rm');
                    snew = strcat(snew, s2);
                    s1 = str2mat(s1, s2); 
                  end
                  
                  QTEMP9 = length(QmatNMR.InitialFitPars.Parameters);
                  s3 = sprintf('\n   Constant  =  %0.5g   Amplitude =  %0.7g\n\n\n', QmatNMR.InitialFitPars.Parameters(QTEMP9-1), QmatNMR.InitialFitPars.Parameters(QTEMP9));
                  snew = strcat(snew, s3);
                
                  QmatNMR.Xlim = get(QTEMP, 'xlim');
                  QmatNMR.Ylim = get(QTEMP, 'ylim');
                  
                  QTEMP4.posdata = [0 0 0];
                  QTEMP1 = text('Parent', QTEMP, ...
                       'BackGroundColor', QmatNMR.ColorScheme.Text1Back, ...
                       'Color', QmatNMR.ColorScheme.Text1Fore, ...
                       'EraseMode', 'normal', ...
                       'units', 'normalized', ...
                       'Position', [0.2 0.4 0], ...
                       'String', snew,...
                       'hittest', 'on', ...
                       'fontsize', QmatNMR.TextSize-3, ...
                       'userdata', QTEMP4, ...
                       'buttondownfcn', 'ZoomMatNMR FitWindow off; MoveAxis');
                  set(QTEMP1, 'fontsize', QmatNMR.TextSize-3);
                end



	elseif strcmp(command,'refreshbut')			%update the screen by taking the current T1 curve
          global QmatNMR
	  T1lsq(QmatNMR.Axis1D',(real(QmatNMR.Spec1D')));	%take the 1D spectrum = T1-curve
	  
	end
end
