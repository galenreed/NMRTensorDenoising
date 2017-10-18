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
% simcsatensor simulates a set of static CSA lineshapes.
%
% syntax:
%    [Error, Spec] = simcsatensor(Params, RefSpec, RefAxis, Epsilon, Constants, PlotIntermediate)
%
% Error is the chi^2 error (if noise was correct)
% Spec is the simulated spectrum
%
% Params are the parameters in the fit. For each line in the spectrum this requires 5 numbers denoting
% [Intensity; sigma 11 (ppm); sigma 22 (ppm); sigma 33 (ppm); Gaussian Linebroadening (ppm); Lorentzian Linebroadening (ppm)]
% Furthermore a background and a slope are required. If the ForceSymmetric flag is set in the Constants variable then
% sigma 11 is in fact the sigma parallel whilst sigma 22 is not required and sigma 33 is the sigma_perpendicular
% (parallel and perpendicular towards the unique axis of the symmetric tensor)
%
% RefSpec is a vector with the experimental spectrum, to which RefAxis denotes the corresponding axis in ppm.
%
% Epsilon is the standard deviation of the noise. This results in a proper chi^2 fit.
%
% Constants are the parameters that remain constant during a fit. See fitcsatensor on how to generate this variable!
%
% PlotIntermediate is a flag to indicate whether a plot is made after each calculation
%
% Jacco van Beek
% 2006
%


function [Error, Spec] = simcsatensor(Params, RefSpec, RefAxis, Epsilon, Constants, PlotIntermediate)

global QmatNMR

%
%This uses the analytical lineshape for by Bloembergen (1949) for non-symmetric tensors.
%

%
%make sure that the reference spectrum and axis are row vectors
%
RefSpec = RefSpec(:).';
RefAxis = RefAxis(:).';

%
%define the parameters [sigma11, sigma22, sigma33, GaussLB, LorentzLB, Intensity] using either the constant values in Constants
%or the values in Parameters.
%
%NOTE: LB is defined in the unit of the frequency axis!
%
if ~isstruct(Constants)
  error('simcsatensor ERROR: Constants parameter is not of right type. Aborting ...');
end
try
  counter = 0;
  NrLines = length(Constants);
  for tel=1:NrLines
    if isnan(Constants(tel).sigma11)
      counter = counter + 1;
      sigma11(tel) = Params(counter);
    else
      sigma11(tel) = Constants(tel).sigma11;
    end
    
    if (Constants(tel).ForceSymmetric == 0)
      if isnan(Constants(tel).sigma22)
        counter = counter + 1;
        sigma22(tel) = Params(counter);
      else
        sigma22(tel) = Constants(tel).sigma22;
      end

      if isnan(Constants(tel).sigma33)
        counter = counter + 1;
        sigma33(tel) = Params(counter);
      else
        sigma33(tel) = Constants(tel).sigma33;
      end
    else
      if isnan(Constants(tel).sigma33)
        counter = counter + 1;
        sigma33(tel) = Params(counter);
      else
        sigma33(tel) = Constants(tel).sigma33;
      end

      sigma22(tel) = sigma33(tel);
    end
    
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
  error('simcsatensor ERROR: length of parameter vector is inconsistent with defined constants! Aborting ...')
end
if counter ~= length(Params)
  error('simcsatensor ERROR: length of parameter vector is inconsistent with defined constants! Aborting ...')
end


