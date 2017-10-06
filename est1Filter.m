function varargout = est1Filter(U, y0, sigma, varargin)

  N = size(U, 1);
  
  if isempty(y0)
    initindex = 2;
  else
    if isrow(y0)
      y0 = y0';
    end
    initindex = length(y0) + 1;
  end
  partialindex = 24;
  
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
  
  
  theta    = [+2.071998413237526648
				-1.081868817558681917
				+0.009631671831252964
				+0.000601219927847566
				+0.000599122856787984
				+0.000124159767168557
				-0.001153710529300176
				-0.000073681880157057
				+0.000155654222340903
				+0.556171754125415529
				-0.067876615405446677
				-0.534429841964134233
				+0.067989476695254528
				-0.110383621509957161
				+0.100685298531353495
				];
  termlist = {'Ys(k-1)'; ...
				'Ys(k-2)'; ...
				'Ys(k-10)'; ...
				'U(k-2,1)'; ...
				'U(k-5,1)'; ...
				'U(k-7,1)'; ...
				'U(k-8,1)'; ...
				'U(k-14,1)'; ...
				'U(k-15,1)'; ...
				'U(k-2,1)*U(k-5,1)'; ...
				'U(k-6,1)*U(k-12,1)'; ...
				'U(k-8,1)*U(k-8,1)'; ...
				'U(k-13,1)*U(k-18,1)'; ...
				'U(k-17,1)*U(k-22,1)'; ...
				'U(k-23,1)*U(k-24,1)'; ...
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
	Us(k,:) = [Ys(k-1) Ys(k-2) Ys(k-10) U(k-2,1) ...
				U(k-5,1) U(k-7,1) U(k-8,1) U(k-14,1) ...
				U(k-15,1) U(k-2,1)*U(k-5,1) U(k-6,1)*U(k-12,1) U(k-8,1)*U(k-8,1) ...
				U(k-13,1)*U(k-18,1) U(k-17,1)*U(k-22,1) U(k-23,1)*U(k-24,1) ];
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
