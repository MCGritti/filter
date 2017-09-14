function out = GAUSS(centro,data,cvar)
% out = gauss (centro, entradas, desvio)

% out    - matriz com (mxn)
% m      - numero de entradas
% n      - numero de clusters
% centro - matriz dos centros calculado pelo K-mean
% data   - matriz com entradas
% cvar   - vetor com desvio padrao dos centros

[nc,~] = size(centro);
[N,p]  = size(data);
out = zeros (N,nc);
for i=1:nc
  out(:,i) = (exp(-0.5*(((data-ones(N,1) * centro(i,:)).^2))*ones(p,1)/cvar(i)));
end
end