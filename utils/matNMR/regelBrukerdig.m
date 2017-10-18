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
%regelBrukerdig.m takes care of removing the effects of the Bruker digital filter from
%the FID, both 1D and 2D. As the digital filter shifts the FID in time the FID is first
%Fourier transformed. Then a first orde phase correction of n*360 degrees is done where
%n is the number of dwell points the FID has been shifted in time. After that an inverse
%Fourier transform gives the FID back.
%
% For older versions of the Bruker hardware:
%
% A nice piece was found on the internet on how to calculate the number of points
% semi-automatically. Note that currently matNMR doesn't allow for the necessary
% negative-time apodization.
%
%
%    W. M. Westler and F.  Abildgaard
%    July 16, 1996
%
%    The introduction of digital signal processing by Bruker in their DMX
%    consoles also introduced an unusual feature associated with the data. The
%    stored FID no longer starts at its maximum followed by a decay, but is
%    prepended with an increasing signal that starts from zero at the
%    first data point and rises to a maximum after several tens of data points.
%    On transferring this data to a non-Bruker processing program such as FELIX,
%    which is used at NMRFAM, the Fourier transform leads to an unusable spectrum
%    filled with wiggles. Processing the same data with Bruker's Uxnmr
%    program yields a correct spectrum. Bruker has been rather reluctant
%    to describe what tricks are implemented during their processing protocol.
%
%    They suggest the data should be first transformed in Uxnmr and then inverse
%    transformed, along with a GENFID command, before shipping the data to another
%    program. Bruker now supplies a piece of software to convert the digitally
%    filtered data to the equivalent analog form.
%    We find it unfortunate that the vendor has decided to complicate
%    the simple task of Fourier transformation. We find that the procedure
%    suggested by Bruker is cumbersome, and more so, we are irritated since
%    we are forced to use data that has been treated with an unknown procedure.
%    Since we do not know any details of Bruker's digital filtration procedure
%    or the "magic" conversion routine that is used in Uxnmr, we have been forced
%    into observation and speculation. We have found a very simple, empirical
%    procedure that leads to spectra processed in FELIX that are identical,
%    within the noise limits, to spectra processed with Uxnmr. We deposit
%    this information here in the hope that it can be of some
%    use to the general community.
%    The application of a nonrecursive (or recursive) digital filter to time
%    domain data is accomplished by performing a weighted running average of
%    nearby data points. A problem is encountered at the beginning of
%    the data where, due to causality, there are no prior values. The
%    weighted average of the first few points, therefore, must include data
%    from "negative" time. One naive procedure, probably appropriate to NMR
%    data, is to supply values for negative time points is to pad the data with
%    zeros. Adding zeros (or any other data values) to the beginning of
%    the FID, however, shifts the beginning of the time domain data (FID) to
%    a later positive time. It is well known that a shift in the time
%    domain data is equivalent to the application of a frequency-dependent,
%    linear phase shift in the frequency domain. The 1st order phase shift
%    corresponding to a time shift of a single complex dwell point is 360 degrees
%    across the spectral width. The typical number of prepended points
%    found in DMX digitally filtered data is about 60 data points (see below),
%
%    the corresponding 1st order phase correction is ~21,000 degrees.
%    This large linear phase correction can be applied to the transformed data
%    to obtain a normal spectrum. Another, equivalent approach is to time
%    shift the data back to its original position. This results in the need
%    of only a small linear phase shift on the transformed data.
%    There is a question as what to do with the data preceding the actual
%    FID. The prepended data can be simply eliminated with the addition
%    of an equal number of zeros at the end of the FID (left shift). This
%    procedure, however, introduces "frowns" (some have a preference to refer
%    to these as "smiles") at the edge of the spectrum. If the sweep
%    width is fairly wide this does not generally cause a problem. The
%    (proper) alternative is to retain this data by applying a circular left
%    shift of the data, moving the first 60 or so points (see recommendations
%    below) to the end of the FID. This is identical to a Fourier transformation
%    followed by the large linear phase correction mentioned above. The
%    resulting FID is periodic with the last of the data rising to meet the
%    first data point (in the next period). Fourier transform of this
%    data results in an approximately phased spectrum. Further linear
%    phase corrections of up to 180 degrees are necessary. A zero fill applied
%    after a circular shift of the data will cause a discontinuity and thus
%    introduce sinc wiggles on the peaks. The usual correction for DC
%    offset and apodization of the data, if not done correctly, also results
%    in the frowns at the edges of the spectrum.
%
%    In our previous document on Bruker digital filters, we presented deduced
%    rules for calculating the appropriate number of points to be circular left
%    shifted. However, since then, newer versions of hardware (DQmatNMR.D) and software
%    has introduced a new set of values. Depending on the firmware versions
%    (DSPFVS) and the decimation rate (DECIM), the following lookup table will
%    give the circular shift values needed to correct the DMX data. The values
%    of DECIM and DSPFVS can be found in the acqus file in the directory containing
%    the data.
%
%     DECIM           DSPFVS 10       DSPFVS 11      DSPFVS 12
%
%       2              44.7500         46.0000        46.311
%       3              33.5000         36.5000        36.530
%       4              66.6250         48.0000        47.870
%       6              59.0833         50.1667        50.229
%       8              68.5625         53.2500        53.289
%      12              60.3750         69.5000        69.551
%      16              69.5313         72.2500        71.600
%      24              61.0208         70.1667        70.184
%      32              70.0156         72.7500        72.138
%      48              61.3438         70.5000        70.528
%      64              70.2578         73.0000        72.348
%      96              61.5052         70.6667        70.700
%     128              70.3789         72.5000        72.524
%     192              61.5859         71.3333
%     256              70.4395         72.2500
%     384              61.6263         71.6667
%     512              70.4697         72.1250
%     768              61.6465         71.8333
%    1024              70.4849         72.0625
%    1536              61.6566         71.9167
%    2048              70.4924         72.0313
%
%
%    The number of points obtained from the table are usually not integers.  The appropriate procedure is to circular shift (see protocol for details) by the integer obtained from truncation of the obtained value and then the residual 1st order phase shift that needs to be applied can be obtained by multiplying the decimal portion of the calculated number of points by 360.
%
%    For example,
%
%    If DECIM = 32, and DSPFVS = 10,
%    then #points 70.0156
%
%    The circular shift performed on the data should be 70 complex points and the linear
%    phase correction after Fourier transformation is approximately 0.0156*360= 5.62 degrees.
%
%    Protocol:
%
%       1. Circular shift (rotate) the appropriate number of points in the data indicated by
%       the  DECIM parameter. (see above formulae).
%
%       2. After the circular shift, resize the data to the original size minus
%       the number of shifted points. This will leave only the part of the
%       data that looks like an FID. Baseline correction (BC) and/or apodization
%       (EM etc.) should be applied only on this data, otherwise "In come the frowns."
%
%       Since the first part of the data (the points that are shifted) represents
%       negative time, a correct apodization would also multiply the shifted points
%       by a negative time apodization. The data size is now returned to
%       its original size to reincorporate the shifted points. There may
%       still be a discontinuity between the FID portion and the shifted points
%       if thelast point of the FID portion is not at zero. This will cause
%       sinc wiggles in the peaks.
%
%       3. Applying a zero fill to this data will lead to a discontinuity in the data
%       between the rising portion of the shifted points and the zero padding.
%       To circumvent this problem, the shifted points are returned (by circular
%       shift) to the front of the data, the data is zero filled, and then the
%       first points are shifted again to the end of the zero filled data.
%
%       4) The data can now be Fourier transformed and the residual calculated
%       1st order phase correction can be applied.
%
%
%
% For newer versions of the Bruker hardware:
%
%     For firmware versions of 20 <= DSPFVS <= 23 the GRPDLY parameter directly shows the number of
%     points that need to be shifted.
%
%     Thanks for Bruker for supplying this information!
%
%
%
%26-09-'00

