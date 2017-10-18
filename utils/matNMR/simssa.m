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
% simssa simulated the sideband pattern for a given tensor, spinning speed and carrier frequency. This uses
% the gamma-COMPUTE algorithm.
%
% syntax:
%    [Error, SSA] = simssa(Params, nu0, nur, qu, NrGammaAngles, RefSpec, RefAxis, Epsilon, Constants, PlotIntermediate)
%
% Error is the chi^2 error (if noise was correct)
% SSA is the simulated set of sideband amplitudes
%
% Params are the parameters in the simulation. This requires 3 numbers denoting [delta (ppm); eta (0-1); ; Intensity]
%
% nu0 = omega0/(2*pi) is the larmor frequency for the nucleus of interest in MHz.
%
% nur = omegar/(2*pi) is the spinning speed in kHz.
%
% qu is an index into the vector pa, which denotes the number of powder averaging points. The scale is nonlinear
% so just try out values to see how many powder-averaging points are calculated. 
%
% NrGammaAngles are the number of gamma angles in the powder average, which also determines the number of subdivisions
% of 1 rotor period, i.e. the time resolution of the simulation.
%
% NOTE: Typically qu=6 (610 poweder-averaging) and NrGammaAngles=50 yields stable results in short calculation times.
%
% RefSpec is a vector with the experimental sideband intensities, to which RefAxis denotes the corresponding axis. The
% axis vector must denote the index of the sideband in increasing value! So e.g. -10:10 where 0 is the centerband and
% -2 the sideband at omega0/(2*pi) - 2*omegar/(2*pi). Note that it is important during processing to know the sign
% of the gyromagnetic ratio of the nucleus of interest.
%
% Epsilon is the standard deviation of the noise. This results in a proper chi^2 fit.
%
% Constants are the parameters that remain constant during a fit. See fitssa on how to generate this variable!
%
% PlotIntermediate is a flag to indicate whether a plot is made after each calculation
%
% Jacco van Beek
% 2007
%


function [Error, SSA] = simssa(Params, nu0, nur, qu, NrGammaAngles, RefSpec, RefAxis, Epsilon, Constants, PlotIntermediate)

global QmatNMR

%
%make sure that the reference spectrum and axis are row vectors
%
RefSpec = RefSpec(:).';
RefAxis = RefAxis(:).';
AxisLength = length(RefAxis);


%
%define the parameters [delta, eta, Intensity] using either the constant values in Constants
%or the values in Parameters.
%
if ~isstruct(Constants)
  error('simssa ERROR: Constants parameter is not of right type. Aborting ...');
end
try
  counter = 0;
  if isnan(Constants.delta)
    counter = counter + 1;
    delta = Params(counter);
  else
    delta = Constants.delta;
  end
  
  if isnan(Constants.eta)
    counter = counter + 1;
    eta = Params(counter);
  else
    eta = Constants.eta;
  end

  if isnan(Constants.Intensity)
    counter = counter + 1;
    Intensity = Params(counter);
  else
    Intensity = Constants.Intensity;
  end
  
catch
  error('simssa ERROR: length of parameter vector is inconsistent with defined constants! Aborting ...')
end
if counter ~= length(Params)
  error('simssa ERROR: length of parameter vector is inconsistent with defined constants! Aborting ...')
end


%
%Convert the parameters to their proper units
%
omega0 = nu0*1e6*pi*2; 		%2*pi*nu with nu in Hz
omegar = nur*1e3*pi*2; 		%2*pi*nu with nu in Hz
delta = delta * 1e-6; 		%delta in ppm
nsteps = NrGammaAngles;
tresolution = 2*pi/omegar/nsteps;
tarray = 0:tresolution:(nsteps-1)*tresolution;


%
%for a proper chi^2 calculation
%
if (abs(Epsilon) < eps)
  Epsilon = 1;
end


%
%perform the gamma-averaged calculation (follows the symvols from the gamma-COMPUTE paper!)
%

%
%values for number of points in two-angle powder averaging and the weighting function
%
pa = [3, 21, 144, 233, 399, 610, 987, 1583, 2741, 4409, 6997, 11657, 17389, 28499, 43051, 65063, 79999, 2943631];
pb = [2, 13,  37, 163, 359, 269, 937, 1153, 1117, 1171, 3049,   131,  1787,  5879,  4649,  5237, 74729,  702707];
NrPP = pa(qu);
beta  = pi * ((1:NrPP)-1)/NrPP;
alpha = 2*pi * (mod(pb(qu)*((1:NrPP)-1), NrPP)/NrPP);
gamma = 0;
weight = sin(beta) / NrPP;
weightMatrix = weight.' * ones(1, nsteps);


%
%determine the sideband manifold requested by the user through the RefAxis
%
FFTstart = floor((-nsteps+1)/2); 	%starting point of the sideband manifold
FFTstop  = nsteps -1 + FFTstart; 	%end point of the sideband manifold
FFTNrSidebands = nsteps;
FFTvector = FFTstart:FFTstop;