%
%Analyze the frequency axis and make an output length that is an integer power of 2
%
AxisStart = 2*RefAxis(1) - RefAxis(2);
AxisIncrement = RefAxis(2) - RefAxis(1);
AxisLength = length(RefAxis);
FFTLength = AxisLength;
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
%Now calculate the separate CSA tensor lineshapes
%
for tel=1:NrLines
  if Constants(tel).ForceSymmetric
    Spec2 = internalSimulateAxiallySymmetric(sigma11(tel), sigma33(tel), RefAxis);
  else
    Spec2 = internalSimulateNonSymmetric(sigma11(tel), sigma22(tel), sigma33(tel), RefAxis);
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
  CSAFitFigure = findobj(0, 'Tag', 'CSAFit');
  CSAFitAxis = findobj(get(CSAFitFigure, 'children'), 'tag', 'CSAFitAxis');
  tmp = get(CSAFitAxis, 'nextplot');
  hold on
  delete(findobj(allchild(CSAFitFigure), 'tag', 'CSAFitHandle'))
  if (gcf ~= CSAFitFigure)
    figure(CSAFitFigure);
  end
  if (RefAxis(1) < RefAxis(2))
    CSAFitHandle = plot(RefAxis, real(Spec), QmatNMR.color(rem(1, length(QmatNMR.color)) + 1));
    set(CSAFitAxis, 'xdir', 'reverse');
  else
    CSAFitHandle = plot(fliplr(RefAxis), fliplr(real(Spec)), QmatNMR.color(rem(1, length(QmatNMR.color)) + 1));
    set(CSAFitAxis, 'xdir', 'normal');
  end
  set(CSAFitAxis, 'nextplot', tmp);
  set(CSAFitHandle, 'tag', 'CSAFitHandle')
  drawnow
end

















%AxiallySymmetric(SigmaParallel, SigmaPerpendicular, FreqVec)
%
%This function calculates an axially symmetric NMR powder pattern as a function of 
%SigmaParallel, SigmaPerpendicular, and the frequency vector FreqVec. 
%All values must be entered in ppm.
%The routine is designed such that it will always produce the correct output, even for 
%example when the principal values are not in the range of FreqVec.
%
%Jacco van Beek
%16-11-2000
%rewritten 22-01-'07

function ret = internalSimulateAxiallySymmetric(SigmaParallel, SigmaPerpendicular, FreqVec)


  if (SigmaParallel > SigmaPerpendicular)
    %
    %This part is for w < SigmaPerpendicular
    %
    FreqVec1 = FreqVec(find(FreqVec < SigmaPerpendicular));
    PlaceVec1 = zeros(1, length(FreqVec1));


    %
    %This part is for w == SigmaPerpendicular
    %
    FreqVec2 = FreqVec(find(FreqVec == SigmaPerpendicular));
    PlaceVec2 = 1./(2*sqrt((SigmaParallel-SigmaPerpendicular)*(FreqVec2+0.001-SigmaPerpendicular)));

    %
    %This part is for SigmaParallel > w > SigmaPerpendicular
    %
    FreqVec3 = FreqVec(find((FreqVec < SigmaParallel) & (FreqVec > SigmaPerpendicular)));
    PlaceVec3 = 1./(2*sqrt((SigmaParallel-SigmaPerpendicular)*(FreqVec3-SigmaPerpendicular)));


    %
    %This part is for w >= SigmaParallel
    %
    FreqVec4 = FreqVec(find(FreqVec >= SigmaParallel));
    PlaceVec4 = zeros(1, length(FreqVec4));
  else
    %
    %This part is for w <= SigmaParallel
    %
    FreqVec1 = FreqVec(find(FreqVec <= SigmaParallel));
    PlaceVec1 = zeros(1, length(FreqVec1));


    %
    %This part is for SigmaPerpendicular > w > SigmaParallel
    %
    FreqVec2 = FreqVec(find((FreqVec > SigmaParallel) & (FreqVec < SigmaPerpendicular)));
    PlaceVec2 = 1./(2*sqrt((SigmaPerpendicular-SigmaParallel)*(FreqVec2-SigmaPerpendicular)));


    %
    %This part is for w == SigmaPerpendicular
    %
    FreqVec3 = FreqVec(find(FreqVec == SigmaPerpendicular));
    PlaceVec3 = 1./(2*sqrt((SigmaPerpendicular-SigmaParallel)*(FreqVec3-0.001-SigmaPerpendicular)));
    
    %
    %This part is for w > SigmaPerpendicular
    %
    FreqVec4 = FreqVec(find(FreqVec > SigmaPerpendicular));
    PlaceVec4 = zeros(1, length(FreqVec4));
  end

  %
  %Combine separate parts and integrate powder pattern always to the same
  %integral per frequency resolution
  %
  ret = [PlaceVec1 PlaceVec2 PlaceVec3 PlaceVec4];
  ret = ret / sum(ret) / abs(FreqVec(2)-FreqVec(1));












