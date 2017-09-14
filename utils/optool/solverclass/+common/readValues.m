function [ props, values, errorFlag ] = readValues( solver, hObj )

    props = properties(solver);
    boundaries = solver.ParameterBoundaries;
    L = length(props);
    values = cell(L,1);
    errorFlag = zeros(L,1);
    
    %------------------------
    % Read values from Figure
    %------------------------
    for i = 1:L
        handleValue = get(hObj.Edits{i}, 'String');
        if ~isa(handleValue, 'cell')
            handleValue(handleValue == '[' | handleValue == ']' | handleValue == ' ') = [];
            if strcmp(handleValue, '') || isempty(handleValue)
                if boundaries.Empty(i)
                    values{i} = [];
                else
                    values{i} = get(solver,props{i});
                    errorFlag(i) = true;
                end
            else
                varSize = sum(handleValue == ';') + 1;
                if varSize > 1
                    aux = 1;
                    cont = 1;
                    string = cell(varSize,1);
                    H = length(handleValue);
                    while aux <= H
                        if handleValue(aux) == ';'
                            if aux == 1
                                errorFlag(i) = true;
                                handleValue(1) = [];
                                H = H - 1;
                            else
                                string{cont} = handleValue(1:aux-1);
                                handleValue(1:aux) = [];
                                H = H - aux;
                                cont = cont + 1;
                                aux = 1;
                            end
                        else
                            aux = aux + 1;
                        end
                    end
                    string{cont} = handleValue;
                    for j = 1:cont
                        switch boundaries.Class{i}
                            case 'Integer'
                                values{i} = [values{i} round(str2double(string{j}))];
                            case 'Double'
                                values{i} = [values{i} str2double(string{j})];
                            case 'Function'
                                values{i} = [values{i} str2func(string{j})];
                            case 'String'
                                values{i} = [values{i} string{j}];
                        end
                    end
                else
                    switch boundaries.Class{i}
                        case 'Integer'
                            values{i} = round(str2double(handleValue));
                        case 'Double'
                            values{i} = str2double(handleValue);
                        case 'Function'
                            values{i} = str2func(handleValue);
                        case 'String'
                            values{i} = handleValue;
                    end
                end
            end
        else
            switch boundaries.Class{i}
                    case 'Logical'
                        Idx = get(hObj.Edits{i}, 'Value');
                        Str = get(hObj.Edits{i}, 'String');
                        Str = Str{Idx};
                        if strcmp(Str,'true')
                            values{i} = true;
                        else
                            values{i} = false;
                        end
                    case 'String'
                        Idx = get(hObj.Edits{i}, 'Value');
                        Str = get(hObj.Edits{i}, 'String');
                        values{i} = Str;
             end
        end
    end

    %---------------
    % Check Var Size
    %---------------
    for i = 1:L
        if numel(values{i}) > boundaries.Size(i)
            values{i}(boundaries.Size+1:end) = [];
            errorFlag(i) = true;
        end
    end
    
    %--------------
    % Check boundaries
    %---------------
    for i = 1:L
        if ~isempty(boundaries.Lower{i})
            j = numel(values{i});
            for k=1:j
                if values{i}(k) < boundaries.Lower{i}
                    values{i}(k) = boundaries.Lower{i};
                    errorFlag(i) = true;
                elseif values{i}(k) > boundaries.Upper{i}
                    values{i}(k) = boundaries.Upper{i};
                    errorFlag(i) = true;
                end
            end
        end
    end
    
    %------------
    % Check NAN
    %------------
    for i = 1:L
        j = numel(values{i});
        for k=1:j
            if isnan(values{i}(j))
                errorFlag(i) = true;
            end
        end
    end
end

