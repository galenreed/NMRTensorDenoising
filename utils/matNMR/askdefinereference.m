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
%askdefinereference allows manual definition of an external spectral reference
%
%29-09-2004

try
  if (((QmatNMR.Dim == 0) & (QmatNMR.RulerXAxis == 1)) | ((QmatNMR.Dim) & (QmatNMR.RulerXAxis1) & (QmatNMR.RulerXAxis2)))
    disp('matNMR NOTICE: spectral references can only be imported when using the default axis! Aborting ...');
    return  
  
  elseif ((QmatNMR.Dim) & (QmatNMR.RulerXAxis1 | QmatNMR.RulerXAxis2))
    disp('matNMR NOTICE: the spectral reference will only apply to dimensions which are in default axis mode!');
  end
  
  
  %
  %for external references for 2D spectra we need to make sure the strings for the input window are made properly
  %
  QTEMP4 = 0;	%flag to check reference values
  QTEMP1 = num2str(QmatNMR.ExternalReferenceFreq(1), 10);
  if (length(QmatNMR.ExternalReferenceFreq) == 2)
    QTEMP1 = [QTEMP1 ' ' num2str(QmatNMR.ExternalReferenceFreq(2), 10)];
    QTEMP4 = 1;	%reference values are for a 2D spectrum
  end
  
  QTEMP2 = num2str(QmatNMR.ExternalReferenceValue(1), 10);
  if (length(QmatNMR.ExternalReferenceValue) == 2)
    QTEMP2 = [QTEMP2 ' ' num2str(QmatNMR.ExternalReferenceValue(2), 10)];
    QTEMP4 = 1;	%reference values are for a 2D spectrum
  end
  
  QTEMP3 = num2str(QmatNMR.ExternalReferenceUnit(1), 10);
  if (length(QmatNMR.ExternalReferenceUnit) == 2)
    QTEMP3 = [QTEMP3 ' ' num2str(QmatNMR.ExternalReferenceUnit(2), 10)];
    QTEMP4 = 1;	%reference values are for a 2D spectrum
  end
  
  
  %
  %if the user has executed "apply external reference" then we don't want the next input window to show the
  %same variable name to store the new reference in.
  %
  if (QmatNMR.BusyWithExternalRef == 1)
    QTEMP6 = '';
    
  else
    %QTEMP6 = QmatNMR.ExternalReferenceVar;
    QTEMP6 = '';
  end
  QmatNMR.BusyWithExternalRef = 0;
  
  
  %
  %open the input window
  %
  if (~QmatNMR.Dim) 	%1D mode
    %
    %warn if current values are for 2D spectrum
    %
    if (QTEMP4 == 1)
      disp('matNMR WARNING: current reference values are for a 2D spectrum but current processing mode is 1D!!');
    end
  
    QuiInput('Define external reference for current 1D :', 'OK | CANCEL', 'regeldefinereference', [], ...
           'Reference Frequency    (MHz) : ', QTEMP1, ...
           'Reference Value    (Unit) : ', QTEMP2, ...
           'Reference Unit    (1=ppm, 2=kHz) : ', QTEMP3, ...
  	 'Save external reference in workspace (optional)', QTEMP6);
  
  else			%2D mode
    QuiInput('Define external reference for current 2D :', 'OK | CANCEL', 'regeldefinereference', [], ...
           'Reference Frequencies [TD2  TD1]    (MHz): ', QTEMP1, ...
           'Reference Values [TD2  TD1]    (Unit) : ', QTEMP2, ...
           'Reference Units [TD2  TD1]    (1=ppm, 2=kHz) : ', QTEMP3, ...
  	 'Save external reference in workspace (optional)', QTEMP6);
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
