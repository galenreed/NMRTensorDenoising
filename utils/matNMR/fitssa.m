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
%
% fitssa fits a sideband manifold to extract tensor parameters.
%
% syntax:
%    [Results, Error, Fit] = fitssa(ExpSpec, ExpAxis, Initial, Constants, nu0, nur, SIMPLEXqu, GRADIENTqu, NrGammaAngles, Epsilon, FitOptions, PlotIntermediate, NoFitFLAG)
% or
%    Constants = fitssa
%
% The latter can be used to obtain a correct structure used for defining Constants. Any parameter defined as 
% constant during the fit must be given a value (instead of the default NaN).
%
% Results are the fitted parameters
% Error is the chi^2 error (if noise was correct)
% Fit is a matNMR structure with the fit
%
% ExpSpec is a vector with the experimental spectrum, to which ExpAxis denotes the corresponding axis. The
% axis vector must denote the index of the sideband in increasing value! So e.g. -10:10 where 0 is the centerband and
% -2 the sideband at omega0/(2*pi) - 2*omegar/(2*pi). Note that it is important during processing to know the sign
% of the gyromagnetic ratio of the nucleus of interest.
%
% Initial is the initial guess for the parameters in the fit. This requires 3 numbers denoting [delta (ppm); eta (0-1); ; Intensity]
%
% nu0 = omega0/(2*pi) is the larmor frequency for the nucleus of interest in MHz.
%
% nur = omegar/(2*pi) is the spinning speed in kHz.
%
% SIMPLEXqu and GRADIENTqu are indices into the vector pa, which denotes the number of powder averaging points. The scale is nonlinear
% so just try out values to see how many powder-averaging points are calculated. 
%
% NrGammaAngles are the number of gamma angles in the powder average, which also determines the number of subdivisions
% of 1 rotor period, i.e. the time resolution of the simulation.
%
% NOTE: Typically qu=6 (610 poweder-averaging) and NrGammaAngles=50 yields stable results in short calculation times.
%
% Epsilon is the standard deviation of the noise. This results in a proper chi^2 fit.
%
% FitOptions are the standard options as given by optimset, possibly modifed.
%
% PlotIntermediate is a flag to indicate whether a plot is made after each calculation
%
% NoFitFLAG is a flag to denote that only a simulation must be done with the parameters. (0=fit)
%
% Jacco van Beek
% 2006
%


function [varargout] = fitssa(ExpSpec, ExpAxis, Initial, Constants, nu0, nur, SIMPLEXqu, GRADIENTqu, NrGammaAngles, Epsilon, FitOptions, PlotIntermediate, NoFitFLAG)


if (nargin == 0)
  Results.Intensity = NaN;
  Results.delta = NaN;
  Results.eta = NaN;
  varargout{1} = Results;
  
else
  if (nargin == 11)
    NoFitFLAG = 0;
  end
  
  
  if (NoFitFLAG)
    %Simulate the spectrum to check out the initial guess
    [Error, Fit2] = simssa(Initial, nu0, nur, SIMPLEXqu, NrGammaAngles, ExpSpec, ExpAxis, Epsilon, Constants, PlotIntermediate);
    Result2 = Initial;

  else
    if (SIMPLEXqu > 1)
      %
      %first SIMPLEX optimization
      %
      Params = Initial;
    
      disp('SIMPLEX algorithm:')
      tic
      Result = fminsearch('simssa', Params, FitOptions, nu0, nur, SIMPLEXqu, NrGammaAngles, ExpSpec, ExpAxis, Epsilon, Constants, PlotIntermediate);
      disp(['SIMPLEX finished in ' num2str(toc) ' seconds']);
    
      %calculate spectrum after SIMPLEX is finished
      [Error, Fit] = simssa(Result, nu0, nur, SIMPLEXqu, NrGammaAngles, ExpSpec, ExpAxis, Epsilon, Constants, PlotIntermediate);
    
    else
      FitHandle = 0;
      Result = Initial;
      Fit = ExpAxis * 0;
      Error = 0;
    end
    
    if (GRADIENTqu > 1)
      disp('Quasi-Newton gradient algorithm:')
      Params = Result;
      tic
      Result2 = fminunc('simssa', Params, FitOptions, nu0, nur, GRADIENTqu, NrGammaAngles, ExpSpec, ExpAxis, Epsilon, Constants, PlotIntermediate);
      disp(['Gradient algorithm finished in ' num2str(toc) ' seconds']);
      
      %draw spectrum after gradient algorithm is finished
      [Error, Fit2] = simssa(Result2, nu0, nur, GRADIENTqu, NrGammaAngles, ExpSpec, ExpAxis, Epsilon, Constants, PlotIntermediate);

    else
      Result2 = Result;
      Fit2 = Fit;
    end
  end
    
  %
  %final output of parameters
  %
  counter = 0;
  counter2= 0;

  fprintf(1, '\n\n');
  counter2 = counter2 + 1;
  if isnan(Constants.delta)
    counter = counter + 1;
    Results(counter2) = Result2(counter);
  else
    Results(counter2) = Constants.delta;
  end
  
  counter2 = counter2 + 1;
  if isnan(Constants.eta)
    counter = counter + 1;
    Results(counter2) = abs(Result2(counter));
  else
    Results(counter2) = abs(Constants.eta);
  end

  counter2 = counter2 + 1;
  if isnan(Constants.Intensity)
    counter = counter + 1;
    Results(counter2) = Result2(counter);
  else
    Results(counter2) = Constants.Intensity;
  end
  
  fprintf(1, 'Fit results :  delta = %7.2f ppm, eta = %7.2f, Intensity = %7.2f \n', Results);
  Results = [Results Error]; 		%store Chi^2 in Results vector
  fprintf(1, 'Chi^2 : ERROR = %10.5g \n\n', Error);
  
  varargout{1} = Results;
  varargout{2} = Error;
  varargout{3} = Fit2;
end
