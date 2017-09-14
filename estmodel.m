function varargout = estmodel(U, y0, sigma, varargin)

  N = size(U, 1);
  
  if isempty(y0)
    initindex = 2;
  else
    if isrow(y0)
      y0 = y0';
    end
    initindex = length(y0) + 1;
  end
  partialindex = 48;
  
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
  
  
  theta    = [-0.048045028865687026
				+213.174206987604407004
				-446.572571884203284753
				+3.422266872199532628
				-4.023303546080952309
				-0.607800259839503476
				+1.249106689878696441
				-0.940229210196449117
				+1.349607741918181780
				-1.693402948371725669
				+235.067122816814332964
				+0.389553987539563051
				+2.913644544869674835
				+1.168572465703099139
				-1.751348783612307169
				];
  termlist = {'U(k-2,2)'; ...
				'U(k-1,1)*U(k-1,1)'; ...
				'U(k-1,1)*U(k-1,2)'; ...
				'U(k-2,1)*U(k-23,1)'; ...
				'U(k-3,1)*U(k-47,2)'; ...
				'U(k-10,1)*U(k-41,2)'; ...
				'U(k-12,1)*U(k-46,1)'; ...
				'U(k-24,1)*U(k-26,2)'; ...
				'U(k-25,1)*U(k-48,1)'; ...
				'U(k-45,1)*U(k-11,2)'; ...
				'U(k-1,2)*U(k-1,2)'; ...
				'U(k-2,2)*U(k-29,2)'; ...
				'U(k-3,2)*U(k-47,2)'; ...
				'U(k-9,2)*U(k-43,2)'; ...
				'U(k-23,2)*U(k-25,2)'; ...
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
	Us(k,:) = [U(k-2,2) U(k-1,1)*U(k-1,1) U(k-1,1)*U(k-1,2) U(k-2,1)*U(k-23,1) ...
				U(k-3,1)*U(k-47,2) U(k-10,1)*U(k-41,2) U(k-12,1)*U(k-46,1) U(k-24,1)*U(k-26,2) ...
				U(k-25,1)*U(k-48,1) U(k-45,1)*U(k-11,2) U(k-1,2)*U(k-1,2) U(k-2,2)*U(k-29,2) ...
				U(k-3,2)*U(k-47,2) U(k-9,2)*U(k-43,2) U(k-23,2)*U(k-25,2) ];
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
