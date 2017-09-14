function dthetavec = backpropagatevec(net, X, y, theta)
%BACKPROPAGATEVEC Retropopagação vetorial
    if nargin > 3
        net = assigntheta(net, theta);
    end
    [~, dthetavec] = backpropagate(net, X, y);
end

