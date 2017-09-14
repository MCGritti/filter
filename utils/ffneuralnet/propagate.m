function y = propagate(net, X, theta)
%PROPAGATE Propaga sinal de entrada através
%          da feedforward.
%
% <Inputs>
% net: Objeto (structure) de rede
% X  : Matriz de entrada
% theta: Parâmetro opcional, utilizado em otimização
%
% <Outputs>
% y  : Vetor/Matrix de saída

    if size(X, 2) ~= net.neurons(1)
        error('Wrong input format');
    end

    if nargin > 2
        net = assigntheta(net, theta);
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
    y = net.actFuncs{net.layers}(Z{net.layers-1});
end

