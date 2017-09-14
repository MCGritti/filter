function [ sidxs, ERR, stats ] = forwardselect( X, y, varargin )
%FORWARDSELECT Algoritmo de seleção de variáveis do tipo à frente.
%  Recebe como argumento a matriz design (inputs do sistema) X e a
%  matriz de saídas (y). Retorna ao usuário os indices de X, ordenados
%  através da métrica ERR, que melhor explicam a variancia de y.
%       Sintaxe:
%           [ sidxs, ERR, plus ] = FORWARDSELECT(X, y, ...);
%
%   <Inputs>
%       X  : Entradas
%       y  : Saidas
%     ...  : Argumentos opcionais (listados adiante)
%
%   <Outputs>
%   sidxs  : Indice das colunas selecionadas, ordenadas de acordo com ERR
%     ERR  : err calculado para cada indice
%   stats  : Cluster contendo informações estatíticas sobre os indices
%            selecionados.
%
%  Os argumentos opcionais (...) são listados abaixo:
%
%  'nvars'    : Número máximo de variaveis a selecionar.
%               (Critério de parada).
%  'maxSERR'  : Quantidade esperada de explicação de variancia de y, ou seja
%               a soma de ERR. (Critério de parada).
%  'verbose'  : Apresenta na linha de comando o que está acontecendo.
%               (0: false, 1: true)
%  'varnames' : Se verbose está setado e varnames não é um conjunto cell
%               nulo, apresenta os resultados utilizando 'varnames'.
%               varnames deve ser um vetor cell com P colunas, uma para
%               cada coluna de X.

[M, P] = size(X);
assert( M == size(y, 1), 'A matriz de entrada e o vetor de saida sao incompativeis.');

[nvars, maxSERR, verbose, varnames, spacing] = argparser( {'nvars', 'maxSERR', 'verbose', 'varnames', 'spacing'}, ...
                                                 {P, 1, 0, cell(0), 13}, ...
                                                 {'double', 'double', 'double', 'cell', 'double'}, ...
                                                 varargin );
                                             
outargs = nargout;
hasStats = outargs > 2;

if verbose
    if isempty(varnames)
        varnames = cell(1,P);
        for k = 1:P
            varnames{k} = sprintf('Col. %d', k);
        end
    end
    assert( length(varnames) == P, 'Erro com o conjunto de nomes.');
    fprintf('%*s %*s %*s %*s\n', ...
                 spacing, 'Indice', ...
                 spacing, 'Nome', ...
                 spacing, 'ERR', ...
                 spacing, 'SERR');
end

Q = zeros(M, nvars);
R = zeros(nvars, nvars);
sidxs = zeros(nvars, 1);
ERR   = zeros(nvars, 1);
inner = zeros(1, nvars);
sigma = y'*y;
g     = zeros(nvars, 1);
n = 1;
stopFlag = 0;

while n <= nvars && ~stopFlag
    stepR     = zeros(n, nvars);
    stepErr   = zeros(1, nvars);
    stepInner = zeros(1, nvars);
    stepG     = zeros(1, nvars);
    for k = 1:P
        if ~any(k == sidxs)
            Q(:,n) = X(:,k);
            stepR(n, k) = 1;
            for j = n-1:-1:1
                stepR(j, k) = X(:,k)'*Q(:,j) / inner(j) ; 
                Q(:,n) = Q(:,n) - stepR(j, k) * Q(:,j);
            end 
            stepInner(k) = Q(:,n)'*Q(:,n);
                stepG(k) = ( Q(:,n)'*y ) / stepInner(k);    
              stepErr(k) = ( stepG(k) ^ 2 ) * stepInner(k) / sigma; 
        end
    end
    
    [maxVal, idx] = max(stepErr);
     ERR(n)    = maxVal;
     sidxs(n)  = idx;
     inner(n)  = stepInner(idx);
     R(1:n, n) = stepR(:, idx)';
     g(n) = stepG(idx);
     Q(:,n) = X(:, idx);
     for j = n-1:-1:1
         Q(:,n) = Q(:,n) - R(j, n)*Q(:,j);
     end
     
     if verbose
         fprintf('%*d %*s %*.3f%% %*.3f%%\n', ...
                 spacing, idx, ...
                 spacing, varnames{idx}, ...
                 spacing, maxVal * 100, ...
                 spacing, sum(ERR(1:n)) * 100);
     end
     
     if sum(ERR(1:n)) > maxSERR
         stopFlag = 1;
     end
     n = n + 1;
end

if hasStats
    sidxs(n:end) = [];
    R(n:end, n:end) = [];
    g(n:end) = [];
    
    theta = R\g;
    Z = X(:,sidxs);
    sigma2 = var( y - Z*theta );
    thetaVar = sigma2*eye(size(Z,2)) / (Z'*Z);
    tvalue = theta ./ sqrt( diag( thetaVar ) ) ;
    df     = size(Z,1) - size(Z,2);
    pvalue = 2*tcdf( -abs(tvalue), df);
    
    stats.theta   = theta;
    stats.tvalues = tvalue;
    stats.pvalues = pvalue;
    
    if verbose
        fprintf('\nSumario:\n\n');
        % Variavel Coeficiente Valor-T Valor-P Pertinente
        fprintf('%*s %*s %*s %*s %*s\n', spacing, 'Variavel', ...
            spacing, 'Coef.', ...
            spacing, 'ERR', ...
            spacing, 'Val-T', ...
            spacing, 'Val-P');
        
        for j = 1:length(g)
            fprintf('%*s %*.4e %*.3f%% %*.4f %*.4f', spacing, varnames{sidxs(j)}, ...
                                                  spacing, stats.theta(j), ...
                                                  spacing, ERR(j)*100, ...
                                                  spacing, stats.tvalues(j), ...
                                                  spacing, stats.pvalues(j));
            if stats.pvalues(j) < 0.025
                fprintf(' **\n');
            else
                fprintf('\n');
            end
        end
    end
                                           
end

