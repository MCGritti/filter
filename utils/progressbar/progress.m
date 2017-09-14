function progress(varargin)

persistent progfig progdata figprop t0;

%---------------
% Get inputs
%---------------

if nargin > 0
    input = varargin;
    ninput = nargin;
else
    input = {[]};
    delete(progfig);
    clear progfig progdata figprop t0;
end

%-------------------------------
% Refresh the bars
%-------------------------------
if ~isempty(input{1}) && isa(input{1}, 'cell')
    if ishandle(progfig)
        L = numel(input{1});
        for i=1:2:L
            Value = input{1}{i+1};
            if isa(input{1}{i},'char')
                for j = 1:figprop.nbars
                    if strcmpi(progdata{j}.ID,input{1}{i})
                        progdata{j}.progvalue = Value;
                    end
                end
            else
                Idx = input{1}{i};
                if Idx <= figprop.nbars
                    progdata{Idx}.progvalue = Value;
                end
            end
        end
    end
    if isempty(t0)
        t0 = clock;
    else
        if etime(clock,t0) < 0.035
            return;
        elseif ishandle(progfig)
            for i = 1:figprop.nbars
                set(progdata{i}.progpatch, 'XData', [0 progdata{i}.progvalue progdata{i}.progvalue 0]);
                set(progdata{i}.progtext, 'String', sprintf('%.1f%%', progdata{i}.progvalue*100));
            end
            t0 = clock;
            drawnow;
        end
    end
end

%-------------------------------
% Interpreter
%-------------------------------

