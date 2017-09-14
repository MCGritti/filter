function R2 = calc_R2(real,est)
%R2: coeficiente de correlação múltipla

    SSE = sum((real - est).^2);
    avg_real = mean(real);
    sum2 = sum((real - avg_real).^2);
    % R2 = 1 - ( sum((real-est).^2) ./ sum((aux_R2).^2));
    R2 = 1 - SSE / sum2;

end