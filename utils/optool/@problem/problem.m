classdef problem < hgsetget
    %PROBLEM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties %Class properties
        Name=[]
        Boundaries = struct('Upper', [], ...
                            'Lower', [])
        ObjectiveFunction=[]
        PlotFunction=[]
        Xopt=[]
        XoptCost = []
        Dimension=[]
        Integers=[]
        IsMinimization=true
        UseInitialGuess=false
        CostHistory=[]
        ExecutionTime=[]
        OtherInformation=[]
    end
    
    methods %Constructor and other methods
        function obj = problem(x0, fobj, dim, vlb, vub, isMinimization, varargin)
            obj.Xopt = x0;
            obj.ObjectiveFunction = fobj;
            obj.Dimension = dim;
            obj.Integers = zeros(1,dim);
            obj.IsMinimization = isMinimization;
            if ~isempty(x0)
                obj.XoptCost = obj.ObjectiveFunction(x0);
            end
            
            
            if (nargin > 6) 
                if (strcmp(varargin{1},'fillbound')) && size(vub,2) == 1 ...
                    && size(vub,1) == 1 && size(vlb,1) == 1 && size(vlb,2) == 1
                    obj.Boundaries.Upper = vub*ones(1,dim);
                    obj.Boundaries.Lower = vlb*ones(1,dim);
                end
            else
                obj.Boundaries.Upper = vub;
                obj.Boundaries.Lower = vlb;
            end
        end
        
        [Xopt, Fbest, CostHistory, ExecutionTime] = Optimize(obj, Solver);
        
        Statistics = StatisticTest(obj, Solver, nTests, varargin);
        
        function Cost = EvalXopt(obj)
            if ~isempty(obj.Xopt)
                Cost = obj.ObjectiveFunction(obj.Xopt);
                obj.XoptCost = Cost;
            else
                fprintf(2,'\n\tNo Xopt defined\n\n');
            end
        end
        
        function PlotXopt(obj)
            if ~isempty(obj.PlotFunction) && ~isempty(obj.Xopt)
                obj.PlotFunction(obj.Xopt);
            else
                fprintf(2,'\nNo PlotResultFunction defined or no result to plot\n');
            end
        end
    end
    
end

