function [net, costHistory, states] = lmtrain(net, X, y, mu, iter)
%LMTRAIN Algorítmo de Levenberg-Marquart (Quasi-Newton vs Gradiente)
    costHistory = zeros(iter+1, 1);
    actTheta = gettheta(net);
    states = zeros(size(actTheta, 1), iter+1);
    states(:, 1) = actTheta;
    %m = size(X, 1);
    n = length(actTheta);
    %Jac = zeros(m, n);

    for i = 1:iter
        J = ffcost(net, X, y, states(:, i));
        costHistory(i) = J;
        if rem(i,100)==0
            fprintf('Iteration %d, Cost %.4e\n', i, J);
        end

        %for k = 1:m
        %    dtheta = backpropagatevec(net, X(k,:), y(k,:), states(:, i));
        %    Jac(k, :) = -dtheta;
        %end
        Jac = backpropagatelm(net, X, y, states(:, i))/2;

        %error = net.propagate(X, states(:, i)) - y;
        error = y - propagate(net, X, states(:, i));
        H = Jac'*Jac;
        delta = (H + mu*eye(n))\Jac'*error;
        ro = delta'*delta/(delta'*H*delta);
        if ffcost(net, X, y, states(:,i) + ro*delta) < J
            states(:, i+1) = states(:, i) + ro*delta;
            mu = mu*0.2;
        else
            states(:, i+1) = states(:, i);
            mu = mu*10;
            if mu > 1e10
                mu = 1e10;
            end
            if mu == 0
                mu = 1e-6;
            end
        end
    end

    net = assigntheta(net, states(:, i));
    J = ffcost(net, X, y);
    costHistory(iter+1) = J;
    fprintf('Terminated with Cost %.4e\n', J);
end
