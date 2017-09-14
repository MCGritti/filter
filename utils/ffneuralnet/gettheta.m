function theta = gettheta(net)
%GETTHETA Retorna os parâmetros da rede em um vetor coluna.
    theta = 0;
    L = net.layers;
    for p = 1:L-1
        theta = theta + numel(net.theta{p});
    end
    theta = zeros(theta, 1);

    sum = 0;
    for p = 1:L-1
        theta(1+sum:numel(net.theta{p})+sum) = net.theta{p}(:);
        sum = sum + numel(net.theta{p});
    end
end

