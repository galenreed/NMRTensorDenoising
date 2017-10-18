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
%regelmatlaad.m reads MATLAB files from disk.
%07-11-'01

try
  if (QmatNMR.buttonList == 1)				%OK-button
    watch;
    disp('Please wait while matNMR is reading the MATLAB files ...');

  %
  %retrieve common part of the filename and the range
  %
    QmatNMR.Fname = QmatNMR.uiInput1;

  %
  %Detect whether a series of files must be loaded
  %
    if (isempty(findstr(QmatNMR.Fname, '$')))
      %
      %load single file
      %

      QTEMP = findstr(QmatNMR.Fname, filesep);		%extract the filename and path depending on the platform
      QmatNMR.Xpath = deblank(QmatNMR.uiInput1(1:QTEMP(length(QTEMP))));
      QmatNMR.Xfilename = deblank(QmatNMR.uiInput1((QTEMP(length(QTEMP))+1):length(QmatNMR.uiInput1)));

      load(QmatNMR.Fname);
      disp([QmatNMR.Fname ' loaded ...']);

    else
      %
      %load series of files
      %

      %
      %Extract and check the ranges first
      %
      QTEMP2 = findstr(QmatNMR.Fname, '$');
      QTEMP61 = QmatNMR.Fname( (QTEMP2(1)):(QTEMP2(2)) );

      if (length(QTEMP2) ~= 2)
        beep
        disp('matNMR WARNING: incorrect syntax for loading series of binary data files. Aborting ...');
        return
      end

      try
        QmatNMR.SeriesRangeIn = eval(QmatNMR.Fname( (QTEMP2(1)+1):(QTEMP2(2)-1) ));
      end

      %
      %Now we perform a loop over the range of the file names and execute the lot
      %
      for QTEMP3 = 1:length(QmatNMR.SeriesRangeIn)
        %
        %create the file name for the current element of the series
        %
        QmatNMR.SeriesName = strrep(QmatNMR.Fname, QTEMP61, num2str(QmatNMR.SeriesRangeIn(QTEMP3), 10));

        load(QmatNMR.SeriesName);

        disp([QmatNMR.SeriesName ' loaded ...']);
      end


      %
      %remember the file name as it was given by the user for the next time a binary FID needs to be read
      %
      QTEMP = findstr(QmatNMR.Fname, filesep);              %extract the filename and path depending on the platform
      QTEMP9 = length(QTEMP);
      QmatNMR.Xpath = deblank(QmatNMR.Fname(1:QTEMP(QTEMP9)));                              %the path
      QmatNMR.Xfilename = deblank(QmatNMR.Fname((QTEMP(QTEMP9)+1):length(QmatNMR.Fname)));       %the file name
    end

    Arrowhead;


    %
    %This may be useful when wanting to operate on series afterwards;
    %
    QmatNMR.AddVariablesCommonString = QmatNMR.Xfilename;

  else
    disp('Reading of series of MATLAB files cancelled ...');
  end

  clear QTEMP*

catch
%
%call the generic error handler routine if anything goes wrong
%
  errorhandler
end
