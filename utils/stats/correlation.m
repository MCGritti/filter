function [ Corr ] = correlation( x )

    M    = size(x, 2);
    Cov  = covariance( x );
    Std  = deviation( x );
    Corr = zeros( M );
    
    for i = 1:M-1
        for j = i+1:M
            Corr(i, j) = Cov(i, j)/(Std(i)*Std(j));
        end
    end

    Corr = Corr + Corr' + eye(M);
    
end

