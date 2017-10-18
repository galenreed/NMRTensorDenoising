function peakfit(command)
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
% 1-1-'97
%
global PFITX PFITDY PFITFY PFIT_LAMBDA Pverbose Pstdv QmatNMR

if nargin == 0
	command = 'init';
end


if ~strcmp(command,'init'),

	[ed, ck, rb, FitBut, CurBut, TolBut, NrIterBut, noibut, zombut, redisbut, lijstbut, MinSlice, MaxSlice, ViewSlice, ...
          parambut, morebut, refreshbut, printbut, stopbut, txt1, txt2, txt3, txt4, txt5, txt6, txt7, txt8, txt9]=pk_udata;
	MorePeaksStatus = get(morebut, 'value');
  if (get(zombut,'Value')==1)
    ZoomMatNMR FitWindow off;
  end

  PeakFitFigure = findobj(0, 'Tag', 'Peakfit');
  PeakFitAxis=findobj(get(PeakFitFigure, 'children'), 'tag', 'PeakFitAxis');
  axes(PeakFitAxis);
end

if isstr(command)
	if strcmp(command,'init')
		pk_init
 		[ed, ck, rb, FitBut, CurBut, TolBut, NrIterBut, noibut, zombut, redisbut, lijstbut, MinSlice, MaxSlice, ViewSlice, ...
		  parambut, morebut, refreshbut, printbut, stopbut, txt1, txt2, txt3, txt4, txt5, txt6, txt7, txt8, txt9]=pk_udata;
		pk_inivl(rb,ck,ed);

                %
		%In case of a 2D we need to see which slice to show
		%
  		[P1 P2] = size(PFITDY);
		if (P2 > 1)
                  if (QmatNMR.Dim == 1)
                    QTEMP =  QmatNMR.rijnr;

		  elseif (QmatNMR.Dim == 2)
                    QTEMP = QmatNMR.kolomnr;
		  end
		else
		  QTEMP = 1;
		end

  		%
		%set UI controls
		%
		set(MinSlice,  'String', 1, 'value', 1);
  		set(MaxSlice,  'String', P2, 'value', P2);
  		set(ViewSlice, 'String', QTEMP, 'value', QTEMP);
  		Pminslice = 1;
  		Pmaxslice = P2;

                Pstdv = 1.0;
         	Pverbose(1)=0;    %This will NOT tell them the results
	        Pverbose(2)=1;    %This will replot each loop
	        Pverbose(3)=0;    %using initial parameters for each new fit is turned off by default

		PeakFitFigure = findobj(0, 'Tag', 'Peakfit');
                PeakFitAxis=findobj(get(PeakFitFigure, 'children'), 'tag', 'PeakFitAxis');
		axes(PeakFitAxis);
                axis on
		set(PeakFitAxis, 'nextplot', 'replacechildren', ...
	                 'units', 'normalized', ...
	                 'position',[0.18 0.32 .78 .65], ...
			 'nextplot', 'replacechildren', ...
                         'XGrid','on', ...
			 'YGrid','on', ...
			 'FontSize', QmatNMR.TextSize, ...
			 'FontName', QmatNMR.TextFont, ...
			 'FontAngle', QmatNMR.TextAngle, ...
			 'FontWeight', QmatNMR.TextWeight, ...
			 'LineWidth', QmatNMR.LineWidth, ...
			 'visible','on', ...
			 'tag', 'PeakFitAxis', ...
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
		  plot(PFITX, PFITDY(:, QTEMP), QmatNMR.LineColor);
		  set(PeakFitAxis, 'XGrid','on', 'YGrid','on', 'XDir', 'reverse', ...
		      'fontsize', QmatNMR.TextSize, 'fontname', QmatNMR.TextFont, 'fontangle', QmatNMR.TextAngle, 'fontweight', QmatNMR.TextWeight);
                  ymin = min(PFITDY(:, QTEMP));
                  ymax = max(PFITDY(:, QTEMP));
                  if (((ymin == 0) & (ymax == 0)) | (isnan(ymin) | isnan(ymax)))
                    ymin = -1;
                    ymax = 1;
                  end
		  axis([min(PFITX) max(PFITX) (ymin-0.1*abs(ymin)) (ymax + 0.1*abs(ymax))]);
		else
		  plot(fliplr(PFITX), fliplr(PFITDY(:, QTEMP)), QmatNMR.LineColor);
		  set(PeakFitAxis, 'XGrid','on', 'YGrid','on', 'XDir', 'normal', ...
		      'fontsize', QmatNMR.TextSize, 'fontname', QmatNMR.TextFont, 'fontangle', QmatNMR.TextAngle, 'fontweight', QmatNMR.TextWeight);
                  ymin = min(PFITDY(:, QTEMP));
                  ymax = max(PFITDY(:, QTEMP));
                  if (((ymin == 0) & (ymax == 0)) | (isnan(ymin) | isnan(ymax)))
                    ymin = -1;
                    ymax = 1;
                  end
		  axis([min(PFITX) max(PFITX) (ymin-0.1*abs(ymin)) (ymax + 0.1*abs(ymax))]);
		end
                setappdata(PeakFitAxis, 'ZoomLimitsMatNMR', [min(PFITX) max(PFITX) (ymin-0.1*abs(ymin)) (ymax + 0.1*abs(ymax))]);

		disp('PEAKFIT succesfully initiated ...');

	elseif strcmp(command,'new') 		%when a fit window is already opened, just update the plot
	        set(PeakFitAxis, 'nextplot', 'replacechildren');

                %
		%In case of a 2D we need to see which slice to show
		%
  		[P1 P2] = size(PFITDY);
		if (P2 > 1)
                  if (QmatNMR.Dim == 1)
                    QTEMP =  QmatNMR.rijnr;

		  elseif (QmatNMR.Dim == 2)
                    QTEMP = QmatNMR.kolomnr;
		  end
		else
		  QTEMP = 1;
		end

                axis on
		set(PeakFitAxis, ...
	                 'units', 'normalized', ...
	                 'position',[0.18 0.32 .78 .65], ...
			 'nextplot', 'replacechildren', ...
                         'XGrid','on', ...
			 'YGrid','on', ...
			 'FontSize', QmatNMR.TextSize, ...
			 'FontName', QmatNMR.TextFont, ...
			 'FontAngle', QmatNMR.TextAngle, ...
			 'FontWeight', QmatNMR.TextWeight, ...
			 'LineWidth', QmatNMR.LineWidth, ...
			 'visible','on', ...
			 'tag', 'PeakFitAxis', ...
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
		  plot(PFITX, PFITDY(:, QTEMP), QmatNMR.LineColor);
		  set(PeakFitAxis, 'XGrid','on', 'YGrid','on', 'XDir', 'reverse', ...
		      'fontsize', QmatNMR.TextSize, 'fontname', QmatNMR.TextFont, 'fontangle', QmatNMR.TextAngle, 'fontweight', QmatNMR.TextWeight);
                  ymin = min(PFITDY(:, QTEMP));
                  ymax = max(PFITDY(:, QTEMP));
                  if (((ymin == 0) & (ymax == 0)) | (isnan(ymin) | isnan(ymax)))
                    ymin = -1;
                    ymax = 1;
                  end
		  axis([min(PFITX) max(PFITX) (ymin-0.1*abs(ymin)) (ymax + 0.1*abs(ymax))]);
		else
		  plot(fliplr(PFITX), fliplr(PFITDY(:, QTEMP)), QmatNMR.LineColor);
		  set(PeakFitAxis, 'XGrid','on', 'YGrid','on', 'XDir', 'normal', ...
		      'fontsize', QmatNMR.TextSize, 'fontname', QmatNMR.TextFont, 'fontangle', QmatNMR.TextAngle, 'fontweight', QmatNMR.TextWeight);
                  ymin = min(PFITDY(:, QTEMP));
                  ymax = max(PFITDY(:, QTEMP));
                  if (((ymin == 0) & (ymax == 0)) | (isnan(ymin) | isnan(ymax)))
                    ymin = -1;
                    ymax = 1;
                  end
		  axis([min(PFITX) max(PFITX) (ymin-0.1*abs(ymin)) (ymax + 0.1*abs(ymax))]);
		end
                setappdata(PeakFitAxis, 'ZoomLimitsMatNMR', [min(PFITX) max(PFITX) (ymin-0.1*abs(ymin)) (ymax + 0.1*abs(ymax))]);

  		set(MinSlice,  'String', 1, 'value', 1);
  		set(MaxSlice,  'String', P2, 'value', P2);
                set(ViewSlice, 'String', QTEMP, 'value', QTEMP);
  		Pminslice = 1;
  		Pmaxslice = P2;

		pk_inivl(rb,ck,ed);

	elseif strcmp(command,'fitbut')

  		PFIT_LAMBDA=[];

		%find out how many peaks must be fitted -> check is the "peak width"
		if (~MorePeaksStatus)
		  for tel=4:-1:1
		    if (~isempty(str2num(get(ed((tel-1)*4+3),'String'))))
		      lam_len= tel*4;
		      break
		    end
		  end

		else
		  for tel=36:-1:1
		    if (~isempty(str2num(get(ed((tel-1)*4+3),'String'))))
		      lam_len= tel*4;
		      break
		    end
		  end
		end

		PFIT_LAMBDA=zeros(1,lam_len);
		for i=1:lam_len
		  PFIT_LAMBDA(i)= str2num(get(ed(i),'String'));
		end
		%
		%we must prevent any zero values for the amplitude or width because
		%this causes an error NOTICE
		%
		QTEMP = PFIT_LAMBDA(2:4:lam_len);
		QTEMP(find(QTEMP==0)) = 1;
		PFIT_LAMBDA(2:4:lam_len) = QTEMP;
		QTEMP = PFIT_LAMBDA(3:4:lam_len);
		QTEMP(find(QTEMP==0)) = 1;
		PFIT_LAMBDA(3:4:lam_len) = QTEMP;

		lam_len=lam_len+2;
		PFIT_LAMBDA(lam_len-1)= str2num(get(ed(145),'String'));
		PFIT_LAMBDA(lam_len)= str2num(get(ed(146),'String'));

		PInitialPars = PFIT_LAMBDA;			%The initial parameters

               	Pminslice = str2num(get(MinSlice,'String'));%Which slices to fit ???
               	Pmaxslice = str2num(get(MaxSlice,'String'));
	        Plength = Pmaxslice - Pminslice + 1;

                QmatNMR.FitResults = [];

		for PTeller = Pminslice:Pmaxslice
			fprintf(1, '\n\n\nStarting fit on column nr : %g\n\n', PTeller);

                        %set the current view indiciator to the correct value
	  	        set(ViewSlice, 'string', num2str(PTeller), 'value', PTeller);

			AreaRow = [];

			if Pverbose(3)
			  PFIT_LAMBDA = PInitialPars;
			end

			constrain=pk_gtcon(ck,lam_len);
			npts=length(PFITX);
	        	wt=Pstdv * ones(npts,1);
			PFITFY=pk_qvt(PFITX,PFIT_LAMBDA);

                axis on
		set(PeakFitAxis, ...
	                 'units', 'normalized', ...
	                 'position',[0.18 0.32 .78 .65], ...
			 'nextplot', 'replacechildren', ...
                         'XGrid','on', ...
			 'YGrid','on', ...
			 'FontSize', QmatNMR.TextSize, ...
			 'FontName', QmatNMR.TextFont, ...
			 'FontAngle', QmatNMR.TextAngle, ...
			 'FontWeight', QmatNMR.TextWeight, ...
			 'LineWidth', QmatNMR.LineWidth, ...
			 'visible','on', ...
			 'tag', 'PeakFitAxis', ...
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
			  plot(PFITX, PFITDY(:, PTeller), QmatNMR.LineColor, PFITX, PFITFY);
			  set(PeakFitAxis, 'XGrid','on', 'YGrid','on', 'XDir', 'reverse');

                          ymin = min(PFITDY(:, 1));
                          ymax = max(PFITDY(:, 1));
                          if (((ymin == 0) & (ymax == 0)) | (isnan(ymin) | isnan(ymax)))
                            ymin = -1;
                            ymax = 1;
                          end
                          axis([min(PFITX) max(PFITX) (ymin-0.1*abs(ymin)) (ymax + 0.1*abs(ymax))]);
			else
			  plot(fliplr(PFITX), fliplr(PFITDY(:, PTeller)), QmatNMR.LineColor, fliplr(PFITX), fliplr(PFITFY));
			  set(PeakFitAxis, 'XGrid','on', 'YGrid','on', 'XDir', 'normal');

                          ymin = min(PFITDY(:, 1));
                          ymax = max(PFITDY(:, 1));
                          if (((ymin == 0) & (ymax == 0)) | (isnan(ymin) | isnan(ymax)))
                            ymin = -1;
                            ymax = 1;
                          end
                          axis([min(PFITX) max(PFITX) (ymin-0.1*abs(ymin)) (ymax + 0.1*abs(ymax))]);
			end
                        setappdata(PeakFitAxis, 'ZoomLimitsMatNMR', [min(PFITX) max(PFITX) (ymin-0.1*abs(ymin)) (ymax + 0.1*abs(ymax))]);

        	        drawnow;
			set(PeakFitFigure,'Pointer','watch');

			FITtol = str2num(get(TolBut, 'String'));
			FITMaxIter = str2num(get(NrIterBut, 'String'));

	tic;
			[PFITFY,PFIT_LAMBDA,kvg,iter,corp,covp,covr,stdresid,Z,r2]= ...
			leasqr(PFITX,PFITDY(:, PTeller),PFIT_LAMBDA,'pk_qvt',FITtol,FITMaxIter,wt,constrain ...
			,'pk_qvtdf');
	toc;

			set(PeakFitFigure,'Pointer','arrow');

			chi2 = sum(((PFITDY(:, PTeller)-PFITFY).*wt).^2)/(npts-lam_len);
			fprintf(1, 'Chisqr= %g\n',chi2);

			total_area= abs(trapz(PFITX,PFITFY));
			s= sprintf('Total area= %-8.6g',total_area);
			disp(s);
			npeaks= floor(lam_len/4);

			if npeaks > 1,			%with multiple lines plot each one separate
				fred= axis;
				axis([fred(1) fred(2) fred(3) fred(4)]);

                                set(PeakFitAxis, 'nextplot', 'add');
				for i=1:npeaks
					base=(i-1)*4;
					lam = PFIT_LAMBDA((base+1):(base+4));
					f=pk_voigt(PFITX,lam);
					plot(PFITX, f, QmatNMR.color(rem(i+1, length(QmatNMR.color)) + 1));
					area(i)= abs(trapz(PFITX,f));
					s= sprintf('Area of peak %-1g = %-8.6g',i,area(i));
					AreaRow = [AreaRow area(i)];
					disp(s);
				end
                                set(PeakFitAxis, 'nextplot', 'replacechildren');

			else				%with only one line don't plot separate
				lam(1:4)= PFIT_LAMBDA(1:4);
				f=pk_voigt(PFITX,lam);
				area(1)= abs(trapz(PFITX,f));
				s= sprintf('Area of peak %-1g = %-8.6g',1,area(1));
				AreaRow = [AreaRow area(1)];
				disp(s);
			end
                  	ymin = min(PFITDY(:, PTeller));
                  	ymax = max(PFITDY(:, PTeller));
                        if (((ymin == 0) & (ymax == 0)) | (isnan(ymin) | isnan(ymax)))
                    	  ymin = -1;
                    	  ymax = 1;
                  	end
		  	axis([min(PFITX) max(PFITX) (ymin-0.1*abs(ymin)) (ymax + 0.1*abs(ymax))]);

			for i=1:lam_len-2,
				set(ed(i),'String',num2str(PFIT_LAMBDA(i), 8));
			end
			set(ed(145),'String',num2str(PFIT_LAMBDA(lam_len-1)));
			set(ed(146),'String',num2str(PFIT_LAMBDA(lam_len)));

						%The matrix with the fit results is built up like :
						%	- nr of iterations
						%	- chi2 for this column
						%	- total area of all peaks (integral)
						%       - integral of the individual peaks
						% 	- fit parameters :
						%            - for all peaks:
						%		               - xpos (center of peak)
						%		               - Amplitude of peak
						%	                 - Width of peak
						%		               - Fraction of Lorentzian lineshape
						%            - background
						%            - slope
						%

                	%
                	%Store the fit into a structure variable
                	%
                        QmatNMR.FitResults(1+PTeller-Pminslice).Parameters 	= [PFIT_LAMBDA];
                        QmatNMR.FitResults(1+PTeller-Pminslice).Integral 	= total_area;
                        QmatNMR.FitResults(1+PTeller-Pminslice).Integrals 	= AreaRow;
                        QmatNMR.FitResults(1+PTeller-Pminslice).Fit 		= PFITFY;
                        QmatNMR.FitResults(1+PTeller-Pminslice).Data 		= PFITDY(:, PTeller);
                        QmatNMR.FitResults(1+PTeller-Pminslice).Axis 		= PFITX;
                        QmatNMR.FitResults(1+PTeller-Pminslice).Error		= chi2;
                        QmatNMR.FitResults(1+PTeller-Pminslice).Sigma	 	= Pstdv;
                        QmatNMR.FitResults(1+PTeller-Pminslice).Constraints  	= cell2mat(get(ck([1:(lam_len-2) 145 146]), 'value'));
		end


                %
                %to store the results we need to make the designated variable global. In case the name
                %points to a structure variable, we need to use only the main variable, hence the following
                %check.
                %
                QTEMP = findstr(QmatNMR.VariableNamePeakFit, '.');
                if QTEMP
                  eval(['global ' QmatNMR.VariableNamePeakFit(1:(QTEMP-1))]);
                else
  		  eval(['global ' QmatNMR.VariableNamePeakFit]);
                end
		eval([QmatNMR.VariableNamePeakFit ' = QmatNMR.FitResults;']);

		fprintf(1, '\n\nFitting finished ...\nThe results have been written to "%s" in the MATLAB workspace.\nType "global %s" once to allow access to the variable\n', QmatNMR.VariableNamePeakFit, QmatNMR.VariableNamePeakFit);
		fprintf(1, 'For Matlab 7: use "cell2mat(cellfun(@(x) x,{%s.Parameters},''UniformOutput'', false)'')"\nto convert an array of structures into a matrix for further manipulation.\n\n', QmatNMR.VariableNamePeakFit);


	elseif strcmp(command,'curbut')
		once= 0;
		LineHandle = findobj(findobj(PeakFitAxis, 'type', 'line'), 'color', [1 1 0]);
		LineYData = get(LineHandle, 'Ydata');

		[xpos,ypos,button]= ginput(1);
		button = get(PeakFitFigure, 'SelectionType');
                if strcmp(button,'normal')
                  gerr = pk_inbds(xpos,ypos);
                else
		  gerr = 1;
		end

		while (~gerr)
		  %
		  %first check which radio button is activated
		  %
		  for DetectButton=1:74
  		    if get(rb(DetectButton), 'value')
		      break
		    end
		  end

		  if (DetectButton==73) 		%baseline level
                    set(ed(145),'String',num2str(ypos));
		    set(ck(145),'Value',0);
                    set(rb(73),'Value',0);
		    set(rb(74),'Value',1);

		  elseif (DetectButton==74) 		%baseline slope
                    fred=str2num(get(ed(145),'string'));
		    mort= (PFITX(length(PFITX))-PFITX(1));
		    slope= (ypos-fred)/mort;
		    set(ed(146),'String',num2str(slope));
		    set(ck(146),'Value',0);

                  elseif (mod(DetectButton, 2) == 1) 	%peak position + amplitude
		    RowNR = ceil(DetectButton/2);
		    set(ed((RowNR-1)*4+1),'String',num2str(xpos, 9));
		    set(ed((RowNR-1)*4+2),'String',num2str(ypos, 9));
		    set(ed(RowNR*4), 'String', '1');
		    set(rb(DetectButton),'Value',0);
		    set(rb(DetectButton+1),'Value',1);

                  elseif (mod(DetectButton, 2) == 0) 	%peak width
		    if (once)
		      fred= abs(xpos-xpos1);
		      RowNR = ceil(DetectButton/2);
		      set(ed((RowNR-1)*4+3),'String',num2str(fred, 9));
		      set(rb(DetectButton),'Value',0);
		      set(rb(DetectButton+1),'Value',1);
		      if ((~MorePeaksStatus) & ((DetectButton+1) == 9))
  		        set(rb(DetectButton+1),'Value',0);
		        set(rb(73),'Value',1);
		      end
		      once = 0;
		    else
		      xpos1 = xpos;
		      once = 1;
		    end
		  end

		  %
		  %repeat the input cycle
		  %
                  [xpos,ypos,button]= ginput(1);
                  button = get(PeakFitFigure, 'SelectionType');
                  if strcmp(button,'normal')
                    gerr = pk_inbds(xpos,ypos);
                  else
		    gerr = 1;
		  end
		end


	elseif strcmp(command,'noibut')
                disp(' ');
                disp('You have to define the area in which only noise is present');
                disp('Move the mouse pointer to the desired coordinates and click a button ...');
                disp(' ');

                set(PeakFitAxis, 'nextplot', 'add');
                PY = get(PeakFitAxis, 'ylim');
                QmatNMR.resolution = (max(PFITX) - min(PFITX))/length(PFITX);
                QmatNMR.waarden(1, :) = ginput(1);
                plot([QmatNMR.waarden(1,1) QmatNMR.waarden(1,1)], PY, 'r--');

                QmatNMR.waarden(2, :) = ginput(1);
                plot([QmatNMR.waarden(2,1) QmatNMR.waarden(2,1)], PY, 'r--');

                axis on
		set(PeakFitAxis, ...
	                 'units', 'normalized', ...
	                 'position',[0.18 0.32 .78 .65], ...
			 'nextplot', 'replacechildren', ...
                         'XGrid','on', ...
			 'YGrid','on', ...
			 'FontSize', QmatNMR.TextSize, ...
			 'FontName', QmatNMR.TextFont, ...
			 'FontAngle', QmatNMR.TextAngle, ...
			 'FontWeight', QmatNMR.TextWeight, ...
			 'LineWidth', QmatNMR.LineWidth, ...
			 'visible','on', ...
			 'tag', 'PeakFitAxis', ...
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
		  set(PeakFitAxis, 'XGrid','on', 'YGrid','on', 'XDir', 'reverse');
		else
		  set(PeakFitAxis, 'XGrid','on', 'YGrid','on', 'XDir', 'normal');
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
                end

                %sort the indices to make sure the lowest comes first
                QmatNMR.waarden = sort([QmatNMR.waarden(1,1) QmatNMR.waarden(2,1)]);

                Pstdv = 1.0 / std(PFITDY(QmatNMR.waarden(1):QmatNMR.waarden(2)));

	elseif strcmp(command,'zombut')
               if (get(zombut,'Value')==1)
                  ZoomMatNMR FitWindow on;
               elseif(get(zombut,'Value')==0)
                  ZoomMatNMR FitWindow off;
               end
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


	elseif strcmp(command,'lijstbut')			%Button for extended output for each fit
               Pverbose(1) = get(lijstbut,'Value');



	elseif strcmp(command,'parambut')			%Button for whether to use the inital parameters
								%for each new column
               Pverbose(3) = get(parambut,'Value');



	elseif strcmp(command,'morebut')			%Button for using more than 4 peaks
								%in the fit
               if (get(morebut, 'value'))
	         set(findobj(0, 'Tag', 'Peakfit2'), 'visible', 'on');

	       else
	         set(findobj(0, 'Tag', 'Peakfit2'), 'visible', 'off');
	       end
               figure(PeakFitFigure)


	elseif strcmp(command,'MinSlice')			%Change the first slice that needs to be fitted
               Pminslice = str2num(get(MinSlice,'String'));
               Pmaxslice = str2num(get(MaxSlice,'String'));

	        						%The first slice is limited by the last slice and
	       if (Pminslice < 1)				%the first possible slice
	         Pminslice = 1;
	         set(MinSlice,  'String', num2str(1), 'value', 1);
	       end

	       if (Pminslice > Pmaxslice)
	         Pminslice = Pmaxslice;
	         set(MinSlice,  'String', num2str(Pminslice), 'value', Pminslice);
	       end


	elseif strcmp(command,'MaxSlice')			%Change the last slice that needs to be fitted
               Pminslice = str2num(get(MinSlice,'String'));
               Pmaxslice = str2num(get(MaxSlice,'String'));

	       [P1 P2] = size(PFITDY);				%The last slice is limited by the last slice possible and
	       if (Pmaxslice < Pminslice)			%the first slice
	         Pmaxslice = Pminslice;
	         set(MaxSlice,  'String', num2str(Pmaxslice), 'value', Pmaxslice);
	       end

	       if (Pmaxslice > P2)
	         Pmaxslice = P2;
	         set(MaxSlice,  'String', num2str(Pmaxslice), 'value', Pmaxslice);
	       end


	elseif strcmp(command,'ViewSlice')			%Change the slice in the figure window
               %extract the slices to view and fit from the UI control in the peakfit window
               Pminslice = str2num(get(MinSlice,'String'));
               Pmaxslice = str2num(get(MaxSlice,'String'));
	       PView = str2num(get(ViewSlice, 'String'));

	       %
	       %replot the original spectrum for the requested slice
	       %
	       [P1 P2] = size(PFITDY);				%The last slice is limited by the last slice possible and
		if (PView < 1)
		  PView = 1;
		  set(ViewSlice,  'String', num2str(PView), 'value', PView);
		end

		if (PView > P2)
		  PView = P2;
		  set(ViewSlice,  'String', num2str(PView), 'value', PView);
		end

                axis on
		set(PeakFitAxis, ...
	                 'units', 'normalized', ...
	                 'position',[0.18 0.32 .78 .65], ...
			 'nextplot', 'replacechildren', ...
                         'XGrid','on', ...
			 'YGrid','on', ...
			 'FontSize', QmatNMR.TextSize, ...
			 'FontName', QmatNMR.TextFont, ...
			 'FontAngle', QmatNMR.TextAngle, ...
			 'FontWeight', QmatNMR.TextWeight, ...
			 'LineWidth', QmatNMR.LineWidth, ...
			 'visible','on', ...
			 'tag', 'PeakFitAxis', ...
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
		  plot(PFITX, PFITDY(:, PView), QmatNMR.LineColor);
		  set(PeakFitAxis, 'visible', 'on', 'XGrid','on', 'YGrid','on', 'XDir', 'reverse', ...
		      'fontsize', QmatNMR.TextSize, 'fontname', QmatNMR.TextFont, 'fontangle', QmatNMR.TextAngle, 'fontweight', QmatNMR.TextWeight);

                  ymin = min(PFITDY(:, PView));
                  ymax = max(PFITDY(:, PView));
                  if (((ymin == 0) & (ymax == 0)) | (isnan(ymin) | isnan(ymax)))
                    ymin = -1;
                    ymax = 1;
                  end
                  axis([min(PFITX) max(PFITX) (ymin-0.1*abs(ymin)) (ymax + 0.1*abs(ymax))]);
		else
		  plot(fliplr(PFITX), fliplr(PFITDY(:, PView)), QmatNMR.LineColor);
		  set(PeakFitAxis, 'visible', 'on', 'XGrid','on', 'YGrid','on', 'XDir', 'normal', ...
		      'fontsize', QmatNMR.TextSize, 'fontname', QmatNMR.TextFont, 'fontangle', QmatNMR.TextAngle, 'fontweight', QmatNMR.TextWeight);

                  ymin = min(PFITDY(:, PView));
                  ymax = max(PFITDY(:, PView));
                  if (((ymin == 0) & (ymax == 0)) | (isnan(ymin) | isnan(ymax)))
                    ymin = -1;
                    ymax = 1;
                  end
                  axis([min(PFITX) max(PFITX) (ymin-0.1*abs(ymin)) (ymax + 0.1*abs(ymax))]);
		end

		%
		%If the data has been fit already once then change the fitting parameters in the
		%UI controls according to the fit results. Also, update the fitted line in blue
		%for the requested slice. Since the variable QmatNMR.FitResults is reset before each
		%fit and when reloading new data, the size of it is used as the indicator to
		%see if the data has been fit or not.
		%
                QTEMP1 = length(QmatNMR.FitResults);
                QTEMP2 = length(QmatNMR.FitResults(1).Parameters);
		if (QTEMP1 == length(Pminslice:Pmaxslice))
		  %
		  %change the parameters in the UI controls
		  %
                  if (mod((QTEMP2-2), 4) == 0)
                    npeaks = ((QTEMP2-2) / 4);

                    set(ed(1:146), 'String', '');		%First clear the old values

                                                  %Then put in the new values
                    for teller=1:(QTEMP2-2)
                      set(ed(teller), 'String', num2str(QmatNMR.FitResults(PView).Parameters(teller), 8));
                    end

                    set(ed(145), 'String', num2str(QmatNMR.FitResults(PView).Parameters(QTEMP2-1)));
                    set(ed(146), 'String', num2str(QmatNMR.FitResults(PView).Parameters(QTEMP2)));
                  else
                    error('matNMR ERROR: the length of the vector is not correct !!');
                  end

		  %
		  %Plot the total fit in blue for the requested slice, after reconstructing the fit
		  %from the parameters (since the fitted spectrum is not stored!)
		  %
                  set(PeakFitAxis, 'nextplot', 'add');
                  f = QmatNMR.FitResults(PView).Fit;
                  PFITX = QmatNMR.FitResults(PView).Axis;
                  plot(PFITX, f, QmatNMR.color(rem(1, length(QmatNMR.color)) + 1));


		  %
		  %Plot the individual fractions for the requested slice
		  %
                  if (npeaks > 1)			%with multiple lines plot each one separate
                    fred = axis;
                    axis([fred(1) fred(2) fred(3) fred(4)]);

                    for i=1:npeaks
                      base = (i-1)*4;
                      lam(1:4) = QmatNMR.FitResults(PView).Parameters((base+1):(base+4));
                      f = pk_voigt(PFITX,lam);
                      plot(PFITX, f, QmatNMR.color(rem(i+1, length(QmatNMR.color)) + 1));
                    end
                    set(PeakFitAxis, 'nextplot', 'replacechildren');
                  end
                end

        	drawnow;



	elseif strcmp(command,'loadpars1')			%Load parameters input window
                QuiInput('Load fit parameters from the workspace :', ' OK | CANCEL', 'regelloadpars;', [], 'Name of variable :', QmatNMR.ViewNamePeakFit, 'Number of slice (ONLY FOR 2D MATRICES!) :', '1');

	elseif strcmp(command,'loadpars2')			%Load parameters input window callback
                QmatNMR.ViewNamePeakFit = QmatNMR.GetString;
                QmatNMR.InitialFitPars = QmatNMR.GetVar;
                SliceNr = eval(QmatNMR.uiInput2);

                %
                %due to a change in the way the parameters are stored we need to ensure backward compatibility
                %
                if ~isstruct(QmatNMR.InitialFitPars)
                  %
                  %convert the variable to the new structure
                  %
                  npeaks = ((length(QmatNMR.InitialFitPars(1).Parameters)-5) / 5);

                  QTEMP1 = QmatNMR.InitialFitPars;
                  QmatNMR.InitialFitPars = [];
                  for teller=1:size(QTEMP1, 1)
                    QmatNMR.InitialFitPars(teller).Parameters = QTEMP1(teller, (end-npeaks*4-1):end);
                  end

                elseif ~isfield(QmatNMR.InitialFitPars, 'Parameters')
                  disp('matNMR WARNING: incorrect variable structure for fit parameters. Aborting ...')
                  beep
                  return

                elseif (length(QmatNMR.InitialFitPars) < SliceNr)
                  disp('matNMR WARNING: incorrect slice number for fit parameters. Aborting ...')
                  beep
                  return
                end

                %
                %continue by writing the parameter values into the appropriate UIcontrols
                %
                if (mod((length(QmatNMR.InitialFitPars(1).Parameters)-2), 4) == 0)
                  set(ed(1:146), 'String', '');		%First clear the old values

                                                %Then put in the new values
                  npeaks = ((length(QmatNMR.InitialFitPars(1).Parameters)-2) / 4);

                  for teller=1:(length(QmatNMR.InitialFitPars(1).Parameters)-2)
                    set(ed(teller), 'String', num2str(QmatNMR.InitialFitPars(1).Parameters(teller), 8));
                  end

                  set(ed(145), 'String', num2str(QmatNMR.InitialFitPars(1).Parameters(end-1)));
                  set(ed(146), 'String', num2str(QmatNMR.InitialFitPars(1).Parameters(end)));

                  %
                  %set the constraints if they were stored in the structure
                  %
                  if isfield(QmatNMR.InitialFitPars(SliceNr), 'Constraints')
                    for teller=1:(length(QmatNMR.InitialFitPars(SliceNr).Constraints)-2)
                      set(ck(teller), 'value', QmatNMR.InitialFitPars(SliceNr).Constraints(teller));
                    end
                    set(ck(145), 'value', QmatNMR.InitialFitPars(SliceNr).Constraints(end-1));
                    set(ck(146), 'value', QmatNMR.InitialFitPars(SliceNr).Constraints(end));
                  end
                else
                  error('matNMR ERROR: the length of the vector is not correct !!');
                end
                disp('Old set of parameters loaded into the peak deconvolution routine');



	elseif strcmp(command,'defvar1')			%Define variable name for Results
                QuiInput('Define Results Variable :', ' OK | CANCEL', 'regeldefvar;', [], 'Name of variable :', QmatNMR.VariableNamePeakFit);

	elseif strcmp(command,'defvar2')			%Define variable name for Results callback
                QmatNMR.VariableNamePeakFit = QmatNMR.uiInput1;
                %
                %to store the results we need to make the designated variable global. In case the name
                %points to a structure variable, we need to use only the main variable, hence the following
                %check.
                %
                QTEMP = findstr(QmatNMR.VariableNamePeakFit, '.');
                if QTEMP
                  eval(['global ' QmatNMR.VariableNamePeakFit(1:(QTEMP-1))]);
                else
  		  eval(['global ' QmatNMR.VariableNamePeakFit]);
                end
		eval([QmatNMR.VariableNamePeakFit ' = 1;']);
		disp('  ');
		disp(['matNMR NOTICE: new variable name "' QmatNMR.VariableNamePeakFit '" defined for peak fitting results. ']);
		disp(['matNMR NOTICE: To be able to access this variable please type:']);
		disp('  ');
                if QTEMP
		  disp(['               global ' QmatNMR.VariableNamePeakFit(1:(QTEMP-1))]);
                else
		  disp(['               global ' QmatNMR.VariableNamePeakFit]);
                end
		disp('  ');



	elseif strcmp(command,'view1')			%View Fit Results input window
                QuiInput('View Fit Results :', ' OK | CANCEL', 'regelviewresults;', [], 'Name of variable :', QmatNMR.ViewNamePeakFit, 'Number of slice (ONLY FOR 2D MATRICES!) :', '1');

	elseif strcmp(command,'view2')			%View Fit Results input window callback
                QmatNMR.ViewNamePeakFit = QmatNMR.GetString;
                QmatNMR.InitialFitPars = QmatNMR.GetVar;
                SliceNr = eval(QmatNMR.uiInput2);

                %
                %due to a change in the way the parameters are stored we need to ensure backward compatibility
                %
                if ~isstruct(QmatNMR.InitialFitPars)
                  %
                  %convert the variable to the new structure
                  %
                  npeaks = ((length(QmatNMR.InitialFitPars(1).Parameters)-5) / 5);

                  QTEMP1 = QmatNMR.InitialFitPars;
                  QmatNMR.InitialFitPars = [];
                  for teller=1:size(QTEMP1, 1)
                    QmatNMR.InitialFitPars(teller).Parameters = QTEMP1(teller, (end-npeaks*4-1):end);
                  end

                elseif ~isfield(QmatNMR.InitialFitPars, 'Parameters')
                  disp('matNMR WARNING: incorrect variable structure for fit parameters. Aborting ...')
                  beep
                  return
                end

                %
                %show the results in text form in the console window and in the appropriate UIcontrols
                %
                Slices = length(QmatNMR.InitialFitPars);
                NrPars = length(QmatNMR.InitialFitPars(1).Parameters);

                if ((SliceNr > Slices) | (SliceNr < 1))
                  error('matNMR ERROR: the slice number is not correct !!');
                else
                  if (mod((NrPars-2), 4) == 0)
                    npeaks = ((NrPars-2) / 4);

                    %
                    %Here we write to the console window
                    %
                    s1 = sprintf('\n\nFit Results of slice %d of variable "%s" :\n\n   Number of peaks  =  %d\n   Total Integral   =  %0.7g\n   Chi^2            =  %4.5f\n', SliceNr, QmatNMR.uiInput1, npeaks, QmatNMR.InitialFitPars(SliceNr).Integral, QmatNMR.InitialFitPars(SliceNr).Error);

                    for teller = 1:npeaks
                      s2 = sprintf('   Peak %d:   Integral  = %0.7g\n             Position  = %6.2f\n             Amplitude = %0.7g\n             FWHH      = %3.5f\n             Frac.Lor. = %0.6g\n', ...
                                   teller, QmatNMR.InitialFitPars(SliceNr).Integrals(teller), QmatNMR.InitialFitPars(SliceNr).Parameters((teller-1)*4+1), QmatNMR.InitialFitPars(SliceNr).Parameters((teller-1)*4+2), ...
                                   QmatNMR.InitialFitPars(SliceNr).Parameters((teller-1)*4+3), QmatNMR.InitialFitPars(SliceNr).Parameters(teller*4));

                      s1 = str2mat(s1, s2);
                    end

                    s3 = sprintf('   Background =  %0.5g\n   Slope      =  %0.7g\n\n\n', QmatNMR.InitialFitPars(SliceNr).Parameters(npeaks*4+1), QmatNMR.InitialFitPars(SliceNr).Parameters(npeaks*4+2));
                    s1 = str2mat(s1, s3);
                    disp(s1);

                    %
                    %Here we set the values for the UIcontrols
                    %
                    set(ed(1:146), 'String', '');		%First clear the old values

                    for teller=1:(length(QmatNMR.InitialFitPars(SliceNr).Parameters)-2)
                      set(ed(teller), 'String', num2str(QmatNMR.InitialFitPars(SliceNr).Parameters(teller), 8));
                    end

                    set(ed(145), 'String', num2str(QmatNMR.InitialFitPars(SliceNr).Parameters(end-1)));
                    set(ed(146), 'String', num2str(QmatNMR.InitialFitPars(SliceNr).Parameters(end)));

                    %
                    %set the constraints if they were stored in the structure
                    %
                    if isfield(QmatNMR.InitialFitPars(SliceNr), 'Constraints')
                      for teller=1:(length(QmatNMR.InitialFitPars(SliceNr).Constraints)-2)
                        set(ck(teller), 'value', QmatNMR.InitialFitPars(SliceNr).Constraints(teller));
                      end
                      set(ck(145), 'value', QmatNMR.InitialFitPars(SliceNr).Constraints(end-1));
                      set(ck(146), 'value', QmatNMR.InitialFitPars(SliceNr).Constraints(end));
                    end
                  else
                    error('matNMR ERROR: the length of the vector is not correct !!');
                  end
                end


                %
                %import the data so it can be fitted again
                %
                PFITX = QmatNMR.InitialFitPars(1).Axis;
                PFITDY = zeros(Slices, length(QmatNMR.InitialFitPars(1).Data));
                for tel=1:Slices
                  PFITDY(tel, :) = QmatNMR.InitialFitPars(tel).Data(:).';
                end


		%
		%Plot the data and update the axis limits
		%
                PView = SliceNr;
                cla
		if (PFITX(1) < PFITX(2))
		  plot(PFITX, QmatNMR.InitialFitPars(PView).Data, QmatNMR.LineColor);
		  set(PeakFitAxis, 'visible', 'on', 'XGrid','on', 'YGrid','on', 'XDir', 'reverse', ...
		      'fontsize', QmatNMR.TextSize, 'fontname', QmatNMR.TextFont, 'fontangle', QmatNMR.TextAngle, 'fontweight', QmatNMR.TextWeight);

                  ymin = min(QmatNMR.InitialFitPars(PView).Data);
                  ymax = max(QmatNMR.InitialFitPars(PView).Data);
                  if (((ymin == 0) & (ymax == 0)) | (isnan(ymin) | isnan(ymax)))
                    ymin = -1;
                    ymax = 1;
                  end
                  axis([min(PFITX) max(PFITX) (ymin-0.1*abs(ymin)) (ymax + 0.1*abs(ymax))]);
		else
		  plot(fliplr(PFITX), fliplr(QmatNMR.InitialFitPars(PView).Data), QmatNMR.LineColor);
		  set(PeakFitAxis, 'visible', 'on', 'XGrid','on', 'YGrid','on', 'XDir', 'normal', ...
		      'fontsize', QmatNMR.TextSize, 'fontname', QmatNMR.TextFont, 'fontangle', QmatNMR.TextAngle, 'fontweight', QmatNMR.TextWeight);

                  ymin = min(QmatNMR.InitialFitPars(PView).Data);
                  ymax = max(QmatNMR.InitialFitPars(PView).Data);
                  if (((ymin == 0) & (ymax == 0)) | (isnan(ymin) | isnan(ymax)))
                    ymin = -1;
                    ymax = 1;
                  end
                  axis([min(PFITX) max(PFITX) (ymin-0.1*abs(ymin)) (ymax + 0.1*abs(ymax))]);
		end


		%
		%Plot the total fit in blue for the requested slice, after reconstructing the fit
		%from the parameters (since the fitted spectrum is not stored!)
		%
                set(PeakFitAxis, 'nextplot', 'add');
                f = QmatNMR.InitialFitPars(PView).Fit;
                PFITX = QmatNMR.InitialFitPars(PView).Axis;
                plot(PFITX, f, QmatNMR.color(rem(1, length(QmatNMR.color)) + 1));


		%
		%Plot the individual fractions for the requested slice
		%
                if (npeaks > 1)                       %with multiple lines plot each one separate
                  fred = axis;
                  axis([fred(1) fred(2) fred(3) fred(4)]);

                  for i=1:npeaks
                    base = (i-1)*4;
                    lam(1:4) = QmatNMR.InitialFitPars(PView).Parameters((base+1):(base+4));
                    f = pk_voigt(PFITX,lam);
                    plot(PFITX, f, QmatNMR.color(rem(i+1, length(QmatNMR.color)) + 1));
                  end
                  set(PeakFitAxis, 'nextplot', 'replacechildren');
                end



	elseif strcmp(command,'refreshbut')			%refresh the screen by taking the current 1D/2D spectrum from the main window
	  global QmatNMR

	  QmatNMR.FitResults = 0;

          Pstdv = 1.0;

          QmatNMR.lowerbound = min([QmatNMR.xmin (QmatNMR.xmin+QmatNMR.totaalX)]);
          QmatNMR.upperbound = max([QmatNMR.xmin (QmatNMR.xmin+QmatNMR.totaalX)]);

          if (LinearAxis(QmatNMR.Axis1D))
            QmatNMR.resolution = abs( QmatNMR.Axis1D(1) - QmatNMR.Axis1D(2) );
            Qindex1 = find(QmatNMR.Axis1D>(QmatNMR.lowerbound-0.5*(QmatNMR.resolution)) & QmatNMR.Axis1D<=(QmatNMR.lowerbound+0.5*(QmatNMR.resolution)));
            Qindex2 = find(QmatNMR.Axis1D<=(QmatNMR.upperbound+0.5*(QmatNMR.resolution)) & QmatNMR.Axis1D>(QmatNMR.upperbound-0.5*(QmatNMR.resolution)));

          else
          			%non-linear axis -> use the one with the lowest distance to the next point in the axis vector
            [QTEMP1, Qindex1] = min(abs(QmatNMR.Axis1D - QmatNMR.lowerbound));
            [QTEMP1, Qindex2] = min(abs(QmatNMR.Axis1D - QmatNMR.upperbound));
          end

          QTEMP = sort([Qindex1 Qindex2]);
          Qindex1 = QTEMP(1);
          Qindex2 = QTEMP(2);

          if ((isempty(Qindex1)) | (Qindex1 < 1))
            Qindex1 = 1;
          end

          if ((isempty(Qindex2)) | (Qindex2 > QmatNMR.Size1D))
            Qindex2 = QmatNMR.Size1D;
          end

       	  QTEMP = get(refreshbut, 'value'); 	%what type of refresh was requested?
	  set(refreshbut, 'value', 1);		%reset refresh button

	  if (QTEMP == 2) 		%refresh current 1D
	    lsq(QmatNMR.Axis1D(Qindex1:Qindex2)',(real(QmatNMR.Spec1D(Qindex1:Qindex2)')));	%take the current 1D spectrum

          else 				%refresh 2D
            if (QmatNMR.Dim == 0)		%refresh 2D not possible for a 1D -> do refresh 1D anyway
              lsq(QmatNMR.Axis1D(Qindex1:Qindex2)',(real(QmatNMR.Spec1D(Qindex1:Qindex2)')));	%take the current 1D spectrum
            elseif (QmatNMR.Dim == 1)
              lsq(QmatNMR.Axis1D(Qindex1:Qindex2)',(real(QmatNMR.Spec2D(:, Qindex1:Qindex2)'))); 	%take all rows
            elseif (QmatNMR.Dim == 2)
              lsq(QmatNMR.Axis1D(Qindex1:Qindex2)',(real(QmatNMR.Spec2D(Qindex1:Qindex2, :))));	%take all columns
  	    end
	  end
	end
end

if (get(zombut,'Value')==1)
  ZoomMatNMR FitWindow on;
end
