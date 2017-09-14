function varargout = argparser(properties, defaults, classes, arguments)
%ARGPARSER Take a cell of pair arguments and split them into configuration
%          parameters
%
%   <Inputs>
%       properties: cell containing the properties name.
%       defaults: default value for parameters (can be a generation
%       function).
%       classes: list containing the classes of the properties.
%       arguments: usually the varargin of the caller script.
%   <Output>
%       varargout = {propertie1, propertie2, ..., propertieN}

    assert(iscell(properties), 'properties must be a cell object');
    
    Np = length(properties);
    Na = length(arguments);
    Nd = length(defaults);
    Nt = length(classes);
    assert(Np == Nd && Nd == Nt, 'properties and defaults must have the same size');
    
    varargout = defaults;
    
    for k = 2:2:Na
        idx = cellfun(@(x) ~isempty(regexp(x, arguments{k-1}, 'match')), properties);
        assert(any(idx) && sum(idx) == 1, [sprintf('Property ''%s'' not found.\n', arguments{k-1}) ...
                          sprintf('These are the available options:\n') ...
                          sprintf('''%s'' ', properties{:})]);
        assert( isa(arguments{k}, classes{idx}), sprintf('Property ''%s'' must receive a ''%s'' object.\n', properties{idx}, classes{idx}));
        varargout{idx} = arguments{k};
    end  
end