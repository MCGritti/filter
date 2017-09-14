function obj = plot( obj )
%PLOT Summary of this function goes here
%   Detailed explanation goes here
    costHistory = obj.MeanCostHistory;
    L = length(costHistory);
    plot(1:L,costHistory);
    
    xlabel('Iter/Gen');
    ylabel('Cost');
    
    title(sprintf('Mean cost history of %s',obj.Solver));
end

