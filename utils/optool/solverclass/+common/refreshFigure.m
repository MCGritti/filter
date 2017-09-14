function refreshFigure( hObj, errorFlag )
    L = numel(errorFlag);
    
    for i=1:L
        if errorFlag(i)
            set(hObj.Strings{i},'Foregroundcolor', [1 0 0]);
        else
            set(hObj.Strings{i},'Foregroundcolor', [0 0 0]);
        end
    end
end

