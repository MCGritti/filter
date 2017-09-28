function [ yOut ] = corr2ohm( yIn, k1, k2, k3 )

    yOut = k2/k3 - k1 ./ (yIn * k3);

end