try
  if (QmatNMR.buttonList == 2)		%automatic determination
    %
    %we try to use the original datapath of the variable and see whether a Bruker acqus file exists in that directory
    %
    if (QmatNMR.Dim == 0) 	%1D dataset
      QTEMP1 = QmatNMR.DataPath1D;
    else 				%2D dataset
      QTEMP1 = QmatNMR.DataPath2D;
    end
    
    if exist([QTEMP1 filesep 'acqus'], 'file')
      QTEMP2 = QTEMP1;
      QmatNMR.Xfilename2 = 'acqus';
      disp(['Using ' QTEMP1 filesep 'acqus for extracting the information about the digital filter']);
  
    else
      %
      %apparantly no so we force the user to specify the correct acqus files which belongs to the current
      %dataset
      %
      disp(['"acqus" file not found in the dataset''s directory ' QTEMP1 '. Reverting to manual input']);
  
      QmatNMR.Xfilename2 = 0;
      QmatNMR.Xtext = '';
      [QmatNMR.Xfilename2, QmatNMR.Xpath] = uigetfile([pwd filesep '*.*'], 'Select "acqus" File for this dataset');
      QTEMP2 = QmatNMR.Xpath;
    end
  
    %
    %when the user has cancelled this menu then the QmatNMR.Xfilename2 variable will be 0, otherwise it
    %will be a filename
    %
    if (QmatNMR.Xfilename2 ~= 0)
      QTEMP1 = DetermineBrukerDigitalFilter([QTEMP2 QmatNMR.Xfilename2]);
      if isempty(QTEMP1) 		%empty means that we couldn't determine the value from the dataset
    				%and an appropriate message was given in the console window.
  				%we go back to the input window
        askBrukerdig
        return
  
      else
        QmatNMR.uiInput1 = num2str(QTEMP1, 10);
      end
  
    else
      disp('Removing of digital filter from the FID cancelled ...');
      return
    end
  end
  
  
  %
  %now continue with the correction
  %
  if ((QmatNMR.buttonList == 1) | (QmatNMR.buttonList == 2))
    watch;
  
    if (QmatNMR.SwitchTo1D) 		%switch from 2D to 1D processing if necessary
      SwitchTo1D
    end
  
    %
    %create entry in the undo matrix
    %
    regelUNDO
  
    QmatNMR.NrDigitalFilter = eval(QmatNMR.uiInput1);
  
    if (QmatNMR.NrDigitalFilter == 0)
      disp('Removing of digital filter from the FID cancelled ...');
      return
    end
  
    QmatNMR.howFT = get(QmatNMR.Four, 'value');		%determine the type of fourier transform currently selected
  
    if (QmatNMR.Dim == 0)			%act on a 1D FID
      QmatNMR.Spec1D = fliplr(fftshift(fft(QmatNMR.Spec1D)));
      QmatNMR.z = ((1:QmatNMR.Size1D)/(QmatNMR.Size1D));
      Qi = sqrt(-1);
      QmatNMR.Spec1D = QmatNMR.Spec1D .* exp(-Qi*(QmatNMR.NrDigitalFilter*2*pi*QmatNMR.z));
      QmatNMR.Spec1D = ifft(fftshift(fliplr(QmatNMR.Spec1D)));
  
    else					%2D FID
      QmatNMR.z = ((1:QmatNMR.Size1D)/(QmatNMR.Size1D));
      Qi = sqrt(-1);
      QTEMP = fliplr(fftshift(exp(-Qi*(QmatNMR.NrDigitalFilter*2*pi*QmatNMR.z))));
  
      if ((QmatNMR.howFT == 3) | (QmatNMR.howFT == 6)) 	%States or States-TPPI
        for QTEMP40=1:QmatNMR.SizeTD1
          QmatNMR.Spec2D(QTEMP40, :) = ifft(QTEMP.*fft(QmatNMR.Spec2D(QTEMP40, :)));
          QmatNMR.Spec2Dhc(QTEMP40, :) = ifft(QTEMP.*fft(QmatNMR.Spec2Dhc(QTEMP40, :)));
        end
  
      else			      %no states
        for QTEMP40=1:QmatNMR.SizeTD1
          QmatNMR.Spec2D(QTEMP40, :) = ifft(QTEMP.*fft(QmatNMR.Spec2D(QTEMP40, :)));
        end
      end
  
     getcurrentspectrum	      %get spectrum to show on the screen
  
    end
  
    disp(['Bruker digital filter removed (' num2str(QmatNMR.NrDigitalFilter, 10) ' points) ...']);
    if (QmatNMR.Dim > 0)			%2D FID
      QmatNMR.History = str2mat(QmatNMR.History, ['Bruker digital filter removed (' num2str(QmatNMR.NrDigitalFilter, 10) ' points) ...']);
  
      %first add dimension-specific information, and then the current command
      if (QmatNMR.Dim == 1) 	%TD2
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
  
      else
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
        QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
      end
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 122, QmatNMR.NrDigitalFilter, QmatNMR.howFT, QmatNMR.Dim);  %code for left shift, nr of points to shift, FT mode, dimension
  
      if QmatNMR.RecordingMacro
        %first add dimension-specific information, and then the current command
        if (QmatNMR.Dim == 1) 	%TD2
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
  
        else
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 1, QmatNMR.SWTD2, QmatNMR.SFTD2, QmatNMR.gamma1, QmatNMR.FIDstatus2D1, QmatNMR.RulerXAxis1, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.rijnr, QmatNMR.four2);
          QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 2, QmatNMR.SWTD1, QmatNMR.SFTD1, QmatNMR.gamma2, QmatNMR.FIDstatus2D2, QmatNMR.RulerXAxis2, QmatNMRsettings.DefaultRulerXAxis2TIME, QmatNMRsettings.DefaultRulerXAxis2FREQ, QmatNMR.kolomnr, QmatNMR.four1);
        end
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 122, QmatNMR.NrDigitalFilter, QmatNMR.howFT, QmatNMR.Dim); 	%code for left shift, nr of points to shift, FT mode, dimension
      end
  
    else					%1D FID
      QmatNMR.History = str2mat(QmatNMR.History, ['Bruker digital filter removed (' num2str(QmatNMR.NrDigitalFilter, 10) ' points) ...']);
  
      %first add dimension-specific information, and then the current command
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
      QmatNMR.HistoryMacro = AddToMacro(QmatNMR.HistoryMacro, 16, QmatNMR.NrDigitalFilter, QmatNMR.howFT); 	%code for remove Bruker digital filter, nr of points, FT mode
  
      if QmatNMR.RecordingMacro
        %first add dimension-specific information, and then the current command
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 400, 0, QmatNMR.SW1D, QmatNMR.SF1D, QmatNMR.gamma1d, QmatNMR.FIDstatus, QmatNMR.RulerXAxis, QmatNMRsettings.DefaultRulerXAxis1TIME, QmatNMRsettings.DefaultRulerXAxis1FREQ, QmatNMR.four2);
        QmatNMR.Macro = AddToMacro(QmatNMR.Macro, 16, QmatNMR.NrDigitalFilter, QmatNMR.howFT); 	%code for left shift, nr of points to shift, FT mode
      end
    end;
  
    if (~QmatNMR.BusyWithMacro)
      asaanpas
      Arrowhead;
    end
  
  else
    disp('Removing of digital filter from the FID cancelled ...');
    QmatNMR.SwitchTo1D = 0;	%reset flag because it is possible that the user came from a 2D but cancelled the action
  end
  
  clear QTEMP* Qi

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
