function [phi0] = phaseCorrectSpectra(spec)
  
max_val = max(spec);  
max_x = find(spec == max_val);
entropy_min = ACMEentropy_fun([0,0], spec(max_x), max_x);
theta = 0;
for psi = 1:360
    entropy_value = ACMEentropy_fun([psi,0], spec(max_x), max_x);
    %disp("entropy_value ="); disp(entropy_value);
    if(entropy_value < entropy_min)
        entropy_min = entropy_value;
        theta = psi;
    end    
end 

phi0 = theta;




%Set the range. In this case 11498 Hz =165 ppm
%max_ppm=(offset-11498+sw/2)/32.1468+165.0;
%min_ppm=(offset-11498-sw/2)/32.1468+165.0;
%ppm = linspace(max_ppm,min_ppm,(ft_pts+zerofill));  % for 3T
%For each spectra, inverse FT back to the FID, apply the phase shift, and
%then FT it back again
%nt = size(data,2);
%for ii=1:nt

%    sp2=fftshift(squeeze(sp(ii,:)));
%    sp2=real(fft(ifft(sp2)* exp((-1)^(0.5)*theta*pi/180)));
%    sp3(:,ii)=sp2;

%end
%newSpec = sp3;

end