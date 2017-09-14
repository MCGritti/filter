%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @Author Marcos Cesar Gritti %
% @Date 30/08/2017            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y = iir_filter(x, a)
%IIR_FILTER Infinite Impulse Response
%   Filtro de resposta ao impulso infinita em batelada
%   y → Vetor do sinal filtrado
%   x → Vetor do sinal de entrada
%   a → Coeficiêntes das componentes auto-regressivas
%
%   O filtro de resposta ao impulso infinito se comporta como 
%   um sistema linear (filtro passa baixa) com ganho K = 1. A
%   ordem do sistema do filtro iir é definida pela dimensão do
%   vetor de coeficientes 'a'. As primeiras 'k' amostras, onde 'k'
%   é a dimensão do vetor 'a', não são filtradas, uma vez que o 
%   sistema de filtragem necessita de um estado inicial.

% Assegura que os vetores de entrada são vetores coluna
if size(x, 1) < size(x, 2)
    x = x';
end

y = x;
M = length(y);
L = length(a);

% Garantindo ganho K = 1
b = 1 - sum(a);

for i = 1 + L : M
    y(i) = a(1) * y(i-1) + b * x(i-1);
    for j = 2:L
        y(i) = y(i) + a(j) * y(i-j);
    end
end