function plotIIR_FFT(params)
    % param = [a1 a2 b1 b2]
    % y[k] = a1 y[k-1] + a2 y[k-2] + b1 u[k] + b2 u[k-1]
    % First condition -> (1 - a1 - a2) = (b1 + b2)
    % z² Y - a1 z Y - a2 Y = b1 z² U + b2 z U
    % Y ( z² - a1 z - a2 ) = U ( b1 z² + b2 z )
    % Y / U = (b1 z² + b2 z) / (z² - a1 z - a2)
    % H = Y / U = H( e^jw )
    
end