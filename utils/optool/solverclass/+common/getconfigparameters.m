function [ strName, strValue, hasSugestions, Sugestions] = getconfigparameters( solver )

CL = solver.ConfigLayout;
strName = CL.FieldNames;
hasSugestions = CL.HasSugestions;
Sugestions = CL.Sugestions;
prop = properties(solver);
N = length(prop);

for i=1:N
    value = get(solver, prop{i});
    if ~isempty(value)
        switch class(value)
            case 'double'
                if numel(value) ~= 1
                    string = '[';
                    for j=1:numel(value)
                        if j~= 1
                            string = [string ' ; '];
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
                    string = 'true';
                else
                    string = 'false';
                end
            case 'function_handle'
                string = func2str(value);
            otherwise
                string = value;
        end
    else
        string = '[]';
    end
    strValue{i} = string;
end

end

