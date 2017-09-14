function [Xopt, Fbest, CostHistory, ExecutionTime] = Optimize(obj, Solver)

    solvername = class(Solver);
    [Xopt, Fbest, CostHistory, ExecutionTime, ArgOut] = feval(['solvers.run' solvername],obj,Solver);
 
    obj.Xopt = Xopt;
    obj.XoptCost = Fbest;
    obj.CostHistory = CostHistory;
    obj.ExecutionTime = ExecutionTime;
    obj.OtherInformation = ArgOut;
end

