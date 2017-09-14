function y = cels_filter(x, m, w)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @Author Marcos Cesar Gritti %
% @Date 30/08/2017            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CELS_FILTER Centered Extended Least Squares Filter
%   Filtro de mínimos quadrados extendido centrado
%   y → Vetor do sinal filtrado
%   x → Vetor do sinal de entrada
%   m → Tamanho de janela
%   w → Fator de esquecimento
%
%   O mesmo que ELS_FILTER, porém utiliza uma janela
%   simétrica. Não pode ser utilizado para filtragem
%   em tempo real, porém, tem ótima eficiência em 
%   aproximar o verdadeiro sinal de referência.

% Assegura que os vetores de entrada são vetores coluna
if size(x, 1) < size(x, 2)
    x = x';
end

y = x;
M = length(y);

% Variáveis de regressão 
T = (-m:m)' * 0.01;
O = ones(size(T));

W = diag(w.^(abs(-m:m)));
X = [O T T.^2];

for i = m+1:M-m-1
    x_range = x(i - m + 1:i + m + 1);
    theta = (X'*W*X) \ X' * W* x_range;
    pred = X*theta;
    y(i) = pred(m+1);
end