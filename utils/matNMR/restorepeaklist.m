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
%restorepeaklist.m restores all peaks and lines that were saved in the data structure
%17-08-'98
%04-10-'00

try
  %
  %Check whether there is a peak list to display --> QmatNMR.numbvars=1, QmatNMR.numbstructs=1
  %i.e. the variable is a structure. They can have a peak list enclosed
  %
  if ((QmatNMR.numbvars == 1) & (QmatNMR.numbstructs == 1))
    %
    %note thet here QmatNMR.CheckInput is still defined by the checkinput.m! i.e. it denotes the
    %place of the variable name in the string QmatNMR.SpecName2D3D
    %					
    for QTEMP40 = length(QmatNMR.CheckInput):-1:2
      %QTEMP2 is the name of the variable without junk that was added by the user
      QTEMP2 = deblank(fliplr(deblank(fliplr(QmatNMR.SpecName2D3DProc((QmatNMR.CheckInput(QTEMP40-1)+1):(QmatNMR.CheckInput(QTEMP40)-1))))));
  
  				%check the expression for existing variables
      if exist(QTEMP2, 'var')
        eval(['QTEMP3 = ' QTEMP2 '.PeakListNums;']);
        eval(['QTEMP4 = ' QTEMP2 '.PeakListText;']);
        QmatNMR.PeakList = [];
        if ~ isempty(QTEMP3)			%If there is a peak list restore the peaks in the plot
  
          if (QmatNMR.FlagCutSpectrum)
          %
          %A "Cut Spectrum" has just been called. This means the axis of display is not equal to
          %the axis containing the real axis units (which are needed for "Get Position" and
          %"Peak Picking")
          %
  	%This means we have to correlate each coordinate in the peak list with its equivalent
  	%position in the real axis of plotting.
  	%Peaks that fall outside the regions that are now present in the plot will not be
  	%plotted. A warning message will be printed then to notify the user.
  	%
            QTEMP5 = size(QTEMP3, 1);
            for QTel = 1:QTEMP5;
            				%put text label in contour plot
              QTEMP6 = find(QmatNMR.NewAxisTD2 == QTEMP3(QTel, 1)); %the x-coordinate in the new display axis
  	    QTEMP7 = find(QmatNMR.NewAxisTD1 == QTEMP3(QTel, 2)); %the y-coordinate in the new display axis
  	    if (isempty(QTEMP6) | isempty(QTEMP7))
  	      disp('matNMR NOTE: A peak was found outside the cutting regions and therefore it cannot be displayed!')
  	      QmatNMR.PeakList = [QmatNMR.PeakList; [QTEMP3(QTel, 1:3) 0 0]];
  	
  	    else
                QmatNMR.PeakTextHandle = text(QTEMP6, QTEMP7, QTEMP4(QTel, :));
                set(QmatNMR.PeakTextHandle,'hittest', 'on', 'Color', QmatNMR.ColorScheme.AxesFore, ...
            	'buttondownfcn', 'askedittext');
   
                QmatNMR.PeakList = [QmatNMR.PeakList; [QTEMP3(QTel, 1:3) QmatNMR.PeakTextHandle 0]];
  
                if (QTEMP3(QTel, 4) > 0)  	%draw lines between the last 2 peaks if needed
    	  					%note that in the structure only 4 numbers are saved
    	  					%whereas 5 in QmatNMR.PeakList! This 4th number denotes the
    	  					%old handle for the line. If this is 0 then there was
    	  					%no line previously and none will be drawn.
            	QTEMP8 = find(QmatNMR.NewAxisTD2 == QmatNMR.PeakList(QTel-1, 1));
            	QTEMP9 = find(QmatNMR.NewAxisTD1 == QmatNMR.PeakList(QTel-1, 2));
    	  	if (isempty(QTEMP8) | isempty(QTEMP9))
            	  disp('matNMR NOTE: The previous peak was found outside the cutting regions and therefore this line cannot be displayed!')
   
            	else
  	  	  QmatNMR.PeakLineHandle = line([QTEMP8 QTEMP6], [QTEMP9 QTEMP7]);
  	  	  set(QmatNMR.PeakLineHandle, 'color', 'w', 'hittest', 'on', ...
  	  	    'buttondownfcn', 'QuiInput(''Delete Line ?'', '' YES | NO'', ''regeleditline'', [], ''Line Handle (do not edit!)'', num2str(gco,20));');
  	  	  QmatNMR.PeakList(QTel, 5) = QmatNMR.PeakLineHandle;
  	  	end
  	      end
  	    end
  	  end
  	
  	else
  	%
  	%the normal case ...
  	%
            QTEMP5 = size(QTEMP3, 1);
            for QTel = 1:QTEMP5;
          				%put text label in contour plot
              QmatNMR.PeakTextHandle = text(QTEMP3(QTel, 1), QTEMP3(QTel, 2), QTEMP4(QTel, :));
              set(QmatNMR.PeakTextHandle, 'hittest', 'on', 'Color', QmatNMR.ColorScheme.AxesFore, ...
                'buttondownfcn', 'askedittext');
        
              QmatNMR.PeakList = [QmatNMR.PeakList; [QTEMP3(QTel, 1:3) QmatNMR.PeakTextHandle 0]];
      
              if (QTEMP3(QTel, 4) > 0)		%draw lines between the last 2 peaks if needed
    	  					%note that in the structure only 4 numbers are saved
    						%whereas 5 in QmatNMR.PeakList! This 4th number denotes the
    						%old handle for the line. If this is 0 then there was
    						%no line previously and none will be drawn.
                QmatNMR.PeakLineHandle = line(QmatNMR.PeakList( (QTel-1):(QTel), 1 ), QmatNMR.PeakList( (QTel-1):(QTel), 2 ));
                set(QmatNMR.PeakLineHandle, 'color', 'w', 'hittest', 'on', ...
    	      'buttondownfcn', 'QuiInput(''Delete Line ?'', '' YES | NO'', ''regeleditline'', [], ''Line Handle (do not edit!)'', num2str(gco,20));');
                QmatNMR.PeakList(QTel, 5) = QmatNMR.PeakLineHandle;
              end
  	  end  
          end
      
          disp('Original peak list was restored');
        end
      end  
    end
  
  %
  %If the variable is called 'QmatNMR.Spec2D', i.e. the current 2D matrix from the main window, then the corresponding
  %peak list variable QmatNMR.PeakListNums is checked.
  %
  elseif (strcmp(QmatNMR.SpecName2D3D, 'QmatNMR.Spec2D') & (size(QmatNMR.PeakListNums, 1) > 0))
  
    QTEMP3 = QmatNMR.PeakListNums;
    QTEMP4 = QmatNMR.PeakListText;
    QmatNMR.PeakList = [];
    if ~ isempty(QTEMP3)  		    %If there is a peak list restore the peaks in the plot
      if (QmatNMR.FlagCutSpectrum)
      %
      %A "Cut Spectrum" has just been called. This means the axis of display is not equal to
      %the axis containing the real axis units (which are needed for "Get Position" and
      %"Peak Picking")
      %
      %This means we have to correlate each coordinate in the peak list with its equivalent
      %position in the real axis of plotting.
      %Peaks that fall outside the regions that are now present in the plot will not be
      %plotted. A warning message will be printed then to notify the user.
      %
        QTEMP5 = size(QTEMP3, 1);
        for QTel = 1:QTEMP5;
    				    %put text label in contour plot
    	QTEMP6 = find(QmatNMR.NewAxisTD2 == QTEMP3(QTel, 1)); %the x-coordinate in the new display axis
      	QTEMP7 = find(QmatNMR.NewAxisTD1 == QTEMP3(QTel, 2)); %the y-coordinate in the new display axis
    	if (isempty(QTEMP6) | isempty(QTEMP7))
    	  disp('matNMR NOTE: A peak was found outside the cutting regions and therefore it cannot be displayed!')
    	  QmatNMR.PeakList = [QmatNMR.PeakList; [QTEMP3(QTel, 1:3) 0 0]];
  
  	else
  	  QmatNMR.PeakTextHandle = text(QTEMP6, QTEMP7, QTEMP4(QTel, :));
  	  set(QmatNMR.PeakTextHandle, 'hittest', 'on', 'Color', QmatNMR.ColorScheme.AxesFore, ...
  	    'buttondownfcn', 'askedittext');
  	
    	  QmatNMR.PeakList = [QmatNMR.PeakList; [QTEMP3(QTel, 1:3) QmatNMR.PeakTextHandle 0]];
   
    	  if (QTEMP3(QTel, 4) > 0)	    %draw lines between the last 2 peaks if needed
    					    %note that in the structure only 4 numbers are saved
      					    %whereas 5 in QmatNMR.PeakList! This 4th number denotes the
      					    %old handle for the line. If this is 0 then there was
      					    %no line previously and none will be drawn.
              QTEMP8 = find(QmatNMR.NewAxisTD2 == QmatNMR.PeakList(QTel-1, 1));
  	    QTEMP9 = find(QmatNMR.NewAxisTD1 == QmatNMR.PeakList(QTel-1, 2));
  	    if (isempty(QTEMP8) | isempty(QTEMP9))
                disp('matNMR NOTE: The previous peak was found outside the cutting regions and therefore this line cannot be displayed!')
  
  	    else
                QmatNMR.PeakLineHandle = line([QTEMP8 QTEMP6], [QTEMP9 QTEMP7]);
                set(QmatNMR.PeakLineHandle, 'color', 'w', 'hittest', 'on', ...
    	        'buttondownfcn', 'QuiInput(''Delete Line ?'', '' YES | NO'', ''regeleditline'', [], ''Line Handle (do not edit!)'', num2str(gco,20));');
                QmatNMR.PeakList(QTel, 5) = QmatNMR.PeakLineHandle;
  	    end  
    	  end
    	end
        end  
  
      else
      %
      %the normal case ...
      %
        QTEMP5 = size(QTEMP3, 1);
        for QTel = 1:QTEMP5;
    				    %put text label in contour plot
    	QmatNMR.PeakTextHandle = text(QTEMP3(QTel, 1), QTEMP3(QTel, 2), QTEMP4(QTel, :));
    	set(QmatNMR.PeakTextHandle, 'hittest', 'on', 'Color', QmatNMR.ColorScheme.AxesFore, ...
    	  'buttondownfcn', 'askedittext');
    
    	QmatNMR.PeakList = [QmatNMR.PeakList; [QTEMP3(QTel, 1:3) QmatNMR.PeakTextHandle 0]];
    
    	if (QTEMP3(QTel, 4) > 0)	    %draw lines between the last 2 peaks if needed
      					    %note that in the structure only 4 numbers are saved
      					    %whereas 5 in QmatNMR.PeakList! This 4th number denotes the
      					    %old handle for the line. If this is 0 then there was
      					    %no line previously and none will be drawn.
    	  QmatNMR.PeakLineHandle = line(QmatNMR.PeakList( (QTel-1):(QTel), 1 ), QmatNMR.PeakList( (QTel-1):(QTel), 2 ));
    	  set(QmatNMR.PeakLineHandle, 'color', 'w', 'hittest', 'on', ...
      	  'buttondownfcn', 'QuiInput(''Delete Line ?'', '' YES | NO'', ''regeleditline'', [], ''Line Handle (do not edit!)'', num2str(gco,20));');
    	  QmatNMR.PeakList(QTel, 5) = QmatNMR.PeakLineHandle;
    	end
        end  
      end
    
      disp('Peak list belonging to QmatNMR.Spec2D was restored');
    end
  
  %
  %No peak list found ...
  %
  else
  
    disp(['No peaklist found for "' QmatNMR.SpecName2D3D '"']);
  end
  
  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
