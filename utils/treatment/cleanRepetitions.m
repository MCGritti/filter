function CleanedData = cleanRepetitions(OriginalData)

    index = 2;                % Variable index
    CleanedData = OriginalData;
    N = length(OriginalData);
    
    while index < N
        if OriginalData(index) == OriginalData(index-1)
            j = index - 1;
            while OriginalData(index) == OriginalData(j)
                if index ~= N
                    index = index + 1;
                else 
                    break;
                end
            end
            y0 = OriginalData(j);
            yf = OriginalData(index);
            m = (yf-y0)/(index-j);
            for k = j:index
                CleanedData(k) = y0 + m*(k-j);
            end
        end
        index = index + 1;
    end
    
end