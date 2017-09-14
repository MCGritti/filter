function [dTheta, dthetavec] = backpropagate(net, X, y)
%BACKPROPAGATE Retropopagação do erro.
    if size(X, 2) ~= net.neurons(1)
        error('Wrong input format');
    end

    m = size(X, 1);
    OnesVec = ones(m, 1);
    Z = cell(net.layers-1, 1);
    A = Z;

    A{1} = [OnesVec net.actFuncs{1}(X)];

    for k = 2:net.layers-1
        Z{k-1} = A{k-1}*net.theta{k-1};
        A{k} = [OnesVec net.actFuncs{k}(Z{k-1})];
    end

    Z{net.layers-1} = A{net.layers-1}*net.theta{net.layers-1};
    yp = net.actFuncs{net.layers}(Z{net.layers-1});

    er = yp - y;

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

    for p = 1:L-1
        dTheta{p} = A{p}'*delta{p}/m;
    end

    dthetavec = 0;
    for p = 1:L-1
        dthetavec = dthetavec + numel(dTheta{p});
    end
    dthetavec = zeros(dthetavec, 1);

    sum = 0;
    for p = 1:L-1
        dthetavec(1+sum:numel(dTheta{p})+sum) = dTheta{p}(:);
        sum = sum + numel(dTheta{p});
    end
end

