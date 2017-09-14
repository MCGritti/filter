function [ y ] = linrect( x )
%LINRECT Função linear retificada
%   Aplica sobre o sinal de entrada 'x' a função
%   linear retificada definida por:
%   - y = x, se x >= 0
%   - y = 0, caso contrário

y = x;
y(y<0) = 0;

end

