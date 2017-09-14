function [ yOut ] = ohm2corr( yIn, k1, k2, k3 )

    yOut = k1 ./ (k2 - k3*yIn);

end

