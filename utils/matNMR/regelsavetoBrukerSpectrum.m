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
%regelsavetoBrukerSpectrum saves the current 1D or 2D spectrum as Bruker spectrum to disk
%
%26-11-'08

try
  if QmatNMR.buttonList == 1		%OK-button
    %
    %The file name entered in the input window
    %
    QmatNMR.BrukerSpectrumName = QmatNMR.uiInput1;
  
    if (QmatNMR.Dim == 0)
      %
      %1D dataset
      %
      QmatNMR.NucleusTD2 = QmatNMR.uiInput3;
  
      
      %
      %make directory with the given name and create the appropriate substructure for Bruker
      %data (pdata/1 as processed data)
      %
      [QTEMP1, QTEMP2, QTEMP3] = mkdir(QmatNMR.uiInput2, QmatNMR.BrukerSpectrumName);
      if ((QTEMP1 == 0) & ~exist([QmatNMR.uiInput2 filesep QmatNMR.BrukerSpectrumName], 'dir'))
        beep
        disp('matNMR WARNING: cannot make the dataset. Please check name and path again. Aborting ...');
        return
      end
      
      [QTEMP1, QTEMP2, QTEMP3] = mkdir([QmatNMR.uiInput2 filesep QmatNMR.BrukerSpectrumName], 'pdata');
      if ((QTEMP1 == 0) & ~exist([QmatNMR.uiInput2 filesep QmatNMR.BrukerSpectrumName filesep 'pdata'], 'dir'))
        beep
        disp('matNMR WARNING: cannot make the pdata directory in the dataset. Please check name and path again. Aborting ...');
        return
      end
      
      [QTEMP1, QTEMP2, QTEMP3] = mkdir([QmatNMR.uiInput2 filesep QmatNMR.BrukerSpectrumName filesep 'pdata'], '1');
      if ((QTEMP1 == 0) & ~exist([QmatNMR.uiInput2 filesep QmatNMR.BrukerSpectrumName filesep 'pdata' filesep '1'], 'dir'))
        beep
        disp('matNMR WARNING: cannot make the pdata/1 directory in the dataset. Please check name and path again. Aborting ...');
        return
      end
      
      
      %
      %make the acqus and acqu2s parameter files
      %
      fp = fopen([QmatNMR.uiInput2 filesep QmatNMR.BrukerSpectrumName filesep 'acqus'], 'w');
      fprintf(fp, '##$NUC1= <%s>\n', QmatNMR.NucleusTD2);
      fprintf(fp, '##$SFO1= %f\n', QmatNMR.SFTD2);
      fclose(fp);
      
      
      %
      %make the procs and proc2s parameter files
      %
      fp = fopen([QmatNMR.uiInput2 filesep QmatNMR.BrukerSpectrumName filesep 'pdata' filesep '1' filesep 'procs'], 'w');
      fprintf(fp, '##$BYTORDP= 0\n'); 					%write as little endian format
      fprintf(fp, '##$XDIM= %d\n', QmatNMR.SizeTD2);
      fprintf(fp, '##$SI= %d\n', QmatNMR.SizeTD2);
      fprintf(fp, '##$SW_p= %f\n', QmatNMR.SWTD2*1000);
      fprintf(fp, '##$OFFSET= %f\n', QmatNMR.AxisTD2(end));
      fclose(fp);
      
      
      %
      %store the 1r part of the dataset. We protect the data from rounding errors by setting the maximum to 1e6 when the
      %maximum value is less than 1e6.
      %
      QTEMP1 = fliplr(real(QmatNMR.Spec1D));
      if (max(QTEMP1) < 1e6)
        if (max(QTEMP1) > eps)
          beep
          disp('matNMR NOTICE: Only 32-bit integers are stored in the Bruker format. This data requires scaling');
          disp(['matNMR NOTICE: to avoid loss of numerical accuracy. The spectrum was multiplied by ' num2str(1e6/max(QTEMP1), 10)]);
          QTEMP1 = QTEMP1*1e6/max(QTEMP1);
        else
          beep
          disp('matNMR NOTICE: Only 32-bit integers are stored in the Bruker format. This data requires scaling');
          disp(['matNMR NOTICE: but the highest value of the spectrum is less than ' num2str(eps) '. Refusing to act']);
        end
      end
  
      fp = fopen([QmatNMR.uiInput2 filesep QmatNMR.BrukerSpectrumName filesep 'pdata' filesep '1' filesep '1r'], 'w', 'l');
      fwrite(fp, QTEMP1, 'int32');
      fclose(fp);
  
    else
      %
      %2D dataset
      %
      QmatNMR.NucleusTD2 = QmatNMR.uiInput3;
      QmatNMR.NucleusTD1 = QmatNMR.uiInput4;
      
      
      %
      %Determine the blocking factors
      %
      if (log2(QmatNMR.SizeTD1) ~= round(log2(QmatNMR.SizeTD1)))
        beep
        disp('matNMR WARNING: size of TD1 not a power of 2. Aborting export as Bruker spectrum ...');
        return
      end
      if (QmatNMR.SizeTD1 > 128)
        QmatNMR.BrukerSpectrumBlockingTD1 = 128;
      else
        QmatNMR.BrukerSpectrumBlockingTD1 = QmatNMR.SizeTD1;
      end
  
      if (log2(QmatNMR.SizeTD2) ~= round(log2(QmatNMR.SizeTD2)))
        beep
        disp('matNMR WARNING: size of TD2 not a power of 2. Aborting export as Bruker spectrum ...');
        return
      end
      if (QmatNMR.SizeTD2 > 1024)
        QmatNMR.BrukerSpectrumBlockingTD2 = 1024;
      else
        QmatNMR.BrukerSpectrumBlockingTD2 = QmatNMR.SizeTD2;
      end
  
      
      %
      %make directory with the given name and create the appropriate substructure for Bruker
      %data (pdata/1 as processed data)
      %
      [QTEMP1, QTEMP2, QTEMP3] = mkdir(QmatNMR.uiInput2, QmatNMR.BrukerSpectrumName);
      if ((QTEMP1 == 0) & ~exist([QmatNMR.uiInput2 filesep QmatNMR.BrukerSpectrumName], 'dir'))
        beep
        disp('matNMR WARNING: cannot make the dataset. Please check name and path again. Aborting ...');
        return
      end
      
      [QTEMP1, QTEMP2, QTEMP3] = mkdir([QmatNMR.uiInput2 filesep QmatNMR.BrukerSpectrumName], 'pdata');
      if ((QTEMP1 == 0) & ~exist([QmatNMR.uiInput2 filesep QmatNMR.BrukerSpectrumName filesep 'pdata'], 'dir'))
        beep
        disp('matNMR WARNING: cannot make the pdata directory in the dataset. Please check name and path again. Aborting ...');
        return
      end
      
      [QTEMP1, QTEMP2, QTEMP3] = mkdir([QmatNMR.uiInput2 filesep QmatNMR.BrukerSpectrumName filesep 'pdata'], '1');
      if ((QTEMP1 == 0) & ~exist([QmatNMR.uiInput2 filesep QmatNMR.BrukerSpectrumName filesep 'pdata' filesep '1'], 'dir'))
        beep
        disp('matNMR WARNING: cannot make the pdata/1 directory in the dataset. Please check name and path again. Aborting ...');
        return
      end
      
      
      %
      %make the acqus and acqu2s parameter files
      %
      fp = fopen([QmatNMR.uiInput2 filesep QmatNMR.BrukerSpectrumName filesep 'acqus'], 'w');
      fprintf(fp, '##$NUC1= <%s>\n', QmatNMR.NucleusTD2);
      fprintf(fp, '##$SFO1= %f\n', QmatNMR.SFTD2);
      fprintf(fp, '##$SW_h= %f\n', QmatNMR.SWTD2*1000);
      fclose(fp);
      
      fp = fopen([QmatNMR.uiInput2 filesep QmatNMR.BrukerSpectrumName filesep 'acqu2s'], 'w');
      fprintf(fp, '##$NUC1= <%s>\n', QmatNMR.NucleusTD1);
      fprintf(fp, '##$SFO1= %f\n', QmatNMR.SFTD1);
      fprintf(fp, '##$SW_h= %f\n', QmatNMR.SWTD1*1000);
      fclose(fp);
      
      
      %
      %make the procs and proc2s parameter files
      %
      fp = fopen([QmatNMR.uiInput2 filesep QmatNMR.BrukerSpectrumName filesep 'pdata' filesep '1' filesep 'procs'], 'w');
      fprintf(fp, '##$BYTORDP= 0\n'); 					%write as little endian format
      fprintf(fp, '##$XDIM= %d\n', QmatNMR.BrukerSpectrumBlockingTD2);
      fprintf(fp, '##$SI= %d\n', QmatNMR.SizeTD2);
      fprintf(fp, '##$SW_p= %f\n', QmatNMR.SWTD2*1000);
      fprintf(fp, '##$OFFSET= %f\n', QmatNMR.AxisTD2(end));
      fclose(fp);
      
      fp = fopen([QmatNMR.uiInput2 filesep QmatNMR.BrukerSpectrumName filesep 'pdata' filesep '1' filesep 'proc2s'], 'w');
      fprintf(fp, '##$XDIM= %d\n', QmatNMR.BrukerSpectrumBlockingTD1);
      fprintf(fp, '##$SI= %d\n', QmatNMR.SizeTD1);
      fprintf(fp, '##$SW_p= %f\n', QmatNMR.SWTD1*1000);
      fprintf(fp, '##$OFFSET= %f\n', QmatNMR.AxisTD1(end));
      fprintf(fp, '##$REVERSE= 0\n');
      fprintf(fp, '##$FT_mod= %f\n', ~(QmatNMR.FIDstatus2D2-1));
      fclose(fp);
      
      
      %
      %store the 2rr part of the dataset
      %We protect the data from rounding errors by setting the maximum to 1e6 when the maximum value is less than 1e6.
      %
      fp = fopen([QmatNMR.uiInput2 filesep QmatNMR.BrukerSpectrumName filesep 'pdata' filesep '1' filesep '2rr'], 'w', 'l');
  
      QTEMP3 = QmatNMR.SizeTD1 / QmatNMR.BrukerSpectrumBlockingTD1;
      QTEMP4 = QmatNMR.SizeTD2 / QmatNMR.BrukerSpectrumBlockingTD2;
      QTEMP1 = fliplr(flipud(real(QmatNMR.Spec2D)));
      if (max(max(QTEMP1)) < 1e6)
        if (max(max(QTEMP1)) > eps)
          beep
          disp('matNMR NOTICE: Only 32-bit integers are stored in the Bruker format. This data requires scaling');
          disp(['matNMR NOTICE: to avoid loss of numerical accuracy. The spectrum was multiplied by ' num2str(1e6/max(max(QTEMP1)), 10)]);
          QTEMP1 = QTEMP1*1e6/max(max(QTEMP1));
        else
          beep
          disp('matNMR NOTICE: Only 32-bit integers are stored in the Bruker format. This data requires scaling');
          disp(['matNMR NOTICE: but the highest value of the spectrum is less than ' num2str(eps) '. Refusing to act']);
        end
      end
  
      for QTEMP5=1:QTEMP3
        for QTEMP6=1:QTEMP4
          for QTEMP7=1:QmatNMR.BrukerSpectrumBlockingTD1
            fwrite(fp, QTEMP1((QTEMP5-1)*QmatNMR.BrukerSpectrumBlockingTD1+QTEMP7, (QTEMP6-1)*QmatNMR.BrukerSpectrumBlockingTD2+(1:QmatNMR.BrukerSpectrumBlockingTD2)), 'int32');
          end
        end
      end
      fclose(fp);
    end
  
  else
    disp('Saving of current spectrum to disk as a Bruker spectrum cancelled ...');
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
