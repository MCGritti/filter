function [varargout] = runde(problem, solver, varargin)

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
    
    %Load de parameters
    
    N = solver.PopSize;
    F = solver.ScaleFactor;
    C = solver.MutationProb;
    bounded = solver.Bounded; 
    
    %% DE Code
    
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
    
    U = X;
    costs = zeros(1,N);
    
    for i=1:N
        costs(i) = fObj(X(i,:));
    end
    
    if isMin
        Fbest = min(costs);
    else
        Fbest = max(costs);
    end

    CostHistory = [];
    
    CV = solvers.initializeControlVariables(problem, solver);
    
    while ~CV.stopFlag
        
        for i=1:N
            r = randperm(N);
            delta = randi(dim);
            
            for j=1:dim
                if (rand < C) || (j == delta)
                    U(i,j) = X(r(1),j) + F*(X(r(2),j) - X(r(3),j));
                    if intcon(j)
                        U(i,j) = round(U(i,j));
                    end
                    if bounded
                        if U(i,j) < vlb(j)
                            U(i,j) = vlb(j);
                        elseif U(i,j) > vub(j)
                                U(i,j) = vub(j);
                        end
                    end
                else
                    U(i,j) = X(i,j);
                end
            end
        end
        
        for i=1:N %Evaluate Population
            tempCost = fObj(U(i,:));
            
            if isMin
                if tempCost < costs(i)
                    X(i,:) = U(i,:);
                    costs(i) = tempCost;
                end
                if tempCost < Fbest
                    Fbest = tempCost;
                    Xopt = X(i,:);
                end
            else
                if tempCost > costs(i)
                    X(i,:) = U(i,:);
                    costs(i) = tempCost;
                end
                if tempCost > Fbest
                    Fbest = tempCost;
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

