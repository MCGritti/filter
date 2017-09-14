function Ys = mancal1modelo(U, y0, sigma)

    N = size(U, 1);

    if isempty(y0)
        initindex = 2;
    else
        if isrow(y0)
            y0 = y0';
        end
        initindex = length(y0) + 1;
    end
    partialindex = 12;

    Ys = zeros(N, 1);
    E  = sigma*randn(N, 1);
    Ys(1:length(y0)) = y0;

    
    theta    = [+4.991708985736909000
				+0.387613607034513200
				+0.048636465913193760
				+0.025191519220168872
				+0.010664307432142115
				+0.044992298111039893
				-0.248009781689088630
				+0.009926795496306701
				+0.026722362623203329
				+0.051909662081458308
				+5.649025214902452200
				+0.949200612673279490
				-0.010698715948677929
				+0.088002595556140151
				+0.011890270999410436
				-0.000489875859857470
				-0.007253493778449487
				+0.006834191205241222
				+0.041497232586228595
				+0.001851964211475725
				-0.001992780334738225
				+0.962218061835567800
				-2.516375254303066200
				+0.686482958044724480
				-0.641334483015842620
				];
    termlist = {'1'; ...
				'Ys(k-1)'; ...
				'Ys(k-3)'; ...
				'Ys(k-4)'; ...
				'Ys(k-5)'; ...
				'Ys(k-6)'; ...
				'Ys(k-7)'; ...
				'Ys(k-8)'; ...
				'Ys(k-9)'; ...
				'U(k-10,1)'; ...
				'U(k-3,2)'; ...
				'U(k-11,2)'; ...
				'Ys(k-1)*Ys(k-5)'; ...
				'Ys(k-1)*U(k-3,2)'; ...
				'Ys(k-5)*Ys(k-7)'; ...
				'Ys(k-7)*U(k-12,1)'; ...
				'Ys(k-8)*U(k-9,1)'; ...
				'Ys(k-8)*U(k-12,1)'; ...
				'Ys(k-8)*U(k-12,2)'; ...
				'U(k-10,1)*U(k-11,1)'; ...
				'U(k-12,1)*U(k-12,1)'; ...
				'U(k-1,2)*U(k-8,2)'; ...
				'U(k-3,2)*U(k-3,2)'; ...
				'U(k-5,2)*U(k-9,2)'; ...
				'U(k-6,2)*U(k-8,2)'; ...
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
        Ys(k) = [1 Ys(k-1) Ys(k-3) Ys(k-4) ...
				Ys(k-5) Ys(k-6) Ys(k-7) Ys(k-8) ...
				Ys(k-9) U(k-10,1) U(k-3,2) U(k-11,2) ...
				Ys(k-1)*Ys(k-5) Ys(k-1)*U(k-3,2) Ys(k-5)*Ys(k-7) Ys(k-7)*U(k-12,1) ...
				Ys(k-8)*U(k-9,1) Ys(k-8)*U(k-12,1) Ys(k-8)*U(k-12,2) U(k-10,1)*U(k-11,1) ...
				U(k-12,1)*U(k-12,1) U(k-1,2)*U(k-8,2) U(k-3,2)*U(k-3,2) U(k-5,2)*U(k-9,2) ...
				U(k-6,2)*U(k-8,2) ]*theta + E(k);
    end

end
