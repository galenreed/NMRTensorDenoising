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
%addvariables2.m adds a series of variables with a similar name
%	syntax: 	Sum = addvariables2(CommonString,)
%
%	where the CommonString should contain the $range$ sequence for substitution by
%	the numbers of the range.
%
%		e.g. 		Sum = addvariables2('j111001_$6:15$');
%
% 	In case the variables are matNMR structures this performs
%	 			Sum = j111001_6.Spectrum + j111001_7.Spectrum + ... + j111001_15.Spectrum;
%
% 	In case the variables are NOT matNMR structures this performs
%	 			Sum = j111001_6 + j111001_7 + ... + j111001_15;
%
%	NOTE: the variables must be global variables!!!
%	NOTE: the variables must be global variables!!!
%	NOTE: the variables must be global variables!!!
%	NOTE: the variables must be global variables!!!
%	NOTE: the variables must be global variables!!!
%	NOTE: the variables must be global variables!!!
%
%
% OR
%
%	syntax: 	Sum = addvariables2(CommonString, RetainFlag)
%
%	This is similar to before but now the flag RetainFlag determines whether
% 	the spectral parameters of the first variable in the range are retained
% 	in the new variable.
%
% 	In case the variables are matNMR structures this performs
%				Sum = j111001_6;			
%	 			Sum.Spectrum = Sum.Spectrum + j111001_7.Spectrum + ... + j111001_15.Spectrum;
%
% 	In case the variables are NOT matNMR structures this performs
%	 			Sum = j111001_6 + j111001_7 + ... + j111001_15;
%
%
% OR
%
%	syntax: 	Sum = addvariables2(CommonString, RetainFlag, NormalizeFlag)
%
%	This is similar to before but now the flag NormalizeFlag determines whether
% 	the new matrix is divided by the total number of variables added together.
%
%
%	NOTE: the variables must be global variables!!!
%	NOTE: the variables must be global variables!!!
%	NOTE: the variables must be global variables!!!
%	NOTE: the variables must be global variables!!!
%	NOTE: the variables must be global variables!!!
%	NOTE: the variables must be global variables!!!
%
%
% Jacco van Beek
% 27-08-'10

function Sum = addvariables2(CommonString, RetainFlag, NormalizeFlag)
  %
  %Check the number of input parameters
  %
  if (nargin == 1)
    RetainFlag = 0;
    NormalizeFlag = 0;
  end

  if (nargin == 2)
    NormalizeFlag = 0;
  end


  %
  %Extract and check the ranges first
  %
  QTEMP2 = findstr(CommonString, '$');
  QTEMP61 = CommonString( (QTEMP2(1)):(QTEMP2(2)) );
  try
    Range = eval(CommonString( (QTEMP2(1)+1):(QTEMP2(2)-1) ));
  end


  %
  %Make all variables in the range accessible to us in this function. This requires
  %all variables to be defined as global in the workspace.
  %
  for QTEMP = 1:length(Range)
    eval(['global ' strrep(CommonString, QTEMP61, num2str(Range(QTEMP), 10))]);
  end


  %
  %Perform a size and existence check
  %
  QTEMP11 = zeros(length(Range), 2);
  for QTEMP = 1:length(Range)
    eval(['QTEMP1 = ~exist(''' strrep(CommonString, QTEMP61, num2str(Range(QTEMP))) ''', ''var'');']);
    if isa(eval(strrep(CommonString, QTEMP61, num2str(Range(QTEMP)))), 'struct')  %yes it is a structure
      eval(['QTEMP1 = ~isfield(' strrep(CommonString, QTEMP61, num2str(Range(QTEMP))) ', ''Spectrum'');']);
      if (QTEMP1 == 0)
        eval(['QTEMP2 = isempty(' strrep(CommonString, QTEMP61, num2str(Range(QTEMP))) '.Spectrum);']);
      else
        QTEMP2 = 1;
      end

    else
      eval(['QTEMP2 = isempty(' strrep(CommonString, QTEMP61, num2str(Range(QTEMP))) ');']);
    end
    if (QTEMP1 | QTEMP2)
      disp('matNMR WARNING: non-existent or empty variable encountered in range. addvariables aborting ...');
      Sum = [];
      return
    end

    if isa(eval(strrep(CommonString, QTEMP61, num2str(Range(QTEMP)))), 'struct')  %yes it is a structure
      eval(['QTEMP11(QTEMP, :) = size(' strrep(CommonString, QTEMP61, num2str(Range(QTEMP))) '.Spectrum);']);

    else
      eval(['QTEMP11(QTEMP, :) = size(' strrep(CommonString, QTEMP61, num2str(Range(QTEMP))) ');']);
    end
  end
  if (sum(abs(diff(QTEMP11(:,1)))) > 1e-10) | (sum(abs(diff(QTEMP11(:,2)))) > 1e-10)
    beep
    disp('matNMR WARNING: spectra of unequal length encountered in range! addvariables aborting ...')
    return
  end




  %
  %Set Sum equal to the first variable
  %
  if (RetainFlag)
  				%check whether the variable is a structure
    if isa(eval(strrep(CommonString, QTEMP61, num2str(Range(1)))), 'struct')  %yes it is
      eval(['Sum = ' strrep(CommonString, QTEMP61, num2str(Range(1))) ';']);

    else  			       %no it isn't
      %
      eval(['Sum = ' strrep(CommonString, QTEMP61, num2str(Range(1))) ';']);
    end
  else
  				%check whether the variable is a structure
    if isa(eval(strrep(CommonString, QTEMP61, num2str(Range(1)))), 'struct')  %yes it is
      eval(['Sum = ' strrep(CommonString, QTEMP61, num2str(Range(1))) '.Spectrum;']);

    else  			       %no it isn't
      %
      eval(['Sum = ' strrep(CommonString, QTEMP61, num2str(Range(1))) ';']);
    end
  end


  %
  %Then do a loop over the rest of the range
  %
  if (RetainFlag)
    for QTEMP = 2:length(Range)
      eval(['global ' strrep(CommonString, QTEMP61, num2str(Range(QTEMP)))]);
  
  			       %check whether the variable is a structure
      if isa(eval(strrep(CommonString, QTEMP61, num2str(Range(QTEMP)))), 'struct')        %yes it is
        eval(['Sum.Spectrum = Sum.Spectrum + ' strrep(CommonString, QTEMP61, num2str(Range(QTEMP))) '.Spectrum;']);

      else			       %no it isn't
        %
        eval(['Sum = Sum + ' strrep(CommonString, QTEMP61, num2str(Range(QTEMP))) ';']);
      end
    end

  else
    for QTEMP = 2:length(Range)
      eval(['global ' strrep(CommonString, QTEMP61, num2str(Range(QTEMP)))]);
  
  			       %check whether the variable is a structure
      if isa(eval(strrep(CommonString, QTEMP61, num2str(Range(QTEMP)))), 'struct')        %yes it is
        eval(['Sum = Sum + ' strrep(CommonString, QTEMP61, num2str(Range(QTEMP))) '.Spectrum;']);

      else			       %no it isn't
        %
        eval(['Sum = Sum + ' strrep(CommonString, QTEMP61, num2str(Range(QTEMP))) ';']);
      end
    end
  end

  %
  %if asked for normalize by dividing by the total number of spectra in the range
  %
  if (NormalizeFlag)
    if (isstruct(Sum))
      Sum.Spectrum = Sum.Spectrum / length(Range);

    else
      Sum = Sum / length(Range);
    end
  end
