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
% matNMRLP2D
%
% syntax: MatrixOut = matNMRLP2D(MatrixIn, Dimension, LPalgorithm, LPdirection, NumberOfPointsToPredict, NumberOfPointsToUse, NrOfFreqs, SN)
%
% Allows performing various types of linear prediction on the 2D data. The dimension on which to
% operate is defined by <Dimension>. There are two algorithms
% available: lpsvd (1) and itmpm (2) for which explanations can be found in the corresponding routines
% in the matNMR distribution. <LPdirection> can be forward (1) or backward (0). <NumberOfPointsToPredict>
% denotes the number of points to add to the FID. <NumberOfPointsToUse> denotes how many of the FID to
% use to predict the new points from. <NrOfFreqs> denotes the estimated number of frequencies that are
% contained in the FID. The itmpm alorithm allows for two special codes to be used alternatively here: 
% -1 uses the AIC method to determine the number of frequencies, whilst -2 uses the MDL method (see
% the original papers for their respective meanings). Finally SN is used as a rough estimation of the
% signal to noise ratio. Gaussian noise is added to the predicted points.
%
% Jacco van Beek
% 25-07-2004
%

function MatrixOut = matNMRLP2D(MatrixIn, Dimension, LPalgorithm, LPdirection, NumberOfPointsToPredict, NumberOfPointsToUse, NrOfFreqs, SN)

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
    disp('matNMRLP2D ERROR: data is not 2D. Aborting ...');
    return
  end


%
%Check parameters
%
if ((Dimension ~= 1) & (Dimension ~= 2))
  beep
  disp('matNMRLP2D ERROR: Dimension must be 1 or 2. Aborting ...');
  return
end


%
%Analyse spectrum: gives dampening, amplitudess, phase, frequency
%
  if (Dimension == 1) 		%TD2
    %
    %first arrange the spectral matrix to its new size
    %  
    if (LPdirection == 0)		%backward prediction --> put zeros in front of matrix
      MatrixOut = zeros(SizeTD1, NumberOfPointsToPredict+SizeTD2);
      MatrixOut(:, (NumberOfPointsToPredict+1):(NumberOfPointsToPredict+SizeTD2)) = MatrixIn;
 
   else  				%forward prediction --> put zeros at back of matrix
      MatrixOut = zeros(SizeTD1, NumberOfPointsToPredict+SizeTD2);
      MatrixOut(:, 1:SizeTD2) = MatrixIn;
    end


    %
    %Perform the linear prediction on all rows
    %  
			%Perform the linear prediction on all rows
    for tel = 1:SizeTD1
      if (LPalgorithm == 1)	%lpsvd method
        if (NrOfFreqs < 1)
          beep
          disp('matNMRLP2D WARNING: number of frequencies cannot be smaller than 1 for lpsvd! Aborting ...')
          break;
        end
    
        QTEMP = lpsvd(MatrixIn(tel, 1:NumberOfPointsToUse), NrOfFreqs);
    
      elseif (LPalgorithm == 2)	%itmpm method
        QTEMP = itcmp(MatrixIn(tel, 1:NumberOfPointsToUse), NrOfFreqs);
    
      else
        beep
        disp('matNMRLP2D ERROR: incorrect code for LP algorithm. Aborting ...');
        return;
      end
  
  
  			%Now check whether the algorythms have found
  			%a decent solution: if not, an empty vector is returned ...
      if (length(QTEMP) < 1)
        beep
        disp('matNMRLP2D ERROR: algorythm did not find a proper result! Aborting ...')
        return
    
      else  
    					%predict points and add to the spectrum
        if (LPdirection == 0)		%backward prediction
          MatrixOut(tel, 1:NumberOfPointsToPredict) = (cegnt( (-NumberOfPointsToPredict):(-1) , QTEMP, SN, 100*rand(1))).';
        
        else				%forward prediction
          MatrixOut(tel, (SizeTD2+1):(SizeTD2+NumberOfPointsToPredict)) = (cegnt( (SizeTD2):(SizeTD2+NumberOfPointsToPredict-1) , QTEMP, SN, 100*rand(1))).';
        end
      end
    end

  else 				%TD1
			%Perform the linear prediction on all columns
    for tel = 1:SizeTD2
      if (LPalgorithm == 1)	%lpsvd method
        if (NrOfFreqs < 1)
          beep
          disp('matNMRLP2D WARNING: number of frequencies cannot be smaller than 1 for lpsvd! Aborting ...')
          return;
        end
    
        QTEMP = lpsvd(MatrixIn(1:NumberOfPointsToUse, tel), NrOfFreqs);
    
      elseif (LPalgorithm == 2)	%itmpm method
        QTEMP = itcmp(MatrixIn(1:NumberOfPointsToUse, tel), NrOfFreqs);
    
      else
        beep
        disp('matNMRLP2D ERROR: incorrect code for LP algorithm. Aborting ...');
        return;
      end
  
  
  			%Now check whether the algorythms have found
  			%a decent solution: if not, an empty vector is returned ...
      if (length(QTEMP) < 1)
        beep
        disp('matNMRLP2D ERROR: algorythm did not find a proper result! Aborting ...')
        return
    
      else  
    					%predict points and add to the spectrum
        if (LPdirection == 0)		%backward prediction
          MatrixOut(1:NumberOfPointsToPredict, tel) = (cegnt( (-NumberOfPointsToPredict):(-1) , QTEMP, SN, 100*rand(1)));
        
        else				%forward prediction
          MatrixOut((SizeTD1+1):(SizeTD1+NumberOfPointsToPredict), tel) = (cegnt( (SizeTD1):(SizeTD1+NumberOfPointsToPredict-1) , QTEMP, SN, 100*rand(1)));
        end
      end
    end
  end