%internalSimulateNonSymmetric(s11, s22, s33, FreqVec)
%
%This function calculates a general NMR powder pattern as a function of s11, s22, s33 and 
%the frequency vector FreqVec. All values must be entered in ppm.
%The routine is designed such that it will always produce the correct output, even for 
%example when the principal values are not in the range of FreqVec.
%
%Jacco van Beek
%08-02-'99
%rewritten 22-01-'07

function ret = internalSimulateNonSymmetric(s11, s22, s33, FreqVec);


%
%First sort the principal values according to s33 > s22 > s11
%
  SortVec = sort([s11 s22 s33]);
  s11 = SortVec(1);
  s22 = SortVec(2);
  s33 = SortVec(3);


%
%Then determine the 4 areas that need to be distinguished to calculate the powder pattern
%

  %
  %This part is for w < s11
  %
  FreqVec1 = FreqVec(find(FreqVec < s11));
  PlaceVec1 = zeros(1, length(FreqVec1));


  %
  %This part is for s22 > w >= s11
  %
  FreqVec2 = FreqVec(find((FreqVec < s22) & (FreqVec >= s11)));
  PlaceVec2 = ellipke( ((FreqVec2-s11).*(s33-s22)) ./ ((s33-FreqVec2).*(s22-s11))  ) ./ ( sqrt(s33-FreqVec2) .* sqrt(s22-s11) .* pi );


  %
  %This part is for s22 == FreqVec (just in case the assymptote lies on a
  %grid point
  %
  FreqVec3 = FreqVec(find(FreqVec == s22));
  if ((s33 ~= s22) & (s22 ~= s11))
    PlaceVec3 = (ellipke( ((FreqVec3-0.001-s11).*(s33-s22)) ./ ((s33-FreqVec3+0.001).*(s22-s11))  ) ./ ( sqrt(s33-FreqVec3+0.001) .* sqrt(s22-s11) .* pi ) + ...
                 ellipke( ((s22-s11).*(s33-FreqVec3-0.001)) ./ ((s33-s22).*(FreqVec3+0.001-s11))  ) ./ ( sqrt(FreqVec3+0.001-s11) .* sqrt(s33-s22) .* pi ))/2;
  elseif (s33 ~= s22)
    PlaceVec3 = ellipke( ((s22-s11).*(s33-FreqVec3-0.001)) ./ ((s33-s22).*(FreqVec3+0.001-s11))  ) ./ ( sqrt(FreqVec3+0.001-s11) .* sqrt(s33-s22) .* pi );
  elseif (s22 ~= s11)
    PlaceVec3 = ellipke( ((FreqVec3-0.001-s11).*(s33-s22)) ./ ((s33-FreqVec3+0.001).*(s22-s11))  ) ./ ( sqrt(s33-FreqVec3+0.001) .* sqrt(s22-s11) .* pi );
  else
    PlaceVec3 = 1;
  end


  %
  %This part is for s33 >= w > s22
  %
  FreqVec4 = FreqVec(find((FreqVec <= s33) & (FreqVec > s22)));
  PlaceVec4 = ellipke( ((s22-s11).*(s33-FreqVec4)) ./ ((s33-s22).*(FreqVec4-s11))  ) ./ ( sqrt(FreqVec4-s11) .* sqrt(s33-s22) .* pi );


  %
  %This part is for w > s33
  %
  FreqVec5 = FreqVec(find(FreqVec > s33));
  PlaceVec5 = zeros(1, length(FreqVec5));


%
%Combine separate parts and integrate powder pattern always to the same
%integral per frequency resolution
%
  ret = [PlaceVec1 PlaceVec2 PlaceVec3 PlaceVec4 PlaceVec5];
  ret = ret / sum(ret) / abs(FreqVec(2)-FreqVec(1));
