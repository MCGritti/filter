function headerPresentation( problem, solver )

    switch class(solver)
        case {'de', 'jade', 'ga'}
            string = 'Generation';
        case {'pso', 'gsa'}
            string = 'Iteration';
    end
    fprintf('\n Optimizing @%s.m\n',func2str(problem.ObjectiveFunction));
    fprintf('%s\n',repmat('-',1,53));
    fprintf('|%14s%34s%4s\n',string,'Objective Function Value','|');

end

