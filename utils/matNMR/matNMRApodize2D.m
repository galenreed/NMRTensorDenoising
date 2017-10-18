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
% matNMRApodize2D
%
% syntax: MatrixOut = matNMRApodize2D(MatrixIn, Dimension, ApodizationType, Extra1, Extra2, Extra3, Extra4)
%
% Allows performing various types of apodization of the 2D data. 
% <Dimension> must be either 1 (TD2) or 2 (TD1).
% Depending of the type of apodization one or more additional parameters must be given:
%
%       MatrixOut = matNMRApodize2D(MatrixIn, Dimension, 1, Phase)
%
% produces a squared cosine apodization. <Phase> specifies the position of the maximum.
%
%
%       MatrixOut = matNMRApodize1D(MatrixIn, Dimension, 10, Phase)
%
% produces a Hanning apodization. <Phase> specifies the position of the maximum.
%
%
%       MatrixOut = matNMRApodize1D(MatrixIn, Dimension, 11, Phase)
%
% produces a Hamming apodization. <Phase> specifies the position of the maximum.
%
%
%       MatrixOut = matNMRApodize2D(MatrixIn, Dimension, 2, BlockSize, LB, SpectralWidth)
%
% produces a block & Lorentzian apodization. LB is the linebroadening in Hz and SpectralWidth is
% expected to be in kHz.
%
%
%       MatrixOut = matNMRApodize2D(MatrixIn, Dimension, 3, BlockSize)
%
% produces a block and cosine^2 apodization.
%
%
%       MatrixOut = matNMRApodize2D(MatrixIn, Dimension, 4, GB, LB, SpectralWidth)
%
% produces a mixed Gaussian/Lorentzian apodization. GB is the Gaussian linebroadening in Hz,
% LB the Lorentzian linebroadening in Hz and SpectralWidth is expected to be in kHz.
%
%
%       MatrixOut = matNMRApodize2D(MatrixIn, Dimension, 5, LB, SpectralWidth)
%
% produces a Lorentzian apodization. LB the Lorentzian linebroadening in Hz and SpectralWidth 
% is expected to be in kHz.
%
%
%       MatrixOut = matNMRApodize2D(MatrixIn, Dimension, 6, GB, LB, SpectralWidth)
%
% produces a mixed Gaussian/Lorentzian apodization FOR WHOLE-ECHO ACQUISITION. GB is the Gaussian
% linebroadening in Hz, LB the Lorentzian linebroadening in Hz and SpectralWidth is expected to be in kHz.
%
%
%       MatrixOut = matNMRApodize2D(MatrixIn, Dimension, 7, LB, SpectralWidth)
%
% produces a Lorentzian apodization FOR WHOLE-ECHO ACQUISITION. LB the Lorentzian linebroadening in 
% Hz and SpectralWidth is expected to be in kHz.
%
%
%       MatrixOut = matNMRApodize2D(MatrixIn, Dimension, 8, GB, SpectralWidthTD2, SpectralWidthTD1, ShearingFactor, EchoMax, ShiftDirection)
%
% produces a mixed Gaussian apodization that shifts with the position of the echo maximum, as
% defined by the SpectralWidths and the shearing factor. GB is the Gaussian linebroadening in Hz,
% SpectralWidthTD2 and SpectralWidthTD1 are expected to be in kHz. EchoMax is the position of the echo
% maximum in the first slice. ShiftDirection determines whether the echo moves forward or backward
% in time (+1 for forward, -1 for backward).
% NOTE: for TPPI-modulated experiments the SpectralWidthTD1 MUST be entered as 1/dwellTD1 and not 
% as 1/(2*dwellTD1)!
%
%
%       MatrixOut = matNMRApodize2D(MatrixIn, Dimension, 9, GB, SpectralWidthTD2, SpectralWidthTD1, ShearingFactor, EchoMax)
%
% produces a mixed Gaussian apodization that shifts with the position of the echo maximum, as
% defined by the SpectralWidths and the shearing factor. GB is the Gaussian linebroadening in Hz,
% SpectralWidthTD2 and SpectralWidthTD1 are expected to be in kHz. EchoMax is the position of the echo
% maximum in the first slice. If EchoMax = 0 then this mean a swap-whole-echo has been performed
% and the echo and anti-echo components are convergent in TD1.
% NOTE: for TPPI-modulated experiments the SpectralWidthTD1 MUST be entered as 1/dwellTD1 and not 
% as 1/(2*dwellTD1)!
%
%
% Jacco van Beek
% 25-07-2004
%

