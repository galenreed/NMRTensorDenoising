function [Nt] = calculateSVDThreshold(sv, thresholdFrac)
  if(frac > 1.0
    disp('input frac should be <= 1');
    return();
  end
  totalEnergy = norm(sv,2)^2;
  energySum = 0;
  ii = 1;
  Nt = 1;
  while(ii <= length(sv))
    energySum = energySum + sv(ii) * conj(sv(ii)); % should be real but just in case
    energyFrac = energySum / totalEnergy;
    if(energyFrac >= thresholdFrac)
      Nt = ii-1;
      break;
    end
  end
end