function [net, costHistory, states] = gdtrain(net, X, y, alpha, iter)
%GDTRAIN Simplest gradient descent method.
    costHistory = zeros(iter+1, 1);
    actTheta = gettheta(net);
    states = zeros(size(actTheta, 1), iter+1);
    states(:, 1) = actTheta;
    
    for i = 1:iter
        J = ffcost(net, X, y);
        costHistory(i) = J;
        if rem(i,100)==0
            fprintf('Iteration %d, Cost %.4e\n', i, J);
        end
        [dTheta, vec] = backpropagate(net, X, y);
        for k = 1:net.layers-1
            net.theta{k} = net.theta{k} - alpha*dTheta{k};
        end
        states(:, i+1) = states(:, i) - alpha*vec;
    end

    J = ffcost(net, X, y);
    costHistory(iter+1) = J;
    fprintf('Terminated with Cost %.4e\n', J);
end

