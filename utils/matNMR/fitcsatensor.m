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
% fitquad fits a set of static CSA lineshapes.
%
% syntax:
%    [Results, Error, Fit] = fitcsatensor(ExpSpec, ExpAxis, Initial, Constants, SIMPLEXflag, GRADIENTflag, Epsilon, FitOptions, PlotIntermediate, NoFitFLAG)
% or
%    Constants = fitcsatensor(NrLines)
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
% [Intensity; sigma 11 (ppm); sigma 22 (ppm); sigma 33 (ppm); Gaussian Linebroadening (ppm); Lorentzian Linebroadening (ppm)]
% Furthermore a background and a slope are required. If the ForceSymmetric flag is set in the Constants variable then
% sigma 11 is in fact the sigma parallel whilst sigma 22 is not required and sigma 33 is the sigma_perpendicular
% (parallel and perpendicular towards the unique axis of the symmetric tensor)
%
% SIMPLEXflag and GRADIENTflag denote whether SIMPLEX and/or gradient algorithms should be used
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


function [varargout] = fitcsatensor(ExpSpec, ExpAxis, Initial, Constants, SIMPLEXflag, GRADIENTflag, Epsilon, FitOptions, PlotIntermediate, NoFitFLAG)


if (nargin == 0)
  Results.Intensity = NaN;
  Results.ForceSymmetric = 0;
  Results.sigma11 = NaN;
  Results.sigma22 = NaN;
  Results.sigma33 = NaN;
  Results.GaussianLB = NaN;
  Results.LorentzianLB = NaN;
  Results.Background = NaN;
  Results.Slope = NaN;
  varargout{1} = Results;
  
elseif (nargin == 1)
  NrLines = ExpSpec;
  for tel=1:NrLines
    Results(tel).Intensity = NaN;
    Results(tel).ForceSymmetric = 0;
    Results(tel).sigma11 = NaN;
    Results(tel).sigma22 = NaN;
    Results(tel).sigma33 = NaN;
    Results(tel).GaussianLB = NaN;
    Results(tel).LorentzianLB = NaN;
    Results(tel).Background = NaN;
    Results(tel).Slope = NaN;
  end
  varargout{1} = Results;
  
else
  if (nargin == 11)
    NoFitFLAG = 0;
  end
  
  
  if (NoFitFLAG)
    %Simulate the spectrum to check out the initial guess
    [Error, Fit2] = simcsatensor(Initial, ExpSpec, ExpAxis, Epsilon, Constants, PlotIntermediate);
    Result2 = Initial;

  else
    if (SIMPLEXflag)
      %
      %first SIMPLEX optimization
      %
      Params = Initial;
    
      disp('SIMPLEX algorithm:')
      tic
      Result = fminsearch('simcsatensor', Params, FitOptions, ExpSpec, ExpAxis, Epsilon, Constants, PlotIntermediate);
      disp(['SIMPLEX finished in ' num2str(toc) ' seconds']);
    
      %calculate spectrum after SIMPLEX is finished
      [Error, Fit] = simcsatensor(Result, ExpSpec, ExpAxis, Epsilon, Constants, PlotIntermediate);
    
    else
      FitHandle = 0;
      Result = Initial;
      Fit = ExpAxis * 0;
      Error = 0;
    end
    
    if (GRADIENTflag)
      disp('Quasi-Newton gradient algorithm:')
      Params = Result;
      tic
      Result2 = fminunc('simcsatensor', Params, FitOptions, ExpSpec, ExpAxis, Epsilon, Constants, PlotIntermediate);
      disp(['Gradient algorithm finished in ' num2str(toc) ' seconds']);
      
      %draw spectrum after gradient algorithm is finished
      [Error, Fit2] = simcsatensor(Result2, ExpSpec, ExpAxis, Epsilon, Constants, PlotIntermediate);

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
    if isnan(Constants(tel).sigma11)
      counter = counter + 1;
      Results(counter2) = Result2(counter);
    else
      Results(counter2) = Constants(tel).sigma11;
    end
    
    if Constants(tel).ForceSymmetric 	%symmetric tensor
      %
      %for a symmetric tensor sigma 11 is in fact sigma parallel. Sigma 22 is hence set equal to sigma 33
      %
      counter2 = counter2 + 2;
      if isnan(Constants(tel).sigma33)
        counter = counter + 1;
        Results(counter2) = Result2(counter);
      else
        Results(counter2) = Constants(tel).sigma33;
      end

      Results(counter2-1) = Results(counter2); 		%set sigma22 and sigma33 equal
    
    else 				%not symmetric
      counter2 = counter2 + 1;
      if isnan(Constants(tel).sigma22)
        counter = counter + 1;
        Results(counter2) = Result2(counter);
      else
        Results(counter2) = Constants(tel).sigma22;
      end

      counter2 = counter2 + 1;
      if isnan(Constants(tel).sigma33)
        counter = counter + 1;
        Results(counter2) = Result2(counter);
      else
        Results(counter2) = Constants(tel).sigma33;
      end
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
    
    fprintf(1, 'Fit results for line %d:  sigma_11 = %7.2f ppm, sigma_22 = %7.2f ppm, sigma_33 = %7.2f ppm\n                         LB (Gaussian) = %7.3f ppm, LB (Lorentzian) = %7.3f ppm, Intensity = %7.2f \n', tel, Results(((tel-1)*6+1):tel*6));
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
  Results = [Results Error];	%store Chi^2 also in results vector
  fprintf(1, 'Chi^2 : ERROR = %10.5g \n\n\n', Error);
  
  varargout{1} = Results;
  varargout{2} = Error;
  varargout{3} = Fit2;
end
