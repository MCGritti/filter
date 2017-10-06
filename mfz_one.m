function varargout = mfz_one(U, y0, sigma, varargin)

  N = size(U, 1);
  
  if isempty(y0)
    initindex = 2;
  else
    if isrow(y0)
      y0 = y0';
    end
    initindex = length(y0) + 1;
  end
  partialindex = 19;
  
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
  
  
  theta    = [+0.341476127896474246
				+0.568917586423611232
				+0.028246451954679088
				+0.024046996519707382
				-1.966994304165704310
				+3.710839096431014728
				-0.024945114517883036
				+0.008608439201193571
				-1.857022961271958872
				+0.006800348933047214
				-0.396282127669510431
				-0.956587177463694371
				];
  termlist = {'Ys(k-1)'; ...
				'Ys(k-2)'; ...
				'Ys(k-3)'; ...
				'Ys(k-5)'; ...
				'Ys(k-1)*Ys(k-1)'; ...
				'Ys(k-1)*Ys(k-3)'; ...
				'Ys(k-1)*U(k-15,1)'; ...
				'Ys(k-2)*U(k-15,1)'; ...
				'Ys(k-3)*Ys(k-3)'; ...
				'U(k-18,1)*U(k-19,1)'; ...
				'E(k-2)'; ...
				'Ys(k-18)*E(k-2)'; ...
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
	Us(k,:) = [Ys(k-1) Ys(k-2) Ys(k-3) Ys(k-5) ...
				Ys(k-1)*Ys(k-1) Ys(k-1)*Ys(k-3) Ys(k-1)*U(k-15,1) Ys(k-2)*U(k-15,1) ...
				Ys(k-3)*Ys(k-3) U(k-18,1)*U(k-19,1) E(k-2) Ys(k-18)*E(k-2) ...
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
