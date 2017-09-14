function [ yOut ] = kalman1d( yIn, s0 )

    yOut = zeros(size(yIn));
    yOut(1) = yIn(1);
    yOut(2) = yIn(2);
    
    p = s0(1);
    q = s0(2);
    r = s0(3);
    
    for i = 3:length(yIn)
        x = yOut(i-1) + 0.01*(yOut(i-1) - yOut(i-2));
        p = p + q;
        
        k = p/(p + r);
        yOut(i) = x + k * (yIn(i) - x);
        p = (1 - k) * p;
    end
    


end

