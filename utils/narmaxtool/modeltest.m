function Ys = modeltest(U, y0, sigma)

    N = size(U, 1);

    if isempty(y0)
        initindex = 2;
    else
        if isrow(y0)
            y0 = y0';
        end
        initindex = length(y0) + 1;
    end
    partialindex = 2;

    Ys = zeros(N, 1);
    E  = sigma*randn(N, 1);
    Ys(1:length(y0)) = y0;

    
    theta    = [-0.634949104880528692
				+0.556691848710095916
				-0.191603914283648785
				+0.181741733193225286
				-0.334336965164596656
				];
    termlist = {'Ys(k-1)'; ...
				'U(k-1,1)'; ...
				'U(k-2,1)'; ...
				'Ys(k-1)*Ys(k-2)'; ...
				'E(k-1)'; ...
				};

    M = length(termlist);
   
    for k = initindex:partialindex
        for m = 1:M
            try
                eval(sprintf('term = %s;', termlist{m}));
            catch
                term = 0;
            end
            Ys(k) = Ys(k) + theta(m)*term;
        end    
    end

    nprint = 0;
    for k = partialindex+1:N
        if k == partialindex + 1 || ~mod(k, 50) || k == N
            while nprint > 0
                fprintf('\b');
                nprint = nprint - 1;
            end
            nprint = fprintf('Simulation %3d%% completed\n', round(100*k/N));
        end
        Ys(k) = [Ys(k-1) U(k-1,1) U(k-2,1) Ys(k-1)*Ys(k-2) ...
				E(k-1) ]*theta + E(k);
    end

end
