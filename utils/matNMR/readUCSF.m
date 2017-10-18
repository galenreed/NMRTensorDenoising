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
% readUCSF.m reads a binary Sparky UCSF file from disk.
%
% syntax:  [ret, Sizes] = readUCSF(FileName);
%
% where ret is a matNMR structure containing the spectrum. Sizes is a vector with the
% length of each dimension written into.
%
% Jacco van Beek
% 28-01-'09

function [ret, Sizes] = readUCSF(FileName)

%
%Open file as big endian format
%
fp = fopen(FileName, 'r', 'b');

%
%Read 5 items from the first header (180 bytes long)
%
filetype = char(fread(fp, 10, 'char'));
NRdimensions = fread(fp, 1, 'char');
NRDataComponents = fread(fp, 1, 'char');
something = fread(fp, 1, 'char');
FormatVersionNumber = fread(fp, 1, 'char');

if (NRdimensions > 3)
  error('readucsf WARNING: cannot read datasets with more than 3 dimensions. Aborting ...');
end

if (FormatVersionNumber ~= 2)
  error('readucsf WARNING: can only read UCSF data format version 2 at the moment. Aborting ...');
end


%
%Generate the structure for the final output
%
ret = GenerateMatNMRStructure;


%
%Read the parameters for all axes
%
if (NRdimensions == 1) 	%1D data
  NRpointsTD1 = 1;
  TileSizeTD1 = 1;

  %
  %Read axis data for 1D
  %
  Offset = 180;
  fseek(fp, Offset, -1);
  NucleusTD2 = char(fread(fp, 6, 'char'));
  fseek(fp, Offset+8, -1);
  NRpointsTD2 = fread(fp, 1, 'uint');
  fseek(fp, Offset+16, -1);
  TileSizeTD2 = fread(fp, 1, 'uint');
  fseek(fp, Offset+20, -1);
  SpectrometerFrequencyTD2 = fread(fp, 1, 'float');
  fseek(fp, Offset+24, -1);
  SpectralWidthTD2 = fread(fp, 1, 'float');
  fseek(fp, Offset+28, -1);
  CenterOfDataTD2 = fread(fp, 1, 'float');

  Sizes = [NRpointsTD2];
  ret.FIDstatusTD2 = 1;
  ret.SpectralFrequencyTD2 = SpectrometerFrequencyTD2;
  ret.SweepWidthTD2 = SpectralWidthTD2/1e3;
  ret.DefaultAxisCarrierIndexTD2 = (NRpointsTD2/2);
  ret.DefaultAxisRefPPMTD2 = CenterOfDataTD2;

  %
  %read the data
  %
  ret.Spectrum = zeros(1, NRpointsTD2);
  fseek(fp, NRdimensions*128+180, -1);
  f2 = NRpointsTD2 / TileSizeTD2;
  k=1:TileSizeTD2;
  for p=1:f2
    [a,count] = fread(fp, TileSizeTD2, 'float');
    ret.Spectrum(k + (p-1)*TileSizeTD2) = a.';
  end
  ret.Spectrum = fliplr(ret.Spectrum);

elseif (NRdimensions == 2) 	%2D data
  %
  %Read axis data for TD1 (also TD1 in matNMR)
  %
  Offset = 180;
  fseek(fp, Offset, -1);
  NucleusTD1 = char(fread(fp, 6, 'char'));
  fseek(fp, Offset+8, -1);
  NRpointsTD1 = fread(fp, 1, 'uint');
  fseek(fp, Offset+16, -1);
  TileSizeTD1 = fread(fp, 1, 'uint');
  fseek(fp, Offset+20, -1);
  SpectrometerFrequencyTD1 = fread(fp, 1, 'float');
  fseek(fp, Offset+24, -1);
  SpectralWidthTD1 = fread(fp, 1, 'float');
  fseek(fp, Offset+28, -1);
  CenterOfDataTD1 = fread(fp, 1, 'float');
  
  ret.SpectralFrequencyTD1 = SpectrometerFrequencyTD1;
  ret.SweepWidthTD1 = SpectralWidthTD1/1e3;
  ret.DefaultAxisCarrierIndexTD1 = (NRpointsTD1/2);
  ret.DefaultAxisRefPPMTD1 = CenterOfDataTD1;
  ret.FIDstatusTD1 = 1;

  %
  %Read axis data for TD2 (also TD2 in matNMR)
  %
  Offset = 308;
  fseek(fp, Offset, -1);
  NucleusTD2 = char(fread(fp, 6, 'char'));
  fseek(fp, Offset+8, -1);
  NRpointsTD2 = fread(fp, 1, 'uint');
  fseek(fp, Offset+16, -1);
  TileSizeTD2 = fread(fp, 1, 'uint');
  fseek(fp, Offset+20, -1);
  SpectrometerFrequencyTD2 = fread(fp, 1, 'float');
  fseek(fp, Offset+24, -1);
  SpectralWidthTD2 = fread(fp, 1, 'float');
  fseek(fp, Offset+28, -1);
  CenterOfDataTD2 = fread(fp, 1, 'float');

  Sizes = [NRpointsTD1 NRpointsTD2];
  ret.FIDstatusTD2 = 1;
  ret.SpectralFrequencyTD2 = SpectrometerFrequencyTD2;
  ret.SweepWidthTD2 = SpectralWidthTD2/1e3;
  ret.DefaultAxisCarrierIndexTD2 = (NRpointsTD2/2);
  ret.DefaultAxisRefPPMTD2 = CenterOfDataTD2;

  %
  %read the data
  %
  ret.Spectrum = zeros(NRpointsTD1, NRpointsTD2);
  fseek(fp, NRdimensions*128+180, -1);
  f1 = NRpointsTD1 / TileSizeTD1;
  f2 = NRpointsTD2 / TileSizeTD2;
  k=1:TileSizeTD2;
  for o=1:f1
    for p=1:f2
      for i=1:TileSizeTD1;
        [a,count] = fread(fp, TileSizeTD2, 'float');
        ret.Spectrum(i + (o-1)*TileSizeTD1 ,k + (p-1)*TileSizeTD2) = a.';
      end
    end
  end
  ret.Spectrum = flipud(fliplr(ret.Spectrum));

