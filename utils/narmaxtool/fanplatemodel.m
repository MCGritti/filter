function Ys = fanplatemodel(U, y0, sigma)

    N = size(U, 1);

    if isempty(y0)
        initindex = 2;
    else
        if isrow(y0)
            y0 = y0';
        end
        initindex = length(y0) + 1;
    end
    partialindex = 10;

    Ys = zeros(N, 1);
    E  = sigma*randn(N, 1);
    Ys(1:length(y0)) = y0;

    cfuncs   = {@(x)cos(2*x*pi/180); ...
		};
    theta    = [+2.480319610750151060
				-2.351784147041777739
				+0.832316335509459382
				+0.014036292892214072
				+0.002017396707606370
				-0.001062671670365395
				-0.000251922673932910
				+0.000151043868430134
				-0.000029989425647048
				-1.067494699930380708
				];
    termlist = {'Ys(k-1)'; ...
				'Ys(k-2)'; ...
				'Ys(k-3)'; ...
				'U(k-3,1)*cfuncs{1}(Ys(k-1))'; ...
				'Ys(k-2)*U(k-4,1)*cfuncs{1}(Ys(k-1))'; ...
				'Ys(k-5)*U(k-4,1)*cfuncs{1}(Ys(k-3))'; ...
				'U(k-4,1)*U(k-9,1)*cfuncs{1}(Ys(k-3))'; ...
				'U(k-7,1)*U(k-9,1)*cfuncs{1}(Ys(k-5))'; ...
				'U(k-3,1)*U(k-10,1)*E(k-1)'; ...
				'E(k-1)*E(k-1)*cfuncs{1}(Ys(k-4))'; ...
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
        Ys(k) = [Ys(k-1) Ys(k-2) Ys(k-3) U(k-3,1)*cfuncs{1}(Ys(k-1)) ...
				Ys(k-2)*U(k-4,1)*cfuncs{1}(Ys(k-1)) Ys(k-5)*U(k-4,1)*cfuncs{1}(Ys(k-3)) U(k-4,1)*U(k-9,1)*cfuncs{1}(Ys(k-3)) U(k-7,1)*U(k-9,1)*cfuncs{1}(Ys(k-5)) ...
				U(k-3,1)*U(k-10,1)*E(k-1) E(k-1)*E(k-1)*cfuncs{1}(Ys(k-4)) ]*theta + E(k);
    end

end
