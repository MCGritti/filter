function varargout = first_filter(U, y0, sigma, varargin)

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
  
  
  theta    = [-0.000000438160053950
				+0.152326882933376484
				+0.149721400009630995
				+0.161669128932273587
				+0.167964103824091160
				+0.071948847591051870
				+0.065933967839468130
				+0.057523610912020108
				+0.051602494759853880
				+0.045716284809340133
				+0.074403180650780401
				-0.030588820684225419
				+0.050815825507860769
				+0.047172401793681186
				+0.006281516104632723
				-0.037523081664705304
				+0.006239657603206382
				-0.026137103696622314
				-0.052365282895936810
				-0.019399846506278486
				-0.002525005768309421
				+0.020021375421925506
				+0.026280373229492612
				+0.023853267638021480
				-0.001733037583199146
				+0.018131389287693398
				+0.007905121472448682
				+0.022415712402051365
				+0.010903152691106619
				+0.000619361306871177
				+0.006019409915874693
				-0.011862228392692634
				-0.015829121514148146
				+0.008685190397027663
				-0.007805216727202151
				+0.010586952901442509
				-0.021000291619982746
				+0.000760192872265729
				-0.014751800758521463
				-0.023569398715138658
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
				'Ys(k-11)'; ...
				'Ys(k-12)'; ...
				'Ys(k-13)'; ...
				'Ys(k-14)'; ...
				'Ys(k-15)'; ...
				'Ys(k-16)'; ...
				'Ys(k-17)'; ...
				'Ys(k-18)'; ...
				'Ys(k-19)'; ...
				'Ys(k-20)'; ...
				'U(k-1,1)'; ...
				'U(k-2,1)'; ...
				'U(k-3,1)'; ...
				'U(k-4,1)'; ...
				'U(k-5,1)'; ...
				'U(k-6,1)'; ...
				'U(k-7,1)'; ...
				'U(k-8,1)'; ...
				'U(k-9,1)'; ...
				'U(k-11,1)'; ...
				'U(k-12,1)'; ...
				'U(k-13,1)'; ...
				'U(k-14,1)'; ...
				'U(k-15,1)'; ...
				'U(k-16,1)'; ...
				'U(k-17,1)'; ...
				'U(k-18,1)'; ...
				'U(k-19,1)'; ...
				'U(k-20,1)'; ...
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
				Ys(k-8) Ys(k-9) Ys(k-10) Ys(k-11) ...
				Ys(k-12) Ys(k-13) Ys(k-14) Ys(k-15) ...
				Ys(k-16) Ys(k-17) Ys(k-18) Ys(k-19) ...
				Ys(k-20) U(k-1,1) U(k-2,1) U(k-3,1) ...
				U(k-4,1) U(k-5,1) U(k-6,1) U(k-7,1) ...
				U(k-8,1) U(k-9,1) U(k-11,1) U(k-12,1) ...
				U(k-13,1) U(k-14,1) U(k-15,1) U(k-16,1) ...
				U(k-17,1) U(k-18,1) U(k-19,1) U(k-20,1) ...
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
