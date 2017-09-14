function [ means, covar, rot, sigma, groups, varargout ] = kmeans( X, K, iterations, alpha )
%KMEANS Algor�tmo de clusteriza��o que encontra em 'X' 
%   'K' clusters, e retorna suas respectivas m�dias e 
%   covari�ncias (para modelos gaussianos).
%
%   << inputs >> 
%           X :     Vetor de dados.
%           K :     N�mero de clusters.
%  iterations :     M�ximo n�mero de itera��es.
%       alpha :     Fator de amortecimento.
%
%   << outputs >>
%       means :     Vetor cell com as cent�ides dos 'clusters'.
%         cov :     Vetor cell com as matrizes de covari�ncia.

means = cell(K, 1);
covar   = cell(K, 1);
rot   = cell(K, 1);


[samples, dimension] = size(X);
initial_indexes = randperm(samples, K);
groups          = zeros(samples, 1);
distances       = zeros(samples, K);
mindist         = zeros(samples, 1);

if nargout > 5
  meanspath       = cell(K, 1);
  haspath = 1;
else
  haspath = 0;
end

for k = 1:K
  means{k} = X(initial_indexes(k), :);
  if haspath
    meanspath{k} = zeros(iterations+1, dimension);
    meanspath{k}(1,:) = means{k};
  end
  covar{k}   = zeros(dimension);
end

for i = 1:iterations
  % Compute distances
  for k = 1:K
    distances(:,k) = sqrt(sum((X - repmat( means{k}, samples, 1 )).^2, 2));
  end
  
  % Classify
  groups(:) = 1;
  mindist = distances(:,1);
  for k = 2:K
    minidxs = distances(:,k) < mindist;
    groups(minidxs) = k;
    mindist(minidxs) = distances(minidxs,k);
  end
  
  % Update
  for k = 1:K
    %means{k} = alpha*means{k} + (1-alpha)*(mean( X( groups == k, :) ) - means{k});
    newcoord = mean( X(groups==k,:) );
    means{k} = means{k} + alpha*(newcoord - means{k});
  end
  
  if haspath
    for k = 1:K
      meanspath{k}(i+1,:) = means{k};
    end
  end
 
end

if haspath
  varargout{1} = meanspath;
end

% Compute distances
for k = 1:K
  distances(:,k) = sqrt(sum((X - repmat( means{k}, samples, 1 )).^2, 2));
end

% Classify
groups(:) = 1;
mindist = distances(:,1);
for k = 2:K
  minidxs = distances(:,k) < mindist;
  groups(minidxs) = k;
  mindist(minidxs) = distances(minidxs,k);
end

for k = 1:K
  covar{k} = cov( X( groups == k, :) );
  [rot{k}, sigma{k}] = eig(covar{k});
end

end

