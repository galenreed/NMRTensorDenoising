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
%GenerateMatNMRStructure.m
%
%generates a generic matNMR variable structure. This is done centrally to make sure
%all routines use the same format.
%
%Jacco van Beek
%23-06-'00

function ret = GenerateMatNMRStructure(ExtensionFlag)

if (nargin == 0)
  ExtensionFlag = 0;
end

%
%define the standard elements of a matNMR structure
%
ret.Spectrum 					= 0;
ret.History 					= '';
ret.HistoryMacro 				= AddToMacro;
ret.AxisTD3					= [];
ret.AxisTD2					= [];
ret.AxisTD1 					= [];
ret.SweepWidthTD2 				= 50;
ret.SweepWidthTD1 				= 50;
ret.SpectralFrequencyTD2 			= 100;
ret.SpectralFrequencyTD1 			= 100;
ret.Hypercomplex 				= [];
ret.PeakListNums 				= [];
ret.PeakListText 				= [];
ret.FIDstatusTD2 				= 2;
ret.FIDstatusTD1 				= 2;
ret.GammaTD2 					= 1;	%select a positive gyromagnetic ratio by default
ret.GammaTD1 					= 1;	%select a positive gyromagnetic ratio by default
ret.DefaultAxisReference.ReferenceFrequency 	= 0;
ret.DefaultAxisReference.ReferenceValue     	= 0;
ret.DefaultAxisReference.ReferenceUnit      	= 0;
ret.DefaultAxisCarrierIndexTD2 			= 0;
ret.DefaultAxisRefkHzTD2 			= 0;
ret.DefaultAxisRefPPMTD2 			= 0;
ret.DefaultAxisCarrierIndexTD1 			= 0;
ret.DefaultAxisRefkHzTD1 			= 0;
ret.DefaultAxisRefPPMTD1 			= 0;
ret.DataPath 					= '';
ret.DataFile 					= '';


%
%if needed (for the undo matrix for example) this can be extended
%
if ExtensionFlag
  ret.Phase0 		= 0;
  ret.Phase1 		= 0;
  ret.Phase2 		= 0;
  ret.Phase1Start	= 0;
  ret.Phase1StartIndex	= 0;

  ret.DefaultAxisFlagTD2  = 0;	%flag for default axis
  ret.DefaultAxisFlagTD1  = 0;	%flag for default axis
end
