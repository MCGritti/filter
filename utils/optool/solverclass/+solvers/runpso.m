function [varargout] = runpso(problem, solver, varargin)

    % Load problem parameters
    
    Xopt     = problem.Xopt;
    fObj     = problem.ObjectiveFunction;
    dim      = problem.Dimension;
    vlb      = problem.Boundaries.Lower;
    vub      = problem.Boundaries.Upper;
    intcon   = problem.Integers;
    isMin    = problem.IsMinimization;
    enx0     = problem.UseInitialGuess;
    initcost = problem.XoptCost;
    
    % Load pso parameters
    
    popSize = solver.Particles;
    cog     = solver.Cognitivity;
    soc     = solver.Sociability;
    inertia = solver.Inertia;
    t       = solver.TimeStep;
    bounded = solver.Bounded;
    
    %% ----------------------------
    % Create initial population
    %----------------------------
    VUB = vub(ones(1,popSize),:);
    VLB = vlb(ones(1,popSize),:);
    INTCON = logical(intcon(ones(1,popSize),:));
    
    X = rand(popSize,dim).*(VUB-VLB) + VLB;
    X(INTCON) = round(X(INTCON));
    if ~isempty(Xopt) && enx0
        X(1,:) = Xopt;
    end
    
    %% -------------------------------------------------------------
    % Allocate space, define constants and initializate variables
    %-------------------------------------------------------------
    V = zeros(popSize,dim);
    gbest = [];
    pbest = X;
    if enx0
        Fbest = initcost;
        gbest = Xopt;
    elseif isMin
        Fbest = inf;
    else
        Fbest = -inf;
    end
    costs = Fbest*ones(1,popSize);
    if length(cog) == 1
        cog = [cog cog];
    end
    if length(soc) == 1
        soc = [soc soc];
    end
    if length(inertia) == 1
        inertia = [inertia inertia];
    end
    
    CostHistory = [];
    
    CV = solvers.initializeControlVariables(problem, solver);
    
    %% ----------------------
    %        Startloop
     
    while ~CV.stopFlag
        
        %% -------------------------------------
        %  Evaluate population and save the bests

        for j=1:popSize
            cost = fObj(X(j,:));
            if isMin
                if cost < Fbest
                    Fbest = cost;
                    costs(j) = cost;
                    gbest = X(j,:);
                    pbest(j,:) = X(j,:);
                elseif cost < costs(j)
                    costs(j) = cost;
                    pbest(j,:) = X(j,:);
                end
            else
                if cost > Fbest
                    Fbest = cost;
                    costs(j) = cost;
                    gbest = X(j,:);
                    pbest(j,:) = X(j,:);
                elseif cost > costs(j)
                    costs(j) = cost;
                    pbest(j,:) = X(j,:);
                end
            end
            
            if ((isMin && Fbest < CV.fObjCrit) || (~isMin && Fbest > CV.fObjCrit)) && ~CV.stopFlag
                Xopt = gbest;
                ExecutionTime = etime(clock, CV.t0); %Check fobj criteria
                common.closeBox('Objetive function criteria', ExecutionTime);
                CV.stopFlag = true;
            end
            
            CV.neval = CV.neval + 1;
            if CV.neval >= CV.maxEval && ~CV.stopFlag
                Xopt = gbest;
                ExecutionTime = etime(clock,CV.t0);
                common.closeBox('Max evaluations', ExecutionTime);
                CV.stopFlag = true; 
            end
        end
        
        %% --------------------
        %   Refresh parameters
  
        w = inertia(1) - (inertia(1)-inertia(2))*(CV.t-1)/(CV.maxIter);
        c1 = cog(1) - (cog(1)-cog(2))*(CV.t-1)/(CV.maxIter);
        c2 = soc(1) - (soc(1)-soc(2))*(CV.t-1)/(CV.maxIter);
        
        %% ----------------
        %   Move population
 
        V = w*V + c1*rand(popSize,dim).*(pbest-X) + c2*rand(popSize,dim).*(gbest(ones(1,popSize),:)-X);
        X = X + t*V + 0.05*randn(popSize,dim);
        X(INTCON) = round(X(INTCON));
        if bounded
            X(X<VLB) = VLB(X<VLB);
            X(X>VUB) = VUB(X>VUB);
        end
        
        %% ---------------------------------------------
        % Check stop criterias and print results to user
        %-----------------------------------------------
        CostHistory = [CostHistory Fbest];
        
        if ~mod(CV.t, CV.refreshRate)
            common.fobjPresentation(CV.t, Fbest);
        end
        
        if CV.t >= CV.maxIter && ~CV.stopFlag
            Xopt = gbest;
            ExecutionTime = etime(clock, CV.t0);
            common.closeBox('Max iterations', ExecutionTime);
            CV.stopFlag = true;
        end
        
        progress({'Iterations',CV.t/CV.maxIter,'Evaluations',CV.neval/CV.maxEval});
        CV.t = CV.t + 1;
        
    end
   
    %% Close progress bar
    progress('refresh');
    progress('resetbar',{'Iterations','Evaluations'});
    
    varargout{1} = Xopt;
    varargout{2} = Fbest;
    varargout{3} = CostHistory;
    varargout{4} = ExecutionTime;
    varargout{5} = [];

end