function compare( varargin )

    N = nargin;
    
    titleStr = 'Mean cost history comparison';
    varName = 'MeanCostHistory';
    
    args = varargin;
    
    i = 1;
    while i <= N
        switch class(args{i})
            case 'char'
                switch args{i}
                    case 'best'
                        titleStr = 'Best cost history comparison';
                        varName = 'BestCostHistory';
                    case 'worst'
                        titleStr = 'Worst cost history comparison';
                        varName = 'WorstCostHistory';
                end
                args(i) = [];
                N = N-1;
            case 'statistics'
                i = i + 1;
            otherwise
                args(i) = [];
                N = N-1;
        end
    end
    
    L = zeros(1,N);
    costHistory = cell(1,N);
    Name = cell(1,N);
    
    for i=1:N
        costHistory{i} = get(args{i},varName);
        L(i) = length(costHistory{i});
        Name{i} = args{i}.Solver;
    end
    
    figure,
    
    hold on;
    colors{1} = 'b';
    colors{2} = 'r';
    colors{3} = 'k';
    colors{4} = 'g';
    
    for i=1:N
        plot(1:L(i),costHistory{i},colors{i},'DisplayName',Name{i});
    end
    legend('toggle');
    xlabel('Iter/Gen');
    ylabel('Cost');
    title(titleStr);
end

