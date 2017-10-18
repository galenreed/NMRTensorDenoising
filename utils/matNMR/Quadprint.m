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
%Quadprint.moffers the possibility to print the results of a Quadrupolar tensor fit.
%All ui-controls are removed except for the parameter buttons which remain
%shown in the plot.
%02-02-'07

function SSAprint
  global QmatNMR

  %define the string that needs to be plotted and put it in the screen
  if (mod((length(QmatNMR.QuadFitResults.Parameters)-5), 6) == 0)
    NrLines = (length(QmatNMR.QuadFitResults.Parameters)-5)/6;
  
    s1 = sprintf('Quadrupolar-tensor Fit Results :\nNumber of lines  =  %d\nChi^2 =  %4.5e', NrLines, QmatNMR.QuadFitResults.Parameters(end-2));
    snew = s1;
    
    for tel = 1:NrLines
      s2 = sprintf('Fit results for line %d:  isoCS = %7.2f ppm, Cq = %6.4f MHz, eta = %5.3f,\n                 LB (Gaussian) = %7.3f ppm, LB (Lorentzian) = %7.3f ppm, Intensity = %7.2f', tel, QmatNMR.QuadFitResults.Parameters(((tel-1)*6+1):tel*6));
                           
      snew = str2mat(snew, s2);
    end
    
    s3 = sprintf('Background = %7.2f, Slope = %7.2f', QmatNMR.QuadFitResults.Parameters(end-4:end-3));
    snew = str2mat(snew, s3);
                  
    QTEMP = str2mat('3/2', '5/2', '7/2', '9/2', '11/2');
    s4 = sprintf('using :  qn = %s, omega0/(2pi) = %7.2f MHz', deblank(QTEMP(QmatNMR.QuadFitResults.Parameters(end-1)-1/2, :)), QmatNMR.QuadFitResults.Parameters(end));
    snew = str2mat(snew, s4);


    %
    %write the string as text on the screen
    %
    QmatNMR.Xlim = get(gca, 'xlim');
    QmatNMR.Ylim = get(gca, 'ylim');
    
    QTEMP1 = text(QmatNMR.Xlim(2) - (QmatNMR.Xlim(2)-QmatNMR.Xlim(1))*0.05, QmatNMR.Ylim(2)*0.85, snew);
    set(QTEMP1, 'fontsize', QmatNMR.TextSize-3, 'BackGroundColor', QmatNMR.ColorScheme.Text1Back, 'Color', QmatNMR.ColorScheme.Text1Fore);

  
    %
    %print the plot to the default printer
    %
    print -dps2 -noui


    %
    %delete the text object with the fit results
    %
    delete(QTEMP1);
  end
