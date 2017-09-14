function [varargout] = runga(problem, solver, varargin)

    % Load problem variables
    
    Xopt = problem.Xopt;
    fObj = problem.ObjectiveFunction;
    dim = problem.Dimension;
    vlb = problem.Boundaries.Lower;
    vub = problem.Boundaries.Upper;
    intcon = problem.Integers;
    isMin = problem.IsMinimization;
    enx0 = problem.UseInitialGuess;
    initcost = problem.XoptCost;
    
    % Load GA parameters
    
    N = solver.PopSize;
    C = solver.CrossoverProb;
    M = solver.MutationProb;
    bits = solver.Bits*ones(1,dim);
    elitist = solver.Elitist;
    %bounded = true; don't need for classic one
    
    %% GA Code
    
    %--------------------------
    % Generate Random Population
    %--------------------------
    VLB = vlb(ones(1,N),:);
    VUB = vub(ones(1,N),:);
    INTCON = logical(intcon(ones(1,N),:));
    
    X = rand(N,dim).*(VUB-VLB) + VLB;
    X(INTCON) = round(X(INTCON));
    if ~isempty(Xopt) && enx0
        X(1,:) = Xopt;
    end
    
    %------------------------
    % Set initial FBest
    %-----------------------
    if enx0
        Fbest = initcost;
    elseif isMin
        Fbest = inf;
    else
        Fbest = -inf;
    end
    
    %-------------------------------------------------------------
    % Allocate space, define constants and inicializate variables
    %-------------------------------------------------------------

    range = vub-vlb;
    precision = range./(2.^bits-1);
    PRECISION = precision(ones(1,N),:);
    L = sum(bits);
    Lmax = max(bits);
    Bits = Lmax;
    Rows = repmat(1:Bits*dim,N,1);
    ConstMatrix = repmat(2.^(Bits-1:-1:0),[N 1 dim]);
    encodemask = zeros(N,Bits,dim);
    costs = zeros(1,N);
    CostHistory = [];
    
    CV = solvers.initializeControlVariables(problem, solver);
    
    while ~CV.stopFlag
        
        %*******************************************************************
        %Evaluate Population
        %*******************************************************************
        for i=1:N
            costs(i) = fObj(X(i,:));
            if isMin
                if costs(i) < Fbest
                    Fbest = costs(i);
                    Xopt = X(i,:);
                end
            else
                if costs(i) > Fbest
                    Fbest = costs(i);
                    Xopt = X(i,:);
                end
            end
            
            if ((isMin && Fbest < CV.fObjCrit) || (~isMin && Fbest > CV.fObjCrit)) && ~CV.stopFlag
                ExecutionTime = etime(clock, CV.t0);
                common.closeBox('Objective function criteria', ExecutionTime);
                CV.stopFlag = true;
            end
            
            CV.neval = CV.neval + 1;
            if CV.neval >= CV.maxEval && ~CV.stopFlag
                ExecutionTime = etime(clock, CV.t0);
                common.closeBox('Max evaluations', ExecitionTime);
                CV.stopFlag = true;
                break;
            end
        end
        
        if elitist
            if isMin
                [~, BestIdx] = min(costs);
            else
                [~, BestIdx] = max(costs);
            end
            V = repmat(X(BestIdx,:),N,1);
        end
    
        %*******************************************************************
        % Encode Population
        %*******************************************************************
        Values = round((X-VLB)./PRECISION);
        
        i = Bits;
        while any(Values)
            encodemask(:,i,:) = mod(Values,2);
            Values = floor(Values/2);
            i = i-1;
        end
        
        Xb = reshape(encodemask,N,Bits*dim);
        
        %*******************************************************************
        % Apply Crossover
        %*******************************************************************
        U = Xb;
        
        % Normalize costs to roulette
        if isMin
            f = 1./(costs - min(costs) + 1);
        else
            f = costs + 1.1*min(costs);
        end
        T = sum(f);
    
        r = T*rand(N,2); %Generate values for roulette loop
        buff = f(1)*ones(N,2); 
        parentIdxs = ones(N,2); 
        w = 1;
        while buff(buff < r) < r(buff < r)
            parentIdxs(buff < r) = parentIdxs(buff < r) + 1;
            w = w + 1;
            buff(buff < r) = buff(buff < r) + f(w);
        end
        
        %If and individual choose the same parent
        mask = parentIdxs(:,1) == parentIdxs(:,2);
        while any(mask)
            parentIdxs(mask,2) = randi(N,length(parentIdxs(mask,2)),1);
            mask = parentIdxs(:,1) == parentIdxs(:,2);
        end
        
        cutIdxs = randi(Bits*dim-1,N,1); %randomize the cutter indexes
        MC = rand(N,1) < C;              %generate logical matrix teeling which individuals will crossover
        cutterInit = Rows(MC,:) <= cutIdxs(MC,ones(1,Bits*dim)); %logical matrix with the first cromossome of the first parent choosen from individual n
        cutterEnd = ~cutterInit;                                 %logival matrix with the secont cromossome of the second parent choosen from individual n
        Mv = Xb(parentIdxs(MC,1),:);
        Maux = Xb(parentIdxs(MC,2),:);
        Mv(cutterEnd) = Maux(cutterEnd);                         %
        U(MC,:) = Mv;
           
        %*******************************************************************
        % Mutate
        %*******************************************************************
        A = rand(N,L) < M;
        U(A) = ~U(A);
        
        %*******************************************************************
        % Decode Population
        %*******************************************************************
        Xb = reshape(U,N,Bits,dim);
        X = reshape(sum(Xb.*ConstMatrix,2),N,dim).*PRECISION + VLB;
        
        %** *****************************************************************
        % Check if Xopt is alive case elitist is seted
        %*******************************************************************
        if elitist
            if ~any(all(X==V,2))
                X(BestIdx,:) = V(BestIdx,:);
            end
        end
            
        CostHistory = [CostHistory Fbest];
        
        if ~mod(CV.t, CV.refreshRate)
            common.fobjPresentation(CV.t, Fbest);
        end
        
        if CV.t >= CV.maxIter && ~CV.stopFlag
            ExecutionTime = etime(clock, CV.t0);
            common.closeBox('Max generations', ExecutionTime);
            CV.stopFlag = true;
        end
        
        progress({'Generations', CV.t/CV.maxIter, 'Evaluations', CV.neval/CV.maxEval});
        CV.t = CV.t + 1;     
    end
    
    progress('refresh');
    progress('resetbar',{'Generations', 'Evaluations'});
    
    varargout{1} = Xopt;
    varargout{2} = Fbest;
    varargout{3} = CostHistory;
    varargout{4} = ExecutionTime;
    varargout{5} = [];

end

