function [ Z ] = makeReference( u, T, tau )
%MAKEREFERENCE Cria referências com regime transitório
% u:      Sinal de referencia estatico
% tau:    Tau do sistema gerador de referência

N = size(u, 1);
Z = zeros(N, 1);
Z(1) = u(1);

% dx/dt + lambda * x = u
% ( x(k) - x(k-1) ) / T  + lambda x(k-1) = u(k-1)
% x(k) - x(k-1) + T * lambda x(k-1) = T*u(k-1)
% x(k) + x(k-1)(T * lambda - 1) = T*u(k-1)
% x(k) = 

alpha = 1 - T / tau;
beta  = 1 - alpha;

for i = 2:N
    if u(i) < u(i-1)
        onDecrease = 1;
    else
        onDecrease = 0;
    end
    if onDecrease
        Z(i) = u(i);
    else
        Z(i) = alpha * Z(i-1) + beta * u(i-1);
    end
end

end

