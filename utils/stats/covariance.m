function [ Cov ] = covariance( x )
    [M, ~] = size(x);
    mu = mean(x);
    X = x - repmat(mu, M, 1);
    Cov = X'*X/(M-1);
end

