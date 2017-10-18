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
%regelsavetoSimpsonASCII saves the current 1D or 2D spectrum/FID as SIMPSON ASCII to disk
%
%03-06-'04

try
  if QmatNMR.buttonList == 1		%OK-button
    %
    %The file name entered in the input window
    %
    QmatNMR.SimpsonASCIIName = QmatNMR.uiInput1;
  
  
    %
    %Check for an extension in the file name. If it is .spe or .fid AND this is in accordance with
    %the current FIDstatus then nothing is done; otherwise the correct extension is added.
    %
    QTEMP1 = findstr(QmatNMR.SimpsonASCIIName, '.');
    if QTEMP1
      %
      %there is an extension present. Let's attempt to check whether it conforms with what
      %SIMPSON expects.
      %
      if (QTEMP1 == length(QmatNMR.SimpsonASCIIName)-3)	%is the extension 3 characters long?
        QTEMP1 = QmatNMR.SimpsonASCIIName(length(QmatNMR.SimpsonASCIIName)-3:end);
        if strcmp(QTEMP1, '.spe') | strcmp(QTEMP1, '.SPE')
          QTEMP9 = '';	%we don't add an additional extension
          if (QmatNMR.Dim == 0)		%1D mode
            if (QmatNMR.FIDstatus == 1)		%spectrum
  	  else
              disp('matNMR NOTICE: extension for spectrum in file name even though dealing with FID. Extension corrected!');
              QmatNMR.SimpsonASCIIName = [QmatNMR.SimpsonASCIIName(1:length(QmatNMR.SimpsonASCIIName)-4) '.fid'];
            end
  
          else
            if ((QmatNMR.FIDstatus2D1 == 2) & (QmatNMR.FIDstatus2D2 == 2))	%FID in both dimensions
              disp('matNMR NOTICE: extension for spectrum in file name even though dealing with FID. Extension corrected!');
              QmatNMR.SimpsonASCIIName = [QmatNMR.SimpsonASCIIName(1:length(QmatNMR.SimpsonASCIIName)-4) '.fid'];
            end
          end
  
        elseif strcmp(QTEMP1, '.fid') | strcmp(QTEMP1, '.FID')
          QTEMP9 = '';	%we don't add an additional extension
          if (QmatNMR.Dim == 0)		%1D mode
            if (QmatNMR.FIDstatus == 1)		%spectrum
              disp('matNMR NOTICE: extension for FID in file name even though dealing with spectrum. Extension corrected!');
              QmatNMR.SimpsonASCIIName = [QmatNMR.SimpsonASCIIName(1:length(QmatNMR.SimpsonASCIIName)-4) '.spe'];
            end
  
          else
            if ((QmatNMR.FIDstatus2D1 == 2) & (QmatNMR.FIDstatus2D2 == 2))	%FID in both dimensions
            else
              disp('matNMR NOTICE: extension for FID in file name even though dealing with spectrum. Extension corrected!');
              QmatNMR.SimpsonASCIIName = [QmatNMR.SimpsonASCIIName(1:length(QmatNMR.SimpsonASCIIName)-4) '.spe'];
            end
          end
  
        else
          disp('matNMR NOTICE: extension suspected in file name, but wasn''t recognized. No extension added!');
        end
  
      else	%NO, then we just add the extension
        disp('matNMR NOTICE: extension suspected in file name, but wasn''t recognized. No extension added!');
      end
  
    else		%no extension present in the specified file name
      if (QmatNMR.Dim == 0)		%1D mode
        if (QmatNMR.FIDstatus == 1)		%spectrum
          QTEMP9 = '.spe';
        else
          QTEMP9 = '.fid';
        end
  
      else
        if ((QmatNMR.FIDstatus2D1 == 2) & (QmatNMR.FIDstatus2D2 == 2))	%FID in both dimensions
          QTEMP9 = '.fid';
        else
          QTEMP9 = '.spe';
        end
      end
    end
  
  
    %
    %Save to disk in SIMPSON format
    %distinguish between 1D and 2D mode
    %
    if (QmatNMR.Dim == 0) 		%1D mode
      %
      %Open file for writing
      %
      QmatNMR.fid = fopen([QmatNMR.uiInput2 filesep QmatNMR.SimpsonASCIIName QTEMP9], 'w');
      if (QmatNMR.fid == -1)
        disp('matNMR WARNING: file could not be opened. Is the path correct?');
        disp('matNMR WARNING: Saving to SIMPSON ASCII aborted ...');
      end
  
      fprintf(QmatNMR.fid,'SIMP\n');
      fprintf(QmatNMR.fid,'NP=%g\n',QmatNMR.Size1D);
      fprintf(QmatNMR.fid,'SW=%g\n',QmatNMR.SW1D*1000);
      if (QmatNMR.FIDstatus == 1)
        fprintf(QmatNMR.fid,'TYPE=SPE\n');
      else
        fprintf(QmatNMR.fid,'TYPE=FID\n');
      end
      fprintf(QmatNMR.fid,'DATA\n');
  
      %
      %reshuffle the data to allow fast saving and write to file
      %
      QTEMP2 = zeros(1, 2*QmatNMR.Size1D);
      QTEMP2(1:2:2*QmatNMR.Size1D) = real(QmatNMR.Spec1DPlot);
      QTEMP2(2:2:2*QmatNMR.Size1D) = imag(QmatNMR.Spec1DPlot);
      fprintf(QmatNMR.fid,'%10.8e    %10.8e\n',QTEMP2);
      fprintf(QmatNMR.fid,'END');
  
      fclose(QmatNMR.fid);
  
      disp('Finished saving current 1D spectrum to disk in Simpson ASCII format.')
  
    else				%2D mode
      %
      %Open file for writing
      %
      QmatNMR.fid = fopen([QmatNMR.uiInput2 filesep QmatNMR.SimpsonASCIIName QTEMP9], 'w');
      if (QmatNMR.fid == -1)
        disp('matNMR WARNING: file could not be opened. Is the path correct?');
        disp('matNMR WARNING: Saving to SIMPSON ASCII aborted ...');
      end
  
      fprintf(QmatNMR.fid,'SIMP\n');
      fprintf(QmatNMR.fid,'NP=%g\n',QmatNMR.SizeTD2);
      fprintf(QmatNMR.fid,'SW=%g\n',QmatNMR.SWTD2*1000);
      fprintf(QmatNMR.fid,'NI=%g\n',QmatNMR.SizeTD1);
      fprintf(QmatNMR.fid,'SW1=%g\n',QmatNMR.SWTD1*1000);
  
      if ((QmatNMR.FIDstatus2D1 == 1) & (QmatNMR.FIDstatus2D2 == 1))		%spectrum in both dimensions
        fprintf(QmatNMR.fid,'TYPE=SPE\n');
      elseif ((QmatNMR.FIDstatus2D1 == 2) & (QmatNMR.FIDstatus2D2 == 2))	%FID in both dimensions
        fprintf(QmatNMR.fid,'TYPE=FID\n');
      else							%mixed FID/spectrum --> give notice
        fprintf(QmatNMR.fid,'TYPE=SPE\n');
        disp('matNMR NOTICE: the current 2D matrix is a mixture of spectrum/FID but will be saved as a spectrum!');
      end
      fprintf(QmatNMR.fid,'DATA\n');
  
      if (QmatNMR.HyperComplex)
        disp('matNMR NOTICE: the SIMPSON format does not allow hypercomplex matrices, only QmatNMR.Spec2D stored in file.');
      end
  
      %
      %reshuffle the data to allow fast saving and write to file
      %
      QTEMP2 = zeros(1, 2*QmatNMR.SizeTD2);
      for QTEMP1=1:QmatNMR.SizeTD1
        QTEMP2(1:2:2*QmatNMR.SizeTD2) = real(QmatNMR.Spec2D(QTEMP1, :));
        QTEMP2(2:2:2*QmatNMR.SizeTD2) = imag(QmatNMR.Spec2D(QTEMP1, :));
        fprintf(QmatNMR.fid,'%10.8e    %10.8e\n',QTEMP2);
      end
      fprintf(QmatNMR.fid,'END');
  
      fclose(QmatNMR.fid);
  
      disp('Finished saving current 2D spectrum to disk in Simpson ASCII format.')
  
    end
  
  else
    disp('Saving of current spectrum to disk in SIMPSON ASCII format cancelled ...');
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
