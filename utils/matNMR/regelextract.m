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
%regelextract.m extracts a part of a contour plot and saves it into a matrix
%13-10-'98

try
  %
  %restore the buttondown functions
  %
  set(QmatNMR.Fig2D3D,'windowbuttondownfcn','', ...
        'windowbuttonupfcn','', ...
        'windowbuttonmotionfcn','',...
        'buttondownfcn', 'SelectFigure', ...
        'interruptible','on')
  set(QmatNMR.AxisHandle2D3D,'interruptible','on', 'buttondownfcn', 'SelectAxis')
  
  %
  %perform extraction
  %
  if (QmatNMR.buttonList == 1)			%= OK-button
    QTEMP1 = QmatNMR.uiInput1;
    QTEMP2 = findstr(QmatNMR.uiInput2, ',');
  
  					%
  					%re-Check the range that was given as input
  					%
    QTEMP3 = sort([QTEMP2 findstr(QmatNMR.uiInput2, ':')]);
    QTEMP4 = [str2num(QmatNMR.uiInput2(1:(QTEMP3(1)-1))) str2num(QmatNMR.uiInput2((QTEMP3(1)+1):(QTEMP3(2)-1))) str2num(QmatNMR.uiInput2((QTEMP3(2)+1):(QTEMP3(3)-1))) str2num(QmatNMR.uiInput2((QTEMP3(3)+1):(length(QmatNMR.uiInput2))))];
    QTEMP4 = [sort(QTEMP4(1:2)); sort(QTEMP4(3:4))];
  
  				%Now determine the position in points
    QTEMP = get(QmatNMR.Fig2D3D, 'userdata');		%extract the userdata from the figure window
  					       	%read offset and slope of the axes vectors in the plot
    QmatNMR.AxisData = QTEMP.PlotParams(QmatNMR.AxisNR2D3D).AxisProps;
  
    if ~ isempty(QmatNMR.AxisData)		      %when the user has plotted some spectrum himself
  					      %into the contour window then probably the axes information
          				      %will not have been written into the userdata property.
          				      %Then this could give errors ...
      %
      %first determine the coordinate in points. The method depends on whether the axis
      %was linear or non-linear.
      %
      if (QmatNMR.AxisData(1))	      %linear axis in TD2 -> use axis increment and offset values
        QmatNMR.valTD2 = sort(round((QTEMP4(2, 1:2)-QmatNMR.AxisData(2)) ./ QmatNMR.AxisData(1)));
      else
  			      %non-linear axis -> use the minimum distance to the next point in the axis vector
        QTEMP7 = QTEMP.PlotParams(QmatNMR.AxisNR2D3D).AxisTD2;
        [QmatNMR.valTD2 QTEMP8] = min(abs(QTEMP7 - QTEMP4(2, 1)));
        [QmatNMR.valTD2 QTEMP9] = min(abs(QTEMP7 - QTEMP4(2, 2)));
        QmatNMR.valTD2 = [QTEMP8 QTEMP9];
      end
      
      if (QmatNMR.AxisData(3))	      %linear axis in TD1 -> use axis increment and offset values
        QmatNMR.valTD1 = sort(round((QTEMP4(1, 1:2)-QmatNMR.AxisData(4)) ./ QmatNMR.AxisData(3)));
      else
  			      %non-linear axis -> use the minimum distance to the next point in the axis vector
        QTEMP7 = QTEMP.PlotParams(QmatNMR.AxisNR2D3D).AxisTD1;
        [QmatNMR.valTD1 QTEMP8] = min(abs(QTEMP7 - QTEMP4(1, 1)));
        [QmatNMR.valTD1 QTEMP9] = min(abs(QTEMP7 - QTEMP4(1, 2)));
        QmatNMR.valTD1 = [QTEMP8 QTEMP9];
      end
  
  				%Check whether the coordinates are within the matrix bounds
      QmatNMR.tmp2 = QTEMP.PlotParams(QmatNMR.AxisNR2D3D).SizeTD2;
      QmatNMR.tmp1 = QTEMP.PlotParams(QmatNMR.AxisNR2D3D).SizeTD1;
      if (QmatNMR.valTD2(1) < 1); QmatNMR.valTD2(1)=1; end
      if (QmatNMR.valTD2(2) > max(QmatNMR.tmp2)); QmatNMR.valTD2(2)=max(QmatNMR.tmp2); end
      if (QmatNMR.valTD1(1) < 1); QmatNMR.valTD1(1)=1; end
      if (QmatNMR.valTD1(2) > max(QmatNMR.tmp1)); QmatNMR.valTD1(2)=max(QmatNMR.tmp1); end
  
  				%Put the final coordinates back in the input string.
  				%
  				%QmatNMR.uiInput2 gives the coordinates in points of the matrix
  				%QTEMP5 gives the coordinates in the value of their original axis --> the user gives
  				%	these numbers as I think the user isn't interested in QmatNMR.uiInput2 if he/she wants to
  				%	select a certain area of the spectrum in PPM.
  				%	QTEMP5 is therefore shown in the History and QmatNMR.uiInput2 is used by matNMR
  				%
      QmatNMR.uiInput2 = [num2str(QmatNMR.valTD1(1)) ':' num2str(QmatNMR.valTD1(2)) ', ' num2str(QmatNMR.valTD2(1)) ':' num2str(QmatNMR.valTD2(2))];
      QTEMP5 = [num2str( QmatNMR.Axis2D3DTD1(QmatNMR.valTD1(1)) ) ':' num2str( QmatNMR.Axis2D3DTD1(QmatNMR.valTD1(2)) ) ', ' num2str( QmatNMR.Axis2D3DTD2(QmatNMR.valTD2(1)) ) ':' num2str( QmatNMR.Axis2D3DTD2(QmatNMR.valTD2(2)) )];
      QTEMP2 = findstr(QmatNMR.uiInput2, ',');
  
  
  %====
    					%
  					%save the Extracted spectrum in the designated variable
  					%
      if exist(QTEMP1)					
        if (isa(eval(QTEMP1), 'struct'))
          eval([QTEMP1 '.Spectrum = QmatNMR.Spec2D3D(' QmatNMR.uiInput2 ');']);
    
          eval([QTEMP1 '.History = str2mat(' QTEMP1 '.History, [''Spectrum extracted for range ('' QTEMP5 '') (TD1, TD2)'']);']);
          eval([QTEMP1 '.HistoryMacro = AddToMacro(' QTEMP1 '.HistoryMacro, 114, QmatNMR.valTD2(1), QmatNMR.valTD2(2), QmatNMR.valTD1(1), QmatNMR.valTD1(2));']);
          eval([QTEMP1 '.AxisTD1 = QmatNMR.Axis2D3DTD1(' QmatNMR.uiInput2(1, 1:(QTEMP2-1)) ');']);
          eval([QTEMP1 '.AxisTD2 = QmatNMR.Axis2D3DTD2(' QmatNMR.uiInput2(1, (QTEMP2+2):(length(QmatNMR.uiInput2(1, :)))) ');']);
          disp(['Extracted spectrum saved in existing structure ' QTEMP1]);
        else  
          eval([QTEMP1 ' = QmatNMR.Spec2D3D(' QmatNMR.uiInput2 ');']);
        
          disp(['Extracted spectrum saved as ' QTEMP1]);
        end
      else  
        eval([QTEMP1 ' = QmatNMR.Spec2D3D(' QmatNMR.uiInput2 ');']);
       
        disp(['Extracted spectrum saved as ' QTEMP1]);
      end
    
    
    
      if QmatNMR.uiInput3				%redraw spectrum ?
        eval(['QmatNMR.Axis2D3DTD1 = QmatNMR.Axis2D3DTD1(' QmatNMR.uiInput2(1, 1:(QTEMP2-1)) ');']);
        eval(['QmatNMR.Axis2D3DTD2 = QmatNMR.Axis2D3DTD2(' QmatNMR.uiInput2(1, (QTEMP2+2):(length(QmatNMR.uiInput2(1, :)))) ');']);
        eval(['QmatNMR.Spec2D3D = QmatNMR.Spec2D3D(' QmatNMR.uiInput2 ');']);
    
        [QmatNMR.SpecName2D3D, QmatNMR.CheckInput] = checkinput(QmatNMR.uiInput1);	%Check the name of the spectrum that needs to be plotted
        QmatNMR.SpecName2D3DProc = QmatNMR.SpecName2D3D;
        checkinputcont;
        
        					%remember the current axis and title labels
        QTEMP5 = [QmatNMR.titelstring1, QmatNMR.titelstring2];
        QTEMP6 = QmatNMR.textt2;
        QTEMP7 = QmatNMR.textt1;
        
        					%redraw the spectrum now
        if (QmatNMR.ContType == 0)
          dispcont;
        else
          dispabscont
        end
        
        					%restore the original title and axis labels
        title(strrep(QTEMP5, '\n', char(10)), 'Color', QmatNMR.ColorScheme.AxisFore);
        QmatNMR.textt2 = QTEMP6;
        xlabel(strrep(QmatNMR.textt2, '\n', char(10)));
        QmatNMR.textt1 = QTEMP7;
        ylabel(strrep(QmatNMR.textt1, '\n', char(10)));
      end
      
    else
      %no axis information was found in the userdata
      %cancel now!
      error('matNMR ERROR: cannot find axis properties in figure window''s userdata. Aborting ...');
    end  
  
  else
    disp('Extraction cancelled ...');
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
