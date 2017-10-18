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
% simquadtensor simulates a set of second-order quadrupole lineshapes at infinite magic-angle spinning speed
%
% syntax:
%    [Error, Spec, RefAxis] = simquadtensor(Params, qn, omega0, qu, RefSpec, RefAxis, Epsilon, Constants, PlotIntermediate)
%
% Error is the chi^2 error (if noise was correct)
% Spec is the simulated spectrum
% RefAxis is the axis vector for the simulated spectrum
%
% Params are the parameters in the simulation. For each line in the spectrum this requires 5 numbers denoting
% [Intensity; isotropic shift (ppm); Cqcc (MHz); eta; Gaussian Linebroadening (ppm); Lorentzian Linebroadening (ppm)]
% Furthermore a background and a slope are required.
%
% qn is the quantum number of the nucleus of interest, e.g. 3/2, 5/2, 7/2, 9/2 or 11/2
%
% omega0 is the larmor frequency for the nucleus of interest in MHz.
%
% qu is an index into the vector pa, which denotes the number of powder averaging points. The scale is nonlinear
% so just try out values to see how many powder-averaging points are calculated. 
%
% RefSpec is a vector with the experimental spectrum, to which RefAxis denotes the corresponding axis in ppm.
%
% Epsilon is the standard deviation of the noise. This results in a proper chi^2 fit.
%
% Constants are the parameters that remain constant during a fit. See fitquadtensor on how to generate this variable!
%
% PlotIntermediate is a flag to indicate whether a plot is made after each calculation
%
% Jacco van Beek
% 2006
%


function [Error, Spec, RefAxis] = simquadtensor(Params, qn, omega0, qu, RefSpec, RefAxis, Epsilon, Constants, PlotIntermediate)

global QmatNMR

%
%This uses the equations from Matthias Ernst's (MAER) script (book draft for lecture, Eq. 9.18 (middle one)
%with A_00(kk) and A_40(kk) taken from Eq. 9.13)
%

%
%define the parameters [Intensity, iso, Cqcc, eta, LB] using either the constant values in Constants
%or the values in Parameters.
%
%NOTE: LB is defined in the unit of the frequency axis!
%
if ~isstruct(Constants)
  error('simquadtensor ERROR: Constants parameter is not of right type. Aborting ...');
end
try
  counter = 0;
  NrLines = length(Constants);
  for tel=1:NrLines
    if isnan(Constants(tel).iso)
      counter = counter + 1;
      iso(tel) = Params(counter);
    else
      iso(tel) = Constants(tel).iso;
    end
    
    if isnan(Constants(tel).Cqcc)
      counter = counter + 1;
      Cqcc(tel) = Params(counter);
    else
      Cqcc(tel) = Constants(tel).Cqcc;
    end
    
    if isnan(Constants(tel).eta)
      counter = counter + 1;
      eta(tel) = Params(counter);
    else
      eta(tel) = Constants(tel).eta;
    end
    if (eta(tel) < 0); eta(tel)=0; end
    if (eta(tel) > 1); eta(tel)=1; end
    
    if isnan(Constants(tel).GaussianLB)
      counter = counter + 1;
      GaussianLB(tel) = Params(counter);
    else
      GaussianLB(tel) = Constants(tel).GaussianLB;
    end
    
    if isnan(Constants(tel).LorentzianLB)
      counter = counter + 1;
      LorentzianLB(tel) = Params(counter);
    else
      LorentzianLB(tel) = Constants(tel).LorentzianLB;
    end

    if isnan(Constants(tel).Intensity)
      counter = counter + 1;
      Intensity(tel) = Params(counter);
    else
      Intensity(tel) = Constants(tel).Intensity;
    end
  end
  %
  %finally the background and slope contributions
  %
  if isnan(Constants(NrLines).Background)
    counter = counter + 1;
    Background = Params(counter);
  else
    Background = Constants(NrLines).Background;
  end
  if isnan(Constants(NrLines).Slope)
    counter = counter + 1;
    Slope = Params(counter);
  else
    Slope = Constants(NrLines).Slope;
  end
  
catch
  error('simquadtensor ERROR: length of parameter vector is inconsistent with defined constants! Aborting ...')
end
if counter ~= length(Params)
  error('simquadtensor ERROR: length of parameter vector is inconsistent with defined constants! Aborting ...')
end


%
%convert the parameters
%
omega0 = omega0 * 1e6;
Cqcc = Cqcc * 1e6;


%
%Analyze the frequency axis and make an output length that is an integer power of 2
%
AxisStart = 2*RefAxis(1) - RefAxis(2);
AxisIncrement = RefAxis(2) - RefAxis(1);
AxisLength = length(RefAxis);
FFTLength = 2^ceil(log2(AxisLength));
%
%for a proper chi^2
%
if (abs(Epsilon) < eps)
  Epsilon = 1;
end


%
%
%
Spec  = zeros(1, FFTLength);
Spec1 = zeros(1, FFTLength);
Spec2 = zeros(1, FFTLength);


