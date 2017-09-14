classdef ga < hgsetget
    %GA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        PopSize=30
        CrossoverProb=0.9
        MutationProb=0.01
        Bits=16
        Elitist=true
        MaxGenerations=1000
        MaxEvaluations=[]
        StopCriteria=[]
        RefreshRate=100
    end
    
    methods
        function obj = ga(varargin)
            L = nargin;
            if L
                i = 1;
                while i < L
                    switch varargin{i}
                        case {'popsize'}
                            obj.PopSize = varargin{i+1};
                        case {'crossoverprob', 'crossprob', 'C'}
                            obj.CrossoverProb = varargin{i+1};
                        case {'mutationprob', 'mutprob', 'M'}
                            obj.MutationProb = varargin{i+1};
                        case {'bits'}
                            obj.Bits = varargin{i+1};
                        case {'elitist'}
                            obj.Elitist = varargin{i+1};
                        case {'maxgenerations', 'maxgen'}
                            obj.MaxGenerations = varargin{i+1};
                        case {'maxeval', 'maxevaluations'}
                            obj.MaxEvaluations = varargin{i+1};
                        case {'stopcriteria', 'fstop'}
                            obj.StopCriteria = varargin{i+1};
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

