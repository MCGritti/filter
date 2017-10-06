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
  
  
  theta    = [-0.041335744202252479
				+1.328601173383895828
				+2.051929020050192953
				+2.785544334395873012
				+0.776687393745903343
				-3.281018931297135843
				-2.527998051756538800
				+2.377844570691054482
				-0.969246240032516582
				+2.681147911900397585
				-3.215338529915050092
				+1.814257827170915327
				+1.030836850888542600
				+1.062491424338880996
				-3.578765654489185710
				];
  termlist = {'U(k-1,2)'; ...
				'U(k-1,1)*U(k-1,1)'; ...
				'U(k-4,1)*U(k-11,2)'; ...
				'U(k-6,1)*U(k-10,2)'; ...
				'U(k-9,1)*U(k-14,2)'; ...
				'U(k-10,1)*U(k-6,2)'; ...
				'U(k-11,1)*U(k-4,2)'; ...
				'U(k-14,1)*U(k-24,2)'; ...
				'U(k-19,1)*U(k-15,2)'; ...
				'U(k-21,1)*U(k-15,2)'; ...
				'U(k-24,1)*U(k-14,2)'; ...
				'U(k-1,2)*U(k-23,2)'; ...
				'U(k-5,2)*U(k-19,2)'; ...
				'U(k-16,2)*U(k-18,2)'; ...
				'U(k-16,2)*U(k-21,2)'; ...
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
	Us(k,:) = [U(k-1,2) U(k-1,1)*U(k-1,1) U(k-4,1)*U(k-11,2) U(k-6,1)*U(k-10,2) ...
				U(k-9,1)*U(k-14,2) U(k-10,1)*U(k-6,2) U(k-11,1)*U(k-4,2) U(k-14,1)*U(k-24,2) ...
				U(k-19,1)*U(k-15,2) U(k-21,1)*U(k-15,2) U(k-24,1)*U(k-14,2) U(k-1,2)*U(k-23,2) ...
				U(k-5,2)*U(k-19,2) U(k-16,2)*U(k-18,2) U(k-16,2)*U(k-21,2) ];
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
