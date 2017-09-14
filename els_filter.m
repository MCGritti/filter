%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @Author Marcos Cesar Gritti %
% @Date 30/08/2017            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y = els_filter(x, m, w)
%ELS_FILTER Extended Least Squares Filter
%   Filtro de mínimos quadrados extendido
%   y → Vetor do sinal filtrado
%   x → Vetor do sinal de entrada
%   m → Tamanho de janela
%   w → Fator de esquecimento
%
%   O filtro baseado no método dos mínimos quadrados extendido
%   aplica regressão em uma janela móvel dos dados de entrada.
%   Esta implementação utiliza um fator de esquecimento, dando
%   ao usuário a capacidade de escolher a influência temporal
%   das amostras utilizadas para regressão. Quando w = 1, esta
%   implementação equivale ao comum método dos mínimos quadrados.
%   Nesta implementação, utiliza-se um vetor relativo de tempo
%   como variável exógena, mas caso existam variáveis exógenas
%   com maior significância, este pode ser re-implementado para
%   utiliza-las.

% Assegura que os vetores de entrada são vetores coluna
if size(x, 1) < size(x, 2)
    x = x';
end

y = x;
M = length(y);

% Variáveis de regressão 
T = (0:m - 1)' * 0.01;
O = ones(size(T));

W = diag(w.^((m-1):-1:0));
X = [O T T.^2];

for i = m+1:M
    x_range = x(i - m + 1:i);
    theta = (X'*W*X) \ X' * W* x_range;
    pred = X*theta;
    y(i) = pred(end);
end