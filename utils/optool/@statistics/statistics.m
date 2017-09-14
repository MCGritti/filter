classdef statistics < hgsetget
    %STATISTICS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ProblemName
        ProblemType
        Solver
        Executions
        Min
        Max
        Mean
        Std
        Xopt
        MeanExecutionTime
        TotalExecutionTime 
        MeanCostHistory
        BestCostHistory
        WorstCostHistory
    end
    
    methods
        function obj = statistics(pName, nTests, Xopt, result, Type, Solver)
            obj.ProblemName = pName;
            obj.Executions = nTests;
            obj.Xopt = Xopt;
            obj.ProblemType = Type;
            obj.Solver = Solver;
            fobj = result{1};
            costs = result{2};
            times = result{3};
            
            obj.Min = min(fobj);
            obj.Max = max(fobj);
            obj.Mean = mean(fobj);
            obj.Std = std(fobj);
            
            obj.MeanExecutionTime = mean(times);
            obj.TotalExecutionTime = sum(times);
            
            finalValues = costs(:,end);
            if strcmp(Type,'Minimization')
                [~, bestIdx] = min(finalValues);
                [~, worstIdx] = max(finalValues);
            else
                [~, bestIdx] = max(finalValues);
                [~, worstIdx] = min(finalValues);
            end
            obj.BestCostHistory = costs(bestIdx,:);
            obj.WorstCostHistory = costs(worstIdx,:);
            obj.MeanCostHistory = mean(costs);
        end
    end
    
end

