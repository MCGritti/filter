function [ varargout ] = acf( y, varargin )
%ACF Auto Correlation Function.
    [maxlags, drawConfidence, confLevel] = argparser({'maxlags', 'drawConfidence', 'confLevel'}, ...
                                                     {20, 1, 1.96}, ...
                                                     {'double', 'double', 'double'}, varargin);
    
    L = length(y);
    idxs = (1+maxlags:L)';
    Y = y(repmat(idxs, 1, maxlags+1) - repmat(0:maxlags, L-maxlags, 1));
    C = correlation(Y);
    acorr = C(:,1);
    
    if nargout == 0
        k = 0:maxlags;
        conf = confLevel/sqrt(L-maxlags);
        stem(k, acorr, 'color', [0 0 0], 'markerfacecolor', [0 0 0], 'markersize', 4);
        if drawConfidence
            line([.5 maxlags], [conf conf], 'color', [0 0 0], 'linestyle', '--');
            line([.5 maxlags], [-conf -conf], 'color', [0 0 0], 'linestyle', '--');
        end
        title('Correlogram');
        xlabel('k');
        ylabel('\rho_k');
        grid;
    else
        varargout = {acorr};
    end


end

