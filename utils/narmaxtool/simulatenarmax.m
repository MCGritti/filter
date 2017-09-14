function [ Ys ] = simulatenarmax( model, U, y0, sigma )
%SIMULATENARMAX Summary of this function goes here
%   Detailed explanation goes here

    pattern = '(?<function>[a-zA-Z0-9]*)\(?(?<term>[yue])(?<index>[0-9]*)\(k-(?<lag>[0-9]+)||(?<term>constant)';
    D  = model.ProcessTerms;
    DE = model.NoiseRelatedTerms;
    cfuncs = model.CustomFunctions;
    
    if sigma == 0
        theta = [model.ProcessTheta];
        RD = cellfun(@(x) regexp(x, pattern, 'names'), D, 'UniformOutput', false);
    else
        theta = [model.ProcessTheta; model.NoiseTheta];
        RD = cellfun(@(x) regexp(x, pattern, 'names'), [D;DE], 'UniformOutput', false);
    end
    
    N = size(U, 1);
    M = length(theta);
    Ys = zeros(N, 1);
    Es = sigma*randn(N, 1);
    
    initlag = 2;
    if ~isempty(y0)
        if isrow(y0)
            y0 = y0';
        end
        IC = length(y0);
        Ys(1:IC) = y0;
        initlag = IC+1;
    end
    
    mlength = 0;
    for k = initlag:N
        if ~mod(k, 50) || k == initlag || k == N
            while mlength > 0
                fprintf('\b');
                mlength = mlength - 1;
             end
        % mlength = fprintf('Simulation %3d%% completed\n',round(100*k/N));
        end
        for m = 1:M
            term = 1;
            for j = 1:length( RD{m} )
                lag = str2double( RD{m}(j).lag );
                if k - lag < 1
                    term = 0;
                    break;
                end
                index = str2double( RD{m}(j).index );
                if isnan(index)
                    index = 1;
                end
                switch RD{m}(j).term
                    case 'y'
                        element = Ys(k-lag, index);
                    case 'u'
                        element = U(k-lag, index);
                    case 'e'
                        element = Es(k-lag, index);
                    case 'constant'
                        element = theta(m);
                    otherwise
                end
                if ~isempty ( RD{m}(j).function )
                    fidx = cellfun ( @(x) strcmp( RD{m}(j).function, x{1} ), cfuncs);
                    if ~any( fidx )
                        error('Function %s not founded in the function handlers', RD{m}(j).function);
                    else
                        term = term*cfuncs{fidx}{2}(element);
                    end
                else
                    term = term*element;
                end
            end
            Ys(k) = Ys(k) + theta(m)*term;
        end
        
    end
end

