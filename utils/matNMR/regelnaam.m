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
%regelnaam.m takes care of the input for loading the spectra.
%21-12-'96

try
  if (((QmatNMR.ask==2) | (QmatNMR.ask==3)) & ((QmatNMR.buttonList == 1) | (QmatNMR.buttonList == 2) | (QmatNMR.buttonList == 3)))	| ((QmatNMR.ask==1) & ((QmatNMR.buttonList == 1) | (QmatNMR.buttonList == 2)))	%= OK-button
    QmatNMR.Spec1DName = fliplr(deblank(fliplr(deblank(QmatNMR.uiInput1))));
    QmatNMR.UserDefAxisT2Main = QmatNMR.uiInput2;
  
    if isempty(QmatNMR.Spec1DName)
      disp('matNMR WARNING: no spectrum/FID given. Please try again.');
      askname
      return
    end
  
    if QmatNMR.ask == 1				%load new 1D FID/spectrum
  
      if QmatNMR.buttonList == 1			%Is it an FID or a spectrum ?
        QmatNMR.FIDstatus = 2;			%these setting are overwritten if the
      else				%new spectrum is a structure (and if
        QmatNMR.FIDstatus = 1;			%the FIDstatuses are stored in it)
      end
  
      QmatNMR.newinlist.Spectrum = QmatNMR.Spec1DName;	%define the name of the variable and axis vector
      QmatNMR.newinlist.Axis = QmatNMR.UserDefAxisT2Main;	%for putinlist1d.m
      putinlist1d;			%put name in list of last 10 variables if it is new
      [QmatNMR.Spec1DName, QmatNMR.CheckInput] = checkinput(QmatNMR.Spec1DName);%adjust the format of the input expression for later use
  
      %
      %delete the 3D panel as we don't need it now
      %
      if ~isempty(QmatNMR.fig3D)
        try
          delete(QmatNMR.fig3D)
        end
        QmatNMR.fig3D = [];
      end
  
      makenew1D;				%if the name is false then an error will be produced
   
   
    elseif QmatNMR.ask == 2			%load 2D FID/spectrum
      QmatNMR.UserDefAxisT1Main = QmatNMR.uiInput3;
  
      if QmatNMR.buttonList == 1			%Is it an FID or a spectrum ?
        QmatNMR.FIDstatus2D1 = 2;		%these setting are overwritten if the
        QmatNMR.FIDstatus2D2 = 2;		%new spectrum is a structure (and if
        					%the FIDstatuses are stored in it)
      elseif QmatNMR.buttonList == 2
        QmatNMR.FIDstatus2D1 = 1;
        QmatNMR.FIDstatus2D2 = 1;
        
      else  
        QmatNMR.FIDstatus2D1 = 1;
        QmatNMR.FIDstatus2D2 = 2;
      end
  
      QmatNMR.newinlist.Spectrum = QmatNMR.Spec1DName;	%define the name of the variable and axis vector
      QmatNMR.newinlist.AxisTD2 = QmatNMR.UserDefAxisT2Main;	%for putinlist2d.m
      QmatNMR.newinlist.AxisTD1 = QmatNMR.UserDefAxisT1Main;
      putinlist2d;			%put name in list of last 10 variables if it is new
      [QmatNMR.Spec1DName, QmatNMR.CheckInput] = checkinput(QmatNMR.Spec1DName);%adjust the format of the input expression for later use
  
      %
      %delete the 3D panel as we don't need it now
      %
      if ~isempty(QmatNMR.fig3D)
        try
          delete(QmatNMR.fig3D)
        end
        QmatNMR.fig3D = [];
      end
  
      makenew2D;				%if the name is false then an error will be produced
   
    elseif QmatNMR.ask == 3			%load 3D FID/spectrum, assuming it is a series of 2D's
      QmatNMR.UserDefAxisT1Main = QmatNMR.uiInput3;
  
      if QmatNMR.buttonList == 1			%Is it an FID or a spectrum ?
        QmatNMR.FIDstatus2D1 = 2;		%these setting are overwritten if the
        QmatNMR.FIDstatus2D2 = 2;		%new spectrum is a structure (and if
        					%the FIDstatuses are stored in it)
      elseif QmatNMR.buttonList == 2
        QmatNMR.FIDstatus2D1 = 1;
        QmatNMR.FIDstatus2D2 = 1;
        
      else  
        QmatNMR.FIDstatus2D1 = 1;
        QmatNMR.FIDstatus2D2 = 2;
      end
  
  
      %
      %create the window with 3D-related controls if necessary
      %
      matNMR3DButtons
  
      QmatNMR.newinlist.Spectrum = QmatNMR.Spec1DName;	%define the name of the variable and axis vector
      QmatNMR.newinlist.AxisTD2 = QmatNMR.UserDefAxisT2Main;	%for putinlist3d.m
      QmatNMR.newinlist.AxisTD1 = QmatNMR.UserDefAxisT1Main;
      putinlist3d;			%put name in list of last 10 variables if it is new
      [QmatNMR.Spec1DName, QmatNMR.CheckInput] = checkinput(QmatNMR.Spec1DName);%adjust the format of the input expression for later use
  
      makenew3D;				%if the name is false then an error will be produced
    end
  
  else
    disp('Loading new spectrum was cancelled ...');
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
