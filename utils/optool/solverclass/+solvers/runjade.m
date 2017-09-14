function [Xopt, Fbest, CostHistory, ExecutionTime, CRHistory, FHistory] = runjade(problem, solver, varargin)

    %Load problem object parameters

    Xopt = problem.Xopt;
    fObj = problem.ObjectiveFunction;
    dim = problem.Dimension;
    vlb = problem.Boundaries.Lower;
    vub = problem.Boundaries.Upper;
    intcon = problem.Integers;
    isMin = problem.IsMinimization;
    enx0 = problem.UseInitialGuess;
    %initcost = problem.XoptCost;
    
    %Load jade parameters
    
    N = solver.PopSize;
    P = solver.BestPercentage;
    c = solver.AdaptativeConstant;
    H = solver.FIRSize;
    bounded = solver.Bounded;
    
    
    %% JADE Code
    
    %% --------------------------
    %  Generate Random Population
    %  --------------------------
    VLB = vlb(ones(1,N),:);
    VUB = vub(ones(1,N),:);
    INTCON = logical(intcon(ones(1,N),:));
    
    X = rand(N,dim).*(VUB-VLB) + VLB;
    X(INTCON) = round(X(INTCON));
    if ~isempty(Xopt) && enx0
        X(1,:) = Xopt;
    end
    
    %% --------------------------------
    %  Evaluate the initial population and get the best
    %  --------------------------------
    costs = zeros(1,N);
    for i=1:N
        costs(i) = fObj(X(i,:));
    end
    
    if isMin
        Fbest = min(costs);
    else
        Fbest = max(costs);
    end

    %% ------------------------------------------------------------
    %  Allocate space, define constants and inicializate variables
    %  ------------------------------------------------------------
    muF = 0.5;
    muCR = 0.5;
    n = round(N*P);
    A = []; % External Archive
    if H==0
        H = N*maxGenerations;
    end
    sF = zeros(1,H);
    sCR = zeros(1,H);
    fidx = 0;
    CostHistory = [];
    CRHistory = [];
    FHistory = [];
    Rmin = zeros(N,1);
    Rmax = ones(N,1);
    
    CV = solvers.initializeControlVariables(problem, solver);
    
    %% --------------------------------------------
    %  Startloop
    %  --------------------------------------------
    
    while ~CV.stopFlag
        
        %% -------------------
        %  Generate normal random F and CR 
        %---------------------------------
        
        CR = muCR + 0.1*randn(N,1);
        F = muF + 0.2*randn(N,1);
        CR(CR<Rmin) = 0;
        CR(CR>Rmax) = 1;
        while any(F<Rmin)
            F(F<Rmin) = muF + 0.2*randn(numel(F(F<Rmin)),1);
        end
        F(F>Rmax) = 1;
        
        %% --------------
        % Select Idexes
        %--------------
        
        %---> Select pbest`s
        if isMin
            [~, idxs] = sort(costs);
        else
            [~, idxs] = sort(costs,'descend');
        end
        BestIdx = idxs(randi(n,N,1))';
        
        %---> Select r1`s
        V1_Idx = randi(N,N,1);
        mask = BestIdx == V1_Idx;
        while V1_Idx(mask) == BestIdx(mask)
            V1_Idx(mask) = randi(N,length(V1_Idx(mask)),1);
            mask = BestIdx == V1_Idx;
        end
        
        %---> Select r2`s
        AUX = [X;A];
        NA = size(AUX,1);
        V2_Idx = randi(NA,N,1);
        submask = (BestIdx == V2_Idx) | (V1_Idx == V2_Idx);
        mask = (V2_Idx(submask) == BestIdx(submask)) | (V2_Idx(submask) == V1_Idx(submask));
        while mask
            V2_Idx(submask) = randi(NA,length(V2_Idx(submask)),1);
            submask = (BestIdx == V2_Idx) | (V1_Idx == V2_Idx);
            mask = (V2_Idx(submask) == BestIdx(submask)) | (V2_Idx(submask) == V1_Idx(submask));
        end
        
        %% ------------------
        % Mutation
        %------------------
        U = X + F(:,ones(1,dim)).*(X(BestIdx,:) - X + X(V1_Idx,:) - AUX(V2_Idx,:));
        
        %% ------------------
        % Crossover
        %------------------
        jrand = randi(dim,N,1);
        columns = repmat(1:dim,N,1);
        mask = rand(N,dim) < CR(:,ones(1,dim)) | jrand(:,ones(1,dim)) == columns;
        U(~mask) = X(~mask);
        U(INTCON) = round(U(INTCON));
        if bounded
            U(U<VLB) = VLB(U<VLB);
            U(U>VUB) = VUB(U>VUB);
        end
        
        %% -------------------
        %  Eval population
        %  -------------------
        for i=1:N
            tempCost = fObj(U(i,:));
            if isMin
                if tempCost < costs(i)
                    if ~isempty(A)
                        if size(A,1) >= N
                            A(randi(N),:) = [];
                        end
                    end
                    A = [A; X(i,:)];
                    if fidx+1 > H
                        sF(1) = [];
                        sCR(1) = [];
                    else
                        fidx = fidx + 1;
                    end
                    sF(fidx) = F(i); 
                    sCR(fidx) = CR(i);
                    X(i,:) = U(i,:);
                    costs(i) = tempCost;
                end
                if tempCost < Fbest
                    Fbest = tempCost;
                    Xopt = X(i,:);
                    if ((isMin && Fbest < CV.fObjCrit) || (~isMin && Fbest > CV.fObjCrit)) && ~CV.stopFlag
                        ExecutionTime = etime(clock, CV.t0);
                        common.closeBox('Objetive function criteria', ExecutionTime);
                        CV.stopFlag = true;
                    end
                end
            else
                if tempCost > costs(i)
                    if ~isempty(A)
                        if size(A,1) >= N
                            A(randi(N),:) = [];
                        end
                    end
                    A = [A; X(i,:)];
                    if fidx+1 > H
                        sF(1) = [];
                        sCR(1) = [];
                    else
                        fidx = fidx + 1;
                    end
                    sF(fidx) = F(i); 
                    sCR(fidx) = CR(i);
                    X(i,:) = U(i,:);
                    costs(i) = tempCost;
                end
                if tempCost > Fbest
                    Fbest = tempCost;
                    Xopt = X(i,:);
                    if ((isMin && Fbest < CV.fObjCrit) || (~isMin && Fbest > CV.fObjCrit)) && ~CV.stopFlag
                        ExecutionTime = etime(clock, CV.t0);
                        common.closeBox('Objetive function criteria', ExecutionTime);
                        CV.stopFlag = true;
                    end
                end
            end
            CV.neval = CV.neval + 1;
            if CV.neval >= CV.maxEval && ~CV.stopFlag;
                ExecutionTime = etime(clock, CV.t0);
                common.closeBox('Max evaluations', ExecutionTime);
                CV.stopFlag = true;
                break;
            end
        end
        
        
        %% -------------
        %  Adapative procedure
        %  -------------------
        
        if ~isempty(sCR)
            muCR = (1-c)*muCR + c*mean(sCR(1:fidx));
        end
        if ~isempty(sF)
            muF = (1-c)*muF + c*(sum(sF(1:fidx).^2)/sum(sF(1:fidx)));
        end
        
        %% ----------------
        %  Save data and print result
        
        CostHistory = [CostHistory Fbest];
        CRHistory = [CRHistory muCR];
        FHistory = [FHistory muF];
        
        if ~mod(CV.t, CV.refreshRate)
            common.fobjPresentation(CV.t, Fbest);
        end
        
        if CV.t >= CV.maxIter && ~CV.stopFlag
            ExecutionTime = etime(clock, CV.t0);
            common.closeBox('Max generations', ExecutionTime);
            CV.stopFlag = true;
        end
        
        progress({'Generations',CV.t/CV.maxIter,'Evaluations',CV.neval/CV.maxEval});
        CV.t = CV.t + 1;
        
    end
    
    %% --------------------
    %  Close the progress bar
    %  ---------------------
    
    progress('refresh');
    progress('resetbar',{'Generations','Evaluations'});
    
end