function MatrixOut = matNMRApodize2D(MatrixIn, Dimension, ApodizationType, Extra1, Extra2, Extra3, Extra4, Extra5, Extra6)

%
%define an empty output variable by default
%
  MatrixOut = [];


%
%Check whether data is truly 2D
%
  if ((ndims(MatrixIn) == 2) & ~isa(MatrixIn, 'struct'))
    [SizeTD1, SizeTD2] = size(MatrixIn);

  else
    beep
    disp('matNMRApodize2D ERROR: data is not 2D. Aborting ...');
    return
  end


%
%Check parameters
%
if ((Dimension ~= 1) & (Dimension ~= 2))
  beep
  disp('matNMRApodize2D ERROR: Dimension must be 1 or 2. Aborting ...');
  return
end


%
%Apodize according to the different types
%
  if (Dimension == 1)
    Size = SizeTD2;
  else
    Size = SizeTD1;
  end

  switch ApodizationType
    case 1			%cos^2
      if (nargin < 4)
        beep
        disp('matNMRApodize2D ERROR: incorrect number of parameters. Aborting ...');
        return
      end
      Apodizer = cos(((1:Size) - Extra1*Size)*pi/(2*Size)) .* cos(((1:Size) - Extra1*Size)*pi/(2*Size));

    
    case 2			%block and exponential
      if (nargin < 6)
        beep
        disp('matNMRApodize2D ERROR: incorrect number of parameters. Aborting ...');
        return
      end
      Apodizer = ones(1, Extra1);
      Apodizer((Extra1+1:Size)) = exp(-Extra2*(0:(Size-Extra1-1))/Extra3/1000);

      
    case 3			%block and cos^2
      if (nargin < 4)
        beep
        disp('matNMRApodize2D ERROR: incorrect number of parameters. Aborting ...');
        return
      end
      Apodizer = ones(1, Extra1);
      Apodizer((Extra1+1:Size)) = cos((1:(Size-Extra1))*pi/(2*(Size-Extra1))) .* cos((1:(Size-Extra1))*pi/(2*(Size-Extra1)));


    case 4			%gaussian
      if (nargin < 6)
        beep
        disp('matNMRApodize2D ERROR: incorrect number of parameters. Aborting ...');
        return
      end
      Extra1 =  (Extra1/(sqrt(8*log(2))));
      Apodizer = exp( -Extra2*(2*pi/(2*Extra3*1000))*(0:(Size-1)) - 2*((Extra1)*(2*pi/(2*Extra3*1000))*(0:(Size-1))).^2 );
      Apodizer = Apodizer / max(Apodizer);


    case 5			%exponential
      if (nargin < 5)
        beep
        disp('matNMRApodize2D ERROR: incorrect number of parameters. Aborting ...');
        return
      end
      Apodizer = exp(-Extra1*(0:(Size-1))*2*pi/(2*Extra2*1000));


    case 6			%gaussian for whole echo FID
      if (nargin < 6)
        beep
        disp('matNMRApodize2D ERROR: incorrect number of parameters. Aborting ...');
        return
      end

      QmatNMR.nulpunt = floor(Size/2)+1;
      Extra1 =  (Extra1/(sqrt(8*log(2))));
      Apodizer = fftshift(exp( -Extra2*(2*pi/(2*Extra3*1000))*abs(QmatNMR.nulpunt-(1:Size)) - 2*((Extra1)*(2*pi/(2*Extra3*1000))*abs(QmatNMR.nulpunt-(1:Size))).^2 ));
      Apodizer = Apodizer / max(Apodizer);


    case 7			%exponential for whole echo FID
      if (nargin < 5)
        beep
        disp('matNMRApodize2D ERROR: incorrect number of parameters. Aborting ...');
        return
      end
      QmatNMR.nulpunt = floor(Size/2)+1;
      Apodizer = fftshift(exp(  -Extra1*abs(QmatNMR.nulpunt-(1:Size))*2*pi/(2*Extra2*1000)  ));


    case 8			%shifting gaussian
      if (nargin < 9)
        beep
        disp('matNMRApodize2D ERROR: incorrect number of parameters. Aborting ...');
        return
      end
      if ((Extra6 ~= 1) & (Extra6 ~= -1))
        beep
        disp('matNMRApodize2D ERROR: Dimension must be -1 or 1. Aborting ...');
        return
      end

      Extra1 =  (Extra1/(sqrt(8*log(2))));
      DwellRatio = Extra2*1000*Extra4/(Extra3*1000);
      
      Apodizer = zeros(SizeTD1, SizeTD2);
      for tel=1:SizeTD1
	Apodizer1D = exp(- 2*((Extra1)*(2*pi/(2*Extra2*1000))*((1:SizeTD2) - Extra5 -Extra6*((tel-1)*DwellRatio))).^2 );
	Apodizer(tel, :) = Apodizer1D / max(Apodizer1D);
      end


    case 9			%shifting gaussian for whole-echo experiments
      if (nargin < 8)
        beep
        disp('matNMRApodize2D ERROR: incorrect number of parameters. Aborting ...');
        return
      end

      Extra1 =  (Extra1/(sqrt(8*log(2))));
      DwellRatio = Extra2*1000*Extra4/(Extra3*1000);
      
      Apodizer = zeros(SizeTD1, SizeTD2);
      if (Extra5 == 0) 			%a swap whole echo has been performed before the apodization step.
      						%then the shifting gaussian is basically convergent (in T1)
        for tel=1:SizeTD1
          Apodizer1D = [exp(- 2*((Extra1)*(2*pi/(2*Extra2*1000))*((0:(floor(SizeTD2/2)-1)) - ((tel-1)*DwellRatio))).^2 )    exp(- 2*((Extra1)*(2*pi/(2*Extra2*1000))*(SizeTD2 - ((floor(SizeTD2/2)+1):SizeTD2) - ((tel-1)*DwellRatio))).^2 )];
          Apodizer(tel, :) = Apodizer1D / max(Apodizer1D);
        end

      else					%no "swap whole echo" has been done. Then the shifting gaussians are basically
      						%divergent in T1
        for tel=1:SizeTD1
          Apodizer1D = [exp(- 2*((Extra1)*(2*pi/(2*Extra2*1000))*((1:(Extra5-1)) - Extra5 + ((tel-1)*DwellRatio))).^2 )    exp(- 2*((Extra1)*(2*pi/(2*Extra2*1000))*(Extra5 - (0:SizeTD2-Extra5) - Extra5 + ((tel-1)*DwellRatio))).^2 )];
          Apodizer(tel, :) = Apodizer1D / max(Apodizer1D);
        end
      end	

    
    case 10			%Hanning
      if (nargin < 4)
        beep
        disp('matNMRApodize2D ERROR: incorrect number of parameters. Aborting ...');
        return
      end
      Apodizer = 0.5 + 0.5*cos(((1:Size) - Extra1*Size)*pi/(Size));

    
    case 11			%Hamming
      if (nargin < 4)
        beep
        disp('matNMRApodize2D ERROR: incorrect number of parameters. Aborting ...');
        return
      end
      Apodizer = 0.54 + 0.46*cos(((1:Size) - Extra1*Size)*pi/(Size));

    
    otherwise
        beep
      error('matNMRApodize2D ERROR: Unknown code for apodization function. Aborting ...');
      return;
  end      


%
%Finalize the apodization
%
  if (Dimension == 1) 		%TD2
    if (ApodizationType < 8)
      for tel=1:SizeTD1
        MatrixOut(tel, :) = Apodizer .* MatrixIn(tel, :);
      end
      
    else
      MatrixOut = Apodizer .* MatrixIn;
    end

  else 				%TD1
    if (ApodizationType < 8)
      Apodizer = Apodizer .';
      for tel=1:SizeTD2
        MatrixOut(:, tel) = Apodizer .* MatrixIn(:, tel);
      end
      
    else
      MatrixOut = Apodizer .* MatrixIn;
    end
  end
