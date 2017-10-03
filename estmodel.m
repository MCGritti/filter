function Ys = estmodel(U, y0, sigma)

    N = size(U, 1);

    if isempty(y0)
        initindex = 2;
    else
        if isrow(y0)
            y0 = y0';
        end
        initindex = length(y0) + 1;
    end
    partialindex = 23;

    Ys = zeros(N, 1);
    E  = sigma*randn(N, 1);
    Ys(1:length(y0)) = y0;

    
    theta    = [-0.023624180375163187
				-1.026282829465680724
				+2.500383272530505518
				+1.362138607061686768
				+218.530667510439400303
				-398.989944205966651225
				+1.653372750842387662
				+1.880941326144145442
				-0.249840054608339940
				+1.225232419289198793
				+178.513478076906437764
				-81.828245042500796558
				-4.297525268962412603
				-0.752974254365349815
				-0.462415582875766284
				];
    termlist = {'1'; ...
				'U(k-1,1)'; ...
				'U(k-1,2)'; ...
				'U(k-2,2)'; ...
				'U(k-1,1)*U(k-1,1)'; ...
				'U(k-1,1)*U(k-1,2)'; ...
				'U(k-1,1)*U(k-13,2)'; ...
				'U(k-2,1)*U(k-12,1)'; ...
				'U(k-14,1)*U(k-23,1)'; ...
				'U(k-14,1)*U(k-23,2)'; ...
				'U(k-1,2)*U(k-1,2)'; ...
				'U(k-1,2)*U(k-2,2)'; ...
				'U(k-1,2)*U(k-13,2)'; ...
				'U(k-4,2)*U(k-11,2)'; ...
				'U(k-4,2)*U(k-22,2)'; ...
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
        Ys(k) = [1 U(k-1,1) U(k-1,2) U(k-2,2) ...
				U(k-1,1)*U(k-1,1) U(k-1,1)*U(k-1,2) U(k-1,1)*U(k-13,2) U(k-2,1)*U(k-12,1) ...
				U(k-14,1)*U(k-23,1) U(k-14,1)*U(k-23,2) U(k-1,2)*U(k-1,2) U(k-1,2)*U(k-2,2) ...
				U(k-1,2)*U(k-13,2) U(k-4,2)*U(k-11,2) U(k-4,2)*U(k-22,2) ]*theta + E(k);
    end

end
