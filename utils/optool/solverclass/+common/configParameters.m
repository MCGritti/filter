function configParameters(solver)

% Layout strings
[strName, strValue, hasSugestions, Sugestions] = common.getconfigparameters(solver);
buttons = {'Save in Object',   'Save in File'};

% Layout inicialization
fontSize = 9;
bgc = [0.9 0.9 0.9];
objheight = 0.025;
objwidth = 0.08;
rows = numel(strName);
cols = 2;
vpad = 0.015;
hpad = 0.01;
width = cols*(hpad + objwidth) + hpad;
height = (rows+1)*(vpad + objheight) + vpad;
left = (1-width)/2;
bottom = (1-height)/2;
alignfactor = 0.004;

% Create figure
hObj.Figure = figure(...
    'Units', 'normalized', ...
    'Position', [left bottom width height], ...
    'Resize', 'off', ...
    'MenuBar', 'none', ...
    'Color', bgc, ...
    'Name', sprintf('Class %s configuration',class(solver)), ...
    'NumberTitle', 'off');

% Normalize constants
left = hpad/width;
objheight = objheight/height;
objwidth = objwidth/width;
vpad = vpad/height;
hpad = hpad/width;
alignfactor = alignfactor/height;

% Display parameter name
for i=1:rows
    bottom = 1 - (objheight + vpad)*i - alignfactor;
    
    hObj.Strings{i} = uicontrol(...
        'Style', 'Text', ...
        'Units', 'normalized', ...
        'FontSize', fontSize, ...
        'String', [strName{i} ' :'], ...
        'Background', bgc, ...
        'HorizontalAlignment', 'right', ...
        'FontWeight', 'bold', ...
        'ForegroundColor', [0.1 0.1 0.1], ...
        'Position', [left bottom objwidth objheight]);
end

% Display edit/listboxes
left = left+hpad+objwidth;
for i=1:rows
    bottom = 1 - (objheight + vpad)*i;
    if ~hasSugestions(i)
        hObj.Edits{i} = uicontrol(...
                'Style', 'edit', ...
                'Units', 'normalized', ...
                'String', strValue{i}, ...
                'Background', [1 1 1], ...
                'HorizontalAlignment', 'left', ...
                'FontSize', fontSize+1, ...
                'Position', [left bottom objwidth objheight]);
    else
        string = Sugestions{i};
        idx = 1;
        while ~strcmp(string{idx},strValue{i})
            idx = idx + 1;
        end
        hObj.Edits{i} = uicontrol(...
                'Style', 'popupmenu', ...
                'Units', 'normalized', ...
                'String', string, ...
                'Background', [1 1 1], ...
                'HorizontalAlignment', 'left', ...
                'FontSize', fontSize+1, ...
                'Value', idx, ...
                'Position', [left bottom objwidth objheight]);
    end
end

% Create buttons
for i=1:2
    left = hpad + (objwidth+hpad)*(i-1);
    bottom = vpad;
    hObj.Buttons{i} = uicontrol(...
        'Style', 'pushbutton', ...
        'Units', 'normalized', ...
        'String', buttons{i}, ...
        'fontSize', fontSize, ...
        'FontWeight', 'bold', ...
        'Position', [left bottom objwidth objheight]);
end
set(hObj.Buttons{1}, 'Callback', {@buttonPress,hObj,solver});
set(hObj.Buttons{2}, 'Callback', {@buttonPress,hObj,solver});

function solver = buttonPress(sender, ~, handles, solver)
    closeFlag = true;
    if sender == handles.Buttons{1}
        [props, values, errorFlag] = common.readValues(solver, handles);
        if any(errorFlag)
            common.refreshFigure(handles, errorFlag);
            closeFlag = false;
        end
        for i=1:numel(props)
            set(solver, props{i}, values{i});
        end
        disp('Solver actualized');
    else
        
    end
    if closeFlag
        delete(handles.Figure);
    end