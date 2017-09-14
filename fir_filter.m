%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @Author Marcos Cesar Gritti %
% @Date 30/08/2017            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y = fir_filter(x, w)
%FIR_FILTER Finite Impulse Response
%   Filtro de resposta ao impulso finita em batelada
%   y → Vetor do sinal filtrado
%   x → Vetor do sinal de entrada
%   w → Vetor de parâmetros do filtro
%
%   O filtro de resposta ao impulso finito realiza uma média
%   ponderada entre as últimas 'k' amostras do sinal de entrada
%   'x', sendo 'k' a dimensão do vetor de parâmetros 'w'. Nesta
%   implementação, as primeiras 'k' amostras de 'x', não são 
%   filtradas, mas este detalhe pode ser alterado facilmente
%   em futuras implementações.

% Assegura que os vetores de entrada são vetores coluna
if size(x, 1) < size(x, 2)
    x = x';
end
if size(w, 1) < size(w, 2)
    w = w';
end

% Normaliza o vetor de parâmetros 'w'
w = w / sum(w);

y = x;
M = length(y);
L = length(w);

for i = L : M
    y(i) = x(i - L + 1: i)' * w;
end