function Ys = modeloNOx(U, y0, sigma)

    N = size(U, 1);

    if isempty(y0)
        initindex = 2;
    else
        if isrow(y0)
            y0 = y0';
        end
        initindex = length(y0) + 1;
    end
    partialindex = 4;

    Ys = zeros(N, 1);
    E  = sigma*randn(N, 1);
    Ys(1:length(y0)) = y0;

    
    theta    = [+0.871751278613310143
				+0.347562627224012100
				-0.219356232120622052
				-0.000170852002515530
				+0.000705292165438878
				-0.000851902726264876
				-0.004995229813705034
				+0.005700293602558485
				+0.000180375037776334
				+0.000006642936775683
				+0.097119196596288121
				];
    termlist = {'Ys(k-1)'; ...
				'Ys(k-2)'; ...
				'Ys(k-4)'; ...
				'U(k-1,10)'; ...
				'U(k-1,16)'; ...
				'U(k-4,16)'; ...
				'U(k-1,18)'; ...
				'U(k-4,18)'; ...
				'U(k-1,34)'; ...
				'U(k-1,46)'; ...
				'E(k-4)'; ...
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
        Ys(k) = [Ys(k-1) Ys(k-2) Ys(k-4) U(k-1,10) ...
				U(k-1,16) U(k-4,16) U(k-1,18) U(k-4,18) ...
				U(k-1,34) U(k-1,46) E(k-4) ]*theta + E(k);
    end

end
