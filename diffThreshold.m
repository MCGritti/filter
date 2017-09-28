% Deadzone differenciator filter
function y = diffThreshold(y, th)
    L = length(y);
    ref = y(1);
    for i = 2:L
        dy = y(i) - ref;
        s = sqrt(dy^2);
        if s > th
            y(i) = ref;
        else
            ref = y(i);
        end
    end
end