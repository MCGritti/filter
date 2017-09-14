classdef solver
    %SOLVER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Hidden)
        Type = 'Solver';
    end
    
    methods (Access=private)
        function this = solver(varargin)
            if nargin > 0
                if strcmp(varargin{1},'createnew')
                    CreateSolver;
                end
            end
        end
        
        function obj = disp(obj)
            fprintf('Solver is a base class used to create new ones\n');
            fprintf('It not contains any usable method or property\n');
        end
    end
    
    methods (Static, Hidden, Access=private)
        function createNewSolver
            f = figure('NumberTitle', 'off', ...
                       'Units', 'normalized', ...
                       'Position', [0.4 0.3 0.2 0.4], ...
                       'MenuBar', 'none',  ...
                       'WindowStyle', 'normal', ...
                       'Name', 'Create a new solver class');
            text = uicontrol('Units', 'normalized', ...
                             'Position', [0.1 0.8 0.2 0.1], ...
                             'Style', 'text', ...
                             'String', 'Solver name :');
            table = uitable();
            
        end
    end
    
end

