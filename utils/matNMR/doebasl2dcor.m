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
%doebasl2dcor.m performs a baseline correction on the current 2D spectrum ...
%20-1-'98

try
  if (QmatNMR.FitPerformed == 0)
    QmatNMR.Basl2DFunction = get(QmatNMR.Q2dbas3, 'value');
    QmatNMR.Basl2DOrder = eval(get(QmatNMR.Q2dbas5, 'String'));
    if (QmatNMR.Basl2DOrder < 0)		%negate any negative orders
      QmatNMR.Basl2DOrder = -QmatNMR.Basl2DOrder;
      set(QmatNMR.Q2dbas5, 'String', QmatNMR.Basl2DOrder);
    end
  
    if isempty(QmatNMR.baslcornoise)
      QmatNMR.baslcornoise = 1:QmatNMR.Size1D;
    end
    QmatNMR.baslcornoise = QmatNMR.baslcornoise(:);
    QmatNMR.baslcornoise = QmatNMR.baslcornoise(:);
  
    QTEMP = zeros(length(QmatNMR.baslcornoise), QmatNMR.Basl2DOrder+1);
    
    				%
    				%determine the starting and ending row/column
    				%this allows for partial baseline correction of the 2D matrix.
    				%
    if (~isempty(get(QmatNMR.Q2dbas11, 'String')))		%starting row/column
      QTEMP8 = get(QmatNMR.Q2dbas11, 'String');
      QmatNMR.BaselineRange = QTEMP8(length(QTEMP8));
      if ((QmatNMR.BaselineRange =='k') | (QmatNMR.BaselineRange == 'K'))
        QmatNMR.SelectedArea(1) = round(eval(QTEMP8(1:(length(QTEMP8)-1))*1024));
      else
        QmatNMR.SelectedArea(1) = round(eval(QTEMP8));
      end  
    else
      QmatNMR.SelectedArea(1) = 1;
    end    
    if (~isempty(get(QmatNMR.Q2dbas9, 'String')))		%ending row/column
      QTEMP8 = get(QmatNMR.Q2dbas9, 'String');
      QmatNMR.BaselineRange = QTEMP8(length(QTEMP8));
      if ((QmatNMR.BaselineRange =='k') | (QmatNMR.BaselineRange == 'K'))
        QmatNMR.SelectedArea(2) = round(eval(QTEMP8(1:(length(QTEMP8)-1))*1024));
      else
        QmatNMR.SelectedArea(2) = round(eval(QTEMP8));
      end  
    else
      if (QmatNMR.Dim < 2)				%covers TD2 and 1D projection modes
        QmatNMR.SelectedArea(2) = QmatNMR.SizeTD1;
      else					%TD1
  
        QmatNMR.SelectedArea(2) = QmatNMR.SizeTD2;
      end  
    end
  
    %
    %check whether the given area is valid
    %
    QmatNMR.SelectedArea = sort(QmatNMR.SelectedArea);
    if (QmatNMR.SelectedArea(1) < 1)
      QmatNMR.SelectedArea(1) = 1;
    end
    if (QmatNMR.Dim < 2)				%covers TD2 and 1D projection modes
      QmatNMR.BaselineRange = QmatNMR.SizeTD1;
    else						%TD1
  
      QmatNMR.BaselineRange = QmatNMR.SizeTD2;
    end  
    if (QmatNMR.SelectedArea(2) > QmatNMR.BaselineRange)
      QmatNMR.SelectedArea(2) = QmatNMR.BaselineRange;
    end
  
    %
    %check whether the selected area is the entire range. If so, then it macro will work different-sized spectra as well.
    %If a specific area was given then the area is written as is into the history macro.
    %
    if ( (QmatNMR.SelectedArea(1) == 1) & (((QmatNMR.Dim == 1) & (QmatNMR.SelectedArea(2) == QmatNMR.SizeTD1)) | ((QmatNMR.Dim == 2) & (QmatNMR.SelectedArea(2) == QmatNMR.SizeTD2))) )
      QmatNMR.SelectedAreaHistoryCode = [-99 -99];
    else
      QmatNMR.SelectedAreaHistoryCode = QmatNMR.SelectedArea;
    end
  
      				%make the regression matrix
    if (QmatNMR.Basl2DFunction == 1)		%Polynomial function(A+Bx+Cx^2+Dx^3...)
      QTEMP(:, 1) = ones(length(QmatNMR.baslcornoise),1);
      for QTEMP40=1:QmatNMR.Basl2DOrder
        QTEMP(:, QTEMP40+1) = QmatNMR.baslcornoise.^QTEMP40;
      end
    
    
    elseif (QmatNMR.Basl2DFunction == 2)	%Bernstein polynomials
      for QTEMP40=0:QmatNMR.Basl2DOrder
        QTEMP(:, QTEMP40+1) = (QmatNMR.baslcornoise.^QTEMP40).*(1-QmatNMR.baslcornoise).^(QmatNMR.Basl2DOrder-QTEMP40);
      end
    
    
    elseif (QmatNMR.Basl2DFunction == 3)	%Cosine series
      QTEMP(:, 1) = ones(length(QmatNMR.baslcornoise),1);
      for QTEMP40=1:QmatNMR.Basl2DOrder
        QTEMP(:, QTEMP40+1) = cos(QTEMP40*pi*(QmatNMR.baslcornoise-1)/QmatNMR.Size1D + QmatNMR.fase0*pi/180);
      end
    end
    
    
      if (QmatNMR.Dim == 0)		%Check whether the current view in the matNMR window isn't a 1D !
        QmatNMR.Dim = 1;
        disp('WARNING: current mode is a 1D, assuming baseline correction on TD2 of spectrum !!');
      end;  
    
    
    				%Do the actual linear regression fit
      if (QmatNMR.Dim == 1)
  %
  %previously I used a very simple linear regression but numerically this was not so stable
  %
  %      QmatNMR.basl2dpars = QTEMP \ real(QmatNMR.Spec2D(QmatNMR.SelectedArea(1):QmatNMR.SelectedArea(2), QmatNMR.baslcornoise)).';
  %
        [QTEMP1, QTEMP2] = qr(QTEMP, 0); 	%see polyfit.m
        QmatNMR.basl2dpars = QTEMP2 \ (QTEMP1.' * real(QmatNMR.Spec2D(QmatNMR.SelectedArea(1):QmatNMR.SelectedArea(2), QmatNMR.baslcornoise)).');    % Same as p = V\y;
  
        QmatNMR.BaselineRange = 'rows';
  
      else
  %
  %previously I used a very simple linear regression but numerically this was not so stable
  %
  %      QmatNMR.basl2dpars = QTEMP\real(QmatNMR.Spec2D(QmatNMR.baslcornoise, QmatNMR.SelectedArea(1):QmatNMR.SelectedArea(2)));
  %
        [QTEMP1, QTEMP2] = qr(QTEMP, 0); 	%see polyfit.m
        QmatNMR.basl2dpars = QTEMP2 \ (QTEMP1.' * real(QmatNMR.Spec2D(QmatNMR.baslcornoise, QmatNMR.SelectedArea(1):QmatNMR.SelectedArea(2))));    % Same as p = V\y;
        QmatNMR.BaselineRange = 'columns';
      end    
    
    				%Create a 2D matrix to multiply with the parameters
    if (QmatNMR.Basl2DFunction == 1)		%Polynomial function(A+Bx+Cx^2+Dx^3...)
      QTEMP2 = zeros(QmatNMR.Basl2DOrder+1, QmatNMR.Size1D);
      QTEMP2(1, :) = ones(1, QmatNMR.Size1D);
      for QTEMP40=1:QmatNMR.Basl2DOrder
        QTEMP2(QTEMP40+1, :) = (1:QmatNMR.Size1D).^QTEMP40;
      end
    
    
    elseif (QmatNMR.Basl2DFunction == 2)	%Bernstein polynomials
      QTEMP2 = zeros(QmatNMR.Basl2DOrder+1, QmatNMR.Size1D);
      QTEMP2(1, :) = (1 - (1:QmatNMR.Size1D)).^QmatNMR.Basl2DOrder;
      for QTEMP40=1:QmatNMR.Basl2DOrder
        QTEMP2(QTEMP40+1, :) = ((1:QmatNMR.Size1D).^QTEMP40).*((1 - (1:QmatNMR.Size1D)).^(QmatNMR.Basl2DOrder-QTEMP40));
      end
    
    
    elseif (QmatNMR.Basl2DFunction == 3)	%Cosine series
      QTEMP2 = zeros(QmatNMR.Basl2DOrder+1, QmatNMR.Size1D);
      QTEMP2(1, :) = ones(1, QmatNMR.Size1D);
      for QTEMP40=1:QmatNMR.Basl2DOrder
        QTEMP2(QTEMP40+1, :) = cos(QTEMP40*pi*((1:QmatNMR.Size1D)-1)/QmatNMR.Size1D + QmatNMR.fase0*pi/180);
      end
    end
      
    				%Now calculate the resulting baseline corrected spectrum
    if (QmatNMR.Dim == 1)
      QmatNMR.Spec2D(QmatNMR.SelectedArea(1):QmatNMR.SelectedArea(2), :) = (QmatNMR.Spec2D(QmatNMR.SelectedArea(1):QmatNMR.SelectedArea(2), :) - (QmatNMR.basl2dpars'*QTEMP2));
    else
      QmatNMR.Spec2D(:, QmatNMR.SelectedArea(1):QmatNMR.SelectedArea(2)) = (QmatNMR.Spec2D(:, QmatNMR.SelectedArea(1):QmatNMR.SelectedArea(2)) - (QmatNMR.basl2dpars'*QTEMP2)');
    end    
    			      %and display it ...
    getcurrentspectrum	      %get spectrum to show on the screen
    figure(QmatNMR.Fig);
    Qspcrel;
    CheckAxis
    simpelplot;
    
    figure(QmatNMR.Basl2Dfig);
    
    QmatNMR.FitPerformed = 1;		%status variable whether a fit has been performed already or not....
    disp(['finished calculating baseline correction on ' QmatNMR.BaselineRange ' of 2D matrix ...']);
  else
  
    disp('matNMR WARNING: A 2D baseline correction has already been done. Please accept, reject or undo this first!');
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
