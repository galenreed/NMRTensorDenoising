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
%regelsolventsuppression1d.m performs the solvent suppression routine as described
%	by Marion, Ikura and Bax in Journal of Magnetic Resonance, 84, 425-430 (1989)
%
%10-08-'01

try
  if QmatNMR.buttonList == 1						%= OK-button
    watch
  
    if (QmatNMR.SwitchTo1D) 		%switch from 2D to 1D processing if necessary
      SwitchTo1D
    end
  
    %
    %create entry in the undo matrix
    %
    regelUNDO
  
    QmatNMR.SolventSuppressionWindow = QmatNMR.uiInput1;
    QmatNMR.SolventSuppressionWidth = eval(QmatNMR.uiInput2);
    QmatNMR.SolventSuppressionExtrapolate = eval(QmatNMR.uiInput3);
  
    QTEMP1 = zeros(1, QmatNMR.Size1D);
    QTEMP4 = zeros(1, QmatNMR.Size1D);
    QTEMP3 = -QmatNMR.SolventSuppressionWidth:QmatNMR.SolventSuppressionWidth;
  
    %
    %Define the shape of the window function and its normalization factor
    %
    if (QmatNMR.SolventSuppressionWindow == 1) 		%use gaussian window function
      %
      %First we calculate the normalization factor
      %
      QmatNMR.NormalizationFactor = sum(exp(-4*QTEMP3.^2/QmatNMR.SolventSuppressionWidth^2));
      QTEMP5 = (exp(-4*QTEMP3.^2/QmatNMR.SolventSuppressionWidth^2));
  
      QmatNMR.History = str2mat(QmatNMR.History, ['Solvent suppression performed with Gaussian, width=' num2str(QmatNMR.SolventSuppressionWidth) ', extrapolate=' num2str(QmatNMR.SolventSuppressionExtrapolate)]);
  
    elseif (QmatNMR.SolventSuppressionWindow == 2) 	%use sine-bell function
      %
      %First we calculate the normalization factor
      %
      QmatNMR.NormalizationFactor = sum(cos(QTEMP3*pi/(2*QmatNMR.SolventSuppressionWidth+2)));
      QTEMP5 = (cos(QTEMP3*pi/(2*QmatNMR.SolventSuppressionWidth+2)));
  
      QmatNMR.History = str2mat(QmatNMR.History, ['Solvent suppression performed with Sine-Bell, width=' num2str(QmatNMR.SolventSuppressionWidth) ', extrapolate=' num2str(QmatNMR.SolventSuppressionExtrapolate)]);
  
    else  					%use rectangular function
      %
      %First we calculate the normalization factor
      %
      QmatNMR.NormalizationFactor = 2*QmatNMR.SolventSuppressionWidth+1;
      QTEMP5 = ones(1, length(QTEMP3));
  
      QmatNMR.History = str2mat(QmatNMR.History, ['Solvent suppression performed with Rectangle, width=' num2str(QmatNMR.SolventSuppressionWidth) ', extrapolate=' num2str(QmatNMR.SolventSuppressionExtrapolate)]);
    end
  
    %
    %Then we calculate all the points that need not be extrapolated
    %
    for QTEMP2=1:(2*QmatNMR.SolventSuppressionWidth+1)
      QTEMP1((1+QmatNMR.SolventSuppressionWidth):(QmatNMR.Size1D-QmatNMR.SolventSuppressionWidth)) = QTEMP1((1+QmatNMR.SolventSuppressionWidth):(QmatNMR.Size1D-QmatNMR.SolventSuppressionWidth)) + QTEMP5(QTEMP2) .*(real(QmatNMR.Spec1D( ((1+QmatNMR.SolventSuppressionWidth):(QmatNMR.Size1D-QmatNMR.SolventSuppressionWidth)) + QTEMP2 - QmatNMR.SolventSuppressionWidth - 1)));
      QTEMP4((1+QmatNMR.SolventSuppressionWidth):(QmatNMR.Size1D-QmatNMR.SolventSuppressionWidth)) = QTEMP4((1+QmatNMR.SolventSuppressionWidth):(QmatNMR.Size1D-QmatNMR.SolventSuppressionWidth)) + QTEMP5(QTEMP2) .*(imag(QmatNMR.Spec1D( ((1+QmatNMR.SolventSuppressionWidth):(QmatNMR.Size1D-QmatNMR.SolventSuppressionWidth)) + QTEMP2 - QmatNMR.SolventSuppressionWidth - 1)));
    end
  
    %
    %And finally we calculate all the points that must be extrapolated
    %
    QTEMP2 = (QTEMP1(QmatNMR.SolventSuppressionWidth+1)-QTEMP1(QmatNMR.SolventSuppressionWidth+QmatNMR.SolventSuppressionExtrapolate))/QmatNMR.SolventSuppressionExtrapolate;
    QTEMP1(1:QmatNMR.SolventSuppressionWidth) = QTEMP1(QmatNMR.SolventSuppressionWidth+1) + (QmatNMR.SolventSuppressionWidth:-1:1)*QTEMP2;
    QTEMP2 = (QTEMP4(QmatNMR.SolventSuppressionWidth+1)-QTEMP4(QmatNMR.SolventSuppressionWidth+QmatNMR.SolventSuppressionExtrapolate))/QmatNMR.SolventSuppressionExtrapolate;
    QTEMP4(1:QmatNMR.SolventSuppressionWidth) = QTEMP4(QmatNMR.SolventSuppressionWidth+1) + (QmatNMR.SolventSuppressionWidth:-1:1)*QTEMP2;
  
    QTEMP2 = (-QTEMP1(QmatNMR.Size1D-QmatNMR.SolventSuppressionWidth)+QTEMP1(QmatNMR.Size1D-QmatNMR.SolventSuppressionWidth-QmatNMR.SolventSuppressionExtrapolate+1))/QmatNMR.SolventSuppressionExtrapolate;
    QTEMP1( (QmatNMR.Size1D-QmatNMR.SolventSuppressionWidth+1):QmatNMR.Size1D ) = QTEMP1(QmatNMR.Size1D-QmatNMR.SolventSuppressionWidth) + (1:QmatNMR.SolventSuppressionWidth)*QTEMP2;
    QTEMP2 = (-QTEMP4(QmatNMR.Size1D-QmatNMR.SolventSuppressionWidth)+QTEMP4(QmatNMR.Size1D-QmatNMR.SolventSuppressionWidth-QmatNMR.SolventSuppressionExtrapolate+1))/QmatNMR.SolventSuppressionExtrapolate;
    QTEMP4( (QmatNMR.Size1D-QmatNMR.SolventSuppressionWidth+1):QmatNMR.Size1D ) = QTEMP4(QmatNMR.Size1D-QmatNMR.SolventSuppressionWidth) + (1:QmatNMR.SolventSuppressionWidth)*QTEMP2;
  
    %
    %substract the low-frequency approximation from the FID
    %
    QmatNMR.Spec1D = QmatNMR.Spec1D - (QTEMP1 + sqrt(-1)*QTEMP4)/QmatNMR.NormalizationFactor;

  
    %
    %take care of the history macro
    %
    %first add dimension-specific information, and then the current command
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
    QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 17, QmatNMR.SolventSuppressionWindow, QmatNMR.SolventSuppressionWidth, QmatNMR.SolventSuppressionExtrapolate);	%code for solvent suppression 1D
  
    if QmatNMR.RecordingMacro
      %first add dimension-specific information, and then the current command
      QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
      QmatNMR.Macro = AddToMacro(QmatNMR.HistoryMacro, 17, QmatNMR.SolventSuppressionWindow, QmatNMR.SolventSuppressionWidth, QmatNMR.SolventSuppressionExtrapolate);	%code for solvent suppression 1D
    end
  
    if (~QmatNMR.BusyWithMacro)
      asaanpas
      Arrowhead;
    end
  
    disp('1D solvent suppression performed');
  
  else
    disp('1D solvent suppression cancelled ...');
    QmatNMR.SwitchTo1D = 0;	%reset flag because it is possible that the user came from a 2D but cancelled the action
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
