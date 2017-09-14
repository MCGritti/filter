function J = ffcost(net, X, y, theta)
%FFCOST Calcula a função custo da feedforward.
    if nargin > 3
        net = assigntheta(net, theta);
    end
    yp = propagate(net, X);
    [m, p] = size(y);

    J = 0;
    for k = 1:p
        J  = J + sum((yp(:,k) - y(:,k)).^2)/(2*m);
    end
end

