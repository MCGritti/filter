function [varargout] = rungsa(problem, solver, varargin)

    %Load problem variables

    Xopt = problem.Xopt;
    fObj = problem.ObjectiveFunction;
    dim = problem.Dimension;
    vlb = problem.Boundaries.Lower;
    vub = problem.Boundaries.Upper;
    intcon = problem.Integers;
    isMin = problem.IsMinimization;
    enx0 = problem.UseInitialGuess;
    %initcost = problem.XoptCost;
    
    %Load gsa parameters
    
    N = solver.PopSize;
    alpha = solver.Alpha;
    elitist = solver.IsElitist;
    bounded = solver.Bounded;
    G = @(G0,Alpha,i,maxIt) G0*exp(-Alpha*i/maxIt);
    G0 = solver.G0;
    
    %% GSA Code
    
    
    %----------------------------
    % Generate inicial population
    %----------------------------
    VLB = vlb(ones(1,N),:);
    VUB = vub(ones(1,N),:);
    INTCON = logical(intcon(ones(1,N),:));
    X = rand(N,dim).*(VUB-VLB) + VLB;
    X(INTCON) = round(X(INTCON));
    
    if ~isempty(Xopt) && enx0
        X(1,:) = Xopt;
    end
    
    %----------------------------------------
    % Allocate space and initialize variables
    %----------------------------------------
    
    if isMin
        Fbest = inf;
    else
        Fbest = -inf;
    end

    costs = zeros(1,N);
    CostHistory = [];
    V = zeros(N,dim);
    
    CV = solvers.initializeControlVariables(problem, solver);
    
    while ~CV.stopFlag
        
        for j=1:N % Evaluate Population
            costs(j) = fObj(X(j,:));
            if isMin
                if costs(j) < Fbest
                    Fbest = costs(j);
                    Xopt = X(j,:);
                end
            else
                if costs(j) > Fbest
                    Fbest = costs(j);
                    Xopt = X(j,:);
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
        
        %------------------------------
        % Masses Calculation
        %------------------------------
        if isMin
            worst = max(costs);
            best = min(costs);
        else
            worst = min(costs);
            best = max(costs);
        end
        
        if worst ~= best
            M = (costs - worst)/(best - worst);
            M = M/sum(M);
        else
            M = ones(N,1)/N;
        end
        
        M = repmat(M',1,dim);
        
        %------------------------------
        % Gravitational Field
        %------------------------------
        g = G(G0,alpha,CV.t,CV.maxIter);
        
        %------------------------------
        % Calculate Acceleration
        %------------------------------
        if elitist
            kbest = 50 - 40*(CV.t-1)/(CV.maxIter-1);
            kbest = round(N*kbest/100);
        else
            kbest = N;
        end
        
        if isMin
            [~, idxs] = sort(costs);
        else
            [~, idxs] = sort(costs,'descend');
        end
        
        bestVec = idxs(1:kbest);
        [i, j] = meshgrid(1:N,bestVec);
        Dv = X(j',:) - X(i',:);        % Diference vector
        R = sqrt(sum(Dv.^2,2)) + eps;  % Norms
        A = Dv.*rand(N*kbest,dim).*M(j',:)./R(:,ones(1,dim)); % Acceleration
        A = g*sum(permute(reshape(A', [dim N kbest]),[2 1 3]),3);   % Acceleration
   
        %----------------------
        % Move population
        %----------------------
        V = rand(N,dim).*V + A;
        X = X + V;
        X(INTCON) = round(X(INTCON));
        if bounded
            X(X<VLB) = VLB(X<VLB);
            X(X>VUB) = VUB(X>VUB);
        end
       
        CostHistory = [CostHistory Fbest];
        
        if ~mod(CV.t, CV.refreshRate)
            common.fobjPresentation(CV.t, Fbest);
        end
        
        if CV.t >= CV.maxIter && ~CV.stopFlag
            ExecutionTime = etime(clock, CV.t0);
            common.closeBox('Max iterations', ExecutionTime);
            CV.stopFlag = true;
        end
        
        progress({'Iterations', CV.t/CV.maxIter, 'Evaluations', CV.neval/CV.maxEval});
        CV.t = CV.t + 1;     
    end
    
    progress('refresh');
    progress('resetbar',{'Iterations', 'Evaluations'});
    
    varargout{1} = Xopt;
    varargout{2} = Fbest;
    varargout{3} = CostHistory;
    varargout{4} = ExecutionTime;
    varargout{5} = [];
    
end

