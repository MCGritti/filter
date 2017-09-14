classdef de < hgsetget
    %DE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        PopSize=30
        ScaleFactor=0.8
        MutationProb=0.85
        Strategy='DE\1'
        MaxGenerations=1000
        MaxEvaluations=[]
        StopCriteria=[]
        Bounded=true
        RefreshRate=100
    end
    
    methods
        function obj = de(varargin)
            L = nargin;
            if L
                i = 1;
                while i < L
                    switch varargin{i}
                        case {'popsize'}
                            obj.PopSize = varargin{i+1};
                        case {'scalefactor', 'F'}
                            obj.ScaleFactor = varargin{i+1};
                        case {'mutationprob', 'mutprob', 'C'}
                            obj.MutationProb = varargin{i+1};
                        case {'maxgenerations', 'maxgen'}
                            obj.MaxGenerations = varargin{i+1};
                        case {'maxeval', 'maxevaluations'}
                            obj.MaxEvaluations = varargin{i+1};
                        case {'stopcriteria', 'fstop'}
                            obj.StopCriteria = varargin{i+1};
                        case {'bounded', 'isbounded'}
                            obj.Bounded = varargin{i+1};
                        case {'refreshrate'}
                            obj.RefreshRate = varargin{i+1};
                        otherwise
                            fprintf(2,'\nParameter %s not recognized\n',varargin{i});
                    end
                    i = i+2;
                end
            end
        end
    end
    
end

