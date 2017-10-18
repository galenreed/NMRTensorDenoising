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
function Difffit(command) 
%  Difffit.m 
%  Created: 4-Mar-94 
%  Using  : GUIMaker by Patrick Marchand 
%                         (pmarchan@motown.ge.com) 
%  Author :  Sean M. Brennan (Bren@SLAC.stanford.edu)
%  Mods.  :  5-3-94 change cursor procedure
%   

%  Copyright (c) 1994 by Patrick Marchand 
%       Permission is granted to modify and re-distribute this 
%        code in any manner as long as this notice is preserved. 
%        All standard disclaimers apply. 

%
% adapted for matNMR by Jacco van Beek
% 1-1-'97
%
global PFITX PFITX2 PFITDY PFITFY PFIT_LAMBDA Pverbose Pstdv QmatNMR

if nargin == 0 
        command = 'init';
end 

if ~ strcmp(command,'init'), 
  [ed,ck, fitbut, TolBut, NrIterBut, redisbut, lijstbut, simplexbut, stopbut, printbut, refreshbut, defparsbut, logbut, txt1, txt2, txt5, txt6, txt7, txt8, txt9, txt10] = Diffpk_udata;

  DiffFitAxis=findobj(allchild(gcf), 'tag', 'DiffFitAxis');
  axes(DiffFitAxis);
end
 
