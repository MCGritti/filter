% Forwardselect
% Utilizou-se o seguinte sistema para testar o algoritmo:

N = 1000;

% Todas as variáveis são aleatórias, exceto x3
x1 = 2*randn(N, 1);
x2 = 2*rand(N, 1);
x4 = 2*randn(N, 1);
e  = randn(N, 1);
nu = randn(N, 1);

x3 = 0.45*x1 + 0.6*x2 + 2*nu;
y = x1 + x2 + x4 + e;

X = [x1 x2 x3 x4 randn(N, 2)];

[sidxs, ERR, stats] = forwardselect(X, y, 'nvars', 3, 'ver', 0);

%%sidxs
%%ERR
%%sum(ERR)


% theta = pinv(X)*y;           % Calcula theta medio
% sigma2 = var( y - X*theta ); % Variancia do erro
% thetaVar = sigma2*eye(size(X,2)) / (X'*X);
% tvalue = theta ./ sqrt( diag( thetaVar ) ) ;
% df     = size(X,1) - size(X,2);
% pvalue = 2*tcdf( -abs(tvalue), df);
% pvalue < 0.025;
%%theta(sidxs)
%%inv(R)*g