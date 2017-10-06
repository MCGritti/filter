function varargout = mfn_one(U, y0, sigma, varargin)

  N = size(U, 1);
  
  if isempty(y0)
    initindex = 2;
  else
    if isrow(y0)
      y0 = y0';
    end
    initindex = length(y0) + 1;
  end
  partialindex = 20;
  
  Ys = zeros(N, 1);
  Y  = zeros(N, 1);
  
  if length(sigma) ~= length(Ys)
    E  = sigma*randn(N, 1);
  else
	E  = sigma;
  end
	
  if nargin > 3
	osa = true;
	Ys  = varargin{1};
	Y   = Ys;
  else
	osa = false;
	Ys(1:length(y0)) = y0;
	Y = Ys;
  end
  
  
  theta    = [+0.000053594637193311
				+0.120410103869112189
				+0.263834332033520802
				+0.299387795769721354
				+0.227908448680025161
				+0.089389858312908965
				+0.035451898067027962
				+0.077235050896303226
				-0.006312944886660059
				+0.297130187734680751
				+0.151846068273387286
				-0.076762530929992162
				-0.034112028152798776
				+0.127359905733945483
				+0.067391031141525629
				-0.197134166504686514
				-0.198161572377939743
				-0.173842404038719062
				-0.160839147054337051
				+0.133406898205688962
				+0.031181068508813959
				-0.024873432159097899
				+0.065873054044487026
				-0.027390867252435551
				+0.034899287413813727
				+159.136166661029392344
				+280.002527362848013581
				-103.743198077315312844
				+276.172110784793744642
				+95.575571271907634241
				-159.603666704403423182
				-233.878306305960137479
				-182.189387575797638874
				-153.873650804152873661
				-10.695741276767218864
				+92.881092503240225255
				+41.317038647305807331
				-20.263700321606481936
				-12.850281727808638976
				-3.145750311603237037
				];
  termlist = {'1'; ...
				'Ys(k-1)'; ...
				'Ys(k-2)'; ...
				'Ys(k-3)'; ...
				'Ys(k-4)'; ...
				'Ys(k-5)'; ...
				'Ys(k-6)'; ...
				'Ys(k-7)'; ...
				'Ys(k-8)'; ...
				'Ys(k-9)'; ...
				'Ys(k-10)'; ...
				'Ys(k-12)'; ...
				'Ys(k-13)'; ...
				'Ys(k-14)'; ...
				'Ys(k-15)'; ...
				'Ys(k-17)'; ...
				'Ys(k-18)'; ...
				'Ys(k-19)'; ...
				'Ys(k-20)'; ...
				'U(k-2,1)'; ...
				'U(k-3,1)'; ...
				'U(k-7,1)'; ...
				'U(k-8,1)'; ...
				'U(k-13,1)'; ...
				'U(k-19,1)'; ...
				'Ys(k-2)*Ys(k-4)'; ...
				'Ys(k-3)*U(k-2,1)'; ...
				'Ys(k-8)*Ys(k-14)'; ...
				'Ys(k-9)*Ys(k-14)'; ...
				'Ys(k-10)*U(k-13,1)'; ...
				'Ys(k-12)*U(k-2,1)'; ...
				'Ys(k-17)*U(k-7,1)'; ...
				'Ys(k-18)*Ys(k-20)'; ...
				'Ys(k-19)*U(k-13,1)'; ...
				'U(k-5,1)*U(k-20,1)'; ...
				'U(k-7,1)*U(k-7,1)'; ...
				'U(k-8,1)*U(k-19,1)'; ...
				'U(k-10,1)*U(k-16,1)'; ...
				'U(k-11,1)*U(k-18,1)'; ...
				'U(k-15,1)*U(k-17,1)'; ...
				};
  
  Us = zeros(length(Ys), length(theta));
  M = length(termlist);

  for k = initindex:partialindex
    for m = 1:M
      try
        eval(sprintf('term = %s;', termlist{m}));
      catch
        term = 0;
      end
	  Us(k,:) = term;
	  Y(k) = Y(k) + theta(m)*term;
	  if ~osa
		Ys(k) = Y(k);
	  end
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
	Us(k,:) = [1 Ys(k-1) Ys(k-2) Ys(k-3) ...
				Ys(k-4) Ys(k-5) Ys(k-6) Ys(k-7) ...
				Ys(k-8) Ys(k-9) Ys(k-10) Ys(k-12) ...
				Ys(k-13) Ys(k-14) Ys(k-15) Ys(k-17) ...
				Ys(k-18) Ys(k-19) Ys(k-20) U(k-2,1) ...
				U(k-3,1) U(k-7,1) U(k-8,1) U(k-13,1) ...
				U(k-19,1) Ys(k-2)*Ys(k-4) Ys(k-3)*U(k-2,1) Ys(k-8)*Ys(k-14) ...
				Ys(k-9)*Ys(k-14) Ys(k-10)*U(k-13,1) Ys(k-12)*U(k-2,1) Ys(k-17)*U(k-7,1) ...
				Ys(k-18)*Ys(k-20) Ys(k-19)*U(k-13,1) U(k-5,1)*U(k-20,1) U(k-7,1)*U(k-7,1) ...
				U(k-8,1)*U(k-19,1) U(k-10,1)*U(k-16,1) U(k-11,1)*U(k-18,1) U(k-15,1)*U(k-17,1) ...
				];
    Y(k) = Us(k,:)*theta;
	if ~osa
	  Y(k) = Y(k) + E(k);
	  Ys(k) = Y(k);
	end
  end
  
  if nargout > 1
	varargout = {Y, Us, theta};
  else
	varargout = {Y};
  end
end
