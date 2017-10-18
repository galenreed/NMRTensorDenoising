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
% matNMRFT2D
%
% syntax: [MatrixOut1, MatrixOut2] = matNMRFT2D(MatrixIn1, Dimension, FTtype, MultiplyByHalf, MatrixIn2)
%
% Allows performing various types of Fourier transform on the 2D data, but only in the
% direction specified by <Dimension>. If Dimension = 1 then this the FT is done along TD2,
% else along TD1. <FTtype> is a flag which 
% codes for :
% 1 = complex FT
% 2 = real FT
% 3 = STATES FT (requires MatrixIn2!)
% 4 = TPPI FT
% 5 = Whole-echo (= complex FT in TD2)
% 6 = STATES-TPPI (requires MatrixIn2!)
% 7 = Bruker qseq FT (Redfield)
%
% <MultiplyByHalf> is an optional flag which states whether the first point of the FID needs to 
% be multiplied by 0.5. This is required for all FID's which are apodized to zero in order to
% avoid needing to do a baseline correction. By default this is set to 1 if left away.
%
% <MatrixIn2> is an optional parameter that contains the hypercomplex complement to MatrixIn1.
%
% Jacco van Beek
% 25-07-2004
%

function [MatrixOut1, MatrixOut2] = matNMRFT2D(MatrixIn1, Dimension, FTtype, MultiplyByHalf, MatrixIn2)

%
%define empty output variables by default
%
  MatrixOut1 = [];
  MatrixOut2 = [];


%
%Check whether data is truly 2D
%
  if ((ndims(MatrixIn1) == 2) & ~isa(MatrixIn1, 'struct'))
    [SizeTD1, SizeTD2] = size(MatrixIn1);

  else
    beep
    disp('matNMRFT2D ERROR: data is not 2D. Aborting ...');
    return
  end


%
%Multiply first point by 0.5 is requested
%
  if (nargin == 3)
    MultiplyByHalf = 1;
  end


%
%Check whether the hypercomplex part MatrixIn1 is needed, present and of the same size as MatrixIn1
%
  if (nargin == 3)
    HyperComplexPresent = 0;
  end
  if (nargin == 4)
    if (length(MultiplyByHalf) > 1)	%MultiplyByHalf can be left out which would make the MatrixIn2 stand in its position
      HyperComplexPresent = 1;
      MatrixIn2 = MultiplyByHalf;
      MultiplyByHalf = 1;

    else
      HyperComplexPresent = 0;
      MatrixIn2 = [];
    end
  end
  if (nargin == 5)
    HyperComplexPresent = 1;
  end

  switch (FTtype)
    case {1, 2, 4, 5, 7}
      HyperComplexNeeded = 0;
  
    case {3, 6}
      HyperComplexNeeded = 1;

    otherwise
      beep
      disp('matNMRFT2D ERROR: unknown code for FTtype! Aborting ...');
      return
  end
  if (HyperComplexNeeded & ~HyperComplexPresent)
    beep
    disp('matNMRFT2D ERROR: select FT mode requires hypercomplex part! Aborting ...');
    return
  
  elseif (HyperComplexNeeded)
    if ~isequal(size(MatrixIn1), size(MatrixIn2))
      beep
      disp('matNMRFT2D ERROR: hypercomplex part doesn''t have te same size as the main matrix! Aborting ...');
      return
    end
  end


