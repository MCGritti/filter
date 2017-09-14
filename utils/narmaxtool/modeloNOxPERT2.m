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
    partialindex = 5;

    Ys = zeros(N, 1);
    E  = sigma*randn(N, 1);
    Ys(1:length(y0)) = y0;

    
    theta    = [+1.146618221437535300
				+0.269097220452922500
				-0.838021439001715770
				+0.414040424962746180
				+0.112403068334005730
				+0.003335848725962015
				+0.002768316278496830
				-0.000339138614419803
				+4.860716334443523600
				-0.003113906447910466
				-0.810409553548123050
				+2.540221154863990400
				-45.557290079206396000
				+43.707157475232059000
				-0.003743352984262230
				];
    termlist = {'Ys(k-1)'; ...
				'Ys(k-3)'; ...
				'Ys(k-4)'; ...
				'Ys(k-5)'; ...
				'U(k-1,15)'; ...
				'U(k-3,30)'; ...
				'U(k-1,32)'; ...
				'U(k-3,38)'; ...
				'U(k-1,45)'; ...
				'U(k-2,50)'; ...
				'U(k-4,51)'; ...
				'U(k-5,69)'; ...
				'U(k-2,83)'; ...
				'U(k-3,83)'; ...
				'U(k-2,90)'; ...
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
        Ys(k) = [Ys(k-1) Ys(k-3) Ys(k-4) Ys(k-5) ...
				U(k-1,15) U(k-3,30) U(k-1,32) U(k-3,38) ...
				U(k-1,45) U(k-2,50) U(k-4,51) U(k-5,69) ...
				U(k-2,83) U(k-3,83) U(k-2,90) ]*theta + E(k);
    end

end