if ~isempty(input{1}) && isa(input{1},'char')  && ninput > 1
    
    %--* Graph parameters *--%
        vpad = 0.005;
        hpad = 0.004;
        width = 0.25;
        left = (1-width)/2;
        barheight = 0.018;
        FontSize = 0.6;
    
    %---------------
    % Create new bar
    %-----------------------------------------------------
    if strcmpi(input{1},'addbar') && isa(input{2}, 'char')
        t0 = clock;
        if ishandle(progfig) %--* Resize the handler *--%
        
            canAdd = true;
            for i = 1:figprop.nbars
                if strcmp(input{2},progdata{i}.ID)
                    canAdd = false;
                end
            end
            
            if canAdd
                figprop.nbars = figprop.nbars + 1;
        
                height = vpad + figprop.nbars*(barheight+vpad);
                factor = barheight+vpad;
                P = get(progfig, 'Position') + [0 -factor 0 factor];
        
                set(progfig, 'Position', P);
        
                barheight = barheight/height;
                vpad = vpad/height;
                hpad = hpad/width;
                width = 1 - 2*hpad;
        
                %--* Positioning the old bars *--%
        
                for i = 1:figprop.nbars-1
                    bottom = 1 - (vpad+barheight)*i;
                    set(progdata{i}.progaxes, 'Position', [hpad bottom width barheight]);
                end
        
                progdata{figprop.nbars}.progaxes = axes(...
                    'Position',[hpad vpad width barheight] , ...
                    'YTick', [], ...
                    'XTick', [], ...
                    'XLim', [0 1], ...
                    'YLim', [0 1], ...
                    'Box', 'on');
                progdata{figprop.nbars}.progpatch = patch(...
                    'XData', [0 0 0 0], ...
                    'YData', [0 0 1 1], ...
                    'FaceColor', 0.3+0.6*rand(1,3));
                progdata{figprop.nbars}.progtext = text(0.99, 0.5, '', ...
                    'HorizontalAlignment', 'Right', ...
                    'FontUnits', 'normalized', ...
                    'FontSize', FontSize, ...
                    'FontWeight', 'bold', ...
                    'String', '0.0%');
                progdata{figprop.nbars}.proglabel = text(0.01, 0.5, '', ...
                    'HorizontalAlignment', 'Left', ...
                    'FontUnits', 'Normalized', ...
                    'FontSize', FontSize, ...
                    'FontWeight', 'bold');
                progdata{figprop.nbars}.progvalue = 0;
        
                progdata{figprop.nbars}.ID = input{2};
                set(progdata{figprop.nbars}.proglabel, 'String', input{2});
            end
        
        else  %--* Createa Progress Bar Figure Handler *--%
            clear persistent;
        
            figprop.DisplayName = '';
            figprop.nbars = 1;
        
            height = vpad + figprop.nbars*(barheight+vpad);
            bottom = (1-height)/2;
        
            progfig = figure(...
                'Units', 'normalized', ...
                'NumberTitle', 'off', ...
                'MenuBar', 'none', ...
                'Position', [left bottom width height], ...
                'Resize', 'off', ...
                'Name', figprop.DisplayName, ...
                'WindowStyle', 'normal');
        
            barheight = barheight/height;
            vpad = vpad/height;
            hpad = hpad/width;
            width = 1 - 2*hpad;
        
            progdata{1}.progaxes = axes(...
                'Position',[hpad vpad width barheight] , ...
                'YTick', [], ...
                'XTick', [], ...
                'XLim', [0 1], ...
                'YLim', [0 1], ...
                'Box', 'on');
            progdata{1}.progpatch = patch(...
                'XData', [0 0 0 0], ...
                'YData', [0 0 1 1], ...
                'FaceColor', 0.3+0.6*rand(1,3));
            progdata{1}.progtext = text(0.99, 0.5, '', ...
                'HorizontalAlignment', 'Right', ...
                'FontUnits', 'normalized', ...
                'FontSize', FontSize, ...
                'FontWeight', 'bold', ...
                'String', '0.0%');
            progdata{1}.proglabel = text(0.01, 0.5, '', ...
                'HorizontalAlignment', 'Left', ...
                'FontUnits', 'Normalized', ...
                'FontSize', FontSize, ...
                'FontWeight', 'bold');
            progdata{figprop.nbars}.progvalue = 0;
        
            progdata{1}.ID = input{2};
            set(progdata{1}.proglabel, 'String', input{2});
        end
    %-------------------
    % Insert DisplayName
    %-------------------------------------------------------------
    elseif strcmpi(input{1},'DisplayName') && isa(input{2}, 'char')
        if ishandle(progfig)
            figprop.DisplayName = input{2};
            set(progfig, 'Name', figprop.DisplayName);
        end
    %-----------
    % Delete bar
    %------------------------------------------------------------
    elseif strcmpi(input{1},'deletebar')
    
        if ishandle(progfig)
        
            if isempty(input{2})
                if isempty(input{3})
                    Idxs = figprop.nbars;
                else
                    Idxs = figprop.nbars:-1:figprop.nbars-input{3}+1;
                end
            else
                switch class(input{2})
                    case 'cell'
                        Idxs = [];
                        for i = 1:figprop.nbars
                            for j = 1:numel(input{2})
                                if strcmpi(input{2}{j}, progdata{i}.ID)
                                    Idxs = [Idxs i];
                                end
                            end
                        end
                    case 'char'
                        for i = 1:figprop.nbars
                            if strcmpi(input{2}, progdata{i}.ID)
                                Idxs = i;
                            end
                        end
                    case 'double'
                        Idxs = input{2};
                end
            end
            
            L = figprop.nbars;
            i = 1;
            
            while i <= L
                if any(Idxs == i)
                    delete(progdata{Idxs(Idxs==i)}.progaxes);
                    progdata(Idxs(Idxs==i)) = [];
                    Idxs(Idxs==i) = [];
                    Idxs = Idxs - 1;
                    L = L - 1;
                else
                    i = i + 1;
                end
            end
            
            if ~L
                delete(progfig);
                clear progfig progdata figprop t0;
                return;
            else %--* Resize the handler *--%
                
        
                height = vpad + L*(barheight+vpad);
                factor = (barheight+vpad)*(figprop.nbars - L);
                figprop.nbars = L;
                sF = 1000;
                P = round(sF*get(progfig, 'Position'))/sF;
        
                set(progfig, 'Position', [round(P(1)*sF)/sF round((P(2)+factor)*sF)/sF width height]);
        
                barheight = barheight/height;
                vpad = vpad/height;
                hpad = hpad/width;
                width = 1 - 2*hpad;
        
                %--* Positioning the bars *--%
        
                for i = 1:figprop.nbars
                    bottom = 1 - (vpad+barheight)*i;
                    set(progdata{i}.progaxes, 'Position', [hpad bottom width barheight]);
                end
            end
        end
    %----------
    % Reset bar
    %----------------------------------
    elseif strcmpi(input{1},'resetbar')
        if ishandle(progfig)
            if isempty(input{2})
                if isempty(input{3}) %--* Sintax: progress('resetbar', [1 3])
                    Idxs = figprop.nbars;
                else                 %--* Sintax: progress('resetbar', [], 2)
                    Idxs = figprop.nbars:-1:figprop.nbars-input{3}+1;
                end
            else
                switch class(input{2})
                    case 'cell'
                        Idxs = [];
                        for i = 1:figprop.nbars
                            for j = 1:numel(input{2})
                                if strcmpi(input{2}{j}, progdata{i}.ID)
                                    Idxs = [Idxs i];
                                end
                            end
                        end
                    case 'char'
                        for i = 1:figprop.nbars
                            if strcmpi(input{2}, progdata{i}.ID)
                                Idxs = i;
                            end
                        end
                    case 'double'
                        Idxs = input{2};
                end
            end
            
            L = numel(Idxs);
            
            if L == figprop.nbars
                delete(progfig);
                clear progfig progdata figprop t0;
                return;
            else
                for i = 1:figprop.nbars
                    if any(Idxs == i)
                        progdata{i}.progvalue = 0;
                        set(progdata{i}.progpatch, 'XData', [0 0 0 0]);
                        set(progdata{i}.progtext, 'String', '0.0%');
                        drawnow;
                    end
                end
            end
        end
    end
elseif ~isa(input{1},'cell')
    if strcmpi(input{1},'refresh') && ishandle(progfig)
        for i = 1:figprop.nbars
                set(progdata{i}.progpatch, 'XData', [0 progdata{i}.progvalue progdata{i}.progvalue 0]);
                set(progdata{i}.progtext, 'String', sprintf('%.1f%%', progdata{i}.progvalue*100));
        end
        t0 = clock;
        drawnow;
    end
end

%-------------------------------
% Another functions
%-------------------------------