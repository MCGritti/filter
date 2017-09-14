function varargout = narmaxFilter(U, y0, sigma, varargin)

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
  
  
  theta    = [-0.003704017854139655
				+0.416496982413586903
				+0.349833374943077369
				+0.119264486479940951
				+0.158098905184299393
				+0.709320305433431386
				+0.467251888118336678
				-11.773190103283297958
				+0.436513620547211878
				-19.187477950980827757
				+5.145694009391669432
				-18.563972614072415723
				+307.664725883091819014
				-97.906484952530490773
				-95.156230385449021014
				+47.885329271755168179
				];
  termlist = {'1'; ...
				'U(k-1,1)'; ...
				'U(k-1,2)'; ...
				'U(k-4,2)'; ...
				'U(k-5,2)'; ...
				'U(k-7,2)'; ...
				'U(k-10,2)'; ...
				'U(k-1,1)*U(k-1,1)'; ...
				'U(k-2,1)*U(k-8,1)'; ...
				'U(k-5,1)*U(k-7,2)'; ...
				'U(k-10,1)*U(k-9,2)'; ...
				'U(k-10,1)*U(k-10,2)'; ...
				'U(k-1,2)*U(k-7,2)'; ...
				'U(k-2,2)*U(k-6,2)'; ...
				'U(k-3,2)*U(k-8,2)'; ...
				'U(k-10,1)*E(k-1)'; ...
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
	Us(k,:) = [1 U(k-1,1) U(k-1,2) U(k-4,2) ...
				U(k-5,2) U(k-7,2) U(k-10,2) U(k-1,1)*U(k-1,1) ...
				U(k-2,1)*U(k-8,1) U(k-5,1)*U(k-7,2) U(k-10,1)*U(k-9,2) U(k-10,1)*U(k-10,2) ...
				U(k-1,2)*U(k-7,2) U(k-2,2)*U(k-6,2) U(k-3,2)*U(k-8,2) U(k-10,1)*E(k-1) ...
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
