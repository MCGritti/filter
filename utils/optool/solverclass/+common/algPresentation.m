function algPresentation( Problem, Solver )

    if ~isempty(Problem.Name)
        Name = Problem.Name;
    else
        Name = upper(func2str(Problem.ObjectiveFunction));
    end
    
    fObj = ['@' func2str(Problem.ObjectiveFunction) '.m'];
    
    if ~isempty(Problem.PlotFunction);
        plotFunction = ['@' func2str(Problem.PlotFunction) '.m'];
    else
        plotFunction = '[]';
    end
    
    dim = Problem.Dimension;
    
    if Problem.IsMinimization
        isMin = 'True';
    else
        isMin = 'False';
    end
    
    Header = [Name ' parameters:'];
    
    fprintf('\n %s\n',Header);
    fprintf('\n'); %fprintf('%s\n',repmat('-',1,45));
    fprintf('%22s  %-21s\n','Objetive Function:',fObj);
    fprintf('%22s  %-21s\n','Plot Function:',plotFunction);
    fprintf('%22s  %-21d\n','Problem Dimension:',dim);
    fprintf('%22s  %-21s\n','Is Minimization:',isMin);
    fprintf('\n'); %fprintf('%s\n',repmat('-',1,67));
    fprintf('%15s%14s%15s%17s\n','Boundaries:','Upper','Lower','Is Integer');
    
    for i=1:dim
        if Problem.Integers(i)
            intcon = 'True';
        else
            intcon = 'False';
        end
        var = sprintf('X(%d)',i);
        fprintf('%12s%19.4e%16.4e%12s\n',var,Problem.Boundaries.Upper(i),Problem.Boundaries.Lower(i), ...
            intcon);
    end
    fprintf('\n'); %fprintf('%s\n',repmat('-',1,67));
   
    solver = upper(class(Solver));
    prop = properties(Solver);
    N = length(prop);
    
    header = [solver ' parameters:'];
    fprintf('\n %s\n',header);
    fprintf('\n'); %fprintf('%s\n',repmat('-',1,45));
    
    for i=1:N
        fprintf('%21s:  ',prop{i});
        value = get(Solver, prop{i});
        if ~isempty(value)
            switch class(value)
                case 'double'
                    if numel(value) ~= 1
                        string = '[';
                        for j=1:numel(value)
                            if j~= 1
                                string = [string ' '];
                            end
                            if value(j) == uint32(value(j))
                                string = [string sprintf('%d',value(j))];
                            else
                                string = [string sprintf('%.4f', value(j))];
                            end
                        end
                        string = [string ']'];
                    else
                        if value == uint32(value)
                            string = sprintf('%d',value);
                        else
                            string = sprintf('%.4f', value);
                        end
                    end
                case 'logical'
                    if value
                        string = 'True';
                    else
                        string = 'False';
                    end
                case 'function_handle'
                    string = func2str(value);
                otherwise
                    string = value;
            end
        else
            string = '[]';
        end
        fprintf('%-18s\n',string);
    end
    
    fprintf('\n'); %fprintf('%s\n',repmat('-',1,45));
end

