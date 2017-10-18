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
% fitquadtensor fits a set of second-order quadrupole lineshapes at infinite magic-angle spinning speed
% For a decent fit make sure the initial guess for the isotropic chemical shift is accurate!
%
% syntax:
%    [Results, Error, Fit, FitAxis] = fitquadtensor(ExpSpec, ExpAxis, Initial, Constants, qn, omega0, SIMPLEXqu, GRADIENTqu, FixedResolution, Epsilon, FitOptions, PlotIntermediate, NoFitFLAG)
% or
%    Constants = fitquadtensor(NrLines)
%
% The latter can be used to obtain a correct structure used for defining Constants. Any parameter defined as 
% constant during the fit must be given a value (instead of the default NaN).
%
% Results are the fitted parameters
% Error is the chi^2 error (if noise was correct)
% Fit is a matNMR structure with the fit
%
% ExpSpec is a vector with the experimental spectrum, to which ExpAxis denotes the corresponding axis in ppm.
%
% Initial is the initial guess for the parameters in the fit. For each line in the spectrum this requires 5 numbers denoting
% [Intensity; isotropic shift (ppm); Cqcc (MHz); eta; Gaussian Linebroadening (ppm); Lorentzian Linebroadening (ppm)]
% Furthermore a background and a slope are required.
%
% qn is the quantum number of the nucleus of interest, e.g. 3/2, 5/2, 7/2, 9/2 or 11/2
%
% omega0 is the larmor frequency for the nucleus of interest in MHz.
%
% SIMPLEXqu and GRADIENTqu are indices into the vector pa, which denotes the number of powder averaging points. The scale is nonlinear
% so just try out values to see how many powder-averaging points are calculated. 
%
% FixedResolution is the resolution in ppm to which the experimental spectrum is interpolated
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


function [varargout] = fitquadtensor(ExpSpec, ExpAxis, Initial, Constants, qn, omega0, SIMPLEXqu, GRADIENTqu, FixedResolution, Epsilon, FitOptions, PlotIntermediate, NoFitFLAG)


if (nargin == 0)
  Results.Intensity = NaN;
  Results.iso = NaN;
  Results.Cqcc = NaN;
  Results.eta = NaN;
  Results.GaussianLB = NaN;
  Results.LorentzianLB = NaN;
  Results.Background = NaN;
  Results.Slope = NaN;
  varargout{1} = Results;
  
elseif (nargin == 1)
  NrLines = ExpSpec;
  for tel=1:NrLines
    Results(tel).Intensity = NaN;
    Results(tel).iso = NaN;
    Results(tel).Cqcc = NaN;
    Results(tel).eta = NaN;
    Results(tel).GaussianLB = NaN;
    Results(tel).LorentzianLB = NaN;
    Results(tel).Background = NaN;
    Results(tel).Slope = NaN;
  end
  varargout{1} = Results;
  
else
  if (nargin == 12)
    NoFitFLAG = 0;
  end
  
