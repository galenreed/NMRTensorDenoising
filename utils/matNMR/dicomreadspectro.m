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
function [fid] = dicomreadspectro(filename)
%DICOMREADSPECTRO  Read a siemens DICOM spectrum
% This function relies on the use of matlab's dicom_get_tags and
% dicom_read_attr functions, which add a lot of overhead. 
% Tested with VB13 and VB15 dicoms from a Trio.
% Rexford Newbould, GSK CIC, 2008

if (nargin < 1)
    error('DICOMREADSPECTRO requires a filename as an argument.')
end

% All this setup is just to allow the use of the Matlab dicom
% functions.
    file = dicom_create_file_struct;
    file.Messages = filename;
    file.Frames = 'all';
    file.Dictionary = dicomdict('get_current');
    file.Raw = 1;
    file.Location = 'Local';
    file = dicom_warn('reset', file);
    file = dicom_get_msg(file);
    file = dicom_open_msg(file, 'r');    
    % Create container for metadata.
    info = dicom_create_meta_struct(file);
% End the setup.

% Find the location of the required tags and the transfer syntax.
[tags, pos, info, file] = dicom_get_tags(file, info);
        
% locate the 7fe1,1010 tag (spectrum data)  This is the location where this
% might break with non-Siemens data.
idx_pix = find(((tags(:,1) == 32737) + (tags(:,2) == 4112)) == 2);
        
if isempty(idx_pix)
    error('I can''t find the pixel data in tag (7fe1,1010).  Check this DICOM file.\n');
end

%
% Extract the FID data using low-level file I/O.
fp = fopen(filename,'rb');
fseek(fp,pos(idx_pix),'bof');
group_and_element = fread(fp,2,'uint16');
OB = fread(fp,2,'char');
padding = fread(fp,2,'uint8');
field_length = fread(fp,1,'uint16') / 4;
padding = fread(fp,2,'uint8');
fid=fread(fp,field_length,'float32','ieee-le');

fid = complex(fid(1:2:end),fid(2:2:end));
fclose(fp);    

file = dicom_close_msg(file);
    
    
end  


