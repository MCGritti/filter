function J = backpropagatelm(net, X, y, theta)
%BACKPROPAGATELM Algoritmo de retropopaga��o para m�todo de
%                Levenberg-Marquardt

    if size(X, 2) ~= net.neurons(1)
        error('Wrong input format');
    end

    if nargin > 3
        net = assigntheta(net, theta);
    end

    m = size(X, 1);
    OnesVec = ones(m, 1);
    Z = cell(net.layers-1, 1);
    A = Z;
    J = zeros(m, length(theta));

    A{1} = [OnesVec net.actFuncs{1}(X)];

    for k = 2:net.layers-1
        Z{k-1} = A{k-1}*net.theta{k-1};
        A{k} = [OnesVec net.actFuncs{k}(Z{k-1})];
    end

    Z{net.layers-1} = A{net.layers-1}*net.theta{net.layers-1};
    %yp = net.actFuncs{net.layers}(Z{net.layers-1});

    er = ones(size(y));

    dTheta = cell(net.layers-1, 1);
    for k = 1:net.layers-1
        dTheta{k} = zeros(size(net.theta{k}));
    end

    % TODO: Subtract 1 from delta and Z index
    L = net.layers;
    delta = cell(L-1, 1);

    delta{L-1} = er.*net.dactFuncs{L}(Z{L-1});
    for p = L-1:-1:2
        delta{p-1} = (delta{p}*net.theta{p}(2:end,:)').*net.dactFuncs{p}(Z{p-1});
    end

    dthetavec = 0;
    for p = 1:L-1
        dthetavec = dthetavec + numel(dTheta{p});
    end
    dthetavec = zeros(dthetavec, 1);

    for k = 1:m
        for p = 1:L-1
            dTheta{p} = A{p}(k, :)'*delta{p}(k, :);
        end

        sum = 0;
        for p = 1:L-1
            dthetavec(1+sum:numel(dTheta{p})+sum) = dTheta{p}(:);
            sum = sum + numel(dTheta{p});
        end

        J(k, :) = dthetavec;
    end
end

