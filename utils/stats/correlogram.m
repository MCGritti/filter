function varargout = correlogram( y, varargin )

    [maxlags, drawConfidence, confLevel] = argparser({'maxlags', 'drawConfidence', 'confLevel'}, ...
                                                     {20, 1, 1.96}, ...
                                                     {'double', 'double', 'double'}, varargin);
    if nargout == 0
        subplot(211);
        acf(y, 'maxlags', maxlags, 'drawConf', drawConfidence, 'confLevel', confLevel);
        subplot(212);
        pacf(y, 'maxlags', maxlags, 'drawConf', drawConfidence, 'confLevel', confLevel);
    else
        varargout{1} = acf(y, 'maxlags', maxlags, 'drawConf', drawConfidence, 'confLevel', confLevel);
        varargout{2} = pacf(y, 'maxlags', maxlags, 'drawConf', drawConfidence, 'confLevel', confLevel);
    end

end