else 			%3D data
  %
  %Read axis data for TD1 (TD3 in matNMR)
  %
  Offset = 180;
  fseek(fp, Offset, -1);
  NucleusTD1 = char(fread(fp, 6, 'char'));
  fseek(fp, Offset+8, -1);
  NRpointsTD1 = fread(fp, 1, 'uint');
  fseek(fp, Offset+16, -1);
  TileSizeTD1 = fread(fp, 1, 'uint');
  fseek(fp, Offset+20, -1);
  SpectrometerFrequencyTD1 = fread(fp, 1, 'float');
  fseek(fp, Offset+24, -1);
  SpectralWidthTD1 = fread(fp, 1, 'float');
  fseek(fp, Offset+28, -1);
  CenterOfDataTD1 = fread(fp, 1, 'float');
  
  ret.SpectralFrequencyTD3 = SpectrometerFrequencyTD1;
  ret.SweepWidthTD3 = SpectralWidthTD1/1e3;
  ret.DefaultAxisCarrierIndexTD3 = (NRpointsTD1/2);
  ret.DefaultAxisRefPPMTD3 = CenterOfDataTD1;
  ret.FIDstatusTD3 = 1;

  %
  %Read axis data for TD2 (TD1 in matNMR)
  %
  Offset = 308;
  fseek(fp, Offset, -1);
  NucleusTD2 = char(fread(fp, 6, 'char'));
  fseek(fp, Offset+8, -1);
  NRpointsTD2 = fread(fp, 1, 'uint');
  fseek(fp, Offset+16, -1);
  TileSizeTD2 = fread(fp, 1, 'uint');
  fseek(fp, Offset+20, -1);
  SpectrometerFrequencyTD2 = fread(fp, 1, 'float');
  fseek(fp, Offset+24, -1);
  SpectralWidthTD2 = fread(fp, 1, 'float');
  fseek(fp, Offset+28, -1);
  CenterOfDataTD2 = fread(fp, 1, 'float');

  ret.FIDstatusTD1 = 1;
  ret.SpectralFrequencyTD1 = SpectrometerFrequencyTD2;
  ret.SweepWidthTD1 = SpectralWidthTD2/1e3;
  ret.DefaultAxisCarrierIndexTD1 = (NRpointsTD2/2);
  ret.DefaultAxisRefPPMTD1 = CenterOfDataTD2;

  %
  %Read axis data for TD3 (TD2 in matNMR)
  %
  Offset = 436;
  fseek(fp, Offset, -1);
  NucleusTD3 = char(fread(fp, 6, 'char'));
  fseek(fp, Offset+8, -1);
  NRpointsTD3 = fread(fp, 1, 'uint');
  fseek(fp, Offset+16, -1);
  TileSizeTD3 = fread(fp, 1, 'uint');
  fseek(fp, Offset+20, -1);
  SpectrometerFrequencyTD3 = fread(fp, 1, 'float');
  fseek(fp, Offset+24, -1);
  SpectralWidthTD3 = fread(fp, 1, 'float');
  fseek(fp, Offset+28, -1);
  CenterOfDataTD3 = fread(fp, 1, 'float');

  Sizes = [NRpointsTD1 NRpointsTD2 NRpointsTD3];
  ret.FIDstatusTD2 = 1;
  ret.SpectralFrequencyTD2 = SpectrometerFrequencyTD3;
  ret.SweepWidthTD2 = SpectralWidthTD3/1e3;
  ret.DefaultAxisCarrierIndexTD2 = (NRpointsTD3/2);
  ret.DefaultAxisRefPPMTD2 = CenterOfDataTD3;

  %
  %read the data
  %
  ret.Spectrum = zeros(NRpointsTD1, NRpointsTD2, NRpointsTD3);
  fseek(fp, NRdimensions*128+180, -1);
  f1 = NRpointsTD1 / TileSizeTD1;
  f2 = NRpointsTD2 / TileSizeTD2;
  f3 = NRpointsTD3 / TileSizeTD3;
  k=1:TileSizeTD3;
  for o=1:f1
    for p=1:f2
      for r=1:f3
        for i=1:TileSizeTD1
          for j=1:TileSizeTD2
            [a,count] = fread(fp, TileSizeTD3, 'float');
            ret.Spectrum(i + (o-1)*TileSizeTD1, j + (p-1)*TileSizeTD2, k + (r-1)*TileSizeTD3) = a.';
          end
        end
      end
    end
  end
  ret.Spectrum = flipdim(ret.Spectrum, 1);
  ret.Spectrum = flipdim(ret.Spectrum, 2);
  ret.Spectrum = flipdim(ret.Spectrum, 3);
end
