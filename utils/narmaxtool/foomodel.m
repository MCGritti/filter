function Ys = foomodel(U, y0, sigma)
    
    if ~isrow(U) && ~iscolumn(U)
        if size(U, 1) > size(U, 2)
            U = U';
        end
    else
        if isrow(U)
            U = U';
        end
    end

    N = size(U, 1);

    if isempty(y0) || y0 == 0
        initindex = 2;
    else
        if isrow(y0)
            y0 = y0';
        end
        initindex = length(y0) + 1;
    end
    partialindex = 11;

    Ys = zeros(N, 1);
    E  = sigma*randn(N, 1);

    
    theta    = [-0.09106250
		+2.67480367
		-2.54105860
		+0.83237385
		+0.00767946
		+0.02015001
		+0.00242039
		+0.00210151
		-0.00974911
		-0.00216998
		+0.00816713
		+0.00100775
		-0.00067533
		+0.00108684
		+0.00050275
		+0.00007940
		-0.00045667
		-0.00005055
		+0.00011444
		-17085762.22607517
		+17085762.22630384
		+17085762.22592714
		-17085762.22640263
		+0.00002313
		+0.00003164
		+0.44873327
		-0.01797116
		-0.00162001
		+0.00038204
		-0.07330068
		];
    termlist = {'1'; ...
		'Ys(k-1,1)'; ...
		'Ys(k-2,1)'; ...
		'Ys(k-3,1)'; ...
		'Ys(k-5,1)'; ...
		'U(k-2,1)'; ...
		'U(k-5,1)'; ...
		'Ys(k-1,1)*Ys(k-1,1)'; ...
		'Ys(k-1,1)*Ys(k-6,1)'; ...
		'Ys(k-1,1)*U(k-2,1)'; ...
		'Ys(k-2,1)*Ys(k-6,1)'; ...
		'Ys(k-2,1)*U(k-2,1)'; ...
		'Ys(k-4,1)*Ys(k-4,1)'; ...
		'Ys(k-4,1)*U(k-3,1)'; ...
		'Ys(k-6,1)*U(k-2,1)'; ...
		'Ys(k-6,1)*U(k-11,1)'; ...
		'Ys(k-7,1)*U(k-2,1)'; ...
		'U(k-2,1)*U(k-2,1)'; ...
		'U(k-2,1)*U(k-4,1)'; ...
		'U(k-2,1)*U(k-5,1)'; ...
		'U(k-2,1)*U(k-11,1)'; ...
		'U(k-3,1)*U(k-5,1)'; ...
		'U(k-3,1)*U(k-11,1)'; ...
		'U(k-4,1)*U(k-6,1)'; ...
		'U(k-5,1)*U(k-5,1)'; ...
		'E(k-1,1)'; ...
		'Ys(k-1,1)*E(k-1,1)'; ...
		'Ys(k-9,1)*E(k-1,1)'; ...
		'U(k-4,1)*E(k-1,1)'; ...
		'E(k-2,1)*E(k-2,1)'; ...
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
        Ys(k) = [1 Ys(k-1,1) Ys(k-2,1) Ys(k-3,1) ...
		 Ys(k-5,1) U(k-2,1) U(k-5,1) Ys(k-1,1)*Ys(k-1,1) ...
		 Ys(k-1,1)*Ys(k-6,1) Ys(k-1,1)*U(k-2,1) Ys(k-2,1)*Ys(k-6,1) Ys(k-2,1)*U(k-2,1) ...
		 Ys(k-4,1)*Ys(k-4,1) Ys(k-4,1)*U(k-3,1) Ys(k-6,1)*U(k-2,1) Ys(k-6,1)*U(k-11,1) ...
		 Ys(k-7,1)*U(k-2,1) U(k-2,1)*U(k-2,1) U(k-2,1)*U(k-4,1) U(k-2,1)*U(k-5,1) ...
		 U(k-2,1)*U(k-11,1) U(k-3,1)*U(k-5,1) U(k-3,1)*U(k-11,1) U(k-4,1)*U(k-6,1) ...
		 U(k-5,1)*U(k-5,1) E(k-1,1) Ys(k-1,1)*E(k-1,1) Ys(k-9,1)*E(k-1,1) ...
		 U(k-4,1)*E(k-1,1) E(k-2,1)*E(k-2,1) ]*theta;
    end

end
