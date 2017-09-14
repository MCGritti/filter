function [ varargout ] = csvfilereader( varargin )
%READSYNC Fast CSV File Reader usign Perl scripts.
%   Detailed explanation goes here
    
    [filename, hasHeader, refreshRate, sep] = argparser({'filename', 'hasHeader', 'refreshRate', 'sep'}, ...
                                                        {'sync.csv', 1, 200, ','}, ...
                                                        {'char', 'double', 'double', 'char'}, ...
                                                         varargin);
    
    %% Get file information
    [nrow, ncol] = filesummary( filename, sep );
    
    %% If has header, get header information
    fid = fopen(filename, 'r');
    if hasHeader
        header = regexp(fgetl(fid), '([A-Za-z0-9_ ]*),?', 'tokens');
        header = [header{:}];
        nrow = nrow - 1;
    else
        header = [];
    end
    
    %% Get number of rows and pre-allocate space.
    h = waitbar(0, 'Allocating Space');
    data = zeros(nrow, ncol);
    
    %% Read data
    k = 0;
    waitbar(0, h, 'Reading data');
    while ~feof(fid)
        if ~rem(k, refreshRate)            
            msg = sprintf('Reading file %s: %.2f%% completed', filename, (k+1)/nrow*100);
            waitbar((k+1)/nrow, h, msg);
        end
        k = k + 1;
        data(k, 1:ncol-1) = fscanf(fid, '%f,', ncol-1);
        data(k, end) = fscanf(fid, '%f\n', 1);       
    end
    
    fclose(fid);
    close(h);
    
    if hasHeader
        varargout = {header, data};
    else
        varargout = {data};
    end
end