%
%define the set of powder averaging points (two-angle ZCW)
%
pa = [3, 21, 144, 233, 399, 610, 987, 1583, 2741, 4409, 6997, 11657, 17389, 28499, 43051, 65063, 79999, 2943631];
pb = [2, 13,  37, 163, 359, 269, 937, 1153, 1117, 1171, 3049,   131,  1787,  5879,  4649,  5237, 74729,  702707];

beta  = pi * ((1:pa(qu))-1) / pa(qu);
alpha = 2*pi * (mod(pb(qu)*((1:pa(qu))-1), pa(qu)) / pa(qu));
weight = sin(beta) / pa(qu);

%
%constants used later
%
  A1 = cos(2*beta);
  A2 = cos(4*beta);
  A3 = cos(2*alpha);
  A4 = sin(beta).^2;
  A5 = cos(4*alpha);
  A6 = sin(beta).^4;


%
%convert Cqcc into delta
%
if (qn==1/2)
  delta = 0;
  Cqcc = 0;
else
  delta = Cqcc ./ (2.0*qn.*(2.0*qn-1.0));
end


%
%define the apodization functions
%
for tel=1:NrLines
  Qlb = abs(LorentzianLB(tel));
  Qgb = abs(GaussianLB(tel));
  QGaussB =  (Qgb/(sqrt(8*log(2))));
  Qmiddle = floor(FFTLength/2) + 1;
  Qemacht(tel, :) = fftshift(exp( -Qlb*(2*pi/(2*abs(AxisIncrement)*(FFTLength-1)))*abs(Qmiddle-(1:FFTLength)) - 2*((QGaussB)*(2*pi/(2*( abs(AxisIncrement)*(FFTLength-1) )))*abs(Qmiddle-(1:FFTLength))).^2 ));
  Qemacht(tel, :) = Qemacht(tel, :) / max(Qemacht(tel, :));
end


%
%Now do the powder integration from the PAS to the ROTOR frame
%
for tel=1:NrLines
  Spec1 = zeros(1, FFTLength);
  Spec2 = zeros(1, FFTLength);

%MAS (eq. 9.18 and 9.13 from MAER book draft)
  Freq = -1/omega0 * (qn*(qn+1)-3/4) * (1/10 * delta(tel)^2 * (eta(tel)^2+3) + 63/161280 * delta(tel)^2 * ( (18 + eta(tel)^2)*(9 + 20*A1 + 35*A2) - 240*eta(tel)*A3.*(A4).*(5+7*A1) + 280*eta(tel)^2*A5.*A6  ));
%static (eq. 9.12 and 9.13 from MAER book draft)
%  Freq = -1/omega0 * (qn*(qn+1)-3/4) * (1/10 * delta(tel)^2 * (eta(tel)^2+3) - 1/7 * delta(tel)^2 * ( (eta(tel)^2-3)*(3*cos(beta).^2-1) - 6*eta(tel)*A4.*A3 ) - 9/8960 * delta(tel)^2 * ( (18 + eta(tel)^2)*(9 + 20*A1 + 35*A2) - 240*eta(tel)*A3.*(A4).*(5+7*A1) + 280*eta(tel)^2*A5.*A6  ));

  Freq = round( ( iso(tel) + Freq * 1e6 / omega0)/abs(AxisIncrement) );
  
  for tel2=1:pa(qu)
    Index = round(Freq(tel2)-AxisStart/abs(AxisIncrement));
    try
      Spec2(Index) = Spec2(Index) + weight(tel2);
    catch
    end
  end
  
  Spec2 = Spec2 * Intensity(tel);
  Spec1 = ifft(fftshift(Spec2), FFTLength);
  Spec1 = Spec1 .* Qemacht(tel, :);
  Spec1 = fftshift(fft(Spec1, FFTLength));

  Spec = Spec + Spec1;
end


%
%Add background and slope
%
Spec = Spec + Background + (Qmiddle-(1:FFTLength))*Slope;


%
%prepare for final output by making the spectrum the right size and by calculationg the error
%
Spec = real(Spec(1:AxisLength));
Error = sum( real(Spec - RefSpec).^2 )/Epsilon^2/(AxisLength-length(Params));


%
%update the plot, if asked for
%
if (PlotIntermediate)
  QuadFitFigure = findobj(0, 'Tag', 'QuadFit');
  QuadFitAxis = findobj(get(QuadFitFigure, 'children'), 'tag', 'QuadFitAxis');
  tmp = get(QuadFitAxis, 'nextplot');
  hold on
  delete(findobj(allchild(QuadFitFigure), 'tag', 'QuadFitHandle'))
  if (gcf ~= QuadFitFigure)
    figure(QuadFitFigure);
  end
  if (RefAxis(1) < RefAxis(2))
    QuadFitHandle = plot(RefAxis, real(Spec), QmatNMR.color(rem(1, length(QmatNMR.color)) + 1));
    set(QuadFitAxis, 'xdir', 'reverse');
  else
    QuadFitHandle = plot(fliplr(RefAxis), fliplr(real(Spec)), QmatNMR.color(rem(1, length(QmatNMR.color)) + 1));
    set(QuadFitAxis, 'xdir', 'normal');
  end
  set(QuadFitAxis, 'nextplot', tmp);
  set(QuadFitHandle, 'tag', 'QuadFitHandle')
  drawnow
end
