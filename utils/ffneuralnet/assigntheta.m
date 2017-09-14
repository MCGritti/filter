function net = assigntheta(net, theta)
%ASSIGNTHETA Modifica os parâmetros da rede
    L = net.layers-1;
    sum = 0;
    for k = 1:L
        net.theta{k} = reshape(theta(1+sum:numel(net.theta{k})+sum), size(net.theta{k}));
        sum = sum + numel(net.theta{k});
    end
end
