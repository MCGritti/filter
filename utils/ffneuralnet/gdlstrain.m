function [net, costHistory, states] = gdlstrain(net, X, y, alpha0, iter)
%GDLSTRAIN Basic gradient descent with linear search.
    costHistory = zeros(iter+1, 1);
    actTheta = gettheta(net);
    states = zeros(size(actTheta, 1), iter+1);
    states(:, 1) = actTheta;
    order = length(actTheta);
    H = eye(order);
    epst = 1e-5;
    sk   = epst*ones(order, 1);
    lastr = [];

    for i = 1:iter
        J = ffcost(net, X, y);
        costHistory(i) = J;
        if rem(i,100)==0
            fprintf('Iteration %d, Cost %.4e\n', i, J);
        end
        [~, r] = backpropagate(net, X, y);

        %Estimate hessian
        if i == 1
            yk = backpropagatevec(net, X, y, states(:, i) + sk) - r;
        else
            yk = r - lastr;
        end
        pk = yk'*sk;
        tvec = eye(order) - sk*yk'/pk;
        H = tvec'/H*tvec + sk*sk'/pk;

        % Lin Search
        alpha = r'*r/(r'/H*r);

        % Update
        if ffcost(net, X, y, states(:, i) - alpha*r) < J
            states(:, i+1) = states(:, i) - alpha*r;
            sk = states(:, i+1) - states(:, i);
            lastr = r;
        else
            if ffcost(net, X, y, states(:, i) - alpha0*r) > J
                if alpha0 > 1e-4
                    alpha0 = alpha0*0.5;
                end
                states(:, i+1) = states(:, i);
                sk = epst*ones(order, 1);
                lastr = zeros*ones(order, 1);
            else
                states(:, i+1) = states(:, i) - alpha0*r;
                sk = states(:, i+1) - states(:, i);
                lastr = r;
                alpha0 = alpha0*1.25;
            end
        end
        net = assigntheta(net, states(:, i+1));

    end

    J = ffcost(net, X, y);
    costHistory(iter+1) = J;
    fprintf('Terminated with Cost %.4e\n', J);
end

