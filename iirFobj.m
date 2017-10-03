function [ J ] = iirFobj( params, data )
%KALMANFOBJ Summary of this function goes here
%   Detailed explanation goes here
    w = data(:,1);
    r = data(:,2);
    df = iir_filter(w, params);
    
    J = sum((df - r).^2) / length(df);
end
