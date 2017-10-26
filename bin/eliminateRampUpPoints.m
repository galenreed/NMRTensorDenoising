function newFid =  eliminateRampUpPoints(fid, doPlot);



nPoints = 25;
newFid = fid;
newFid(1:nPoints) = [];

if(doPlot)
  subplot(1,2,1);
  plot(abs(fid));
  subplot(1,2,2);
  plot(abs(newFid));
end
  