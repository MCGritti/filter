classdef gsa < hgsetget 
    
    properties
        PopSize=30
        G0=10
        Alpha=1
        IsElitist=true
        MaxIterations=1000
        MaxEvaluations=[]
        StopCriteria=[]
        Bounded=true
        RefreshRate=100
    end
    
    methods
        function Config(this)
            common.configParameters(this);
        end
        
        function set.Bounded(this, value)
            if value
                this.Bounded = true;
            else
                this.Bounded = false;
            end
        end    
    end
    
    methods (Static, Hidden)
        function CL = ConfigLayout
            CL.FieldNames = {...
			'PopSize', ...
			'G0', ...
			'Alpha', ...
			'Elitist', ...
			'Max Iterations', ...
			'Max Evaluations', ...
			'Desired Fobj Value', ...
			'Bounded', ...
			'Refresh Rate', ...
            };
            CL.HasSugestions = [...
			false, ... % PopSize
			false, ... % G0
			false, ... % Alpha
			true, ...  % Elitist
			false, ... % Max Iterations
			false, ... % Max Evaluations
			false, ... % Desired Fobj Value
			true, ...  % Bounded
			false, ... % Refresh Rate
            ];
            CL.Sugestions = {...
			[], ...                     % PopSize
			[], ...                     % G0
			[], ...                     % Alpha
			{'true', 'false'}, ...      % Elitist
			[], ...                     % Max Iterations
			[], ...                     % Max Evaluations
			[], ...                     % Desired Fobj Value
			{'true', 'false'}, ...      % Bounded
			[], ...                     % Refresh Rate
            };
        end
        
        function Output = ParameterBoundaries
            Output.Class = {...
			'Integer', ... 	% PopSize
			'Double', ... 	% G0
			'Double', ... 	% Alpha
			'Logical', ... 	% Elitist
			'Integer', ... 	% Max Iterations
			'Integer', ... 	% Max Evaluations
			'Double', ... 	% Desired Fobj Value
			'Logical', ... 	% Bounded
			'Integer', ... 	% Refresh Rate
            };
            Output.Lower = {...
			0, ... 	% PopSize
			0, ... 	% G0
			0, ... 	% Alpha
			[], ... 	% Elitist
			0, ... 	% Max Iterations
			0, ... 	% Max Evaluations
			-Inf, ... 	% Desired Fobj Value
			[], ... 	% Bounded
			1, ... 	% Refresh Rate
            };
            Output.Upper = {...
			Inf, ... 	% PopSize
			Inf, ... 	% G0
			Inf, ... 	% Alpha
			[], ... 	% Elitist
			Inf, ... 	% Max Iterations
			Inf, ... 	% Max Evaluations
			Inf, ... 	% Desired Fobj Value
			[], ... 	% Bounded
			Inf, ... 	% Refresh Rate
            };
            Output.Size = [...
			1, ... 	% PopSize
			1, ... 	% G0
			1, ... 	% Alpha
			1, ... 	% Elitist
			1, ... 	% Max Iterations
			1, ... 	% Max Evaluations
			1, ... 	% Desired Fobj Value
			1, ... 	% Bounded
			1, ... 	% Refresh Rate
            ];
            Output.Empty = [...
			false, ... % PopSize
			false, ... % G0
			false, ... % Alpha
			false, ... % Elitist
			true, ...  % Max Iterations
			true, ...  % Max Evaluations
			true, ...  % Desired Fobj Value
			false, ... % Bounded
			false, ... % Refresh Rate
            ];
        end
    end
    
end

