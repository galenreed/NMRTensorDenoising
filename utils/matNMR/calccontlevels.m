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
%calccontlevels.m calculates the contour levels
%20-08-'98

try
  [QTEMP3, QTEMP4] = size(QmatNMR.Spec2D3D);		%First make a necessary adjustment to the matrix so MATLAB is able to do a
  if QTEMP3 > QTEMP4				% max(matrix) command ...
    QTEMPspec = zeros(QTEMP3);
  else
    QTEMPspec = zeros(QTEMP4);
  end
  
  QmatNMR.contdisplay = QmatNMR.contdisplaystring(get(QmatNMR.c17, 'value'), :);
  QTEMPspec(1:QTEMP3, 1:QTEMP4) = eval([QmatNMR.contdisplay '(QmatNMR.Spec2D3D)']);  	%make a real square matrix of spectrum
  								%QmatNMR.contdisplay determines whether the real, imaginary or absolute part is taken!
  
  if (QmatNMR.negcont == 1)			%Only positive contours
    QmatNMR.specmax = max(max(QTEMPspec));
    QmatNMR.fact = (QmatNMR.over - QmatNMR.under);
  
    %
    %protect against incorrect input
    %
    if (length(QmatNMR.numbcont)>1)
      QmatNMR.numbcont = QmatNMR.numbcont(1);
    end
  
    QmatNMR.ContourLevels = zeros(1, QmatNMR.numbcont);
  								%calculate the positive contour levels
    if (QmatNMR.multcont == 1)					%multiplier = 1 --> linear scale
      if (QmatNMR.numbcont == 1)
        QmatNMR.ContourLevels = QmatNMR.specmax / 100 * QmatNMR.fact / 2;
      else
        QmatNMR.ContourLevels(1:QmatNMR.numbcont) = (QmatNMR.specmax/100) * ( ( ((0:QmatNMR.numbcont-1)/(QmatNMR.numbcont-1)) * QmatNMR.fact) + QmatNMR.under);
      end
    else
      %
      %use non-linear contour levels. If multiplier > 1 then we start with lowest contour level and multiply each next level by the multiplier,
      %whilst ignoring the number of contour levels specified by the user
      %
      QmatNMR.ContourLevels = QmatNMR.under * (QmatNMR.multcont .^ (0:250));
      QmatNMR.ContourLevels = QmatNMR.ContourLevels(find(QmatNMR.ContourLevels < QmatNMR.over));
      QmatNMR.ContourLevels = sort((QmatNMR.specmax/100) * QmatNMR.ContourLevels);
      QmatNMR.numbcont = length(QmatNMR.ContourLevels);
    end
  
    %
    %reset the PosNeg colormaps
    %
    AdjustPosNeg
  
  
  elseif (QmatNMR.negcont == 2)			%Only negative contours  
    QmatNMR.specmin = min(min(QTEMPspec));
    QmatNMR.fact = (QmatNMR.over - QmatNMR.under);
  
    %
    %protect against incorrect input
    %
    if (length(QmatNMR.numbcont)>1)
      QmatNMR.numbcont = QmatNMR.numbcont(1);
    end
  
    QmatNMR.ContourLevels = zeros(1, QmatNMR.numbcont);
  
    								%calculate the negative contour levels
    if (QmatNMR.multcont == 1)					%multiplier = 1 --> linear scale
      if (QmatNMR.numbcont == 1)
        QmatNMR.ContourLevels = QmatNMR.specmin / 100 * QmatNMR.fact / 2;
      else
        QmatNMR.ContourLevels(1:QmatNMR.numbcont) = (QmatNMR.specmin/100) * (( (((QmatNMR.numbcont-1):-1:0)/(QmatNMR.numbcont-1)) * QmatNMR.fact) + QmatNMR.under);
      end
    else
      %
      %use non-linear contour levels. If multiplier > 1 then we start with lowest contour level and multiply each next level by the multiplier,
      %whilst ignoring the number of contour levels specified by the user
      %
      QmatNMR.ContourLevels = QmatNMR.under * (QmatNMR.multcont .^ (0:250));
      QmatNMR.ContourLevels = QmatNMR.ContourLevels(find(QmatNMR.ContourLevels < QmatNMR.over));
      QmatNMR.ContourLevels = sort((QmatNMR.specmin/100) * QmatNMR.ContourLevels);
      QmatNMR.numbcont = length(QmatNMR.ContourLevels);
    end
  
    %
    %reset the PosNeg colormaps
    %
    AdjustPosNeg
  
    
  elseif (QmatNMR.negcont == 3)			%Positive and Negative contours, relative to the respective positive and negative maxima
    QmatNMR.specmin = min(min(QTEMPspec));
    QmatNMR.specmax = max(max(QTEMPspec));
    QmatNMR.fact = (QmatNMR.over - QmatNMR.under);
    if (length(QmatNMR.numbcont)>1)
      QmatNMR.numbcontPos = QmatNMR.numbcont(1);
      QmatNMR.numbcontNeg = QmatNMR.numbcont(2);
    else  
      QmatNMR.numbcontPos = QmatNMR.numbcont(1);
      QmatNMR.numbcontNeg = QmatNMR.numbcont(1);
    end
    QmatNMR.ContourLevels = zeros(1, QmatNMR.numbcontPos);
  
  								%calculate the positive contour levels
    if (QmatNMR.multcont == 1)					%multiplier = 1 --> linear scale
      if (QmatNMR.numbcontPos == 1)
        QmatNMR.ContourLevels = QmatNMR.specmax / 100 * QmatNMR.fact / 2;
      else
        QmatNMR.ContourLevels(1:QmatNMR.numbcontPos) = (QmatNMR.specmax/100) * ( ( ((0:QmatNMR.numbcontPos-1)/(QmatNMR.numbcontPos-1)) * QmatNMR.fact) + QmatNMR.under);
      end
    else
      %
      %use non-linear contour levels. If multiplier > 1 then we start with lowest contour level and multiply each next level by the multiplier,
      %whilst ignoring the number of contour levels specified by the user
      %
      QmatNMR.ContourLevels = QmatNMR.under * (QmatNMR.multcont .^ (0:250));
      QmatNMR.ContourLevels = QmatNMR.ContourLevels(find(QmatNMR.ContourLevels < QmatNMR.over));
      QmatNMR.ContourLevels = sort((QmatNMR.specmax/100) * QmatNMR.ContourLevels);
      QmatNMR.numbcontPos = length(QmatNMR.ContourLevels);
    end
  
    								%calculate the negative contour levels
    if (QmatNMR.multcont == 1)					%multiplier = 1 --> linear scale
      QmatNMR.ContourLevels((QmatNMR.numbcontNeg+1):(QmatNMR.numbcontPos+QmatNMR.numbcontNeg)) = QmatNMR.ContourLevels;
      if (QmatNMR.numbcontNeg == 1)
        QmatNMR.ContourLevels(1) = QmatNMR.specmin / 100 * QmatNMR.fact / 2;
      else
        QmatNMR.ContourLevels(1:QmatNMR.numbcontNeg) = (QmatNMR.specmin/100) * (( (((QmatNMR.numbcontNeg-1):-1:0)/(QmatNMR.numbcontNeg-1)) * QmatNMR.fact) + QmatNMR.under);
      end
    else
      %
      %use non-linear contour levels. If multiplier > 1 then we start with lowest contour level and multiply each next level by the multiplier,
      %whilst ignoring the number of contour levels specified by the user
      %
      QTEMP1 = QmatNMR.under * (QmatNMR.multcont .^ (0:250));
      QTEMP1 = QTEMP1(find(QTEMP1 < QmatNMR.over));
      QTEMP1 = sort((QmatNMR.specmin/100) * QTEMP1);
      QmatNMR.numbcontNeg = length(QTEMP1);
      QmatNMR.ContourLevels((QmatNMR.numbcontNeg+1):(QmatNMR.numbcontPos+QmatNMR.numbcontNeg)) = QmatNMR.ContourLevels;
      QmatNMR.ContourLevels(1:QmatNMR.numbcontNeg) = QTEMP1;
    end
  
    QmatNMR.ContourLevels = sort(QmatNMR.ContourLevels);
  
    if (QmatNMR.ContourLevels(QmatNMR.numbcontNeg) == QmatNMR.ContourLevels(QmatNMR.numbcontNeg+1))	%prevent a double contour on 0
      QmatNMR.tmp = QmatNMR.ContourLevels;
      QmatNMR.ContourLevels = zeros(1, QmatNMR.numbcontPos+QmatNMR.numbcontNeg-1);
      QmatNMR.ContourLevels(1:QmatNMR.numbcontNeg) = QmatNMR.tmp(1:QmatNMR.numbcontNeg);
      QmatNMR.ContourLevels( (QmatNMR.numbcontNeg+1) : (QmatNMR.numbcontPos+QmatNMR.numbcontNeg-1) ) = QmatNMR.tmp( (QmatNMR.numbcontNeg+2) : (QmatNMR.numbcontPos+QmatNMR.numbcontNeg) );
    end
    
    %
    %Now adjust the QmatNMR.PosNegMap colormap such that the 121nd element (which is green) = 0 in the color axis
    %
    AdjustPosNeg(QmatNMR.specmin, QmatNMR.specmax);
  
  
  elseif (QmatNMR.negcont == 4)			%Positive and Negative contours, relative to the positive maximum
    QmatNMR.specmax = max(max(QTEMPspec));
    QmatNMR.specmin = -QmatNMR.specmax;
    QmatNMR.fact = (QmatNMR.over - QmatNMR.under);
    if (length(QmatNMR.numbcont)>1)
      QmatNMR.numbcontPos = QmatNMR.numbcont(1);
      QmatNMR.numbcontNeg = QmatNMR.numbcont(2);
    else  
      QmatNMR.numbcontPos = QmatNMR.numbcont(1);
      QmatNMR.numbcontNeg = QmatNMR.numbcont(1);
    end
    QmatNMR.ContourLevels = zeros(1, QmatNMR.numbcontPos);
  
  								%calculate the positive contour levels
    if (QmatNMR.multcont == 1)					%multiplier = 1 --> linear scale
      if (QmatNMR.numbcontPos == 1)
        QmatNMR.ContourLevels = QmatNMR.specmax / 100 * QmatNMR.fact / 2;
      else
        QmatNMR.ContourLevels(1:QmatNMR.numbcontPos) = (QmatNMR.specmax/100) * ( ( ((0:QmatNMR.numbcontPos-1)/(QmatNMR.numbcontPos-1)) * QmatNMR.fact) + QmatNMR.under);
      end
    else
      %
      %use non-linear contour levels. If multiplier > 1 then we start with lowest contour level and multiply each next level by the multiplier,
      %whilst ignoring the number of contour levels specified by the user
      %
      QmatNMR.ContourLevels = QmatNMR.under * (QmatNMR.multcont .^ (0:250));
      QmatNMR.ContourLevels = QmatNMR.ContourLevels(find(QmatNMR.ContourLevels < QmatNMR.over));
      QmatNMR.ContourLevels = sort((QmatNMR.specmax/100) * QmatNMR.ContourLevels);
      QmatNMR.numbcontPos = length(QmatNMR.ContourLevels);
    end
  
    								%calculate the negative contour levels
    if (QmatNMR.multcont == 1)					%multiplier = 1 --> linear scale
      QmatNMR.ContourLevels((QmatNMR.numbcontNeg+1):(QmatNMR.numbcontPos+QmatNMR.numbcontNeg)) = QmatNMR.ContourLevels;
      if (QmatNMR.numbcontNeg == 1)
        QmatNMR.ContourLevels(1) = QmatNMR.specmin / 100 * QmatNMR.fact / 2;
      else
        QmatNMR.ContourLevels(1:QmatNMR.numbcontNeg) = (QmatNMR.specmin/100) * (( (((QmatNMR.numbcontNeg-1):-1:0)/(QmatNMR.numbcontNeg-1)) * QmatNMR.fact) + QmatNMR.under);
      end
    else
      %
      %use non-linear contour levels. If multiplier > 1 then we start with lowest contour level and multiply each next level by the multiplier,
      %whilst ignoring the number of contour levels specified by the user
      %
      QTEMP1 = QmatNMR.under * (QmatNMR.multcont .^ (0:250));
      QTEMP1 = QTEMP1(find(QTEMP1 < QmatNMR.over));
      QTEMP1 = sort((QmatNMR.specmin/100) * QTEMP1);
      QmatNMR.numbcontNeg = length(QTEMP1);
      QmatNMR.ContourLevels((QmatNMR.numbcontNeg+1):(QmatNMR.numbcontPos+QmatNMR.numbcontNeg)) = QmatNMR.ContourLevels;
      QmatNMR.ContourLevels(1:QmatNMR.numbcontNeg) = QTEMP1;
    end
  
    QmatNMR.ContourLevels = sort(QmatNMR.ContourLevels);
  
    if (QmatNMR.ContourLevels(QmatNMR.numbcontNeg) == QmatNMR.ContourLevels(QmatNMR.numbcontNeg+1))	%prevent a double contour on 0
      QmatNMR.tmp = QmatNMR.ContourLevels;
      QmatNMR.ContourLevels = zeros(1, QmatNMR.numbcontPos+QmatNMR.numbcontNeg-1);
      QmatNMR.ContourLevels(1:QmatNMR.numbcontNeg) = QmatNMR.tmp(1:QmatNMR.numbcontNeg);
      QmatNMR.ContourLevels( (QmatNMR.numbcontNeg+1) : (QmatNMR.numbcontPos+QmatNMR.numbcontNeg-1) ) = QmatNMR.tmp( (QmatNMR.numbcontNeg+2) : (QmatNMR.numbcontPos+QmatNMR.numbcontNeg) );
    end
  
    
    %
    %reset the PosNeg colormaps
    %
    AdjustPosNeg
  
  
  elseif (QmatNMR.negcont == 5)			%Positive and Negative contours, relative to the negative maximum
    QmatNMR.specmax = min(min(QTEMPspec));
    QmatNMR.specmin = -QmatNMR.specmax;
    QmatNMR.fact = (QmatNMR.over - QmatNMR.under);
    if (length(QmatNMR.numbcont)>1)
      QmatNMR.numbcontPos = QmatNMR.numbcont(1);
      QmatNMR.numbcontNeg = QmatNMR.numbcont(2);
    else  
      QmatNMR.numbcontPos = QmatNMR.numbcont(1);
      QmatNMR.numbcontNeg = QmatNMR.numbcont(1);
    end
    QmatNMR.ContourLevels = zeros(1, QmatNMR.numbcontPos);
  
  								%calculate the positive contour levels
    if (QmatNMR.multcont == 1)					%multiplier = 1 --> linear scale
      if (QmatNMR.numbcontPos == 1)
        QmatNMR.ContourLevels = QmatNMR.specmax / 100 * QmatNMR.fact / 2;
      else
        QmatNMR.ContourLevels(1:QmatNMR.numbcontPos) = (QmatNMR.specmax/100) * ( ( ((0:QmatNMR.numbcontPos-1)/(QmatNMR.numbcontPos-1)) * QmatNMR.fact) + QmatNMR.under);
      end
    else
      %
      %use non-linear contour levels. If multiplier > 1 then we start with lowest contour level and multiply each next level by the multiplier,
      %whilst ignoring the number of contour levels specified by the user
      %
      QmatNMR.ContourLevels = QmatNMR.under * (QmatNMR.multcont .^ (0:250));
      QmatNMR.ContourLevels = QmatNMR.ContourLevels(find(QmatNMR.ContourLevels < QmatNMR.over));
      QmatNMR.ContourLevels = sort((QmatNMR.specmax/100) * QmatNMR.ContourLevels);
      QmatNMR.numbcontPos = length(QmatNMR.ContourLevels);
    end
  
    								%calculate the negative contour levels
    if (QmatNMR.multcont == 1)					%multiplier = 1 --> linear scale
      QmatNMR.ContourLevels((QmatNMR.numbcontNeg+1):(QmatNMR.numbcontPos+QmatNMR.numbcontNeg)) = QmatNMR.ContourLevels;
      if (QmatNMR.numbcontNeg == 1)
        QmatNMR.ContourLevels(1) = QmatNMR.specmin / 100 * QmatNMR.fact / 2;
      else
        QmatNMR.ContourLevels(1:QmatNMR.numbcontNeg) = (QmatNMR.specmin/100) * (( (((QmatNMR.numbcontNeg-1):-1:0)/(QmatNMR.numbcontNeg-1)) * QmatNMR.fact) + QmatNMR.under);
      end
    else
      %
      %use non-linear contour levels. If multiplier > 1 then we start with lowest contour level and multiply each next level by the multiplier,
      %whilst ignoring the number of contour levels specified by the user
      %
      QTEMP1 = QmatNMR.under * (QmatNMR.multcont .^ (0:250));
      QTEMP1 = QTEMP1(find(QTEMP1 < QmatNMR.over));
      QTEMP1 = sort((QmatNMR.specmin/100) * QTEMP1);
      QmatNMR.numbcontNeg = length(QTEMP1);
      QmatNMR.ContourLevels((QmatNMR.numbcontNeg+1):(QmatNMR.numbcontPos+QmatNMR.numbcontNeg)) = QmatNMR.ContourLevels;
      QmatNMR.ContourLevels(1:QmatNMR.numbcontNeg) = QTEMP1;
    end
    
    QmatNMR.ContourLevels = sort(QmatNMR.ContourLevels);
  
    if (QmatNMR.ContourLevels(QmatNMR.numbcontNeg) == QmatNMR.ContourLevels(QmatNMR.numbcontNeg+1))	%prevent a double contour on 0
      QmatNMR.tmp = QmatNMR.ContourLevels;
      QmatNMR.ContourLevels = zeros(1, QmatNMR.numbcontPos+QmatNMR.numbcontNeg-1);
      QmatNMR.ContourLevels(1:QmatNMR.numbcontNeg) = QmatNMR.tmp(1:QmatNMR.numbcontNeg);
      QmatNMR.ContourLevels( (QmatNMR.numbcontNeg+1) : (QmatNMR.numbcontPos+QmatNMR.numbcontNeg-1) ) = QmatNMR.tmp( (QmatNMR.numbcontNeg+2) : (QmatNMR.numbcontPos+QmatNMR.numbcontNeg) );
    end
  
    
    %
    %reset the PosNeg colormaps
    %
    AdjustPosNeg
  end
  
  if (QmatNMR.ContourLevels == zeros(1, length(QmatNMR.ContourLevels)))
    QmatNMR.ContourLevels = [];
    disp('matNMR WARNING: All contours levels are 0! No spectrum will be drawn');
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
