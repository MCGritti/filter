function Statistics = StatisticTest(obj, Solver, nTests, varargin)
%% Statistics = StatisticTest(Solver, nTests, ProblemName[Optional])
%  Get the satistical results of N tests runned for a desired solver

    if nargin > 3
        ProblemName = varargin{4};
    else
        ProblemName = func2str(obj.ObjectiveFunction);
    end
    
    switch class(Solver)
        case {'de', 'ga', 'jade'}
            L = Solver.MaxGenerations;
            Label = 'Generations';
        case {'pso', 'gsa'}
            L = Solver.MaxIterations;
            Label = 'Iterations';
    end
    
    saveState.StopCriteria = Solver.StopCriteria;
    saveState.UseInitialGuess = obj.UseInitialGuess;
    
    Solver.StopCriteria = []; %If Stop Criteria is seted, it will be cleared
    obj.UseInitialGuess = false; %If InitialGuess is seted, it will be cleared
    Xopt = zeros(nTests, obj.Dimension);
    Fbest = zeros(1,nTests);
    CostHistory = zeros(nTests, L);
    ExecutionTime = zeros(1,nTests);
    Solv = upper(class(Solver));
    
    progress('addbar','Runs');
    progress('DisplayName', [Solv ' running']);
    rand('seed',1);
    
    for i=1:nTests
    
        switch class(Solver)
            case 'pso'
                [Xopt(i,:), Fbest(i), CostHistory(i,:), ExecutionTime(i)] = solvers.runpso(obj,Solver);
            case 'de'
                [Xopt(i,:), Fbest(i), CostHistory(i,:), ExecutionTime(i)] = solvers.runde(obj,Solver);
            case 'ga'
                [Xopt(i,:), Fbest(i), CostHistory(i,:), ExecutionTime(i)] = solvers.runga(obj,Solver);
            case 'gsa'
                [Xopt(i,:), Fbest(i), CostHistory(i,:), ExecutionTime(i)] = solvers.rungsa(obj,Solver);
            case 'jade'
                [Xopt(i,:), Fbest(i), CostHistory(i,:), ExecutionTime(i), sCR, sF] = solvers.runjade(obj,Solver);
                ParameterHistory.CR = sCR;
                ParameterHistory.F = sF;
            otherwise
        end
        
        per = i/nTests;
        progress({'Runs', per});
    end
    
    progress;
    if obj.IsMinimization
        [~, idx] = min(Fbest);
        Type = 'Minimization';
    else
        [~, idx] = max(Fbest);
        Type = 'Maximization';
    end
    
    Xopt = Xopt(idx,:);
    results{1} = Fbest;
    results{2} = CostHistory;
    results{3} = ExecutionTime;
    Statistics = statistics(ProblemName, nTests, Xopt, results, Type, upper(class(Solver)));

    Solver.StopCriteria = saveState.StopCriteria;
    obj.UseInitialGuess = saveState.UseInitialGuess;
    
end

