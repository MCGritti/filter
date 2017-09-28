function [ J ] = kalmanFobj( params, data, k1, k2, k3, dt )
%KALMANFOBJ Summary of this function goes here
%   Detailed explanation goes here
    w = diffThreshold(data(:,1), 4e-4);
    r = data(:,2);
    f = kalman1d(w, params(1:3));
    changes = find([0; diff(r)] ~= 0);
    inverted = 1;

    F = ohm2corr(f, k1, k2, k3);
    DF = [0; diff(F)] * dt;
    K = kalman1d(DF, params(4:6));
    %K = iir_filter(K, params(7));
    
    J = 0;
    lastIdx = 1;
    for i = 1:length(changes)
        auxK = K(lastIdx:changes(i));
        auxR = r(lastIdx + 1);
        auxT = (0:length(auxK)-1)'*0.1;
        if inverted
            auxT = auxT(end:-1:1);
        end
        
        J = J + sum(((auxK - auxR).*auxT).^2) / length(auxK);
        lastIdx = changes(i);
    end
    
    auxK = K(lastIdx:end);
    auxR = r(lastIdx + 1);
    auxT = (0:length(auxK)-1)'*0.01;
    if inverted
        auxT = auxT(end:-1:1);
    end
        
    J = J + sum(((auxK - auxR).*auxT).^2) / length(auxK);
end

