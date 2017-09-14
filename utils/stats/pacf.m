function varargout = pacf( y, varargin )
%PACF Partial Auto Correlation Function
    [maxlags, drawConfidence, confLevel] = argparser({'maxlags', 'drawConfidence', 'confLevel'}, ...
                                                     {20, 1, 1.96}, ...
                                                     {'double', 'double', 'double'}, varargin);
    
    L = length(y);
    
    phi = ones(maxlags+1, 1);
    
    for lag = 1:maxlags
        idxs = (1+lag:L)';
        Y = y(repmat(idxs, 1, lag+1) - repmat(0:lag, L-lag, 1));
        r = correlation(Y);
        R = r(1:end-1,1:end-1);
        Ro = r(1, 2:end)';
        Phi = R\Ro;
        phi(lag+1) = Phi(end);
    end
        
    
    if nargout == 0
        k = 0:maxlags;
        conf = confLevel/sqrt(L-maxlags);
        stem(k, phi, 'color', [0 0 0], 'markerfacecolor', [0 0 0], 'markersize', 4);
        if drawConfidence
            line([.5 maxlags], [conf conf], 'color', [0 0 0], 'linestyle', '--');
            line([.5 maxlags], [-conf -conf], 'color', [0 0 0], 'linestyle', '--');
        end
        title('Partial correlogram');
        xlabel('k');
        ylabel('\pi_k');
        grid;
    else
        varargout = {phi};
    end
    


end

