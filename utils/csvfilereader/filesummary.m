function [ nrows, ncols ] = filesummary( file, sep )
    string = perl('filesummary.pl', file, sep);
    logidx = string == ' ';
    cutidx = 1;
    while ~logidx(cutidx), cutidx = cutidx + 1; end;
    nrows = str2double(string(1:cutidx));
    ncols = str2double(string(cutidx+1:end));
end

