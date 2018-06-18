%% Calculating angle
function deg=CalculateInvariantAngle(chA, chB)
    epsilon=1e-3;
    histBins=zeros(64,1);
    subs=1;
    for angle=0:0.01:pi
         inv=255*(cos(angle)*(chA) - sin(angle)*(chB));
         inv=inv-min(min(inv));
         inv = inv*255/max(max(inv));
         inv=round(inv);
         u=1;
         for i=0:4:255
            [m n]=size(find(inv>=i & inv<=(i+3)));
            histBins(u)=m;
            u=u+1;
         end    
%   Entropy calculation
        [m n]=size(inv);
        histBins = histBins / (m*n);
        histBins(find(histBins == 0))=epsilon;
        logs = log(histBins);
        res = histBins .* logs;
        eta(subs) = sum(res)*-1;
        subs=subs+1;       
    end
    plot(eta)
    deg = find(eta==min(eta))-1;
    deg
   
