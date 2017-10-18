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
%apodize1d.m handles apodization of 1D FID's in matNMR
%
%23-03-'99

try
  if (QmatNMR.buttonList == 1)
    %
    %create entry in the undo matrix
    %
    regelUNDO
  
  
    repairapodize;
    
    QmatNMR.lbstatus = QmatNMR.lbTempstatus;	%retrieve the code for the new type of apodization function.
    
    switch QmatNMR.lbstatus
      case -99			%cos^2
        QmatNMR.PhaseFactor = eval(QmatNMR.uiInput1);
        QmatNMR.Cos2Span = eval(QmatNMR.uiInput2);
        QmatNMR.emacht = cos(((1:QmatNMR.Size1D)*(1+QmatNMR.PhaseFactor)*QmatNMR.Cos2Span - QmatNMR.PhaseFactor*QmatNMR.Size1D)*pi/(2*QmatNMR.Size1D)) .^ 2;
      
      case -60			%block and exponential
        QmatNMR.blocklength = eval(QmatNMR.uiInput1);
        QmatNMR.lb = eval(QmatNMR.uiInput2);
        QmatNMR.emacht = ones(1, QmatNMR.blocklength);
        QmatNMR.emacht((QmatNMR.blocklength+1:QmatNMR.Size1D)) = exp(-QmatNMR.lb*(0:(QmatNMR.Size1D-QmatNMR.blocklength-1))/QmatNMR.SW1D/1000);
  
        
      case -50			%block and cos^2
        QmatNMR.blocklength = eval(QmatNMR.uiInput1);
        QmatNMR.emacht = ones(1, QmatNMR.blocklength);
        QmatNMR.emacht((QmatNMR.blocklength+1:QmatNMR.Size1D)) = cos((1:(QmatNMR.Size1D-QmatNMR.blocklength))*pi/(2*(QmatNMR.Size1D-QmatNMR.blocklength))) .* cos((1:(QmatNMR.Size1D-QmatNMR.blocklength))*pi/(2*(QmatNMR.Size1D-QmatNMR.blocklength)));
  
  
      case -40			%Hanning
        QmatNMR.PhaseFactor = eval(QmatNMR.uiInput1);
        QmatNMR.emacht = 0.50 + 0.50*cos(((1:QmatNMR.Size1D) - QmatNMR.PhaseFactor*QmatNMR.Size1D)*pi/(QmatNMR.Size1D));
  
  
      case -30			%Hamming
        QmatNMR.PhaseFactor = eval(QmatNMR.uiInput1);
        QmatNMR.emacht = 0.54 + 0.46*cos(((1:QmatNMR.Size1D) - QmatNMR.PhaseFactor*QmatNMR.Size1D)*pi/(QmatNMR.Size1D));
  
      
      case 10			%gaussian
        QmatNMR.lb = eval(QmatNMR.uiInput1);
        QmatNMR.gb = eval(QmatNMR.uiInput2);
        QmatNMR.GaussB =  (QmatNMR.gb/(sqrt(8*log(2))));
        QmatNMR.emacht = exp( -QmatNMR.lb*(2*pi/(2*QmatNMR.SW1D*1000))*(0:(QmatNMR.Size1D-1)) - 2*((QmatNMR.GaussB)*(2*pi/(2*QmatNMR.SW1D*1000))*(0:(QmatNMR.Size1D-1))).^2 );
        QmatNMR.emacht = QmatNMR.emacht / max(QmatNMR.emacht);
  
  
      case 50			%exponential
        QmatNMR.lb = eval(QmatNMR.uiInput1);
        QmatNMR.emacht = exp(-QmatNMR.lb*(0:(QmatNMR.Size1D-1))*2*pi/(2*QmatNMR.SW1D*1000));
  
      case 100			%shifting gaussian
        QmatNMR.gb = eval(QmatNMR.uiInput1);
        QmatNMR.SWTD2 = eval(QmatNMR.uiInput2);
        QmatNMR.SWTD1 = eval(QmatNMR.uiInput3);
        QmatNMR.ShearingFactor = eval(QmatNMR.uiInput4);
        QmatNMR.EchoMaximum = eval(QmatNMR.uiInput5);
        QmatNMR.ShiftDirection = QmatNMR.uiInput6-1;
        
        QmatNMR.SW1D = QmatNMR.SWTD2;
        set(QmatNMR.hsweep, 'String', num2str(QmatNMR.SW1D, 10));
  
        QmatNMR.howFT = get(QmatNMR.Four, 'value');
        if (QmatNMR.howFT == 4)				%TPPI
          QmatNMR.DwellRatio = QmatNMR.SWTD2*1000*QmatNMR.ShearingFactor/(2*QmatNMR.SWTD1*1000);
        else  					%all other types of processing
          QmatNMR.DwellRatio = QmatNMR.SWTD2*1000*QmatNMR.ShearingFactor/(QmatNMR.SWTD1*1000);
        end    
        QmatNMR.GaussB =  (QmatNMR.gb/(sqrt(8*log(2))));
        [QTEMP4, QTEMP3] = size(QmatNMR.Spec2D);
        QmatNMR.emacht = zeros(QTEMP4, QTEMP3);
        
        if (QmatNMR.ShiftDirection==0)		%positive shift in time of the gaussian
          QTEMP = -1;			%positive shift in time of the gaussian
        else
          QTEMP = 1;			%negative shift in time of the gaussian
        end
      
        %
        %QTEMP3 = TD1, QTEMP4 = TD2 ! for FID's !!!!
        %
        for QTEMP40=1:QTEMP4
  	QmatNMR.emacht2 = exp(- 2*((QmatNMR.GaussB)*(2*pi/(2*QmatNMR.SWTD2*1000))*((1:QmatNMR.Size1D) - QmatNMR.EchoMaximum + QTEMP*((QTEMP40-1)*QmatNMR.DwellRatio))).^2 );
  	QmatNMR.emacht2 = QmatNMR.emacht2 / max(QmatNMR.emacht2);
  	QmatNMR.emacht(QTEMP40, 1:QTEMP3) = QmatNMR.emacht2;
        end
  
  
      case 101			%gaussian for whole echo FID
        QmatNMR.lb = eval(QmatNMR.uiInput1);
        QmatNMR.gb = eval(QmatNMR.uiInput2);
        QmatNMR.nulpunt = floor(QmatNMR.Size1D/2) + 1;
        QmatNMR.GaussB =  (QmatNMR.gb/(sqrt(8*log(2))));
        QmatNMR.emacht = fftshift(exp( -QmatNMR.lb*(2*pi/(2*QmatNMR.SW1D*1000))*abs(QmatNMR.nulpunt-(1:QmatNMR.Size1D)) - 2*((QmatNMR.GaussB)*(2*pi/(2*QmatNMR.SW1D*1000))*abs(QmatNMR.nulpunt-(1:QmatNMR.Size1D))).^2 ));
        QmatNMR.emacht = QmatNMR.emacht / max(QmatNMR.emacht);
  
  
      case 501			%exponential for whole echo FID
        QmatNMR.lb = eval(QmatNMR.uiInput1);
        QmatNMR.nulpunt = floor(QmatNMR.Size1D/2) + 1;
        QmatNMR.emacht = fftshift(exp(  -QmatNMR.lb*abs(QmatNMR.nulpunt-(1:QmatNMR.Size1D))*2*pi/(2*QmatNMR.SW1D*1000)  ));
  
  
      case 1001			%shifting gaussian for whole echo FID
        QmatNMR.gb = eval(QmatNMR.uiInput1);
        QmatNMR.SWTD2 = eval(QmatNMR.uiInput2);
        QmatNMR.SWTD1 = eval(QmatNMR.uiInput3);
        QmatNMR.ShearingFactor = eval(QmatNMR.uiInput4);
        QmatNMR.EchoMaximum = eval(QmatNMR.uiInput5);
  
        QmatNMR.SW1D = QmatNMR.SWTD2;
        set(QmatNMR.hsweep, 'String', num2str(QmatNMR.SW1D, 10));
        QmatNMR.GaussB =  (QmatNMR.gb/(sqrt(8*log(2))));
  
        QmatNMR.howFT = get(QmatNMR.Four, 'value');
        if (QmatNMR.howFT == 4)				%TPPI
          QmatNMR.DwellRatio = QmatNMR.SWTD2*1000*QmatNMR.ShearingFactor/(2*QmatNMR.SWTD1*1000);
        else  					%all other types of processing
          QmatNMR.DwellRatio = QmatNMR.SWTD2*1000*QmatNMR.ShearingFactor/(QmatNMR.SWTD1*1000);
        end    
        [QTEMP4, QTEMP3] = size(QmatNMR.Spec2D);
        QmatNMR.emacht = zeros(QTEMP4, QTEMP3);
  
        if (QmatNMR.EchoMaximum == 0) 			%a swap whole echo has been performed before the apodization step.
        						%then the shifting gaussian is basically convergent (in T1)
          %
          %QTEMP3 = TD1, QTEMP4 = TD2 ! for FID's !!!!
          %
          for QTEMP40=1:QTEMP4
            QmatNMR.emacht2 = [exp(- 2*((QmatNMR.GaussB)*(2*pi/(2*QmatNMR.SWTD2*1000))*((0:(floor(QmatNMR.Size1D/2)-1)) - ((QTEMP40-1)*QmatNMR.DwellRatio))).^2 )    exp(- 2*((QmatNMR.GaussB)*(2*pi/(2*QmatNMR.SWTD2*1000))*(QmatNMR.Size1D - ((floor(QmatNMR.Size1D/2)+1):QmatNMR.Size1D) - ((QTEMP40-1)*QmatNMR.DwellRatio))).^2 )];
            QmatNMR.emacht2 = QmatNMR.emacht2 / max(QmatNMR.emacht2);
            QmatNMR.emacht(QTEMP40, 1:QTEMP3) = QmatNMR.emacht2;
          end
  
        else					%no "swap whole echo" has been done. Then the shifting gaussians are basically
        						%divergent in T1
          %
          %QTEMP3 = TD1, QTEMP4 = TD2 ! for FID's !!!!
          %
          for QTEMP40=1:QTEMP4
            QmatNMR.emacht2 = [exp(- 2*((QmatNMR.GaussB)*(2*pi/(2*QmatNMR.SWTD2*1000))*((1:(QmatNMR.EchoMaximum-1)) - (QmatNMR.EchoMaximum) + ((QTEMP40-1)*QmatNMR.DwellRatio))).^2 )    exp(- 2*((QmatNMR.GaussB)*(2*pi/(2*QmatNMR.SWTD2*1000))*(QmatNMR.EchoMaximum - (0:QmatNMR.Size1D-QmatNMR.EchoMaximum) - (QmatNMR.EchoMaximum) + ((QTEMP40-1)*QmatNMR.DwellRatio))).^2 )];
            QmatNMR.emacht2 = QmatNMR.emacht2 / max(QmatNMR.emacht2);
            QmatNMR.emacht(QTEMP40, 1:QTEMP3) = QmatNMR.emacht2;
          end
        end	
      
      otherwise
        disp('matNMR ERROR: Unknown code for apodization function');
        beep
    end      
  
    restorelb		%make apodization effective
    Qspcrel
    CheckAxis
  
    if (~QmatNMR.BusyWithMacro)
      %
      %replot the altered FID and reset the X-axis
      %
      simpelplot
      resetXaxis
    
      %
      %plot apodisation function in blue in the same plot
      %
      plotapodizer
    end  
  
    %
    %put information in history clipboard. Just in case the user performs an apodization to a slice of
    %a 2D and afterwards switches to a 1D mode, then the apodization is stored a posteriori in the
    %routine SwitchTo1D.
    %
    if (QmatNMR.Dim == 0)
      QmatNMR.APosterioriHistoryEntry = 0;
    else
      QmatNMR.APosterioriHistoryEntry = 1;
    end
    historyapodize
  
  else
    repairapodizebutton
    disp('Apodization canceled ...');
  end  
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