FixedResolution
  %
  %interpolate the experimental spectrum to a fixed ppm/point frequency grid
  %
  maxxo = round(max(ExpAxis));
  minno = round(min(ExpAxis));
  RefAxis = minno:FixedResolution:maxxo;
  RefSpec = interp1(ExpAxis, real(ExpSpec), RefAxis, 'spline');
  
  
  %
  %define a set of powder averaging points (two-angle ZCW)
  %
  pa = [3, 21, 144, 233, 399, 610, 987, 1583, 2741, 4409, 6997, 11657, 17389, 28499, 43051, 65063, 79999, 2943631];
  pb = [2, 13,  37, 163, 359, 269, 937, 1153, 1117, 1171, 3049,   131,  1787,  5879,  4649,  5237, 74729,  702707];
  
  if (NoFitFLAG)
    %Simulate the spectrum to check out the initial guess
    [Error, Fit2, FitAxis] = simquadtensor(Initial, qn, omega0, SIMPLEXqu, RefSpec, RefAxis, Epsilon, Constants, PlotIntermediate);
    Result2 = Initial;

  else
    if (SIMPLEXqu > 1)
      %
      %first SIMPLEX optimization
      %
      Params = Initial;
    
      disp('SIMPLEX algorithm:')
      disp(['Fitting data with ' num2str(pa(SIMPLEXqu), 10) ' powder averaging points.']);
      tic
      Result = fminsearch('simquadtensor', Params, FitOptions, qn, omega0, SIMPLEXqu, RefSpec, RefAxis, Epsilon, Constants, PlotIntermediate);
      disp(['SIMPLEX finished in ' num2str(toc) ' seconds']);
    
      %calculate spectrum after SIMPLEX is finished
      [Error, Fit, FitAxis] = simquadtensor(Result, qn, omega0, SIMPLEXqu, RefSpec, RefAxis, Epsilon, Constants, PlotIntermediate);
    
    else
      FitHandle = 0;
      Result = Initial;
      Fit = RefAxis * 0;
      FitAxis = RefAxis;
      Error = 0;
    end
    
    if (GRADIENTqu > 1)
      disp('Quasi-Newton gradient algorithm:')
      disp(['Fitting data with ' num2str(pa(GRADIENTqu), 10) ' powder averaging points.']);
      Params = Result;
      tic
      Result2 = fminunc('simquadtensor', Params, FitOptions, qn, omega0, GRADIENTqu, RefSpec, RefAxis, Epsilon, Constants, PlotIntermediate);
      disp(['Gradient algorithm finished in ' num2str(toc) ' seconds']);
      
      %draw spectrum after gradient algorithm is finished
      [Error, Fit2, FitAxis] = simquadtensor(Result2, qn, omega0, GRADIENTqu, RefSpec, RefAxis, Epsilon, Constants, PlotIntermediate);

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

  NrLines = length(Constants);
  fprintf(1, '\n\n');
  for tel=1:NrLines
    counter2 = counter2 + 1;
    if isnan(Constants(tel).iso)
      counter = counter + 1;
      Results(counter2) = Result2(counter);
    else
      Results(counter2) = Constants(tel).iso;
    end
    
    counter2 = counter2 + 1;
    if isnan(Constants(tel).Cqcc)
      counter = counter + 1;
      Results(counter2) = Result2(counter);
    else
      Results(counter2) = Constants(tel).Cqcc;
    end
    
    counter2 = counter2 + 1;
    if isnan(Constants(tel).eta)
      counter = counter + 1;
      Results(counter2) = Result2(counter);
    else
      Results(counter2) = Constants(tel).eta;
    end
    
    counter2 = counter2 + 1;
    if isnan(Constants(tel).GaussianLB)
      counter = counter + 1;
      Results(counter2) = abs(Result2(counter));
    else
      Results(counter2) = abs(Constants(tel).GaussianLB);
    end
    
    counter2 = counter2 + 1;
    if isnan(Constants(tel).LorentzianLB)
      counter = counter + 1;
      Results(counter2) = abs(Result2(counter));
    else
      Results(counter2) = abs(Constants(tel).LorentzianLB);
    end

    counter2 = counter2 + 1;
    if isnan(Constants(tel).Intensity)
      counter = counter + 1;
      Results(counter2) = Result2(counter);
    else
      Results(counter2) = Constants(tel).Intensity;
    end
    
    fprintf(1, 'Fit results for line %d:  isoCS = %7.2f ppm, Cq = %6.4f MHz, eta = %5.3f\n                         LB (Gaussian) = %7.3f ppm, LB (Lorentzian) = %7.3f ppm, Intensity = %7.2f \n', tel, Results(((tel-1)*6+1):tel*6));
  end
    
  counter2 = counter2 + 1;
  if isnan(Constants(NrLines).Background)
    counter = counter + 1;
    Results(counter2) = Result2(counter);
  else
    Results(counter2) = Constants(NrLines).Background;
  end
  counter2 = counter2 + 1;
  if isnan(Constants(NrLines).Slope)
    counter = counter + 1;
    Results(counter2) = Result2(counter);
  else
    Results(counter2) = Constants(NrLines).Slope;
  end
  fprintf(1, 'Background = %7.2f, Slope = %7.2f\n', Results(end-1:end));
  Results = [Results Error];
  fprintf(1, 'Chi^2 : ERROR = %10.5g \n\n\n', Error);
  
  varargout{1} = Results;
  varargout{2} = Error;
  varargout{3} = Fit2;
  varargout{4} = FitAxis;
end