if (sum((RefAxis - round(RefAxis)).^2) > 1e-10)
  error('simssa WARNING: axis vector appears not to be correctly denoting sideband indices. Aborting ...')
  return
end
for tel=1:length(RefAxis)
  SSAindexFFT(tel) = find(FFTvector == RefAxis(tel));
end
SSA = 0*RefAxis;


%
%calculate all frequencies for all crystallites at all times.
%
omegars = FrequencyMAS(omega0, delta, eta, omegar, alpha, beta, gamma, tarray);


%
%these are the QTrs factors for all crystallites and all time steps
%
QTrs = ones(NrPP, nsteps);
for j=2:nsteps
  QTrs(:, j) = exp(-sqrt(-1)*sum(omegars(:, 1:(j-1)), 2)*tresolution);
end


%
%these are the rhoT0sr factors for all crystallites and all time steps
%
rhoT0sr = conj(QTrs);


%
%calculate the gamma-averaged FID over 1 rotor period for all crystallites
%
for j=0:nsteps-1
  favrs(:, j+1) = sum(rhoT0sr .* (QTrs(:, mod( (0:nsteps-1)+j, nsteps) +1)), 2);
end


%
%apply the weight of the powder averaging scheme (sideband intensities are independent of nsteps and NrPP!!)
%
favrs = favrs .* weightMatrix / nsteps^2;


%
%calculate the sideband intensities by doing an FT and pick the ones that are needed further
%
sidebands = fftshift(real(fft(sum(favrs))));
sidebands = sidebands/sum(sidebands);
SSA = Intensity*sidebands(SSAindexFFT);


%
%prepare for final output by making the spectrum the right size and by calculationg the error
%
Error = sum( real(SSA - RefSpec).^2 )/Epsilon^2/(AxisLength-length(Params));


%
%update the plot, if asked for
%
if (PlotIntermediate)
  SSAFitFigure = findobj(0, 'Tag', 'SSAFit');
  SSAFitAxis = findobj(get(SSAFitFigure, 'children'), 'tag', 'SSAFitAxis');
  tmp = get(SSAFitAxis, 'nextplot');
  hold on
  delete(findobj(allchild(SSAFitFigure), 'tag', 'SSAFitHandle'))
  if (gcf ~= SSAFitFigure)
    figure(SSAFitFigure);
  end
  if (RefAxis(1) < RefAxis(2))
    SSAFitHandle = plot(RefAxis, SSA, QmatNMR.color(rem(1, length(QmatNMR.color)) + 1));
    set(SSAFitAxis, 'xdir', 'reverse');
  else
    SSAFitHandle = plot(fliplr(RefAxis), fliplr(SSA), QmatNMR.color(rem(1, length(QmatNMR.color)) + 1));
    set(SSAFitAxis, 'xdir', 'normal');
  end
  set(SSAFitAxis, 'xdir', 'reverse', 'nextplot', tmp);
  set(SSAFitHandle, 'tag', 'SSAFitHandle')
  drawnow
end

















%
%Here we calculate the frequencies encountered for all powder averaging
%points in the mesh and for all the time steps on a rotor period at once.
%So, alpha and beta and t can be arrayed for optimum speed.
%This is eq. 4.17 from Matthias' 2006 lecture notes.
%
function Freq = FrequencyMAS(omega0, delta, eta, omegar, alpha, beta, gamma, t)

  Freq = zeros(length(alpha), length(t));

  alpha = alpha(:);
  beta = beta(:);
  gamma=gamma(:);
  t = t(:).';

  sinBeta = sin(beta);
  cosBeta = cos(beta);
  sin2Alpha = sin(2*alpha);
  cos2Alpha = cos(2*alpha);

  C1 = sqrt(2)/3 * omega0 * delta * sinBeta .* cosBeta .* (3 + eta*cos2Alpha);
  S1 = sqrt(2)/3 * omega0 * delta .* sinBeta * eta .* sin2Alpha;
  C2 = -omega0 * delta / 3 * ( 3/2*sinBeta.^2 - eta/2*(1+cosBeta.^2).*cos2Alpha );
  S2 =  omega0 * delta / 3 * eta * cosBeta .* sin2Alpha;

  if (length(gamma) == 1) 		%if gamma is a constant then use a fast vectorized approach
    Freq = C1 * cos(omegar*t - gamma) + S1 * sin(omegar*t-gamma) + C2 * cos(2*omegar*t - 2*gamma) + S2 * sin(2*omegar*t - 2*gamma);

  else 					%otherwise assume that the array in t is shorter than the array the angles
    for tel=1:length(t)
      Freq(:, tel) = C1 .* cos(omegar*t(tel) - gamma) + S1 .* sin(omegar*t(tel)-gamma) + C2 .* cos(2*omegar*t(tel) - 2*gamma) + S2 .* sin(2*omegar*t(tel) - 2*gamma);
    end
  end
