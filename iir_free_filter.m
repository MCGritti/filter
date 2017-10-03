%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @Author Marcos Cesar Gritti %
% @Date 30/08/2017            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y = iir_free_filter(x, w)
%IIR_FILTER Infinite Impulse Response
%   Filtro de resposta ao impulso infinita em batelada
%   y → Vetor do sinal filtrado
%   x → Vetor do sinal de entrada
%   a → Coeficiêntes das componentes auto-regressivas e de média-móvel
%
%   O filtro de resposta ao impulso infinito se comporta como 
%   um sistema linear (filtro passa baixa) com ganho K = 1. A
%   ordem do sistema do filtro iir é definida pela dimensão do
%   vetor de coeficientes 'a'. As primeiras 'k' amostras, onde 'k'
%   é a dimensão do vetor 'a', não são filtradas, uma vez que o 
%   sistema de filtragem necessita de um estado inicial.

% Assegura que os vetores de entrada são vetores coluna
if size( x, 1 ) < size( x, 2 )
    x = x';
end

if size( w, 2 ) < size( w, 1 )
    w = w';
end

% Assegura que a dimensão de w é um número par
L = length( w );
if mod( L , 2 )
    error( 'Dimensão de w deve ser par' );
end

y = x;
M = length( y );

a = w( 1:L/2 );
b = w( L/2+1:end );

alpha = 0.99;
for i = 2:L/2
    y(i) = alpha * y(i-1) + (1-alpha) * x(i);
end

ylags = 1:L/2;
xlags = ylags-1;

for i = L/2+1:M
    y(i) = a * y(i-ylags) + b * x(i-xlags);
end
