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
%dosaveliststructure.m saves the current peak list and lines and text labels into the
%structure that contains the current spectrum
%If it isn't a structure yet, it will be turned into a structure
%17-08-'98
%14-01-'99

try
  if (QmatNMR.buttonList == 1)
  
  					%check whether the QmatNMR.SpecName2D3D variable = 'QmatNMR.Spec2D'
  					%if so exit.
    if (strcmp(QmatNMR.SpecName2D3D, 'QmatNMR.Spec2D'))
      QTEMP9 = QmatNMR.uiInput1;
      eval([QTEMP9 ' = []']);
    else  
      QTEMP9 = QmatNMR.SpecName2D3D;  
    end
  
  
    if ~ (strcmp(QTEMP9, 'QmatNMR.Spec2D') | strcmp(QTEMP9, ''))
  					%Check whether there is a peak list to save
      QTEMP1 = size(QmatNMR.PeakList, 1);
      if (QTEMP1 > 1)
  					%Create a proper list to save, first the numbers, then the string text
        QTEMP2 = [QmatNMR.PeakList(1:QTEMP1, 1:3) QmatNMR.PeakList(1:QTEMP1, 5)];
        QTEMP3 = get(QmatNMR.PeakList(1,4), 'String');
        for QTel=2:QTEMP1(1)
          QTEMP3 = str2mat(QTEMP3, get(QmatNMR.PeakList(QTel,4), 'String'));
        end  
  
  	 				%Check whether the variable already is a structure
        if (isa(eval(QTEMP9), 'struct'))
          %we save the peak list in to the structure
          eval([QTEMP9 '.PeakListNums = QTEMP2;']);
          eval([QTEMP9 '.PeakListText = QTEMP3;']);
  
          %
  	%also we want to save the current axes of the plot because they were used to
  	%create the peak list and so they are necessary
  	%
          QTEMP4 = size(QmatNMR.Spec2D3D);
          if ~ (all(QmatNMR.Axis2D3DTD2 == (1:QTEMP4(2))) & all(QmatNMR.Axis2D3DTD1 == (1:QTEMP4(1))))
            eval([QTEMP9 '.AxisTD1 = QmatNMR.Axis2D3DTD1;']);
            eval([QTEMP9 '.AxisTD2 = QmatNMR.Axis2D3DTD2;']);
          else	
            eval([QTEMP9 '.AxisTD1 = [];']);
            eval([QTEMP9 '.AxisTD2 = [];']);
          end  
  
          disp('Peak List saved in data structure');
  
        else					%else make it a structure
          if exist(QTEMP9)			%but only if the variable is a single name
            %first generate a generic structure
            eval([QTEMP9 '= GenerateMatNMRStructure;']);
  
            eval([QTEMP9 '.Spectrum = QmatNMR.Spec2D3D;']);
            eval([QTEMP9 '.Hypercomplex = [];']);
            eval([QTEMP9 '.History = [];']);
            eval([QTEMP9 '.PeakListNums = QTEMP2;']);
            eval([QTEMP9 '.PeakListText = QTEMP3;']);
            eval([QTEMP9 '.SweepWidthTD2 = QmatNMR.SWTD2;']);
            eval([QTEMP9 '.SpectralFrequencyTD2 = QmatNMR.SFTD2;']);
            eval([QTEMP9 '.SweepWidthTD1 = QmatNMR.SWTD1;']);
            eval([QTEMP9 '.SpectralFrequencyTD1 = QmatNMR.SFTD1;']);
  
            QTEMP4 = size(QmatNMR.Spec2D3D);
            if ~ (all(QmatNMR.Axis2D3DTD2 == (1:QTEMP4(2))) & all(QmatNMR.Axis2D3DTD1 == (1:QTEMP4(1))))
              eval([QTEMP9 '.AxisTD1 = QmatNMR.Axis2D3DTD1;']);
              eval([QTEMP9 '.AxisTD2 = QmatNMR.Axis2D3DTD2;']);
            else	
              eval([QTEMP9 '.AxisTD1 = [];']);
              eval([QTEMP9 '.AxisTD2 = [];']);
            end  
        
            disp(['Peak list was saved in data structure (' QTEMP9 ' has been converted!!)']);
          else  
            disp('matNMR WARNING:   Cannot make a data structure from the current spectrum name!');
          end;  
        end
    
      else
  					%If the peak list is empty the peak list in the structure
  					%is cleared. If there is no structure an error will be
  					%displayed
        if (isa(eval(QTEMP9), 'struct'))
          eval([QTEMP9 '.PeakListNums = [];']);
          eval([QTEMP9 '.PeakListText = [];']);
          eval([QTEMP9 '.AxisTD1 = [];']);
          eval([QTEMP9 '.AxisTD2 = [];']);
      
          disp('Peak List removed from data structure');
        else
          disp('There is no peak list to save!');
        end  
      end
  
    else
      error('matNMR error: peak list not saved due to unallowed name for variable!')
    end
    
  else
    disp('Saving of peak list in a structure was cancelled....');
  end  
    
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
