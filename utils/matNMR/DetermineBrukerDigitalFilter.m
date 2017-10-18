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
%DetermineBrukerDigitalFilter reads in a Bruker acqus file and tries to determine
%how many points need to be circularly shifted in order to remove the effects of
%the digital filter.
%
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
%30-07-'04
%11-04-'06

function NrPointsToShift = DetermineBrukerDigitalFilter(FileName)

  NrPointsToShift  = [];
  
  %read in the acqus file
  QTEMP1 = ReadParameterFile(FileName);
  
  %check whether the digital filter was used in this dataset
  eval([QTEMP1(strmatch('DIGMOD=', QTEMP1), :) ';']);
  if (DIGMOD == 0)
    %
    %the digital filter wasn't used in the appointed dataset and so we revert 
    %back to the input window
    %
    disp('DetermineBrukerDigitalFilter WARNING: no digital filter was used in the appointed dataset! Refusing to act.');
    return
    
  else
    %read in DECIM and DSPFVS
    eval([QTEMP1(strmatch('DECIM=', QTEMP1), :) ';']);
    eval([QTEMP1(strmatch('DSPFVS=', QTEMP1), :) ';']);
    
    switch (DSPFVS)
      case 10
        switch (DECIM)
	  case 2
	    NrPointsToShift = 44.7500;
	  case 3
	    NrPointsToShift = 33.5000;
	  case 4
	    NrPointsToShift = 66.6250;
	  case 6
	    NrPointsToShift = 59.0833;
	  case 8
	    NrPointsToShift = 68.5625;
	  case 12
	    NrPointsToShift = 60.3750;
	  case 16
	    NrPointsToShift = 69.5313;
	  case 24
	    NrPointsToShift = 61.0208;
	  case 32
	    NrPointsToShift = 70.0156;
	  case 48
	    NrPointsToShift = 61.3438;
	  case 64
	    NrPointsToShift = 70.2578;
	  case 96
	    NrPointsToShift = 61.5052;
	  case 128
	    NrPointsToShift = 70.3789;
	  case 192
	    NrPointsToShift = 61.5859;
	  case 256
	    NrPointsToShift = 70.4395;
	  case 384
	    NrPointsToShift = 61.6263;
	  case 512
	    NrPointsToShift = 70.4697;
	  case 768
	    NrPointsToShift = 61.6465;
	  case 1024
	    NrPointsToShift = 70.4849;
	  case 1536
	    NrPointsToShift = 61.6566;
	  case 2048
	    NrPointsToShift = 70.4924;
	  otherwise
	    disp('DetermineBrukerDigitalFilter ERROR: code for DECIM not recognized. Aborting ...');
        end

      case 11
        switch (DECIM)
	  case 2
	    NrPointsToShift = 46.0000;
	  case 3
	    NrPointsToShift = 36.5000;
	  case 4
	    NrPointsToShift = 48.0000;
	  case 6
	    NrPointsToShift = 50.1667;
	  case 8
	    NrPointsToShift = 53.2500;
	  case 12
	    NrPointsToShift = 69.5000;
	  case 16
	    NrPointsToShift = 72.2500;
	  case 24
	    NrPointsToShift = 70.1667;
	  case 32
	    NrPointsToShift = 72.7500;
	  case 48
	    NrPointsToShift = 70.5000;
	  case 64
	    NrPointsToShift = 73.0000;
	  case 96
	    NrPointsToShift = 70.6667;
	  case 128
	    NrPointsToShift = 72.5000;
	  case 192
	    NrPointsToShift = 71.3333;
	  case 256
	    NrPointsToShift = 72.2500;
	  case 384
	    NrPointsToShift = 71.6667;
	  case 512
	    NrPointsToShift = 72.1250;
	  case 768
	    NrPointsToShift = 71.8333;
	  case 1024
	    NrPointsToShift = 72.0625;
	  case 1536
	    NrPointsToShift = 71.9167;
	  case 2048
	    NrPointsToShift = 72.0313;
	  otherwise
	    disp('DetermineBrukerDigitalFilter ERROR: code for DECIM not recognized. Aborting ...');
        end
      
      case 12
        switch (DECIM)
	  case 2
	    NrPointsToShift = 46.311;
	  case 3
	    NrPointsToShift = 36.530;
	  case 4
	    NrPointsToShift = 47.870;
	  case 6
	    NrPointsToShift = 50.229;
	  case 8
	    NrPointsToShift = 53.289;
	  case 12
	    NrPointsToShift = 69.551;
	  case 16
	    NrPointsToShift = 71.600;
	  case 24
	    NrPointsToShift = 70.184;
	  case 32
	    NrPointsToShift = 72.138;
	  case 48
	    NrPointsToShift = 70.528;
	  case 64
	    NrPointsToShift = 72.348;
	  case 96
	    NrPointsToShift = 70.700;
	  case 128
	    NrPointsToShift = 72.524;
	  otherwise
	    disp('DetermineBrukerDigitalFilter ERROR: code for DECIM not recognized. Aborting ...');
        end
      
      case {20, 21, 22, 23}
        eval([QTEMP1(strmatch('GRPDLY=', QTEMP1), :) ';']);
        NrPointsToShift = GRPDLY;
      
      otherwise
        disp('DetermineBrukerDigitalFilter ERROR: code for DSPFVS not recognized. Aborting ...');
    end
  end