if isstr(command) 
  if strcmp(command,'init') 
    Diffpk_init
    [ed,ck, fitbut, TolBut, NrIterBut, redisbut, lijstbut, simplexbut, stopbut, printbut, refreshbut, defparsbut, logbut, txt1, txt2, txt5, txt6, txt7, txt8, txt9, txt10] = Diffpk_udata;
    Diffpk_inivl(ck,ed);

    Pstdv = 1.0;
    Pverbose(1)=0;    %This will NOT tell them the results
    Pverbose(2)=1;    %This will replot each loop
    Pverbose(3)=1;
    
    DiffFitAxis=findobj(get(gcf, 'children'), 'tag', 'DiffFitAxis');
    axes(DiffFitAxis);

    plot(PFITX2, PFITDY, [QmatNMR.LineColor 'p--']);
    axis on
    set(DiffFitAxis, 'nextplot', 'replacechildren', ...
	             'units', 'normalized', ...
	             'position',[0.05 0.37 .9 .57], ...
		     'nextplot', 'replacechildren', ...
                     'XGrid','on', ...
		     'YGrid','on', ...
		     'FontSize', QmatNMR.TextSize, ...
		     'FontName', QmatNMR.TextFont, ...
		     'FontAngle', QmatNMR.TextAngle, ...
		     'FontWeight', QmatNMR.TextWeight, ...
		     'LineWidth', QmatNMR.LineWidth, ...
		     'visible','on', ...
		     'tag', 'DiffFitAxis', ...
		     'view', [0 90], ...
		     'color', QmatNMR.ColorScheme.AxisBack, ...
		     'xcolor', QmatNMR.ColorScheme.AxisFore, ...
		     'ycolor', QmatNMR.ColorScheme.AxisFore, ...
		     'zcolor', QmatNMR.ColorScheme.AxisFore, ...
		     'visible', 'on', ...
		     'xscale', 'linear', ...
		     'yscale', 'log', ...
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
    xlabel('gradient^2');

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
      set(DiffFitAxis, 'yscale', 'log');
      QTEMP = abs(max(PFITX2) - min(PFITX2));
      axis([min(PFITX2)-QTEMP/20 max(PFITX2)+QTEMP/20 (ymin-(10^floor(log10(abs(ymin)))/2)) (1.5*ymax)]);
      setappdata(DiffFitAxis, 'ZoomLimitsMatNMR', [min(PFITX2)-QTEMP/20 max(PFITX2)+QTEMP/20 (ymin-(10^floor(log10(abs(ymin)))/2)) (1.5*ymax)]);
    else
      set(DiffFitAxis, 'yscale', 'linear');
      QTEMP = abs(max(PFITX) - min(PFITX));
      axis([min(PFITX2)-QTEMP/20 max(PFITX2)+QTEMP/20 (ymin-0.1*ymax) (1.1*ymax)]);
      setappdata(DiffFitAxis, 'ZoomLimitsMatNMR', [min(PFITX2)-QTEMP/20 max(PFITX2)+QTEMP/20 (ymin-0.1*ymax) (1.1*ymax)]);
    end

    ZoomMatNMR FitWindow on
  
    disp('Diffusion fit succesfully initiated ...');
  	  
  elseif strcmp(command,'new')  	       %when a fit window is already opened, just update the plot
    plot(PFITX2, PFITDY, [QmatNMR.LineColor 'p--']);
    axis on
    set(DiffFitAxis, 'nextplot', 'replacechildren', ...
	             'units', 'normalized', ...
	             'position',[0.05 0.37 .9 .57], ...
		     'nextplot', 'replacechildren', ...
                     'XGrid','on', ...
		     'YGrid','on', ...
		     'FontSize', QmatNMR.TextSize, ...
		     'FontName', QmatNMR.TextFont, ...
		     'FontAngle', QmatNMR.TextAngle, ...
		     'FontWeight', QmatNMR.TextWeight, ...
		     'LineWidth', QmatNMR.LineWidth, ...
		     'visible','on', ...
		     'tag', 'DiffFitAxis', ...
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
    xlabel('gradient^2');

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
      set(DiffFitAxis, 'yscale', 'log');
      QTEMP = abs(max(PFITX2) - min(PFITX2));
      axis([min(PFITX2)-QTEMP/20 max(PFITX2)+QTEMP/20 (ymin-(10^floor(log10(abs(ymin)))/2)) (1.5*ymax)]);
      setappdata(DiffFitAxis, 'ZoomLimitsMatNMR', [min(PFITX2)-QTEMP/20 max(PFITX2)+QTEMP/20 (ymin-(10^floor(log10(abs(ymin)))/2)) (1.5*ymax)]);

    else
      set(DiffFitAxis, 'yscale', 'linear');
      QTEMP = abs(max(PFITX) - min(PFITX));
      axis([min(PFITX2)-QTEMP/20 max(PFITX2)+QTEMP/20 (ymin-0.1*ymax) (1.1*ymax)]);
      setappdata(DiffFitAxis, 'ZoomLimitsMatNMR', [min(PFITX2)-QTEMP/20 max(PFITX2)+QTEMP/20 (ymin-0.1*ymax) (1.1*ymax)]);
    end

    ZoomMatNMR FitWindow on

    Diffpk_inivl(ck,ed);
  	  
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


    %
    %setup the initial guess by reading out the buttons on the screen
    %
    PFIT_LAMBDA=zeros(1,lam_len);
    for i=1:lam_len,
      PFIT_LAMBDA(i)= str2num(get(ed(i),'String'));
    end
    %this is for the constant
    lam_len=lam_len+1;
    PFIT_LAMBDA(lam_len)= str2num(get(ed(9),'String'));
    %this is for the amplitude
    lam_len=lam_len+1;
    PFIT_LAMBDA(lam_len)= str2num(get(ed(10),'String'));

    constrain = Diffpk_gtcon(ck,lam_len);%which variables need to be fitted and which not ?
    npts=length(PFITX);
    wt=Pstdv * ones(npts,1);
    PFITFY=Diffpk_qvt(PFITX,PFIT_LAMBDA);

    %redraw the spectrum
    plot(PFITX2, PFITDY, [QmatNMR.LineColor 'p--'], PFITX2, PFITFY, QmatNMR.color(rem(1, length(QmatNMR.color)) + 1));
    axis on
    set(DiffFitAxis, 'nextplot', 'replacechildren', ...
	             'units', 'normalized', ...
	             'position',[0.05 0.37 .9 .57], ...
		     'nextplot', 'replacechildren', ...
                     'XGrid','on', ...
		     'YGrid','on', ...
		     'FontSize', QmatNMR.TextSize, ...
		     'FontName', QmatNMR.TextFont, ...
		     'FontAngle', QmatNMR.TextAngle, ...
		     'FontWeight', QmatNMR.TextWeight, ...
		     'LineWidth', QmatNMR.LineWidth, ...
		     'visible','on', ...
		     'tag', 'DiffFitAxis', ...
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
    xlabel('gradient^2');

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
      set(DiffFitAxis, 'yscale', 'log');
      QTEMP = abs(max(PFITX2) - min(PFITX2));
      axis([min(PFITX2)-QTEMP/20 max(PFITX2)+QTEMP/20 (ymin-(10^floor(log10(abs(ymin)))/2)) (1.5*ymax)]);
    else
      set(DiffFitAxis, 'yscale', 'linear');
      QTEMP = abs(max(PFITX) - min(PFITX));
      axis([min(PFITX2)-QTEMP/20 max(PFITX2)+QTEMP/20 (ymin-0.1*ymax) (1.1*ymax)]);
    end

    ZoomMatNMR FitWindow on
    drawnow;
    set(gcf,'Pointer','watch');
  
    FITtol = str2num(get(TolBut, 'String'));
    FITMaxIter = str2num(get(NrIterBut, 'String'));

    %start the fit and time it
    tic;
    [PFITFY,PFIT_LAMBDA,kvg,iter,corp,covp,covr,stdresid,Z,r2]= ...
    Diffleasqr(PFITX,PFITDY,PFIT_LAMBDA,'Diffpk_qvt',FITtol,FITMaxIter,wt,constrain ...
    ,'Diffpk_qvtdf');
    toc;

    ZoomMatNMR FitWindow on

    %read out the parameters and produce output.
    set(gcf,'Pointer','arrow');
    
    chi2= sum(((PFITDY-PFITFY).*wt).^2)/(npts-lam_len);
    fprintf(1, 'Chisqr= %g\n',chi2);

    for i=1:lam_len-2,
      set(ed(i),'String',num2str(PFIT_LAMBDA(i)));
    end
    set(ed(9),'String',num2str(PFIT_LAMBDA(lam_len-1)));
    set(ed(10), 'String',num2str(PFIT_LAMBDA(lam_len)));
    
    %The matrix with the fit results is built up like :
    %	       - fit parameters :
    %		       - For each exponential
    %			       - coefficient
    %			       - time constant
    %		       - constant
    %		       - amplitude
    %

    Ptemp = [PFIT_LAMBDA];
  
    %
    %Store the fit into a structure variable
    %
    if isfield(QmatNMR, 'DiffFitResults')
      QmatNMR = rmfield(QmatNMR, 'DiffFitResults');
    end
    QmatNMR.DiffFitResults.Parameters 	= Ptemp;
    QmatNMR.DiffFitResults.Fit      	= PFITFY;
    QmatNMR.DiffFitResults.Data     	= PFITDY;
    QmatNMR.DiffFitResults.Axis     	= PFITX;
    QmatNMR.DiffFitResults.Error    	= chi2;
    QmatNMR.DiffFitResults.Sigma       	= Pstdv;
    QmatNMR.DiffFitResults.Constraints 	= cell2mat(get(ck([1:(lam_len-2) 9 10]), 'value'));

    %
    %to store the results we need to make the designated variable global. In case the name
    %points to a structure variable, we need to use only the main variable, hence the following
    %check.
    %
    QTEMP = findstr(QmatNMR.VariableNameDiffFit, '.');
    if QTEMP
      eval(['global ' QmatNMR.VariableNameDiffFit(1:(QTEMP-1))]);
    else
      eval(['global ' QmatNMR.VariableNameDiffFit]);
    end
    eval([QmatNMR.VariableNameDiffFit ' = QmatNMR.DiffFitResults;']);

    fprintf(1, '\n\n');			      %Show FitResults and give concluding NOTICE
    QmatNMR.DiffFitResults.Parameters
    fprintf(1, '\n\nFitting finished ...\nThe results have been written to "%s" in the MATLAB workspace.\nType "global %s" once to allow access to the variable\n\n', QmatNMR.VariableNameDiffFit, QmatNMR.VariableNameDiffFit);
    fprintf(1, 'For Matlab 7: use "cell2mat(cellfun(@(x) x,{%s.Parameters},''UniformOutput'', false)'')"\nto convert an array of structures into a matrix for further manipulation.\n\n', QmatNMR.VariableNameDiffFit);
  
  

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
      set(DiffFitAxis, 'yscale', 'log');
      QTEMP = abs(max(PFITX2) - min(PFITX2));
      axis([min(PFITX2)-QTEMP/20 max(PFITX2)+QTEMP/20 (ymin-(10^floor(log10(abs(ymin)))/2)) (1.5*ymax)]);
      setappdata(DiffFitAxis, 'ZoomLimitsMatNMR', [min(PFITX2)-QTEMP/20 max(PFITX2)+QTEMP/20 (ymin-(10^floor(log10(abs(ymin)))/2)) (1.5*ymax)]);
    else
      set(DiffFitAxis, 'yscale', 'linear');
      QTEMP = abs(max(PFITX) - min(PFITX));
      axis([min(PFITX2)-QTEMP/20 max(PFITX2)+QTEMP/20 (ymin-0.1*ymax) (1.1*ymax)]);
      setappdata(DiffFitAxis, 'ZoomLimitsMatNMR', [min(PFITX2)-QTEMP/20 max(PFITX2)+QTEMP/20 (ymin-0.1*ymax) (1.1*ymax)]);
    end

    ZoomMatNMR FitWindow on
  	 
  	 
  elseif strcmp(command,'lijstbut')			   %Button for extended output for each fit
    Pverbose(1) = get(lijstbut,'Value');

  elseif strcmp(command,'simplexbut')			     %Button for Simplex prefit
    Pverbose(3) = get(simplexbut,'Value');

  elseif strcmp(command,'loadpars1')			    %Load parameters input window
    QuiInput('Load fit parameters from the workspace :', ' OK | CANCEL', 'regelloadparsDiff;', [], 'Name of variable :', QmatNMR.ViewNameDiffFit);

  elseif strcmp(command,'loadpars2')			    %Load parameters input window callback
    QmatNMR.ViewNameDiffFit = QmatNMR.GetString;
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
      for teller=1:9		      %First clear the old values
  	set(ed(teller), 'String', '');
      end
  	
  				      %Then put in the new values  
      npeaks = ((QTEMP9-2) / 2);
  	
      for teller=1:(QTEMP9-2)
  	set(ed(teller), 'String', num2str(QmatNMR.InitialFitPars.Parameters(teller), 8));
      end

      set(ed(9), 'String', num2str(QmatNMR.InitialFitPars.Parameters(QTEMP9-1)));
      set(ed(10), 'String', num2str(QmatNMR.InitialFitPars.Parameters(QTEMP9)));
                  
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



  elseif strcmp(command,'defvar1')			  %Define variable name for Results
    QuiInput('Define Results Variable :', ' OK | CANCEL', 'regeldefvarDiff;', [], 'Name of variable :', QmatNMR.VariableNameDiffFit);

  elseif strcmp(command,'defvar2')			  %Define variable name for Results callback
    QmatNMR.VariableNameDiffFit = QmatNMR.uiInput1;
    %
    %to store the results we need to make the designated variable global. In case the name
    %points to a structure variable, we need to use only the main variable, hence the following
    %check.
    %
    QTEMP = findstr(QmatNMR.VariableNameDiffFit, '.');
    if QTEMP
      eval(['global ' QmatNMR.VariableNameDiffFit(1:(QTEMP-1))]);
    else
      eval(['global ' QmatNMR.VariableNameDiffFit]);
    end
    eval([QmatNMR.VariableNameDiffFit ' = 1;']);
    disp('  ');
    disp(['matNMR NOTICE: new variable name "' QmatNMR.VariableNameDiffFit '" defined for Diffusion fitting results. ']);
    disp(['matNMR NOTICE: To be able to access this variable please type:']);
    disp('  ');
    if QTEMP
      disp(['		   global ' QmatNMR.VariableNameDiffFit(1:(QTEMP-1))]);
    else
      disp(['		   global ' QmatNMR.VariableNameDiffFit]);
    end
    disp('  ');



  elseif strcmp(command,'view1')				%View Fit Results input window
    QuiInput('View Fit Results :', ' OK | CANCEL', 'regelviewresultsDiff;', [], 'Name of variable :', QmatNMR.ViewNameDiffFit);

  elseif strcmp(command,'view2')				%View Fit Results input window callback
    QmatNMR.ViewNameDiffFit = QmatNMR.GetString;
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
      npeaks = ((QTEMP9-2) / 2);

      %
      %write results to the console window
      %
      s1 = sprintf('Diff Fit Results of variable "%s" :\n\n   Number of Exponentials  =  %d\n	Chi^2 =  %4.5f\n', QmatNMR.uiInput1, npeaks, QmatNMR.InitialFitPars.Error);
      
      for teller = 1:npeaks
  	s2 = sprintf('   Exponential %d:   Coefficient = %0.7g\n		    D		= %6.2f\n', ...
  		       teller, QmatNMR.InitialFitPars.Parameters(1+((teller-1)*2)), QmatNMR.InitialFitPars.Parameters(2+((teller-1)*2)));
  	s1 = str2mat(s1, s2); 
      end
      
      s3 = sprintf('   Constant  =  %0.5g\n   Amplitude =  %0.7g\n\n\n', QmatNMR.InitialFitPars.Parameters(QTEMP9-1), QmatNMR.InitialFitPars.Parameters(QTEMP9));
      s1 = str2mat(s1, s3);

      disp(s1);


      %
      %write values to the UIcontrols
      %
      for teller=1:(QTEMP9-2)
  	set(ed(teller), 'String', num2str(QmatNMR.InitialFitPars.Parameters(teller), 8));
      end

      set(ed(9), 'String', num2str(QmatNMR.InitialFitPars.Parameters(QTEMP9-1)));
      set(ed(10), 'String', num2str(QmatNMR.InitialFitPars.Parameters(QTEMP9)));

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


      %
      %plot the data and fit
      %
      PFITX2 = QmatNMR.InitialFitPars.Axis;
      PFITDY = QmatNMR.InitialFitPars.Data;
      PFITFY = QmatNMR.InitialFitPars.Fit;
      plot(PFITX2, PFITDY, [QmatNMR.LineColor 'p'], PFITX2, PFITFY, QmatNMR.color(rem(1, length(QmatNMR.color)) + 1));
      axis on
      set(DiffFitAxis, 'nextplot', 'replacechildren', ...
  	             'units', 'normalized', ...
  	             'position',[0.05 0.37 .9 .57], ...
  		     'nextplot', 'replacechildren', ...
                     'XGrid','on', ...
  		     'YGrid','on', ...
  		     'FontSize', QmatNMR.TextSize, ...
  		     'FontName', QmatNMR.TextFont, ...
  		     'FontAngle', QmatNMR.TextAngle, ...
  		     'FontWeight', QmatNMR.TextWeight, ...
  		     'LineWidth', QmatNMR.LineWidth, ...
  		     'visible','on', ...
  		     'tag', 'DiffFitAxis', ...
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
      xlabel('gradient^2');

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
        set(DiffFitAxis, 'yscale', 'log');
        QTEMP = abs(max(PFITX2) - min(PFITX2));
        axis([min(PFITX2)-QTEMP/20 max(PFITX2)+QTEMP/20 (ymin-(10^floor(log10(abs(ymin)))/2)) (1.5*ymax)]);
        setappdata(DiffFitAxis, 'ZoomLimitsMatNMR', [min(PFITX2)-QTEMP/20 max(PFITX2)+QTEMP/20 (ymin-(10^floor(log10(abs(ymin)))/2)) (1.5*ymax)]);
      else
        set(DiffFitAxis, 'yscale', 'linear');
        QTEMP = abs(max(PFITX) - min(PFITX));
        axis([min(PFITX2)-QTEMP/20 max(PFITX2)+QTEMP/20 (ymin-0.1*ymax) (1.1*ymax)]);
        setappdata(DiffFitAxis, 'ZoomLimitsMatNMR', [min(PFITX2)-QTEMP/20 max(PFITX2)+QTEMP/20 (ymin-0.1*ymax) (1.1*ymax)]);
      end
  
      ZoomMatNMR FitWindow on
    else  
      error('matNMR ERROR: the length of the vector is not correct !!');
    end



  elseif strcmp(command,'viewadd1')				%Add Fit Results to plot
    QuiInput('Add Fit Results to Plot:', ' OK | CANCEL', 'regelviewaddresultsDiff;', [], 'Name of variable :', QmatNMR.ViewNameDiffFit);

  elseif strcmp(command,'viewadd2')				%View Fit Results input window callback
    QmatNMR.ViewNameDiffFit = QmatNMR.GetString;
    QmatNMR.InitialFitPars = QmatNMR.GetVar;

    %find the right axis
    QTEMP = findobj(allchild(0), 'tag', 'DiffFitAxis');
    set(get(QTEMP, 'parent'), 'currentaxes', QTEMP)
    
    %define the string that needs to be plotted and put it in the screen
    QTEMP1 = 0;
    if (mod((length(QmatNMR.DiffFitResults.Parameters)-2), 2) == 0)
      npeaks = ((length(QmatNMR.DiffFitResults.Parameters)-2) / 2);
    
      s1 = sprintf('   Diffusion Fit Results :\n\n   Number of Exponentials  =  %d\n   Chi^2 =  %4.5e\n', npeaks, QmatNMR.DiffFitResults.Error);
      snew = s1;
      
      for teller = 1:npeaks
        s2 = sprintf('\n   Exponential %d:   Coefficient = %0.3g\n %s %6.3g %s\n', ...
                     teller, QmatNMR.DiffFitResults.Parameters(1+((teller-1)*2)),'                            \bfD             =',QmatNMR.DiffFitResults.Parameters(2+((teller-1)*2)),' \rm');
        snew = strcat(snew, s2);
        s1 = str2mat(s1, s2); 
      end
      
      s3 = sprintf('   Constant  =  %0.5g\n   Amplitude =  %0.7g\n\n\n', QmatNMR.DiffFitResults.Parameters(length(QmatNMR.DiffFitResults.Parameters)-1), QmatNMR.DiffFitResults.Parameters(length(QmatNMR.DiffFitResults.Parameters)));
      snew = strcat(snew, s3);
    
      QmatNMR.Xlim = get(QTEMP, 'xlim');
      QmatNMR.Ylim = get(QTEMP, 'ylim');
      
      %
      %place the text with the parameters in the middle of the axis
      %
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
    end



  elseif strcmp(command,'refreshbut')			     	%update the screen by taking the current diffusion curve
    global QmatNMR
    Difflsq(QmatNMR.Axis1D',(real(QmatNMR.Spec1D')));			%take the 1D spectrum = diffusion-curve



  elseif strcmp(command,'defparsbut')			     	%start the process of getting all necessary constants
    QuiInput('Input constants :', ' OK | READ Bruker | CANCEL', 'regeldefparsDiff;', [], ...
  	     '\gamma/2\pi in MHz/T :', num2str(QmatNMR.DiffGamma, 15), ...
  	     'Gradient duration \delta in s :', num2str(QmatNMR.Diffdelta, 15), ...
             '\alpha :', num2str(QmatNMR.Diffalpha, 15), ...
  	     'Gradient spacing \Delta in s :', num2str(QmatNMR.DiffDELTA, 15), ...
             '\tau (\pi-pulse) for bipolar gradients in s (0 if not applicable) :', num2str(QmatNMR.Difftau, 15), ...
             '\beta :', num2str(QmatNMR.Diffbeta, 15));



  elseif strcmp(command,'defparsbut2')  		      	%continue the process of getting all necessary constants
  end
end
