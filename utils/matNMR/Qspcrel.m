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
%Qspcrel is the script that takes care of the relative or absolute scaling of the (1D) spectra

try
  if QmatNMR.yrelative
    switch (QmatNMR.DisplayMode)
      case 1	%Real spectrum
        QmatNMR.Spec1DPlot = QmatNMR.Spec1D - min(real(QmatNMR.Spec1D));
        QTEMP = max(real(QmatNMR.Spec1DPlot));
      
      case 2 	%Imaginary spectrum
        QmatNMR.Spec1DPlot = QmatNMR.Spec1D - sqrt(-1)*min(imag(QmatNMR.Spec1D));
        QTEMP = max(imag(QmatNMR.Spec1DPlot));
  
      case 3	%Both Real and Imaginary spectrum together
        if (min(real(QmatNMR.Spec1D)) < min(imag(QmatNMR.Spec1D)))
          QmatNMR.Spec1DPlot = QmatNMR.Spec1D - min(real(QmatNMR.Spec1D))*(1+sqrt(-1));
        else
          QmatNMR.Spec1DPlot = QmatNMR.Spec1D - min(imag(QmatNMR.Spec1D))*(1+sqrt(-1));
        end
        QTEMP = max([max(real(QmatNMR.Spec1DPlot)) max(imag(QmatNMR.Spec1DPlot))]);
  
      case 4	%Absolute spectrum
        QmatNMR.Spec1DPlot = QmatNMR.Spec1D - min(abs(QmatNMR.Spec1D));
        QTEMP = max(abs(QmatNMR.Spec1DPlot));
  
      case 5	%Power spectrum
        QmatNMR.Spec1DPlot = QmatNMR.Spec1D - min(abs(QmatNMR.Spec1D).^2);
        QTEMP = max(abs(QmatNMR.Spec1DPlot).^2);
  
      otherwise
        disp('matNMR ERROR: unknown value for QDisplayMode!');
        disp('matNMR ERROR: Abort ...');
        return
    end      
  
    if (QTEMP)
      QmatNMR.Spec1DPlot = QmatNMR.Spec1DPlot / QTEMP;
    end  
  
  else
    QmatNMR.Spec1DPlot = QmatNMR.Spec1D;
  end
  
  QmatNMR.Size1D = length(QmatNMR.Spec1D);
  
  %
  %in case the current dimension is an FID and a real FT mode was selected we remove the imaginary part from view
  %
  if (QmatNMR.FIDstatus == 2) 
    QmatNMR.howFT = get(QmatNMR.Four, 'value');
    
    if ((QmatNMR.howFT == 2) | (QmatNMR.howFT == 4) | (QmatNMR.howFT == 8))
      QmatNMR.Spec1DPlot = real(QmatNMR.Spec1DPlot);
    end
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
