function [ J ] = kalmanFobj( params, data, k1, k2, k3, dt )
%KALMANFOBJ Summary of this function goes here
%   Detailed explanation goes here
    w = data(:,1);
    r = data(:,2);
    f = kalman1d(w, params(1:3));

    F = ohm2corr(f, k1, k2, k3);
    DF = [0; diff(F)] * dt;
    K = kalman1d(DF, params(4:6));
    K = iir_filter(K, params(7));
    
    J = sum((K - r).^2) / length(w);
end

