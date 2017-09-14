function [f, x, saida_estimada, pesosout] = rbf_custo(x,n_ent,n_neu,INPUTS,OUTPUTS)

centros = zeros(n_neu,n_ent);
for i=1:n_neu
    centros(i,:) = x(1,(i-1)*n_ent + 1 : n_ent*i);
end

% spread
aberturas = x(n_ent * n_neu + 1 : end);

%--- Gauss
saida_camada_oculta = GAUSS(centros, INPUTS, aberturas);

%--- treinar usando a pseudoinversa
gm = pinv(saida_camada_oculta);

%--- determinar os pesos da camada de saída
pesosout = (gm * OUTPUTS)';

%--- o "Purelin" vai retornar a saída linear
saida_estimada = purelin(pesosout * saida_camada_oculta')';

% erro do treinamento
[MSE,~] = CalculaErros(OUTPUTS, saida_estimada);

f = MSE;

end