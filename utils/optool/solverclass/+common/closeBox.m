function closeBox(Flag, ExecutionTime)
    fprintf('%s\n',repmat('-',1,53))
    fprintf('\n\t%s reached\n',Flag);
    fprintf('\tExecuted in %.4f seconds\n',ExecutionTime);
end

