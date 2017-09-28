function varargout = estmodel(U, y0, sigma, varargin)

  N = size(U, 1);
  
  if isempty(y0)
    initindex = 7;
  else
    if isrow(y0)
      y0 = y0';
    end
    initindex = length(y0) + 1;
  end
  partialindex = 23;
  
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
  
  
  theta    = [+0.057652199118281504
				+972.027807137459490150
				-969.268336245376531224
				-969.039190708051364709
				+967.344613280090015905
				-4.728773212298885475
				+3.496556092600286991
				-1.250025673739777909
				-0.631528353143811394
				+0.371037057113209612
				+6445.174041536633922078
				];
  termlist = {'U(k-6,2)'; ...
				'U(k-1,1)*U(k-22,2)'; ...
				'U(k-1,1)*U(k-23,2)'; ...
				'U(k-3,1)*U(k-22,2)'; ...
				'U(k-3,1)*U(k-23,2)'; ...
				'U(k-6,1)*U(k-1,2)'; ...
				'U(k-6,1)*U(k-2,2)'; ...
				'U(k-7,1)*U(k-18,1)'; ...
				'U(k-19,1)*U(k-22,1)'; ...
				'U(k-8,2)*U(k-8,2)'; ...
				'E(k-5)*E(k-23)'; ...
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
	Us(k,:) = [U(k-6,2) U(k-1,1)*U(k-22,2) U(k-1,1)*U(k-23,2) U(k-3,1)*U(k-22,2) ...
				U(k-3,1)*U(k-23,2) U(k-6,1)*U(k-1,2) U(k-6,1)*U(k-2,2) U(k-7,1)*U(k-18,1) ...
				U(k-19,1)*U(k-22,1) U(k-8,2)*U(k-8,2) E(k-5)*E(k-23) ];
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
