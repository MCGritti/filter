function [net, costHistory, states] = scgtrain(net, X, y, iter)
%SCGTRAIN Scaled Conjugate Gradient Descent
    wk = gettheta(net);
    sigma = 0.5;
    lambda = 0.8;
    lambdaMean = 0;
    states = zeros(length(wk), iter +1);
    states(:, 1) = wk;

    P = length(wk);
    success = 1;
    stopFlag = 0;

    costHistory = zeros(iter + 1, 1);
    k = 1;
    rk = - backpropagatevec(net, X, y, wk);
    pk = rk;

    while ~stopFlag
        J = ffcost(net, X, y, wk);
        costHistory(k) = J;
        if rem(k,100)==0
            fprintf('Iteration %d, Cost %.4e\n', k, J);
        end
        pkNorm = sum(sqrt(pk.^2));
        if success
            sigmak = sigma/pkNorm;
            sk     = (backpropagatevec(net, X, y, wk + sigmak*pk) + rk)/sigmak;
            deltak = pk'*sk;
        end

        % Scale sk
        sk = sk + (lambda - lambdaMean)*pk;
        deltak = deltak + (lambda - lambdaMean)*pkNorm^2;

        % If deltak lesser than 0, then make the Hessian Matrix
        % positive definite
        if deltak <= 0
            sk = sk + (lambda - 2*deltak/(pkNorm^2))*pk;
            lambdaMean = 2*(lambda - deltak/(pkNorm^2));
            deltak = -deltak + lambda*pkNorm^2;
            lambda = lambdaMean;
        end

        % Calculate step size
        muk = pk'*rk;
        alphak = muk/deltak;

        % Calculate comparison parameter
        DELTA = 2*deltak*(J - ffcost(net, X, y, wk+alphak*pk))/(muk^2);

        if DELTA >= 0
            wk = wk + alphak*pk;
            rkold = rk;
            rk = -1*backpropagatevec(net, X, y, wk);
            lambdaMean = 0; success = true;
            if mod(k, P)
                pk = rk;
            else
                betak = (sum(rk.^2) - rk'*rkold)/muk;
                pk = rk + betak*pk;
            end
            if DELTA >= 0.75
                lambda = lambda/2;
            end
        else
            lambdaMean = lambda;
            success = 0;
        end

        if DELTA < 0.25
            lambda = lambda*4;
        end

        if k == iter || all(abs(rk) < 1e-12);
            stopFlag = 1;
        end

        states(:, k+1) = wk;
        k = k + 1;
    end

    states(:, k+1:end) = [];

    J = ffcost(net, X, y, wk);
    costHistory(iter+1) = J;
    net = assigntheta(net, wk);
    %fprintf('Terminated with Cost %.4e\n', J);
end

