function [CV] = initializeControlVariables(Problem, Solver)
    
    switch class(Solver)
          case {'ga', 'de', 'jade'}
                if ~isempty(Solver.MaxGenerations)
                    CV.maxIter = Solver.MaxGenerations;
                else
                    CV.maxIter = inf;
                end
                CV.closeBoxString = 'Max generations';
                progress('addbar','Generations');
            case {'pso', 'gsa'}
                if ~isempty(Solver.MaxIterations)
                    CV.maxIter = Solver.MaxIterations;
                else
                    CV.maxIter = inf;
                end
                CV.closeBoxString = 'Max iterations';
                progress('addbar','Iterations');
    end
    if isempty(Solver.MaxEvaluations)
        CV.maxEval = inf;
    else
        CV.maxEval = Solver.MaxEvaluations;
    end
    isMin = Problem.IsMinimization;
    if isempty(Solver.StopCriteria)
        if isMin
            CV.fObjCrit = -inf;
        else
            CV.fObjCrit = inf;
        end
    else
        CV.fObjCrit = Solver.StopCriteria;
    end
    if CV.maxEval ~= inf, progress('addbar', 'Evaluations'); end
    CV.refreshRate = Solver.RefreshRate;
    common.algPresentation(Problem, Solver);
    common.headerPresentation(Problem, Solver);
    
    CV.t = 1;
    CV.neval = 0;
    CV.stopFlag = false;
    
    CV.t0 = clock;  
end
