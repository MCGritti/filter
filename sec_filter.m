function varargout = sec_filter(U, y0, sigma, varargin)

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
  
  
  theta    = [+2.214452197126976607
				+1.006922864004755169
				+0.032103447011196273
				-42063.356361357968125958
				+42856.130661203991621733
				-0.613391128026705701
				-0.313436130591507489
				+11535313.450009016320109367
				-23118020.095918424427509308
				+11582756.142507292330265045
				+0.397601124408538453
				+413.498750118378154639
				];
  termlist = {'1'; ...
				'Ys(k-1)'; ...
				'Ys(k-11)'; ...
				'U(k-1,1)'; ...
				'U(k-12,1)'; ...
				'Ys(k-1)*Ys(k-1)'; ...
				'Ys(k-1)*Ys(k-11)'; ...
				'Ys(k-1)*U(k-10,1)'; ...
				'Ys(k-1)*U(k-11,1)'; ...
				'Ys(k-1)*U(k-12,1)'; ...
				'Ys(k-3)*Ys(k-11)'; ...
				'U(k-1,1)*U(k-1,1)'; ...
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
	Us(k,:) = [1 Ys(k-1) Ys(k-11) U(k-1,1) ...
				U(k-12,1) Ys(k-1)*Ys(k-1) Ys(k-1)*Ys(k-11) Ys(k-1)*U(k-10,1) ...
				Ys(k-1)*U(k-11,1) Ys(k-1)*U(k-12,1) Ys(k-3)*Ys(k-11) U(k-1,1)*U(k-1,1) ...
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