%
%Execute requested FT
%
  if (Dimension == 1) 		%TD2
    switch (FTtype)
      case {1, 5}  	%Complex FT and whole-echo
        if MultiplyByHalf
	  MatrixIn1(1:SizeTD1, 1) = MatrixIn1(1:SizeTD1, 1) * 0.5;
	end
        MatrixOut1 = fftshift(fft(MatrixIn1, [], 2), 2);
    
      case 2      	%Real FT
        if MultiplyByHalf
	  MatrixIn1(1:SizeTD1, 1) = MatrixIn1(1:SizeTD1, 1) * 0.5;
	end
        MatrixOut1 = fftshift(fft(real(MatrixIn1), [], 2), 2);
  
      case {3,6}      	%STATES and STATES-TPPI FT
        if MultiplyByHalf
	  MatrixIn1(1:SizeTD1, 1) = MatrixIn1(1:SizeTD1, 1) * 0.5;
	  MatrixIn2(1:SizeTD1, 1) = MatrixIn2(1:SizeTD1, 1) * 0.5;
	end
        MatrixOut1 = MatrixIn1;
        MatrixOut2 = MatrixIn2;
        for QTEMP40=1:SizeTD1
          MatrixOut1(QTEMP40, :) = fftshift(fft(MatrixIn1(QTEMP40, :)));
          MatrixOut2(QTEMP40, :) = fftshift(fft(MatrixIn2(QTEMP40, :)));
        end
  
      case 4      	%TPPI FT
        if MultiplyByHalf
	  MatrixIn1(1:SizeTD1, 1) = MatrixIn1(1:SizeTD1, 1) * 0.5;
	end
        MatrixOut1 = MatrixIn1;
        for QTEMP40=1:SizeTD1
          QTEMP1 = fftshift(fft(real(MatrixIn1(QTEMP40, :)), 2*SizeTD2));
	  MatrixOut1(QTEMP40, :) = QTEMP1(1:SizeTD2);
        end
  
      case 7      	%Bruker qseq FT
        if MultiplyByHalf
	  MatrixIn1(1:SizeTD1, 1) = MatrixIn1(1:SizeTD1, 1) * 0.5;
	end
        MatrixOut1 = MatrixIn1;
        for QTEMP40=1:SizeTD1
          QTEMP1 = MatrixIn1(QTEMP40, :);
          QTEMP1(2:2:SizeTD2) = -QTEMP1(2:2:SizeTD2);
          QTEMP2 = zeros(1, 2*SizeTD2);
          QTEMP2(1:2:2*SizeTD2) = real(QTEMP1);
          QTEMP2(2:2:2*SizeTD2) = imag(QTEMP1);
          QTEMP1 = fftshift(fft(QTEMP2, 2*SizeTD2));
          MatrixOut1(QTEMP40, :) = QTEMP1(1:SizeTD2);
        end
  
      otherwise
        beep
        disp('matNMRFT2D ERROR: unknown code for FTtype! Aborting ...');
        return
    end	 


  else		%TD1
    switch (FTtype)
      case {1,5}  	%Complex FT and whole-echo
        if MultiplyByHalf
	  MatrixIn1(1, 1:SizeTD2) = MatrixIn1(1, 1:SizeTD2) * 0.5;
	end
        MatrixOut1 = fftshift(fft(MatrixIn1, [], 1), 1);
    
      case 2      	%Real FT
        if MultiplyByHalf
	  MatrixIn1(1, 1:SizeTD2) = MatrixIn1(1, 1:SizeTD2) * 0.5;
	end
        MatrixOut1 = fftshift(fft(real(MatrixIn1), [], 1), 1);
  
      case 3      	%STATES FT
        if MultiplyByHalf
	  MatrixIn1(1, 1:SizeTD2) = MatrixIn1(1, 1:SizeTD2) * 0.5;
	  MatrixIn2(1, 1:SizeTD2) = MatrixIn2(1, 1:SizeTD2) * 0.5;
	end
	MatrixOut1 = real(MatrixIn1) + sqrt(-1)*real(MatrixIn2);
	MatrixOut2 = imag(MatrixIn1) + sqrt(-1)*imag(MatrixIn2);
        for QTEMP40=1:SizeTD2
          QTEMP1 = fftshift(fft(MatrixOut1(:, QTEMP40)));
          QTEMP2 = fftshift(fft(MatrixOut2(:, QTEMP40)));
        
          MatrixOut1(:, QTEMP40) = real(QTEMP1) + sqrt(-1)*real(QTEMP2);
          MatrixOut2(:, QTEMP40) = imag(QTEMP1) + sqrt(-1)*imag(QTEMP2);
        end
  
      case 4      	%TPPI FT
        if MultiplyByHalf
	  MatrixIn1(1, 1:SizeTD2) = MatrixIn1(1, 1:SizeTD2) * 0.5;
	end
	MatrixOut1 = MatrixIn1;
	MatrixOut2 = MatrixIn2;
        for QTEMP40=1:SizeTD2
          QTEMP1 = fft((real(MatrixIn1(:, QTEMP40))), 2*SizeTD1);
          QTEMP2 = fft((imag(MatrixIn1(:, QTEMP40))), 2*SizeTD1);

          MatrixOut1(:, QTEMP40) = real(QTEMP1(1:SizeTD1)) + sqrt(-1)*real(QTEMP2(1:SizeTD1));
          MatrixOut2(:, QTEMP40) = imag(QTEMP1(1:SizeTD1)) + sqrt(-1)*imag(QTEMP2(1:SizeTD1));
        end
  
      case 6      	%STATES-TPPI FT
        if MultiplyByHalf
	  MatrixIn1(1, 1:SizeTD2) = MatrixIn1(1, 1:SizeTD2) * 0.5;
	  MatrixIn2(1, 1:SizeTD2) = MatrixIn2(1, 1:SizeTD2) * 0.5;
	end
        %
        %First we negate every second complex point
        %
        MatrixOut1 = real(MatrixIn1) + sqrt(-1)*real(MatrixIn2);
        MatrixOut1(2:2:SizeTD1, :) = -MatrixOut1(2:2:SizeTD1, :);
  
        MatrixOut2 = imag(MatrixIn1) + sqrt(-1)*imag(MatrixIn2); 						
        MatrixOut2(2:2:SizeTD1, :) = -MatrixOut2(2:2:SizeTD1, :);
      
        for QTEMP40=1:SizeTD2
          QTEMP1 = fftshift(fft(MatrixOut1(:, QTEMP40)));
          QTEMP2 = fftshift(fft(MatrixOut2(:, QTEMP40)));
        
          MatrixOut1(:, QTEMP40) = real(QTEMP1) + sqrt(-1)*real(QTEMP2);
          MatrixOut2(:, QTEMP40) = imag(QTEMP1) + sqrt(-1)*imag(QTEMP2);
        end
  
      case 7      	%Bruker qseq FT
        if MultiplyByHalf
	  MatrixIn1(1, 1:SizeTD2) = MatrixIn1(1, 1:SizeTD2) * 0.5;
	end
	MatrixOut1 = MatrixIn1;
	MatrixOut2 = MatrixIn1;
        for QTEMP40=1:SizeTD2
          QTEMP1 = real(MatrixIn1(:, QTEMP40));
          QTEMP1(3:4:SizeTD1) = -QTEMP1(3:4:SizeTD1);
          QTEMP1(4:4:SizeTD1) = -QTEMP1(4:4:SizeTD1);
          QTEMP1 = fft(QTEMP1, 2*SizeTD1);
  
          QTEMP2 = imag(MatrixIn1(:, QTEMP40));
          QTEMP2(3:4:SizeTD1) = -QTEMP2(3:4:SizeTD1);
          QTEMP2(4:4:SizeTD1) = -QTEMP2(4:4:SizeTD1);
          QTEMP2 = fft(QTEMP2, 2*SizeTD1);
  
          MatrixOut1(:, QTEMP40) = real(QTEMP1(1:SizeTD1)) + sqrt(-1)*real(QTEMP2(1:SizeTD1));
          MatrixOut2(:, QTEMP40) = imag(QTEMP1(1:SizeTD1)) + sqrt(-1)*imag(QTEMP2(1:SizeTD1));
        end
  
      otherwise
        beep
        disp('matNMRFT2D ERROR: unknown code for FTtype! Aborting ...');
        return
    end	 
  end
