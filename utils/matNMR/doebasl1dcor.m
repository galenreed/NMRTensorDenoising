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
%doebasl1dcor.m performs a baseline correction on the current 1D spectrum ...
%20-1-'98

try
  if (QmatNMR.FitPerformed == 0)
    QmatNMR.Basl1DFunction = get(QmatNMR.bas3, 'value');
    QmatNMR.Basl1DOrder = eval(get(QmatNMR.bas5, 'String'));
    if (QmatNMR.Basl1DOrder < 0)
      QmatNMR.Basl1DOrder = -QmatNMR.Basl1DOrder;
      set(QmatNMR.bas5, 'String', '0');
    end

    if isempty(QmatNMR.baslcornoise)
      QmatNMR.baslcornoise = 1:QmatNMR.Size1D;
    end
    QmatNMR.baslcornoise = QmatNMR.baslcornoise(:);
    QTEMP = zeros(length(QmatNMR.baslcornoise), QmatNMR.Basl1DOrder+1);

		%
		%now make the regression matrix
		%
    if (QmatNMR.Basl1DFunction == 1)	%Polynomial function
      QTEMP(:, 1) = ones(length(QmatNMR.baslcornoise),1);
      for QTEMP40=1:QmatNMR.Basl1DOrder
        QTEMP(:, QTEMP40+1) = QmatNMR.baslcornoise.^QTEMP40;
      end
    
    
    elseif (QmatNMR.Basl1DFunction == 2)	%Bernstein polynomials
      for QTEMP40=0:QmatNMR.Basl1DOrder
        QTEMP(:, QTEMP40+1) = (QmatNMR.baslcornoise.^QTEMP40).*((1-QmatNMR.baslcornoise).^(QmatNMR.Basl1DOrder-QTEMP40));
      end
    
    
    elseif (QmatNMR.Basl1DFunction == 3)	%Cosine series
      QTEMP(:, 1) = ones(length(QmatNMR.baslcornoise),1);
      for QTEMP40=1:QmatNMR.Basl1DOrder
        QTEMP(:, QTEMP40+1) = cos(QTEMP40*pi*(QmatNMR.baslcornoise-1)/QmatNMR.Size1D + QmatNMR.fase0*pi/180);
      end
    end
    
  
    				%Do the actual linear regression
  %
  %previously I used a very simple linear regression but numerically this was not so stable
  %
  %  QmatNMR.basl1dpars = QTEMP\real(QmatNMR.Spec1D(QmatNMR.baslcornoise)).'
  %
    [QTEMP1, QTEMP2] = qr(QTEMP, 0); 	%see polyfit.m
    QmatNMR.basl1dpars = QTEMP2\(QTEMP1.' * real(QmatNMR.Spec1D(QmatNMR.baslcornoise)).');    % Same as p = V\y;

    				%Now calculate the resulting baseline
    if (QmatNMR.Basl1DFunction == 1)	%Polynomial function(A+Bx+Cx^2+Dx^3...)
      QmatNMR.baseline1d = QmatNMR.basl1dpars(1)*ones(1, QmatNMR.Size1D);
      for QTEMP40=1:QmatNMR.Basl1DOrder
        QmatNMR.baseline1d =  QmatNMR.baseline1d + QmatNMR.basl1dpars(QTEMP40+1)*((1:QmatNMR.Size1D).^QTEMP40);
      end
    
    elseif (QmatNMR.Basl1DFunction == 2)	%Bernstein polynomial
      QmatNMR.baseline1d = QmatNMR.basl1dpars(1)*((1 - (1:QmatNMR.Size1D)).^QmatNMR.Basl1DOrder);
      for QTEMP40=1:QmatNMR.Basl1DOrder
        QmatNMR.baseline1d = QmatNMR.baseline1d + QmatNMR.basl1dpars(QTEMP40+1)*(((1:QmatNMR.Size1D).^QTEMP40).*((1 - (1:QmatNMR.Size1D)).^(QmatNMR.Basl1DOrder-QTEMP40)));
      end
    
    elseif (QmatNMR.Basl1DFunction == 3)	%Cosine series
      QmatNMR.baseline1d = QmatNMR.basl1dpars(1)*ones(1, QmatNMR.Size1D);
      for QTEMP40=1:QmatNMR.Basl1DOrder
        QmatNMR.baseline1d =  QmatNMR.baseline1d + QmatNMR.basl1dpars(QTEMP40+1)*cos(QTEMP40*pi*(0:(QmatNMR.Size1D-1))/QmatNMR.Size1D + QmatNMR.fase0*pi/180);
      end
    end  
    
    
      				%Now plot it all in the existing plot
    figure(QmatNMR.Fig);
    QmatNMR.Spec1D = QmatNMR.Spec1D-QmatNMR.baseline1d;
    Qspcrel
    CheckAxis
    simpelplot;
    
    
    				%This way the scale for the baseline correction is the same as for the spectrum
    if QmatNMR.yrelative
      QmatNMR.baseline1d = QmatNMR.baseline1d/max(real(QTEMP1));
    end  
    delete(findobj(allchild(gca), 'tag', 'ManualBaslcor'))
    QTEMP1 = findobj(allchild(gca), 'type', 'line');
    QTEMP2 = copyobj(QTEMP1(length(QTEMP1)), gca);
    QTEMP1 = copyobj(QTEMP1(length(QTEMP1)), gca);
    if (QmatNMR.Rincr > 0)
      %
      %if the axis increment is positive (most likely) then  we don't
      %need to fliplr the QmatNMR.baseline1d (see also CheckAxis.m), else we do
      %
      set(QTEMP1, 'ydata', QmatNMR.baseline1d, 'color', QmatNMR.color(rem(2, length(QmatNMR.color)) + 1), 'tag', 'ManualBaslcor');
      set(QTEMP2, 'ydata', QmatNMR.Spec1D+QmatNMR.baseline1d, 'color', QmatNMR.color(rem(3, length(QmatNMR.color)) + 1), 'tag', 'ManualBaslcor');
    else
      %
      %negative axis increment --> we must do a fliplr!
      %
      set(QTEMP1, 'ydata', fliplr(QmatNMR.baseline1d), 'color', QmatNMR.color(rem(2, length(QmatNMR.color)) + 1), 'tag', 'ManualBaslcor');
      set(QTEMP2, 'ydata', fliplr(QmatNMR.Spec1D+QmatNMR.baseline1d), 'color', QmatNMR.color(rem(3, length(QmatNMR.color)) + 1), 'tag', 'ManualBaslcor');
    end
      
    figure(QmatNMR.Basl1Dfig);  				
    QmatNMR.FitPerformed = 1; 		%status variable whether a fit has been performed already or not....
  else
  
    disp('matNMR WARNING: A 1D baseline correction has already been done. Please accept, reject or undo this first!');
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
