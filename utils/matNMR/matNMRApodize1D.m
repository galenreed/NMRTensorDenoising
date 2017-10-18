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
% matNMRApodize1D
%
% syntax: MatrixOut = matNMRApodize1D(MatrixIn, ApodizationType, Extra1, Extra2, Extra3, Extra4)
%
% Allows performing various types of apodization of the 1D data. Depending of the type of
% apodization one or more additional parameters must be given:
%
%
%       MatrixOut = matNMRApodize1D(MatrixIn, 1, Phase)
%
% produces a squared cosine apodization. <Phase> specifies the position of the maximum.
%
%
%       MatrixOut = matNMRApodize1D(MatrixIn, 8, Phase)
%
% produces a Hanning apodization. <Phase> specifies the position of the maximum.
%
%
%       MatrixOut = matNMRApodize1D(MatrixIn, 9, Phase)
%
% produces a Hamming apodization. <Phase> specifies the position of the maximum.
%
%
%       MatrixOut = matNMRApodize1D(MatrixIn, 2, BlockSize, LB, SpectralWidth)
%
% produces a block & Lorentzian apodization. LB is the linebroadening in Hz and SpectralWidth is
% expected to be in kHz.
%
%
%       MatrixOut = matNMRApodize1D(MatrixIn, 3, BlockSize)
%
% produces a block and cosine^2 apodization.
%
%
%       MatrixOut = matNMRApodize1D(MatrixIn, 4, GB, LB, SpectralWidth)
%
% produces a mixed Gaussian/Lorentzian apodization. GB is the Gaussian linebroadening in Hz,
% LB the Lorentzian linebroadening in Hz and SpectralWidth is expected to be in kHz.
%
%
%       MatrixOut = matNMRApodize1D(MatrixIn, 5, LB, SpectralWidth)
%
% produces a Lorentzian apodization. LB the Lorentzian linebroadening in Hz and SpectralWidth 
% is expected to be in kHz.
%
%
%       MatrixOut = matNMRApodize1D(MatrixIn, 6, GB, LB, SpectralWidth)
%
% produces a mixed Gaussian/Lorentzian apodization FOR WHOLE-ECHO ACQUISITION. GB is the Gaussian
% linebroadening in Hz, LB the Lorentzian linebroadening in Hz and SpectralWidth is expected to be in kHz.
%
%
%       MatrixOut = matNMRApodize1D(MatrixIn, 7, LB, SpectralWidth)
%
% produces a Lorentzian apodization FOR WHOLE-ECHO ACQUISITION. LB the Lorentzian linebroadening in 
% Hz and SpectralWidth is expected to be in kHz.
%
%
% Jacco van Beek
% 25-07-2004
%

function MatrixOut = matNMRApodize1D(MatrixIn, ApodizationType, Extra1, Extra2, Extra3, Extra4)

%
%define an empty output variable by default
%
  MatrixOut = [];


%
%Check whether data is truly 1D
%
  if ((ndims(MatrixIn) == 2) & ~isa(MatrixIn, 'struct'))
    [SizeTD1, SizeTD2] = size(MatrixIn);
    if ((SizeTD1 ~= 1) & (SizeTD2 ~= 1))
      beep
      disp('matNMRApodize1D ERROR: data  is not 1D. Aborting ...');
      return;
  
    else
      Size = length(MatrixIn);
    end

  else
    beep
    disp('matNMRApodize1D ERROR: data  is not 1D. Aborting ...');
    return
  end


%
%Apodize according to the different types
%
  switch ApodizationType
    case 1			%cos^2
      if (nargin < 3)
        beep
        disp('matNMRApodize1D ERROR: incorrect number of parameters. Aborting ...');
        return
      end
      MatrixOut = cos(((1:Size) - Extra1*Size)*pi/(2*Size)) .* cos(((1:Size) - Extra1*Size)*pi/(2*Size));

    
    case 2			%block and exponential
      if (nargin < 5)
        beep
        disp('matNMRApodize1D ERROR: incorrect number of parameters. Aborting ...');
        return
      end
      MatrixOut = ones(1, Extra1);
      MatrixOut((Extra1+1:Size)) = exp(-Extra2*(0:(Size-Extra1-1))/Extra3/1000);

      
    case 3			%block and cos^2
      if (nargin < 3)
        beep
        disp('matNMRApodize1D ERROR: incorrect number of parameters. Aborting ...');
        return
      end
      MatrixOut = ones(1, Extra1);
      MatrixOut((Extra1+1:Size)) = cos((1:(Size-Extra1))*pi/(2*(Size-Extra1))) .* cos((1:(Size-Extra1))*pi/(2*(Size-Extra1)));


    case 4			%gaussian
      if (nargin < 5)
        beep
        disp('matNMRApodize1D ERROR: incorrect number of parameters. Aborting ...');
        return
      end
      Extra1 =  (Extra1/(sqrt(8*log(2))));
      MatrixOut = exp( -Extra2*(2*pi/(2*Extra3*1000))*(0:(Size-1)) - 2*((Extra1)*(2*pi/(2*Extra3*1000))*(0:(Size-1))).^2 );
      MatrixOut = MatrixOut / max(MatrixOut);


    case 5			%exponential
      if (nargin < 4)
        beep
        disp('matNMRApodize1D ERROR: incorrect number of parameters. Aborting ...');
        return
      end
      MatrixOut = exp(-Extra1*(0:(Size-1))*2*pi/(2*Extra2*1000));


    case 6			%gaussian for whole echo FID
      if (nargin < 5)
        beep
        disp('matNMRApodize1D ERROR: incorrect number of parameters. Aborting ...');
        return
      end

      Qnulpunt = floor(Size/2)+1;
      Extra1 =  (Extra1/(sqrt(8*log(2))));
      MatrixOut = fftshift(exp( -Extra2*(2*pi/(2*Extra3*1000))*abs(Qnulpunt-(1:Size)) - 2*((Extra1)*(2*pi/(2*Extra3*1000))*abs(Qnulpunt-(1:Size))).^2 ));
      MatrixOut = MatrixOut / max(MatrixOut);


    case 7			%exponential for whole echo FID
      if (nargin < 4)
        beep
        disp('matNMRApodize1D ERROR: incorrect number of parameters. Aborting ...');
        return
      end
      Qnulpunt = floor(Size/2)+1;
      MatrixOut = fftshift(exp(  -Extra1*abs(Qnulpunt-(1:Size))*2*pi/(2*Extra2*1000)  ));

    
    case 8			%Hanning
      if (nargin < 3)
        beep
        disp('matNMRApodize1D ERROR: incorrect number of parameters. Aborting ...');
        return
      end
      MatrixOut = 0.5 + 0.5*cos(((1:Size) - Extra1*Size)*pi/(Size));

    
    case 9			%Hamming
      if (nargin < 3)
        beep
        disp('matNMRApodize1D ERROR: incorrect number of parameters. Aborting ...');
        return
      end
      MatrixOut = 0.54 + 0.46*cos(((1:Size) - Extra1*Size)*pi/(Size));

    
    otherwise
      beep
      error('matNMRApodize1D ERROR: Unknown code for apodization function. Aborting ...');
      return;
  end      


%
%Finalize the apodization
%
  MatrixOut = MatrixOut .* MatrixIn;
