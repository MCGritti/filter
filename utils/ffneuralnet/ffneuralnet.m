function net = ffneuralnet(neurons)
    %NEURALNET Rede neural do tipo feedforward
    %   A rede pode utilizar qualquer função de ativação,
    %   desde que sejam passadas suas derivadas.
    %
    %   Como o código foi adaptado a structs,
    %   o usuário deve configurar a rede diretamente pela
    %   struct 'net' retornada por essa função.

    net.layers = [];
    net.neurons = [];
    net.theta = [];
    net.actFuncs = [];
    net.dactFuncs = [];

    if ~isrow(neurons)
        error('''neurons'' must be a row vector');
    end
    net.layers  = length(neurons);
    net.neurons = neurons;
    net.theta   = cell(net.layers-1,1);
    net.actFuncs = cell(net.layers, 1);
    net.dactFuncs = cell(net.layers, 1);
    for k = 1:net.layers-1
        net.theta{k} = 2*rand(neurons(k)+1, neurons(k+1)) - 1;
    end

    net.actFuncs{1} = @(x) x;
    net.dactFuncs{1} = @(x) ones(size(x));
    for k = 2:net.layers-1
        net.actFuncs{k} = @(x) tansig(x);
        net.dactFuncs{k} = @(x) 4*logsig(2*x).*(1 - logsig(2*x));
    end
    net.actFuncs{net.layers} = @(x) x;
    net.dactFuncs{net.layers} = @(x) ones(size(x));
end

